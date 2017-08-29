# (c) 2013-2016 Oasis LMF Ltd.  Software provided for early adopter evaluation only.
library(shiny)
#library(ggplot2)
#library(reshape2)
#library(ggmap)

############################################## Global Variables #####################################
UserID <- -1 # when no user is selected user ID is reset to -1
FLdata <- 0
FVid <- -1
MarkerData <- NULL

qt <- "\""

############################################### functions ###########################################
  
  # draw company user list table with custom format options, queries the database every time to update its dataset
  drawFLtable <- function(){
    query <- NULL
    FLdata <<- NULL
    query <- paste0("exec dbo.getFileViewerTable")
    FLdata <<- execute_query(query)
    print(presel_filerunid)
    if (presel_filerunid == -1){
      index <- 1 
    }else {
      index <- match(c(paste0("Process:", presel_filerunid)),FLdata[[7]])
    }
    datatable(
      FLdata,
      rownames = TRUE,
      selection = list(mode = 'single', selected = rownames(FLdata)[c(as.integer(index))]),
      colnames = c('Row Number' = 1),
      options = list(
        columnDefs = list(list(visible = FALSE, targets = 0)),
        pageLength = 20,
      	autoWidth=TRUE,
      	#scrollX = TRUE,
        #scrollY = 250,
        rowCallback = JS('function(nRow, aData, iDisplayIndex, iDisplayIndexFull) {
                        //$("table").css("width", "1400px");
                         $("th").css("text-align", "center");
                         $("td", nRow).css("font-size", "12px");
                         $("td", nRow).css("text-align", "center");
                         }')
              )
        )
  }
    
  drawprinfotable <- function(prcrunid){
    res <- NULL
    query <- NULL
    prinfo <<- NULL
    query <- paste("exec dbo.getProcessRunDetailsForFileOutput",prcrunid)
    prinfo <<- execute_query(query)
    datatable(
      prinfo,
      rownames = TRUE,
      #selection = "single",
      selection = list(mode = 'none'),
      colnames = c('Row Number' = 1),
      options = list(
        columnDefs = list(list(visible = FALSE, targets = 0)),
        #autoWidth=FALSE,
        scrollX = TRUE,
#         scrollCollapse = TRUE,
        paging = FALSE,
        searching = FALSE,
        rowCallback = JS('function(nRow, aData, iDisplayIndex, iDisplayIndexFull) {
                         $("table").css("width", "1400px");
                         $("th").css("text-align", "center");
                         $("td", nRow).css("font-size", "12px");
                         $("td", nRow).css("text-align", "center");
  }')
              )
        )
  }
  
  
  drawFVtable <- function(data){
    #invalidateLater(25000,session)
    if(is.character(data)){
        validate(
          need(input$data !="", "Data cannot be displayed for this file type.")
        )
      } else{
    datatable(
      data,
      rownames = TRUE,
      colnames = c('Row Number' = 1),
      options = list(
        columnDefs = list(list(visible = FALSE, targets = 0)),
        pageLength = 20,
        #autoWidth=TRUE,
        #scrollX=TRUE,
        rowCallback = JS('function(nRow, aData, iDisplayIndex, iDisplayIndexFull) {
                           //$("th").css("background-color", "#F5A9BC");
                           $("th").css("text-align", "center");
                           $("td", nRow).css("font-size", "12px");
                           $("td", nRow).css("text-align", "center");
                           }')
            )
        )
    }}
    
  getFilePath <- function(){
        filepath <- FLdata[c(input$tableFVfileList_rows_selected), 3][length(FLdata[c(input$tableFVfileList_rows_selected), 4])]
        filename <- FLdata[c(input$tableFVfileList_rows_selected), 4][length(FLdata[c(input$tableFVfileList_rows_selected), 4])]
        filepath <- file.path(filepath, filename )
    return(filepath)

  }
  
  getYears <- function(){
    filename <- FLdata[c(input$tableFVfileList_rows_selected), 6][length(FLdata[c(input$tableFVfileList_rows_selected), 6])]
    #filename <-("PiWindAEP_1000.csv")
    filename <- toString(filename)
    print(paste("selected filename", typeof(filename)))
    years <- strsplit(filename, split = '[_]')
    years <- years[[1]][2]
    years = as.integer(years)
    return(years)
  }
  
  getGeoDetails <- function(address){   
    #use the gecode function to query google servers
    geo_reply = geocode(address, output='all', messaging=TRUE, override_limit=TRUE)
    #now extract the bits that we need from the returned list
    answer <- data.frame(number=NA, street=NA, postcode=NA, lat=NA, long=NA, formatted_address=NA, accuracy=NA, status=NA)
    
    #return Na's if we didn't get a match:
    if (geo_reply$status != "OK"){
      return(answer)
    }   
    #else, extract what we need from the Google server reply into a dataframe:
    answer$lat <- geo_reply$results[[1]]$geometry$location$lat
    answer$long <- geo_reply$results[[1]]$geometry$location$lng   
    if (length(geo_reply$results[[1]]$types) > 0){
      answer$accuracy <- geo_reply$results[[1]]$types[[1]]
    }
    #    answer$address_type <- paste(geo_reply$results[[1]]$types, collapse=',')
    answer$formatted_address <- geo_reply$results[[1]]$formatted_address
    answer$status <- paste(geo_reply$status)
    return(answer)
  } 
  ############################################### Draw Tables ###########################################
  
  #Render Company user list data when the page is loaded, calls the drawFLtable function
  output$tableFVfileList <- DT::renderDataTable({
    input$fm
    if (input$fm == "fileviewer") {
      drawFLtable()
    }
  })
  
  #An observer to enable/disable Process details based on the type of file selected
  observe({
    if(length(input$tableFVfileList_rows_selected) > 0){
      sourcename <- (FLdata[c(input$tableFVfileList_rows_selected), 7][length(FLdata[c(input$tableFVfileList_rows_selected), 7])])
      srcname <- (nchar(toString(sourcename)))
      prcrunid <-substr(sourcename,9,srcname)
      prcstr <- toString(substr(sourcename,0,8))
      if(prcstr == 'Process:'){
        shinyjs::show("processruninfodiv")
        prcrunid = as.integer(prcrunid)
        showprcinfo <- getProcRunDetForFileOutput(prcrunid)
        showruntimeparam <- getProcRunparamFileOutput(prcrunid)
        output$textprcruninfo <- renderUI({
          prid<-paste(strong("Process Id: "), showprcinfo[[1]][1])
          prrnid<-paste(strong("Process Run Id: "), showprcinfo[[2]][1])
          prname<-paste(strong("Process Name: "), showprcinfo[[3]][1])
          prgname<-paste(strong("Programme: "), showprcinfo[[4]][1])
          modname<-paste(strong("Model: "), showprcinfo[[5]][1])
          wkflow<-paste(strong("Workflow: "), showprcinfo[[6]][1])
          HTML(paste(prid, prrnid, prname, prgname,modname,wkflow, sep = '<br/>'))
        })
        output$textprcrunparaminfo <- renderUI({
          paramstype <- names(showruntimeparam)
          paramvalues <- (showruntimeparam)
          params <- paste0("<b>",paramstype,": </b>", paramvalues, sep = "<br/>")
          HTML(params)
        })
      }
      else{
        shinyjs::hide("processruninfodiv")
      }
    } else{
      shinyjs::hide("processruninfodiv")
    }
  })  
  
  #function to get Process Run Details
  getProcRunDetForFileOutput<- function(prcrunid){
    res <- NULL
    query <- NULL
    query <- paste("exec dbo.getProcessRunDetailsForFileOutput",prcrunid)
    res <- execute_query(query)
    return(res)
  }
  
  #function to get Process Runtime Param Details
  getProcRunparamFileOutput<- function(prcrunid){
    res <- NULL
    query <- NULL
    query <- paste("exec dbo.getUserParamsForProcessRun",prcrunid)
    res <- execute_query(query)
    rows <- nrow(res)
    if (rows > 0) {
      s_options2 <- list()
      #s_options2[[print("All")]] <- print("0")
      for (i in 1:rows){
        s_options2[[paste(sprintf("%s", res[i, 1]))]] <-
          paste0(sprintf("%s", res[i, 2]))
      }
      #print(s_options2)
      return(s_options2)
    }
    return(res)
  }

  #To display process details for an output file
#   processdetails <-function(){
# #     if(length(input$tableFVfileList_rows_selected) > 0){
# #       sourcename <- (FLdata[c(input$tableFVfileList_rows_selected), 7][length(FLdata[c(input$tableFVfileList_rows_selected), 7])])
# #       srcname <- (nchar(toString(sourcename)))
# #       prcrunid <-substr(sourcename,9,srcname)
# #       prcstr <- toString(substr(sourcename,0,8))
# #       if(prcstr == 'Process:'){
#         prcrunid = as.integer(prcrunid)
#         showprcinfo <- getProcRunDetForFileOutput(prcrunid)
#         #info(showprcinfo)
#         prid <- paste("Process Id: ", showprcinfo[[1]][1])
#         prrunid <- paste("Process Run Id: ", showprcinfo[[2]][1])
#         info(paste(prid,prrunid, sep = '<br/>' ))
#         #info(paste("Process Id: ", showprcinfo[[1]][1],"\n", "Process Run Id: ", showprcinfo[[2]][1], "Process Name: ", showprcinfo[[3]][1], "Programme: ", showprcinfo[[4]][1], "Model: ", showprcinfo[[5]][1], "Workflow: ", showprcinfo[[6]][1]))
# #       }else {
# #         info("This is not an output file from process run.")
# #       }
# #     } else {
# #       info("Please select a file to see the Process details.")
# #     }
#   }
#   onclick("abuttonprocessinfo", {processdetails()})
  

FuncForGenericMap <- function()
{
#  filepath <- {getFilePath()}
#  print(paste(filepath))
  filename <- paste0(FLdata[c(input$tableFVfileList_rows_selected), 5], "/", FLdata[c(input$tableFVfileList_rows_selected), 2])
  MarkerData <<- NULL
  MarkerData <<- read.csv(filename, header = TRUE, sep = ",", quote = "\"", dec = ".", fill = TRUE, comment.char = "")
  PopupData <- paste0(
    "<strong>Location ID: </strong>", MarkerData$LOCNUM,
    "<br><strong>Lat: </strong>", MarkerData$LATITUDE,
    "<br><strong>Long: </strong>", MarkerData$LONGITUDE)
  leaflet() %>%
    addTiles() %>%
      addMarkers(data = MarkerData,
                clusterOptions= markerClusterOptions(maxClusterRadius = 50),
                popup = (PopupData))

}

  
output$plainmap <- renderLeaflet({ FuncForGenericMap() })





FuncForEventFootprintMap <- function()
{
  filepath <- {getFilePath()}
  #print(paste(filepath))
  ExposureData <<- NULL
  ExposureData <<- execute_query(paste("exec dbo.getFileDataForFile",FVid))

     PopupData <- paste0(
        "<strong>Latitude: </strong>", ExposureData$latitude,
        "<br><strong>Longitude: </strong>", ExposureData$longitude,
        "<br><strong>Intensity: </strong>", ExposureData$intensity,
        "<br><strong>Area Peril ID: </strong>", ExposureData$AreaPeril)

     leaflet() %>%
         addTiles() %>%
            addMarkers(
                data = ExposureData,
                clusterOptions= markerClusterOptions(maxClusterRadius = 30),
                popup = PopupData
            )
}


output$EventFootprintMap <- renderLeaflet({ FuncForEventFootprintMap() })

observe(
  {
    if (length(input$tableFVfileList_rows_selected) > 0) 
    {
      output$tableFVExposureSelected <- DT::renderDataTable(#server = FALSE, 
        {
          #info(FLdata[c(input$tableFVfileList_rows_selected), 2])
          filename <- paste0(FLdata[c(input$tableFVfileList_rows_selected), 5], "/", FLdata[c(input$tableFVfileList_rows_selected), 2])
          filedata <<- read.csv(filename, header = TRUE, sep = ",", quote = "\"", dec = ".", fill = TRUE, comment.char = "")
          datatable(
            filedata,
            rownames = TRUE,
            selection = "none",
            colnames = c('Row Number' = 1)
            )
        }
  )

  output$FVEdownloadexcel <- downloadHandler(
    filename = paste0(FLdata[c(input$tableFVfileList_rows_selected), 2]),
    content = function(file) {
      write.csv(filedata, file)}
  )

    }
  }
)

FuncForPlotFVAEPCurve <- function()
{
  AEPData <- NULL
  AEPData <- execute_query(paste("exec dbo.getFileDataForFile",FVid))
  years <- 1000
      years <- 1000
  idx <- AEPData[, 3]
  Value <- AEPData[, 4]
  Rank <- AEPData[, 5]
  RT <- years/Rank
  AEPData <- data.frame(IDX = idx, ReturnPeriod = RT, Loss = Value)
  AEPData <- melt(AEPData, id.vars=c("IDX", "ReturnPeriod", "Loss"))
  
  res <- ggplot(AEPData, aes(x = ReturnPeriod, y = Loss, color = IDX, group = IDX)) +
    geom_line() +
    scale_colour_gradient(low = "red")

  return(res)
}


output$plotFVAEPCurve <- renderPlot({ FuncForPlotFVAEPCurve() })



FuncForTableFVAEPdata <- function()
{
    res <- NULL
    AEPdata <- execute_query(
        paste("exec dbo.getFileDataForFile", FVid))
    res <- drawFVtable(AEPdata)

    return(res)
}


output$tableFVAEPdata <- DT::renderDataTable({ FuncForTableFVAEPdata() })






FuncForTableGeocodeData <- function()
{                               
  geocoded <- data.frame()
  filepath <- {getFilePath()}
  print(paste(filepath))
  GeoData <<- NULL
  GeoData <<- execute_query(paste("exec dbo.getFileDataForFile",FVid))
  withProgress(message = "Getting Geocode Data",{
    for(n in 1:50){
      query <- paste(GeoData[n,2], GeoData[n,3], GeoData[n,4])
      print(query)
      result = getGeoDetails(query)
      geocoded <- rbind(geocoded, result)
      geocoded$number[n] <- GeoData[n,2]
      geocoded$street[n] <- paste(GeoData[n,3])
      geocoded$postcode[n] <- paste(GeoData[n,4])
      incProgress(amount = 0.02, detail = paste0(n*2, "%"))
    }
  })
  # note that %>% must follow on immediately from an expression,
  # it can't appear on a line by itself
  datatable(
    geocoded,
    selection = "none",
    colnames = c('Building No.', 'Street Name', 'Postcode', 'Latitude', 'Longitude', 'Returned Address', 'Accuracy', 'Status'),
    options = list(
        columnDefs = list(list(visible = FALSE, targets = 0)),
        autoWidth=TRUE)
  ) %>%
    formatStyle('lat', backgroundColor = '#96BFD8') %>%
    formatStyle('long', backgroundColor = '#96BFD8') %>%
    formatStyle('accuracy', backgroundColor = '#96BFD8') %>%
    formatStyle('formatted_address', backgroundColor = '#96BFD8') %>%
    formatStyle('status', backgroundColor = '#96BFD8')
}


  
##ONLY GETS THE FIRST 50 ROWS OF DATA
## above comment left in but doesn't seem to be true any more???
  output$tableGeocodeData <- DT::renderDataTable({ FuncForTableGeocodeData() })





  observe({

    input$tableFVfileList_rows_selected
    if(length(input$tableFVfileList_rows_selected) == 0)
    {
        disableAllButtonsButTable()
    }
    else # something selected...
    {
        FVid <<- FLdata[c(input$tableFVfileList_rows_selected), 1]
        # print(paste("fvid is ", FVid))
        disableAllButtonsButTable()
        validButtons = execute_query(
            paste("exec dbo.TellOperationsValidOnFileID", FVid))
        # need to transpose here to get the 'for' working; don't know why
        validButtons = t(validButtons)
        for(btnIDs in validButtons)
        {
            enable(btnIDs)
        }

    }

  })


  
  
  
  


############################################# Export to .csv #####################################################################
#File List
output$FVFLdownloadexcel <- downloadHandler(
  filename ="filelist.csv",
  content = function(file) {
    write.csv(FLdata, file)}
)
##Exposures
#output$FVEdownloadexcel <- downloadHandler(
#  filename ="exposures.csv",
#  content = function(file) {
#    write.csv(execute_query(paste("exec dbo.getFileDataForFile",FVid)), file)}
#)
#AEP
output$FVAEPdownloadexcel <- downloadHandler(
  filename ="AEPdata.csv",
  content = function(file) {
    write.csv(execute_query(paste("exec dbo.getFileDataForFile",FVid)), file)}
)
#Geocode
output$FVGdownloadexcel <- downloadHandler(
  filename ="geocodeddata.csv",
  content = function(file) {
    write.csv(execute_query(paste("exec dbo.getFileDataForFile",FVid)), file)}
)


displayOnePanel <- function(which)
{
    print(paste("showing ", which))
    output$FVPanelSwitcher <- reactive({which})
}


hideAllFileMgmtDivs <<- function()
{
    # print(paste("all mgmt tabs are ", allFileMgmtDivIDs))
    for(nm in allFileMgmtDivIDs)
    {
        hide(nm)
        disable(nm)
    }
}



disableAllButtonsButTable <<- function()
{
    for(btnName in AllFileMgmtButtonIDs)
    {
        # the current query will enable file content viewer always
        if (btnName != FOBtnShowTable)
        {
            disable(btnName)
        }
    }
}





onclick(FOBtnShowTable,      { displayOnePanel(FODivTable) })

onclick(FOBtnShowRawContent, { displayOnePanel(FODivFilecontents) })

onclick(FOBtnShowMap, { displayOnePanel(FODivPlainMap) })

onclick(FOBtnShowAEPCurve, { displayOnePanel(FODivAEPcurve) })

onclick(FOBtnShowGeocode, { displayOnePanel(FODivGeocode) })

onclick(FOBtnShowEventFootprint, { displayOnePanel(FODivEventFootprint) })


#An Observer function to switch to Main Menu   
observe({
  input$fm
  if (input$fm == "fmlp")
  {
    loginfo(paste("From File Management to Landing Page, Userid: ", user_id, Sys.time()), logger="flamingo.module")
    active_menu <<- "LP"
    output$menu<-reactive({active_menu})    
    load_inbox()
  }
})
