# (c) 2013-2016 Oasis LMF Ltd.  Software provided for early adopter evaluation only.
library(datasets)
library(httr)
library(rjson)
library(RODBC)
library(shinyjs)
library(xml2)
library(logging)

user_id <- -1
active_menu <- -1
buttonupdatemodel_flag <- 0
buttonupdatemodel_counter <- 0
abuttonvalifrmt_counter <- 0
abuttonvalidata_counter <- 0

addHandler(writeToFile, logger="flamingo", file="/var/log/shiny-server/flamingo.log")
loginfo("testing logger", logger="flamingo.module")

port <<- Sys.getenv("FLAMINGO_API_PORT")
flamingo_server_ip <- Sys.getenv("DOCKER_HOST_IP")
server <<- Sys.getenv("FLAMINGO_DB_IP")
dbuid <<- Sys.getenv("FLAMINGO_DB_USERNAME")
dbpwd <<- Sys.getenv("FLAMINGO_DB_PASSWORD")
db_port <<- Sys.getenv("FLAMINGO_DB_PORT")
database <<- Sys.getenv("FLAMINGO_DB_NAME")
dbdriver <<- Sys.getenv("FLAMINGO_DB_DRIVER")

#cat(paste(port, dbdriver, dbuid, dbpwd, database, server), file=stderr())
con_string <<- paste0("DRIVER={FreeTDS};PORT=", db_port, ";server=", server, ";database=", database, ";uid=", dbuid, ";pwd=", dbpwd)
#loginfo(paste(con_string), logger="flamingo.module")

execute_query <- function(query){
  #info(query)
  res <- NULL
  tryCatch({
    #con <- odbcConnect(dbdriver, dbuid, dbpwd)
    con <- odbcDriverConnect(con_string)
    sqlQuery(con, "SET ANSI_NULLS ON")
    sqlQuery(con, "SET ANSI_WARNINGS ON")
    sqlQuery(con, paste("use ", database))
    res <- sqlQuery(con, query)
    odbcClose(con)
  }, warning = function(war) {
    #print(paste("Warning: ", war))
    res <- NULL
  }, error=function(e) {
    #print(paste("Error", e))
    res <- NULL
  }, finally = {
    #print(paste("In Finally:", res))
    return(res)
  }
  )
  #return(res)
}

#Login function
login <- function(pwd, uid) {
  #print("In function Login")
  res <- NULL
  login_query <- paste0("exec dbo.BFELogin '", uid, "', '", pwd, "'")
  res <- execute_query(login_query)
 #info(res) 
if(is.null(res)){
    return(-1)
  }else {
    return(res[1,1])
  }
}

checkmenupermissions <- function(resourceID){
  res <- NULL
  query <- paste("exec dbo.getResourceModeUser", user_id, ",", resourceID )
  res <- execute_query(query)
  return(res)
}

lpbuttonupdate <- function(session){
  #print("Checking Permissions")
  loginfo("Checking Permissions\n", logger="flamingo.module")
  
  permission <- checkmenupermissions("600")
  if(identical(permission[,1], character(0))){
    updateButton(session, "abuttonenquiry", disabled=TRUE)}
  else{updateButton(session, "abuttonenquiry", disabled=FALSE)}
  
  permission <- checkmenupermissions("1000")
    if(identical(permission[,1], character(0))){
    updateButton(session, "abuttonprmngt", disabled=TRUE)}
  else{updateButton(session, "abuttonprmngt", disabled=FALSE)}
  
  permission <- checkmenupermissions("700")
  if(identical(permission[,1], character(0))){
    updateButton(session, "abuttonexpmngt", disabled=TRUE)}
  else{updateButton(session, "abuttonexpmngt", disabled=FALSE)}
  
  permission <- checkmenupermissions("904")
  if(identical(permission[,1], character(0))){
    updateButton(session, "abuttonuseradmin", disabled=TRUE)}
  else{updateButton(session, "abuttonuseradmin", disabled=FALSE)}
  
  permission <- checkmenupermissions("950")
  if(identical(permission[,1], character(0))){
    updateButton(session, "abuttonworkflowadmin", disabled=TRUE)}
  else{updateButton(session, "abuttonworkflowadmin", disabled=FALSE)}
  
  permission <- checkmenupermissions("200") 
  if(identical(permission[,1], character(0))){
    updateButton(session, "abuttonsysconf", disabled=TRUE)}
  else{updateButton(session, "abuttonsysconf", disabled=FALSE)}
  
#   permission <- checkmenupermissions("500")
#   if(identical(permission[,1], character(0))){
#     updateButton(session, "abuttonutilities", disabled=TRUE)}
#   else{updateButton(session, "abuttonutilities", disabled=FALSE)}
  
  permission <- checkmenupermissions("300")
  if(identical(permission[,1], character(0))){
    updateButton(session, "abuttonfilemngt", disabled=TRUE)}
  else{updateButton(session, "abuttonfilemngt", disabled=FALSE)}
}

##############################################Table UI function #######################################
#Function containing table settings/elements can used across screens
gettableui <- function(){
  options = list(rowCallback = JS('function(nRow, aData, iDisplayIndex, iDisplayIndexFull) {
                                        $("table").css("width", "1000px");
                                          //$("th").css("background-color", "#F5A9BC");
                                          $("th").css("text-align", "center");
                                          $("td", nRow).css("font-size", "12px");                                    
                                          $("td", nRow).css("text-align", "center");
    }'),
    search = list(caseInsensitive = TRUE), 
    processing=0,
    pageLength = 10)
  
  return(options)
}



# Define server logic required to summarize and view the 
shinyServer(function(input, output, session) {
  
  output$id<-reactive({user_id})
  output$menu<-reactive({active_menu})

  #An Observer function to perform login action   
  observe({
    input$loginbutton
    if (input$loginbutton > 0) {
      user_id <<- {login(isolate(input$password), isolate(input$userid))}
      if ( user_id == -1) {
        info("Login Failed!")
        #showshinyalert(session,"loginalert", "Incorrect Username or Password",styleclass = "danger")        
      }else {
        lpbuttonupdate(session)
        active_menu <<- "LP"
        query <- paste("SELECT BFEUserName FROM [dbo].[BFEUser] WHERE BFEUserID =", user_id)
        userName <- execute_query(query)
        output$textOutputHeaderData2 <- renderText(paste("User Name:", userName[1,1]))
        load_inbox()
      }
      output$id<-reactive({user_id})
      output$menu<-reactive({active_menu})
    }
    #print("In Observer to login")    
    #info(paste("Userid: ", user_id))
    loginfo(paste("In Login Userid: ", user_id, Sys.time()), logger="flamingo.module")  
    print(Sys.time())
  })
  ####################################### LandingPage Process ##############################################
  source("landingPage_server.R", local=TRUE)
  
  ############################################# Exposure Management ###########################################
  source("defineProg_server.R", local=TRUE)$value
  #source("LoadCanonicalModel_server.R", local=TRUE)$value
  source("defineAccount_server.R", local=TRUE)$value
  #source("expManagement_server.R", local=TRUE)
  #source("canonicalmodel_server.R", local=TRUE)$value
  #source("insurancepolicyterms_server.R", local=TRUE)$value
  #source("obtainOasisKey_server.R", local=TRUE)$value  
    
  ############################################## Process Management #################################################
  #source("defineProcess_server.R", local=TRUE)
  source("processRun_server.R", local=TRUE)
  #source("batch_server.R", local=TRUE)
  
  ###################################### File Management ################################################
  source("fileViewer_server.R", local=TRUE)$value
  #source("fileUpload_server.R", local=TRUE)
  
  ####################################### Enquiry #########################################################
  #source("enquiryinbox_server.R", local=TRUE)$value
  source("enquirypage_server.R", local=TRUE)$value
  
  ######################################### System Config ##################################
  #source("modelsupplier_server.R", local=TRUE)$value
  #source("supplierservices_server.R", local=TRUE)$value
  source("model_server.R", local=TRUE)$value
  
  ############################################## Workflow Administration ###########################################
  #source("defineWorkflow_server.R", local=TRUE)
  
  ####################################### User Admin ##############################################
  source("defineUserAdmin_server.R", local=TRUE)$value
  source("defineCompany_server.R", local=TRUE)$value
  #source("resources_server.R", local=TRUE)$value
  #source("licenses_server.R", local=TRUE)$value
  
  ####################################### Utilities #########################################################
  #source("themes_server.R", local=TRUE)$value

})
