

library(ssh)

shiny_log <- function(host) {
  max <-
    ssh_connect(host, passwd = Sys.getenv("ssh_pswd"))
  
  logs <-
    ssh_exec_internal(max, command = "ls /var/log/shiny-server/")
  
  l <- paste(rawToChar(logs$stdout))
  cat(l)
# issue with function ordering things alphabetically, 
# makes it harder to find most recent file
  l <- unlist(strsplit(l, "\n"))
  
  ssh_exec_wait(max,
                command = paste0(
                  "echo ",
                  Sys.getenv("ssh_pswd"),
                  " | sudo -S cat /var/log/shiny-server/",
                  l[length(1)]
                ))
  ssh_disconnect(max)
}

shiny_log("max@167.71.158.245")
