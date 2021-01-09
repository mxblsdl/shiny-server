


library(shiny)
source("modules/mod_login.R")



# login form as defined in the module
login_ui(id = "module_login", title = "Please login"),

# app 
uiOutput(outputId = "display_content_module"),



# create user base
user_base_module_tbl <- data.table(
  user_name = "max",
  password  = "pass"
)

# check credentials vs tibble 
validate_password_module <- callModule(
  module   = validate_pwd, 
  id       = "module_login", 
  data     = user_base_module_tbl, 
  user_col = 'user_name', 
  pwd_col  = 'password'
)


# authentication success message
output$display_content_module <- renderUI({
  
  req(validate_password_module())
  
  div(
    class = "bg-success",
    id = "success_module",
    h4("Access confirmed!"),
    p("Welcome to your module-secured application!")
  )
  
})
    # authentication success message
    output$display_content_module <- renderUI({

        req(validate_password_module())
        
        div(
            class = "bg-success",
            id = "success_module",
            h4("Access confirmed!"),
            p("Welcome to your module-secured application!")
        )
        
    })


