# (c) 2013-2016 Oasis LMF Ltd.  Software provided for early adopter evaluation only.
tabPanel("Process Run", value = "processrun",
         br(),
         br(),
         br(),
         br(),         
         h3("Process Run", align = "center"),
#          tags$div(
#            HTML(paste("", tags$span(style="color: #fff; background-color: #446e9b;text-align: center;font-size: 24px;", "Process Run"), sep = "")), align = "center"
#          ),
         tags$head(
           tags$style(HTML("
                           .multicol {
                           -webkit-column-count: 6; /* Chrome, Safari, Opera */
                           -moz-column-count: 6; /* Firefox */
                           column-count: 6;
                           }"),
                      HTML("
                           .h5-align {
                            margin-top: 14px;
                            margin-bottom: 0px;
                           }
                           ")
                )
           
           ), #CSS class to format checkboxinputgroups into 6 columns
         bsModal("bsmodalrunparam", "Select Runtime Parameters", trigger= "", size = "large",
                 sidebarLayout(
                         sidebarPanel(class="panel panel-primary", 
                                   selectInput("sinoutputoptions", "Output Presets:", choices = ""),
                                   #actionButton("abtnupdtoutopt", "Update Presets", class="btn btn-primary"),
                                   actionButton("abtnclroutopt", "Clear", class="btn btn-primary"),
                                   br(),
                                   br(),
                                   textInput("tinputprocessrunname", label = "Process Run Name:", value = ""),
                                   textInput("tinputnoofsample", label = "Number of Samples:", value = "10"),
                                   textInput("tinputthreshold", label = "Loss Threshold:", value = "0"),
                                   selectInput("sinputeventset", label = "Event Set:", choices = "Probabilistic"),
                                   selectInput("sinputeventocc", label = "Event Occurrence Set:", choices = "Long Term"),
                                   #shinyjs::hidden(div(id = "SessionID", selectInput("chkinputsessionid", "Session ID:", choices = c("")))),
                                   #shinyjs::hidden(div(id = "ReconciliationMode", checkboxInput("chkinputrcmode", "Reconciliation Mode:", value = TRUE))),
                                   shinyjs::hidden(div(id = "perilwind", checkboxInput("chkinputprwind", "Peril: Wind", value = TRUE))),
                                   shinyjs::hidden(div(id = "perilsurge", checkboxInput("chkinputprstsurge", "Peril: Surge", value = TRUE))),
                                   shinyjs::hidden(div(id = "perilquake", checkboxInput("chkinputprquake", "Peril: Quake", value = TRUE))),
                                   shinyjs::hidden(div(id = "perilflood", checkboxInput("chkinputprflood", "Peril: Flood", value = TRUE))),
                                   shinyjs::hidden(div(id = "demandsurge", checkboxInput("chkinputdsurge", "Demand Surge", value = TRUE))),
                                   shinyjs::hidden(div(id = "leakagefactor",sliderInput("sliderleakagefac", "Leakage factor:", min= 0, max=100, value=0.5, step = 0.5))),
                                   br(),
                                   checkboxInput("chkinputsummaryoption", "Summary Reports", value = TRUE)
                                   #selectInput("sinputoasissystem", "Oasis System", choices = c(""))
                       ),#End of sidebarpanel Process RUn
                 mainPanel(
                   fluidRow(
                     # Few outputs commented/disabled for the first release. To be enabled for later releases.  
                     column(4, h4("Ground Up Loss", style="font-size: 18px; font-weight: bold;"), h5("Full Sample", style="font-size: 16.5px;"), 
                            h5("ELT", style="font-size: 16.5px;"), tags$div(class = "h5-align", h5("AEP", style="font-size: 16.5px;")), 
                            tags$div(class = "h5-align", h5("OEP", style="font-size: 16.5px;")), tags$div(class = "h5-align", h5("Multi AEP", style="font-size: 16.5px;")),
                            h5("Multi OEP", style="font-size: 16.5px;"), 
#                             h5("WS Mean AEP", style="font-size: 16.5px;"), tags$div(class = "h5-align", h5("WS Mean OEP", style="font-size: 16.5px;")), 
#                             tags$div(class = "h5-align",h5("Sample Mean AEP", style="font-size: 16.5px;")), h5("Sample Mean OEP", style="font-size: 16.5px;"), 
                            h5("AAL", style="font-size: 16.5px;"), tags$div(class = "h5-align",h5("PLT", style="font-size: 16.5px;"))),
                            tags$div(class = "multicol",
                              checkboxGroupInput("chkgulprog", label = h4("Prog", style="font-size: 15.0px;"), 
                                                 choices = list(" " = "gulprogSummary", " " = "gulprogELT", " " = "gulprogFullUncAEP", " " = "gulprogFullUncOEP", " " = "gulprogAEPWheatsheaf", " " = "gulprogOEPWheatsheaf", 
#                                                                " " = "gulprogMeanAEPWheatsheaf", " " = "gulprogMeanOEPWheatsheaf", " " = "gulprogSampleMeanAEP", " " = "gulprogSampleMeanOEP",
                                                                " " = "gulprogAAL", " " = "gulprogPLT"),
                                                 selected = NULL),
                              checkboxGroupInput("chkgulpolicy", label = h4("Policy", style="font-size: 15.0px;"), 
                                                 choices = list(" " = "gulpolicySummary", " " = "gulpolicyELT", " " = "gulpolicyFullUncAEP", " " = "gulpolicyFullUncOEP", " " = "gulpolicyAEPWheatsheaf", " " = "gulpolicyOEPWheatsheaf",  
#                                                                " " = "gulpolicyMeanAEPWheatsheaf", " " = "gulpolicyMeanOEPWheatsheaf", " " = "gulpolicySampleMeanAEP", " " = "gulpolicySampleMeanOEP",
                                                                " " = "gulpolicyAAL", " " = "gulpolicyPLT"),
                                                 selected = NULL),
                              checkboxGroupInput("chkgulstate", label = h4("State", style="font-size: 15.0px;"), 
                                                 choices = list(" " = "gulstateSummary", " " = "gulstateELT", " " = "gulstateFullUncAEP", " " = "gulstateFullUncOEP", " " = "gulstateAEPWheatsheaf", " " = "gulstateOEPWheatsheaf", 
#                                                                " " = "gulstateMeanAEPWheatsheaf", " " = "gulstateMeanOEPWheatsheaf", " " = "gulstateSampleMeanAEP", " " = "gulstateSampleMeanOEP",
                                                                " " = "gulstateAAL", " " = "gulstatePLT"),
                                                 selected = NULL),
                              checkboxGroupInput("chkgulcounty", label = h4("County", style="font-size: 15.0px;"), 
                                                 choices = list(" " = "gulcountySummary", " " = "gulcountyELT", " " = "gulcountyFullUncAEP", " " = "gulcountyFullUncOEP", " " = "gulcountyAEPWheatsheaf", " " = "gulcountyOEPWheatsheaf", 
#                                                                " " = "gulcountyMeanAEPWheatsheaf", " " = "gulcountyMeanOEPWheatsheaf", " " = "gulcountySampleMeanAEP", " " = "gulcountySampleMeanOEP",
                                                                " " = "gulcountyAAL", " " = "gulcountyPLT"),
                                                 selected = NULL),
                              checkboxGroupInput("chkgulloc", label = h4("Location", style="font-size: 15.0px;"), 
                                                 choices = list(" " = "gullocSummary", " " = "gullocELT", " " = "gullocFullUncAEP", " " = "gullocFullUncOEP", " " = "gullocAEPWheatsheaf", " " = "gullocOEPWheatsheaf", 
#                                                                " " = "gullocMeanAEPWheatsheaf", " " = "gullocMeanOEPWheatsheaf", " " = "gullocSampleMeanAEP", " " = "gullocSampleMeanOEP",
                                                                " " = "gullocAAL", " " = "gullocPLT"),
                                                 selected = NULL),
                              checkboxGroupInput("chkgullob", label = h4("LOB", style="font-size: 15.0px;"), 
                                                 choices = list(" " = "gullobSummary", " " = "gullobELT", " " = "gullobFullUncAEP", " " = "gullobFullUncOEP", " " = "gullobAEPWheatsheaf", " " = "gullobOEPWheatsheaf", 
#                                                                " " = "gullobMeanAEPWheatsheaf", " " = "gullobMeanOEPWheatsheaf", " " = "gullobSampleMeanAEP", " " = "gullobSampleMeanOEP",
                                                                " " = "gullobAAL", " " = "gullobPLT"),
                                                 selected = NULL)
                     )
                   ),
                   br(),
                   fluidRow(
                     column(4, h4("Insured Loss", style="font-size: 18px; font-weight: bold;"), h5("Full Sample", style="font-size: 16.5px;"), 
                            h5("ELT", style="font-size: 16.5px;"), tags$div(class = "h5-align", h5("AEP", style="font-size: 16.5px;")), 
                            tags$div(class = "h5-align", h5("OEP", style="font-size: 16.5px;")), tags$div(class = "h5-align", h5("Multi AEP", style="font-size: 16.5px;")),
                            h5("Multi OEP", style="font-size: 16.5px;"),  
#                             h5("WS Mean AEP", style="font-size: 16.5px;"), tags$div(class = "h5-align", h5("WS Mean OEP", style="font-size: 16.5px;")),  
#                             tags$div(class = "h5-align",h5("Sample Mean AEP", style="font-size: 16.5px;")),h5("Sample Mean OEP", style="font-size: 16.5px;"), 
                            h5("AAL", style="font-size: 16.5px;"), tags$div(class = "h5-align",h5("PLT", style="font-size: 16.5px;"))),
                    tags$div(class = "multicol", 
                    checkboxGroupInput("chkilprog", label = h5("Prog", style="font-size: 15.0px;"), 
                                                 choices = list(" " = "ilprogSummary", " " = "ilprogELT", " " = "ilprogFullUncAEP", " " = "ilprogFullUncOEP", " " = "ilprogAEPWheatsheaf", " " = "ilprogOEPWheatsheaf",  
#                                                                " " = "ilprogMeanAEPWheatsheaf", " " = "ilprogMeanOEPWheatsheaf"," " = "ilprogSampleMeanAEP", " " = "ilprogSampleMeanOEP",
                                                                " " = "ilprogAAL", " " = "ilprogPLT"),
                                                 selected = NULL),
                    checkboxGroupInput("chkilpolicy", label = h5("Policy", style="font-size: 15.0px;"), 
                                                 choices = list(" " = "ilpolicySummary", " " = "ilpolicyELT", " " = "ilpolicyFullUncAEP", " " = "ilpolicyFullUncOEP", " " = "ilpolicyAEPWheatsheaf", " " = "ilpolicyOEPWheatsheaf", 
#                                                                " " = "ilpolicyMeanAEPWheatsheaf", " " = "ilpolicyMeanOEPWheatsheaf", " " = "ilpolicySampleMeanAEP", " " = "ilpolicySampleMeanOEP",
                                                                " " = "ilpolicyAAL", " " = "ilpolicyPLT"),
                                                 selected = NULL),
                    checkboxGroupInput("chkilstate", label = h5("State", style="font-size: 15.0px;"), 
                                                 choices = list(" " = "ilstateSummary", " " = "ilstateELT", " " = "ilstateFullUncAEP", " " = "ilstateFullUncOEP", " " = "ilstateAEPWheatsheaf", " " = "ilstateOEPWheatsheaf", 
#                                                                " " = "ilstateMeanAEPWheatsheaf", " " = "ilstateMeanOEPWheatsheaf", " " = "ilstateSampleMeanAEP", " " = "ilstateSampleMeanOEP",
                                                                " " = "ilstateAAL", " " = "ilstatePLT"),
                                                 selected = NULL),
                    checkboxGroupInput("chkilcounty", label = h5("County", style="font-size: 15.0px;"), 
                                                 choices = list(" " = "ilcountySummary", " " = "ilcountyELT", " " = "ilcountyFullUncAEP", " " = "ilcountyFullUncOEP", " " = "ilcountyAEPWheatsheaf", " " = "ilcountyOEPWheatsheaf", 
#                                                                " " = "ilcountyMeanAEPWheatsheaf", " " = "ilcountyMeanOEPWheatsheaf", " " = "ilcountySampleMeanAEP", " " = "ilcountySampleMeanOEP",
                                                                " " = "ilcountyAAL", " " = "ilcountyPLT"),
                                                 selected = NULL),
                    checkboxGroupInput("chkilloc", label = h5("Location", style="font-size: 15.0px;"), 
                                                 choices = list(" " = "illocSummary", " " = "illocELT", " " = "illocFullUncAEP", " " = "illocFullUncOEP", " " = "illocAEPWheatsheaf", " " = "illocOEPWheatsheaf", 
#                                                                " " = "illocMeanAEPWheatsheaf", " " = "illocMeanOEPWheatsheaf", " " = "illocSampleMeanAEP", " " = "illocSampleMeanOEP",
                                                                " " = "illocAAL", " " = "illocPLT"),
                                                 selected = NULL),
                    checkboxGroupInput("chkillob", label = h5("LOB", style="font-size: 15.0px;"), 
                                                 choices = list(" " = "illobSummary", " " = "illobELT", " " = "illobFullUncAEP", " " = "illobFullUncOEP", " " = "illobAEPWheatsheaf", " " = "illobOEPWheatsheaf", 
#                                                                " " = "illobMeanAEPWheatsheaf", " " = "illobMeanOEPWheatsheaf", " " = "illobSampleMeanAEP", " " = "illobSampleMeanOEP",
                                                                " " = "illobAAL", " " = "illobPLT"),
                                                 selected = NULL)
                     )
                   ),#end of fluidrow FM
                   br(),
                   actionButton("abuttonexecuteprrun", "Execute Run", class="btn btn-primary"),
                   actionButton("abuttonsaveoutput", "Save Output", class="btn btn-primary"),
                   actionButton("abuttoncancelrun", "Cancel", class="btn btn-primary")
                 )#End of MainPanel
                 )#End of sidebarLayout
         ),#End of BSModal bsmodalrunparam

        bsModal("bsmodalsaveoutput", "Save Output", trigger= "abuttonsaveoutput", size = "small",
                textInput("tinputoutputname", label = "Output Name:", value = ""),
                actionButton("abuttonsubmitoutput", "Submit", class="btn btn-primary")
        ),#End of BSModal

             h4("Prog Oasis", align = "left"),
             DT::dataTableOutput("tableprocessdata2"),
             actionButton("abuttonrunpr", "Run Process", class="btn btn-primary"),
             br(),
             br(),
             br(),
             hidden(div(id = "prruntable",             
                          fluidRow(
                                 column(6, h4("Process Runs"), align = "left"),
                                 ### removed radioprrunsMineOrAll as per JIRA http://52.213.134.255:8080/browse/OASIS-336
                                 #column(3, radioButtons("radioprrunsMineOrAll", "Which Processes", list("Mine", "Everyone's"), inline = TRUE)),
# nbsp handling for proper space in "In_Progress" - this may help
# <https://groups.google.com/forum/?_escaped_fragment_=msg/shiny-discuss/7IUil3Pc3Rw/FaazvIoTycMJ#!msg/shiny-discuss/7IUil3Pc3Rw/FaazvIoTycMJ>
# but I couldn't get it to work
                                 column(5, radioButtons("radioprrunsAllOrInProgress", "Processes' Status", list("All", "In_Progress"), inline = TRUE)),
                                 column(1, actionButton("abuttonrefreshprrun", "Refresh", class="btn btn-primary"), align = "right")
                          ),#End of fluidrow
                        DT::dataTableOutput("processrundata"),
                        #actionButton("abuttontogooutput", "View Output", class="btn btn-primary"),
                        actionButton("abuttondisplayoutput", "Display Output", class="btn btn-primary"),
                        actionButton("abuttonhideoutput", "Hide Output", class="btn btn-primary"),
                        actionButton("abuttonrerunpr", "Rerun", class="btn btn-primary")
                        #actionButton("abuttonterminateprrun", "Terminate Job", class="btn btn-primary")
                    )#End of div prruntable 
             ),#End of hidden for prruntable

             hidden(div(id = "prrunoutput",
                        br(),
                        br(),
                        fluidRow(
                          column(10, h4("Output Files"), align = "left"),
                          column(2, actionButton("abuttonrefreshprrunoutputfile", "Refresh", class="btn btn-primary"), align = "right")
                        ),#End of fluidrow
                        tabsetPanel(id = "tabsetprrunoutput",
                          tabPanel("File List", value = "tabprrunfilelist",DT::dataTableOutput("outputfileslist")),
                          tabPanel("File Contents", value = "tabprrunfiledata", DT::dataTableOutput("dttableoutputfiledata"),
                                   downloadButton("PRfiledataIdownloadexcel",label="Export to Excel")
                                   ),
                          tabPanel("Summary Graph", value = "tabprrunsummary", h3("Summary EP Curves"),
                                   fluidRow(
                                   column(6, h4("GUL Outputs"),
                                          plotOutput("plotGULOutput")), #width = "100%", height = "400px", click = NULL, dblclick = NULL, hover = NULL, hoverDelay = NULL, hoverDelayType = NULL, brush = NULL, clickId = NULL, hoverId = NULL, inline = FALSE)),
                                   column(6, h4("IL Outputs"),
                                          plotOutput("plotILOutput", width = "100%", height = "400px", click = NULL, dblclick = NULL, hover = NULL, hoverDelay = NULL, hoverDelayType = NULL, brush = NULL, clickId = NULL, hoverId = NULL, inline = FALSE)))
                        ),
                        tabPanel("Summary Table", value = "tabprrunsummarytable", DT::dataTableOutput("dttableoutputsummary"))
                        )
                       
             )#End of div prrunoutput
             ),#End of hidden for prrunoutput

             br(),
             br(),
             hidden(div(id = "prrunlogtable",
                        fluidRow(
                                 column(10, h4("Process Run Logs"), align = "left"),
                                 column(2, actionButton("abuttonrefreshprrunlogs", "Refresh", class="btn btn-primary"), align = "right")
                        ),#End of fluidrow
                        DT::dataTableOutput("log")
                       
             )#End of div prrunlogtable
             )#End of hidden for prrunlogtable
             #DT::dataTableOutput("log")
             
 #          )#End of mainpanel
#         )#End of sidebar layout
)#End of tabPanel("Run Process")
