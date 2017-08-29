# (c) 2013-2016 Oasis LMF Ltd.  Software provided for early adopter evaluation only.
# define Company

############################################## Global Variables #####################################
Compdata <- 0
comp_flag <<- ""
############################################### functions ###########################################

# populates the options for the dropdown (sinputcompany) select input (All option not included)
getcompanylist <- function() {
  res <- NULL
  res <- execute_query(paste("exec dbo.getCompanies"))
  return(res)
}

# draw company table with custom format options, queries the database every time to update its dataset
drawCompanytable <- function(){
  Compdata <<- getcompanylist()
  output$tablecompanylist <- DT::renderDataTable({
  datatable(
    Compdata,
    rownames = TRUE,
    filter = "none",
    selection = "single",
    colnames = c('Row Number' = 1),
    options = list(
      columnDefs = list(list(visible = FALSE, targets = 0)),
      autoWidth=TRUE,
      rowCallback = JS('function(nRow, aData, iDisplayIndex, iDisplayIndexFull) {
                       ////$("th").css("background-color", "#F5A9BC");
                       $("th").css("text-align", "center");
                       $("td", nRow).css("font-size", "12px");
                       $("td", nRow).css("text-align", "center");
}')
  )
      )
  })
  }

#Clear Side Bar Panel
clearCmpnySideBar <- function(){
  updateTextInput(session, "tinputCompName", value = "")
  updateTextInput(session, "tinputCompDom", value = "")
  updateTextInput(session, "tinputCompLegName", value = "")
  updateTextInput(session, "tinputCompRegNo", value = "")
}

###################################### goto Main Menu ##########################################
#An Observer function to switch to Landing page if the user clicks on Main Menu
observe({
  input$ua
  if (input$ua == "ualp")
  {
    #cat(paste("From User Admin to Landing Page, Userid: ", user_id, Sys.time(), "\n"), file=stderr())
    loginfo(paste("From User Admin to Landing Page, Userid: ", user_id, Sys.time()), logger="flamingo.module")
    active_menu <<- "LP"
    output$menu<-reactive({active_menu})    
  }
})


############################################### Draw Tables ###########################################

#Render Company user list data when the page is loaded, calls the drawCULtable function
observe({
  input$ua
  if (input$ua == "definecompany") {
    drawCompanytable()
  }
})

########################################## Company Create / Update / Delete ###################################

#onclick of cancel button in pop-up
onclick("abuttonccancel", {
  toggleModal(session, "compcrtupmodal", toggle = "close")
  clearCmpnySideBar()
  drawCompanytable()
})

#onclick of create button in main panel
onclick("abuttoncompcrt", {
  comp_flag <<- "C"
  clearCmpnySideBar()
})

#on click of update button in main panel
onclick("abuttoncompupdate", {
  if(length(input$tablecompanylist_rows_selected) > 0){
    comp_flag <<- "U"
    updateTextInput(session, "tinputCompName", value = Compdata[input$tablecompanylist_rows_selected, 2])
    updateTextInput(session, "tinputCompDom", value = Compdata[input$tablecompanylist_rows_selected, 3])
    updateTextInput(session, "tinputCompLegName", value = Compdata[input$tablecompanylist_rows_selected, 4])
    updateTextInput(session, "tinputCompRegNo", value = Compdata[input$tablecompanylist_rows_selected, 5])  
    toggleModal(session, "compcrtupmodal", toggle = "open")
  } else{
      info("Please select the company to update.")
    }
  })

#on click of delete button in main panel
onclick("abuttoncompdel", {
  if(length(input$tablecompanylist_rows_selected) > 0){
    toggleModal(session, "compdelmodal", toggle = "open")
#     output$companydelete <- renderUI({
#       delcontent <- paste("Are you sure want to delete company: ", Compdata[input$tablecompanylist_rows_selected, 2], "?")
#       HTML(paste(delcontent))
#     })
  } else{
    info("Please select the company to delete")
  }
})

#on click of cancel button in delete modal
onclick("abuttonccanceldel", {
  toggleModal(session, "compdelmodal", toggle = "close")
  drawCompanytable()
})


#onclick of submit button in pop-up
onclick("abuttonsubcomp",{
  res <- NULL
  if (comp_flag == "C"){
    query <- paste0("exec dbo.createCompany '",input$tinputCompName,"', '", input$tinputCompDom, "', '", input$tinputCompLegName, "', '", input$tinputCompRegNo, "'")
    res <- execute_query(query)
    if (is.null(res)) {
      info(paste("Failed to create company - ", input$tinputCompName))
    }else{
      info(paste("Company ", input$tinputCompName, " created."))
    }
  }else{
    if (comp_flag == "U"){
      query <- paste0("exec dbo.updateCompany ", Compdata[input$tablecompanylist_rows_selected, 1], ", '", input$tinputCompName,"', '", input$tinputCompDom, "', '", input$tinputCompLegName, "', '", input$tinputCompRegNo, "'")
      res <- execute_query(query)
      if (is.null(res)) {
        info(paste("Failed to update company - ", Compdata[input$tablecompanylist_rows_selected, 2]))
      }else{
        info(paste("Company -", Compdata[input$tablecompanylist_rows_selected, 2], " updated."))
      }
    }}
  comp_flag <<- ""
  toggleModal(session, "compcrtupmodal", toggle = "close")
  drawCompanytable()
})

#confirm delete
onclick("abuttoncconfirmdel",{
  toggleModal(session, "compdelmodal", toggle = "close")
  if(length(input$tablecompanylist_rows_selected) > 0){
    query <- paste0("exec dbo.deleteCompany ", Compdata[input$tablecompanylist_rows_selected, 1])
    res <- execute_query(query)
    if (is.null(res)) {
      info(paste("Failed to delete company - ", Compdata[input$tablecompanylist_rows_selected, 2]))
    }else{
      info(paste("Company -", Compdata[input$tablecompanylist_rows_selected, 2], " deleted."))
    }
    clearCmpnySideBar()
    drawCompanytable() 
  }
})


