# main site

library(shiny)
library(shinyjs)
library(shinythemes)

console_div <- function(text, link_text = "", link = NULL) {
  div(class = "cont",
      div(class = "box",
          span(class = "red-dot dot"),
          span(class = "yellow-dot dot"),
          span(class = "green-dot dot"),
          h4(text),
          p(class = "link", tags$a(link_text, href= link))
      )
  )
}
 
ui <- fluidPage(theme = shinytheme("superhero"),
  tags$head(
    tags$link(rel = "stylesheet", type = "text/css", href = 'style.css'),
    tags$style("
               .container{
               margin-left:4rem;
               margin-right:4rem;
               width:75%;
               }
               .link{
               margin:1em;
               }
               img{
               border-radius:8%;
               width:400px;
               height:100%;
               }

               ")
  ),
  
  useShinyjs(),
  
  actionButton("reset", "Reload"),

  fluidRow(
    column(width = 4,
           console_div('Minimalist Maps',
                       link_text = img(src = "line_map_prev.png"),
                       link = "../minimal-map/"
                       )
           ),
    column(width = 4,
           console_div("Portland Tree Map",
                       link_text = img(src = "portland-trees.png"),
                       link = "../tree-map/")
           )
    ), 
  fluidRow(
    column(width = 4,
           console_div(text = "Weather Clock, write up coming soon...",
                       link_text = img(src = "weather.png"),
                       link = "../weather_clock.png")
           ),
    column(width = 4,
           console_div("More to Come", link_text = "")
           )
    ),
  tags$script(src = "script.js")

);

server <- function(input, output, session){
  shinyjs::runjs("

                 ")
  
  
}

shinyApp(ui, server)

