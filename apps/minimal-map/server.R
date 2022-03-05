#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

# Define server logic required to draw a histogram
shinyServer(function(input, output) {

    observe({
        if(input$country == "") {
            disable("gen")  
        } else {enable("gen")} 
        
        if(input$country == "United States") {
            shinyjs::show(id = "add-us", anim = T, animType = "slide", time = .5)
        }
        }
    )
    
    # some js/css to show hide elements on hover, no transition effects though :(
    onclick("methods", toggle("dropdown1", anim = T, animType = "slide"))

    #onclick()
    # TODO styles
    # TODO add leaflet map of country outline and location
    
    observeEvent(input$gen , {
        
        # display plot output
        show("main")
        
        # create a loading image for plot
        waiter_show(id = "mapOutput", 
                    html = spin_three_bounce(),
                    hide_on_render = T)
        
        # tolerance value translated to high or low
        t <- switch(input$detail,
               "High" = 14,
               "Low" = 6)

        # Custom logic for united state
        # TODO log list counties as I find them
        if(input$`add-us` == "") {
            state <- 1
        } else if (input$`add-us` == "Alaska") {
            state <- 2
            # 3 is some islands, possibly guam
        } else(state <- 4)
        
        # get country
        abvr <- country_names[NAME == input$country, ISO3]
        
         r <- prepare_poly_country(abvr, tol = t, state = state)
         r <- prepare_dt(r)
         r_plot <- prepare_plot(dt = r,
                                fill = input$`canvas-col`,
                                line_col = input$`line-col`)
         
         # render plot
         output$mapOutput <- renderPlot({
             r_plot
         })
        
         # Sys.sleep(3)
         # waiter_hide()
         # TODO fix specify height and width on download
         output$downloadPlot <- downloadHandler(
             filename = function() { paste(input$country, '.png', sep='') },
             content = function(file) {
                 ggsave(file, plot = r_plot, device = "png")
             }
         )
         
         
    }) # end observe event


    
})
