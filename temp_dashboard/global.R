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

# return all data points within allotated time frame
Sys.getenv("influx_name")
Sys.getenv("passwd")
Sys.getenv("db")
Sys.getenv("postgre_pswd")

# pull out first time stamp
# now <- dat %...>% .[1, ]

