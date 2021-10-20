library(shiny)
library(shinydashboard)
library(g2r)
library(reticulate)
library(lubridate)
library(dplyr)

## Head --------------------------------------------------
use_python(python = "/usr/bin/python3")
source_python("py/influx_dash.py")
# source_python("temp_dashboard/py/influx.py")

source("R/g2r.R")
source("R/clean_data.R")

readRenviron("~/.Renviron")

# return all data points within allotated time frame
Sys.getenv("influx_name")
Sys.getenv("passwd")
Sys.getenv("db")
Sys.getenv("postgre_pswd")

# def get_temperature_data(hours_back, uname, pswd, db)
  
dat <- get_temperature_data(hours_back = 3, 
                            uname = Sys.getenv("influx_name"),
                            pswd = Sys.getenv("passwd"),
                            db = Sys.getenv("db"))

# convert to West Coast Time
dat$time <- lubridate::with_tz(dat$time,
                               tzone = "America/Los_Angeles")

# pull out first time stamp
now <- dat[1, ]

dat <- clean_data(dat, "5 mins")