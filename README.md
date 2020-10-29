# My Shiny Server

## Instructions for shiny server

- Open terminal and type `USER@167.71.158.245` 
- If root user and logged in on personal laptop the SSH should be set up.
Otherwise enter password.
- Once logged onto the server navigate to the git repo \
`cd srv/shiny-server`\
`git pull`\
to get recent updates

## Troubleshooting
- R packages need to be installed from the root user OR by running \
`sudo su - -c "R -e \"install.packages('R_PACKAGE')\""`\
from the CL. The above command will install for all users. 

- Shiny apps run as the user `shiny` so that user must have permissions and access to specific packages.