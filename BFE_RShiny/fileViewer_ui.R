# (c) 2013-2016 Oasis LMF Ltd.  Software provided for early adopter evaluation only.
library(leaflet)

tabPanel("File Viewer", value = "fileviewer",
         br(),
         br(),
         h3("File Viewer", align = "center"),
#          sidebarLayout(fluid=FALSE,
# 
#            # this section hidden from here...
#            shinyjs::hidden( 
#                       sidebarPanel(class = "panel panel-primary", width = 3,
#                                     helpText("File Details"),
#                                     selectInput("sinputFVprogramme", "Programme", choices=""),
#                                     selectInput("sinputFVlocation", "Location", choices=""),
#                                     textInput("tinputFVfileName", "File Name"),
#                                     selectInput("sinputFileType", "File Type", choices=""),
#                                     selectInput("sinputFVowner", "Owner", choices=""),
#                                     selectInput("sinputFVsource", "Source", choices=""),
#                                     selectInput("sinputFVResourceTable","Resource Table", choices="" ),
#                                     actionButton("abuttonFVupdateFile", "Update", class="btn btn-primary"),
#                                     br(),
#                                     br()
#                       )
#                ),
#             # ... to here. Not wanted at all at present. Needs removing
#                        
#                        mainPanel(


# make verbatimTextOutput tiny and transparent because if you hide it
# with hidden(), it hides the conditionalPanel which depend on
# it. Weird.
tags$style(type='text/css', '#FVPanelSwitcher { color: rgba(0, 0, 0, 0); background-color: rgba(0, 0, 0, 0); font-size: 1%; height: 1px; border-style: none;  }'),
verbatimTextOutput("FVPanelSwitcher"),


actionButton( noteButtonID(FOBtnShowTable),         "Table",            class = "btn btn-primary"),
actionButton( noteButtonID(FOBtnShowRawContent),    "File",             class = "btn btn-primary"),
actionButton( noteButtonID(FOBtnShowMap),           "Map",              class = "btn btn-primary"),
# actionButton( noteButtonID(FOBtnShowAEPCurve),      "AEP Curve",        class = "btn btn-primary"),
# actionButton( noteButtonID(FOBtnShowGeocode),        "Geocode",         class = "btn btn-primary"),
# actionButton( noteButtonID(FOBtnShowEventFootprint), "Event Footprint", class = "btn btn-primary"),



# controller widget for conditionalPanel below


conditionalPanel
(
        condition = paste0("output.FVPanelSwitcher == '", FODivTable, "'"),
        h4("File List"),
#            column(12, actionButton("abuttonprocessinfo", "Process Run Details", class="btn btn-primary"), align = "right"),
#            #bsModal("modalExample", "Data Table", "tabBut", size = "large",dataTableOutput("distTable")),
#         br(),
#         br(),
        DT::dataTableOutput("tableFVfileList"),
        br(),
        # br(),
        shinyjs::hidden(                           
          div(id = "processruninfodiv",  
              h4("Process Run Details"),
              #DT::dataTableOutput("tableProcessRunInfo")
              htmlOutput("textprcruninfo"),
              htmlOutput("textprcrunparaminfo"),
              br()
          ))
),


conditionalPanel
(
        condition = paste0("output.FVPanelSwitcher == '", FODivFilecontents, "'"),
        h4("File Contents"),
        DT::dataTableOutput("tableFVExposureSelected"),
        br(),
        downloadButton("FVEdownloadexcel",label="Export to Excel")
),


conditionalPanel
(
       condition = paste0("output.FVPanelSwitcher == '", FODivPlainMap, "'"),
       tags$style(type = "text/css", "#plainmap {height: calc(100vh - 230px) !important;}"),
       h4("Map"),
       leafletOutput("plainmap")
),


conditionalPanel
(
    condition = paste0("output.FVPanelSwitcher == '", FODivAEPcurve, "'"),
    h4("AEP Curve"),
    plotOutput("plotFVAEPCurve")
#,
#    h4("AEP Curve Data"),
# TODO XXX commented out for serious login-page-not-appearing shiny bug 
#    DT::dataTableOutput("tableFVAEPdata"),
#    downloadButton("FVAEPdownloadexcel",label="Export to Excel")
),


conditionalPanel
(
    condition = paste0("output.FVPanelSwitcher == '", FODivGeocode, "'"),
    h4("Geocoded Data"),
    DT::dataTableOutput("tableGeocodeData")
# ,
# TODO XXX commented out for serious login-page-not-appearing shiny bug 
#    downloadButton("FVGdownloadexcel",label="Export to Excel")
),


conditionalPanel
(
    condition = paste0("output.FVPanelSwitcher == '", FODivEventFootprint, "'"),
    h4("Event Footprint", align="left"),
    leafletOutput("EventFootprintMap")
)



#                        )
#                        
#                        
#          )
)




