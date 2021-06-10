

# Define font for reactable
font = "Helvetica"

max_width <- function(vec) {
  vec <- strsplit(as.character(vec), "") 
  
  vec <- sapply(vec, length)
  
  max(vec)
}

# Render a bar chart with a label on the left
bar_chart <- function(label,
                      width = "100%",
                      height = "16px",
                      fill = "#00bfc4",
                      background = NULL,
                      buffer) {
  bar <- div(style = list(background = fill,
                          width = width,
                          height = height, 
                          float = "left"))
  chart <- div(style = list(flexGrow = 2,
                            marginLeft = "8px",
                            background = background),
               bar)
  label <- str_pad(as.character(label), 
                   width = buffer,
                   side = "left",
                   pad = " ")
  div(style = list(display = "flex",
                   whiteSpace = "pre-wrap",
                   alignItems = "center",
                   fontFamily = "Monospace"),
      label,
      chart)
};

# React table function
react_table <- function(data) {
  reactable(
    data,
    defaultColDef = colDef(
      defaultSortOrder = "desc",
      style = list(`font-family` = font),
      align = "center",
      headerStyle = list(background = "#1de9b6", `font-family` = font),
      minWidth = 8,
      headerClass = "bar-sort-header"
    ),
    columns = list(
      MAPLABEL = colDef(name = "Neighborhood",
                        minWidth = 10,
                        style = list(`font-size` = 14,
                                     `font-family` = font)),
      fruit = colDef(show = F),
      nut = colDef(show = F),
      n_trees = colDef(name = "Trees", cell = function(value) {
        width <- paste0(value / max(data[['n_trees']]) * 100, "%")
        bar_chart(value,
                  width = width,
                  background = "#eceff1",
                  buffer = max_width(data[['n_trees']]))
      }),
      acres = colDef(show = F),
      geom = colDef(show = F),
      trees_per_acre = colDef("Trees per Acre", 
                              cell = function(value) {
                                width <- paste0(value / max(data[['trees_per_acre']]) * 100, "%")
                                bar_chart(round(value, 1),
                                          width = width,
                                          fill = "#43a047",
                                          background = "#eceff1",
                                          buffer = max_width(round(data[['trees_per_acre']], 1)))
                              }
      ),
      bordered = T,
      highlight = T,
      showSortIcon = F,
      paginationType = "simple"
    ) 
  ) 
};
