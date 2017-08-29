# (c) 2013-2016 Oasis LMF Ltd.  Software provided for early adopter evaluation only.
# define user Admin

# Server side script for accessing the Company User List for Flamingo in association with OASIS LMF

############################################## Global Variables #####################################
UserID <- -1 # when no user is selected user ID is reset to -1
CULdata <- 0
useradminflg <<- ""
############################################### functions ###########################################

checkuapermissions <- function(){
  res <- NULL
  query <- paste0("exec dbo.getResourceModeUser ", user_id, ", 905")
  res <- execute_query(query)
  return(res)
}

# populates the options for the dropdown (sinputcompany) select input (All option not included)
getcomplist <- function() {
  res <- NULL
  #res <- execute_query(paste("select CompanyName, CompanyID from dbo.Company where deleted = 0"))
  res <- execute_query(paste("exec dbo.getCompanies"))
  rows <- nrow(res)
  if (rows > 0) {
    s_options2 <- list()
    s_options2[[("Select Company")]] <- ("0")
    for (i in 1:rows){
      s_options2[[paste(sprintf("%s", res[i, 2]))]] <- paste0(sprintf("%s", res[i, 1]))
    }
    return(s_options2)
  }
  return(res)
}

# populates the options for the dropdown (sinputSecurity) select input (All option included)
getsecuritylist <- function() {
  res <- NULL
  #res <- execute_query(paste("select SecurityGroupID, SecurotyGroupName from dbo.SecurityGroup"))
  res <- execute_query(paste("exec dbo.getSecurityGroups"))
  rows <- nrow(res)
  if (rows > 0) {
    s_options2 <- list()
    s_options2[[("All")]] <- ("0")
    for (i in 1:rows){
      s_options2[[paste(sprintf("%s", res[i, 2]))]] <- paste0(sprintf("%s", res[i, 1]))
    }
    return(s_options2)
  }
  return(res)
}

# populates the toptions for the dropdown (sinputOasisID) select input (All option not included)
getoasisidlist <- function() {
  res <- NULL
  res <- execute_query(paste("select OasisUserID, OasisUserName from dbo.OasisUser"))
  rows <- nrow(res)
  if (rows > 0) {
    s_options2 <- list()
    s_options2[[("Select Oasis User ID")]] <- ("0")
    for (i in 1:rows){
      s_options2[[paste(sprintf("%s", res[i, 2]))]] <- paste0(sprintf("%s", res[i, 1]))
    }
    return(s_options2)
  }
  return(res)
}

# draw company user list table with custom format options, queries the database every time to update its dataset
drawCULtable <- function(){
  query <- NULL
  query <- paste0("exec dbo.getUsersForCompany")
  CULdata <<- NULL
  CULdata <<- execute_query(query)
  datatable(
    CULdata,
    rownames = TRUE,
    filter = "none",
    selection = "single",
    colnames = c('Row Number' = 1),
    options = list(
      columnDefs = list(list(visible = FALSE, targets = 0)),
      #autoWidth=TRUE,
      rowCallback = JS('function(nRow, aData, iDisplayIndex, iDisplayIndexFull) {
                       ////$("th").css("background-color", "#F5A9BC");
                       $("th").css("text-align", "center");
                       $("td", nRow).css("font-size", "12px");
                       $("td", nRow).css("text-align", "center");
}')
  )
      )
  }

# draw User Securtiy Group table with custom format options, queries the database every time to update its dataset
drawUSGtable <- function(){
  query <- NULL
  USGdata <<- NULL
  query <- paste("exec dbo.getSecurityGroupsForUser ", UserID)
  USGdata <<- execute_query(query)
  datatable(
    USGdata,
    rownames = TRUE,
    selection = "none",
    colnames = c('Row Number' = 1),
    options = list(
      autoWidth=TRUE,
      columnDefs = list(list(visible = FALSE, targets = 0)),
      rowCallback = JS('function(nRow, aData, iDisplayIndex, iDisplayIndexFull) {
                       //$("th").css("background-color", "#F5A9BC");
                       $("th").css("text-align", "center");
                       $("td", nRow).css("font-size", "12px");
                       $("td", nRow).css("text-align", "center");
}'),
    search = list(caseInsensitive = TRUE), 
    processing=0,
    pageLength = 10)
    
    )
  
  }

# draw User License table with custom format options, quries the database every time to update dataset
drawULtable <- function(){
  query <- NULL
  CUAULdata <<- NULL
  query <- paste("exec dbo.getUserLicenses ", UserID)
  CUAULdata <<- execute_query(query)
  datatable(
    CUAULdata,
    rownames = TRUE,
    selection = "none",
    colnames = c('Row Number' = 1),
    options = list( 
      autoWidth = TRUE,
      scrollX = TRUE,
      columnDefs = list(list(visible = FALSE, targets = 0)),
      rowCallback = JS('function(nRow, aData, iDisplayIndex, iDisplayIndexFull) {
                       //$("th").css("background-color", "#F5A9BC");
                       $("th").css("text-align", "center");
                       $("td", nRow).css("font-size", "12px");
                       $("td", nRow).css("text-align", "center");
}'),
    search = list(caseInsensitive = TRUE),
    processing=0,
    pageLength = 10)
    )
  
  }

# queries the database to retrieve department login and password details for selected user,
# only used once hence Deptdata is not global
getDeptdata <- function(){
  query <- NULL
  res <- NULL
  query <- paste("exec dbo.getUserDepartment ", UserID)
  res <- execute_query(query)
  return(res) 
}

# Function to clear the information fields on the left hand side,
# resets UserID global variable to -1
clearFields <- function(){
  UserID <<- -1
  updateTextInput(session, "tinputUserName", value = "")
  updateSelectInput(session, "sinputCompany", selected = c("Select Company"= 0))
  updateTextInput(session, "tinputDepartment", value = "")
  updateTextInput(session, "tinputLogin", value = "")
  updateTextInput(session, "tinputPassword", value = "")
}

############################################## Permission Checking ################################
observe({
  input$ua
  if(input$ua == "defineuser"){
    permission <- checkuapermissions()
    if(identical(permission[,1], character(0))){
      info("You do not have the required permissions to view this page")
      gotoua()
    }
    else{
      if(permission[1,1] == "CRUD"){
                shinyjs::enable("abuttonnewUser")
                shinyjs::enable("abuttonuserupdate")
                shinyjs::enable("abuttonuserdelete")
                shinyjs::enable("abuttonusersecurity")
                shinyjs::enable("abuttonuseroasis")
              }
              else if(permission[1,1] == "R"){
                shinyjs::disable("abuttonnewUser")
                shinyjs::disable("abuttonuserupdate")
                shinyjs::disable("abuttonuserdelete")
                shinyjs::disable("abuttonusersecurity")
                shinyjs::disable("abuttonuseroasis")
              }
              else{
                info("Neither CRUD nor R")
              }
    }
   }
})

############################################### Draw Tables ###########################################

#Render Company user list data when the page is loaded, calls the drawCULtable function
output$tablecompanyuserlist <- DT::renderDataTable({
  input$ua
  if (input$ua == "defineuser") {
    complist <- getcomplist()
    updateSelectInput(session, "sinputCompany", choices = complist, selected = c("Select Company" = 0))
    securitylist <- getsecuritylist()
    updateSelectInput(session, "sinputSecurity", choices = securitylist, selected = c("All" = 0))
    oasisidlist <- getoasisidlist()
    updateSelectInput(session, "sinputOasisID", choices = oasisidlist, selected = c("Select Oasis User ID" = 0))
    shinyjs::hide("usgroups")
    shinyjs::hide("ulicenses")
    clearFields()
    drawCULtable()
  }
})

######################################################## Text Input Updating ############################

# updates the details on the left hand side every time a row is clicked
# uses the list of rows selected to attain row index
# row index is used to access data in table and render it to the left hand side
observe({
  input$tablecompanyuserlist_rows_selected
  if (input$ua == "defineuser") {
  if(length(input$tablecompanyuserlist_rows_selected) > 0){
    UserID <<- CULdata[input$tablecompanyuserlist_rows_selected, 3]
    updateTextInput(session, "tinputID", value = UserID)
    updateTextInput(session, "tinputUserName", value = CULdata[input$tablecompanyuserlist_rows_selected, 4])
    updateSelectInput(session, "sinputCompany", selected = CULdata[(input$tablecompanyuserlist_rows_selected),1])
    Deptdata <- {getDeptdata()}
    updateTextInput(session, "tinputDepartment", value = Deptdata[[3]])
    updateTextInput(session, "tinputLogin", value = Deptdata[[1]])
    updateTextInput(session, "tinputPassword", value = Deptdata[[2]])
    output$tableusersecuritygroups <- DT::renderDataTable({drawUSGtable()})
    shinyjs::show("ulicenses")
    output$tableuserlicenses <- DT::renderDataTable({drawULtable()})
    shinyjs::show("usgroups")
  }else{
    shinyjs::hide("usgroups")
    shinyjs::hide("ulicenses")
    clearFields()
  }
}})

########################################## User Create / Update / Delete ###################################

# onclick of create button
onclick("abuttonnewUser", {
  useradminflg <<- "C"
  clearFields()
})

# cancel new user
# clears the fields, hides confirm cancel, shows CRUD buttons
onclick("abuttonusercancel",{
    toggleModal(session, "useradmincrtupmodal", toggle = "close")
    clearFields()
    output$tablecompanyuserlist <- DT::renderDataTable({drawCULtable()})
})

#on click of update button
onclick("abuttonuserupdate", {
  if(length(input$tablecompanyuserlist_rows_selected) > 0){
    useradminflg <<- "U"
    toggleModal(session, "useradmincrtupmodal", toggle = "open")
  } else{
    info("Please select a user to update details.")
  }
})

#on click of submit button in pop-up to create/update
onclick("abuttonusersubmit",{
  res <- NULL
  if (useradminflg == "C"){
    query <- paste0("exec dbo.CreateNewUser", " [",input$tinputUserName,"]", ", ","[",input$sinputCompany, "]", ", ","[", input$tinputLogin, "]", ", ","[", input$tinputPassword, "]", ", ","[", input$tinputDepartment,"]")
    res <- execute_query(query)
    if (is.null(res)) {
      info(paste("Failed to create new user - ", input$tinputUserName))
    }else{
      info(paste("User ", input$tinputUserName, " created. User id: ", res))
    }
  }else{
    if (useradminflg == "U"){
      query <- paste0("exec dbo.updateUser", " '",UserID,"'", ", ","'",input$tinputUserName,"'", ", ","'",input$sinputCompany, "'", ", ","'", input$tinputLogin, "'", ", ","'", input$tinputPassword, "'", ", ","'", input$tinputDepartment,"'")
      res <- execute_query(query)
      if (is.null(res)) {
        info(paste("Failed to update user - ",input$tinputUserName))
      }else{
        info(paste("User -", input$tinputUserName, " updated."))
      }
    }}
  useradminflg <<- ""
  toggleModal(session, "useradmincrtupmodal", toggle = "close")
  output$tablecompanyuserlist <- DT::renderDataTable({drawCULtable()})
})

#onclick of delete button
onclick("abuttonuserdelete", {
  if(length(input$tablecompanyuserlist_rows_selected) > 0){
    toggleModal(session, "userdelmodal", toggle = "open")
  } else{
    info("Please select a user to delete")
  }
})

#onclick of cancel delete button
onclick("abuttonucanceldel", {
  toggleModal(session, "userdelmodal", toggle = "close")
  output$tablecompanyuserlist <- DT::renderDataTable({drawCULtable()})
})

#onclick of confirm delete button
onclick("abuttonuconfirmdel",{
    query <- paste0("exec dbo.deleteUser", " '",CULdata[input$tablecompanyuserlist_rows_selected, 3],"'")
    res <- execute_query(query)
    if (is.null(res)) {
      info(paste("Failed to delete user - ", CULdata[input$tablecompanyuserlist_rows_selected, 4]))
    }else{
      info(paste("User -", CULdata[input$tablecompanyuserlist_rows_selected, 4], " deleted."))
    }
    clearFields()
    toggleModal(session, "userdelmodal", toggle = "close")
    output$tablecompanyuserlist <- DT::renderDataTable({drawCULtable()}) 
})

##################################################### Security Group Add/Delete #############################################
#onclick of add/remove security button
onclick("abuttonusersecurity", {
  if(length(input$tablecompanyuserlist_rows_selected) > 0){
    securitylist <- getsecuritylist()
    updateSelectInput(session, "sinputSecurity", choices = securitylist, selected = c("All" = 0))
    toggleModal(session, "usersecuritymodal", toggle = "open")
  } else{
    info("Please select a user to add security group")
  }
})

#onclick of add security button in pop-up
onclick("abuttonaddsecurity", {
        query <- paste0("exec dbo.addSecurityGroup", " '",UserID,"'", ", ","'",input$sinputSecurity,"'")
        res <- execute_query(query)
        output$tableusersecuritygroups <- DT::renderDataTable({
          if (length(input$tablecompanyuserlist_rows_selected) > 0) {
            drawUSGtable()
          }
        })
        toggleModal(session, "usersecuritymodal", toggle = "close")
})

#onclick of remove security button
onclick("abuttonrmvsecurity", {
      query <- paste0("exec dbo.removeSecurityGroup", " '",UserID,"'", ", ","'",input$sinputSecurity,"'")
      execute_query(query)
      output$tableusersecuritygroups <- DT::renderDataTable({
        if (length(input$tablecompanyuserlist_rows_selected) > 0) {
          drawUSGtable()
        }
      })
  toggleModal(session, "usersecuritymodal", toggle = "close")
})


################################# Oasis User Id (License) Add/Delete ############################################

#onclick of add/remove license button
onclick("abuttonuseroasis", {
  if(length(input$tablecompanyuserlist_rows_selected) > 0){
    oasisidlist <- getoasisidlist()
    updateSelectInput(session, "sinputOasisID", choices = oasisidlist, selected = c("Select Oasis User ID" = 0))
    toggleModal(session, "userlicensemodal", toggle = "open")
  } else{
    info("Please select a user to add license")
  }
})


#onclick of add license button in pop-up
onclick("abuttonaddoasisid", {
        query <- paste0("exec dbo.addUserLicense", " '",UserID,"'", ", ","'",input$sinputOasisID,"'")
        execute_query(query)
        output$tableuserlicenses <- DT::renderDataTable({
          input$tablecompanyuserlist_rows_selected
          if (length(input$tablecompanyuserlist_rows_selected) > 0){
            drawULtable()
          }
        })
  toggleModal(session, "userlicensemodal", toggle = "close")
})

#onclick of remove license button in pop-up
onclick("abuttonrmvoasisid", {
        query <- paste0("exec dbo.removeUserLicense", " '",UserID,"'", ", ","'",input$sinputOasisID,"'")
        execute_query(query)
        output$tableuserlicenses <- DT::renderDataTable({
          input$tablecompanyuserlist_rows_selected
          if (length(input$tablecompanyuserlist_rows_selected) > 0){
            drawULtable()
          }
        })
  toggleModal(session, "userlicensemodal", toggle = "close")
})


####################################################### Export to Excel ####################################################

#User List
output$CUACULdownloadexcel <- downloadHandler(
  filename ="companyuserlist.csv",
  content = function(file) {
    write.csv(CULdata, file)}
)
#User Security Groups
output$CUAUUSGdownloadexcel <- downloadHandler(
  filename ="usersecuritygroups.csv",
  content = function(file) {
    write.csv(USGdata, file)}
)
#User Licenses
output$CUAULdownloadexcel <- downloadHandler(
  filename ="userlicenses.csv",
  content = function(file) {
    write.csv(CUAULdata, file)}
)