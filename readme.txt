
REAL-TIME SURVEILLANCE DASHBOARD

A shiny app for real-time surveillance of BXW
Automatically updates(deploys to shinyapps.io) on push/ pull-request 

app.R: main dashboard (with server and ui functions)
firebaseimport.R imports data from firebase via API + data cleaning (updates data twice every week)
dataprep.R: Data preparation/aggregation script. Reads into app.R
part.R: functions and variables definitions
deploy.R: script to enable auto deploy to shinyapps.io on schedule+ push/pull-request merge
.github/workflows/main.yml :for automating workflows on GitHub actions
data: folder contains required data + reporting script (report.Rmd)


MAIN WEBSITE
website_dashboard: code for the website (with the embedded dashboard) www.ict4bxw.com;
           automatically updated and deployed on the Digital Ocean server on push/pull-request merge
