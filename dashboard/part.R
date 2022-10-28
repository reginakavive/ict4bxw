sectors <- read.csv("data/sectors.csv", stringsAsFactors = FALSE)

dropdownButton <- function(label = "", status = c("default", "primary", "success", "info", "warning", "danger"), ..., width = NULL) {

  status <- match.arg(status)
  # dropdown button content
  html_ul <- list(
    class = "dropdown-menu",
    style = if (!is.null(width))
      paste0("width: ", validateCssUnit(width), ";"),
    lapply(X = list(...), FUN = tags$li, style = "margin-left: 10px; margin-right: 10px;")
  )
  # dropdown button apparence
  html_button <- list(
    class = paste0("btn btn-", status," dropdown-toggle"),
    type = "button",
    `data-toggle` = "dropdown"
  )
  html_button <- c(html_button, list(label))
  html_button <- c(html_button, list(tags$span(class = "caret")))
  # final result
  tags$div(
    class = "dropdown",
    do.call(tags$button, html_button),
    do.call(tags$ul, html_ul),
    tags$script(
      "$('.dropdown-menu').click(function(e) {
        e.stopPropagation();
  });")
  )
}



district_select<-c("All","Bugesera","Gatsibo", "Kayonza", "Kirehe",  "Ngoma", "Nyagatare", "Rwamagana","Gasabo", "Kicukiro", "Nyarugenge","Burera",  "Gakenke",
                   "Gicumbi", "Musanze", "Rulindo","Gisagara", "Huye",   "Kamonyi",  "Muhanga",  "Nyamagabe",  "Nyanza",  "Nyaruguru",   "Ruhango", "Karongi",
                   "Ngororero",  "Nyabihu",   "Nyamasheke",   "Rubavu",   "Rusizi", "Rutsiro")


# plot(rwad_shp[rwad_shp$NAME_2=="Kayonza", ])
# centro<-(gCentroid(rwad_shp[rwad_shp$NAME_2=="Kayonza", ]))
# 
# ((gCentroid(rwad_shp[rwad_shp$NAME_2=="Kayonza", ]))@coords)[1,1]
# 
# View(centro)
# s<-centro@coords
# s
# s[1,1]
# s[1,2]
# ((gCentroid(rwad_shp[rwad_shp$NAME_2==input$districtfinder, ]))@coords)[1,1]



# head(bxw_data)
# 
# 
# bxw_data %>% 
#   mutate(month = format(Date.Created, "%b-%Y")) %>%
#   group_by(month) %>%
#   summarise(Count = n()) %>%
#   ggplot(aes(x = month, y = Count)) +
#   geom_point(stat = "identity") +
#   theme(axis.text.x=element_text(angle = -90, hjust = 0))

# bxw_data_yes <- bxw_data[which(bxw_data$Has.BXW =="YES" ), ]
# 
# ggplot(bxw_data_yes, aes(format(Date.Created, "%Y-%m"))) +
#   geom_bar(stat = "Count") +
#   labs(x = "Month",y="Count", title = "BXW MONTHLY OCCURRENCE TREND ")+labs(y="Count")+
#   theme(panel.background = element_blank(),
#         panel.grid.major = element_blank(),
#         panel.grid.minor = element_blank(),
#         plot.title = element_text(size=17, face="bold",hjust = 0.5 ),
#         strip.text.x = element_text(size = 15, color = "black", face = "bold"),
#         axis.text=element_text(color = "black",size=14),
#         axis.text.x = element_text(angle = 60, hjust = 1),
#         axis.title=element_text(size=16,face="bold"),
#         legend.title = element_text(color = "black",face="bold", size = 16),
#         legend.text = element_text(color = "black", size = 15),
#         axis.line.x = element_line(color="black", size = 0.3),
#         #scale_x_date(date_breaks = "months" , date_labels = "%b-%y"),
#         axis.line.y = element_line(color="black", size = 0.3))
#theme(axis.text.x=element_text(angle = 60, hjust = 0))+




# ggplot(bxw_data_yes, aes(x = format(Date.Created, "%Y-%m"), y = stat(count), colour = "Red")) + 
#   stat_count(geom = "line") + 
#   stat_count(geom = "point")


# output$secondSelection1 <- renderUI({
#   observe({
#     if (input$districtfinder != "All"){
#       selectInput(
#         "sectorfinder",
#         label = "sector",
#         multiple=FALSE,
#         choices = as.character(sectors[which(sectors$District == input$districtfinder),"Sector" ]),
#         selected= "All")
#     }
#   })
# })

# ######Clean Data##########
# #subset for required cols
# #head(bxw_data)
# bxw_data_all<-bxw_diagnosis[c("Latitude","Longitude","Has.BXW","District","Sector","Cell","Village", "Date.Created")]
# 
# 
# ##split date col year time.... keep date with full year
# ##convert date
# #bxw_data_all$Date.Created<-as.Date(bxw_data_all$Date.Created, tryFormats = c("%B", "%m","%Y-%m-%d", "%Y/%m/%d", "%m-%d", "%d-%m", "%d-%B") )
# 
# bxw_data_all$Date.Created <- as.Date(bxw_data_all$Date.Created, format = "%m/%d/%Y")
# 
# #drop na in date col
# bxw_data<-na.omit(bxw_data_all)
# 
# # remove duplicates
# 
# #drop rows if date=1577833200000 and if lat, lon, distr, date, hasbxw is null
# #bxw_data[df$No_of_Mails != 0, ]
# 
# #bxw_data1 <- na.omit(bxw_data)
# #bxw_data[complete.cases(bxw_data),]
# 
# # summary(bxw_data)
# # str(bxw_data)
# # 
# # View(bxw_data1)
# 
# ###filter for districts (remove any strange name)
# # districts<-c("Rubavu","Rulindo","Gatsibo","Burera", "Kayonza", "Gisagara", "Muhanga","Karongi", "Rubavu","rulindo","gatsibo","burera", "kayonza", "gisagara", "muhanga","karongi",
# #              "RUBAVU","RULINDO","GATSIBO","BURERA", "KAYONZA", "GISAGARA", "Muhanga","Karongi")
# # #bxw_data1<-bxw_data%>%
# #  # filter(District == c("Rubavu","Rulindo","Gatsibo","Burera", "Kayonza", "Gisagara", "Muhanga","Karongi"))
# # 
# # #bxw_data1<-bxw_data[bxw_data$District == "Karongi"]
# # 
# # bxw_data1<-filter(bxw_data, District == districts)
# # bxw_data1<-dplyr::filter(bxw_data, districts %in% bxw_data$District)
# # 
# # #bxw_data1<-bxw_data[grepl("districts",bxw_data$bxw_data),]




# output$map <-renderMapview({
#   mapview()%>%
#     suppressWarnings()
# })
#head(bxw_data)
# bxw_data_a <- bxw_data[which(bxw_data$District == "Rulindo"), ]

# pal <- colorFactor(pal = c("green", "red"), domain = c("NO", "YES"))
# labs <- as.list(rwad_shp$NAME_2)
# output$map<- renderLeaflet({
#   leaflet(bxw_data) %>% 
#     addProviderTiles(providers$CartoDB.DarkMatter) %>% 
#     addPolygons(data=rwa_shp, color="grey",fillOpacity = 0.1,weight = 1.2)%>%
#     addPolygons(data=rwad_shp, color="grey",fillOpacity = 0.0,weight = 1.2,label = lapply(labs, HTML))%>%
#     addCircles(lng = ~Longitude, lat = ~Latitude) %>% 
#     #addTiles() %>%
#     addCircleMarkers(data = bxw_data, lat =  ~Latitude, lng =~Longitude, 
#                      radius = 3,
#                      color = ~pal(bxw_data$Has.BXW),
#                      stroke = FALSE, fillOpacity = 1)%>%
#     addLegend(title = "BXW Occurrence", pal=pal, values=bxw_data$Has.BXW,opacity=1)%>%
#     addEasyButton(easyButton(
#       icon="fa-crosshairs", title="ME",
#       onClick=JS("function(btn, map){ map.locate({setView: true}); }")))
#   
# }) 

# observe({
#   if (input$distfinder == input$distfinder){
#     bxw_data <- bxw_data[which(bxw_data$Sector == input$distfinder), ]
# 
#     pal <- colorFactor(pal = c("green", "red"), domain = c("NO", "YES"))
#     labs <- as.list(rwad_shp$NAME_2)
#     output$map<- renderLeaflet({
#       leaflet(bxw_data) %>%
#         addProviderTiles(providers$CartoDB.DarkMatter) %>%
#         addPolygons(data=rwa_shp, color="grey",fillOpacity = 0.1,weight = 1.2)%>%
#         addPolygons(data=rwad_shp, color="grey",fillOpacity = 0.0,weight = 1.2,label = lapply(labs, HTML))%>%
#         addCircles(lng = ~Longitude, lat = ~Latitude) %>%
#         #addTiles() %>%
#         addCircleMarkers(data = bxw_data, lat =  ~Latitude, lng =~Longitude,
#                          radius = 3,
#                          color = ~pal(bxw_data$Has.BXW),
#                          stroke = FALSE, fillOpacity = 1)%>%
#         addLegend(title = "BXW Occurrence", pal=pal, values=bxw_data$Has.BXW,opacity=1)%>%
#         addEasyButton(easyButton(
#           icon="fa-crosshairs", title="ME",
#           onClick=JS("function(btn, map){ map.locate({setView: true}); }")))
# 
#     })
# 
#   }
# })
# length(bxw_data$Has.BXW)
# yes<- bxw_data[which(bxw_data$Has.BXW == "YES"), ]
# yes
# length(yes$Has.BXW)
# length((bxw_data[which(bxw_data$Has.BXW == "YES"), ])$Has.BXW)



# sector_Nyanza<-c( "All","Busasamana",	"Busoro",	"Cyabakamyi",	"Kibilizi",	"Kigoma",	"Mukingo",	"Muyira",	"Ntyazo",	"Nyagisozi",	"Rwabicuma" )
# 
# sector_Nyaruguru<-c( "All","Busanze",	"Cyahinda",	"Kibeho",	"Kivu",	"Mata",	"Muganza",	"Munini",	"Ngera",	"Ngoma",	"Nyabimata",	"Nyagisozi", 	"Ruheru",	"Ruramba",	"Rusenge" )
# 
# sector_Ruhango<-c( "All","Bweramana",	"Byimana",	"Kabagali",	"Kinazi",	"Kinihira",	"Mbuye",	"Mwendo",	"Ntongwe",	"Ruhango" )
# 
# sector_Karongi<-c( "All","Bwishyura",	"Gashari",	"Gishyita",	"Gitesi",	"Mubuga",	"Murambi",	"Murundi",	"Mutuntu",	"Rubengera",	"Rugabano",	"Ruganda",	"Rwankuba",	"Twumba" )
# 
# sector_Ngororero<-c("All", "Bwira",	"Gatumba",	"Hindiro",	"Kabaya",	"Kageyo",	"Kavumu",	"Matyazo",	"Muhanda",	"Muhororo",	"Ndaro",	"Ngororero",	"Nyange",	"Sovu" )
# 
# sector_Nyabihu<-c("All", "Bigogwe",	"Jenda",	"Jomba", 	"Kabatwa",	"Karago",	"Kintobo",	"Mukamira",	"Muringa",	"Rambura",	"Rugera",	"Rurembo",	"Shyira"		 )
# 
# sector_Nyamasheke<-c("All", "Bushekeri",	"Bushenge",	"Cyato",	"Gihombo",	"Kagano",	"Kanjongo",	"Karambi",	"Karengera",	"Kirimbi",	"Macuba",	"Mahembe",	"Nyabitekeri",	"Rangiro",	"Ruharambuga",	"Shangi"	 )
# 
# sector_Rubavu<-c("All", "Bugeshi",	"Busasamana",	"Cyanzarwe",	"Gisenyi",	"Kanama",	"Kanzenze",	"Mudende",	"Nyakiriba",	"Nyamyumba",	"Nyundo",	"Rubavu",	"Rugerero" )
# 
# sector_Rusizi<-c("All", "Bugarama",	"Butare",	"Bweyeye",	"Gashonga",	"Giheke",	"Gihundwe",	"Gikundamvura",	"Gitambi",	"Kamembe",	"Muganza",	"Mururu",	"Nkanka",	"Nkombo",	"Nkungu",	"Nyakabuye",	"Nyakarenzo", "Nzahaha",	"Rwimbogo" )
# 
# sector_Rutsiro<-c("All", "Boneza",	"Gihango", 	"Kigeyo",	"Kivumu",	"Manihira",	"Mukura",	"Murunda",	"Musasa",	"Mushonyi",	"Mushubati",	"Nyabirasi",	"Ruhango",	"Rusebeya"  )
# 
# sector_Burera<-c("All", "Bungwe",	"Butaro",	"Cyanika",	"Cyeru",	"Gahunga",	"Gatebe",	"Gitovu",	"Kagogo",	"Kinoni",	"Kinyababa",	"Kivuye",	"Nemba",	"Rugarama",	"Rugengabari",	"Ruhunde",	"Rusarabuye",	"Rwerere" )
# 
# sector_Gakenke<-c("All","Busengo",	"Coko",	"Cyabingo",	"Gakenke",	"Gashenyi",	"Janja",	"Kamubuga",	"Karambo",	"Kivuruga",	"Mataba",	"Minazi",	"Mugunga",	"Muhondo",	"Muyongwe",	"Muzo",	"Nemba",	"Ruli",	"Rusasa",	"Rushashi"  )
# 
# sector_Gicumbi<-c("All","Bukure",	"Bwisige",	"Byumba",	"Cyumba",	"Giti",	"Kageyo",	"Kaniga",	"Manyagiro",	"Miyove",	"Mukarange",	"Muko",	"Mutete",	"Nyamiyaga",	"Nyankenke",	"Rubaya",	"Rukomo",	"Rushaki",	"Rutare",	"Ruvune",	"Rwamiko",	"Shangasha"  )
# 
# sector_Musanze<-c("All", "Busogo",	"Cyuve",	"Gacaca",	"Gashaki",	"Gataraga",	"Kimonyi",	"Kinigi",	"Muhoza",	"Muko",	"Musanze",	"Nkotsi",	"Nyange",	"Remera",	"Rwaza",	"Shingiro" )
# 
# sector_Rulindo<-c("All","Base",	"Burega",	"Bushoki",	"Buyoga",	"Cyinzuzi",	"Cyungo",	"Kinihira",	"Kisaro",	"Masoro",	"Mbogo",	"Murambi",	"Ngoma",	"Ntarabana",	"Rukozo",	"Rusiga",	"Shyrongi",	"Tumba"  )
# 
# sector_Gisagara<-c("All","Gikonko",	"Gishubi",	"Kansi",	"Kibirizi",	"Kigembe",	"Mamba",	"Muganza",	"Mugombwa",	"Mukindo" ,	"Musha", 	"Ndora" ,	"Nyanza",	"Save"  )
# 
# sector_Huye<-c("All", "Gishamvu",	"Huye",	"Karama",	"Kigoma",	"Kinazi",	"Maraba",	"Mbazi",	"Mukura",	"Ngoma",	"Ruhashya",	"Rusatira",	"Rwaniro",	"Simbi",	"Tumba" )
# 
# sector_Kamonyi<-c("All", "Gacurabwenge",	"Karama",	"Kayenzi",	"Kayumbu",	"Mugina",	"Musambira",	"Ngamba",	"Nyamiyaga",	"Nyarubaka",	"Rugarika",	"Rukoma",	"Runda" )
# 
# sector_Muhanga<-c("All", "Cyeza",	"Kabacuzi",	"Kibangu",	"Kiyumba",	"Muhanga",	"Mushishiro",	"Nyabinoni",	"Nyamabuye",	"Nyarusange",	"Rongi",	"Rugendabari",	"Shyogwe" )
# 
# sector_Nyamagabe<-c("All", "Buruhukiro",	"Cyanika",	"Gasaka",	"Gatare",	"Kaduha",	"Kamegeri",	"Kibirizi",	"Kibumbwe",	"Kitabi",	"Mbazi",	"Mugano",	"Musange",	"Musebeya",	"Mushubi",	"Nkomane",	"Tare",	"Uwinkingi" )
# 
# sector_Bugesera<-c("All", "Gashora",	"Juru",	"Kamabuye",	"Mareba",	"Mayange",	"Musenyi",	"Mwogo",	"Ngeruka",	"Ntarama",	"Nyamata",	"Nyarugenge",	"Rilima",	"Ruhuha",	"Rweru",	"Shyara" )
# 
# sector_Gatsibo<-c("All", "Gasange",	"Gatsibo",	"Gitoki",	"Kabarore",	"Kageyo",	"Kiramuruzi",	"Kiziguro",	"Muhura",	"Murambi",	"Ngarama",	"Nyagihanga",	"Remera",	"Rugarama",	"Rwimbogo" )
# 
# sector_Kayonza<-c("All", "Gahini",	"Kabare",	"Kabarondo",	"Mukarange",	"Murama",	"Murundi",	"Mwiri",	"Ndego",	"Nyamirama",	"Rukara",	"Ruramira",	"Rwinkwavu" )
# 
# sector_Kirehe<-c( "All","Gahara",	"Gatore",	"Kigarama",	"Kigina",	"Kirehe",	"Mahama",	"Mpanga",	"Musaza",	"Mushikiri",	"Nasho",	"Nyamugari",	"Nyarubuye" )
# 
# sector_Ngoma<-c("All", "Gashanda",	"Jarama",	"Karembo",	"Kazo",	"Kibungo",	"Mugesera",	"Murama",	"Mutenderi",	"Remera",	"Rukira",	"Rukumberi",	"Rurenge",	"Sake",	"Zaza"	 )
# 
# sector_Nyagatare<-c("All", "Gatunda",	"Karama",	"Karangazi",	"Katabagemu",	"Kiyombe",	"Matimba",	"Mimuri",	"Mukama",	"Musheri",	"Nyagatare",	"Rukomo",	"Rwempasha",	"Rwimiyaga",	"Tabagwe" )
# 
# sector_Rwamagana<-c("All", "Fumbwe",	"Gahengeri",	"Gishali",	"Karenge",	"Kigabiro",	"Muhazi",	"Munyaga",	"Munyiginya",	"Musha",	"Muyumbu",	"Mwulire",	"Nyakaliro",	"Nzige",	"Rubona"	 )
# 
# sector_Gasabo<-c("All", "Bumbogo",	"Gatsata",	"Gikomero",	"Gisozi",	"Jabana",	"Jali",	"Kacyiru",	"Kimihurura",	"Kimironko",	"Kinyinya",	"Ndera",	"Nduba",	"Remera",	"Rusororo",	"Rutunga" )
# 
# sector_Kicukiro<-c("All",	"Gahanga", 	"Gatenga",	"Gikondo",	"Kagarama",	"Kanombe",	"Kicukiro",	"Kigarama",	"Masaka",	"Niboye",	"Nyarugunga"  )
# 
# sector_Nyarugenge<-c( "All","Gitega",	"Kanyinya", "Kigali", "Kimisagara", "Mageregere", "Muhima", "Nyakabanda", "Nyamirambo", "Nyarugenge", "Rwezamenyo" )





# selectInput(
#   "distfinder",
#   label = "sector",
#   multiple=FALSE,
#   choices = as.character((sectors[which(sectors$District == input$districtfinder), ])$Sector),
#   selected= "All"),

#sector_choices <- sectors[which(sectors$District == input$districtfinder), ],



# choices = as.character(dat5[dat5$email==input$Select, date]))

# conditionalPanel(  condition = "input.districtfinder == 'Bugesera'",  
#                    selectInput("sectorfinder",  
#                                label = "Sector",
#                                multiple=FALSE,  
#                                selectize = TRUE, 
#                                choices =sector_Bugesera ,
#                                selected = "All")
# ),

# conditionalPanel( condition = "input.districtfinder == 'Gatsibo'",
#                   selectInput("sectorfinder",label = "Sector",  
#                               multiple=FALSE,   
#                               selectize = TRUE,  
#                               choices =sector_Gatsibo ,
#                               selected = "All")
# ),
# conditionalPanel(  condition = "input.districtfinder == 'Kayonza'", 
#                    selectInput("sectorfinder",  label = "Sector",  
#                                multiple=FALSE,selectize = TRUE,  
#                                choices =sector_Kayonza ,
#                                selected = "All")
# ),
# conditionalPanel( condition = "input.districtfinder == 'Kirehe'", selectInput("sectorfinder", label = "Sector",  multiple=FALSE,   selectize = TRUE,  choices =sector_Kirehe,
#                                                                               selected = "All")
# ),
# conditionalPanel( condition = "input.districtfinder == 'Ngoma'",selectInput("sectorfinder",label = "Sector",  multiple=FALSE, selectize = TRUE,  choices =sector_Ngoma,
#                                                                             selected = "All")
# ),
# conditionalPanel(condition = "input.districtfinder == 'Nyagatare'",  selectInput(  "sectorfinder", label = "Sector",  multiple=FALSE,  selectize = TRUE,choices =sector_Nyagatare,
#                                                                                    selected = "All")
# ),
# 
# conditionalPanel( condition = "input.districtfinder == 'Rwamagana'",selectInput("sectorfinder",  label = "Sector",  multiple=FALSE,  selectize = TRUE,choices =sector_Rwamagana,
#                                                                                 selected = "All")
# ),
# conditionalPanel( condition = "input.districtfinder == 'Gasabo'",  selectInput( "sectorfinder",  label = "Sector",  multiple=FALSE,    selectize = TRUE,  choices =sector_Gasabo,
#                                                                                 selected = "All")
# ),
# conditionalPanel( condition = "input.districtfinder == 'Kicukiro'",  selectInput( "sectorfinder", label = "Sector",  multiple=FALSE,  selectize = TRUE, choices =sector_Kicukiro,
#                                                                                   selected = "All")
# ),
# conditionalPanel(condition = "input.districtfinder == 'Nyarugenge'",selectInput("sectorfinder", label = "Sector",  multiple=FALSE,   selectize = TRUE,   choices =sector_Nyarugenge,
#                                                                                 selected = "All")
# ),
# conditionalPanel(condition = "input.districtfinder == 'Burera'",selectInput("sectorfinder", label = "Sector", multiple=FALSE,selectize = TRUE,choices =sector_Burera,
#                                                                             selected = "All")
# ),
# conditionalPanel(condition = "input.districtfinder == 'Gakenke'",selectInput("sectorfinder", label = "Sector", multiple=FALSE,selectize = TRUE,choices =sector_Gakenke,
#                                                                              selected = "All")
# ),
# conditionalPanel(condition = "input.districtfinder == 'Gicumbi'",selectInput("sectorfinder", label = "Sector", multiple=FALSE,selectize = TRUE,choices =sector_Gicumbi,
#                                                                             selected = "All")
# ),
# conditionalPanel(condition = "input.districtfinder == 'Musanze'",selectInput("sectorfinder", label = "Sector", multiple=FALSE,selectize = TRUE,choices =sector_Musanze,
#                                                                             selected = "All")
# ),
# conditionalPanel(condition = "input.districtfinder == 'Rulindo'",selectInput("sectorfinder", label = "Sector", multiple=FALSE,selectize = TRUE,choices =sector_Rulindo,
#                                                                             selected = "All")
# ),
# conditionalPanel(condition = "input.districtfinder == 'Gisagara'",selectInput("sectorfinder", label = "Sector", multiple=FALSE,selectize = TRUE,choices =sector_Gisagara,
#                                                                              selected = "All")
# ),
# conditionalPanel(condition = "input.districtfinder == 'Huye'",selectInput("sectorfinder", label = "Sector", multiple=FALSE,selectize = TRUE,choices =sector_Huye,
#                                                                              selected = "All")
# ),
# conditionalPanel(condition = "input.districtfinder == 'Kamonyi'",selectInput("sectorfinder", label = "Sector", multiple=FALSE,selectize = TRUE,choices =sector_Kamonyi,
#                                                                              selected = "All")
# ),
# conditionalPanel(condition = "input.districtfinder == 'Muhanga'",selectInput("sectorfinder", label = "Sector", multiple=FALSE,selectize = TRUE,choices =sector_Muhanga,
#                                                                              selected = "All")
# ),
# conditionalPanel(condition = "input.districtfinder == 'Nyamagabe'",selectInput("sectorfinder", label = "Sector", multiple=FALSE,selectize = TRUE,choices =sector_Nyamagabe,
#                                                                              selected = "All")
# ),
# conditionalPanel(condition = "input.districtfinder == 'Nyanza'",selectInput("sectorfinder", label = "Sector", multiple=FALSE,selectize = TRUE,choices =sector_Nyanza,
#                                                                              selected = "All")
# ),
# conditionalPanel(condition = "input.districtfinder == 'Nyaruguru'",selectInput("sectorfinder", label = "Sector", multiple=FALSE,selectize = TRUE,choices =sector_Nyaruguru,
#                                                                              selected = "All")
# ),
# conditionalPanel(condition = "input.districtfinder == 'Ruhango'",selectInput("sectorfinder", label = "Sector", multiple=FALSE,selectize = TRUE,choices =sector_Ruhango,
#                                                                              selected = "All")
# ),
# conditionalPanel(condition = "input.districtfinder == 'Karongi'",selectInput("sectorfinder", label = "Sector", multiple=FALSE,selectize = TRUE,choices =sector_Karongi,
#                                                                              selected = "All")
# ),
# conditionalPanel(condition = "input.districtfinder == 'Ngororero'",selectInput("sectorfinder", label = "Sector", multiple=FALSE,selectize = TRUE,choices =sector_Ngororero,
#                                                                              selected = "All")
# ),
# conditionalPanel(condition = "input.districtfinder == 'Nyabihu'",selectInput("sectorfinder", label = "Sector", multiple=FALSE,selectize = TRUE,choices =sector_Nyabihu,
#                                                                                selected = "All")
# ),
# conditionalPanel(condition = "input.districtfinder == 'Nyamasheke'",selectInput("sectorfinder", label = "Sector", multiple=FALSE,selectize = TRUE,choices =sector_Nyamasheke,
#                                                                                selected = "All")
# ),
# conditionalPanel(condition = "input.districtfinder == 'Rubavu'",selectInput("sectorfinder", label = "Sector", multiple=FALSE,selectize = TRUE,choices =sector_Rubavu,
#                                                                                selected = "All")
# ),
# conditionalPanel(condition = "input.districtfinder == 'Rusizi'",selectInput("sectorfinder", label = "Sector", multiple=FALSE,selectize = TRUE,choices =sector_Rusizi,
#                                                                                selected = "All")
# ),
# conditionalPanel(condition = "input.districtfinder == 'Rutsiro'",selectInput("sectorfinder", label = "Sector", multiple=FALSE,selectize = TRUE,choices =sector_Rutsiro,
#                                                                                selected = "All")
# ),








# dropdownButton(
#   
#   label = " Select District (s)", status = "default", width = 500,
#   # actionButton(inputId = "a2z", label = "Sort A to Z", icon = icon("sort-alpha-asc")),
#   # actionButton(inputId = "z2a", label = "Sort Z to A", icon = icon("sort-alpha-desc")),
#   #br(),
#   actionButton(inputId = "all", label = "(Un)select all"),
#   selectizeInput(inputId = "districtfinder", multiple=TRUE, label = "",  choices = district_select,
#                  options = list(
#                    placeholder = 'select here'))
# ),

# dropdownButton(
#   
#   label = " Select District (s)", status = "default", width = 500,
#   # actionButton(inputId = "a2z", label = "Sort A to Z", icon = icon("sort-alpha-asc")),
#   # actionButton(inputId = "z2a", label = "Sort Z to A", icon = icon("sort-alpha-desc")),
#   #br(),
#   actionButton(inputId = "all", label = "(Un)select all"),
#   selectizeInput(inputId = "districtfinder", multiple=TRUE, label = "",  choices = district_select,
#                  options = list(
#                    placeholder = 'select here'))
# ),


#length(sectors_rwanda)


# sectors_rwanda<-c( "Busasamana",	"Busoro",	"Cyabakamyi",	"Kibilizi",	"Kigoma",	"Mukingo",	"Muyira",	"Ntyazo",	"Nyagisozi",	"Rwabicuma" ,"Busanze",	"Cyahinda",
#                   "Kibeho",	"Kivu",	"Mata",	"Muganza",	"Munini",	"Ngera",	"Ngoma",	"Nyabimata",	"Nyagisozi", 	"Ruheru",	"Ruramba",	"Rusenge" 
#                   ,"Bweramana",	"Byimana",	"Kabagali",	"Kinazi",	"Kinihira",	"Mbuye",	"Mwendo",	"Ntongwe",	"Ruhango" 
#                   ,"Bwishyura",	"Gashari",	"Gishyita",	"Gitesi",	"Mubuga",	"Murambi",	"Murundi",	"Mutuntu",	"Rubengera",	"Rugabano",	"Ruganda",
#                   "Rwankuba",	"Twumba" , "Bwira",	"Gatumba",	"Hindiro",	"Kabaya",	"Kageyo",	"Kavumu",	"Matyazo",	"Muhanda",	"Muhororo",	"Ndaro",	"Ngororero",	
#                   "Nyange",	"Sovu" , "Bigogwe",	"Jenda",	"Jomba", 	"Kabatwa",	"Karago",	"Kintobo",	"Mukamira",	"Muringa",	"Rambura",	"Rugera",	"Rurembo",	"Shyira"
#                   , "Bushekeri",	"Bushenge",	"Cyato",	"Gihombo",	"Kagano",	"Kanjongo",	"Karambi",	"Karengera",	"Kirimbi",	"Macuba",	"Mahembe",	"Nyabitekeri",
#                   "Rangiro",	"Ruharambuga",	"Shangi", "Bugeshi",	"Busasamana",	"Cyanzarwe",	"Gisenyi",	"Kanama",	"Kanzenze",	"Mudende",	"Nyakiriba",	"Nyamyumba",
#                   "Nyundo",	"Rubavu",	"Rugerero" , "Bugarama",	"Butare",	"Bweyeye",	"Gashonga",	"Giheke",	"Gihundwe",	"Gikundamvura",	"Gitambi",	"Kamembe",	"Muganza",
#                   "Mururu",	"Nkanka",	"Nkombo",	"Nkungu",	"Nyakabuye",	"Nyakarenzo", "Nzahaha",	"Rwimbogo" , "Boneza",	"Gihango", 	"Kigeyo",	"Kivumu",	"Manihira",	
#                   "Mukura",	"Murunda",	"Musasa",	"Mushonyi",	"Mushubati",	"Nyabirasi",	"Ruhango",	"Rusebeya"  , "Bungwe",	"Butaro",	"Cyanika",	"Cyeru",	"Gahunga",
#                   "Gatebe",	"Gitovu",	"Kagogo",	"Kinoni",	"Kinyababa",	"Kivuye",	"Nemba",	"Rugarama",	"Rugengabari",	"Ruhunde",	"Rusarabuye",	"Rwerere" ,"Busengo",
#                   "Coko",	"Cyabingo",	"Gakenke",	"Gashenyi",	"Janja",	"Kamubuga",	"Karambo",	"Kivuruga",	"Mataba",	"Minazi",	"Mugunga",	"Muhondo",	"Muyongwe",	
#                   "Muzo",	"Nemba",	"Ruli",	"Rusasa",	"Rushashi" ,"Bukure",	"Bwisige",	"Byumba",	"Cyumba",	"Giti",	"Kageyo",	"Kaniga",	"Manyagiro",	"Miyove",	
#                   "Mukarange",	"Muko",	"Mutete",	"Nyamiyaga",	"Nyankenke",	"Rubaya",	"Rukomo",	"Rushaki",	"Rutare",	"Ruvune",	"Rwamiko",	"Shangasha" 
#                   , "Busogo",	"Cyuve",	"Gacaca",	"Gashaki",	"Gataraga",	"Kimonyi",	"Kinigi",	"Muhoza",	"Muko",	"Musanze",	"Nkotsi",	"Nyange",	"Remera",	"Rwaza",	
#                   "Shingiro" ,"Base",	"Burega",	"Bushoki",	"Buyoga",	"Cyinzuzi",	"Cyungo",	"Kinihira",	"Kisaro",	"Masoro",	"Mbogo",	"Murambi",	"Ngoma",	
#                   "Ntarabana",	"Rukozo",	"Rusiga",	"Shyrongi",	"Tumba" ,"Gikonko",	"Gishubi",	"Kansi",	"Kibirizi",	"Kigembe",	"Mamba",	"Muganza",	"Mugombwa",	
#                   "Mukindo" ,	"Musha", 	"Ndora" ,	"Nyanza",	"Save", "Gishamvu",	"Huye",	"Karama",	"Kigoma",	"Kinazi",	"Maraba",	"Mbazi",	"Mukura",	"Ngoma",	"Ruhashya",
#                   "Rusatira",	"Rwaniro",	"Simbi",	"Tumba", "Gacurabwenge",	"Karama",	"Kayenzi",	"Kayumbu",	"Mugina",	"Musambira",	"Ngamba",	"Nyamiyaga",	
#                   "Nyarubaka",	"Rugarika",	"Rukoma",	"Runda", "Cyeza",	"Kabacuzi",	"Kibangu",	"Kiyumba",	"Muhanga",	"Mushishiro",	"Nyabinoni",	"Nyamabuye",
#                   "Nyarusange",	"Rongi",	"Rugendabari",	"Shyogwe" , "Buruhukiro",	"Cyanika",	"Gasaka",	"Gatare",	"Kaduha",	"Kamegeri",	"Kibirizi",	"Kibumbwe",	
#                   "Kitabi",	"Mbazi",	"Mugano",	"Musange",	"Musebeya",	"Mushubi",	"Nkomane",	"Tare",	"Uwinkingi", "Gashora",	"Juru",	"Kamabuye",	"Mareba",	"Mayange",
#                   "Musenyi",	"Mwogo",	"Ngeruka",	"Ntarama",	"Nyamata",	"Nyarugenge",	"Rilima",	"Ruhuha",	"Rweru",	"Shyara", "Gasange",	"Gatsibo",	"Gitoki",
#                   "Kabarore",	"Kageyo",	"Kiramuruzi",	"Kiziguro",	"Muhura",	"Murambi",	"Ngarama",	"Nyagihanga",	"Remera",	"Rugarama",	"Rwimbogo", "Gahini",	"Kabare",
#                   "Kabarondo",	"Mukarange",	"Murama",	"Murundi",	"Mwiri",	"Ndego",	"Nyamirama",	"Rukara",	"Ruramira",	"Rwinkwavu","Gahara",	"Gatore",	"Kigarama",
#                   "Kigina",	"Kirehe",	"Mahama",	"Mpanga",	"Musaza",	"Mushikiri",	"Nasho",	"Nyamugari",	"Nyarubuye" , "Gashanda",	"Jarama",	"Karembo",	"Kazo",	
#                   "Kibungo",	"Mugesera",	"Murama",	"Mutenderi",	"Remera",	"Rukira",	"Rukumberi",	"Rurenge",	"Sake",	"Zaza", "Gatunda",	"Karama",	"Karangazi",	
#                   "Katabagemu",	"Kiyombe",	"Matimba",	"Mimuri",	"Mukama",	"Musheri",	"Nyagatare",	"Rukomo",	"Rwempasha",	"Rwimiyaga",	"Tabagwe", "Fumbwe",	
#                   "Gahengeri",	"Gishali",	"Karenge",	"Kigabiro",	"Muhazi",	"Munyaga",	"Munyiginya",	"Musha",	"Muyumbu",	"Mwulire",	"Nyakaliro",	"Nzige",	
#                   "Rubona", "Bumbogo",	"Gatsata",	"Gikomero",	"Gisozi",	"Jabana",	"Jali",	"Kacyiru",	"Kimihurura",	"Kimironko",	"Kinyinya",	"Ndera",	"Nduba",	
#                   "Remera",	"Rusororo",	"Rutunga",	"Gahanga", 	"Gatenga",	"Gikondo",	"Kagarama",	"Kanombe",	"Kicukiro",	"Kigarama",	"Masaka",	"Niboye",
#                   "Nyarugunga" ,"Gitega",	"Kanyinya", "Kigali", "Kimisagara", "Mageregere", "Muhima", "Nyakabanda", "Nyamirambo", "Nyarugenge", "Rwezamenyo" )
