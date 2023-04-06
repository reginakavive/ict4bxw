

##START HERE

library(tidyverse)
library(dplyr)
library(magrittr)

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

#WRITE CSV AND CLEAN ...check mispellings/inconsistensies of district and sectors and aggregate accordingly
write.csv(summarydata,"Incidence sms alert/output/to_clean.csv")
#after cleaning save as clean.csv

#Read cleaned summary data
summarydata_clean<- read.csv("Incidence sms alert/output/clean.csv", stringsAsFactors = FALSE)
summarydata_clean<-as.data.frame(summarydata_clean)

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
#write results
write.csv(sectorincidencerate,"Incidence sms alert/output/CurrentQuarterResults.csv")
#save 
#remember to paste the quarter's result in the quarterly spreadsheet (new sheet for each quarter) in the xlsx file 
###Sectors (BXW incidence level)-Quarterly update.xlsx
##also update dropbox

