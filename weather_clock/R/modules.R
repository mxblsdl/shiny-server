

# modules
iconUI <- function(id) {
  ns <- NS(id)
  uiOutput(ns("fore"))
}

# create icon and short weather widget
iconServer <- function(id, icon, temp, desc) {
  moduleServer(id,
               function(input, output, session) {
                 output$fore <- renderUI({
                   ns <- session$ns
                   div(
                     tags$i(id = ns("img"),
                            class = paste(icon, "icon")),
                     span(id = ns("short"), desc),
                     div(id = ns("tem"), 
                         if(is.list(temp)) {
                       HTML(paste(
                         paste("High:", temp[[1]]),
                         "<span>F&#176;</span>",
                         paste("Low:", temp[[2]])
                       ))
                     } else {
                       temp
                     },
                     HTML("<span>F&#176;</span>"))
                   )
                 })  
               })
}