library(plumber)
library(rmarkdown)

# Set the render function to listen on port 8000
pr("plumber/render.R") %>%
  pr_run(port=8000)
