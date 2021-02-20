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

library(odbc)
library(DBI)
options(shiny.autoreload = T)

# con <- dbConnect(RPostgreSQL::PostgreSQL(),
#                  , host = Sys.getenv("postgre_ip")
#                  , port = '5432'
#                  , dbname = 'parks'
#                  , user = 'max'
#                  , password = Sys.getenv("postgre_pswd"))

con <- "data/data.gpkg"

neigh <- read_sf(con, layer = "neigh")
trees <- read_sf(con, layer = "park_trees")
parks <- read_sf(con, layer = "park")

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
          panel.background = element_rect(fill = "#f0f0f0"),
          plot.background = element_rect(fill = "#f0f0f0")) +
    scale_x_discrete(labels = function(x) gsub("d I", 'd\nI', x)) +
    theme(legend.position = "none")
  
  gg_df + labs(y = switch(val, 
                 "n_trees" = "Total Trees",
                 "trees_per_acre" = "Trees Per Acre"))
}

# TODO change .Renviron to correct IP address of db
# TODO write up description of project a bit
# Include postgres setup 
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
      h2("Trees of Portland Summary"),
      
      # information about this app
      h3("Neighborhoods, trees and parks"),
      
#      h4("plots of trees per neighborhood"),

      material_row(id = "controls",
                   material_column(width = 3,
                                   material_switch(
                                     input_id = "switch1",
                                     off_label = "Total",
                                     on_label = "Per Acre",
                                     initial_value = T
                                   )),
                   material_column(width = 2,
                     material_number_box("graph",
                                         label = "Neighborhoods",
                                         max_value = 15,
                                         min_value = 3,
                                         initial_value = 5)),
                   material_column(class = "right",
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
      h3("Made by Max for fun"),
      a(href = "http://www.maxblasdel.com", "My Website")
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
    graph_size <- input$graph
    val <- t()
    plot_data  <- neigh %>% 
        arrange(desc(.data[[val]])) %>% 
        slice(1:graph_size) %>% 
        mutate(MAPLABEL = factor(MAPLABEL))
    
    # create plot
    trees_plot(plot_data, val)
  })

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
observe({
  # Get selected column
  colorBy <- t()
  
  # create color scale
  pal <- colorQuantile(palette = 'Blues',
                       domain = neigh[[colorBy]],
                       n = 5)
  
  # Create pop-up based on switch input
  valueVar <- switch(colorBy,
                     "n_trees" = "Number of Trees",
                     "trees_per_acre" = "Trees per Acre")
  
  popup <- glue::glue("<strong> { neigh[['MAPLABEL']] } </strong> <br>
             {valueVar}: {round(neigh[[colorBy]], 2)}
             ")
  
  # add polygons to map
  leafletProxy("dash-map", 
               data = neigh) %>%
    addPolygons(stroke = T
                , weight = 1
                , fillColor = ~pal(get(colorBy))
                , color = "white"
                , dashArray = "2"
                , fillOpacity = 0.7
                , popup = popup
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
  }) 

# TODO delay load until clicked on
# map specific tab
  output$map <-renderLeaflet(
    leaflet(options = leafletOptions(maxZoom = 18, minZoom = 10, zoomControl = F)) %>%
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
                       options = layersControlOptions(autoZIndex = F)) %>%
      addPolygons(data = parks,
                  color = "#a5bda0",
                  fill = F,
                  popup = paste(parks[["NAME"]]),
                  popupOptions = list(className = "pop")) %>%
      addAwesomeMarkers(data = trees,
                        icon = makeAwesomeIcon(
                          icon = "tree",
                          library = "fa",
                          markerColor = "lightgreen",
                          iconColor = "green"
                        ),
                        clusterOptions = markerClusterOptions(spiderfyOnMaxZoom = T,
                                                              showCoverageOnHover = T,
                                                              spiderLegPolylineOptions = "width = 5")
  )
  
  # TODO add event on click
  # observe({
    # leafletProxy("map") %>%
    #   addPolygons(data = parks,
    #               color = "#a5bda0",
    #               fill = F,
    #               popup = paste(parks[["NAME"]]),
    #               popupOptions = list(className = "pop")) %>%
    #   addAwesomeMarkers(data = trees,
    #                     icon = makeAwesomeIcon(
    #                       icon = "tree",
    #                       library = "fa",
    #                       markerColor = "lightgreen",
    #                       iconColor = "green"
    #                     ),
    #                     clusterOptions = markerClusterOptions(spiderfyOnMaxZoom = T,
    #                                                           showCoverageOnHover = T,
    #                                                           spiderLegPolylineOptions = "width = 5")
      # )
    # }
  )
  
}
  





    

shinyApp(ui, server)
