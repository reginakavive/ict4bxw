
if(!require(plotly)) install.packages("plotly", repos = "http://cran.us.r-project.org")
if(!require(shiny)) install.packages("shiny", repos = "http://cran.us.r-project.org")
if(!require(rgdal)) install.packages("rgdal", repos = "http://cran.us.r-project.org")
if(!require(mapview)) install.packages("mapview", repos = "http://cran.us.r-project.org")
if(!require(ggplot2)) install.packages("ggplot2", repos = "http://cran.us.r-project.org")
if(!require(lubridate)) install.packages("lubridate", repos = "http://cran.us.r-project.org")
if(!require(sp)) install.packages("sp", repos = "http://cran.us.r-project.org")
if(!require(gstat)) install.packages("gstat", repos = "http://cran.us.r-project.org")
if(!require(shinyWidgets)) install.packages("shinyWidgets", repos = "http://cran.us.r-project.org")
if(!require(tidyr)) install.packages("tidyr", repos = "http://cran.us.r-project.org")
if(!require(magrittr)) install.packages("magrittr", repos = "http://cran.us.r-project.org")
if(!require(leaflet)) install.packages("leaflet", repos = "http://cran.us.r-project.org")
if(!require(shinyjs)) install.packages("shinyjs", repos = "http://cran.us.r-project.org")
if(!require(zoo)) install.packages("zoo", repos = "http://cran.us.r-project.org")
if(!require(rgeos)) install.packages("rgeos", repos = "http://cran.us.r-project.org")
if(!require(Cairo)) install.packages("Cairo", repos = "http://cran.us.r-project.org")
if(!require(grDevices)) install.packages("grDevices", repos = "http://cran.us.r-project.org")
if(!require(latticeExtra)) install.packages("latticeExtra", repos = "http://cran.us.r-project.org")
if(!require(maptools)) install.packages("maptools", repos = "http://cran.us.r-project.org")
if(!require(sf)) install.packages("sf", repos = "http://cran.us.r-project.org")
if(!require(png)) install.packages("png", repos = "http://cran.us.r-project.org")
if(!require(naniar)) install.packages("naniar", repos = "http://cran.us.r-project.org")
if(!require(tidyverse)) install.packages("tidyverse", repos = "http://cran.us.r-project.org")

source("dataprep.R")
source("part.R")

# Define UI for application that draws a histogram
ui <- fluidPage(
  tags$style('.container-fluid {
                             background-color: #222222; 
             }'),
  tags$head(tags$style(
    HTML('
         #sidebar {
         background-color: #111111; color:#a9a9a9; border-color: black;
         }

         body, label, input, button, select {
         font-color:"white";
         }')
  )),

   # Application title
   titlePanel("Real-Time Surveillance"),
   
  sidebarLayout(
    
    sidebarPanel(id="sidebar",
                 
                 titlePanel("BXW Distribution"),
                 
                 HTML('<p> The map and the graphs below show the BXW occurrence from 2019. </p>'),
                 
                 HTML('<br>'),
                 
                 HTML('<p style="font-size: 14px;color:#a9a9a9 ;font-weight: bold">ADMINISTRATIVE REGION:</p>'),
                 
                 
                 selectInput(
                   "districtfinder",
                   label = "District",
                   multiple=FALSE,
                   choices =district_select,
                   selected= "All Districts"),
                 
                 conditionalPanel( condition = "input.districtfinder != 'All'",
                                   uiOutput("secondSelection")
                 ),
                 
                 
                 dateRangeInput("dateRange", "DATE RANGE:",
                                start = "2019-10-01",
                                end   = Sys.time()),
                 
                 HTML('<br>'),
                 
                 HTML('<p style="font-size: 14px;color:#a9a9a9 ;font-weight: bold">SUMMARY:</p>'),
                 
                 column(4,
                   span(tags$i(h5("Total Diagnosis")), style="color:#008080"),
                 #textyle(((textOutput("total_participant")))),
                 h5(textOutput("totalText"), align = "right",  style="color:#008080")
                 ),
                 
                 column(4,
                 span(tags$i(h5("BXW Occurrences")), style="color:red"),
                 #textyle(((textOutput("total_participant")))),
                 h5(textOutput("bxwText"), align = "right",  style="color:red")
                 ),
                 
                 column(4,
                        span(tags$i(h5("Users Reached")), style="color:#964B00"),
                        #textyle(((textOutput("total_participant")))),
                        h5(textOutput("farmerT"), align = "right",  style="color:#964B00")
                 ),
                 
                 HTML('<br>'),
                 
                 HTML('<br>'),
                 
                 column(12,
                 span(tags$i(h5("Change in BXW Occurrence:")), style="color:#FF7F50"),
                 #textyle(((textOutput("total_participant")))),
                 h5(textOutput("change"), align = "center",  style="color:#orange")),
                 column(12,
                        HTML('<br>')),
                 column(12,
                 span(tags$i(h5("")), style="color:#orange")
                 ),
                 
                 # HTML('<p style="font-size: 14px;color:#a9a9a9 ;font-weight: bold">SUMMARY:</p>'),
                 # HTML('<p> Total Diagnosis : </p>'),verbatimTextOutput("totalText"),
                 # HTML('<p> Total BXW Occurrences :  </p>'),verbatimTextOutput("bxwText"),
                 # 
                 # HTML('<p> Change in BXW Occurrence : </p>'),verbatimTextOutput("change"),
                 # 
                 # #HTML('<p> Overall Farmers Reached :  </p>'),verbatimTextOutput("5106"),
                 # 
                 # HTML('<br>'),
                 # 
                 
                 # HTML('<p style="font-size: 14px;color:black ;font-weight: bold">Generate Report:</p>'),
                 # actionButton("init", "Print Report", icon = icon("download")),
                 # downloadButton("downloadDataC","Download" , style = "visibility: hidden;")
                 #HTML('<p> Coming Soon... </p>'),
                 
                 # HTML('<p> Farmers Reached : </p>'),
                 # verbatimTextOutput("farmerT"),
                 
                 HTML('<br>'),
                 column(6,
                 plotlyOutput("graph2",width = "100%", height = '300px')
                 ),
                 column(6,
                 plotlyOutput("graph3", height = '300px', width = "100%")
                 ),
                 column(12,
                        HTML('<br>')),
                 column(12,
                 plotOutput("pie", height = 300, width = "100%")
                 ),
                 column(12,
                 HTML('<br>')),
                 
                 downloadButton("report", "Generate report")
                 
      ),
    # absolutePanel(
    #   id = "summary1", class = "panel panel-default", fixed = TRUE,width = 100,
    #   
    #   span(tags$i(h4("Total Diagnosis:")), style="color:green"),
    #   h3(textOutput("totalText"), align = "right",  style="color:green")
    # ),
    # absolutePanel(
    #   id = "summary2", class = "panel panel-default", fixed = TRUE,width = 100,
    #   
    #   span(tags$i(h4("Total BXW Occurrences:")), style="color:red"),
    #   h3(textOutput("bxwText"), align = "right",  style="color:red")
    # ),
      
      # Show a plot of the generated distribution
      mainPanel(
        leafletOutput("map"),
        HTML('<br>'),
        plotlyOutput("graph",width = "100%"),
        plotlyOutput("graph4", width = "100%")
        
        
      )
   )
)

# Define server logic required to draw a histogram
server <- function(input, output, session) {
  options(shiny.usecairo=T)
  
  valspdf <- reactiveValues(map=NULL,graph=NULL,district=NULL,sector=NULL,date1=NULL,date2=NULL,totalText=NULL,bxwText=NULL,change=NULL)
  
  output$secondSelection2 <- renderUI({
    selectInput(
      "sectorfinder2",
      label = "Sector",
      multiple=FALSE,
      choices = "All",
      selected= "All")
    #selectInput("User", "Date:", choices = as.character(dat5[dat5$email==input$districtfinder,"Sector"]))
  })
  output$secondSelection <- renderUI({
    selectInput(
      "sectorfinder",
      label = "Sector",
      multiple=FALSE,
      choices = as.character(sectors[which(sectors$District == input$districtfinder),"Sector" ]),
      selected= "All")
    #selectInput("User", "Date:", choices = as.character(dat5[dat5$email==input$districtfinder,"Sector"]))
  })
  
  
  
  ###SUMMARY
  output$farmerT  <- renderText({
    paste(as.character(length(unique(bxw_data_e$Farmer))))
  })
  
  
  
  ###GRAPHS
  output$pie<-renderPlot({
    
    ggplot(bxw_data_h, aes(x="", y=per, fill=Gender)) +
      geom_bar(stat="identity", width=1) +
      coord_polar("y") +
      scale_y_continuous(labels = scales::percent)+
      geom_text(aes(label = paste(round(count / sum(count) * 100, 1), "%")),
                position = position_stack(vjust = 0.5)) +
      scale_fill_brewer(palette="Oranges",direction=-1, labels = c("Male", "Female"))+
      #scale_fill_discrete(labels = c("Male", "Female"))+
      #scale_color_manual(labels = c("Male", "Female"), values = c("blue", "red")) +
      
      # geom_text(aes(y = per, 
      #               label = percent(per*100)), size=5)
      theme(panel.background = element_rect(fill = "black"), # bg of the panel
            plot.background = element_rect(fill = "black", color = NA), # bg of the plot
            panel.grid.major = element_blank(),
            panel.grid.minor = element_blank(),
            axis.line.x = element_blank(),
            axis.line.y = element_blank(),
            axis.text.x = element_blank(),
            axis.text.y = element_blank()
      )
    #ggplotly(aa, tooltip="y")
    
  }, bg="#111111")
  
  
  output$graph2<-renderPlotly({
    g<-ggplot(incidenceT, aes(x = format(month, "%Y"), y = Totaldiagnoses)) + 
      geom_bar(width=0.7, color="orange",position = 'dodge',  stat = "identity") +
      #geom_text(aes(label=Totaldiagnoses), position=position_dodge(width=0.7), vjust=-0.25, size=3)+
      labs(x = "Year",y="Count", title = "Yearly Diagnosis")+
      theme(panel.background = element_rect(fill = "black"), # bg of the panel
            plot.background = element_rect(fill = "black", color = NA), # bg of the plot
            panel.grid.major = element_blank(),
            panel.grid.minor = element_blank(),
            plot.title = element_text(size=8, face="bold",color = "#a9a9a9", hjust = 0.5 ),
            strip.text.x = element_text(size = 15, color = "#a9a9a9", face = "bold"),
            axis.text=element_text(color = "#a9a9a9",size=10),
            axis.text.x = element_text(angle = 60, hjust = 1),
            #axis.text.y = element_blank(),
            #axis.title=element_text(size=16,face="bold"),
            axis.title=element_blank(),
            legend.title = element_text(color = "#a9a9a9",face="bold", size = 16),
            legend.text = element_text(color = "#a9a9a9", size = 15),
            #axis.line.x = element_line(color="black", size = 0.3),
            #scale_x_date(date_breaks = "months" , date_labels = "%b-%y"),
            #axis.line.y = element_line(color="black", size = 0.3))
            axis.line.x = element_blank(),
            #hovertemplate = paste('%{x}', '<br>lifeExp: %{text:.2s}<br>'),
            axis.line.y = element_blank())
    ggplotly(g, tooltip="y")
    
  })
  
  output$graph3<-renderPlotly({
  ah<-ggplot(usertotalT, aes(x = format(month, "%Y"), y = Total)) + 
    geom_bar(width=0.7, fill="grey",position = 'dodge',  stat = "identity") +
    #geom_text(aes(label=Total), position=position_dodge(width=0.7), vjust=-0.25, size=3)+
    labs(x = "Year",y="Count", title = "Unique Users")+
    theme(panel.background = element_rect(fill = "black"), # bg of the panel
          plot.background = element_rect(fill = "black", color = NA), # bg of the plot
          panel.grid.major = element_blank(),
          panel.grid.minor = element_blank(),
          plot.title = element_text(size=8, face="bold",color = "#a9a9a9", hjust = 0.5 ),
          strip.text.x = element_text(size = 15, color = "#a9a9a9", face = "bold"),
          axis.text=element_text(color = "#a9a9a9",size=10),
          axis.text.x = element_text(angle = 60, hjust = 1),
          #axis.text.y = element_blank(),
          #axis.title=element_text(size=16,face="bold"),
          axis.title=element_blank(),
          legend.title = element_text(color = "#a9a9a9",face="bold", size = 16),
          legend.text = element_text(color = "#a9a9a9", size = 15),
          #axis.line.x = element_line(color="black", size = 0.3),
          #scale_x_date(date_breaks = "months" , date_labels = "%b-%y"),
          #axis.line.y = element_line(color="black", size = 0.3))
          axis.line.x = element_blank(),
          #hovertemplate = paste('%{x}', '<br>lifeExp: %{text:.2s}<br>'),
          axis.line.y = element_blank())
  ggplotly(ah, tooltip="y")
  })
  
  
  incidenceGroupedY<-incidenceGroupedT[which(incidenceGroupedT$Has.BXW == "YES"), ]
  output$graph4<-renderPlotly({
  ab<-ggplot(incidenceGroupedY, aes(x= month, y=Total, group=Has.BXW,colour=Has.BXW))+ 
    geom_point(size=1, color="red")+
    geom_line(size=0.7, color = "red")+
    #theme_bw(base_size = 24)+
    labs(title="Trend of Positive BXW diagnosis", x="", y="No. of Diagnosis")+
    theme(panel.background = element_rect(fill = "black"), # bg of the panel
          plot.background = element_rect(fill = "black", color = NA), # bg of the plot
          panel.grid.major = element_blank(),
          panel.grid.minor = element_blank(),
          plot.title = element_text(size=12, face="bold",color = "#a9a9a9", hjust = 0.5 ),
          strip.text.x = element_text(size = 15, color = "#a9a9a9", face = "bold"),
          axis.text=element_text(color = "#a9a9a9",size=10),
          axis.text.x = element_text(angle = 60, hjust = 1),
          #axis.text.y = element_blank(),
          #axis.title=element_text(size=16,face="bold"),
          axis.title=element_blank(),
          legend.title = element_text(color = "#a9a9a9",face="bold", size = 16),
          legend.text = element_text(color = "#a9a9a9", size = 15),
          #axis.line.x = element_line(color="black", size = 0.3),
          #scale_x_date(date_breaks = "months" , date_labels = "%b-%y"),
          #axis.line.y = element_line(color="black", size = 0.3))
          axis.line.x = element_blank(),
          #hovertemplate = paste('%{x}', '<br>lifeExp: %{text:.2s}<br>'),
          axis.line.y = element_blank())
    ggplotly(ab, tooltip="y")
  })
  
  observe ({
    if (input$districtfinder == "All"){
      #input$sectorfinder <- "ALL"
      #incidents %>% filter(REPORT_DAT >= input$dateRange[1] & REPORT_DAT <= input$dateRange[2])
      #input$sectorfinder == "All"
      #bxw_data <-bxw_data_e
      bxw_data <- bxw_data_e[which(bxw_data_e$Date.Created >= input$dateRange[1] & bxw_data_e$Date.Created <= input$dateRange[2]), ]
      
      # bxw_data %>% 
      #   filter(bxw_data$Date.Created >= input$dateRange[1] & bxw_data$Date.Created <= input$dateRange[2])
      
      pal <- colorFactor(pal = c("green", "red"), domain = c("NO", "YES"))
      labs <- as.list(rwad_shp$NAME_2)
      output$map<- renderLeaflet({
        leaflet(bxw_data) %>% 
          addProviderTiles(providers$CartoDB.DarkMatter) %>% 
          addPolygons(data=rwa_shp, color="grey",fillOpacity = 0.1,weight = 1.2)%>%
          addPolygons(data=rwad_shp, color="grey",fillOpacity = 0.0,weight = 1.2,label = lapply(labs, HTML))%>%
          addCircles(lng = ~Longitude, lat = ~Latitude) %>% 
          #addTiles() %>%
          addCircleMarkers(data = bxw_data, lat =  ~Latitude, lng =~Longitude, 
                           radius = 3,
                           color = ~pal(bxw_data$Has.BXW),
                           stroke = FALSE, fillOpacity = 1)%>%
          addLegend(title = "BXW Occurrence", pal=pal, values=bxw_data$Has.BXW,opacity=1)%>%
          addEasyButton(easyButton(
            icon="fa-crosshairs", title="ME",
            onClick=JS("function(btn, map){ map.locate({setView: true}); }")))
        
        
      })
      
      output$graph<-renderPlotly({
        bxw_data_yes <- bxw_data[which(bxw_data$Has.BXW =="YES" ), ]
        
        # hc <- df %>%
        #   hchart('column', hcaes(x = dose, y = len))
        
        g<-ggplot(bxw_data_yes, aes(format(Date.Created, "%Y-%m"))) +
          geom_bar(stat = "Count",  color="orange") +
          labs(x = "Month",y="Count", title = "MONTHLY BXW OCCURRENCE ")+
          theme(panel.background = element_rect(fill = "black"), # bg of the panel
                plot.background = element_rect(fill = "black", color = NA), # bg of the plot
                panel.grid.major = element_blank(),
                panel.grid.minor = element_blank(),
                plot.title = element_text(size=12, face="bold",color = "#a9a9a9", hjust = 0.5 ),
                strip.text.x = element_text(size = 15, color = "#a9a9a9", face = "bold"),
                axis.text=element_text(color = "#a9a9a9",size=10),
                axis.text.x = element_text(angle = 60, hjust = 1),
                #axis.text.y = element_blank(),
                #axis.title=element_text(size=16,face="bold"),
                axis.title=element_blank(),
                legend.title = element_text(color = "#a9a9a9",face="bold", size = 16),
                legend.text = element_text(color = "#a9a9a9", size = 15),
                #axis.line.x = element_line(color="black", size = 0.3),
                #scale_x_date(date_breaks = "months" , date_labels = "%b-%y"),
                #axis.line.y = element_line(color="black", size = 0.3))  
                axis.line.x = element_blank(),
                #hovertemplate = paste('%{x}', '<br>lifeExp: %{text:.2s}<br>'),
                axis.line.y = element_blank())
        ggplotly(g, tooltip="y")  
        
      })
      
      
      
      output$district  <- renderText({
        input$districtfinder
      })
      
      output$sector  <- renderText({
        input$sectorfinder
      })
      output$date1  <- renderText({
        input$dateRange[1]
      })
      output$date2  <- renderText({
        input$dateRange[2]
      })
      
      output$totalText  <- renderText({
        if (input$dateRange[1] == "2019-10-01" && input$dateRange[2] == Sys.time() ){
          paste(as.character(length(bxw_data_e$Has.BXW)))
        } else{paste(as.character(length(bxw_data$Has.BXW)))  }
      })
      output$bxwText  <- renderText({
        if (input$dateRange[1] == "2019-10-01" && input$dateRange[2] == Sys.time() ){
          paste(as.character(length((bxw_data_e[which(bxw_data_e$Has.BXW == "YES"), ])$Has.BXW)))
        }else{  paste(as.character(length((bxw_data[which(bxw_data$Has.BXW == "YES"), ])$Has.BXW)))        }
      })
      
      output$change  <- renderText({
        
        if (input$dateRange[1] <= "2019-10-03"){
          paste( "No previously existing data")
        }else if(input$dateRange[1] > Sys.time()){
          paste( "No data")
        }else if (input$dateRange[1] > "2019-10-03"){
          dat1 <-  bxw_data[which(bxw_data$Date.Created > input$dateRange[1] ), ]
          leg1<- length((dat1[which(dat1$Has.BXW == "YES"), ])$Has.BXW)
          dat2 <-  bxw_data_e[which(bxw_data_e$Date.Created < input$dateRange[1] ), ]
          leg2<- length((dat2[which(dat2$Has.BXW == "YES"), ])$Has.BXW)
          cha<-((leg1-leg2)/(leg1+leg2))*100
          paste(as.character(format(round(cha, 2), nsmall = 2)),"%")
          
        }
      })
      
      print(Sys.time())
      print(input$dateRange[1])
      
      #(input$districtfinder == input$districtfinder )  (input$sectorfinder == input$sectorfinder) 136-
    }else if (input$districtfinder == input$districtfinder && input$sectorfinder == "All" ) {
      #bxw_data <-bxw_data_e
      bxw_data_d <- bxw_data_e[which(bxw_data_e$District == input$districtfinder), ]
      bxw_data <- bxw_data_d[which(bxw_data_d$Date.Created >= input$dateRange[1] & bxw_data_d$Date.Created <= input$dateRange[2]), ]
      
      #bxw_data %>% filter(bxw_data$Date.Created >= input$dateRange[1] & bxw_data$Date.Created <= input$dateRange[2])
      
      pal <- colorFactor(pal = c("green", "red"), domain = c("NO", "YES"))
      labs <- as.list(rwad_shp$NAME_2)
      output$map<- renderLeaflet({
        leaflet(bxw_data) %>% 
          addProviderTiles(providers$CartoDB.DarkMatter) %>% 
          addPolygons(data=rwa_shp, color="grey",fillOpacity = 0.1,weight = 1.2)%>%
          addPolygons(data=(rwad_shp[rwad_shp$NAME_2==input$districtfinder, ]), weight = 3.2, color = "green")%>%
          addPolygons(data=rwad_shp, color="grey",fillOpacity = 0.0,weight = 1.2,label = lapply(labs, HTML))%>%
          addCircles(lng = ~Longitude, lat = ~Latitude) %>% 
          #addTiles() %>%
          addCircleMarkers(data = bxw_data, lat =  ~Latitude, lng =~Longitude, 
                           radius = 3,
                           color = ~pal(bxw_data$Has.BXW),
                           stroke = FALSE, fillOpacity = 1)%>%
          addLegend(title = "BXW Occurrence", pal=pal, values=bxw_data$Has.BXW,opacity=1)%>%
          addEasyButton(easyButton(
            icon="fa-crosshairs", title="ME",
            onClick=JS("function(btn, map){ map.locate({setView: true}); }")))%>%
          #setView(lng=Zooming()$X,lat=Zooming()$Y,zoom = Zooming()$Level)
          setView( ((gCentroid(rwad_shp[rwad_shp$NAME_2==input$districtfinder, ]))@coords)[1,1], ((gCentroid(rwad_shp[rwad_shp$NAME_2==input$districtfinder, ]))@coords)[1,2], zoom = 10)
        
      })
      
      
      output$graph<-renderPlotly({
        bxw_data_yes <- bxw_data[which(bxw_data$Has.BXW =="YES" ), ]
        
        g<-ggplot(bxw_data_yes, aes(format(Date.Created, "%Y-%m"))) +
          geom_bar(stat = "Count",  color="orange") +
          labs(x = "Month",y="Count", title = "MONTHLY BXW OCCURRENCE ")+
          theme(panel.background = element_rect(fill = "black"), # bg of the panel
                plot.background = element_rect(fill = "black", color = NA), # bg of the plot
                panel.grid.major = element_blank(),
                panel.grid.minor = element_blank(),
                plot.title = element_text(size=12, face="bold",color = "#a9a9a9", hjust = 0.5 ),
                strip.text.x = element_text(size = 15, color = "#a9a9a9", face = "bold"),
                axis.text=element_text(color = "#a9a9a9",size=10),
                axis.text.x = element_text(angle = 60, hjust = 1),
                #axis.text.y = element_blank(),
                #axis.title=element_text(size=16,face="bold"),
                axis.title=element_blank(),
                legend.title = element_text(color = "#a9a9a9",face="bold", size = 16),
                legend.text = element_text(color = "#a9a9a9", size = 15),
                #axis.line.x = element_line(color="black", size = 0.3),
                #scale_x_date(date_breaks = "months" , date_labels = "%b-%y"),
                #axis.line.y = element_line(color="black", size = 0.3))  
                axis.line.x = element_blank(),
                #hovertemplate = paste('%{x}', '<br>lifeExp: %{text:.2s}<br>'),
                axis.line.y = element_blank())                 
        ggplotly(g, tooltip="y")
      })
      
      output$district  <- renderText({
        input$districtfinder
      })
      output$sector  <- renderText({
        input$sectorfinder
      })
      output$date1  <- renderText({
        input$dateRange[1]
      })
      output$date2  <- renderText({
        input$dateRange[2]
      })
      
      output$totalText  <- renderText({
        paste(as.character(length(bxw_data$Has.BXW)))
      })
      output$bxwText  <- renderText({
        paste(as.character(length((bxw_data[which(bxw_data$Has.BXW == "YES"), ])$Has.BXW)))
      })
      
      output$change  <- renderText({
        paste(as.character(length((bxw_data[which(bxw_data$Has.BXW == "YES"), ])$Has.BXW)))
      })
      
      output$change  <- renderText({
        
        if (input$dateRange[1] <= "2019-10-03"){
          paste( "No previously existing data")
        }else if(input$dateRange[1] > Sys.time()){
          paste( "No data")
        }else if (input$dateRange[1] > "2019-10-03"){
          dat1 <-  bxw_data[which(bxw_data$Date.Created > input$dateRange[1] ), ]
          leg1<- length((dat1[which(dat1$Has.BXW == "YES"), ])$Has.BXW)
          dat2 <-  bxw_data_e[which(bxw_data_e$Date.Created < input$dateRange[1] ), ]
          leg2<- length((dat2[which(dat2$Has.BXW == "YES"), ])$Has.BXW)
          cha<-((leg1-leg2)/(leg1+leg2))*100
          paste(as.character(format(round(cha, 2), nsmall = 2)),"%")
          
        }
      })
      
      
      
    }else if (input$districtfinder == input$districtfinder &&  input$sectorfinder != "All") {
      #bxw_data <-bxw_data_e
      bxw_data_s <- bxw_data_e[which(bxw_data_e$District == input$districtfinder), ]
      bxw_data_s <- bxw_data_s[which(bxw_data_s$Sector == input$sectorfinder), ]
      #bxw_data <- bxw_data[which(bxw_data$Sector == "Kabarondo"), ]
      #bxw_data <- bxw_data[which(bxw_data$Sector == "Kabarondo"), ]
      bxw_data <- bxw_data_s[which(bxw_data_s$Date.Created >= input$dateRange[1] & bxw_data_s$Date.Created <= input$dateRange[2]), ]
      
      #bxw_data %>% filter(bxw_data$Sector == input$sectorfinder)
      
      pal <- colorFactor(pal = c("green", "red"), domain = c("NO", "YES"))
      labs <- as.list(rwad_shp$NAME_2)
      output$map<- renderLeaflet({
        leaflet(bxw_data) %>% 
          addProviderTiles(providers$CartoDB.DarkMatter) %>% 
          addPolygons(data=rwa_shp, color="grey",fillOpacity = 0.1,weight = 1.2)%>%
          #addPolygons(data=rwas_shp, color="grey",fillOpacity = 0.1,weight = 1.0)%>%
          addPolygons(data=(rwad_shp[rwad_shp$NAME_2==input$districtfinder, ]), weight = 3.2, fillOpacity = 0.1, color = "green")%>%
          #addPolygons(data=(rwas_shp[rwas_shp$Name==input$sectorfinder, ]), weight = 3.2, color = "green")%>%
          addPolygons(data=rwad_shp, color="grey",fillOpacity = 0.0,weight = 1.2,label = lapply(labs, HTML))%>%
          addCircles(lng = ~Longitude, lat = ~Latitude) %>% 
          #addTiles() %>%
          addCircleMarkers(data = bxw_data, lat =  ~Latitude, lng =~Longitude, 
                           radius = 3,
                           color = ~pal(bxw_data$Has.BXW),
                           stroke = FALSE, fillOpacity = 1)%>%
          addLegend(title = "BXW Occurrence", pal=pal, values=bxw_data$Has.BXW,opacity=1)%>%
          addEasyButton(easyButton(
            icon="fa-crosshairs", title="ME",
            onClick=JS("function(btn, map){ map.locate({setView: true}); }")))%>%
          setView( ((gCentroid(rwad_shp[rwad_shp$NAME_2==input$districtfinder, ]))@coords)[1,1], ((gCentroid(rwad_shp[rwad_shp$NAME_2==input$districtfinder, ]))@coords)[1,2], zoom = 10)
        
        
      })
      
      output$graph<-renderPlotly({
        bxw_data_yes<- bxw_data[which(bxw_data$Has.BXW =="YES" ), ]
        
        g<-ggplot(bxw_data_yes, aes(format(Date.Created, "%Y-%m"))) +
          geom_bar(stat = "Count",  color="orange") +
          labs(x = "Month",y="Count", title = "MONTHLY BXW OCCURRENCE ")+
          theme(panel.background = element_rect(fill = "black"), # bg of the panel
                plot.background = element_rect(fill = "black", color = NA), # bg of the plot
                panel.grid.major = element_blank(),
                panel.grid.minor = element_blank(),
                plot.title = element_text(size=12, face="bold",color = "#a9a9a9", hjust = 0.5 ),
                strip.text.x = element_text(size = 15, color = "#a9a9a9", face = "bold"),
                axis.text=element_text(color = "#a9a9a9",size=10),
                axis.text.x = element_text(angle = 60, hjust = 1),
                #axis.text.y = element_blank(),
                #axis.title=element_text(size=16,face="bold"),
                axis.title=element_blank(),
                legend.title = element_text(color = "#a9a9a9",face="bold", size = 16),
                legend.text = element_text(color = "#a9a9a9", size = 15),
                #axis.line.x = element_line(color="black", size = 0.3),
                #scale_x_date(date_breaks = "months" , date_labels = "%b-%y"),
                #axis.line.y = element_line(color="black", size = 0.3))  
                axis.line.x = element_blank(),
                #hovertemplate = paste('%{x}', '<br>lifeExp: %{text:.2s}<br>'),
                axis.line.y = element_blank())                 
        ggplotly(g, tooltip="y")
      })
      
      output$district  <- renderText({
        input$districtfinder
      })
      output$sector  <- renderText({
        input$sectorfinder
      })
      output$date1  <- renderText({
        input$dateRange[1]
      })
      output$date2  <- renderText({
        input$dateRange[2]
      })
      
      output$totalText  <- renderText({
        paste(as.character(length(bxw_data$Has.BXW)))
      })
      output$bxwText  <- renderText({
        paste(as.character(length((bxw_data[which(bxw_data$Has.BXW == "YES"), ])$Has.BXW)))
      })
      
      output$change  <- renderText({
        paste(as.character(length((bxw_data[which(bxw_data$Has.BXW == "YES"), ])$Has.BXW)))
      })
      
      output$change  <- renderText({
        
        if (input$dateRange[1] <= "2019-10-03"){
          paste( "No previously existing data")
        }else if(input$dateRange[1] > Sys.time()){
          paste( "No data")
        }else if (input$dateRange[1] > "2019-10-03"){
          dat1 <-  bxw_data[which(bxw_data$Date.Created > input$dateRange[1] ), ]
          leg1<- length((dat1[which(dat1$Has.BXW == "YES"), ])$Has.BXW)
          dat2 <-  bxw_data_e[which(bxw_data_e$Date.Created < input$dateRange[1] ), ]
          leg2<- length((dat2[which(dat2$Has.BXW == "YES"), ])$Has.BXW)
          cha<-((leg1-leg2)/(leg1+leg2))*100
          paste(as.character(format(round(cha, 2), nsmall = 2)),"%")
          
        }
      })
      
    }
    
    
    
  })
  output$report <- downloadHandler(
    # For PDF output, change this to "report.pdf"
    filename = "report.pdf",
    content = function(file) {
      withProgress(message = "Downloading...", {
        # Copy the report file to a temporary directory before processing it, in
        # case we don't have write permissions to the current working dir (which
        # can happen when deployed).
        tempReport <- file.path("./data", "report.Rmd")
        file.copy("report.Rmd", tempReport, overwrite = TRUE)
        
        # Set up parameters to pass to Rmd document
        params <- list(c = input$districtfinder, d = input$sectorfinder, e = input$dateRange[1], f = input$dateRange[2] )
        #params <- list(report = uiOutput("map","graph","totalText", "bxwText", "change"))
        # Knit the document, passing in the `params` list, and eval it in a
        # child of the global environment (this isolates the code in the document
        # from the code in this app).
        rmarkdown::render(tempReport, output_file = file,
                          params = params,
                          envir = new.env(parent = globalenv())
        )
      })
      
    }
  )
  
  
  session$allowReconnect(TRUE)
  
  
  
}

# Run the application 
shinyApp(ui = ui, server = server)

