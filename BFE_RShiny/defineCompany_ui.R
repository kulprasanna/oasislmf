# (c) 2013-2016 Oasis LMF Ltd.  Software provided for early adopter evaluation only.
library(shinyBS)

tabPanel("Company", value = "definecompany",
         br(),
         br(),
         h3("Company", align = "center"),
             helpText(h4("Company List")),
             DT::dataTableOutput("tablecompanylist"),
             actionButton("abuttoncompcrt",  class="btn btn-primary",label = "Create", align = "left"),
             actionButton("abuttoncompupdate",  class="btn btn-primary",label = "Update", align = "left"),
             actionButton("abuttoncompdel",  class="btn btn-primary",label = "Delete", align = "left"),
             bsModal("compcrtupmodal", "Company Details", trigger= "abuttoncompcrt", size = "medium",
                     textInput("tinputCompName", "Company Name"),
                     textInput("tinputCompDom", "Company Domicile"),
                     textInput("tinputCompLegName", "Company Legal Name"),
                     textInput("tinputCompRegNo", "Company Registration Number"),
                     actionButton("abuttonsubcomp",  class="btn btn-primary",label = "Submit", align = "left"),
                     actionButton("abuttonccancel", class = "btn btn-primary", label = "Cancel", align = "right")),
              bsModal("compdelmodal", "Are you sure you want to delete?", trigger = "", size = "medium",
#                       htmlOutput("companydelete"),
#                       br(),
                      br(),
                      actionButton("abuttoncconfirmdel", class="btn btn-primary",label = "Confirm", align = "center"),
                      actionButton("abuttonccanceldel", class = "btn btn-primary", label = "Cancel", align = "right"))

)