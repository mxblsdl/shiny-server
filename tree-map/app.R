library(shiny)
library(shinymaterial)
library(shinyjs)
# library(darkmode)
library(leaflet)
library(htmlwidgets)
library(countup)
# library(shinipsum)
# library(ggiraph)

library(sf)
library(dplyr)
# library(ggplot2)
# library(scales)
library(g2r)

library(odbc)
library(DBI)
library(RPostgreSQL)

options(shiny.autoreload = T)

readRenviron("~/.Renviron")
con <- dbConnect(PostgreSQL(),
                 , host = Sys.getenv("postgre_ip")
                 , port = '5432'
                 , dbname = 'parks'
                 , user = 'max'
                 , password = Sys.getenv("postgre_pswd"))

# con <- "data/data.gpkg"

neigh <- read_sf(con, layer = "neigh")
trees <- read_sf(con, layer = "park_trees")
parks <- read_sf(con, layer = "park")

# close connection once data is loaded
dbDisconnect(con)

# plot function
trees_plot <- function(df, val) {
  g2 <- g2(df, asp(x = MAPLABEL,
              , y = .data[[val]],
              color = .data[[val]])) %>% 
    fig_interval() %>% 
    gauge_color_rdylbu() %>%
    legend_color(F) %>% 
    axis_x(label = list(autoRotate = T,
                        style = list(fontSize = 20)))

  g2 <- g2 %>% axis_title_y(title = switch(val, 
                 "n_trees" = "Total Trees",
                 "trees_per_acre" = "Trees Per Acre"), fontSize = 18)
  
  g2$sizingPolicy$padding <- 15
  g2
};

material_counter <- function(title, value, color) {
  div(
    class = sprintf("boxxy %s", color),
    h3(class = "boxxy-value", value),
    p(class = "boxxy-title", title)
  )
};

# Include postgres setup 
# TODO change switch to be total or fruit/nut

ui <- material_page(

  # Header ------------------------------------------------------
  tags$style("
             .switch *{
             font-size:2em;
             }
             .switch label .lever {
             background-color:rgba(44, 161, 245, .5);
             }
             .switch label .lever:after {
             background-color:rgba(44, 161, 245, .9);
             }
             .shiny-material-side-nav-tab-content {
             padding-left:20px;
             padding-right:20px;
             }
             .boxxy{
               text-align: center;
               border-left: 6px solid #073b4c;
               padding: 1em;
             }
             .boxxy-title{
               text-transform: uppercase;
             }
             .boxxy-value{
               font-size: 3em;
             }
             .legend{
             text-align:left;
             }
             "),
  # JBox
  tags$head(
    tags$script(
      src = paste0(
        "https://cdn.jsdelivr.net/gh/StephanWagner/",
        "jBox@v1.2.0/dist/jBox.all.min.js"
      )
    ),
    tags$link(
      rel = "stylesheet",
      href = paste0(
        "https://cdn.jsdelivr.net/gh/StephanWagner/",
        "jBox@v1.2.0/dist/jBox.all.min.css"
      )
    ),
    tags$script(
      "Shiny.addCustomMessageHandler(
        type = 'load-notice', function(message) {
          new jBox('Notice', {
            id: 'loading',      
            content: message,
            closeButton:true,
            autoClose:3000,
            color: 'red',
            stack: false,
            responsiveHeight:true,
            animation: 'slide'
          });
        });
      "
    )
  ),
  
  title = "PDX Trees",
  nav_bar_fixed = F, 
  nav_bar_color = "green darken-3",
  
  # side panel -------------------------------------------------
  material_side_nav(
    fixed = F,
    material_side_nav_tabs(
      side_nav_tabs = c("Dashboard" = "dash",
                        "Map" = "map",
                        "Contact" = "contact",
                        "Data/Sources" = 'data_usage'), 
      # Icons availble at this website
      # https://materializecss.com/icons.html
      icons = c("dashboard", 
                "map",
                "contacts",
                "data_usage")
      ),
    
    # switch not doing anything right now
    material_card(title = "Postgres",
                  color = "grey lighten-2",
                  HTML("<p>Data loaded from Postgres database. See link for DB setup</p>
                       <br>
                       <a href = '../postgres/'>PostgreSQL Setup</a>")
                       )

    ), # end the side nav html
  
  # Main Tab ------------------------------------------
  material_side_nav_tab_content(side_nav_tab_id = "dash",
      h2("Trees of Portland Summary"),
      includeMarkdown("www/park_trees.md"),
      
      # Material Colors
      # https://materializecss.com/color.html
      # information about this app
      h3("Neighborhoods, trees and parks"),
      material_row(
        material_column(
          material_counter(title = "Park Trees",
                           value = countupOutput("cnt_park"),
                           color = "teal darken-2"),
          width = 4, offset = 1),
        material_column(
          material_counter(title = "Street Trees",
                           value = countupOutput("cnt_neigh"),
                           color = "teal accent-3"),
          width = 4, offset = 3)
      ),
      
      material_row(id = "controls",
                   material_column(width = 4,
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
                                         initial_value = 5)
                     ),
                   material_column(width = 3, offset = 1,
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
                                   g2Output("plot1")
                                   ),
                   material_column(class = "center", width = 6,
                                   leafletOutput("dash-map",
                                                 width = "100%",
                                                 height = "55vh")
                   )
                   )
      
    ),
  
  # Second leaflet map ---------------------------------------------
  material_side_nav_tab_content(side_nav_tab_id = "map",
    h3("Park Trees"),
    
    material_row(
      material_column(width = 10, class = "center",
                    includeMarkdown("www/map_tab.md")
#                      div("Portland Urban Forestry conducted")
                      )
    ),
    material_row(
      material_column(width = 10, offset = 1,
                      material_depth(leafletOutput("map", 
                                                   width = "100%",
                                                   height = "70vh"),
                                     depth = 2)
                      )
      )
  ),
  
  # Contact Card ------------------------------------------------
  material_side_nav_tab_content(
      side_nav_tab_id = "contact",
      h3("Made by Max for fun"),
      a(href = "http://www.maxblasdel.com", "My Website")
      ),

# Sources
  material_side_nav_tab_content(
    side_nav_tab_id = "data_usage",
    
    material_row(
      material_column(class = 'leftr',
                      offset = 3,
                      width = 6,
                      h3("Data used in this application"),
                      tags$li(
                        tags$a("Street Trees",
                               href = "https://gis-pdx.opendata.arcgis.com/datasets/street-trees?geometry=-123.198%2C45.452%2C-122.108%2C45.621", 
                               target = "_blank")
                      ),
                      tags$li(
                        tags$a("Park Trees",
                               href = "https://gis-pdx.opendata.arcgis.com/datasets/parks-tree-inventory", 
                               target = "_blank")),
                      tags$li(
                        tags$a("Other Portland Data",
                               href = "https://gis-pdx.opendata.arcgis.com/", 
                               target = "_blank")),
                        
                        h3("Code used to process data"),
                        tags$a("Github link", 
                               href = "https://github.com/mxblsdl/tree_map",
                               target = "_blank"),
                        p("Note that the github repo was created as a stand alone app at one point but the outputs were migrated to a newer server and updated significantly."),
                      br(),
                      p("Some analysis was done to aggregate and prepare the data before being displayed on this site")
      )
    )
  )
) # end UI

# Server ------------------------------

server <- function(input, output, session) {


  
  shinyjs::onclick("switch2_switch",
                   session$sendCustomMessage(
                     type = "load-notice",
                     message = "oops, this functionality isn't built yet"
                   )
                  )
  # Make part of leaflet to a function
  neigh[is.na(neigh)] <- 0
  
  # first switch input
  t <- reactive({
      ifelse(input$switch1, "trees_per_acre", "n_trees")
  })
  
  # Count up number of trees
  output$cnt_park <- renderCountup({
    countup(count = nrow(trees), start_at = 0)
  })

  output$cnt_neigh <- renderCountup({
    countup(sum(neigh[["n_trees"]]), start_at = 0)
  })

  # plot of number of trees next to map of neighborhoods colored by number of trees
  # toggle changes per acre to gross values
  output$plot1 <- renderG2({
    graph_size <- input$graph
    val <- t()
    plot_data  <- neigh %>% 
        arrange(desc(.data[[val]])) %>% 
        slice(1:graph_size) %>% 
        mutate(MAPLABEL = factor(MAPLABEL)) %>% 
        as.data.frame()
    
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
  
  qs <- 5
  # create color scale
  pal <- colorQuantile(palette = 'Blues',
                       domain = neigh[[colorBy]],
                       n = qs)
  
  qpal_colors <- unique(pal(sort(neigh[[colorBy]]))) # hex codes
  qpal_labs <- quantile(neigh[[colorBy]], seq(0, 1, 1/qs)) %>% 
    round(2)# depends on n from pal
  qpal_labs <- paste(lag(qpal_labs), qpal_labs, sep = " - ")[-1] # first lag is NA
  
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
    clearShapes() %>%
    clearControls() %>%
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
    ) %>%   
    addLegend("bottomright", 
                 colors = qpal_colors,
                 labels = qpal_labs,
                 title = valueVar
    )
  }) 

# TODO delay load until clicked on
# map specific tab
tree_pop <- glue::glue("<strong> { trees[['Common_name']] } </strong> <br>
             Annual Benefits: {trees[['Total_Annual_Benefits']]}
             ")
              
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
                  fill = "transparent",
                  popup = parks[["NAME"]],
                  popupOptions = list(className = "pop")) %>%
      addAwesomeMarkers(data = trees,
                        popup = tree_pop,
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
  
  # Create notice when non working switch is set
  observeEvent(input$switch2, {
    session$sendCustomMessage(
      type = "load-notice",
      message = "oops, this functionality isn't built yet"
    )
  }, ignoreInit = T);
  
  
}
  





    

shinyApp(ui, server)
