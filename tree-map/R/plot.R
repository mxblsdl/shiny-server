
# plot function
trees_plot <- function(df, val) {
  g2 <- g2(df, asp(x = MAPLABEL,
                   , y = .data[[val]],
                   color = .data[[val]])) %>% 
    fig_interval() %>% 
    gauge_color_rdylbu() %>%
    legend_color(F) %>% 
    axis_x(label = list(autoRotate = T,
                        style = list(fontSize = 20)))
  
  g2 <- g2 %>% axis_title_y(title = switch(val, 
                                           "n_trees" = "Total Trees",
                                           "trees_per_acre" = "Trees Per Acre"), fontSize = 18)
  
  g2$sizingPolicy$padding <- 15
  g2
} 