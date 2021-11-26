library(dplyr)
library(rvest)
library(reactable)

# Globals -----------------------------------------------------------------

webpage <- "https://community.rstudio.com/c/jobs/20"

table <- read_html(webpage) %>% 
  html_table()

table <- table[[1]]

table <-
  table %>% 
  select(Topic, Replies, Views, Activity) %>%
  filter(!grepl("Post Jobs", Topic)) %>% 
  mutate(Topic = gsub("\n.*", "", Topic),
         Keyword = case_when(
           grepl("Shiny", Topic, ignore.case = T) ~ "Shiny",
           grepl("Data Scien.*", Topic, ignore.case = T) ~ "Data Scientist",
           grepl("Analyst", Topic, ignore.case = T) ~ "Analyst",
           grepl("database", Topic, ignore.case = T) ~ "Database",
           grepl("Engineer", Topic, ignore.case = T) ~ "Engineering",
           T ~ "Other")) #%>% 
# Create inter mediate table here
tbl <- 
  table %>%   
  group_by(Keyword) %>% 
  summarize(Replies = sum(Replies),
            Views = sum(Views),
            Count = n()) %>% 
  arrange(desc(Views)) %>% 
  mutate(`Avg. Views` = round(Views / Count, 1))

r_table <- function(key, bg) {
  reactable(select(filter(table, Keyword == key), Details = Topic), wrap = T, 
            theme = reactableTheme(backgroundColor = bg))
}