# (c) 2013-2016 Oasis LMF Ltd.  Software provided for early adopter evaluation only.
acc_flag <<- ""

################################################# Account Functions ###########################################
drawDAAccountTable <- function(){
  DAAccountdata <<- NULL
  query <- paste0("exec dbo.getAccount")
  DAAccountdata <<- execute_query(query)
  datatable(
    DAAccountdata,
    rownames = TRUE,
    filter = "none",
    selection = "single",
    colnames = c('Row Number' = 1),
    options = list(
      columnDefs = list(list(visible = FALSE, targets = 0)),
      #autoWidth=TRUE,
      #scrollX = TRUE,
      pageLength = 5,
      rowCallback = JS('function(nRow, aData, iDisplayIndex, iDisplayIndexFull) {
                       $("table").css("width", "1300px");
                       $("th").css("text-align", "center");
                       $("td", nRow).css("font-size", "12px");
                       $("td", nRow).css("text-align", "center");
}')
    )
      )
}

####################### On Click Account ###############################
####### Create Account #######
onclick("buttoncreateac",{
  acc_flag <<- "C"
  shinyjs::show("divsidebardefacc")
  updateTextInput(session, "tinputDAAccountName", value="")
  shinyjs::disable("buttoncreateac")
})

####### Amend Account #######
onclick("buttonamendac",{
  if(length(input$tableDAAccount_rows_selected) > 0) {
    acc_flag <<- "A"
    shinyjs::show("divsidebardefacc")
    updateTextInput(session, "tinputDAAccountName", value=DAAccountdata[input$tableDAAccount_rows_selected,2])
    shinyjs::disable("buttonamendac")
  }else {
    info("Please select an Account to Amend")
  }
})

####### Delete Account #######
onclick("buttondeleteac",{
  if(length(input$tableDAAccount_rows_selected) > 0) {
    query <- paste("exec dbo.deleteAccount", DAAccountdata[input$tableDAAccount_rows_selected,1])
    execute_query(query)
    info(paste("Account ", DAAccountdata[input$tableDAAccount_rows_selected,2], " deleted."))
    output$tableDAAccount <- DT::renderDataTable({drawDAAccountTable()})
  }else {
    info("Please select an Account to Delete")
  }
  
})

######## Submit - Account ########
onclick("abuttonAccSubmit", {
  res <- NULL
  if (acc_flag == "C"){
    query <- paste0("exec dbo.createAccount [",input$tinputDAAccountName,"]")
    res <- execute_query(query)
    if (is.null(res)) {
      info(paste("Failed to create an account - ", input$tinputDAAccountName))
    }else{
      info(paste("Account ", input$tinputDAAccountName, " created."))
    }
  }else {
    if (acc_flag == "A"){
      query <- paste0("exec dbo.updateAccount ",DAAccountdata[input$tableDAAccount_rows_selected,1],",[",input$tinputDAAccountName,"]")
      res <- execute_query(query)
      if (is.null(res)) {
        info(paste("Failed to amend an account - ", DAAccountdata[input$tableDAAccount_rows_selected,2]))
      }else{
        info(paste("Account ", DAAccountdata[input$tableDAAccount_rows_selected,2], " amended."))
      }
    }
  }
  output$tableDAAccount <- DT::renderDataTable({drawDAAccountTable()})
  shinyjs::hide("divsidebardefacc")
  updateTextInput(session, "tinputDAAccountName", value="")
  shinyjs::enable("buttoncreateac")
  shinyjs::enable("buttonamendac")
  acc_flag <<- ""
})

######## Cancel - Account ########
onclick("abuttonAccCancel",{
  shinyjs::hide("divsidebardefacc")
  updateTextInput(session, "tinputDAAccountName", value="")
  shinyjs::enable("buttoncreateac")
  shinyjs::enable("buttonamendac")
  shinyjs::enable("buttonamendpr")
  shinyjs::enable("buttoncreatepr")
  acc_flag <<- ""
})

#### Load Account table
observe ({
  input$em 
  if (input$em == "defineAccount") {
    output$tableDAAccount <- DT::renderDataTable({drawDAAccountTable()})
    acc_flag <<- ""
    shinyjs::hide("divsidebardefacc")
    shinyjs::enable("buttoncreateac")
    shinyjs::enable("buttonamendac")
    shinyjs::enable("buttoncreatepr")
    shinyjs::enable("buttonamendpr")
    #names(AccountDPChoices) <<- AccountDPChoices
  }
})

#An Observer function to switch to Main Menu   
observe({
  input$em
  if (input$em == "emlp")
  {
    #cat(paste("From Exposure Management to Landing Page, Userid: ", user_id, Sys.time(), "\n"), file=stderr())
    loginfo(paste("From Exposure Management to Landing Page, Userid: ", user_id, Sys.time()), logger="flamingo.module")
    active_menu <<- "LP"
    output$menu<-reactive({active_menu})
    load_inbox()
  }
})