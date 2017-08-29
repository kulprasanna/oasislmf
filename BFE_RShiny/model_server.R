# (c) 2013-2016 Oasis LMF Ltd.  Software provided for early adopter evaluation only.
# modelsupplier_server.R
# model supplier page

############################################################## Global Variables ####################################################
MID <<- -1
Mdata <<- 0

############################################################# Functions ##############################################


drawModellisttable <- function(){
  query <- paste0("exec dbo.getmodel")
  Mdata <<- NULL
  Mdata <<- execute_query(query)
  datatable(
    Mdata,   
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


drawmrtable <- function(){
  MID <<- Mdata[(input$tablemodel_rows_selected),1]
  query <- paste("exec dbo.getmodelresource", MID)
  mrdata <<- NULL
  mrdata <<- execute_query(query)
  output$mrtable <- DT::renderDataTable({
  datatable(
    mrdata,
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
})
  }

# function to fetch resource type name and ID
getresourcetype <- function(){
  res <- NULL
  res <- execute_query(paste("exec dbo.getResourceType"))
  rows <- nrow(res)
  if (rows > 0) {
    s_options2 <- list()
    s_options2[[print("Select Resource Type")]] <- print("0")
    for (i in 1:rows){
      s_options2[[paste(sprintf("%s", res[i, 2]))]] <-
        paste0(sprintf("%s", res[i, 1]))
    }
    return(s_options2)
  }
  return(res)
}

#function to fetch oasis model family version
getoasismfversion <- function(){
  res <- NULL
  res <- execute_query(paste("exec dbo.getOasisModelFamilyVersion"))
  rows <- nrow(res)
  if (rows > 0) {
    s_options2 <- list()
    s_options2[[print("Select Oasis MF Version")]] <- print("0")
    for (i in 1:rows){
      s_options2[[paste(sprintf("%s", res[i, 1]))]] <-
        paste0(sprintf("%s", res[i, 2]))
    }
    return(s_options2)
  }
  return(res)
}

# function to get oasis system id
getoasissystemid <- function(){
  res <- NULL
  res <- execute_query(paste("exec dbo.getOasisSystemID"))
  rows <- nrow(res)
  if (rows > 0) {
    s_options2 <- list()
    s_options2[[print("Select Oasis System")]] <- print("0")
    for (i in 1:rows){
      s_options2[[paste(sprintf("%s", res[i, 2]))]] <-
        paste0(sprintf("%s", res[i, 1]))
    }
    return(s_options2)
  }
  return(res)
}

# function to get model
getmodel <- function(){
  res <- NULL
  res <- execute_query(paste("exec dbo.getmodel"))
  rows <- nrow(res)
  if (rows > 0) {
    s_options2 <- list()
    s_options2[[print("Select Model")]] <- print("0")
    for (i in 1:rows){
      s_options2[[paste(sprintf("%s", res[i, 2]))]] <-
        paste0(sprintf("%s", res[i, 1]))
    }
    return(s_options2)
  }
  return(res)
}

# function to create model resource
createmodresrec <- function(modresname, restype, oasissys, modelid, modresval){
  res <- NULL
  query <- NULL
  query <- (paste0("exec dbo.createModelResource ","'", modresname , "', ",restype , ", ", oasissys, ",",modelid, ",'", modresval, "'"))
  res <- execute_query(query)
  return(res)
  
}

# function to update model resource
updatemodres <- function(modresid, modresname, restype, oasissys, modelid, modresval){
  res <- NULL
  query <- NULL
  query <- (paste0("exec dbo.updateModelResource ",modresid , ",'", modresname , "', ",restype , ", ", oasissys, ",",modelid, ",'", modresval, "'"))
  res <- execute_query(query)
  return(res)
}

# function to delete model resource
deletemodres <- function(modresid){
  res <- NULL
  query <- NULL
  query <- (paste0("exec dbo.deleteModelResource ",modresid ))
  res <- execute_query(query)
  return(res)  
}

############################################################### Draw Tables ##############################################

# when navigated to Model tab, model table should be displayed
output$tablemodel <- DT::renderDataTable({
  input$sc
  if (input$sc == "Model") {
    shinyjs::hide("divmr")
    shinyjs::hide("cramndelmodres")
    shinyjs::hide("submitmodrescreate")
    shinyjs::hide("ConfirmModResDel")
    drawModellisttable()
  }
})


# Model resource table to be displayed at the click a row of Model table
observe({
  input$tablemodel_rows_selected
  if(length(input$tablemodel_rows_selected) > 0) {
    shinyjs::show("divmr")
    drawmrtable()
  }else{
       shinyjs::hide("divmr")
       shinyjs::hide("cramndelmodres")
       shinyjs::hide("submitmodrescreate")
       shinyjs::hide("ConfirmModResDel")
      }
})

#Auto fill based on row selection of model resource in sidebar
observe({
  input$mrtable_rows_selected
  if (input$sc == "Model") {
    if(length(input$mrtable_rows_selected) > 0){
      updateTextInput(session, "tinmodelresname", value = mrdata[input$mrtable_rows_selected,2])
      resourcetype <- {getresourcetype()}
      ressel <- mrdata[input$mrtable_rows_selected,3]
      updateSelectInput(session, "sinresrctype", choices = resourcetype, selected = ressel)
      #oasismfver <- {getoasismfversion()}
      #updateSelectInput(session, "sinoasismfvername", choices = oasismfver, selected = mrdata[input$mrtable_rows_selected,5])
      oasissys <- {getoasissystemid()}
      updateSelectInput(session, "sinoasissysname", choices = oasissys, selected = mrdata[input$mrtable_rows_selected,4])
      updateTextInput(session, "tinmodelresvalue", value = mrdata[input$mrtable_rows_selected,6])
      shinyjs::show("crudmodres")
    } else {
      #shinyjs::hide("cramndelmodres")
      clearmodressidebar()
    }
  }
})

#clear fields on sidebar panel
clearmodressidebar<- function(){
  updateTextInput(session, "tinmodelresname", value = "")
  resourcetype <- {getresourcetype()}
  updateSelectInput(session, "sinresrctype", choices = resourcetype, selected = c("Select Resource Type"=0))
  
  #oasismfver <- {getoasismfversion()}
  #updateSelectInput(session, "sinoasismfvername", choices = oasismfver, selected = c("Select Oasis MF Version"=0))
  
  oasissys <- {getoasissystemid()}
  updateSelectInput(session, "sinoasissysname", choices = oasissys, selected = c("Select Oasis System"=0))
  
  updateTextInput(session, "tinmodelresvalue", value = "")
  shinyjs::show("crudmodres")
}

# on click of Create/Update/Delete button (either by table row selection or
#just by clicking the button sidebar) is displayed
onclick("abuttoncrtudptdelmodres", {
        if(length(input$mrtable_rows_selected) > 0){
          shinyjs::show("cramndelmodres")
          shinyjs::hide("submitmodrescreate")
          shinyjs::hide("ConfirmModResDel")
        }else{
          clearmodressidebar()
          shinyjs::show("cramndelmodres")
          shinyjs::hide("submitmodrescreate")
          shinyjs::hide("ConfirmModResDel")
        }
  }
)

# on click of create button in sidebar submit and cancel create buttons are displayed
onclick("abuttoncreatemodres",{
        shinyjs::hide("crudmodres")
        shinyjs::show("submitmodrescreate")
        shinyjs::hide("ConfirmModResDel")
})

# on click of submit button, new model resource record is created
onclick("abuttonsubmodres",{
        if(input$tinmodelresname >0 && (isolate(input$sinresrctype)>0) && (isolate(input$sinoasissysname)>0) && input$tinmodelresvalue >0){
          crtmodres <- createmodresrec(input$tinmodelresname, isolate(input$sinresrctype), isolate(input$sinoasissysname), MID, input$tinmodelresvalue)
          info(paste("Model Resource ", crtmodres, " created."))
          shinyjs::show("crudmodres")
          shinyjs::hide("submitmodrescreate")
          shinyjs::hide("ConfirmModResDel")
          clearmodressidebar()
          drawmrtable()
        } else{info("Please fill all the fields.")}
})

# model resource record is updated by modres table row selection and click of update button
onclick("abuttonupdatemodres",{
    if(length(input$mrtable_rows_selected) > 0){
      updtmodres <- updatemodres(mrdata[input$mrtable_rows_selected,1], input$tinmodelresname, isolate(input$sinresrctype), isolate(input$sinoasissysname), MID, input$tinmodelresvalue)
      info(paste("Model Resource ", updtmodres, " updated."))
      shinyjs::show("crudmodres")
      shinyjs::hide("submitmodrescreate")
      shinyjs::hide("ConfirmModResDel")
      clearmodressidebar()
      drawmrtable()
    }else{
        info("Please select a Model Resource to update.")
    }
  
})


# closes the sidebar panel when cancel button is clicked
onclick("abuttoncancelmodres",{
        shinyjs::hide("cramndelmodres")
        clearmodressidebar()
})

# at the click of delete button, confirm delete div is displayed
onclick("abuttondeldelres",{
  if(length(input$mrtable_rows_selected) > 0){
        shinyjs::hide("crudmodres")
        shinyjs::hide("submitmodrescreate")
        shinyjs::show("ConfirmModResDel")
  }else{
    info("Please select a Model Resource to delete.")
       }
})

#confirm delete and model resource record is deleted
onclick("abuttonconmodresdelete",{
  if(length(input$mrtable_rows_selected) > 0){
    delmodres <- deletemodres(mrdata[input$mrtable_rows_selected,1])
    info(paste("Model Resource ", delmodres, " deleted."))
    shinyjs::show("crudmodres")
    shinyjs::hide("submitmodrescreate")
    shinyjs::hide("ConfirmModResDel")
    clearmodressidebar()
    drawmrtable() 
}})

# to cancel delete of model resource record
onclick("abuttoncancelmodresdelete",{
  shinyjs::show("crudmodres")
  shinyjs::hide("submitmodrescreate")
  shinyjs::hide("ConfirmModResDel")
}
)

# to cancel creation of new model resource record
onclick("abuttoncancelmodrescrt",{
  clearmodressidebar()
  shinyjs::show("crudmodres")
  shinyjs::hide("submitmodrescreate")
  shinyjs::hide("ConfirmModResDel")
}
)


output$Modeldownloadexcel <- downloadHandler(
  filename ="model.csv",
  content = function(file) {
    write.csv(Mdata, file)}
)


output$MRdownloadexcel <- downloadHandler(
  filename ="modelresource.csv",
  content = function(file) {
    write.csv(mrdata, file)}
)

############################################################### goto Main Menu ##################################################
#An Observer function to switch to Landing page if the user clicks on Main Menu - not necessary on every page
observe({
  input$sc
  if (input$sc == "sclp")
  {
    loginfo(paste("From System Config to Landing Page, Userid: ", user_id, Sys.time()), logger="flamingo.module")      
    active_menu <<- "LP"
    output$menu<-reactive({active_menu})    
  }
})