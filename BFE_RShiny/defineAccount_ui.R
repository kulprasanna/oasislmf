# (c) 2013-2016 Oasis LMF Ltd.  Software provided for early adopter evaluation only.
tabPanel("Define Account", value = "defineAccount",
         br(),
         br(),
         #Title Text
         h3("Define Account", align = "center"),
         
         sidebarLayout(
           fluid = FALSE,
           shinyjs::hidden(div(id = "divsidebardefacc",
           sidebarPanel(width=3,
                           helpText(h4("Create/Amend Account")),
                           textInput("tinputDAAccountName", "Account Name"),
                           actionButton("abuttonAccSubmit",  class="btn btn-primary",label = "Submit", align = "left"),
                           actionButton("abuttonAccCancel", class = "btn btn-primary", label = "Cancel", align = "right"))
           )),
#            shinyjs::hidden(div(id = "divsidebaraccount",
#                                sidebarPanel(width=3, 
#                                             #shinyjs::hidden(div(id = "divamdaccount",
#                                                                 helpText(h4("Create/Amend Account")),
#                                                                 textInput("tinputDAAccountName", "Account Name"),
#                                                                 actionButton("abuttonAccSubmit",  class="btn btn-primary",label = "Submit", align = "left"),
#                                                                 actionButton("abuttonAccCancel", class = "btn btn-primary", label = "Cancel", align = "right")
#                                             #))
#                            ))),
            mainPanel(
              br(),
              helpText(h4("Account Table")),
              DT::dataTableOutput("tableDAAccount"),
              downloadButton("DAAdownloadexcel",label="Export to Excel"),
              actionButton("buttoncreateac", "Create Account", class="btn btn-primary", align = "left"),
              actionButton("buttonamendac", "Amend Account", class="btn btn-primary", align = "centre"),
              actionButton("buttondeleteac", "Delete Account", class="btn btn-primary", align = "right")
#               bsModal("userdelmodal", "Are you sure you want to delete?", trigger = "", size = "medium",
#                       br(),
#                       actionButton("abuttonuconfirmdel", class="btn btn-primary",label = "Confirm", align = "center"),
#                       actionButton("abuttonucanceldel", class = "btn btn-primary", label = "Cancel", align = "right")),
            )
  ))  