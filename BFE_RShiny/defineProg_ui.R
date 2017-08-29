# (c) 2013-2016 Oasis LMF Ltd.  Software provided for early adopter evaluation only.
tabPanel("Define Prog", value = "defineProg",
         br(),
         br(),
         #Title Text
         h3("Define Programme", align = "center"),
         
         sidebarLayout(
           fluid = FALSE,
           shinyjs::hidden(div(id = "divsidebardefprog",
           sidebarPanel(width=3, 
                        shinyjs::hidden(div(id = "divamdprog",
                                            helpText(h4("Create/Amend Programme")),
                                            selectInput("sinputDPAccountName", "Account Name", choices=""),
                                            textInput("tinputDPProgName", "Programme Name"),
                                            tipify(selectInput("sinputTransformname", "Transform Name", choices=""),"Transformation Description to be added here", placement="right", trigger="hover", options = NULL),
                                            # tipify is an extract of bsTooltip and would wrap any shiny element and it will create a tooltip on the wrapped element.
                                            actionButton("abuttonProgSubmit",  class="btn btn-primary",label = "Submit", align = "left"),
                                            br(),
                                            br(),
                                            
                                            shinyjs::hidden(div(id = "divFileUpload",
                                            helpText(h4("Source Location File")),
                                            selectInput("sinputSLFile", "Select Option", c("Select" = "",
                                                                                           "Upload New File" = "U",
                                                                                           "Select existing file" = "S")),
                                            shinyjs::hidden(div(id = "divSLFileUpload",
                                                                fileInput('SLFile', 'Choose a file to upload:',
                                                                          accept = c(
                                                                            'csv',
                                                                            'comma-separated-values',
                                                                            '.csv'
                                                                          )),
                                                                actionButton("abuttonSLFileUpload",  class="btn btn-primary",label = "Upload File", align = "left", enable = FALSE)
                                            )),
                                            shinyjs::hidden(div(id = "divSLFileSelect",                    
                                                                selectInput("sinputselectSLFile", "Select existing File", choices=""),
                                                                actionButton("abuttonSLFileLink",  class="btn btn-primary",label = "Link", align = "left")
                                            )),
                                            #br(),
                                            helpText(h4("Source Account File")),
                                            selectInput("sinputSAFile", "Select Option", c("Select" = "",
                                                                                           "Upload New File" = "U",
                                                                                           "Select existing file" = "S")),
                                            shinyjs::hidden(div(id = "divSAFileUpload",
                                                                fileInput('SAFile', 'Choose a file to upload:',
                                                                          accept = c(
                                                                            'csv',
                                                                            'comma-separated-values',
                                                                            '.csv'
                                                                          )),
                                                                actionButton("abuttonSAFileUpload",  class="btn btn-primary",label = "Upload File", align = "left")
                                            )),
                                            shinyjs::hidden(div(id = "divSAFileSelect",                    
                                                                selectInput("sinputselectSAFile", "Select existing File", choices=""),
                                                                actionButton("abuttonSAFileLink",  class="btn btn-primary",label = "Link", align = "left")
                                            )),
                                              br()
                                            )),# end of divFileUpload
                                            
                                            actionButton("abuttonProgCancel", class = "btn btn-primary", label = "Cancel", align = "right")
                         )),
                                            shinyjs::hidden(                           
                                              div(id = "obtainoasiscrtprgdiv",
                                                  h4("Create Programme Model"),
                                                  selectInput("sinputookprogid", "Programme:", choices = c("")),
                                                  selectInput("sinputookmodelid", "Model:", choices = c("")),
                                                  tipify(selectInput("sinputProgModTransform", "Transform Name", choices=""),"Transformation Description to be added here", placement="right", trigger="hover",options = NULL),
                                                  # tipify is an extract of bsTooltip and would wrap any shiny element and it will create a tooltip on the wrapped element.
                                                  actionButton("abuttoncrprogoasis", "Create", class="btn btn-primary"),
                                                  actionButton("abuttoncancreateprog", "Cancel", class="btn btn-primary")
                                              ))
           ))
           ),
         mainPanel(
           br(),
                               helpText(h4("Programme Table")),
                               column(12,actionButton("abuttonprgtblrfsh", "Refresh", class="btn btn-primary"), align = "right"),
                               br(),
                               br(),           
                               DT::dataTableOutput("tableDPprog"),
                               br(),
                               actionButton("buttoncreatepr", "Create Programme", class="btn btn-primary", align = "left"),
                               actionButton("buttonamendpr", "Amend Programme", class="btn btn-primary", align = "centre"),
                               actionButton("buttondeletepr", "Delete Programme", class="btn btn-primary", align = "right"),
                               actionButton("buttonloadcanmodpr", "Load Programme", class="btn btn-primary", align = "right"),
                               br(),
                               br(),
                               #downloadButton("DPPdownloadexcel",label="Export to Excel"),
                               shinyjs::hidden(
                                 div(id="divdefprogdetails",
                                     helpText(h4("Programme Details")),
                                     column(12,actionButton("abuttondefprogrfsh", "Refresh", class="btn btn-primary"), align = "right"),
                                     br(),
                                     br(),
                                     DT::dataTableOutput("tableprogdetails")
                                )),
                                shinyjs::hidden(div(id="divprogmodeltable",
                                      #br(),
                                      br(),
                                      helpText(h4("Programme Model Table")),
                                      column(12,actionButton("abuttonookrefresh", "Refresh", class="btn btn-primary"), align = "right"),
                                      br(),
                                      br(),
                                      DT::dataTableOutput("tableProgOasisOOK"),
                                      br(),
                                      actionButton("abuttonmaincreateprog", "Create Programme Model", class="btn btn-primary", align = "left"),
                                      actionButton("abuttonloadprogmodel", "Load Programme Model", class="btn btn-primary", align = "left"),
                                      actionButton("abuttongotoprocessrun", "Go to Process Run", class="btn btn-primary")
                                )),
                                shinyjs::hidden(
                                  div(id="divprogoasisfiles",
                                      br(),
                                      br(),
                                      helpText(h4("Programme Model Details")),
                                      column(12,actionButton("abuttonprgoasisrfsh", "Refresh", class="btn btn-primary"), align = "right"),
                                      br(),
                                      br(),
                                      DT::dataTableOutput("tabledisplayprogoasisfiles")
                                  ))
     
         )
         ))