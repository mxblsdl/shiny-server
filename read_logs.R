

library(ssh)

shiny_log <- function(host) {
  con <-
    ssh_connect(host, passwd = Sys.getenv("ssh_pswd"))

  # retrieve date modified info
  logs <-
    ssh_exec_internal(con, command = "stat -c %y /var/log/shiny-server/*")
  
  l <- paste(rawToChar(logs$stdout))
  l <- unlist(strsplit(l, "\n"))

  # convert to datetime and find max
  date_mod <- as.POSIXct(l)
  ind <-which.max(date_mod)
  
  # read files 
  logs <-
    ssh_exec_internal(con, command = "ls /var/log/shiny-server/")
  
  l <- paste(rawToChar(logs$stdout))
  l <- unlist(strsplit(l, "\n"))

  # echo most recently modified file
  ssh_exec_wait(con,
                command = paste0(
                  "echo ",
                  Sys.getenv("ssh_pswd"),
                  " | sudo -S cat /var/log/shiny-server/",
                  l[ind]
                ))
  ssh_disconnect(con)
}

shiny_log(paste0(Sys.getenv("ssh_host"), '@167.71.158.245'))
