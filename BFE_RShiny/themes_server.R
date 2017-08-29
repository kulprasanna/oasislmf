# (c) 2013-2016 Oasis LMF Ltd.  Software provided for early adopter evaluation only.
observe({
  input$ut
  if (input$ut == "utlp")
  {
    loginfo(paste("From Utilities to Landing Page, Userid: ", user_id, Sys.time()), logger="flamingo.module")
    active_menu <<- "LP"
    output$menu<-reactive({active_menu})    
  }
})






################## Functions ########################################

changetheme <- function(newtheme){
  
  file.copy(newtheme, "www/bootstrap.css", overwrite = TRUE)
  print ("function")
  print(newtheme)
  
}




################## Apply Theme #######################################

onclick("applytheme", {
  
  
  theme <- input$themes
  changetheme(theme)
  print("button")
  print (theme)
})

observe({
  input$themes
    if (input$ut == "themes")
    {    
      picture <- input$themes
      ssplit <- unlist(strsplit(picture, split="\\."))[1]
      picture <- paste0(ssplit, ".png")
      print(picture)
      output$example <- renderImage({
        return(list(
        src=picture,
        contentType="image/png"))
        }, deleteFile = FALSE)
    }
})

