# (c) 2013-2016 Oasis LMF Ltd.  Software provided for early adopter evaluation only.
tabPanel("Company User Administraton", value = "defineuser",
         br(),
         br(),
         h3("Company User Administration", align = "center"),
             helpText(h4("Company User List")),
             DT::dataTableOutput("tablecompanyuserlist"),
             downloadButton("CUACULdownloadexcel",label="Export to Excel"),
            actionButton("abuttonnewUser",  class="btn btn-primary", label = "Create", align = "left"),
            actionButton("abuttonuserupdate",  class="btn btn-primary",label = "Update", align = "center"),
            actionButton("abuttonuserdelete",  class="btn btn-primary",label = "Delete", align = "right"),
            column(12,
            actionButton("abuttonusersecurity",  class="btn btn-primary",label = "Add/Remove Security Group"),
            actionButton("abuttonuseroasis",  class="btn btn-primary",label = "Add/Remove User License"), align = "right"),
            bsModal("useradmincrtupmodal", "User Details", trigger= "abuttonnewUser", size = "medium",
                      textInput("tinputUserName", "User Name"),
                      selectInput("sinputCompany", "Company Name", choices = c("")),
                      textInput("tinputDepartment", "Department"),
                      textInput("tinputLogin", "Login"),
                      passwordInput("tinputPassword", "Password"),
                      actionButton("abuttonusersubmit",  class="btn btn-primary",label = "Submit", align = "left"),
                      actionButton("abuttonusercancel", class = "btn btn-primary", label = "Cancel", align = "right")),
            bsModal("userdelmodal", "Are you sure you want to delete?", trigger = "", size = "medium",
                    br(),
                    actionButton("abuttonuconfirmdel", class="btn btn-primary",label = "Confirm", align = "center"),
                    actionButton("abuttonucanceldel", class = "btn btn-primary", label = "Cancel", align = "right")),
            bsModal("usersecuritymodal", "Add/Remove Security Groups", trigger = "", size = "medium",
                    br(),
                    selectInput("sinputSecurity", "Select Security Group", choices = c("")),
                    actionButton("abuttonaddsecurity", class="btn btn-primary", label = "Add", align = "left"),
                    actionButton("abuttonrmvsecurity", class="btn btn-primary", label = "Remove", align = "right")),
            bsModal("userlicensemodal", "Add/Remove User Licenses", trigger = "", size = "medium",
                    br(),
                    selectInput("sinputOasisID", "Select Oasis User ID", choices = c("")),
                    actionButton("abuttonaddoasisid", class="btn btn-primary", label = "Add", align = "left"),
                    actionButton("abuttonrmvoasisid", class="btn btn-primary", label = "Remove", align = "right")),
             br(),
             br(),
             shinyjs::hidden(
               div(id = "usgroups",
                    h4("User Security Groups", align = "left"),
                    DT::dataTableOutput(outputId = "tableusersecuritygroups"),
                    downloadButton("CUAUUSGdownloadexcel",label="Export to Excel"),
                    br()
               )#End of div usgroups
             ),#End of hidden for usgroups
             shinyjs::hidden(
               div(id = "ulicenses",
                    h4("User Licenses", align = "left"),
                    DT::dataTableOutput(outputId = "tableuserlicenses"),
                    downloadButton("CUAULdownloadexcel",label="Export to Excel")
               )#End of div ulicenses
             )#End of hidden for ulicense
)