
library(shiny)
library(shinyjs)
library(colourpicker)
library(darkmode)
library(waiter)

# Define UI for application that draws a histogram
shinyUI(
    fluidPage(
    useShinyjs(),
    use_waiter(),
    includeCSS("www/styles.css"),
    tags$script(src = "myjs.js"),
    
    # Application title
    titlePanel("Minimalist Maps"),
    
    with_darkmode(autoMatchOsTheme = F,
                  time = '0.4s',
                  label = "🌙"),

    # Sidebar with a slider input for number of bins
    sidebarLayout(
        sidebarPanel(
            selectizeInput("country", "Country", 
                        choices = country_names[['NAME']],
                        options = list(
                            placeholder = "Please Select a Country",
                            onInitialize = I('function() {this.setValue(""); }')
                            )
                        ),
            hidden(selectizeInput("add-us", "More Detail [Optional]",
                        choices = c("Alaska", "Hawaii"),
                        options = list(
                            placeholder = "",
                            onInitialize = I('function() {this.setValue(""); }'))
                        )
                   ),
            
            colourpicker::colourInput("line-col", "Line Color", 
                        value = "black",
                        allowTransparent = T,
                        returnName = T),
            colourpicker::colourInput("canvas-col", "Canvas Color", 
                        value = "white",
                        allowTransparent = T,
                        returnName = T),
            radioButtons("detail", "Level of Detail",
                         choices = c("High", # consider another level of detail 
                                     "Low"), 
                         inline = T),
            
            actionButton("gen", "Generate Elevation Map",
                         class= "btn-primary btn-lg")
        ),

    mainPanel(
        # Some about, could be moved to hideable drop down
        fluidRow(id = "methods", 
                 div(class = "header", "Info"),
                 hidden(div(id = "dropdown1", 
                     "Invoke minimal line maps showing the elevation of any country in the world!",
                     br(),
                     "These maps are inspired by a couple notable blog posts and are commonly cited as similar to 'Unknown Pleasures' album artwork"
                     )),
                 ),
        
            # Show elevation map
            hidden(div(id = "main",
                plotOutput("mapOutput"),
                downloadButton("downloadPlot", label = "Download")
            )

        )
    ) # end main panel
    ) # end side bar layout
))
