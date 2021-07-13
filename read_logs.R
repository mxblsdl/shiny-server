

library(ssh)

shiny_log <- function(host) {
  max <-
    ssh_connect(host, passwd = Sys.getenv("ssh_pswd"))

  # retrieve date modified info
  logs <-
    ssh_exec_internal(max, command = "stat -c %y /var/log/shiny-server/*")
  
  l <- paste(rawToChar(logs$stdout))
  l <- unlist(strsplit(l, "\n"))

  # convert to datetime and find max
  date_mod <- as.POSIXct(l)
  ind <-which.max(date_mod)
  
  # read files 
  logs <-
    ssh_exec_internal(max, command = "ls /var/log/shiny-server/")
  
  l <- paste(rawToChar(logs$stdout))
  l <- unlist(strsplit(l, "\n"))

  # echo most recently modified file
  ssh_exec_wait(max,
                command = paste0(
                  "echo ",
                  Sys.getenv("ssh_pswd"),
                  " | sudo -S cat /var/log/shiny-server/",
                  l[ind]
                ))
  ssh_disconnect(max)
}

shiny_log("max@167.71.158.245")
