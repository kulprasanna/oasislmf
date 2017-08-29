# (c) 2013-2016 Oasis LMF Ltd.  Software provided for early adopter evaluation only.
presel_runid <- -1
presel_filerunid <- -1
presel_procid <- -1

#A function to go to Workflow submenu   
gotopm <- function(){
  loginfo(paste("From Landing Page to Process Management, Userid: ", user_id, Sys.time()), logger="flamingo.module")
  active_menu <<- "WF"
  output$menu<-reactive({active_menu})
  #updateTabsetPanel(session, "pr", selected = "pmtemp")
  updateTabsetPanel(session, "pr", selected = "processrun")
}

#A function to go to Exposure Management submenu   
gotoem <- function(){
  loginfo(paste("From Landing Page to Exposure Management, Userid: ", user_id, Sys.time()), logger="flamingo.module")
  active_menu <<- "EM"
  output$menu<-reactive({active_menu})
  #updateTabsetPanel(session, "em", selected = "emtemp")
  updateTabsetPanel(session, "em", selected = "defineProg")
  
}

#A function to go to User Admin submenu   
gotoua <- function(){
  loginfo(paste("From Landing Page to User Admin, Userid: ", user_id, Sys.time()), logger="flamingo.module")
  active_menu <<- "UA"
  output$menu<-reactive({active_menu})
  #updateTabsetPanel(session, "ua", selected = "uatemp")
  updateTabsetPanel(session, "ua", selected = "definecompany")
}

#A function to go to Workflow Admin submenu   
gotowa <- function(){
  loginfo(paste("From Landing Page to Workflow Admin, Userid: ", user_id, Sys.time()), logger="flamingo.module")     
  active_menu <<- "WA"
  output$menu<-reactive({active_menu})
  #updateTabsetPanel(session, "wa", selected = "watemp")
  updateTabsetPanel(session, "wa", selected = "defineworkflow")
}

#A function to go to File Management submenu   
gotofm <- function(){
  loginfo(paste("From Landing Page to File Management, Userid: ", user_id, Sys.time()), logger="flamingo.module")
  active_menu <<- "FM"
  output$menu<-reactive({active_menu})
  #updateTabsetPanel(session, "fm", selected = "fmtemp")
  updateTabsetPanel(session, "fm", selected = "fileviewer")
  # force it to show file list.Suspect there's a better way to do this
  # but bit rushed TODO
  output$FVPanelSwitcher <- reactive({FODivTable})
}

#A function to go to System Configuration submenu   
gotosc <- function(){
  loginfo(paste("From Landing Page to System Config, Userid: ", user_id, Sys.time()), logger="flamingo.module")
  active_menu <<- "SC"
  output$menu<-reactive({active_menu})
  #updateTabsetPanel(session, "sc", selected = "sctemp")
  updateTabsetPanel(session, "sc", selected = "Model")
}

#A function to go to Utilities submenu   
# gotout <- function(){
#   loginfo(paste("From Landing Page to Utilities, Userid: ", user_id, Sys.time()), logger="flamingo.module")
#   active_menu <<- "UT"
#   output$menu<-reactive({active_menu})
#   #updateTabsetPanel(session, "ut", selected = "uttemp")
#   updateTabsetPanel(session, "ut", selected = "themes")
# }

gotoenq <- function(){
  loginfo(paste("From Landing Page to Enquiry, Userid: ", user_id, Sys.time()), logger="flamingo.module")         
  active_menu <<- "Enq"
  output$menu<-reactive({active_menu})
  #updateTabsetPanel(session, "enq", selected = "enqtemp")
  #updateTabsetPanel(session, "enq", selected = "tabenquiryinbox")
  updateTabsetPanel(session, "enq", selected = "enquiry")
}



#A function to switch to login page if the user clicks on Logout   
logout <- function (){
  loginfo(paste("In logout, UserID: ", user_id, Sys.time()), logger="flamingo.module")         
  user_id <<- -1
  output$id<-reactive({user_id})
  updateTextInput(session, "userid", label = "", value = "")
  updateTextInput(session, "password", label = "", value = "")
  
}


#A function to get process runs
getinboxdata <- function(userid) {
  res <- NULL
  query <- paste0("exec dbo.getUserProcessDetails ", userid)
  print(query)
  res <- execute_query(query)
  return(res)
}

#A function to go to process run screen
gotorun <- function() {
  if(length(input$tableinbox_rows_selected) == 1) {
    #info(input$tableinbox_rows_selected)
    res <- {getinboxdata(user_id)}
    presel_runid <<- res[c(input$tableinbox_rows_selected), 2]
    presel_procid <<- res[c(input$tableinbox_rows_selected), 1]
    loginfo(paste("Process and ProcessRun selected in Inbox: ", presel_procid, presel_runid), logger="flamingo.module")
    active_menu <<- "WF"
    output$menu<-reactive({active_menu})
    updateTabsetPanel(session, "pr", selected = "processrun")
  }
}

outputOptions(output, 'id', suspendWhenHidden=FALSE)
outputOptions(output, 'menu', suspendWhenHidden=FALSE)

onclick("abuttonprmngt", {gotopm()})
onclick("abuttonexpmngt", {gotoem()})
onclick("abuttonuseradmin", {gotoua()})
onclick("abuttonworkflowadmin", {gotowa()})
onclick("abuttonfilemngt", {gotofm()})
onclick("abuttonlogout", {logout()})
onclick("abuttongotorun", {gotorun()})
onclick("abuttonsysconf", {gotosc()})
onclick("abuttonutilities", {gotout()})
onclick("abuttonenquiry", {gotoenq()})


#Render Inbox table: when a ProcessRun is selected in processrundata table    
#output$tableinbox <- DT::renderDataTable({
load_inbox <- function(){
  if (user_id != -1) {
    output$tableinbox <- DT::renderDataTable({
    res <- {getinboxdata(user_id)}
    #info(res)
    datatable(
      res,
      rownames = TRUE,
      #filter = "bottom",
      selection = "single",
      colnames = c('Row Number' = 1),
      #extensions = 'TableTools',
      options = list(
        columnDefs = list(list(visible = FALSE, targets = 0))
        #dom = 'T<"clear">lfrtip',
        #tableTools = list(sSwfPath = copySWF('www'))
      )
      #colnames = c('Row Number' = 1),
      #tableui <- {getprtable()},
      #style = 'bootstrap'
    )
  })
}
}

onclick("abuttonrefreshinbox", {load_inbox()})
output$PRIdownloadexcel <- downloadHandler(
  filename ="processruninbox.csv",
  content = function(file) {
    write.csv(getinboxdata(user_id), file)}
)


