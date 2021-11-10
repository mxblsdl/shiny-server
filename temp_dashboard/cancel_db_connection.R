
## Code snippet to include at end of server to disconnect from DB

disconnect <- function() {
  if(exists("con")){
    DBI::dbDisconnect(con)
    print("Connection to DB Closed") 
  }
}

cancel.onSessionEnded <- session$onSessionEnded(disconnect)

