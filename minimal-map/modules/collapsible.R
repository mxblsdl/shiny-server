
# TODO put styling in html

ui_collapsible <-function(id, text) {
  
  ns <- NS(id) # namespaced id
  
  fluidRow(id = ns("methods"), 
           div(class = "header", "Info"),
           div(id = ns("dropdown1"), text
           ),
  )
}


