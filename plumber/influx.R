
#* @get /temp
function() {
  
  con <- influx_connection(
    host = Sys.getenv('postgre_ip'), 
    port = 8086, 
    user = Sys.getenv("influx_name"),
    pass = Sys.getenv("passwd")
  )
  
  res <- influx_select(con, 
                       db = "temperature",
                       measurement = 'room_temperature_humidity',
                       limit = 1, 
                       field_keys = 'temperature',
                       order_desc = T,
                       return_xts = F,
                       simplifyList = T)
  
  temp <- res[[1]]$temperature * (9/5) + 32
  return(temp)
}

