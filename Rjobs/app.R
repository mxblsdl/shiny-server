library(bslib)
library(shiny)

source("global.R")


table_bg <- "rgb(240, 240, 240)"

# bs_theme_preview()
th <- bs_theme_update(
    bs_theme(version = 5, bootswatch = "materia"),
    bg = "rgb(240, 240, 240)",
    primary = "#6A98CA",
    # secondary = "#BB95CE",
    heading_font = font_google("Roboto"),
    font_scale = 1.45,
    fg = "#000",
    'grid-gutter-width' = '3rem',
    'body-text-align' = "center"
    # 'link-color' = "red"
)

## For interactively setting the theme run
# bs_theme_preview(th)
## outside of the shiny app


## The preview will output R code to update the theme based on 
## inputs in the shiny app
# th <- bs_theme_update(th, primary = "#787F37", font_scale = NULL, 
#                 bootswatch = "darkly")


# UI ----------------------------------------------------------------------

# Define UI for application that draws a histogram
ui <- fluidPage(title = "Job Board",
    theme = th,

    # Application title
    titlePanel("R Studio Jobs Board Summary"),

    # Sidebar with a slider input for number of bins 
        fluidRow(
            column(6,
                "Snapshot of RStudio job postings by keywords"
            ),
            column(6,
                actionButton(inputId = "job-link", label = HTML("<a href = 'https://community.rstudio.com/c/jobs/20'>Job Board</a>"))   
            )
        ),

        # Show a plot of the generated distribution
        fluidRow(
            column(10, offset = 1,
                reactableOutput("jobs")
                )
            ),
    fluidRow(
        column(10,
               "Gives an overview of what keywords are popular in the RStudio job postings board.")
    )
)


# Server ------------------------------------------------------------------



# Define server logic required to draw a histogram
server <- function(input, output) {
    
    # Use to enter into an interactive styling for limited 
    # number of elements
    # output$link_count <- renderText(input$link)
    
    output$jobs <- renderReactable({
        reactable(
            select(tbl, -Views),
            details = function(index) {
                switch(tbl[[index, "Keyword"]],
                       "Other" = r_table("Other", table_bg),
                       "Shiny" = r_table("Shiny", table_bg),
                       "Analyst" = r_table("Analyst", table_bg),
                       "Data Scientist" = r_table("Data Scientist", table_bg),
                       "Engineering" = r_table("Engineering", table_bg),
                       "Database" = r_table("Database", table_bg))
            },
            highlight = T,
            borderless = T,
            showSortIcon = T,
            theme = reactableTheme(color = "black",
                                   backgroundColor = table_bg, 
                                   style = list(
                                       fontFamily = "-apple-system, BlinkMacSystemFont, Segoe UI, Helvetica, Arial, sans-serif"
                                   )
            )
        )
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
