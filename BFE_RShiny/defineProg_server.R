# (c) 2013-2016 Oasis LMF Ltd.  Software provided for early adopter evaluation only.
prog_flag <<- ""
DPProgdata <<- NULL
prog_oasisid <<- -1

################################################# Programme Functions ###########################################
drawDPprogtable <- function(){
  DPProgdata <<- NULL
    query <- paste("exec dbo.getProgData")
    DPProgdata <<- execute_query(query)
    datatable(
      DPProgdata,
      rownames = TRUE,
      filter = "none",
      selection = "single",
      colnames = c('Row Number' = 1),
      options = list(
        columnDefs = list(list(visible = FALSE, targets = 0)),
        autoWidth=TRUE,
        #scrollX = TRUE,
        pageLength = 5,
        rowCallback = JS('function(nRow, aData, iDisplayIndex, iDisplayIndexFull) {
                         //$("table").css("width", "1850px");
                         //$("th").css("background-color", "#F5A9BC");
                         $("th").css("text-align", "center");
                         $("td", nRow).css("font-size", "12px");
                         $("td", nRow).css("text-align", "center");
  }')
      )
        )
  #}
  }

drawprogdet <- function(prog_id){
  query <- NULL
  if(length(input$tableDPprog_rows_selected) > 0){
    query <- paste0("exec dbo.getProgFileDetails ", prog_id)
    loginfo(paste("In drawprogdet: ", query), logger="flamingo.module")
    progdetails <<- execute_query(query)
    datatable(
      progdetails,
      rownames = TRUE,
      filter = "none",
      selection = "none",
      colnames = c('Row Number' = 1),
      options = list(
        columnDefs = list(list(visible = FALSE, targets = 0)),
        autoWidth=TRUE,
        #scrollX = TRUE,
        #scrollY = 300,
        rowCallback = JS('function(nRow, aData, iDisplayIndex, iDisplayIndexFull) {
                         //$("table").css("width", "1400px");
                         $("th").css("text-align", "center");
                         $("td", nRow).css("font-size", "12px");
                         $("td", nRow).css("text-align", "center");
  }')
      )
    )
  }}


####### TO BE DELETED AFTER INCLUDING FILE UPLOAD ##########
getfilelocationpath <- function(filetyp){
  res <- NULL
  res <- execute_query(paste0("exec dbo.getFileLocationPath ","'", filetyp , "'"))
  return(res[1,1])
}

####### TO BE DELETED AFTER INCLUDING FILE UPLOAD ##########
createfilerecord <- function(filename, filedesc, filetype, locpathunix, BFEUserID, ResourceTable, ResourceKey){
  res <- NULL
  res <- execute_query(paste0("exec dbo.createFileRecord ","'", filename , "', ", "'", filedesc , "', ","'", filetype , "', ", "'", locpathunix , "', ", BFEUserID , ", '", ResourceTable, "', ", ResourceKey))
  filerecres <- unlist(res)
  return(filerecres)
}

####################### Programme Table###############################
getAccountName <- function(){
  res <- NULL
  res <- execute_query(paste("exec dbo.getAccount"))
  rows <- nrow(res)
  if (rows > 0) {
    s_options2 <- list()
    s_options2[[("Select Account")]] <- ("0")
    for (i in 1:rows){
      s_options2[[paste(sprintf("%s", res[i, 2]))]] <- paste0(sprintf("%s", res[i, 1]))
    }
    return(s_options2)
  }
  return(res)
}

getTransformNameSourceCan <- function(){
  res <- NULL
  res <- execute_query(paste("exec dbo.getTransformNameSourceCan"))
  rows <- nrow(res)
  if (rows > 0) {
    s_options2 <- list()
    s_options2[[("Select Transform")]] <- ("0")
    for (i in 1:rows){
      s_options2[[paste(sprintf("%s", res[i, 1]))]] <- paste0(sprintf("%s", res[i, 2]))
    }
    #print(s_options2)
    return(s_options2)
  }
  return(res)
}

getTransformNameCanModel <- function(){
  res <- NULL
  res <- execute_query(paste("exec dbo.getTransformNameCanModel"))
  rows <- nrow(res)
  if (rows > 0) {
    s_options2 <- list()
    s_options2[[("Select Transform")]] <- ("0")
    for (i in 1:rows){
      s_options2[[paste(sprintf("%s", res[i, 1]))]] <- paste0(sprintf("%s", res[i, 2]))
    }
    #print(s_options2)
    return(s_options2)
  }
  return(res)
}
####### Create Programme #######
onclick("buttoncreatepr",{
  prog_flag <<- "C"
  shinyjs::show("divsidebardefprog")
  shinyjs::show("divamdprog")
  updateSelectInput(session, "sinputDPAccountName", choices= getAccountName(), selected = c("Select Account" = 0))

  updateTextInput(session, "tinputDPProgName", value="")
  
  updateSelectInput(session, "sinputTransformname", choices= getTransformNameSourceCan(), selected=c("Select Transform" = 0))
  #shinyjs::disable("buttoncreatepr")
})

####### Amend Programme #######
onclick("buttonamendpr",{
  if(length(input$tableDPprog_rows_selected) > 0) {
    prog_flag <<- "A"
    shinyjs::show("divsidebardefprog")
    shinyjs::show("divamdprog")
    #info("showing amend div")
    shinyjs::show("divFileUpload")
    updateSelectInput(session, "sinputDPAccountName", choices= getAccountName(), selected=toString(DPProgdata[(input$tableDPprog_rows_selected),3]))
    updateTextInput(session, "tinputDPProgName", value=DPProgdata[input$tableDPprog_rows_selected,2])
    updateSelectInput(session, "sinputTransformname", choices= getTransformNameSourceCan(), selected=toString(DPProgdata[(input$tableDPprog_rows_selected),5]))
#    shinyjs::disable("buttonamendpr")
  }else {
    info("Please select a Programme to Amend")
  }
})

####### Delete Programme #######
onclick("buttondeletepr",{
  if(length(input$tableDPprog_rows_selected) > 0) {
    query <- paste("exec dbo.deleteProg", DPProgdata[input$tableDPprog_rows_selected,1])
    execute_query(query)
    info(paste("Programme ", DPProgdata[input$tableDPprog_rows_selected,2], " deleted."))
    output$tableDPprog <- DT::renderDataTable({drawDPprogtable()})
  }else {
    info("Please select a Programme to Delete")
  }
  
})

######## Submit - Programme ########
onclick("abuttonProgSubmit", {
  res <- NULL
  if (prog_flag == "C"){
    query <- paste0("exec dbo.createProg [",input$tinputDPProgName,"],",input$sinputDPAccountName,", [",input$sinputTransformname,"]")
    res <- execute_query(query)
    if (is.null(res)) {
      info(paste("Failed to create a Programme - ", input$tinputDPProgName))
    }else{
      info(paste("Programme ", input$tinputDPProgName, " created."))
    }
  }else {
    if (prog_flag == "A"){
      query <- paste0("exec dbo.updateProg ",DPProgdata[input$tableDPprog_rows_selected,1],",[",input$tinputDPProgName,"],", input$sinputDPAccountName,", [",input$sinputTransformname,"]")
      res <- execute_query(query)
      if (is.null(res)) {
        info(paste("Failed to amend a Programme - ", DPProgdata[input$tableDPprog_rows_selected,2]))
      }else{
        info(paste("Programme ", DPProgdata[input$tableDPprog_rows_selected,2], " amended."))
      }
    }
  }
  output$tableDPprog <- DT::renderDataTable({drawDPprogtable()})
  shinyjs::hide("divsidebardefprog")
  shinyjs::hide("divamdprog")
  shinyjs::hide("divFileUpload")
  updateTextInput(session, "tinputDPProgName", value="")
  shinyjs::enable("buttoncreatepr")
  shinyjs::enable("buttonamendpr")
  prog_flag <<- ""
})

######## Cancel - Programme ########
onclick("abuttonProgCancel",{
  shinyjs::hide("divsidebardefprog")
  shinyjs::hide("divamdprog")
  shinyjs::hide("divFileUpload")
  shinyjs::hide("divSLFileUpload")
  shinyjs::hide("divSLFileSelect")
  shinyjs::hide("divSAFileUpload")
  shinyjs::hide("divSAFileSelect")
  updateTextInput(session, "tinputDPProgName", value="")
  updateSelectInput(session, "sinputSLFile", selected="")    
  updateSelectInput(session, "sinputSAFile", selected="")      
#   shinyjs::enable("buttonamendpr")
#   shinyjs::enable("buttoncreatepr")
#   shinyjs::enable("buttoncreateac")
#   shinyjs::enable("buttonamendac")
  prog_flag <<- ""
})

#######Upload Location File ########
onclick("abuttonSLFileUpload",{
  inFile <- input$SLFile
  #info(inFile[1,1])
 flc <- getfilelocationpath("Exposure File")
 #info(flc)
 flcopy <- file.copy(inFile$datapath, paste0(flc, "/",inFile[1,1]), overwrite = TRUE)
 #cat(paste0(flc, "/",inFile[1,1], "\n"))
 loginfo(paste0(flc, "/",inFile[1,1]), logger="flamingo.module")
  if (flcopy == TRUE){
    createrec <- createfilerecord(inFile[1,1],"Source Loc File",101, flc, user_id, "Prog", DPProgdata[input$tableDPprog_rows_selected,1])
    #info(paste(inFile[1,1],"Cannonical Loc File",1, flc, user_id))
    info(paste("New File record id: ", createrec, " created."))
    output$tableprogdetails <- DT::renderDataTable({drawprogdet(DPProgdata[input$tableDPprog_rows_selected,1])})
 } else{
   info("File transfer failed.")
 }
})

#######Upload Account File  ###########
onclick("abuttonSAFileUpload",{
  inFile <- input$SAFile
  print(inFile[1,1])
  flc <- getfilelocationpath("Exposure File")
  flcopy <- file.copy(inFile$datapath, paste0(flc, "/",inFile[1,1]), overwrite = TRUE)
  #cat(paste0(flc, "/",inFile[1,1], "\n"))
  loginfo(paste0(flc, "/",inFile[1,1]), logger="flamingo.module")
  if (flcopy == TRUE){
    createrec <- createfilerecord(inFile[1,1],"Source Acc File",102, flc, user_id, "Prog", DPProgdata[input$tableDPprog_rows_selected,1])
    #print(paste(inFile[1,1],"Cannonical Acc File",1, flc, user_id))
    info(paste("New File record id: ", createrec, " created."))
    output$tableprogdetails <- DT::renderDataTable({drawprogdet(DPProgdata[input$tableDPprog_rows_selected,1])})
  } else{
    info("File transfer failed.")
  }
  shinyjs::hide("divSLFileUpload")
})

#######Link Programme File  ###########
onclick("abuttonSLFileLink",{
  res <- NULL
  res <- execute_query(paste("exec dbo.updateSourceLocationFileForProg ", input$sinputselectSLFile, ", ", DPProgdata[input$tableDPprog_rows_selected,1]))
  if(input$sinputselectSLFile != ""){
    if (is.null(res)){
      info("Failed to link the File!")
    }else {
      info(paste("Location File linked to Programme", DPProgdata[input$tableDPprog_rows_selected,2]))
      output$tableprogdetails <- DT::renderDataTable({drawprogdet(DPProgdata[input$tableDPprog_rows_selected,1])})
    }
  }else{
    info("Please select a file to Link")
  }
})

#######Link Account File  ###########
onclick("abuttonSAFileLink",{
  res <- NULL
  res <- execute_query(paste("exec dbo.updateSourceAccountFileForProg ", input$sinputselectSAFile, ", ", DPProgdata[input$tableDPprog_rows_selected,1]))
  if(input$sinputselectSAFile != ""){
    if (is.null(res)){
      info("Failed to link the File!")
    }else {
      info(paste("Location File linked to Programme", DPProgdata[input$tableDPprog_rows_selected,2]))
      output$tableprogdetails <- DT::renderDataTable({drawprogdet(DPProgdata[input$tableDPprog_rows_selected,1])})
    }
  }else{
    info("Please select a file to Link")
  }
})

##########Load Programme data ######################

#A function to load Programme data
loadprogrammedata <- function(){
  url_rp <- NULL
  flag <- 1
  tryCatch({
    progid <- DPProgdata[input$tableDPprog_rows_selected,1]
    url <- paste0("http://",flamingo_server_ip,":",port,"/loadprogrammedata/", progid)
    url_rp <- GET(url, as = "text")
    status <- http_status(url_rp)
    flag <- status[[1]]
    warn_for_status(url_rp)
    #cat(paste("In loadprogrammedata trycatch:",status, "\n"), file=stderr())
    loginfo(paste("In loadprogrammedata trycatch:",status), logger="flamingo.module")
  }, warning = function(war) {
    flag <- status[[1]]
    #cat(paste("In loadprogrammedata Warning: ", war, "\n"), file=stderr())
    loginfo(paste("In loadprogrammedata Warning: ", war), logger="flamingo.module")
    #return(NULL)
  }, error=function(e) {
    flag <- status[[1]]
    loginfo(paste("In loadprogrammedata Error:", e), logger="flamingo.module")
    #return(NA)
  }, finally = {
    loginfo(paste("In loadprogrammedata Finally:", url), logger="flamingo.module")
    return(flag)
  }
  )
}


onclick("buttonloadcanmodpr",{
  if(length(input$tableDPprog_rows_selected) > 0){
#     res <- NULL
#     query <- paste0("exec dbo.LoadProgrammeData ",DPProgdata[input$tableDPprog_rows_selected,1])
#     res <- execute_query(query)
#     canmodres <- unlist(res)
#     #names(canmodres) <- canmodres
#     if (is.null(res)) {
#       info(paste("Failed to load canonical model for Programme - ", DPProgdata[input$tableDPprog_rows_selected,2]))
#     }else{
#       info(paste("Result: ", canmodres))
#     }
    loadprogdata <- loadprogrammedata()
    if(loadprogdata == 'success' || loadprogdata == 'Success'){
      info("Initiating load programme data..")
    }else{
      info("Failed to load programme data.")
    }
  }else{
    info("Please select a Programme to load programme data.")
  }
  
})

#########On click of Prog Table Refresh Button ##############

onclick("abuttonprgtblrfsh", {
  output$tableDPprog <- DT::renderDataTable({drawDPprogtable()})
})


#########On click of Prog Details Refresh Button ##############

onclick("abuttondefprogrfsh", {
  output$tableprogdetails <- DT::renderDataTable({drawprogdet(DPProgdata[input$tableDPprog_rows_selected,1])})
})

######################################### Observers #####################################################
observe ({
  input$em 
  if (input$em == "defineProg") {
    prog_flag <<- ""
    output$tableDPprog <- DT::renderDataTable({drawDPprogtable()})
    shinyjs::hide("divsidebardefprog")
    shinyjs::hide("obtainoasiscrtprgdiv")
    shinyjs::hide("divprogmodeltable")
    shinyjs::hide("divSLFileUpload")
    shinyjs::hide("divSLFileSelect")
    shinyjs::hide("divSAFileUpload")
    shinyjs::hide("divSAFileSelect")
    shinyjs::hide("divdefprogdetails")
    shinyjs::hide("divprogoasisfiles")
#     shinyjs::enable("buttoncreatepr")
#     shinyjs::enable("buttonamendpr")
    updateSelectInput(session, "sinputSLFile", selected="")    
    updateSelectInput(session, "sinputSAFile", selected="")    
  }
})

#### Load Prog Model table
observe({
  input$em 
  if (input$em == "defineProg") {
  if(length(input$tableDPprog_rows_selected) > 0){
    shinyjs::show("divprogmodeltable")
    output$tableProgOasisOOK <- DT::renderDataTable({
      drawPOtableOOK(DPProgdata[input$tableDPprog_rows_selected,1])})
    programme = {getProgrammeList()}
    updateSelectInput(session, "sinputookprogid", choices = programme, selected = DPProgdata[input$tableDPprog_rows_selected,1])
  }else{
    shinyjs::hide("divprogmodeltable")
    shinyjs::hide("divprogoasisfiles")
    shinyjs::hide("divsidebardefprog")
    shinyjs::hide("obtainoasiscrtprgdiv")
  }
  }    
})

###Load Prog details table
observe({
  input$em 
  if (input$em == "defineProg") {
  if(length(input$tableDPprog_rows_selected) > 0){
    shinyjs::show("divdefprogdetails")
    prog_id <- toString(DPProgdata[input$tableDPprog_rows_selected,1])
    output$tableprogdetails <- DT::renderDataTable({drawprogdet(prog_id)})
  }else{
    shinyjs::hide("divdefprogdetails")
  }
  }
})

## Display File Upload/link options
observe({
  if(input$sinputSLFile == "U"){
    shinyjs::show("divSLFileUpload")
    shinyjs::disable("abuttonSLFileUpload")
    shinyjs::hide("divSLFileSelect")
  }else{
    if(input$sinputSLFile == "S"){
      shinyjs::show("divSLFileSelect")
      shinyjs::hide("divSLFileUpload")
    } 
  }
  if(input$sinputSAFile == "U"){
    shinyjs::show("divSAFileUpload")
    shinyjs::hide("divSAFileSelect")
  }else{
    if(input$sinputSAFile == "S"){
      shinyjs::show("divSAFileSelect")
      shinyjs::hide("divSAFileUpload")
    } 
  }
})

########### On change Location file upload dropdown ########
getFileSourceLocationFile <- function(){
  res <- NULL
  res <- execute_query(paste("exec dbo.getFileSourceLocationFile"))
        rows <- nrow(res)
        if (rows > 0) {
          s_options2 <- list()
          #s_options2[[print("All")]] <- print("0")
          for (i in 1:rows){
            s_options2[[paste(sprintf("%s", res[i, 1]))]] <- paste0(sprintf("%s", res[i, 2]))
          }
          #print(s_options2)
          return(s_options2)
        }
        return(res)
}
  
observe({
  input$sinputSLFile
  if (input$sinputSLFile == "U"){
    options(shiny.maxRequestSize = 1024*1024^2)
    inFile <- input$SLFile
    if (is.null(inFile)){
      return(NULL)
    }else{
      shinyjs::enable("abuttonSLFileUpload")
    }  
  }else{
    if (input$sinputSLFile == "S"){
      SLfileList <- getFileSourceLocationFile()
      #SLfileListChoices <- unlist(SLfileList)
      #names(SLfileListChoices) <- SLfileListChoices
      updateSelectInput(session, "sinputselectSLFile", choices= SLfileList)
    }
  }
})

 
########### On change Account file upload dropdown ########

getFileSourceAccountFile <- function(){
  res <- NULL
  res <- execute_query(paste("exec dbo.getFileSourceAccountFile"))
  rows <- nrow(res)
  if (rows > 0) {
    s_options2 <- list()
    #s_options2[[print("All")]] <- print("0")
    for (i in 1:rows){
      s_options2[[paste(sprintf("%s", res[i, 1]))]] <- paste0(sprintf("%s", res[i, 2]))
    }
    #print(s_options2)
    return(s_options2)
  }
  return(res)
}

observe({
  input$sinputSAFile
  if (input$sinputSAFile == "U"){
    options(shiny.maxRequestSize = 1024*1024^2)
    inFile <- input$SAFile
    if (is.null(inFile)){
      return(NULL)
    }else{
      shinyjs::enable("abuttonSAFileUpload")
    }  
  }else{
    if (input$sinputSAFile == "S"){
      SAfileList <- getFileSourceAccountFile()
      updateSelectInput(session, "sinputselectSAFile", choices= SAfileList)
    }
  }
})

######################################## Programme Model Table (previously OOK) ##############################
PO_data <<- NULL

#A function to get getProgOasisForProg
getProgOasisForProgdata <- function(ProgID){
  res <- NULL
  query <- NULL
  query <- paste("exec dbo.getProgOasisForProg",ProgID)
  loginfo(paste("In getProgOasisForProgdata: ", query), logger="flamingo.module")
  res <- execute_query(query)
  return(res)
}

#A function to get Programme data 
getProgrammeList <- function (){
  res <- NULL
  res <- execute_query(paste("exec dbo.getProgData"))
  rows <- nrow(res)
  if (rows > 0) {
    s_options2 <- list()
    s_options2[[("Select Programme")]] <- ("0")
    for (i in 1:rows){
      s_options2[[paste(sprintf("%s", res[i, 2]))]] <- paste(sprintf("%s", res[i, 1]))
    }
    return(s_options2)
  }
  print(paste("Res of Prog data:", res))
  return(res)
  
}

#A function to get Model data 
getModelsList <- function (){
  res <- NULL
  res <- execute_query(paste("exec dbo.getmodel"))
  rows <- nrow(res)
  if (rows > 0) {
    s_options2 <- list()
    s_options2[[("Select Model")]] <- ("0")
    for (i in 1:rows){
      s_options2[[paste(sprintf("%s", res[i, 2]))]] <- paste(sprintf("%s", res[i, 1]))
    }
    return(s_options2)
  }
  print(paste("Res of process data:", res))
  return(res)
  
}


drawPOtableOOK <- function(prgid){
  PO_data <<- 0
  PO_data <<- getProgOasisForProgdata(prgid)
  datatable(
    PO_data,
    rownames = TRUE,
    filter = "none",
    selection = "single",
    colnames = c('Row Number' = 1),
    options = list(
      columnDefs = list(list(visible = FALSE, targets = 0)),
      autoWidth=TRUE,
      scrollX = TRUE,
      #scrollY = 250,
      pageLength = 5,
      rowCallback = JS('function(nRow, aData, iDisplayIndex, iDisplayIndexFull) {
                        //$("table").css("width", "1400px");
                       //$("th").css("background-color", "#F5A9BC");
                       $("th").css("text-align", "center");
                       $("td", nRow).css("font-size", "12px");
                       $("td", nRow).css("text-align", "center");
}')
        )
      )
}

drawPOFilestable <- function(prgoasisid){
  query <- NULL
  query <- paste0("exec dbo.getProgOasisFileDetails ", prgoasisid)
  loginfo(paste("In drawPOFilestable: ", query), logger="flamingo.module")
  progfiles <<- execute_query(query)
  datatable(
    progfiles,
    rownames = TRUE,
    filter = "none",
    selection = "none",
    colnames = c('Row Number' = 1),
    options = list(
      columnDefs = list(list(visible = FALSE, targets = 0)),
      autoWidth=TRUE,
      pageLength = 20,
      rowCallback = JS('function(nRow, aData, iDisplayIndex, iDisplayIndexFull) {
                        //$("table").css("width", "1400px");
                       //$("th").css("background-color", "#F5A9BC");
                       $("th").css("text-align", "center");
                       $("td", nRow).css("font-size", "12px");
                       $("td", nRow).css("text-align", "center");
}')
        )
      )
  }

#observer to display prog oasis files
observe({
  input$tableProgOasisOOK
  if(input$em == "defineProg"){
    if(length(input$tableProgOasisOOK_rows_selected) > 0){
      shinyjs::show("divprogoasisfiles")
      progoasis_id <- toString(PO_data[input$tableProgOasisOOK_rows_selected,1])
      output$tabledisplayprogoasisfiles <- DT::renderDataTable({drawPOFilestable(progoasis_id)})
    } else{
      shinyjs::hide("divprogoasisfiles")
    }
  }
})

#onclick of create prog oasis in main panel
onclick("abuttonmaincreateprog",{
  shinyjs::show("divsidebardefprog")
  shinyjs::show("obtainoasiscrtprgdiv")

  programme = {getProgrammeList()}
  updateSelectInput(session, "sinputookprogid", choices = programme, selected = DPProgdata[input$tableDPprog_rows_selected,1])
  
  models = {getModelsList()}
  updateSelectInput(session, "sinputookmodelid", choices = models, selected = c("Select Model"= 0))
  
  updateSelectInput(session, "sinputProgModTransform", choices= getTransformNameCanModel(), selected=c("Select Transform" = 0))
  
})


#onclick of cancel create prog oasis
onclick("abuttoncancreateprog", {
  shinyjs::hide("obtainoasiscrtprgdiv")
  shinyjs::hide("divsidebardefprog")
  clearooksidebar()
})

#function to create prog oasis
createProgOasis <- function(progid, modelid, transformid){
  res <- NULL
  query <- NULL
  query <- paste("exec dbo.createProgOasis ",progid, ", " ,modelid, ", " ,transformid)
  res <- execute_query(query)
  return(res)
}

#on click of create prog oasis button
onclick("abuttoncrprogoasis",{
  if(isolate(input$sinputookprogid)>0 && isolate(input$sinputookmodelid)>0){
    crtprogoasis <- createProgOasis(isolate(input$sinputookprogid), isolate(input$sinputookmodelid), isolate(input$sinputProgModTransform))
    info(paste("Prog Oasis id:",crtprogoasis,  " created."))
    clearooksidebar()
    shinyjs::hide("obtainoasiscrtprgdiv")
    shinyjs::hide("divsidebardefprog")
    output$tableProgOasisOOK <- DT::renderDataTable({
      drawPOtableOOK(DPProgdata[input$tableDPprog_rows_selected,1])})
  }else{
    info("Please select both the fields.")
  }
}
)

clearooksidebar<-function(){
  programme = {getProgrammeList()}
  updateSelectInput(session, "sinputookprogid", choices = programme, selected = c("Select Programme"= 0))
  
  models = {getModelsList()}
  updateSelectInput(session, "sinputookmodelid", choices = models, selected = c("Select Model"= 0))
  
  updateSelectInput(session, "sinputProgModTransform", choices= getTransformNameCanModel(), selected=c("Select Transform" = 0))
}


#on click of prog oasis refresh table
onclick("abuttonprgoasisrfsh", {
  output$tabledisplayprogoasisfiles <- DT::renderDataTable({
    drawPOFilestable(PO_data[input$tableProgOasisOOK_rows_selected, 1])})
})

#on click of Programme model table refresh
onclick("abuttonookrefresh", {output$tableProgOasisOOK <- DT::renderDataTable({
  drawPOtableOOK(DPProgdata[input$tableDPprog_rows_selected,1])})
})

########## LoadProgrammeModelData ######################
#A function to load Programme model
loadprogrammemodel <- function(){
  url_rp <- NULL
  flag <- 1
  tryCatch({
    progoasisid <- toString(PO_data[input$tableProgOasisOOK_rows_selected,1])
    url <- paste0("http://",flamingo_server_ip,":",port,"/loadprogrammemodel/", progoasisid)
    url_rp <- GET(url, as = "text")
    status <- http_status(url_rp)
    flag <- status[[1]]
    warn_for_status(url_rp)
    loginfo(paste("In loadprogrammemodel trycatch:",status), logger="flamingo.module")
  }, warning = function(war) {
    flag <- status[[1]]
    loginfo(paste("In loadprogrammemodel Warning: ", war), logger="flamingo.module")
    #return(NULL)
  }, error=function(e) {
    flag <- status[[1]]
    loginfo(paste("In loadprogrammemodel Error:", e), logger="flamingo.module")
    #return(NA)
  }, finally = {
    loginfo(paste("In loadprogrammemodel Finally:", url), logger="flamingo.module")
    return(flag)
  }
  )
}

#on click of load programme model
onclick("abuttonloadprogmodel",{
  if(length(input$tableProgOasisOOK_rows_selected) > 0){
#     res <- NULL
#     query <- paste0("exec dbo.LoadProgrammeModelData ",PO_data[input$tableProgOasisOOK_rows_selected, 1])
#     res <- execute_query(query)
#     progmodres <- unlist(res)
#     #names(progmodres) <- progmodres
#     if (is.null(res)) {
#       info(paste("Failed to load Programme model- ", PO_data[input$tableProgOasisOOK_rows_selected, 1]))
#     }else{
#       info(paste("Result: ", progmodres))
    loadprogmodel <- loadprogrammemodel()
    if(loadprogmodel == 'success' || loadprogmodel == 'Success'){
      info("Initiating load programme model..")
      progoasis_id <- toString(PO_data[input$tableProgOasisOOK_rows_selected,1])
      output$tabledisplayprogoasisfiles <- DT::renderDataTable({drawPOFilestable(progoasis_id)})
    }else{
      info("Failed to load programme model.")
    }
  }else{
    info("Please select a Prog Oasis to load Programme model.")
  }
  
})

######################################### Navigation to Process run screen ##########################

#navigation to Define process
onclick("abuttongotoprocessrun",{
  if(length(input$tableProgOasisOOK_rows_selected) > 0){
    prog_oasisid <<- toString(PO_data[input$tableProgOasisOOK_rows_selected,1])
    #info(prog_oasisid)
    active_menu <<- "WF"
    output$menu<-reactive({active_menu})
    updateTabsetPanel(session, "pr", selected = "processrun")
  }else{info("Please select a ProgOasis Id to navigate to Process Run.")}
})


######################################## Export to Excel #####################################################
#### Programme
output$DPPdownloadexcel <- downloadHandler(
  filename ="programmelist.csv",
  content = function(file) {
    write.csv(DPProgdata, file)}
)


