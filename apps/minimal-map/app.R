library(shiny)

source("ui.R", local = T)
source("server.R")

options(shiny.autoreload = T)

shinyApp(ui, server)
