
material_counter <- function(title, value, color) {
  div(
    class = sprintf("boxxy %s", color),
    h3(class = "boxxy-value", value),
    p(class = "boxxy-title", title)
  )
};
