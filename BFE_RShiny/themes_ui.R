# (c) 2013-2016 Oasis LMF Ltd.  Software provided for early adopter evaluation only.
#Creates a tab on the navbar called "Model Suppliers"
library(shinyBS)
tabPanel("Themes", value = "themes",
         br(),
         br(),
         #Title Text
         h3("Sample Theme", align = "center"),
         
         
         
         #Specifies the layout to have a sidebarPanel and a mainPanel
         sidebarLayout(
           #Sidebar section
           sidebarPanel(class = "panel panel-primary", width = 2,
                      
                        selectInput("themes", "Themes", choices=list("Cerulean"="www/cerulean.css", "Cosmo"="www/cosmo.css", "Flamingo"="www/flamingo.css", "Spacelab"="www/spacelab.css", "United"="www/united.css")),
                        br(),
                        actionButton("applytheme", "Apply Theme", class="btn btn-primary"),
                        bsTooltip("applytheme", "The theme will be applied when the application is refreshed", placement="bottom", trigger="hover")
                        
           ),
         mainPanel(
           br(),
           
           fluidRow(
             column(10,
             imageOutput("example")
           ))
         )
         )
)