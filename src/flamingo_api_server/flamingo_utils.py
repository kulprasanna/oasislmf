# (c) 2013-2016 Oasis LMF Ltd.

# Python 2 standard library imports
import csv
import gzip
import json
import logging
import os
import re
import shutil
import subprocess
import sys
import time
import urllib2

# Python 2 3rd party imports
import jsonpickle

# Oasis imports
from oasisapi_client import OasisAPIClient
import flamingo_db_utils
import ara_flamingo_utils

from oasis_utils import (
    oasis_log_utils,
    oasis_db_utils,
    oasis_utils,
)

ENVIRONMENT = ""
FILES_DIRECTORY = ""
OASIS_FILES_DIRECTORY = ""
# File handling needs to be different if the host
# filesystem is Windows e.g. Symlinking doesn't work.
IS_WINDOWS_HOST = False

def _check_file(filename):
    """
    Raise an exception if the specified file doe not exists
    """
    if not os.path.exists(filename):
        raise Exception("File does not exist: {}".format(filename))
        return False
    else:
        return True

def _do_transform(
    progid, sourcefilename, validationfilelocname, transformationfilename, 
    destinationfilepath, destinationfilename, do_sequence):
    '''
    Transform source to canonical.
    '''

    _check_file(sourcefilename)
    _check_file(validationfilelocname)
    _check_file(transformationfilename)

    destinationfilename = os.path.join(destinationfilepath, destinationfilename)

    cmd = "mono /var/www/oasis/xtrans/xtrans.exe " \
            " -d " + str(validationfilelocname) + \
            " -c " + str(sourcefilename) + \
            " -t " + str(transformationfilename) + \
            " -o " + str(destinationfilename)

    if do_sequence:
        cmd = cmd + " -s"

    logging.getLogger().info("Executing command: {}" .format(cmd))
    os.system(cmd)
    if _check_file(destinationfilename) is False:
        return False
    else:
        return True


@oasis_log_utils.oasis_log()
def transform_source_to_canonical(
    progid, sourcefilename, validationfilelocname, transformationfilename, 
    destinationfilepath, destinationfilename):
    '''
    Transform source to canonical.
    '''
    do_sequence = True
    trasform_status = _do_transform(
        progid, sourcefilename, validationfilelocname, transformationfilename, 
    destinationfilepath, destinationfilename, do_sequence)
    if trasform_status is False:
        flamingo_db_utils.update_prog_status(progid, "Failed")



@oasis_log_utils.oasis_log()
def transform_canonical_to_model(
    progoasisid, sourcefilename, validationfilelocname, transformationfilename,
    destinationfilepath, destinationfilename):
    '''
    Transform canonical to model.
    '''
    do_sequence = False
    trasform_status = _do_transform(
        progoasisid, sourcefilename, validationfilelocname, transformationfilename,
    destinationfilepath, destinationfilename, do_sequence)
    if trasform_status is False:
        flamingo_db_utils.update_progoasis_status(progoasisid, "Failed")

@oasis_log_utils.oasis_log()
def do_load_programme_data(progid):
    '''
    Load programme data. This populates the canonical model
    from the exposure files.
    '''
    try:
        row = flamingo_db_utils.get_transform_file_names_prog(progid)
        ts = oasis_utils.get_timestamp()
        dest_file_path = str(FILES_DIRECTORY) + "/Exposures/"
        canonicallocfilename = "CanLocProg" + str(progid) + "_" + str(ts) + ".csv"
        transform_source_to_canonical(
            progid, row[0], row[1], row[2],
            dest_file_path, canonicallocfilename)
        ts = oasis_utils.get_timestamp()
        canonicalaccfilename = "CanAccProg" + str(progid) + "_" + str(ts) + ".csv"
        transform_source_to_canonical(
            progid, row[3], row[4], row[5],
            dest_file_path, canonicalaccfilename)
        flamingo_db_utils.generate_output_transform_file_records_for_prog(
            progid, canonicallocfilename, canonicalaccfilename)

        rows = flamingo_db_utils.get_profile_details(progid)
        schema_filepath = FILES_DIRECTORY +  "/Exposures/Schema.ini"
        with open(schema_filepath, "w") as schema_file:
            for line in rows:
                line = re.sub(",", "\t", str(line))
                logging.getLogger().debug(re.sub("[()']", "", str(line)))
                schema_file.write(re.sub("[()']", "", str(line)) + "\n")

        flamingo_db_utils.generate_canonical_model(progid)
    except:
        logging.getLogger().exception("Error in do_load_programme_data")
        flamingo_db_utils.update_prog_status(progid, "Failed")


@oasis_log_utils.oasis_log()
def do_load_programme_model(progoasisid):
    '''
    Load programme model.
    '''
    try:
        row = flamingo_db_utils.get_transform_file_names_progoasis(progoasisid)
        extension = flamingo_db_utils.get_model_file_extension(progoasisid)
        ts = oasis_utils.get_timestamp()
        dest_file_path = str(FILES_DIRECTORY) + "/APIInput/"
        destinationfile = "ModelLocProgOasis" + str(progoasisid) + "_" + str(ts) + "." + str(extension[0])
        transform_canonical_to_model(
            progoasisid, row[0], row[1], row[2], dest_file_path, destinationfile)

        flamingo_db_utils.generate_output_transform_file_records_for_progoasis(progoasisid, destinationfile)

        do_call_keys_service(progoasisid)
        do_generate_oasis_files(progoasisid)

    except:
        logging.getLogger().exception("Error in do_load_programme_model")
        flamingo_db_utils.update_progoasis_status(progoasisid, "Failed")


@oasis_log_utils.oasis_log()
def do_run_prog_oasis(processrunid):
    '''
    Run a programme model combination.
    '''

    element_run_ids = list()
    element_run_id = -1

    flamingo_db_utils.update_process_run_status(
        processrunid, "In Progress")

    try:
        base_url = flamingo_db_utils.get_base_url(processrunid)
        element_run_ids = \
            flamingo_db_utils.get_element_run_ids(processrunid)

        upload_directory = generate_summary_files(processrunid)
        logging.getLogger().debug(
            "Upload_directory: {}".format(upload_directory))

        analysis_settings_json = get_analysis_settings_json(processrunid)
        logging.getLogger().debug(analysis_settings_json)

        analysis_poll_interval_in_seconds = 5
        client = OasisAPIClient(base_url, logging.getLogger())

        element_run_id = element_run_ids[0][0]
        input_location = client.upload_inputs_from_directory(
            upload_directory, do_validation=False, do_clean=(not IS_WINDOWS_HOST))
        logging.getLogger().info(
            "Input location: {}".format(input_location))

        flamingo_db_utils.log_element_run_to_db(
            element_run_id, "Success", "Exposure files location: {}".format(input_location))

        element_run_id = element_run_ids[1][0]
        analysis_status_location = client.run_analysis(
            analysis_settings_json, input_location, do_clean=False)

        flamingo_db_utils.log_element_run_to_db(
            element_run_id, "Success", "Started analysis")

        element_run_id = element_run_ids[2][0]
        outputs_location = ""
        while True:
            logging.getLogger().debug(
                "Polling analysis status for: {}".format(analysis_status_location))
            (status, message, outputs_location) = \
                client.get_analysis_status(analysis_status_location)
            flamingo_db_utils.log_element_run_to_db(element_run_id, status, "In Progress")

            if status == oasis_utils.STATUS_SUCCESS:
                if outputs_location is None:
                    raise Exception("Complete but no outputs location")
                flamingo_db_utils.log_element_run_to_db(
                    element_run_id, status, "Analysis Completed")
                break
            elif status == oasis_utils.STATUS_FAILURE:
                error_message = "Analysis failed: {}".format(message)
                logging.getLogger().error(error_message)
                raise Exception(error_message)
            time.sleep(analysis_poll_interval_in_seconds)

        element_run_id = element_run_ids[3][0]
        client.get_output_files(
            outputs_location, upload_directory, input_location)
        flamingo_db_utils.log_element_run_to_db(
            element_run_id, 'Success', 'Downloaded output files successfully')

        extract_tarball(
            os.path.join(upload_directory, outputs_location + ".tar.gz"),
            upload_directory)

        output_file_list = ','.join(map(str, os.listdir(os.path.join(upload_directory, "output"))))
        logging.getLogger().debug("Output_file_list: {}".format(output_file_list))
        oasis_db_utils.execute(
            "exec dbo.linkOutputFileToProcessRun @ProcessRunId = ?, @OutputFiles = ?",
            processrunid, output_file_list)
        flamingo_db_utils.update_process_run_status(processrunid, 'Completed')

    except Exception as e:
        flamingo_db_utils.update_process_run_status(processrunid, "Failed")
        if element_run_id != -1:
            flamingo_db_utils.log_element_run_to_db(element_run_id, 'Failed: ', str(e))
        logging.getLogger().exception(
            "Failed to run prog oasis: {}".format(processrunid))


@oasis_log_utils.oasis_log()
def generate_summary_files(processrunid):

    flamingo_db_utils.generate_oasis_files_outputs(processrunid)
    prog_oasis_location = \
        flamingo_db_utils.get_prog_oasis_location(processrunid)

    ts = oasis_utils.get_timestamp()
    process_dir = "ProcessRun_" + str(processrunid) + "_" + ts
    input_location = str(prog_oasis_location) + "/" + str(process_dir)
    if not os.path.isdir(input_location):
        os.mkdir(input_location)


    for i in ("items", "coverages", "fm_programme", "fm_policytc", "fm_xref", "fm_profile"):
        source_file = "{}/{}.csv".format(prog_oasis_location, i)
        target_file = "{}/{}.csv".format(input_location, i)
        if not IS_WINDOWS_HOST:
            os.symlink(source_file, target_file)
        else:
            shutil.copy(source_file, target_file)

    oasis_db_utils.bcp("OasisGULSUMMARYXREF", input_location+ "/gulsummaryxref_temp.csv")
    oasis_db_utils.bcp("OasisFMSUMMARYXREF", input_location + "/fmsummaryxref_temp.csv")

    gulsummaryxref = input_location + "/gulsummaryxref.csv"
    destination = open(gulsummaryxref, 'wb')
    shutil.copyfileobj(
        open(OASIS_FILES_DIRECTORY + "/gulsummaryxrefHeader.csv", 'rb'), 
        destination)
    shutil.copyfileobj(
        open(input_location + "/gulsummaryxref_temp.csv", 'rb'), 
        destination)
    destination.close()
    os.remove(input_location + "/gulsummaryxref_temp.csv")

    fmsummaryxref = input_location + "/fmsummaryxref.csv"
    destination = open(fmsummaryxref, 'wb')
    shutil.copyfileobj(
        open(OASIS_FILES_DIRECTORY + "/fmsummaryxrefHeader.csv", 'rb'), 
        destination)
    shutil.copyfileobj(
        open(input_location + "/fmsummaryxref_temp.csv", 'rb'), 
        destination)
    destination.close()
    os.remove(input_location + "/fmsummaryxref_temp.csv")

    process_run_locationid = flamingo_db_utils.get_process_run_locationid(
        prog_oasis_location, process_dir, processrunid)

    flamingo_db_utils.generate_oasis_files_records_outputs(
        processrunid, process_run_locationid)

    return input_location


@oasis_log_utils.oasis_log()
def get_analysis_settings_json(processrunid):

    general_settings_data = \
        flamingo_db_utils.get_general_settings(processrunid)
    model_settings_data = \
        flamingo_db_utils.get_model_settings(processrunid)
    gul_summaries_data = \
        flamingo_db_utils.get_gul_summaries(processrunid)
    il_summaries_data = \
        flamingo_db_utils.get_il_summaries(processrunid)

    analysis_settings = dict()
    general_settings = dict()

    for row in general_settings_data:
        if row[2] == 'bool':
            general_settings[row[0]] = eval("{}({})".format(row[2], row[1]))
        else:
            general_settings[row[0]] = eval("{}('{}')".format(row[2], row[1]))

    model_settings = dict()
    logging.getLogger().debug("Model settings:")
    for row in model_settings_data:
        logging.getLogger().debug("row: %r" % row)
        if row[2] == 'bool':
            model_settings[row[0]] = eval("{}({})".format(row[2], row[1]))
        else:
            model_settings[row[0]] = eval("{}('{}')".format(row[2], row[1]))

    gul_summaries_dict = dict()
    for row in gul_summaries_data:
        id = int(row[0])
        if not gul_summaries_dict.has_key(id):
            gul_summaries_dict[id] = dict()
        if row[3] == 1:
            if not gul_summaries_dict[id].has_key('leccalc'):
                gul_summaries_dict[id]['leccalc'] = dict()
                gul_summaries_dict[id]['leccalc']['outputs'] = dict()
            if row[1] == 'return_period_file':
                gul_summaries_dict[id]['leccalc'][row[1]] = bool(row[2])
            else:
                gul_summaries_dict[id]['leccalc']['outputs'][row[1]] = bool(row[2])
        else:
            gul_summaries_dict[id][row[1]] = bool(row[2])

    gul_summaries = list()
    for id in gul_summaries_dict.keys():
        gul_summaries_dict[id]['id'] = id
        gul_summaries.append(gul_summaries_dict[id])

    il_summaries_dict = dict()
    for row in il_summaries_data:
        id = int(row[0])
        if not il_summaries_dict.has_key(id):
            il_summaries_dict[id] = dict()
        if row[3] == 1:
            if not il_summaries_dict[id].has_key('leccalc'):
                il_summaries_dict[id]['leccalc'] = dict()
                il_summaries_dict[id]['leccalc']['outputs'] = dict()
            if row[1] == 'return_period_file':
                il_summaries_dict[id]['leccalc'][row[1]] = bool(row[2])
            else:
                il_summaries_dict[id]['leccalc']['outputs'][row[1]] = bool(row[2])
        else:
            il_summaries_dict[id][row[1]] = bool(row[2])

    il_summaries = list()
    for id in il_summaries_dict.keys():
        il_summaries_dict[id]['id'] = id
        il_summaries.append(il_summaries_dict[id])

    general_settings['model_settings'] = model_settings
    general_settings['gul_summaries'] = gul_summaries
    general_settings['il_summaries'] = il_summaries
    analysis_settings['analysis_settings'] = general_settings
    apijson = jsonpickle.encode(analysis_settings)
    return json.loads(apijson)


@oasis_log_utils.oasis_log()
def extract_tarball(tar_file, output_dir):
    unzip_command = "tar xf {} -C {}".format(tar_file, output_dir)
    unzip_result = subprocess.call(unzip_command, shell=True)
    if int(unzip_result) != 0:
        logging.getLogger().debug(
            "unzip command: {}".format(unzip_command))
        raise Exception("Failed to extract tarball")


@oasis_log_utils.oasis_log()
def process_keys_response(progoasisid, modelid, apiJSON):
    all_location_count = 0
    success_location_count = 0
    nomatch_location_count = 0
    fail_location_count = 0
    ts = oasis_utils.get_timestamp()
    mapped_exposure_file = FILES_DIRECTORY + "/APIOutput/ExposureKeys_" + str(ts) + ".csv"
    logging.getLogger().info("Writing mapped exposure to {}".format(mapped_exposure_file))
    error_file = FILES_DIRECTORY + "/APIOutput/ExposureKeysError_" + str(ts) + ".csv"
    logging.getLogger().info("Writing non-mapped and failed exposure to {}".format(error_file))
    error_file = FILES_DIRECTORY + "/APIOutput/ExposureKeysError_" + str(ts) + ".csv"
    with open(mapped_exposure_file, "w") as out_file, open(error_file, "w") as error_file:

        out_writer = csv.writer(out_file)
        error_writer = csv.writer(error_file)

        out_writer.writerow(["LocID", "PerilID", "CoverageID", "AreaPerilID", "VulnerabilityID"])
        error_writer.writerow(["LocID", "PerilID", "CoverageID", "Message"])
        for location in apiJSON:
            all_location_count = all_location_count + 1
            if location['status'] == 'success':
                success_location_count = success_location_count + 1
                out_writer.writerow(
                    [location['id'], location['peril_id'], location["coverage"], location['area_peril_id'], location['vulnerability_id']])

            elif location['status'] == 'nomatch':
                nomatch_location_count = nomatch_location_count + 1
                error_writer.writerow([location['id'], location['peril_id'], location["coverage"], location['message']])

            elif location['status'] == 'fail':
                fail_location_count = fail_location_count + 1
                error_writer.writerow([location['id'], location['peril_id'], location["coverage"], location['message']])

    logging.getLogger().info('{:,} locations'.format(all_location_count))
    logging.getLogger().info('{0:.2f}% success'.format(100.0 * success_location_count/all_location_count))
    logging.getLogger().info('{0:.2f}% fail'.format(100.0 * fail_location_count/all_location_count))
    logging.getLogger().info('{0:.2f}% no match'.format(100.0 * nomatch_location_count/all_location_count))

    flamingo_db_utils.get_api1a_return_data(
        progoasisid, "ExposureKeys_" + str(ts) + ".csv")

    flamingo_db_utils.create_api_error_file_record(
        "ExposureKeysError_" + str(ts) + ".csv", progoasisid)


@oasis_log_utils.oasis_log()
def do_call_keys_service(progoasisid):

    (progid, modelid, fileid) = \
        flamingo_db_utils.get_prog_oasis_details(progoasisid)

    (targetURI, systemname) = \
        flamingo_db_utils.get_api_uri_and_systemname(modelid)
    logging.getLogger().debug(
        "Target URI: {}, System name: {}".format(
            targetURI, systemname))

    filename = flamingo_db_utils.get_filename(fileid)
    logging.getLogger().debug("Filename = {}".format(filename))

    if systemname == "ARA API":
        ara_flamingo_utils.call_ara_api(
            progoasisid, progid, modelid, targetURI, FILES_DIRECTORY, filename)
    else:
        locations = list()

        reload(sys)
        sys.setdefaultencoding('UTF8')
        logging.getLogger().info("Encoding mode: %r" % sys.getdefaultencoding())
        logging.getLogger().info("Reading exposures from {}".format(filename))

        with open(filename, 'r') as exposure_file:
            csv_data = exposure_file.read()
        csv_data_bytes = csv_data.encode()

        req = urllib2.Request(targetURI)
        req.add_header('Content-Type', 'text/csv; charset=utf-8')
        req.add_header('Content-Length', len(csv_data_bytes))
        response = urllib2.urlopen(req, data=csv_data_bytes)
        locations = json.loads(gzip.zlib.decompress(response.read()).decode('utf-8'))['items']
        process_keys_response(progoasisid, modelid, locations)

    return {'In': 'Yes'}


@oasis_log_utils.oasis_log()
def do_generate_oasis_files(progoasisid):

    location_id = -1

    status = flamingo_db_utils.generate_oasis_files(progoasisid)

    if status != "Done":
        raise Exception("Failed to generate Oasis files")

    progoasis_dir = "ProgOasis_" + progoasisid
    input_location = OASIS_FILES_DIRECTORY + "/" + progoasis_dir
    if not os.path.isdir(input_location):
        os.mkdir(input_location)

    location_id = flamingo_db_utils.generate_location_record(
        OASIS_FILES_DIRECTORY, progoasis_dir, "ProgOasis_" + progoasisid)[0]

    logging.getLogger().info("location_id: {}".format(location_id))
    if location_id == -1:
        raise Exception("Failed to generate location record")

    items = input_location + "/items.csv"
    coverages = input_location + "/coverages.csv"
    fm_programme = input_location + "/fm_programme.csv"
    fm_policytc = input_location + "/fm_policytc.csv"
    fm_xref = input_location + "/fm_xref.csv"
    fm_profile = input_location + "/fm_profile.csv"
    itemdict = input_location + "/ItemDict.csv"
    fmdict = input_location + "/FMDict.csv"

    oasis_db_utils.bcp("OasisCOVERAGES", OASIS_FILES_DIRECTORY + "/Coverages_temp.csv")
    oasis_db_utils.bcp("OasisITEMS", OASIS_FILES_DIRECTORY + "/Items_temp.csv")
    oasis_db_utils.bcp("OasisFM_PROGRAMME", OASIS_FILES_DIRECTORY + "/FMProgramme_temp.csv")
    oasis_db_utils.bcp("OasisFM_POLICYTC", OASIS_FILES_DIRECTORY + "/FMPolicyTC_temp.csv")
    oasis_db_utils.bcp("OasisFM_PROFILE", OASIS_FILES_DIRECTORY + "/FMProfile_temp.csv")
    oasis_db_utils.bcp("OasisFM_XREF", OASIS_FILES_DIRECTORY + "/FMXRef_temp.csv")
    oasis_db_utils.bcp("OasisITEMDICT", OASIS_FILES_DIRECTORY + "/ItemDict_temp.csv")
    oasis_db_utils.bcp("OasisFMDICT", OASIS_FILES_DIRECTORY + "/FMDict_temp.csv")

    destination = open(coverages, 'wb')
    shutil.copyfileobj(open(OASIS_FILES_DIRECTORY + "/CoveragesHeader.csv", 'rb'), destination)
    shutil.copyfileobj(open(OASIS_FILES_DIRECTORY + "/Coverages_temp.csv", 'rb'), destination)
    destination.close()
    os.remove(OASIS_FILES_DIRECTORY + "/Coverages_temp.csv")

    destination = open(items, 'wb')
    shutil.copyfileobj(open(OASIS_FILES_DIRECTORY + "/ItemsHeader.csv", 'rb'), destination)
    shutil.copyfileobj(open(OASIS_FILES_DIRECTORY + "/Items_temp.csv", 'rb'), destination)
    destination.close()
    os.remove(OASIS_FILES_DIRECTORY + "/Items_temp.csv")

    destination = open(fm_programme, 'wb')
    shutil.copyfileobj(open(OASIS_FILES_DIRECTORY + "/FMProgrammeHeader.csv", 'rb'), destination)
    shutil.copyfileobj(open(OASIS_FILES_DIRECTORY + "/FMProgramme_temp.csv", 'rb'), destination)
    destination.close()
    os.remove(OASIS_FILES_DIRECTORY + "/FMProgramme_temp.csv")

    destination = open(fm_policytc, 'wb')
    shutil.copyfileobj(open(OASIS_FILES_DIRECTORY + "/FMPolicyTCHeader.csv", 'rb'), destination)
    shutil.copyfileobj(open(OASIS_FILES_DIRECTORY + "/FMPolicyTC_temp.csv", 'rb'), destination)
    destination.close()
    os.remove(OASIS_FILES_DIRECTORY + "/FMPolicyTC_temp.csv")

    destination = open(fm_profile, 'wb')
    shutil.copyfileobj(open(OASIS_FILES_DIRECTORY + "/FMProfileHeader.csv", 'rb'), destination)
    shutil.copyfileobj(open(OASIS_FILES_DIRECTORY + "/FMProfile_temp.csv", 'rb'), destination)
    destination.close()
    os.remove(OASIS_FILES_DIRECTORY + "/FMProfile_temp.csv")

    destination = open(fm_xref, 'wb')
    shutil.copyfileobj(open(OASIS_FILES_DIRECTORY + "/FMXRefHeader.csv", 'rb'), destination)
    shutil.copyfileobj(open(OASIS_FILES_DIRECTORY + "/FMXRef_temp.csv", 'rb'), destination)
    destination.close()
    os.remove(OASIS_FILES_DIRECTORY + "/FMXRef_temp.csv")

    destination = open(itemdict, 'wb')
    shutil.copyfileobj(open(OASIS_FILES_DIRECTORY + "/ItemDictHeader.csv", 'rb'), destination)
    shutil.copyfileobj(open(OASIS_FILES_DIRECTORY + "/ItemDict_temp.csv", 'rb'), destination)
    destination.close()
    os.remove(OASIS_FILES_DIRECTORY + "/ItemDict_temp.csv")

    destination = open(fmdict, 'wb')
    shutil.copyfileobj(open(OASIS_FILES_DIRECTORY + "/FMDictHeader.csv", 'rb'), destination)
    shutil.copyfileobj(open(OASIS_FILES_DIRECTORY + "/FMDict_temp.csv", 'rb'), destination)
    destination.close()
    os.remove(OASIS_FILES_DIRECTORY + "/FMDict_temp.csv")

    flamingo_db_utils.generate_oasis_file_records(progoasisid, location_id)
