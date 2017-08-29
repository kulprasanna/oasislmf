# (c) 2013-2016 Oasis LMF Ltd.  Software provided for early adopter evaluation only.
# modelsupplier_ui.R
# model supplier page

#Creates a tab on the navbar called "Model Suppliers"
tabPanel("Model", value = "Model",
         br(),
         br(),
         h3("Model", align = "center"),
#         sidebarLayout(
         shinyjs::hidden(
           div(id = "cramndelmodres",
               sidebarPanel(class="panel panel-primary", position = "bottom",
                            helpText("Model Resource"),
                            textInput("tinmodelresname", label = "Model Resource Name:", value = ""),
                            selectInput("sinresrctype", "Resource Type:", choices = c("")),
                            #selectInput("sinoasismfvername", "Oasis Model Family Version:", choices = c("")), 
                            selectInput("sinoasissysname", "Oasis System Name:", choices = c("")),
                            textInput("tinmodelresvalue", label = "Model Resource Value:", value = ""),
                            shinyjs::hidden(
                              div(id = "crudmodres",
                            actionButton("abuttoncreatemodres", "Create", class="btn btn-primary"),
                            actionButton("abuttonupdatemodres", "Update", class="btn btn-primary"),
                            actionButton("abuttondeldelres", "Delete", class="btn btn-primary"),
                            br(),
                            br(), 
                            actionButton("abuttoncancelmodres", "Cancel", class="btn btn-primary")
                              )),
                            shinyjs::hidden(
                              div(id = "submitmodrescreate",
                                  actionButton("abuttonsubmodres", class="btn btn-primary",label = "Submit", align = "left"),
                                  actionButton("abuttoncancelmodrescrt", class = "btn btn-primary", label = "Cancel Create", align = "right"))
                            ),                            
                            shinyjs::hidden(
                              div(id = "ConfirmModResDel",
                                  helpText("Are you sure you want to delete?"),
                                  actionButton("abuttonconmodresdelete", class="btn btn-primary",label = "Confirm", align = "left"),
                                  actionButton("abuttoncancelmodresdelete", class = "btn btn-primary", label = "Cancel Delete", align = "right"))
                            ),
                            width = 3,
                            br()               
               )#End of sidebarpanel Process
           )#End of div createamendmodres
         ), #end of hidden         
         #Main Page section
         mainPanel(
         
           helpText(h4("Model")),
           
           #Table output
           DT::dataTableOutput("tablemodel"),
           downloadButton("Modeldownloadexcel",label="Export to Excel"),
           br(),
           br(),
           #Further tables that are only shown when a row is selected in the primary table - they depend on which row is selected
           shinyjs::hidden(
             div(id = "divmr",
                 # Table title
                 h4("Model Resource", align = "left"),
                 DT::dataTableOutput(outputId = "mrtable"),
                 actionButton("abuttoncrtudptdelmodres", "Create/Update/Delete", class="btn btn-primary"),
                 downloadButton("MRdownloadexcel",label="Export to Excel"),
                 br()
             )
           )
           
         )
)
#)