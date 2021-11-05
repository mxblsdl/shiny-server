library(shiny)
library(shinydashboard)
library(g2r)
library(reticulate)
library(lubridate)
library(dplyr)
<<<<<<< HEAD
<<<<<<< HEAD
=======
library(promises)
>>>>>>> add dashboard to dev
=======
library(promises)
>>>>>>> 4a31d614992dce6b225ec9a80a64beef7638cea5

## Head --------------------------------------------------
use_python(python = "/usr/bin/python3")
source_python("py/influx_dash.py")
<<<<<<< HEAD
<<<<<<< HEAD
# source_python("temp_dashboard/py/influx.py")
=======
# source_python("temp_dashboard/py/influx_dash.py")
>>>>>>> add dashboard to dev
=======
# source_python("temp_dashboard/py/influx_dash.py")
>>>>>>> 4a31d614992dce6b225ec9a80a64beef7638cea5

source("R/g2r.R")
source("R/clean_data.R")

<<<<<<< HEAD
<<<<<<< HEAD
readRenviron("~/.Renviron")

# return all data points within allotated time frame
Sys.getenv("influx_name")
Sys.getenv("passwd")
Sys.getenv("db")
Sys.getenv("postgre_pswd")

# def get_temperature_data(hours_back, uname, pswd, db)
  
dat <- get_temperature_data(hours_back = 24*30, 
                            uname = Sys.getenv("influx_name"),
                            pswd = Sys.getenv("passwd"),
                            db = Sys.getenv("db"))

# convert to West Coast Time
dat$time <- lubridate::with_tz(dat$time,
                               tzone = "America/Los_Angeles")

# pull out first time stamp
now <- dat[1, ]

dat <- clean_data(dat, "5 mins")
=======
=======
>>>>>>> 4a31d614992dce6b225ec9a80a64beef7638cea5
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

<<<<<<< HEAD
>>>>>>> add dashboard to dev
=======
>>>>>>> 4a31d614992dce6b225ec9a80a64beef7638cea5
