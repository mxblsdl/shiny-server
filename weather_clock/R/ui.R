

# time and date display function
time_display <- function(secs = 0) {
  format(strptime(gsub(".* ", "", Sys.time()), format='%H:%M:%S') + secs, '%r')
}


date_display <- function(days = 0) {
  sub(".*?-", "", Sys.Date() + days)
}

# ui functions
# TODO make sure this refreshes
dateUI <- function() {
  fluidRow(id = "date", 
           Sys.Date(),
           span(class = "right",
                "Last Updated:",
                time_display(0)
           )
  )
}
