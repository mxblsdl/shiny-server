
library(shiny)
library(shinyjs)
library(bslib)
library(shinythemes)
library(scrollrevealR)

my_scroll_reveal <- function(target, origin = c("left", "right")) {
  scroll_reveal(target = target, 
                duration = 1000,
                distance = "600px",
                origin = origin,
                delay = 180, 
                reset = T)
}

ui <- fluidPage(theme = shinytheme("superhero"),

# link to custom css and JS
tags$head(
  tags$link(rel = "stylesheet", href = "style.css"),
  tags$style("
             #toTop{
              border-radius:50%;
              position:fixed;
              top: 80%;
              right:5%;
              opacity:0;
              transition: opacity 1000ms ease-in-out;
              visibility:hidden;
              }

              #toTop.scrolled{
              opacity:1;
              visibility:visible;
              }
             ")
  ),
  
# Nav Bar
fluidRow(id= "nav",
  column(width = 10, 
         tags$a("Shiny", class = "btn btn-default", href = "#shiny"),
         tags$a("Gallery", class = "btn btn-default", href = "#gallery"),
         tags$a("Work/Education", class = "btn btn-default", href = "#work"),
         tags$a("Contact", class = "btn btn-default", href = "#contact")
  )
),

# Name
fluidRow(
  column(width = 6, offset = 3,
         div(id =  "name",
               h1(class = "chrome", "Max"),
               h1(class = "dreams", "Blasdel")
  ))
),

# Return to top button
actionButton(inputId = "toTop", 
             class = "Fade",
             icon("angle-up")),

# Who I am
fluidRow(
  column(width = 9, offset = 1,
         div(id =  "who",
             p(class = "chrome header"),
             h4(includeMarkdown("www/career.md"))
         ))
),

# About this site
fluidRow(
  column(width = 9, offset = 1,
         div(id =  "shiny",
             p(class = "chrome header", "Shiny"),
             h4(includeMarkdown("www/shiny.md"))
         ))
),

# Gallery
fluidRow(
  column(width = 9, offset = 1,
         div(id = "gallery",
             p(class = "chrome header", "Gallery"),
             h3(tags$a(href = "gallery/", "Gallery"))
             ))
),

# Work/Education
fluidRow(
  column(width = 9, offset = 1,
         div(id = "work",
             p(class = "chrome header", "Work/Education"),
             h4(includeMarkdown("www/work.md")),
             tags$a("href" = "#", "Link to resume")
         ))
),

# Contact
fluidRow(
  column(width = 9, offset = 1,
         div(id = "contact",
             p(class = "chrome header", "Contact"),
             h3(
               tags$a(href = "mailto: maxblasdel@gmail.com?subject=website%20feedback",  "Email Me")
             ),
             h3(tags$a(href = "https://github.com/mxblsdl", icon(name = "github", lib = "font-awesome"))),
             h3(tags$a(href = "https://www.linkedin.com/in/max-blasdel/", icon(name = "linkedin", lib = "font-awesome")))
         ))
),


# Custom scroll reveal with preset options
my_scroll_reveal("#name", "right"),
my_scroll_reveal("#who", "left"),
my_scroll_reveal("#shiny", "right"),
my_scroll_reveal("#gallery", "left"),
my_scroll_reveal("#work", "right"),
my_scroll_reveal("#contact", "left"),

tags$script(src = "script.js")
);

server <- function(input, output, session) {

};

shinyApp(ui, server)