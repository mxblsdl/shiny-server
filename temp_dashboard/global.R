library(shiny)
library(shinydashboard)
library(g2r)
library(reticulate)
library(lubridate)
library(dplyr)
library(promises)

## Head --------------------------------------------------
use_python(python = "/usr/bin/python3")
source_python("py/influx_dash.py")
# source_python("temp_dashboard/py/influx_dash.py")

source("R/g2r.R")
source("R/clean_data.R")

# def get_temperature_data(hours_back, uname, pswd, db)

prom <- future_promise(get_temperature_data(hours_back = 24*30, 
                                           uname = Sys.getenv("influx_name"),
                                           pswd = Sys.getenv("passwd"),
                                           db = Sys.getenv("db")))

# convert to West Coast Time
dat <- prom %...>%
  mutate(time = lubridate::with_tz(time,
                                   tzone = "America/Los_Angeles")) %...>% 
  clean_data(., "5 mins")

# pull out first time stamp
now <- dat %...>% .[1, ]

