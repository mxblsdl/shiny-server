library(influxdbr)
library(plumber)

# 'plumber.R' is the location of the file shown above
pr("plumber/influx.R") %>%
  pr_run(port=8000)
