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
               width:1 rem;
               height:100%;
               }

               ")
  ),
  
  useShinyjs(),
  
  actionButton("reset", "Reload"),

  fluidRow(
    column(width = 4,
           div(class = "content",
               p("Some Content")))
  ),
  
  fluidRow(
    column(width = 4,
           console_div('Minimalist Maps',
                       link_text = img(src = "line_map_prev_resize.png"),
                       link = "../minimal-map/"
                       )
           ),
    column(width = 4,
           console_div("Portland Tree Map",
                       link_text = img(src = "portland-trees_resize.png"),
                       link = "../tree-map/")
           )
    ), 
  fluidRow(
    column(width = 4,
           console_div(text = "Weather Clock, write up coming soon...",
                       link_text = img(src = "weather_resize.png"),
                       link = "../weather_clock/")
           ),
    column(width = 4,
           console_div("More to Come", link_text = "")
           )
    ),
  
  fluidRow(
    column(width = 4,
           console_div(text = "Stylized Roads",
                       link_text = img(src = "roads_resize.png"),
                       link = "../Stylized-Street-Maps/")
    ),
    column(width = 4,
           console_div("Fun with D3", 
                       link_text = "Using D3 within a Shiny runtime",
                       link = "../r2d3/")
    )
  ),
  
  tags$script(src = "script.js")

);

server <- function(input, output, session){
  
}

shinyApp(ui, server)

