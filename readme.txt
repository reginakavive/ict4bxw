
REAL-TIME SURVEILLANCE DASHBOARD

A shiny app for real-time surveillance of BXW
Automatically updates(deploys to shinyapps.io) on push/ pull-request 

app.R: main dashboard (with server and ui functions)
dataprep.R: Data preparation script read into app.R
part.R: functions and variables definitions
deploy.R: script to enable auto deploy to shinyapps.io on push/pull-request merge
.github/workflows/main.yml :for automating workflows on GitHub actions
data: folder contains required data + reporting script (report.Rmd)


MAIN WEBSITE
website_dashboard: code for the website (with the embedded dashboard) www.ict4bxw.com;
           automatically updated and deployed on the Digital Ocean server on push/pull-request merge