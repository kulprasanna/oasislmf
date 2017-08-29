# (c) 2013-2016 Oasis LMF Ltd.
import logging
import json
import readunicedepx as upx
import re
import csv
import os
import datetime
import time
import requests
from oasis_utils import oasis_log_utils, oasis_db_utils, oasis_utils

AUTH = ('howmany', 'TheAnswerMyFriendIsBlowingInTheWind')

@oasis_log_utils.oasis_log()
def call_ara_api(progoasisid, progid, modelid, targetURI, files_directory, filename):

    files = {}
    UPXFile = filename
    files['upxfile'] = open(filename, 'rb')
    # Set storm_surge to try in case it is selected when a
    # subsequent analysis is started.
    body = {
        'number_of_cores': 0,
        'storm_surge': 1,
        'upxfile': UPXFile}
    r = requests.post(
        targetURI, files=files, data=body, verify=False, auth=AUTH)
    if r.status_code != oasis_utils.HTTP_RESPONSE_OK:
        raise Exception(
            "Failed to call ARA API: Response code={}; Message={}".format(
                r.status_code, r._content))
    apiJSON = json.loads(r._content)
    process_ara_response(
        progoasisid, progid, modelid, targetURI,
        UPXFile, apiJSON, files_directory)


def get_tivs(UPX_file):
    tiv = dict()
    with open(UPX_file, "r") as upx_file:
        line = upx_file.readline()
        iversionList = upx.GetUpxRecordType(line)
        iversion = iversionList[0]
        for line in upx_file:
            (retval,polid,locid,AreaScheme,StateFIPS,CountyFIPS,ZIP5,GeoLat,GeoLong,\
            RiskCount,RepValBldg,RepValOStr,RepValCont,RepValTime,RVDaysCovered,ConType,\
            ConBldg,ConOStr,OccType,Occ,YearBuilt,Stories,GrossArea,PerilCount,Peril,LimitType,\
            Limits,Participation,DedType,Deds,territory,SubArea,ReinsCount,ReinsOrder,\
            ReinsType,ReinsCID,ReinsField1,ReinsField2,ReinsField3,ReinsField4)	= upx.ParseLocationRecord(line, iversion)
            polid = polid.strip()
            locid = locid.strip()
            tiv[ (polid, locid, 'Bldg' ) ] = RepValBldg
            tiv[ (polid, locid, 'Ostr' ) ] = RepValOStr
            tiv[ (polid, locid, 'Cont' ) ] = RepValCont
            tiv[ (polid, locid, 'Time' ) ] = RepValTime
    return tiv

def get_api1a_return_data(progoasis_id, ts, session_id):
    oasis_db_utils.execute(
        "exec getAPI1aReturnData ?, ?, ?",
        progoasis_id, "ExposureKeys_" + str(ts) + ".csv", session_id)


def create_api_error_file_record(progoasis_id, ts, session_id):
    oasis_db_utils.execute(
        "exec createAPIErrorFileRecord ?, ?",
        "ExposureKeysError_" + str(ts) + ".csv", progoasis_id)


def get_api1b_return_data(prog_id, model_id, session_id, status):
    oasis_db_utils.execute(
        "exec getAPI1bReturnData ?, ?, ?, ?",
        prog_id, model_id, session_id, status)


def write_exposure_file(temp_exposure_filepath, api1a_json):
    
    if api1a_json['Locations'] is None:
        return

    with open(temp_exposure_filepath, "w") as exposure_file:
        exposure_file.write("ItemID, LocID, AreaPerilID, PerilId, CoverageId, VulnerabilityID\n")
        itemID = 1
        for locs in api1a_json['Locations']:
            for av in locs['AVs']:
                for covs in av['CoverageAndVulnerabilities']:
                    if av["PerilID"] == "W":
                        exposure_file.write("{0},{1},{2},{3},{4},{5}\n".format(
                            itemID, locs['LocID'], av['AreaPerilID'], av["PerilID"], 1, covs['VulnerabilityID']))
                        exposure_file.write("{0},{1},{2},{3},{4},{5}\n".format(
                            itemID+1, locs['LocID'], av['AreaPerilID'], av["PerilID"], 2, covs['VulnerabilityID']))
                        exposure_file.write("{0},{1},{2},{3},{4},{5}\n".format(
                            itemID+2, locs['LocID'], av['AreaPerilID'], av["PerilID"], 3, covs['VulnerabilityID']))
                        exposure_file.write("{0},{1},{2},{3},{4},{5}\n".format(
                            itemID+3, locs['LocID'], av['AreaPerilID'], av["PerilID"], 4, covs['VulnerabilityID']))
                    if av["PerilID"] == "S":
                        exposure_file.write("{0},{1},{2},{3},{4},{5}\n".format(
                            itemID+4, locs['LocID'], av['AreaPerilID'], av["PerilID"], 1, covs['VulnerabilityID']))
                        exposure_file.write("{0},{1},{2},{3},{4},{5}\n".format(
                            itemID+5, locs['LocID'], av['AreaPerilID'], av["PerilID"], 2, covs['VulnerabilityID']))
                        exposure_file.write("{0},{1},{2},{3},{4},{5}\n".format(
                            itemID+6, locs['LocID'], av['AreaPerilID'], av["PerilID"], 3, covs['VulnerabilityID']))
                        exposure_file.write("{0},{1},{2},{3},{4},{5}\n".format(
                            itemID+7, locs['LocID'], av['AreaPerilID'], av["PerilID"], 4, covs['VulnerabilityID']))
            itemID += 8


@oasis_log_utils.oasis_log()
def process_ara_response(
    progoasis_id, prog_id, model_id, target_URI, 
    UPX_file, json_response, files_directory):

    api1a_json = json_response
    session_id = api1a_json['SessionID']
    ts = datetime.datetime.now().strftime('%Y%m%d_%H%M%S')
    logging.getLogger().info("Tiemstamp: %r" % ts)

    exposure_filepath = files_directory + "/APIOutput/ExposureKeys_" + str(ts) + ".csv"
    temp_exposure_filepath = exposure_filepath + ".tmp"

    error_filepath = files_directory + "/APIOutput/ExposureKeysError_" + str(ts) + ".csv"
    temp_error_filepath = error_filepath + ".tmp"

    write_exposure_file(temp_exposure_filepath, json_response)

    # call API1b to check the status of API1a
    api_1b_url = re.sub('api1a', 'api1b', target_URI)
    api_1b_url = api_1b_url + "/" + str(session_id)
    api_poll_flag = True
    api_fail_count = 0
    api_retries = 3
    while api_poll_flag:
        r = requests.get(api_1b_url, verify=False, auth=AUTH)
        if r.status_code != oasis_utils.HTTP_RESPONSE_OK:
            api_fail_count = api_fail_count + 1
            if api_fail_count >= api_retries:
                raise Exception(
                    "Failed to call ARA API: Response code={}; Message={}".format(
                    r.status_code, r._content))                

        if r.status_code == oasis_utils.HTTP_RESPONSE_OK:
            api1bJSON = json.loads(r._content)
            logging.getLogger().info("api1bJSON %r" % api1bJSON)
            if api1bJSON["Status"] == "Running":
                logging.getLogger().info("Still running")
                api_poll_flag = True
                time.sleep(5)
            else:
                api_poll_flag = False
                with open(temp_error_filepath, "w") as OutError:
                    OutError.write("PerilId, VulnerabilityID\n")
                    if api1bJSON['Errors'] is not None:
                        for error in api1bJSON['Errors']:
                            logging.getLogger().info(error)
                            if re.search('wind', error['DESCR'], re.IGNORECASE):
                                EPerilID = "W"
                            elif re.search('surge', error['DESCR'], re.IGNORECASE):
                                EPerilID = "S"
                            for vid in error['VIDs']:
                                OutError.write("{0},{1}\n".format(EPerilID, vid))
            
            get_api1b_return_data(
                prog_id, model_id, session_id, api1bJSON["Status"])

    # Create a lookup table of the error vulnerabilities
    error_vulnerabilities_by_peril = dict()
    error_vulnerabilities_by_peril['S'] = set()
    error_vulnerabilities_by_peril['W'] = set()

    # Read the temp error file
    with open(temp_error_filepath, "rb") as temp_error_file:
    
        temp_error_reader = csv.reader(temp_error_file)
        # Skip the header
        next(temp_error_reader)
        for peril_id, vulnerability_id in temp_error_reader:
            error_vulnerabilities_by_peril[peril_id].add(vulnerability_id)

    with open(error_filepath, "wb") as error_file, \
         open(exposure_filepath, "wb") as exposure_file, \
         open(temp_exposure_filepath, "rb") as temp_exposure_file:
        error_writer = csv.writer(error_file)
        exposure_writer = csv.writer(exposure_file)
        temp_exposure_reader = csv.reader(temp_exposure_file)

        # Skip header
        next(temp_exposure_file)

        # Write headers
        exposure_writer.writerow(["ItemID", "LocID", "AreaPerilID", "PerilId", "CoverageId", "VulnerabilityID"])
        error_writer.writerow(["ItemID", "LocID", "PerilID", "CoverageID"])

        # Write the items into the exposure file or error file as appropriate
        for row in temp_exposure_reader:
            (item_id, loc_id, area_peril_id, peril_id, coverage_id, vulnerability_id) = row
            if vulnerability_id not in error_vulnerabilities_by_peril[peril_id]:
                exposure_writer.writerow(
                    [item_id, loc_id, area_peril_id, peril_id, coverage_id, vulnerability_id])
            else:
                error_writer.writerow(
                    [item_id, loc_id, peril_id, coverage_id])

    # Clean up the temp files
    os.remove(temp_exposure_filepath)
    os.remove(temp_error_filepath)

    get_api1a_return_data(progoasis_id, ts, session_id)
    create_api_error_file_record(progoasis_id, ts, session_id)

