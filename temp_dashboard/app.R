
source("./global.R")

## UI ------------------------------------------------------
ui <- dashboardPage(
  dashboardHeader(title = "Temp Sensor"),
  
  dashboardSidebar(collapsed = F,
                   sidebarMenu(id = "menu",
                     menuItem("",
                              tabName = "input"),
                     # This doesn't need to be in a conditional panel 
                     # but this syntax may be helpful 
                     conditionalPanel(
                       'input.menu == "input"',
                       HTML("Near real time temperature <br>and humidity data for<br> my office in NE Portland Oregon."),
                       
                       shinyWidgets::radioGroupButtons(
                         "time",
                         "Time Frame",
                         selected = 3,
                         size = "normal",
                         direction = "vertical",
                         status = "primary" ,
                         justified = F,
                         choiceNames = c("3H",
                                         "1D",
                                         "1W",
                                         "1M"),
                         choiceValues = c(3,
                                          24,
                                          24 * 7,
                                          24 * 30)
                       )
                     )
                   )
                   ),
  
  dashboardBody(
    # tabItems(
    tabBox(
      title = "",
      # The id lets us use input$tabset1 on the server to find the current tab
      id = "tabs",
      width = "100%",
      tabPanel("Temperature", g2Output("temp")),
      tabPanel("Humidity", g2Output("humid")),
      tabPanel("Info", includeMarkdown("www/details.md")),
      tabPanel("Office", "Add picture of office")
    ),
    tabBox(width = '100%',
           tabPanel(title = "Current",
                    fluidRow(
                      column(width = 6,
                             h4("Temperature"),
                             h2(countup::countup(
                               now[["temperature"]], options = list(useEasing = T,
                                                                    suffix = " Degrees")
                             ))),
                      column(width = 6,
                             h4("Relative Humidity"),
                             h2(countup::countup(
                               now[["humidity"]], options = list(useEasing = T,
                                                                 suffix = " %")
                             )))
                    )))
  )
)

server <- function(input, output) { 
  output$temp <- renderG2({
    # React to radio inputs
    d <- subset(dat, interval >= now[["time"]] - hours(as.numeric(input$time)) )
    
    g2plot(d, 'temperature')
  })

  output$humid  <- renderG2({
    # React to radio inputs
    d <- subset(dat, interval >= now[["time"]] - hours(as.numeric(input$time)) )
    
    g2plot(d, 'humidity')
  })
  
  }

shinyApp(ui, server)