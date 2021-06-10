# main site
# 
# 
library(shiny)
library(shinyjs)
library(shinythemes)

ui <- fluidPage(theme = shinytheme("superhero"),
  shinythemes::themeSelector()

)

server <- function(input, output, session){
  
}

shinyApp(ui, server)



