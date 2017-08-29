# (c) 2013-2016 Oasis LMF Ltd.  Software provided for early adopter evaluation only.
######################################### Functions ######################################################
#draw table function
drawenqaccounttable <- function(){
  #executes query
  AccountEnqdata <<- NULL
  query <- paste0("exec dbo.getAccount")
  AccountEnqdata <<- execute_query(query)
  #table properties
  datatable(
    #what data to use
    AccountEnqdata,
    #options
    rownames = TRUE,
    filter = "none",
    selection = "single",
    colnames = c('Row Number' = 1),
    options = list(
      columnDefs = list(list(visible = FALSE, targets = 0)),
      autoWidth=TRUE,
      scrollX = TRUE,
      rowCallback = JS('function(nRow, aData, iDisplayIndex, iDisplayIndexFull) {
                       //$("th").css("background-color", "#F5A9BC");
                       $("th").css("text-align", "center");
                       $("td", nRow).css("font-size", "12px");
                       $("td", nRow).css("text-align", "center");
}')
    )
  )
}

observe({
  input$tableEnqaccounts_rows_selected
  if (input$enq == "enquiry") {
  if(length(input$tableEnqaccounts_rows_selected) > 0){
    AccountEnqID <<- AccountEnqdata[(input$tableEnqaccounts_rows_selected),1]}}})


drawEnqprogtable <- function(){
  query <- paste0("exec dbo.getEnquiryProgForAccount ", AccountEnqID)
  EnqProgdata <<- NULL
  EnqProgdata <<- execute_query(query)
  datatable(
    EnqProgdata,
    rownames = TRUE,
    filter = "none",
    selection = "single",
    colnames = c('Row Number' = 1),
    options = list(
      columnDefs = list(list(visible = FALSE, targets = 0)),
      autoWidth=TRUE,
      scrollX = TRUE,
      rowCallback = JS('function(nRow, aData, iDisplayIndex, iDisplayIndexFull) {
                       //$("th").css("background-color", "#F5A9BC");
                       $("th").css("text-align", "center");
                       $("td", nRow).css("font-size", "12px");
                       $("td", nRow).css("text-align", "center");
}')
    )
      )
}

observe({
  input$tableEnqprog_rows_selected
  if (input$enq == "enquiry") {
  if(length(input$tableEnqprog_rows_selected) > 0){
    EnqPolicyID <<- EnqProgdata[(input$tableEnqprog_rows_selected),1]}}})

drawEnqFiletable <- function(){
  query <- NULL
  EnqFiledata <<- NULL
  query <- paste0("exec dbo.getFileViewerTableForProgID ",EnqPolicyID)
  EnqFiledata <<- execute_query(query)
  datatable(
    EnqFiledata,
    rownames = TRUE,
    filter = "bottom",
    selection = "single",
    colnames = c('Row Number' = 1),
    options = list(
      columnDefs = list(list(visible = FALSE, targets = 0)),
      autoWidth=TRUE,
      rowCallback = JS('function(nRow, aData, iDisplayIndex, iDisplayIndexFull) {
                         //$("th").css("background-color", "#F5A9BC");
                         $("th").css("text-align", "center");
                         $("td", nRow).css("font-size", "12px");
                         $("td", nRow).css("text-align", "center");
                         }')
    )
  )
}

drawEnqPolicytable <- function(){
  query <- paste("exec dbo.getPoliciesForProgID", EnqPolicyID)
  EnqPodata <<- NULL  
  EnqPodata <<- execute_query(query)
    datatable(
      EnqPodata,
      rownames = TRUE,
      filter = "none",
      selection = "single",
      colnames = c('Row Number' = 1),
      options = list(
        columnDefs = list(list(visible = FALSE, targets = 0)),
        autoWidth=TRUE,
        scrollX = TRUE,
        rowCallback = JS('function(nRow, aData, iDisplayIndex, iDisplayIndexFull) {
                         //$("th").css("background-color", "#F5A9BC");
                         $("th").css("text-align", "center");
                         $("td", nRow).css("font-size", "12px");
                         $("td", nRow).css("text-align", "center");
  }')
    )
        )
}

observe({
  input$tableEnqfiles_rows_selected
  if (input$enq == "enquiry") {
  if(length(input$tableEnqfiles_rows_selected) > 0){
    EnqFileID <<- EnqFiledata[(input$tableEnqfiles_rows_selected),1]}}})

drawEnqFileContentstable <- function(){
  readFileDataEnq()
#   query <- NULL
#   query <- paste0("exec Flamingo.dbo.getFileViewerTableForProgID ",EnqPolicyID)
  readFileDataEnq()
  datatable(
    EnqFileContentsdata,
    rownames = TRUE,
    filter = "bottom",
    selection = "single",
    colnames = c('Row Number' = 1),
    options = list(
      columnDefs = list(list(visible = FALSE, targets = 0)),
      autoWidth=TRUE,
      rowCallback = JS('function(nRow, aData, iDisplayIndex, iDisplayIndexFull) {
                         //$("th").css("background-color", "#F5A9BC");
                         $("th").css("text-align", "center");
                         $("td", nRow).css("font-size", "12px");
                         $("td", nRow).css("text-align", "center");
                         }')
    )
  )
}

observe({
  input$tableEnqpolicies_rows_selected
  if (input$enq == "enquiry") {
  if(length(input$tableEnqpolicies_rows_selected) > 0){
    enqPolicyID <<- EnqPodata[(input$tableEnqpolicies_rows_selected),1]}}})

drawenqPCtable <- function(){
  query <- paste("exec dbo.getPolicyCoverageForPolicies", enqPolicyID )
  if(is.na(PolicyID)){shinyjs::hide("divpolicycoveragetable")}
  else{
    enqPCdata <<- NULL
    enqPCdata <<- execute_query(query)
    datatable(
      enqPCdata,
      rownames = TRUE,
      filter = "none",
      selection = "none",
      colnames = c('Row Number' = 1),
      options = list(
        columnDefs = list(list(visible = FALSE, targets = 0)),
        autoWidth=TRUE,
        scrollX = TRUE,
        rowCallback = JS('function(nRow, aData, iDisplayIndex, iDisplayIndexFull) {
                         //$("th").css("background-color", "#F5A9BC");
                         $("th").css("text-align", "center");
                         $("td", nRow).css("font-size", "12px");
                         $("td", nRow).css("text-align", "center");
  }')
    )
        )
}
}

#Table2,Tab2

drawenqPVtable <- function(){
  query <- paste("exec dbo.getPolicyValuesForPolicies", enqPolicyID)
  enqPVdata <<- NULL
  enqPVdata <<- execute_query(query)
  datatable(
    enqPVdata,
    rownames = TRUE,
    filter = "none",
    selection = "none",
    colnames = c('Row Number' = 1),
    options = list(
      columnDefs = list(list(visible = FALSE, targets = 0)),
      autoWidth=TRUE,
      scrollX = TRUE,
      rowCallback = JS('function(nRow, aData, iDisplayIndex, iDisplayIndexFull) {
                         //$("th").css("background-color", "#F5A9BC");
                         $("th").css("text-align", "center");
                         $("td", nRow).css("font-size", "12px");
                         $("td", nRow).css("text-align", "center");
  }')
    )
  )
}

readFileDataEnq <- function () {
  EnqFileContentsdata <<- NULL
  EnqFileContentsdata <<- execute_query(paste("exec dbo.getFileDataForFile",EnqFileID))
  
}



######################################### Observers #####################################################


observe ({
  input$enq
  if (input$enq == "enquiry") {
    # AccountDPTable <- execute_query(paste("getAccountName"))
    # AccountDPChoices <- unlist(AccountDPTable)
    # names(AccountDPChoices) <- AccountDPChoices
    # updateSelectInput(session, "sinputDPAccountName", choices= names(AccountDPChoices))
    output$tableEnqaccounts <- DT::renderDataTable({drawenqaccounttable()})
  }
})

observe({
  input$tableEnqaccounts_rows_selected
  if (input$enq == "enquiry") {
  if (length(input$tableEnqaccounts_rows_selected) > 0) {
    shinyjs::show("divenqprog")
    shinyjs::hide("divfileviewerenq")
    output$tableEnqprog <- DT::renderDataTable({drawEnqprogtable()})
  }
}})

observe({
  input$tableEnqprog_rows_selected
  if (input$enq == "enquiry") {
  if (length(input$tableEnqprog_rows_selected) > 0) {
    shinyjs::show("divenqpoliciestable")
    output$tableEnqpolicies <- DT::renderDataTable({drawEnqPolicytable()})
    output$tableEnqfiles <- DT::renderDataTable({drawEnqFiletable()})
  }
}})

observe({
  input$tableEnqfiles_rows_selected
  if (input$enq == "enquiry") {
  if (length(input$tableEnqfiles_rows_selected) > 0) {
    shinyjs::show("divfileviewerenq")
    output$tableEnqReadFile <- DT::renderDataTable({drawEnqFileContentstable()})
  }
}})

observe({
  input$tableEnqpolicies_rows_selected
  if (input$enq == "enquiry") {
  if (length(input$tableEnqpolicies_rows_selected) > 0) {
    output$tableenqpolicycoverage <- DT::renderDataTable({drawenqPCtable()})
    output$tableenqpolicyvalues <- DT::renderDataTable({drawenqPVtable()})
    shinyjs::show("divenqpolicycoveragetable")
  }
}})


#Export to Excel
output$EnqAdownloadexcel <- downloadHandler(
  filename ="account.csv",
  content = function(file) {
    write.csv(AccountEnqdata, file)}
)

output$EnqProgdownloadexcel <- downloadHandler(
  filename ="programmelist.csv",
  content = function(file) {
    write.csv(EnqProgdata, file)}
)

output$EnqPodownloadexcel <- downloadHandler(
  filename ="policy.csv",
  content = function(file) {
    write.csv(EnqPodata, file)}
)

output$EnqFilesdownloadexcel <- downloadHandler(
  filename ="file.csv",
  content = function(file) {
    write.csv(EnqFiledata, file)}
)

output$EnqFileContentsdownloadexcel <- downloadHandler(
  filename ="FileContents.csv",
  content = function(file) {
    write.csv(EnqFileContentsdata, file)}
)


#################################### Change Page #################################################
onclick("aButtonEnqaccountmaintenance",{
  active_menu <<- "EM"
  output$menu<-reactive({active_menu})
  updateTabsetPanel(session, "em", selected = "defineProg")
})

onclick("aButtonEnqprogmaintenance",{
  active_menu <<- "EM"
  output$menu<-reactive({active_menu})
  updateTabsetPanel(session, "em", selected = "tabloadcanmodel")
})

onclick("aButtonEnqfilemanagement",{
  active_menu <<- "FM"
  output$menu<-reactive({active_menu})
  updateTabsetPanel(session, "fm", selected = "fileviewer")
  output$FVPanelSwitcher <- reactive({FODivTable})
})

### this code should be uncommented after adding Insurance Policy screen
# onclick("aButtonEnqIPT",{
#   active_menu <<- "EM"
#   output$menu<-reactive({active_menu})
#   updateTabsetPanel(session, "em", selected = "insurancepolicyterms")
# })

############################################################### goto Main Menu ##################################################
#An Observer function to switch to Landing page if the user clicks on Main Menu - not necessary on every page
observe({
  input$enq
  if (input$enq == "enqlp")
  {
    #show("lpage")
    #hide("useradmin") 
    loginfo(paste("From Enquiry to Landing Page, Userid: ", user_id, Sys.time()), logger="flamingo.module")
    active_menu <<- "LP"
    output$menu<-reactive({active_menu}) 
    load_inbox()            
  }
})

