

# get date and time for given forecast
get_date_time <- function(starttime) {
  d <- gsub("(T.*)", "", starttime)
  t <- gsub("(.*T)", "", starttime)
  t <- gsub("^([^:]*:[^:]*).*", "\\1", t)
  return(list(d,t))
}

# unlist function
fore_unlist <- function(list, n) {
  unlist(list[n], recursive = F)
}

# select icon function
# TODO add as needed
# Add 'is night' to short forecast to make more combinations
fore_icon <- function(fore) {
  return(
    switch(fore,
           "Partly Cloudy" = "bi-cloud-sun",
           "Mostly Cloudy" = "bi-cloudy",
           "Cloudy" = "bi-clouds",
           "Slight Chance Rain Showers" = "bi-cloud-drizzle",
           "Chance Light Rain" = "bi-cloud-drizzle",
           "Chance Rain Showers" = "bi-cloud-drizzle",
           "Rain Showers Likely" = "bi-cloud-rain",
           "Partly Sunny" = "bi-cloud-sun",
           "Mostly Sunny" = "bi-sun",
           "Clear" = "bi-moon",
           "Mostly Clear" = "bi-moon",
           "Light Rain" = "bi-umbrella"
           )
  )
}

# extract maximum and minimum temps
fore_max_min <- function(forecast, startTime, days) {
  # get hours ahead
  h <- days * 24
  # extract initial time and convert to number
  t <- get_date_time(startTime)
  h_to_mid <- h - as.numeric(gsub(":.*", "", t[[2]]))
  
  # create hours for day
  h_seq <- seq(h_to_mid, h_to_mid + h)
  # extract all temps in those hours
  temps <- purrr::map_dfc(h_seq, ~ unlist_forecast(forecast, .x)$temperature)
  
  return(list(max(temps), min(temps)))
}
