library(shiny)
library(shinymaterial)
library(shinyjs)
# library(darkmode)
library(leaflet)
library(htmlwidgets)
library(shinipsum)
library(ggiraph)

options(shiny.autoreload = T)

ui <- material_page(
  # fun darkmode settings
  # Take direct inputs
  # darkmode::with_darkmode(autoMatchOsTheme = T,
  #                         mixColor = "#D2D1D6",
  #                         time = '0.2s'),

  title = "PDX Trees",
  nav_bar_fixed = F, 
  nav_bar_color = "green darken-3",
  material_side_nav(
    fixed = F,
    material_side_nav_tabs(
      side_nav_tabs = c("Dashboard" = "dash",
                        "Map" = "map",
                        "Contact" = "contact"), 
      # Icons availble at this website
      # https://materializecss.com/icons.html
      icons = c("dashboard", 
                "map",
                "contacts")
      ),
    material_switch("swi", off_label = "off", on_label = "on")
    ), # end the side nav html
  
  # Define each tab content
  # Introduction and dashboard compoents
  # Possibly some plots and figures
  material_side_nav_tab_content(side_nav_tab_id = "dash",
      h3("Dashboard Content"),
      h4("plots of trees per neighborhood"),

      material_row(id = "controls",
                   material_column(class = "left",
                                   material_switch(
                                     input_id = "switch1",
                                     off_label = "total",
                                     on_label = "per acre",
                                     initial_value = T
                                   )),
                   material_column(class = "left",
                                   material_switch(
                                     input_id = "switch2",
                                     off_label = "Fruit",
                                     on_label = "Nut",
                                     initial_value = T
                                   ))
                   ),
      
      material_row(id = "plots",
                   material_column(class = "center", width = 5, offset = 1,
                                   plotOutput("plot1")
                                   ),
                   material_column(class = "center", width = 5,
                                   plotOutput("plot2")
                   )
                   ),
      
    ),
  
  material_side_nav_tab_content(side_nav_tab_id = "map",
    h3("Leaflet Placeholder"),
    material_row(
      material_column(width = 10, offset = 1,
                      material_depth(leafletOutput("map", width = "100%", height = "70vh"), 
                                     depth = 2)
                      )
    )
                                
  ),
  
    material_side_nav_tab_content(
      side_nav_tab_id = "contact",
      h3("Contact Information")
    ),

  )


server <- function(input, output, session) {
  
  output$plot1 <-renderPlot(
    shinipsum::random_ggplot(type = "col")
  ) 
  
  output$plot2 <-renderPlot(
    shinipsum::random_ggplot(type = "col")
  ) 
  
  output$map <-renderLeaflet(
    leaflet(options = leafletOptions(maxZoom = 20, minZoom = 10, zoomControl = F)) %>%
      htmlwidgets::onRender("function(el, x) {
                          L.control.zoom({position: 'topright'}).addTo(this)
                          }") %>% 
      addProviderTiles(providers$CartoDB.Positron, group = "Default") %>%
      addProviderTiles(providers$Esri.WorldImagery, group = "Satellite") %>% 
      setView(lng = -122.63,
              lat = 45.54,
              zoom = 12) %>%
      setMaxBounds(lng1 = -122.4,
                   lat1 = 45.4,
                   lng2 = -122.8,
                   lat2 = 45.67) %>%
      addLayersControl(baseGroups = c("Default", "Satellite"), 
                       options = layersControlOptions(autoZIndex = F))
    #  leafem::addMouseCoordinates()# %>%
    #addControl(actionButton("map-change", label = "", icon = icon("bars"), class = "leaf-extend"), position = "topleft")
  )
}
  
    

shinyApp(ui, server)
