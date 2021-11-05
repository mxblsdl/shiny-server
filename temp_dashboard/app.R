
source("./global.R")

## UI ------------------------------------------------------
ui <- dashboardPage(

  dashboardHeader(title = "Temp Sensor"),

  dashboardSidebar(
    tags$head(
      tags$style("
               #time, #time-label, #t{
                margin-left:10%;
               };
               ")
    ),

    collapsed = F,
                   sidebarMenu(id = "menu",
                     menuItem("",
                              tabName = "input"),
                     # This doesn't need to be in a conditional panel 
                     # but this syntax may be helpful 
                     conditionalPanel(
                       'input.menu == "input"',
                       div(id = "t", HTML("Near real time temperature <br>and humidity data for<br> my office in NE Portland Oregon.")),
                       
                       shinyWidgets::radioGroupButtons(
                         "time",
                         "Time Frame",
                         selected = 3,
                         size = "lg",
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
    tags$head(
      tags$style("
               .boxxy{
               text-align: center;
               border-left: 5px solid #5fa8c0;
               padding: 1em;
               };
               .boxxy-title{
               text-transform: uppercase;
               };
                 ")
    ),
    # tabItems(
    tabBox(
      title = "", 
      # The id lets us use input$tabset1 on the server to find the current tab
      id = "tabs",
      width = "100%", height = '65%',
      tabPanel("Temperature", g2Output("temp")),
      tabPanel("Humidity", g2Output("humid")),
      tabPanel("Info", includeMarkdown("www/details.md")),
      tabPanel("Office", includeMarkdown("www/office.md"))
    ),
    tabBox(width = '100%',
           tabPanel(title = "Current",
                    fluidRow(
                      column(width = 6, class = "boxxy",
                             h4("Temperature", class = "boxxy-title"),
                             h2(countup::countupOutput("temp_now"))),
                      column(width = 6, class = "boxxy",
                             h4("Relative Humidity", class = "boxxy-title"),
                             h2(countup::countupOutput("humid_now")
                             ))
                    )))
  )
)

server <- function(input, output) { 
  output$temp <- renderG2({
    # React to radio inputs
    dat %...>% 
      subset(., interval >= Sys.time() - hours(as.numeric(input$time))) %...>% 
      g2plot('temperature')
  })

  output$humid  <- renderG2({
    # React to radio inputs
    dat %...>% 
      subset(., interval >= Sys.time() - hours(as.numeric(input$time))) %...>%
      g2plot('humidity') 
  })
  
  # Render the countups
  output$humid_now <- countup::renderCountup({
    now %...>%
      pull("humidity") %...>% 
      countup::countup(
      duration = 8,
      options = list(useEasing = T,
                     suffix = " %") 
    )
  })
  
  output$temp_now <- countup::renderCountup({
    now %...>%
    pull("temperature") %...>% 
    countup::countup(
      duration = 8, 
      options = list(useEasing = T,
                     suffix = " Degrees")
    )
  })
}

shinyApp(ui, server)