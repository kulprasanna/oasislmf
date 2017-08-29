# (c) 2013-2016 Oasis LMF Ltd.  Software provided for early adopter evaluation only.
tabPanel("Account Enquiry", value = "enquiry",
         br(),
         br(),
         h3("Enquiry", align = "center"),
         div(id="divEnquiry",
             helpText(h4("Accounts Table")),
             #A table output - the table itself is defined in the modelsupplier_server.R file.
             DT::dataTableOutput("tableEnqaccounts"),
             downloadButton("EnqAdownloadexcel",label="Export to Excel"),
             actionButton("aButtonEnqaccountmaintenance", label="Account Maintenance", align="right",class="btn btn-primary"),
             
              shinyjs::hidden(div(id="divenqprog",
              br(),br(),
              helpText(h4("Programme Table")),
             
              DT::dataTableOutput("tableEnqprog"),
              
              downloadButton("EnqProgdownloadexcel",label="Export to Excel"),
              actionButton("aButtonEnqprogmaintenance", label="Prog Maintenance", align="right",class="btn btn-primary"),
              actionButton("aButtonEnqfilemanagement", label="File Management", align="right",class="btn btn-primary"))),
             
             shinyjs::hidden(
               
               div(id="divenqpoliciestable",
                   br(),
                   helpText(h4("File Table")),
                   
                   DT::dataTableOutput("tableEnqfiles"),
                   downloadButton("EnqFilesdownloadexcel",label="Export to Excel"),
                   
                   br(),br(),
                   
                   shinyjs::hidden(
                     div(id="divfileviewerenq",
                         helpText(h4("File")),
                         DT::dataTableOutput("tableEnqReadFile"),
                         downloadButton("EnqFileContentsdownloadexcel",label="Export to Excel"),
                         br(),br()
                         )
                   ),
                   
                   helpText(h4("Policies Table")),
                   
                   DT::dataTableOutput("tableEnqpolicies"),
                   downloadButton("EnqPodownloadexcel",label="Export to Excel"),
                   #actionButton("aButtonEnqIPT", label="Insurance Policy Terms", align="right",class="btn btn-primary"),
                   br(),br(),
                   
                   shinyjs::hidden(
                     div(id="divenqpolicycoveragetable",
                         tabsetPanel(id="policiestabset",
                                     #Tab1
                                     tabPanel("Policy Coverages",
                                              br(),
                                              helpText(h4("Policy Coverage Table")),
                                              DT::dataTableOutput("tableenqpolicycoverage"),
                                              # downloadButton("enqIPTPCdownloadexcel",label="Export to Excel"),
                                              br(),br(),br(),
                                              value="enqpolicycoveragetab"
                                     ),
                                     #Tab2
                                     tabPanel("Policy Values",
                                              br(),
                                              helpText(h4("Policy Values")),
                                              DT::dataTableOutput("tableenqpolicyvalues"),
                                              # downloadButton("enqIPTPVdownloadexcel",label="Export to Excel"),
                                              br(),br(),
#                                               shinyjs::hidden(
#                                                 div(id="enqdivamendPV",
#                                                     helpText("Amend Policy Field Value"),
#                                                     textInput("tinputFieldValue", "Field Value"),
#                                                     actionButton("abuttonPVFVupdate",  class="btn btn-primary",label = "Update", align = "center")
#                                                 )),
                                              value="policyvaluestab"
                                     )
                                     
                         )
                     )),
                   br(),br()
                   
               ))
             
              )#end divenquiry
         
         
         
         )#end tabpanel