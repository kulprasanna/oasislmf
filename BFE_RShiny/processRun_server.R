# (c) 2013-2016 Oasis LMF Ltd.  Software provided for early adopter evaluation only.
abuttonrunpr_counter <- 0
abuttonexecuteprrun_counter <- 0
abuttonrefreshprrun_counter <- 0
abuttonrefreshprrunlogs_counter <- 0
abuttoncancelrun_counter <- 0
prcrundata <- 0
fileslistdata <- 0
filedata <- 0
#filenameexport <- 0
prrunid <- -1


# shinyjs::show("SessionID")
# shinyjs::show("ReconciliationMode")
shinyjs::show("perilwind")
shinyjs::show("perilsurge")
shinyjs::show("perilquake")
shinyjs::show("perilflood")
shinyjs::show("demandsurge")
shinyjs::show("leakagefactor")

shinyjs::disable("chkgulpolicy")

shinyjs::disable(selector = "#chkgulcounty input[value='gulcountyFullUncAEP']")
shinyjs::disable(selector = "#chkgulcounty input[value='gulcountyFullUncOEP']")
shinyjs::disable(selector = "#chkgulcounty input[value='gulcountyAEPWheatsheaf']")
shinyjs::disable(selector = "#chkgulcounty input[value='gulcountyOEPWheatsheaf']")

shinyjs::disable(selector = "#chkgulloc input[value='gullocFullUncAEP']")
shinyjs::disable(selector = "#chkgulloc input[value='gullocFullUncOEP']")
shinyjs::disable(selector = "#chkgulloc input[value='gullocAEPWheatsheaf']")
shinyjs::disable(selector = "#chkgulloc input[value='gullocOEPWheatsheaf']")

shinyjs::disable(selector = "#chkilcounty input[value='ilcountyFullUncAEP']")
shinyjs::disable(selector = "#chkilcounty input[value='ilcountyFullUncOEP']")
shinyjs::disable(selector = "#chkilcounty input[value='ilcountyAEPWheatsheaf']")
shinyjs::disable(selector = "#chkilcounty input[value='ilcountyOEPWheatsheaf']")

shinyjs::disable(selector = "#chkilloc input[value='illocFullUncAEP']")
shinyjs::disable(selector = "#chkilloc input[value='illocFullUncOEP']")
shinyjs::disable(selector = "#chkilloc input[value='illocAEPWheatsheaf']")
shinyjs::disable(selector = "#chkilloc input[value='illocOEPWheatsheaf']")




#shinyjs::disable("chkgulcounty")


############## UI helper functions ################
disableRunProcessButton <- function()
{
  loginfo("In disable RunProcess button", logger="flamingo.module")
  shinyjs::disable("abuttonrunpr")
}


enableProcessRunButton <- function()
{
  loginfo("In enable RunProcess button", logger="flamingo.module")
  shinyjs::enable("abuttonrunpr")
}



DebugPrint <- function(msg)
{
  print(msg)
}


###############################################  Process Run functions  #################################################
#Funtion to get Process Data
getprocessdata <- function(pruser, prmodel, prprogramme, prworkflow) {
  res <- NULL
  query <- NULL
  query <- paste0("exec dbo.getProcessData ", pruser, ", ", prmodel, ", ", prprogramme, ", ", prworkflow)
  #print(query)
  res <- execute_query(query)
  return(res)
}

#Funtion to get User details
getprusers <- function() {
  res <- NULL
  res <- execute_query(paste0("select BFEUserName, BFEUserID from dbo.BFEUser"))
  #print(paste("function for prusers:", res))
  rows <- nrow(res)
  if (rows > 0) {
    s_options2 <- list()
    s_options2[[print("All")]] <- print("0")
    for (i in 1:rows){
      s_options2[[paste(sprintf("%s", res[i, 1]))]] <- paste0(sprintf("%s", res[i, 2]))
    }
    #print(s_options2)
    return(s_options2)
  }
  return(res)
}

#Function containing table settings/elements from pr tab
getprtable <- function(){
  options = list(rowCallback = JS('function(nRow, aData, iDisplayIndex, iDisplayIndexFull) {
                                  //$("table").css("width", "1400px");
                                  //$("th").css("background-color", "#F5A9BC");
                                  $("th").css("text-align", "center");
                                  $("td", nRow).css("font-size", "12px");
                                  $("td", nRow).css("text-align", "center");
}'),
    search = list(caseInsensitive = TRUE), 
    processing=0,
    pageLength = 10,
    autoWidth=TRUE,
    columnDefs = list(list(visible = FALSE, targets = 0)))
  
  return(options)
  }


#A funtion to get Oasis System Details
getOasisSystems <- function(procid) {
  res <- NULL
  res <- execute_query(paste0("exec dbo.getOasisSystems '", procid, "'"))
  print(paste("Result of dbo.getOasisSystems:", res))
  rows <- nrow(res)
  if (rows > 0) {
    s_options2 <- list()
    #s_options2[[print("All")]] <- print("0")
    for (i in 1:rows){
      s_options2[[paste(sprintf("%s", res[i, 1]))]] <- paste0(sprintf("%s", res[i, 2]))
    }
    print(s_options2)
    return(s_options2)
  }
  return(res)
}


#A function to get process runs
getprocessrun <- function(procid, prstatus) {
  res <- NULL
  print(paste("procid: ", procid))
  res <- execute_query(paste0("exec dbo.ListProcessRun ", procid, ", '", prstatus, "'"))
  return(res)
}

#A function to generate process run
oldgeneraterun <- function(prid, nosample, sthreshold, sessionid, rcmode, demandsurge, perilwind, perilstormsurge, oasissystemid) {
  DebugPrint("entering generaterun")
  pr_runid <- NULL
  query <- paste0("exec dbo.WorkflowFlattener ", prid, ", ", user_id, ", 1, ", oasissystemid, ", ", nosample, ", ", sthreshold, ", ", sessionid, ", '", 
                  substr(rcmode, 1, 1), "', '", substr(demandsurge, 1, 1), "', '", substr(perilwind, 1, 1), "', '", substr(perilstormsurge, 1, 1), "'")
  pr_runid <- execute_query(query)
  print(paste("Process Run ID: ", pr_runid))
  DebugPrint("exiting generaterun")
  return (pr_runid)
}

#A function to generate process run
generaterun <- function() {
  DebugPrint("entering generaterun")
  
  prtable <- getprocessdata(user_id, 0, 0, 0)
  ProgOasisID <- toString(prtable[input$tableprocessdata2_rows_selected, 1])
  
  
  processrunname <- isolate(input$tinputprocessrunname)
  nosample <- isolate(input$tinputnoofsample)
  sthreshold <- isolate(input$tinputthreshold)
  eventsetid <- isolate(input$sinputeventset)
  eventoccid <- isolate(input$sinputeventocc)
  
  windperil <- NULL
  surgeperil <- NULL
  quakeperil <- NULL
  floodperil <- NULL
  dmdsurge <- NULL
  leakagefactor <- NULL
  
  summaryreports <- tolower(isolate(input$chkinputsummaryoption))
  
  #functionality to handle model resource based metrics
  runparamlist <- NULL
  runparamlist <- execute_query(paste0("exec dbo.getRuntimeParamList ", ProgOasisID))
  rows <- nrow(runparamlist)
  #info(runparamlist)
  if (rows > 0) {
    for (i in 1:rows){
      if (runparamlist[i, 1] == 'demand_surge'){
        dmdsurge <- tolower(isolate(input$chkinputdsurge))
        next
      } 
      if (runparamlist[i, 1] == 'peril_wind'){
        windperil <- tolower(isolate(input$chkinputprwind))
        next
      }
      if (runparamlist[i, 1] == 'peril_surge'){
        surgeperil <- tolower(isolate(input$chkinputprstsurge))
        next
      }
      if (runparamlist[i, 1] == 'peril_quake'){
        quakeperil <- tolower(isolate(input$chkinputprquake))
        next
      }
      if (runparamlist[i, 1] == 'peril_flood'){
        floodperil <- tolower(isolate(input$chkinputprflood))
        next
      }
      if (runparamlist[i, 1] == 'leakage_factor'){
        leakagefactor <- isolate(input$sliderleakagefac)
        #info(leakagefactor)
      }
    }
  }
  
  
  OutputsStringGUL <- paste(c(input$chkgulprog, input$chkgulpolicy, input$chkgulstate, input$chkgulcounty, input$chkgulloc, input$chkgullob), collapse = ",")
  #print(OutputsStringGUL)
  
  OutputsStringIL <- paste(c(input$chkilprog, input$chkilpolicy, input$chkilstate, input$chkilcounty, input$chkilloc, input$chkillob),  collapse = ",")
  #print(OutputsStringIL)
  query <- paste0("exec dbo.WorkflowFlattener ", "@ProgOasisID= ", ProgOasisID, ", @WorkflowID= 1, ", "@NumberOfSamples=", nosample, ",@GULThreshold= ", sthreshold, ",@UseRandomNumberFile= 0,",
                  "@OutputsStringGUL= '", OutputsStringGUL, "',@OutputsStringIL= '", OutputsStringIL, "',@EventSetID= '", eventsetid ,"', @EventOccurrenceID= '", eventoccid, 
                  "', @PerilWind = '", windperil ,"', @PerilSurge='", surgeperil, "', @PerilQuake='", quakeperil, "', @PerilFlood='", floodperil,
                  "', @DemandSurge= '", dmdsurge, "' ", ",@LeakageFactor= '" , leakagefactor, "'", ",@ProcessRunName= '" , processrunname, "'", ",@SummaryReports='", summaryreports , "'")
  print(query)
  loginfo(paste("Workflow flattener query: ",query), logger="flamingo.module")
  pr_runid <- execute_query(query)
  print(paste("Process Run ID: ", pr_runid))
  DebugPrint("exiting generaterun")
  return (pr_runid)
}

#Call BFE webservice to execute workflow
runprocess <- function(runid) {
  if ( runid != "" ) {
    url_rp <- NULL
    flag <- 1
    tryCatch({
      #url <- paste("http://10.1.0.181:",port,"/runprocess/", runid, sep="")
      #url <- paste("http://127.0.0.1:",port,"/runprocess/", runid, sep="")
      url <- paste("http://",flamingo_server_ip,":",port,"/runprogoasis/", runid, sep="")  
      #GET(url, as = "text", progress())
      url_rp <- GET(url, as = "text")
      status <- http_status(url_rp)
      flag <- status[[1]]
      warn_for_status(url_rp)
      loginfo(paste("In runprocess trycatch:",status), logger="flamingo.module")
    }, warning = function(war) {
      flag <- status[[1]]
      loginfo(paste("In runprocess Warning: ", war), logger="flamingo.module")
      #return(NULL)
    }, error=function(e) {
      flag <- status[[1]]
      loginfo(paste("In runprocess Error:", e), logger="flamingo.module")
      #return(NA)
    }, finally = {
      loginfo(paste("In runprocess Finally:", url), logger="flamingo.module")
      return(flag)
    }
    )
  }
}

#Function to call BFE terminate job web service to terminate a job
terminateprocess <- function(wkrunid){
  if ( wkrunid != "" ) {
    url_rp <- NULL
    flag <- 1
    tryCatch({
      #    url <- paste("http://10.1.0.181:",port,"/runprocess/", runid, sep="")
      url <- paste("http://",flamingo_server_ip,":",port,"/terminateprocess/", wkrunid, sep="")
      #GET(url, as = "text", progress())
      url_rp <- GET(url, as = "text")
      status <- http_status(url_rp)
      flag <- status[[1]]
      warn_for_status(url_rp)
      loginfo(paste("In terminateprocess trycatch:",status), logger="flamingo.module")
    }, warning = function(war) {
      flag <- status[[1]]
      loginfo(paste("In terminateprocess Warning: ", war), logger="flamingo.module")
      #return(NULL)
    }, error=function(e) {
      flag <- status[[1]]
      loginfo(paste("In terminateprocess Error:", e), logger="flamingo.module")
      #return(NA)
    }, finally = {
      loginfo(paste("In terminateprocess Finally:", url), logger="flamingo.module")
      return(flag)
    }
    )
  }
}

#Get log details for a selected run
getlogs <- function(wfid) {
  res <- NULL
  if ( wfid != 0 ) {
    res <- execute_query(paste("exec dbo.getProcessRunDetails", wfid))
  }
  #loginfo(paste("Inside getlogs wfid, res:", wfid, res), logger="flamingo.module")  
  return(res)
}

## Get list of output files for selected Run ID
getfilelist <- function(prrunid){
  res <- NULL
  if ( prrunid != 0 ) {
    res <- execute_query(paste("exec dbo.getFileViewerTable @ProcessRunID = ", prrunid))
  }
  loginfo(paste("Inside getfilelist for: ", prrunid, res), logger="flamingo.module")
  return(res)  
}


displayoutput <- function(){
  if (length(input$processrundata_rows_selected) > 0) {
    shinyjs::show("prrunoutput")
    shinyjs::hide("abuttondisplayoutput")
    shinyjs::show("abuttonhideoutput")
    updateTabsetPanel(session, "tabsetprrunoutput", selected = "tabprrunfilelist")
    output$outputfileslist <- DT::renderDataTable({
      prrunid <<- (prcrundata[c(input$processrundata_rows_selected), 1][length(prcrundata[c(input$processrundata_rows_selected), 1])])
      loginfo(paste("Inside displayoutput", prrunid), logger="flamingo.module")  
      fileslistdata <<- getfilelist(prrunid)
      datatable(
        fileslistdata,
        rownames = TRUE,
        selection = "single",
        colnames = c('Row Number' = 1),
        tableui <- {getprtable()}
      )
    })
  }else{
    info("Please select Process Run")
  }
}

##### Plot outputgraph
funPlotOutput <- function(outputplotdata)
{
  #years <- 1000
  #idx <- AEPData[, 1]
  #Value <- AEPData[, 2]
  #Rank <- AEPData[, 5]
  #RT <- years/Rank
  #info(outputplotdata)
  outputData <- data.frame(ReturnPeriod = outputplotdata[,1], Loss = outputplotdata[,2])
  outputData <- melt(outputData, id.vars=c("ReturnPeriod", "Loss"))
  
  res <- ggplot(outputData, aes(x = ReturnPeriod, y = Loss)) +
    geom_line() +
    scale_colour_gradient(low = "red")
  return(res)
}


funPlotOutput2 <- function(outputplotdata)
{
  AEPData <- NULL
  #  AEPData <- execute_query(paste("exec dbo.getFileDataForFile 109"))
  #   years <- 1000
  #   years <- 1000
  #   idx <- AEPData[, 3]
  #   Value <- AEPData[, 4]
  #   Rank <- AEPData[, 5]
  #   RT <- years/Rank
  outputData <- data.frame(ReturnPeriod = outputplotdata[,1], Loss = outputplotdata[,2])
  outputData <- melt(outputData, id.vars=c("ReturnPeriod", "Loss"))
  
  res <- ggplot(aes(x='ReturnPeriod'),data=outputData) + 
    stat_function(outputplotdata[,2],color="blue") + 
    stat_function(outputplotdata[,3],color="red") 
  return(res)}

# ##### Plot outputgraph2
# funPlotOutput2 <- function(outputplotdata)
# {
#   df_tb <- read_tsv("../data/OTIS 2013 TB Data.txt", n_max = 1069, col_types = "-ciiii?di")
#   top_states <- df_tb %>%
#     filter(Year == 2013) %>%
#     arrange(desc(Rate)) %>%
#     slice(1:input$nlabels) %>%
#     select(State)
#   
#   df_tb$top_state <- factor(df_tb$State, levels = c(top_states$State, "Other"))
#   df_tb$top_state[is.na(df_tb$top_state)] <- "Other"   
#   info(top_states)
#   
#   res <- df_tb %>%
#     ggplot() +
#     labs(x = "Year reported",
#          y = "TB Cases per 100,000 residents",
#          title = "Reported Active Tuberculosis Cases in the U.S.") +
#     theme_minimal() +
#     geom_line(aes(x = Year, y = Rate, group = State, colour = top_state, size = top_state)) +
#     scale_colour_manual(values = c(brewer.pal(n = input$nlabels, "Paired"), "grey"), guide = guide_legend(title = "State")) +
#     scale_size_manual(values = c(rep(1,input$nlabels), 0.5), guide = guide_legend(title = "State"))
# 
#   return(res)
# }




observe({
  input$tabsetprrunoutput
  if(input$tabsetprrunoutput == "tabprrunfiledata")
  {
    if (length(input$outputfileslist_rows_selected) > 0) {
      fileid <- fileslistdata[c(input$outputfileslist_rows_selected), 1]
          output$dttableoutputfiledata <- DT::renderDataTable(#server = FALSE, 
            {
              filename <- paste0(fileslistdata[c(input$outputfileslist_rows_selected), 5], "/", fileslistdata[c(input$outputfileslist_rows_selected), 2])
              filedata <<- read.csv(filename, header = TRUE, sep = ",", quote = "\"", dec = ".", fill = TRUE, comment.char = "")
              datatable(
                filedata,
                rownames = TRUE,
                selection = "none",
                colnames = c('Row Number' = 1)
                )
            }
        )
          output$PRfiledataIdownloadexcel <- downloadHandler(
            filename = paste0(fileslistdata[c(input$outputfileslist_rows_selected), 2]),
            content = function(file) {
              write.csv(filedata, file)}
          )
          
    }
    else{ 
      info("Please select a file from File List.") 
      updateTabsetPanel(session, "tabsetprrunoutput", selected = "tabprrunfilelist")
    }
  }else{ 
    if(input$tabsetprrunoutput == "tabprrunsummary"){
      outputdataquery <- paste0("getOutputSummaryEP ", prrunid)
      outputplotdata <- execute_query(outputdataquery) 
      #info(paste(outputplotdata))
      #output$plotGULOutput <- renderPlot({
      # lines()
      #outputplotdata[2]
      #})
      output$plotGULOutput <- renderPlot({ 
        RP <- (outputplotdata$ReturnPeriod)
        GUL_OEP <- (outputplotdata$GUL_OEP)
        GUL_AEP <- (outputplotdata$GUL_AEP)
        options("scipen" = 100, "digits" = 4)
        plot(x=RP, y=GUL_AEP, ylab = "Loss", type = "o", col = "red")+
          lines(x=RP, y=GUL_OEP, type = "o", col = "blue")
      })
      output$plotILOutput <- renderPlot({ 
        RP <- (outputplotdata$ReturnPeriod)
        IL_OEP <- (outputplotdata$IL_OEP)
        IL_AEP <- (outputplotdata$IL_AEP)
        options("scipen" = 100, "digits" = 4)
        plot(x=RP, y=IL_AEP, ylab = "Loss", type = "o", col = "red")+
          lines(x=RP, y=IL_OEP, type = "o", col = "blue")
      })
      #output$plotGULOutput <- renderPlot({ funPlotOutput2(outputplotdata)})
      #plot(mtcars$wt, mtcars$mpg)
      #         info(paste("mtcars$wt", typeof(mtcars$wt)))
      #         info(paste("outputplotdata[[1]]", typeof(outputplotdata[[1]])))
    }else{ 
      if(input$tabsetprrunoutput == "tabprrunsummarytable"){
        output$dttableoutputsummary <- DT::renderDataTable(server = FALSE, {
          filedata <- execute_query(paste("exec getOutputSummary", prrunid))
          #info(filedata)
          datatable(
            filedata,
            rownames = TRUE,
            selection = "none",
            colnames = c('Row Number' = 1),
            tableui <- {getprtable()}
          )
        })       
      }
    }}
})

#getfiledownloadname <- function()
#{
#  downloadfilename <- (fileslistdata[c(input$outputfileslist_rows_selected), 2])
#}

#output$PRfiledataIdownloadexcel <- downloadHandler(
#  filename = paste0(getfiledownloadname()),
#  content = function(file) {
#    write.csv(filedata, file)}
#)

# gotofileoutput <- function(){
#     DebugPrint("entering gotofileoutput")
#     if (length(input$processrundata_rows_selected) == 0)
#     {
#         info("please select a file")
#     }
#     else
#     {
#         active_menu <<- "FM"
#         output$menu<-reactive({active_menu})
#         # force it to show file list.Suspect there's a better way to
#         # do this but bit rushed TODO
#         #output$FVPanelSwitcher <- reactive({FODivFilecontents})        
#         output$FVPanelSwitcher <- reactive({FODivTable})        
#         prcrundata2 <<- getProcessRunWithUserChoices(user_id, 0, 0, 0)
#         presel_filerunid <<- (prcrundata2[c(input$processrundata_rows_selected), 1][length(prcrundata2[c(input$processrundata_rows_selected), 1])])
#         print(paste("presel_filerunid is", presel_filerunid))
#         updateTabsetPanel(session, "fm", selected = "fileviewer")
#         updateTabsetPanel(session, "FVMainTabsetPanel", selected = "Table")
#     }
#     
#     DebugPrint("exiting gotofileoutput")
# }




getProcessRunWithUserChoices <- function(pruser, prmodel, prprogramme, prworkflow)
{
  DebugPrint("Entering getProcessRunWithUserChoices")
  
  
  prtable <- getprocessdata(pruser, prmodel, prprogramme, prworkflow)
  
  # Rule is, for one process ID, pass that process ID in, for all
  # processes pass a null.  For processes in all states (completed,
  # created, in progress etc), pass 'All', for just in progress pass
  # 'In Progress'
  prcid <- toString(prtable[c(input$tableprocessdata2_rows_selected), 1])
  
  AllOrInProgress <- isolate(input$radioprrunsAllOrInProgress)
  
  if (AllOrInProgress == "In_Progress")
  {
    AllOrInProgress = "In Progress"
  }
  
  MineOrEveryones <- "All"
#   MineOrEveryones <- isolate(input$radioprrunsMineOrAll)
#   if (MineOrEveryones == "Everyone's")
#   {
#     prcid = "null"
#   }
  prcrundata <<- getprocessrun(prcid, AllOrInProgress)
  
  DebugPrint("Exiting getProcessRunWithUserChoices")
  # return should be unnecessary as prcrundata is set as a global,
  # but some callers expect a return
  return(prcrundata)
}

loadRuntable <- function() {
  DebugPrint("entering loadRuntable")
  prcrundata <<- getProcessRunWithUserChoices(user_id, 0, 0, 0)
  print(prcrundata)
  if (presel_runid == -1){
    index <- 1
  }else {
    index <- match(c(presel_runid),prcrundata[[1]])
  }
  #info(paste("In loadRuntable", input$processrundata_rows_selected))
  output$processrundata <- DT::renderDataTable({
    loginfo(paste("Inside processrundata renderDataTable, Values for presected ProcessRun Index: ", index, Sys.time()), logger="flamingo.module")    
    #info("In processrundata renderDataTable")
    datatable(
      prcrundata,
      rownames = TRUE,
      selection = list(mode = 'single', selected = rownames(prcrundata)[c(as.integer(index))]),
      colnames = c('Row Number' = 1),
      tableui <- {getprtable()}
    )
  })
  DebugPrint("exiting loadRuntable")
}


# function to clear checkboxgroup
clearchkboxgrp<- function(){
  #GUL group
  updateCheckboxGroupInput(session, inputId ="chkgulprog", selected = "None")
  shinyjs::disable("chkgulpolicy")
  updateCheckboxGroupInput(session, inputId ="chkgulstate", selected = "None")
  updateCheckboxGroupInput(session, inputId ="chkgulcounty",selected = "None")
  updateCheckboxGroupInput(session, inputId ="chkgulloc", selected = "None")
  updateCheckboxGroupInput(session, inputId ="chkgullob", selected = "None")
  
  #IL group
  updateCheckboxGroupInput(session, inputId ="chkilprog", selected = "None")
  updateCheckboxGroupInput(session, inputId ="chkilpolicy", selected = "None")
  updateCheckboxGroupInput(session, inputId ="chkilstate", selected = "None")
  updateCheckboxGroupInput(session, inputId ="chkilcounty", selected = "None")
  updateCheckboxGroupInput(session, inputId ="chkilloc", selected = "None")
  updateCheckboxGroupInput(session, inputId ="chkillob", selected = "None")
  
}

# function to get the output presets list
getoutputopt<- function(){
  res <- NULL
  res <- execute_query(paste("exec dbo.getOutputOptions"))
  #result <- unlist(res)
  #print(paste("function for prusers:", res))
  rows <- nrow(res)
  if (rows > 0) {
    s_options2 <- list()
    s_options2[[("--Select--")]] <- ("0")
    for (i in 1:rows){
      s_options2[[paste(sprintf("%s", res[i, 1]))]] <- paste0(sprintf("%s", res[i, 1]))
    }
    #print(s_options2)
    return(s_options2)
  }
  return(res)
}

#function to get Event set list
geteventset<- function(prgoasisid){
  res <- NULL
  res <- execute_query(paste("exec dbo.getEventSet '", prgoasisid, "'"))
  rows <- nrow(res)
  if (rows > 0) {
    s_options2 <- list()
    #s_options2[[("--Select--")]] <- ("0")
    for (i in 1:rows){
      s_options2[[paste(sprintf("%s", res[i, 1]))]] <- paste0(sprintf("%s", res[i, 1]))
    }
    #print(s_options2)
    return(s_options2)
  }
  return(res)
}

#function to get Event Occurrence list
geteventoccurrence<- function(prgoasisid){
  res <- NULL
  res <- execute_query(paste("exec dbo.getEventOccurrence '", prgoasisid, "'"))
  rows <- nrow(res)
  if (rows > 0) {
    s_options2 <- list()
    #s_options2[[("--Select--")]] <- ("0")
    for (i in 1:rows){
      s_options2[[paste(sprintf("%s", res[i, 1]))]] <- paste0(sprintf("%s", res[i, 1]))
    }
    #print(s_options2)
    return(s_options2)
  }
  return(res)
}

#function to clear other runtime params
clearotherparams <- function(){
  updateSelectInput(session, "sinoutputoptions", choices= getoutputopt(), selected = c("--Select--" = 0))
  updateTextInput(session, "tinputprocessrunname", value = "")
  ProgoasisID <- toString(ProcessData[c(input$tableprocessdata2_rows_selected), 1])
  #sessionIDs = getSessionIDs(ProgoasisID)
  #updateSelectInput(session, "chkinputsessionid", choices=sessionIDs)
  updateSliderInput(session, "sliderleakagefac", "Leakage factor:", min= 0, max=100, value=0.5, step = 0.5)
  #   updateSelectInput(session, "sinputeventset", choices= geteventset(ProgoasisID), selected = c("--Select--" = 0))
  #   updateSelectInput(session, "sinputeventocc", choices= geteventoccurrence(ProgoasisID), selected = c("--Select--" = 0))
  updateSelectInput(session, "sinputeventset", choices= geteventset(ProgoasisID))
  updateSelectInput(session, "sinputeventocc", choices= geteventoccurrence(ProgoasisID))  
  updateCheckboxInput(session, "chkinputprwind", "Peril: Wind", value = TRUE)
  updateCheckboxInput(session, "chkinputprstsurge", "Peril: Surge", value = TRUE)
  updateCheckboxInput(session, "chkinputprquake", "Peril: Quake", value = TRUE)
  updateCheckboxInput(session, "chkinputprflood", "Peril: Flood", value = TRUE)
  updateCheckboxInput(session, "chkinputdsurge", "Demand Surge", value = TRUE)
  #ModelName <- toString(ProcessData[c(input$tableprocessdata2_rows_selected), 3])
  #oasisSystems <- getOasisSystems(ProgoasisID)
  #updateSelectInput(session, "sinputoasissystem", choices=oasisSystems)   
}

#A function to run Process: when a row in tableprocessdata2 is selected and Run Process button is clicked    
runpr <- function() {
  if (length(input$tableprocessdata2_rows_selected) > 0 ) {
    toggleModal(session, "bsmodalrunparam", toggle = "open")
    clearotherparams()
    clearchkboxgrp()
    prtable <- getprocessdata(user_id, 0, 0, 0)
    procid <- toString(prtable[c(input$tableprocessdata2_rows_selected), 1][length(prtable[c(input$tableprocessdata2_rows_selected), 1])])
    paramlist <- NULL
    paramlist <- execute_query(paste0("exec dbo.getRuntimeParamList ", procid))
    
    #shinyjs::hide("SessionID")        
    #shinyjs::hide("ReconciliationMode")
    shinyjs::hide("perilwind") 
    shinyjs::hide("perilsurge")
    shinyjs::hide("perilquake") 
    shinyjs::hide("perilflood")
    shinyjs::hide("demandsurge")
    shinyjs::hide("leakagefactor")
    rows <- nrow(paramlist)
    if (rows > 0) {
      for (i in 1:rows){
        ctrname <- gsub("_", "", paramlist[i, 1], fixed = TRUE)
        #info(ctrname)
        shinyjs::show(ctrname)
      }
      
    }
    #clearotherparams()
    #disableRunProcessButton()
  } else {
    info("Please select a Process to run.")
  }
}

#onclick of update button in sidebar panel to update checkboxes for pre-populated values
#onclick("abtnupdtoutopt",{
observe({
  input$sinoutputoptions
  if (input$pr == "processrun"){
    clearchkboxgrp()
    if(length(input$sinoutputoptions)>0 && input$sinoutputoptions != c("--Select--" = 0)){
      outputlist <- NULL
      outputlist <- execute_query(paste0("exec dbo.getOutputOptionOutputs '", input$sinoutputoptions, "'"))
      rows <- nrow(outputlist)
      if (rows > 0) {
        for (i in 1:rows){
          grpid <- paste0("chk",outputlist$Group[i])
          grpinputid <- strsplit(toString(grpid), " ")[[1]]
          chkboxid <- outputlist$Parameter[i]
          #selchoices <- as.list(strsplit(gsub("'", '', toString(chkboxid)), ",")[[1]])
          selchoices <- as.list(strsplit(toString(chkboxid), ",")[[1]])
          updateCheckboxGroupInput(session, inputId = grpinputid, selected = c(selchoices))
        }
      }
    }
  }
  #info(input$sinoutputoptions)
})
#})

#onclick of clear button to clear the checkbox groups and preset dropdown
onclick("abtnclroutopt",{
  clearchkboxgrp()
  updateSelectInput(session, "sinoutputoptions", choices= getoutputopt(), selected = c("--Select--" = 0))
})

onclick("abuttonsaveoutput",{
  OutputOptionsList <- paste(c(input$chkgulprog, input$chkgulpolicy, input$chkgulstate, input$chkgulcounty, input$chkgulloc, input$chkgullob, input$chkilprog, input$chkilpolicy, input$chkilstate, input$chkilcounty, input$chkilloc, input$chkillob),  collapse = ",")
  if(OutputOptionsList == "") {
    toggleModal(session, "bsmodalsaveoutput", toggle = "close")
    info("Please select Output")
  }
})  





onclick("abuttonsubmitoutput",{
  res <- NULL
  if(input$tinputoutputname == "") {
    info("Please enter Output Name")
  }else{
    query <- paste0("EXEC dbo.saveoutputoption @OutputOptionName = '", input$tinputoutputname, "',@OutputOptionsList = '", OutputOptionsList, "'")
    #info(paste(OutputOptionsList, input$tinputoutputname))
    res <- execute_query(query)
    #info(query)
    updateTextInput(session, "tinputoutputname", value = "")
    updateSelectInput(session, "sinoutputoptions", choices= getoutputopt(), selected = c("--Select--" = 0))
    toggleModal(session, "bsmodalsaveoutput", toggle = "close")
  }  
})



#A function to Execute Process: When Execute Run button is clicked    
executerun <- function (){
  print(paste("In function execute button, counter:", input$abuttonexecuteprrun, abuttonexecuteprrun_counter)) 
  #prtable <- getprocessdata(user_id, 0, 0, 0)
  #prcid <- toString(prtable[c(input$tableprocessdata2_rows_selected), 1][length(prtable[c(input$tableprocessdata2_rows_selected), 1])])
  #info(isolate(input$sinputoasissystem))
  #     prrun_id <- {generaterun(
  #         isolate(prcid),
  #         isolate(input$tinputnoofsample),
  #         isolate(input$tinputthreshold),
  #         isolate(input$chkinputsessionid),  
  #         isolate(input$chkinputrcmode),
  #         isolate(input$chkinputdsurge),
  #         isolate(input$chkinputprwind),
  #         isolate(input$chkinputprstsurge),
  #         isolate(input$sinputoasissystem)
  #     )}
  
  prrun_id <- generaterun()
  #shinyjs::hide("sidebarprrun")
  toggleModal(session, "bsmodalrunparam", toggle = "close")
  clearchkboxgrp()
  clearotherparams()
  #enableProcessRunButton() # should be in a try/finally
  if(is.null(prrun_id)){
    info("Process Run ID could not be generated. So Process cannot be executed.")
  }else{      
    runprc <- runprocess(prrun_id)
    if(runprc == 'success' || runprc == 'Success'){
      info(paste("Created Process Run ID: ", prrun_id, " and process run is executing."))
      loadRuntable()
    }else{
      info(paste("Created Process Run ID: ", prrun_id, ". But process run execution failed."))
    }
  }
}

getSessionIDs <- function(ProcessID) {
  res <- NULL # necessary?
  res <- execute_query(paste(
    "exec dbo.getSessionIDsForRunProcessPicker", ProcessID))
  s_options2 <- list()
  for (i in 1:nrow(res)){
    s_options2[[paste(sprintf("%d", res[i, 1]))]] <-
      paste(sprintf("%s", res[i, 1]))
  }
  
  return(s_options2)
  
  
}

cancelRun <- function()
{
  #enableProcessRunButton()
  #shinyjs::hide("sidebarprrun")
  toggleModal(session, "bsmodalrunparam", toggle = "close")
  clearchkboxgrp()
  clearotherparams()
}

#Terminate job: when "Terminate job" button is clicked
terminatejob <-function(){
  if(length(input$processrundata_rows_selected) > 0){
    prrunstatus <- (prcrundata[c(input$processrundata_rows_selected), 3][length(prcrundata[c(input$processrundata_rows_selected), 3])])
    #info(prrunstatus)
    if(prrunstatus == 'In Progress'){
      prrunid <- (prcrundata[c(input$processrundata_rows_selected), 1][length(prcrundata[c(input$processrundata_rows_selected), 1])])
      trmprc <- terminateprocess(prrunid)
      if(trmprc == 'success' || trmprc == 'Success'){
        info(paste("Terminating Process Run ID:", prrunid))
      } else{
        info("Failed to terminate the process.")
      }
    }else {
      info("Cannot terminate this process.")
    }
  } else {
    info("Please select a process run to terminate.")
  }
}

#function to Render Log table 
loadLogtable <- function() {
  wkflwid <- (prcrundata[c(input$processrundata_rows_selected), 1][length(prcrundata[c(input$processrundata_rows_selected), 1])])
  loginfo(paste("Inside LoadLogDetails", wkflwid), logger="flamingo.module")  
  res <- getlogs(wkflwid)
  #loginfo(paste("Inside LoadLogDetails res:", res), logger="flamingo.module")  
  output$log <- DT::renderDataTable({
    loginfo(paste("Inside log renderDataTable res:", res), logger="flamingo.module")
    #info("In renderlogtable")
    #invalidateLater(30000,session)
    datatable(
      res,
      rownames = TRUE,
      selection = "none",
      colnames = c('Row Number' = 1),
      tableui <- {getprtable()}
    )
  })
  DebugPrint("exiting loadLogtable")
}



###############################################################################################################
#An Observer function to switch to Landing page if the user clicks on Main Menu
observe({
  #DebugPrint("entering Observer function to switch to Landing page if...")
  input$pr
  if (input$pr == "prlp")
  {
    loginfo(paste("From Process Management to Landing Page, Userid: ", user_id, Sys.time()), logger="flamingo.module")
    presel_runid <<- -1
    presel_procid <<- -1
    active_menu <<- 'LP'
    output$menu<-reactive({active_menu})   
    load_inbox()
  }
  #   if (input$pr == "processrun")
  #   {
  #       shinyjs::hide("sidebarprrun")
  #       #shinyjs::hide("prruntable")
  #       #shinyjs::hide("processrundata")
  #   }
  #DebugPrint("exiting Observer function to switch to Landing page if...")
})


#Render process data table on Process Run page : when the Process Run tab is clicked
output$tableprocessdata2 <- DT::renderDataTable({
  input$pr
  #loginfo(paste("preselected Process and Run IDs: ", presel_procid, ", ", prog_oasisid), logger="flamingo.module")  
  if ( input$pr == "processrun") {
    #{enableProcessRunButton()}
    ProcessData <<- getprocessdata(user_id, 0, 0, 0)
    print(ProcessData)
    #info(paste("prog_oasisid", prog_oasisid))
    #     if (presel_procid == -1 && presel_runid == -1){
    #       loginfo("presel_procid == -1 && prog_oasisid == -1 \n", logger="flamingo.module")        
    #       index <- 1
    #     }else{ if (presel_procid != -1){
    #       loginfo("presel_procid != -1 \n", logger="flamingo.module")
    #       index <- match(c(presel_procid),ProcessData[[1]])
    #       }else {
    #         loginfo("else \n", logger="flamingo.module")
    #         index <- match(c(prog_oasisid),ProcessData[[1]])
    #       }
    #     }
    index <- match(c(presel_procid),ProcessData[[1]])
    loginfo(paste("Inside tableprocessdata2 renderDataTable, Values for presected Process Index: ", index, Sys.time()), logger="flamingo.module")  
    #res <- datatable(
    datatable(
      ProcessData,
      rownames = TRUE,
      filter = "bottom",
      selection = list(mode = 'single', selected = rownames(ProcessData)[c(as.integer(index))]),
      colnames = c('Row Number' = 1),
      tableui <- {getprtable()}
    )
    #info(input$tableprocessdata2_rows_selected)
  }
  #DebugPrint("Exiting output$tableprocessdata2")
  #res
})


#Observer: Render processrundata table: when a Process is selected in tableprocessdata2 table
observe({
  input$tableprocessdata2_rows_selected
  #input$radioprrunsMineOrAll
  input$radioprrunsAllOrInProgress
  input$pr
  #loginfo(paste("In observer to when process is selected, before if condition", length(input$tableprocessdata2_rows_selected)), logger="flamingo.module")  
  if (input$pr == "processrun"){
    if (length(input$tableprocessdata2_rows_selected) > 0)  {
      loginfo(paste("In observer to when process is selected", length(input$tableprocessdata2_rows_selected)), logger="flamingo.module")  
      # MUST show in this order or doesn't work properly!
      #shinyjs::show("processrundata")
      shinyjs::show("prruntable")
      # shinyjs::hide("prrunlogtable")
      loadRuntable()
      shinyjs::show("abuttondisplayoutput")
      shinyjs::hide("abuttonhideoutput")
      shinyjs::hide("prrunoutput")
      shinyjs::hide("prrunlogtable")
    }else {
      loginfo("Hiding Run table now...\n", logger="flamingo.module")
      #shinyjs::hide("processrundata")
      shinyjs::hide("prruntable")
      shinyjs::hide("prrunlogtable") # does not seem to work, even if put first
    }  
    DebugPrint("exiting observe for input$tableprocessdata2_rows_selected")
  }})

#Observer: when a ProcessRun is selected in processrundata table    
observe({
  input$processrundata_rows_selected
  input$abuttonrefreshprrunlogs
  #loginfo("In observer when processrun is selected\n", logger="flamingo.module")
  if (input$pr == "processrun"){
    if (length(input$processrundata_rows_selected) > 0) {
      loginfo(paste("In condition where processrun is selected", length(input$processrundata_rows_selected)), logger="flamingo.module")  
      #loginfo(length(input$processrundata_rows_selected), logger="flamingo.module")
      updateTabsetPanel(session, "tabsetprrunoutput", selected = "tabprrunfilelist")
      shinyjs::show("prrunlogtable")
      #info(paste("observe: when a ProcessRun is selected in processrundata table", length(input$processrundata_rows_selected)))
      loadLogtable()
    }else {
      loginfo("Hiding Log details now...\n", logger="flamingo.module")
      shinyjs::show("abuttondisplayoutput")
      shinyjs::hide("abuttonhideoutput")
      shinyjs::hide("prrunoutput")
      shinyjs::hide("prrunlogtable")
    }
    DebugPrint("exiting input$processrundata_rows_selected")
  }})

onclick("abuttonrefreshprrun", {loadRuntable()})
onclick("abuttonrunpr", {runpr()})

# When execute run button in clicked in pop-up
onclick("abuttonexecuteprrun", {
  #   if(length(input$sinputeventset)>0 && input$sinputeventset!= c("--Select--" = 0) &&
  #      length(input$sinputeventocc)>0 && input$sinputeventocc!= c("--Select--" = 0)){
  #        executerun()
  #   } else{
  #     info("Please select Event set and Event Occurrence")
  #   }
  OutputOptionsList <- paste(c(input$chkgulprog, input$chkgulpolicy, input$chkgulstate, input$chkgulcounty, input$chkgulloc, input$chkgullob, input$chkilprog, input$chkilpolicy, input$chkilstate, input$chkilcounty, input$chkilloc, input$chkillob),  collapse = ",")  
  if(OutputOptionsList == ""){
    info("Please select Output")
  }else{
    executerun()
  }
  
})
#Cancel Process run: When "Cancel" button is clicked    
onclick("abuttoncancelrun", {cancelRun()} )
onclick("abuttonterminateprrun", {terminatejob()})
onclick("abuttonrefreshprrunogs", {loadLogtable()})
#onclick("abuttontogooutput", {gotofileoutput()})
onclick("abuttondisplayoutput", {displayoutput()})
onclick("abuttonhideoutput", {
  shinyjs::hide("prrunoutput")
  shinyjs::hide("abuttonhideoutput")
  shinyjs::show("abuttondisplayoutput")
})

onclick("abuttonrerunpr", {
  if (length(input$processrundata_rows_selected) > 0) {
    prrunid <- (prcrundata[c(input$processrundata_rows_selected), 1][length(prcrundata[c(input$processrundata_rows_selected), 1])])
    outputlist <- execute_query(paste0("exec dbo.getOutputOptionOutputs @processrunid = ", prrunid))
    runparamsforpr <- execute_query(paste0("exec dbo.getProcessRunParams ", prrunid))
    runpr()
    updateTextInput(session, "tinputprocessrunname", value = prcrundata[c(input$processrundata_rows_selected), 2])
    rows <- nrow(runparamsforpr)
    if (rows > 0) {
      for (i in 1:rows){
        if(runparamsforpr[i,1] == "number_of_samples") {
          updateTextInput(session, "tinputnoofsample", value = runparamsforpr[i,2])      
          next
        }
        if(runparamsforpr[i,1] == "gul_threshold") {
          updateTextInput(session, "tinputthreshold", value = runparamsforpr[i,2])
          next
        }
        if(runparamsforpr[i,1] == "event_set") {
          updateSelectInput(session, "sinputeventset", selected = runparamsforpr[i,2])
          next
        }
        if(runparamsforpr[i,1] == "event_occurrence_id") {
          updateSelectInput(session, "sinputeventocc", selected = runparamsforpr[i,2])
          next
        }
        if(runparamsforpr[i,1] == "peril_wind") {
          updateCheckboxInput(session, "chkinputprwind", value = eval(parse(text=toString(runparamsforpr[i,2]))))
          next
        }
        if(runparamsforpr[i,1] == "peril_surge") {
          updateCheckboxInput(session, "chkinputprstsurge", value = eval(parse(text=toString(runparamsforpr[i,2]))))
          next
        }
        if(runparamsforpr[i,1] == "peril_quake") {
          updateCheckboxInput(session, "chkinputprquake", value = eval(parse(text=toString(runparamsforpr[i,2]))))
          next
        }
        if(runparamsforpr[i,1] == "peril_flood") {
          updateCheckboxInput(session, "chkinputprflood", value = eval(parse(text=toString(runparamsforpr[i,2]))))
          next
        }
        if(runparamsforpr[i,1] == "demand_surge") {
          updateCheckboxInput(session, "chkinputdsurge", value = eval(parse(text=toString(runparamsforpr[i,2]))))
          next
        }
        if(runparamsforpr[i,1] == "leakage_factor") {
          updateSliderInput(session, "sliderleakagefac", value = runparamsforpr[i,2])
          next
        }
      }
    }
    orows <- nrow(outputlist)
    if (orows > 0) {
      for (i in 1:orows){
        grpid <- paste0("chk",outputlist$Group[i])
        grpinputid <- strsplit(toString(grpid), " ")[[1]]
        chkboxid <- outputlist$Parameter[i]
        selchoices <- as.list(strsplit(toString(chkboxid), ",")[[1]])
        updateCheckboxGroupInput(session, inputId = grpinputid, selected = c(selchoices))
      }
    }  
  }else{
    info("Please select Process Run")
  }
  
})
