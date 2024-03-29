
library(shiny)
library(reticulate)
library(waiter)

options(shiny.autoreload = T)

# make sure to set which python
use_python("usr/bin/python3")

# install api package if needed
# reticulate::install_miniconda()
# py_install("noaa-sdk", pip = T)

# Source python function
source_python("py/forecast.py")

# Define UI for application that draws a histogram
ui <- fluidPage(
    waiter_use(),
    waiter_show_on_load(
        html = spin_wandering_cubes()
            ),
    # Include bootstrap icons
    # https://icons.getbootstrap.com/
    tags$head(
        tags$link(rel = "stylesheet", href = "https://cdn.jsdelivr.net/npm/bootstrap-icons@1.4.0/font/bootstrap-icons.css")
    ),

    # TODO move to css file
    # TODO keep description in its own box
    tags$style(
        "
        h3{
        # border-color:red;
        # border-style:solid;
        # border-width:1px;
        }
        .icon{
        font-size:3em;
        }
        .right{
        float:right;
        }
        #date{
        margin-left:10px;
        margin-right:10px;
        font-size: 2em;
        }
        .description {
        font-size: 1.4em;
        }
        body{
        background-color:#f5f5f5;
        }
        * {
        color: #262626;    
        }
        .fore{
        border-style:solid;
        border-color:black;
        border-width:1px;
        border-radius:5px;
        margin:0 15px 10px 15px;
        padding: 0 5px 0 5px;
        }
        "
    ),

    # Application title
    titlePanel("Weather Clock"),

    # display date and time
    uiOutput("timestamp"),
#    dateUI(),

    # display weather results
    fluidRow(
        column(3, class = "fore",
            h3("Current"),
            iconUI("now"),
        ), 
        column(3
               , class = "fore",
               h3(time_display(3600)),
               iconUI("hour1")),
        column(3,
               class = "fore",
               h3(time_display(7200)),
               iconUI("hour2"))

    ),
    fluidRow(
        column(3, class = "fore",
               h3(date_display(1), weekdays(Sys.Date() + 1)),
               iconUI("next1")),
        column(3, class = "fore",
               offset = 1,
               h3(date_display(2), weekdays(Sys.Date() + 2)),
               iconUI("next2")),
        column(3, class = "fore",
               offset = 1,
               h3(date_display(3), weekdays(Sys.Date() + 3)),
               iconUI("next3"))
        )
)

# Define server logic required to draw a histogram
server <- function(input, output, session) {
    # waiter_show(
    #     html = spin_wandering_cubes()
    # )
    # Initial time
    output$timestamp <- renderUI(dateUI())
    observe({
        invalidateLater(60000, session)
       output$timestamp <- renderUI(dateUI())
    })
    

    #Initial forecast
    forecast <-reactive({
        get_observations("97218")
        })

    # call observation for zip code
    # Returns six and a half days of weather
    forecast <- reactive({
        invalidateLater(60000, session)
        f <- get_observations("97218")
    })
    
    observe({
    now <- fore_unlist(forecast(), 1)
    hour1 <- fore_unlist(forecast(), 2)
    hour2 <- fore_unlist(forecast(), 3)
    next1 <- fore_unlist(forecast(), 24)
    next2 <- fore_unlist(forecast(), 48)
    next3 <- fore_unlist(forecast(), 72)  
    
    # List time of forecast
    # TODO Show next day high lows
    # TODO add more arguments to module function
    iconServer("now",
               icon = fore_icon(now$shortForecast),
               temp = now$temperature, 
               desc = now$shortForecast)
    
    iconServer("hour1", 
               fore_icon(hour1$shortForecast),
               hour1$temperature, 
               desc = hour1$shortForecast)
    
    iconServer("hour2",
    fore_icon(hour2$shortForecast),
            hour2$temperature,
            hour2$shortForecast)

    # Next three days
    iconServer("next1", 
            fore_icon(next1$shortForecast),
            fore_max_min(forecast(), now$startTime, days = 1),
            next1$shortForecast)

    iconServer("next2", 
            fore_icon(next2$shortForecast),
            fore_max_min(forecast(), now$startTime, days = 2),
            next2$shortForecast)

    iconServer("next3", 
            fore_icon(next3$shortForecast),
            fore_max_min(forecast(), now$startTime, days = 3),
            next3$shortForecast)
    waiter_hide()
    })

}

# Run the application 
shinyApp(ui = ui, server = server)


