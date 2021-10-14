# Plotting function
g2plot <- function(x, metric) {
  x %>% 
    dplyr::mutate(interval = strftime(interval, format = "%m-%d %I:%M %p")) %>%
    g2(., asp(interval, .data[[metric]])) %>% 
    fig_line() %>% 
    fig_area() %>% 
    axis_x(label = list(autoRotate = T,
                        style = list(fontSize = 12)))
}