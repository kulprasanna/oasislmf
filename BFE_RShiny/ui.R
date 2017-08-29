# (c) 2013-2016 Oasis LMF Ltd.  Software provided for early adopter evaluation only.
library(shiny)
library(shinyBS)
#library(shinyTable)
#library(shinysky)
library(shinyjs)
library(DT)

shinyUI(
  fluidPage(theme = "bootstrap.css", 
                  shinyjs::useShinyjs(),
                  title = "Flamingo",
                  conditionalPanel(
                    condition = "output.id == -1",
                    tags$div(align = "center",
                             br(),                             
                             img(src="Flamingo.jpg"),
                                    #h3("Login", style="color:#E26A97"),
                                    br(),
                                    br(),                             
                                    br(),
                                    tags$input(id="userid",type="text",placeholder="username", size=15,style="font-size:14pt;"),
                                    br(),br(),
                                    tags$input(id="password",type="password",placeholder="password", size=15,style="font-size:14pt;", onkeydown="if (event.keyCode == 13) document.getElementById('loginbutton').click()"),
                                    br(),br(),br(),
                                    actionButton("loginbutton", "Login", class="btn btn-success"),
                                    br(), br()
                                    #shinyalert("loginalert", click.hide = TRUE, auto.close.after = NULL)
                                    ),#End of tags$div
                             hidden(
                                   div(id = "toutuserid",
                                   verbatimTextOutput("id"),
                                   verbatimTextOutput("menu")
                                  )#End of div toutuserid
                            )#End of hidden for div loutuserid
                   ),#ENd of conditional panel
                    conditionalPanel(
                      condition = "output.id != -1",
                      conditionalPanel(
                        condition = "output.menu == 'LP'",
                        fluidRow(
                          column(10,
                                 h1("Flamingo 1.0"),
                                 h4("Oasis Business Front End")
                                 ),
                          column(2,
                                 br(),
                                 wellPanel(
                                 textOutput("textOutputHeaderData2")
                                 ))
                        ),
                        fluidRow(
                          column(2,
                                bsButton("abuttonexpmngt", "Exposure Management", style="btn btn-primary", size="default", type="action", block=T),
                                bsButton("abuttonprmngt", "Process Management", style="btn btn-primary", size="default", type="action", block=T),
                                bsButton("abuttonfilemngt", "File Management", style="btn btn-primary", size="default", type="action", block=T),
                                #bsButton("abuttonenquiry", "Enquiry", style="btn btn-primary", size="default", type="action", block=T),
                                bsButton("abuttonsysconf", "System Configuration", style="btn btn-primary", size="default", type="action", block=T),
                                #bsButton("abuttonworkflowadmin", "Workflow Administration", style="btn btn-primary", size="default", type="action", block=T),
                                bsButton("abuttonuseradmin", "User Administration", style="btn btn-primary", size="default", type="action", block=T),
                                #bsButton("abuttonutilities", "Utilities", style="btn btn-primary", size="default", type="action", block=T),
                                bsButton("abuttonlogout", "Logout", style="btn btn-primary", size="default", type="action", block=T)
                                ),
                        column(10,

                                wellPanel(
                                h4("Process Runs Inbox"),
                                DT::dataTableOutput("tableinbox"),
                                actionButton("abuttongotorun", "Goto Run Details", class="btn btn-primary", align = "right"),
                                actionButton("abuttonrefreshinbox", "Refresh", class="btn btn-primary", align = "right"),
                                downloadButton("PRIdownloadexcel",label="Export to Excel")
                        )),
                        column(12, align = 'right',
                               em("Powered by RShiny", style = "color:gray; font-size:10pt"))
                        )),#End of conditional panel Landing page
                      
                      ############################################# Exposure Management ###########################################                   
                      conditionalPanel(
                        condition = "output.menu == 'EM'",                    
                        navbarPage("Exposure Management", id = "em", 
                                   position = "fixed-top",
                                   tabPanel("", value = "emtemp"),
                                   source("defineAccount_ui.R",local=TRUE)$value,
                                   source("defineProg_ui.R",local=TRUE)$value,
# 								                   source("LoadCanonicalModel_ui.R", local=TRUE)$value,
#                                    source("obtainOasisKey_ui.R", local=TRUE)$value,
                                   tabPanel("Main Menu",  value = "emlp"),
                                   column(12, align = 'right',
                                          em("Powered by RShiny", style = "color:gray; font-size:10pt"))                              
                        )#End of navbarMenu("Exposure Management")
                      ),#ENd of conditional panel Exposure Management  

                      ############################################## Process Management #################################################                      
                      conditionalPanel(
                        condition = "output.menu == 'WF'",                   
                        navbarPage("Process Management", id = "pr",
                                   position = "fixed-top",
                                   tabPanel("", value = "pmtemp"),
                                   #source("defineProcess_ui.R", local=TRUE)$value,
                                   source("processRun_ui.R", local=TRUE)$value,
                                   #source("batch_ui.R", local=TRUE)$value,
                                   tabPanel("Main Menu",  value = "prlp"),
                                   column(12, align = 'right',
                                          em("Powered by RShiny", style = "color:gray; font-size:10pt"))                                
                        )#End of navbarMenu("Process Management")
                      ),#ENd of conditional panel Process Management
                      
                      ###################################### File Management ################################################
                      conditionalPanel(
                        condition = "output.menu == 'FM'",
                        navbarPage("File Management", id = "fm",
                                   position = "fixed-top",
                                   tabPanel("", value = "fmtemp"),
                                   source("fileViewer_ui.R", local=TRUE)$value,
                                   #source("fileUpload_ui.R", local=TRUE)$value,
                                   tabPanel("Main Menu",  value = "fmlp"),
                                   column(12, align = 'right',
                                          em("Powered by RShiny", style = "color:gray; font-size:10pt"))                              
                        )#End of navbarMenu(File Management")
                      ),#ENd of conditional panel File Management

                      ####################################### Enquiry #########################################################                                            
                      conditionalPanel(
                        condition = "output.menu == 'Enq'",                    
                        navbarPage("Enquiries", id = "enq", 
                                   position = "fixed-top",
                                   tabPanel("", value = "enqtemp"),
                                   #source("enquiryinbox_ui.R", local=TRUE)$value,
                                   source("enquirypage_ui.R", local=TRUE)$value,
                                   tabPanel("Main Menu",  value = "enqlp"),
                                   column(12, align = 'right',
                                   em("Powered by RShiny", style = "color:gray; font-size:10pt"))
                        )#End of navbarMenu("Enquiry")
                      ),#ENd of conditional panel Enquiry  
                   
                      ######################################### System Config ##################################                  
                      conditionalPanel(
                        condition = "output.menu == 'SC'",
                        navbarPage("System Configuration", id = "sc",
                                   position = "fixed-top",
                                   tabPanel("", value = "sctemp"),
                                   #source("modelsupplier_ui.R", local=TRUE)$value,
                                   #source("supplierservices_ui.R", local=TRUE)$value,
                                   source("model_ui.R", local=TRUE)$value,
                                   tabPanel("Main Menu",  value = "sclp"),
                                   column(12, align = 'right',
                                          em("Powered by RShiny", style = "color:gray; font-size:10pt"))                    
                        )#End of navbarMenu(System Config)
                      ),#ENd of conditional panel System Config
                      
                      ############################################## Workflow Administration ###########################################
#                       conditionalPanel(
#                         condition = "output.menu == 'WA'",
#                         navbarPage("Workflow Administration", id = "wa",
#                                    position = "fixed-top", 
#                                    tabPanel("", value = "watemp"),
#                                    source("defineWorkflow_ui.R", local=TRUE)$value,
#                                    tabPanel("Main Menu",  value = "walp"),
#                                    column(12, align = 'right',
#                                           em("Powered by RShiny", style = "color:gray; font-size:10pt"))                              
#                         )#End of navbarMenu("Workflow Administration")
#                       ),#ENd of conditional panel Workflow Admin
                      
                      
                      ####################################### User Admin ##############################################
                      conditionalPanel(
                         condition = "output.menu == 'UA'",                    
                         navbarPage("User Administration", id = "ua",
                                    position = "fixed-top",
                                    tabPanel("", value = "uatemp"),
                                    source("defineCompany_ui.R", local=TRUE)$value,
                                    source("defineUserAdmin_ui.R", local=TRUE)$value,
                                        #source("userSecurityGroups_ui.R", local=TRUE)$value,
                                        #source("resources_ui.R", local=TRUE)$value,
                                        #source("licenses_ui.R", local=TRUE)$value,
                                    tabPanel("Main Menu",  value = "ualp"),
                                    column(12, align = 'right',
                                           em("Powered by RShiny", style = "color:gray; font-size:10pt"))                              
                         )#End of navbarMenu("User Administration")
                      ),#ENd of conditional panel User Administrationt  
                   
                      ####################################### Utilities #########################################################                      
                      conditionalPanel(
                        condition = "output.menu == 'UT'",
                        navbarPage("Utilities", id = "ut",
                                   position = "fixed-top",
                                   tabPanel("", value = "uttemp"),
                                   #source("themes_ui.R", local=TRUE)$value,
                                   #source("fileoutput_ui.R", local=TRUE)$value,
                                   tabPanel("Main Menu",  value = "utlp"),
                                   br(),
                                   br(),
                                   br(),
                                   br(),
                                   br(),
                                   br(),
                                   br(),
                                   br(),
                                   br(),
                                   column(12, align = 'right',
                                          em("Powered by RShiny", style = "color:gray; font-size:10pt"))
                                   
                        )
                   ))#End of conditiopnalPanel Utilities                   

  )#End of fluidpage
)#End of ShinyUI
