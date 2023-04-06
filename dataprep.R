

footer <- readPNG("data/footer.png")

#to update after aggregation in data sourcing folder
bxw_diagnosis <- read.csv("data/Diagnosis_result_A.csv", stringsAsFactors = FALSE)
sectors <- read.csv("data/sectors.csv", stringsAsFactors = FALSE)

rwa_shp <- rgdal::readOGR(dsn   = "data/shp",
                          layer = "rwa_o", 
                          stringsAsFactors = FALSE)

rwad_shp <- rgdal::readOGR(dsn   = "data/shp",
                           layer = "rwa_d", 
                           stringsAsFactors = FALSE)

rwas_shp <- rgdal::readOGR(dsn   = "data/shp/rwa_sector",
                           layer = "Sector", 
                           stringsAsFactors = FALSE)
distR <- st_read("data/gadm36_RWA_shp/gadm36_RWA_2.shp")


######Clean Data##########
#subset for required cols
#head(bxw_data)
diagnosisdata<-bxw_diagnosis

diagnosisdata<-diagnosisdata%>%
  rename(Has_BXW = Has.BXW,
         Date_Created = Date.Created)

diagnosisdata$Latitude<-as.numeric(diagnosisdata$Latitude)
diagnosisdata$Longitude<-as.numeric(diagnosisdata$Longitude)

diagnosisdata<- diagnosisdata [!duplicated(diagnosisdata[c("Latitude","Longitude")]),]

#split date column to date and time
CreatedDate<-(diagnosisdata$Date_Created)
CreatedDate<-gsub("T", " ",CreatedDate)
CreatedDate<-separate(data.frame(CreatedDate),CreatedDate[1], into = c("Date_Created", "Time"), sep = " ",
                      extra = "merge")

diagnosisdata1<-diagnosisdata[c("Farmer","Gender","Latitude","Longitude","Has_BXW", "District","Sector","Cell","Village")]
diagnosisdata2<-cbind( diagnosisdata1, CreatedDate)


diagnosisdata2$Date_Created<-as.Date(diagnosisdata2$Date_Created,  format = "%Y-%m-%d" )

#rename male and females, f or M to Gitsina Gore, Gore, gabo
tail(diagnosisdata2)
diagnosisdata_filtered<-diagnosisdata2[c("Farmer","Gender","Latitude","Longitude","Has_BXW", "District","Sector","Cell","Village", "Date_Created")]

diagnosisdata_filtered<-diagnosisdata_filtered%>%
  replace_with_na(replace = list(Date_Created = ""))%>%
  replace_with_na(replace = list(Gender = ""))%>%
  replace_with_na(replace = list(Gender = "-"))

diagnosisdata_filtered$Gender[diagnosisdata_filtered$Gender=="Female"]<-"Gitsina Gore" 
diagnosisdata_filtered$Gender[diagnosisdata_filtered$Gender=="F"]<-"Gitsina Gore" 
diagnosisdata_filtered$Gender[diagnosisdata_filtered$Gender=="f"]<-"Gitsina Gore" 
diagnosisdata_filtered$Gender[diagnosisdata_filtered$Gender=="Male"]<-"Gitsina Gabo" 
diagnosisdata_filtered$Gender[diagnosisdata_filtered$Gender=="M"]<-"Gitsina Gabo" 
diagnosisdata_filtered$Gender[diagnosisdata_filtered$Gender=="m"]<-"Gitsina Gabo"

diagnosisdata_filtered$Date_Created <- as.Date(diagnosisdata_filtered$Date_Created, format = "%Y-%m-%d")

#######################################################################################
diagnosisdata_filtered1<-diagnosisdata_filtered%>%
  rename(Has.BXW = Has_BXW,
         Date.Created = Date_Created)

bxw_data_all<-diagnosisdata_filtered1[c("Farmer","Gender","Latitude","Longitude","Has.BXW","District","Sector","Cell","Village", "Date.Created")]


bxw_data_e<-bxw_data_all
bxw_data_f<-bxw_data_e


bxw_data_f %>% distinct(Farmer,  .keep_all = TRUE)

bxw_data_f<- bxw_data_f[which(bxw_data_f$Gender == c("Gitsina Gabo","Gitsina Gore") ), ]



bxw_data_h<-bxw_data_e %>%
  select(Farmer,Gender, Date.Created) %>%
  distinct(Farmer,  .keep_all = TRUE)%>%
  group_by(Gender) %>%
  drop_na()%>%
  summarise(count = n()) %>%
  mutate(per=count/sum(count)) %>% 
  ungroup()




incidenceT<-bxw_data_e %>%
  select(Has.BXW, Date.Created) %>%
  drop_na()%>%
  group_by(month = lubridate::floor_date(Date.Created, "year")) %>%
  #summarize(Totaldiagnoses = sum(Has_BXW))%>%
  count() %>%
  rename(Totaldiagnoses = n) %>%
  suppressWarnings()




usertotalT<-bxw_data_e %>%
  select(Farmer, Date.Created) %>%
  distinct(Farmer,  .keep_all = TRUE)%>%
  #drop_na()%>%
  group_by(month = lubridate::floor_date(Date.Created, "year")) %>%
  #summarize(Totaldiagnoses = sum(Has_BXW))%>%
  count() %>%
  drop_na()%>%
  rename(Total = n) %>%
  suppressWarnings()

incidenceGroupedT<-bxw_data_e %>%
  select(Has.BXW, Date.Created) %>%
  #drop_na()%>%
  group_by(month = lubridate::floor_date(Date.Created, "month"),Has.BXW) %>%
  #summarize(Totaldiagnoses = sum(Has_BXW))%>%
  count() %>%
  rename(Total = n) %>%
  suppressWarnings()


incidenceT<-bxw_data_e %>%
  select(Has.BXW, Date.Created) %>%
  drop_na()%>%
  group_by(month = lubridate::floor_date(Date.Created, "year")) %>%
  #summarize(Totaldiagnoses = sum(Has_BXW))%>%
  count() %>%
  rename(Totaldiagnoses = n) %>%
  suppressWarnings()

### total diagnosis by month.... trend line graph
incidenceTotal<-bxw_data_e %>%
  select(Has.BXW, Date.Created) %>%
  #drop_na()%>%
  group_by(month = lubridate::floor_date(Date.Created, "month")) %>%
  #summarize(Totaldiagnoses = sum(Has_BXW))%>%
  count() %>%
  rename(Totaldiagnoses = n) %>%
  suppressWarnings()

### total diagnosis by month grouped per diagnosis, yes or no bxw.... trend line graph
incidenceGrouped<-bxw_data_e %>%
  select(Has.BXW, Date.Created) %>%
  #drop_na()%>%
  group_by(month = lubridate::floor_date(Date.Created, "month"),Has.BXW) %>%
  #summarize(Totaldiagnoses = sum(Has_BXW))%>%
  count() %>%
  rename(Total = n) %>%
  suppressWarnings()

### total diagnosis by year grouped per gender, male  or female.... bar graph percentage graph
userGender<-bxw_data_e %>%
  select(Farmer,Gender, Date.Created) %>%
  distinct(Farmer,  .keep_all = TRUE)%>%
  #drop_na()%>%
  group_by(month = lubridate::floor_date(Date.Created, "year"),Gender) %>%
  #summarize(Totaldiagnoses = sum(Has_BXW))%>%
  count() %>%
  drop_na()%>%
  rename(Total = n) %>%
  suppressWarnings()

#Unique users/farmers reached by year
usertotal<-bxw_data_e %>%
  select(Farmer, Date.Created) %>%
  distinct(Farmer,  .keep_all = TRUE)%>%
  #drop_na()%>%
  group_by(month = lubridate::floor_date(Date.Created, "year")) %>%
  #summarize(Totaldiagnoses = sum(Has_BXW))%>%
  count() %>%
  drop_na()%>%
  rename(Total = n) %>%
  suppressWarnings()

#head(userGenderO)
#overal by gender
userGenderO<-bxw_data_e %>%
  select(Farmer,Gender, Date.Created) %>%
  distinct(Farmer,  .keep_all = TRUE)%>%
  group_by(Gender) %>%
  drop_na()%>%
  summarise(count = n()) %>%
  mutate(per=count/sum(count)) %>% 
  ungroup()

#total bxw incidence by  district  by year... 3 layers bar graph
unique(userGenderO$Gender)
# 
# bxw_data_em<-as.data.frame(bxw_data_e)
# ggplot(bxw_data_e) +
#   geom_sf(data = distR, fill = "#f7f7f7", size = 0.1) +
#   geom_point(aes(x=Longitude,y=Latitude, color=Has.BXW))+
#   scale_colour_manual(labels=c("No", "YES"), values=c("green","red"))
# #coord_sf(xlim = c(28.3, 31.2), ylim = c(-3, -1), expand = F)+
# #labs(title="")+

library(magrittr)
groupbydist<-bxw_data_e %>%
  select(District, Has.BXW) %>%
  #drop_na()%>%
  group_by(District, Has.BXW) %>%
  #summarize(Totaldiagnoses = sum(Has_BXW))%>%
  count() %>%
  drop_na()%>%
  rename(Total = n) %>%
  suppressWarnings()

groupbydist
