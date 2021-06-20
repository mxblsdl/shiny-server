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
          p(text),
          p(class = "link", tags$a(link_text, href= link))
      )
  )
}

options(shiny.autoreload = T)
 
ui <- fluidPage(theme = shinytheme("superhero"),
  tags$head(
    tags$link(rel = "stylesheet", type = "text/css", href = 'style.css'),
    tags$style("
  .red-dot:hover, .yellow-dot:hover, .green-dot:hover{
    transform: scale(1.2)
  }
               ")
  ),
  useShinyjs(),

  shinythemes::themeSelector(),
  
  actionButton("reset", "Reload"),
  fluidRow(
    console_div("Minimalist Maps", link_text = "")
    ),
  fluidRow(
    console_div("Portland Tree Map", link_text = "")
  ),
  fluidRow(
    console_div("My Setup", link_text = "") 
  ),
  fluidRow(
    console_div("More to Come", link_text = "") 
  )

  
)

server <- function(input, output, session){
  shinyjs::runjs("
                 $('.yellow-dot').click(function() {
                  $(this).siblings('p').slideUp('slow');
                 });
                 
                 $('.green-dot').click(function() {
                  $(this).siblings('p').slideDown('slow');
                 });
                 
                 $('.red-dot').click(function() {
                  $(this).parent().hide(1000);
                 });
                 
                 $('#reset').click(function() {
                   $('.box').show(1000);
                   $('.box').children('p').slideDown('slow');
                 });
                 ")
  
  
}

shinyApp(ui, server)

