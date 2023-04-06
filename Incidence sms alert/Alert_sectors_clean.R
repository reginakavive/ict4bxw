#A CHRON JOB HAS BEEN SET UP VIA GITHUB ACTIONS TO RUN THIS EVERY THREE MONTHS (1ST) 
# Output saved as csv for each quarter on dropbox (shared folder)
#link to output folder:https://www.dropbox.com/scl/fo/ora1htqx56dsydeu3aipo/h?dl=0&rlkey=6c0jdyeej0wqh0zj7eth8n2is

##START HERE

library(tidyverse)
library(dplyr)
library(magrittr)
library(rdrop2)

#read diagnosis data
diagnosis_data <- read.csv("data/Diagnosis_result_A.csv", stringsAsFactors = FALSE)
#### select loc, district sector, diagnosis...from diagnosis data
data_all<-diagnosis_data[c("Latitude","Longitude","Has.BXW","District","Sector")]


#remove data where district or sector, or coords is na
data_all<-na.omit(data_all)

data_all<-data_all[!(data_all$Latitude=="" |data_all$Longitude==""| data_all$Has.BXW=="" |data_all$District==""| data_all$Sector==""), ]
#view(data_all)


#rename data values ..change case
dataclean<- data_all %>% mutate(District = toupper(District))
dataclean<- dataclean %>% mutate(Sector = toupper(Sector))

#length(dataclean$District)

#remove spaces
dataclean$District <- gsub('\\s+', '', dataclean$District)
dataclean$Sector <- gsub('\\s+', '', dataclean$Sector)

#View(dataclean)
#total diagnosis and incidence
dataclean<-data.frame(dataclean)

#SUMMARISE TOTAL incidence and diagnosis by district and sector
summarydata<-dataclean %>%
  select(Has.BXW,District, Sector) %>%
  #drop_na()%>%
  group_by(District, Sector) %>%
  summarise(totalDiagnoses = n(),totalIncidence = sum(Has.BXW =="YES"))%>%
  suppressWarnings()
#View(summarydata)

# #WRITE CSV AND CLEAN ...check mispellings/inconsistensies of district and sectors and aggregate accordingly
# write.csv(summarydata,"Incidence sms alert/output/to_clean.csv")
# #after cleaning save as clean.csv
# 
# #Read cleaned summary data
# summarydata_clean<- read.csv("Incidence sms alert/output/clean.csv", stringsAsFactors = FALSE)
# summarydata_clean<-as.data.frame(summarydata_clean)

#skip above for automation
summarydata_clean<- as.data.frame(summarydata)

#################################
##CALCULATE INCIDENCE RATE 

#first select sectors with more than 20 diagnoses
select_sectors <- summarydata_clean[which(summarydata_clean$totalDiagnoses >=20), ]

#calculate the incidence rate (2 dp)
sectorincidencerate<-select_sectors%>%
  dplyr:: mutate(incidenceRate=((select_sectors$totalIncidence/select_sectors$totalDiagnoses)*100))

sectorincidencerate[,'incidenceRate']=round(sectorincidencerate[,'incidenceRate'],2)
#View(sectorincidencerate)

#Assign Levels  (High, medium, low)
sectorincidencerate<-sectorincidencerate%>%
  mutate(Level= case_when(
    sectorincidencerate$incidenceRate >= 50 ~ "High",
    sectorincidencerate$incidenceRate >= 20 & sectorincidencerate$incidenceRate < 50  ~ "Medium",
    sectorincidencerate$incidenceRate < 20 ~ "Low"
  ))
  
#view(sectorincidencerate)
#write results (with month/year suffix)
m.y<- as.character (format(Sys.time(), "%Y-%m"))
path<-paste0("Incidence sms alert/output/QuarterlyIncidenceResults.",m.y, ".csv")
write.csv(sectorincidencerate,path)
#saved to csv locally 

#save file to dropbox for access by the team or authorized personnel for SMS disbursement
#dropbox authentication
rdrop2::drop_auth(
  new_user = FALSE,
  key = "${{secrets.DRP_KEY}}",
  secret = "${{secrets.DRP_SECRET}}",
  cache = TRUE,
  rdstoken = NA
)
#Upload to dropbox shared folder
dropbox.path<-file.path("ICT4BXW_Regina_Outputs/BXW Quarterly Incidence/")
rdrop2::drop_upload(path,dropbox.path)





