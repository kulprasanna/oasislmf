# (c) 2013-2016 Oasis LMF Ltd.  Software provided for early adopter evaluation only.
selDataTableOutput <- function (outputId) 
{
  tagList(singleton(tags$head(tags$link(rel = "stylesheet", 
    type = "text/css", href = "shared/datatables/css/DT_bootstrap.css"),
    tags$style(type="text/css", ".rowsSelected td{
               background-color: rgba(112,164,255,0.2) !important}"),
    tags$style(type="text/css", ".selectable div table tbody tr{
               cursor: hand; cursor: pointer;}"),
    tags$style(type="text/css",".selectable div table tbody tr td{
               -webkit-touch-callout: none;
               -webkit-user-select: none;
               -khtml-user-select: none;
               -moz-user-select: none;
               -ms-user-select: none;
               user-select: none;}"),                          
    tags$script(src = "shared/datatables/js/jquery.dataTables.min.js"), 
    tags$script(src = "shared/datatables/js/DT_bootstrap.js"),
    tags$script(src = "js/DTbinding.js"))), 
    div(id = outputId, class = "shiny-datatable-output selectable"))
}






# Button Names
FOBtnShowTable          <<- "FO_btn_show_table"
FOBtnShowRawContent     <<- "FO_btn_show_raw_content"
FOBtnShowMap            <<- "FO_btn_show_map"
FOBtnShowAEPCurve       <<- "FO_btn_show_AEPCurve"
FOBtnShowGeocode        <<- "FO_btn_show_geocode"
FOBtnShowEventFootprint <<- "FO_btn_show_EventFootprint"




FODivTable              <<- "FO_div_table"
FODivFilecontents       <<- "FO_div_filecontents"
FODivPlainMap           <<- "FO_div_plainmap"
FODivAEPcurve           <<- "FO_div_AEPcurve"
FODivGeocode            <<- "FO_div_geocode"
FODivEventFootprint     <<- "FO_div_EventFootprint"


AllFileMgmtButtonIDs <<- list()



noteButtonID <- function(name)
{
    AllFileMgmtButtonIDs <<- c(AllFileMgmtButtonIDs, list(name))
    name
}