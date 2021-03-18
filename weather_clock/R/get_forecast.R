# POC with reticulate
# 
# library(reticulate)
# 
# # make sure to set which python
# use_python("usr/bin/python3")
# 
# # install api package
# # py_install("noaa-sdk", pip = T)
# 
# # Source python function
# source_python("forecast.py")
# 
# # call observation for zip code
# # Returns six and a half days of weather
# forecast <- get_observations("97218")
# 
# # get date and time for given forecast
# get_date_time <- function(starttime) {
#   d <- gsub("(T.*)", "", starttime)
#   t <- gsub("(.*T)", "", starttime)
#   t <- gsub("^([^:]*:[^:]*).*", "\\1", t)
#   return(list(d,t))
# }
# 
# # define times for forecast
# times <- c(1,2,3, 24, 48, 72)
# forecast_trim <- forecast[times]
# 
# # unlist function
# unlist_forecast <- function(list, n) {
#   unlist(list[n], recursive = F)
# }
# 
# # create objects to display
# now <- unlist_forecast(forecast, 1)
# hour_2 <- unlist_forecast(forecast, 2)
# hour_3 <- unlist_forecast(forecast, 3)
# day_2 <- unlist_forecast(forecast, 4)
# day_3 <- unlist_forecast(forecast, 5)
# day_4 <- unlist_forecast(forecast, 6)
# 
# 
# 
#   
#   