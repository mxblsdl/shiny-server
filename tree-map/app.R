library(shiny)
library(shinymaterial)
library(shinyjs)
# library(darkmode)
library(leaflet)
library(htmlwidgets)
library(shinipsum)
#library(ggiraph)

library(sf)
library(dplyr)
library(ggplot2)
library(scales)

options(shiny.autoreload = T)

neigh <- read_sf("data/data.gpkg", layer = "neigh")

# plot function
trees_plot <- function(df, val) {
  gg_df <- ggplot(df) +
    geom_bar(aes(x = reorder(MAPLABEL, .data[[val]]) ,
                 y = .data[[val]],
                 fill = .data[[val]]
    ),
    stat = "identity") +
    theme_classic() +
    labs(x = element_blank()) +
    scale_y_continuous(labels = comma) +
    theme(axis.text.x = element_text(angle = 45, hjust = 1, size = 12),
          panel.background = element_rect(fill = '#f7f0d2'),
          plot.background = element_rect(fill = '#f7f0d2')) +
    scale_x_discrete(labels = function(x) gsub("d I", 'd\nI', x)) +
    theme(legend.position = "none")
  
  gg_df + if(val == "n_trees") {
    labs(y = "Total Trees")
  } else {
    labs(y = "Trees Per Acre") 
  }
}

# TODO revisit original data there appears to be issues with it
# TODO change neighborhood names to be more understandable

# TODO have leaflet display popups
# TODO Get switches to change map and graph
# TODO second map should have individual trees
# TODO change switch to be total or fruit/nut


ui <- material_page(

  tags$style("
             .switch label .lever {
             background-color:rgba(44, 161, 245, .5);
             }
             .switch label .lever:after {
             background-color:rgba(44, 161, 245, .9);
             }
             "),
  
  title = "PDX Trees",
  nav_bar_fixed = F, 
  nav_bar_color = "green darken-3",
  
  # side panel
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
    
    # switch not doing anything right now
    material_switch("swi", off_label = "off", on_label = "on")
    ), # end the side nav html
  
  # Define each tab content
  material_side_nav_tab_content(side_nav_tab_id = "dash",
      h3("Dashboard Content"),
      # information about this app
      h3("Some intro text"),
      
      h4("plots of trees per neighborhood"),

      material_row(id = "controls",
                   material_column(class = "left",
                                   material_switch(
                                     input_id = "switch1",
                                     off_label = "Total",
                                     on_label = "Per Acre",
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
      
      # main dashboard outputs
      material_row(id = "plots",
                   material_column(class = "center", width = 5, offset = 1,
                                   plotOutput("plot1")
                                   ),
                   material_column(class = "center", width = 6,
                                   leafletOutput("dash-map",
                                                 width = "100%",
                                                 height = "55vh")
                   )
                   )
      
    ),
  
  # Second leaflet map
  material_side_nav_tab_content(side_nav_tab_id = "map",
    h3("Leaflet Placeholder"),
    material_row(
      material_column(width = 10, offset = 1,
                      material_depth(leafletOutput("map", 
                                                   width = "100%",
                                                   height = "70vh"),
                                     depth = 2)
                      )
      )
  ),
  
  # Contact Card 
  material_side_nav_tab_content(
      side_nav_tab_id = "contact",
      h3("Contact Information")
      )

) # end UI

# Server ------------------------------

server <- function(input, output, session) {

  # Make part of leaflet to a function
  neigh[is.na(neigh)] <- 0
  
  # first switch input
  t <- reactive({
    ifelse(input$switch1, "trees_per_acre", "n_trees")
  })
  
  # plot of number of trees next to map of neighborhoods colored by number of trees
  # toggle changes per acre to gross values
  output$plot1 <- renderPlot({
    val <- t()
    plot_data  <- neigh %>% 
        arrange(desc(.data[[val]])) %>% 
        slice(1:5) %>% 
        mutate(MAPLABEL = factor(MAPLABEL))
    print(val)
    # create plot
    trees_plot(plot_data, val)
  })

  # TODO define mapval
  mapval <- "n_trees"
  
  pal <- colorQuantile(palette = 'Blues',
                     domain = neigh[[mapval]],
                     n = 5)

  # labels <- sprintf(
  #     "<strong>%s</strong><br/>%g people / mi<sup>2</sup>",
  #     states$name, states$density
  #   ) %>% lapply(htmltools::HTML)

  # render the basic basemap set to the correct view & zoom
  output$`dash-map` <- renderLeaflet({
    leaflet(options = leafletOptions(maxZoom = 20,
                                     minZoom = 10,
                                     zoomControl = F)) %>%
      htmlwidgets::onRender("function(el, x) {
                          L.control.zoom({position: 'topright'}).addTo(this)
                          }") %>%
      addProviderTiles(providers$CartoDB.Positron, group = "Default") %>%
  #    addProviderTiles(providers$Esri.WorldImagery, group = "Satellite") %>% 
      setView(lng = -122.63,
              lat = 45.54,
              zoom = 10) %>%
      setMaxBounds(lng1 = -122.4,
                   lat1 = 45.4,
                   lng2 = -122.8,
                   lat2 = 45.67)# %>%
      # addLayersControl(baseGroups = c("Default", "Satellite"), 
      #                  options = layersControlOptions(autoZIndex = F))
  })
  
  # add polygon layer
  leafletProxy("dash-map", data = neigh) %>% 
  addPolygons(stroke = T
              , weight = 1
              # use get() here
              , fillColor = ~pal(get(mapval))
              , color = "white"
              , dashArray = "2"
              , fillOpacity = 0.7
              , highlight = highlightOptions(
                weight = 5
                , color = "#999"
                , dashArray = ""
                , fillOpacity = .7
                , bringToFront = T)
              #   weight = 5,
              #   color = "#666",
              #   dashArray = "",
              #   fillOpacity = 0.7,
              #   bringToFront = TRUE)
  )

# map specific tab
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
