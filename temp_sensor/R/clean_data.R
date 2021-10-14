clean_data <- function(x, interval) {
  stopifnot(is.character(interval))
  # clean out obviously wrong humidity readings
  x <- subset(x, humidity < 100)
  
  # clean out outliers greater than 4 SD
  x <- x %>%
    mutate(scale = scale(temperature)) %>%
    filter(scale < 4 & scale > -4) %>% 
    select(-scale)
  
  # Average to 5 minute intervals
  x <- x %>% 
    group_by(interval = round_date(time, interval)) %>%
    summarize(across(c(temperature, humidity), mean))
  return(x)
}