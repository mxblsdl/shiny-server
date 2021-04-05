

# time and date display function
time_display <- function(secs = 0) {
  format(
    strptime(
      gsub(".* ", "", Sys.time()),
      format = '%H:%M:%S'
      ) + secs, 
    '%r',
    tz = "America/Los_Angeles")
}

# Show day with argument for increasing number of days shown
date_display <- function(days = 0) {
  sub(".*?-", "", Sys.Date() + days)
}

# ui functions
dateUI <- function() {
  fluidRow(id = "date", class = "time", 
           Sys.Date(),
           span(class = "right",
                "Last Updated:",
                time_display(0)
           )
  )
}
