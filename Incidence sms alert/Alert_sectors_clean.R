

##START HERE

library(tidyverse)
library(dplyr)
library(dplyr)
library(magrittr)

#read diagnosis data
diagnosis_data <- read.csv("website_dashboard/surveillance_dash/data/Diagnosis_result_A.csv", stringsAsFactors = FALSE)
#### select loc, district sector, diagnosis...from diagnosis data
data_all<-diagnosis_data[c("Latitude","Longitude","Has.BXW","District","Sector")]


#remove data where district or sector, or coords is na
data_all<-na.omit(data_all)

data_all<-data_all[!(data_all$Latitude=="" |data_all$Longitude==""| data_all$Has.BXW=="" |data_all$District==""| data_all$Sector==""), ]
view(data_all)


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
  summarise(Totaldiagnoses = n(),Totalincidence = sum(Has.BXW =="YES"))%>%
  suppressWarnings()
View(summarydata)

#WRITE CSV AND CLEAN ...check mispellings/inconsistensies of district and sectors and aggregate accordingly
write.csv(summarydata,"Incidence sms alert/output/to_clean.csv")
#after cleaning save as clean.csv

#Read cleaned summary data
summarydata_clean<- read.csv("Incidence sms alert/output/clean.csv", stringsAsFactors = FALSE)

##CALCULATE INCIDENCE RATE and order

#write results
write.csv(summarydata_clean,"Incidence sms alert/output/CurrentQuarterlyResults.csv")

#save 
#remember to paste the quarter's result in the quarterly spreadsheet (new sheet for each quarter) in the xlsx file 
###Sectors (BXW incidence level)-Quarterly update.xlsx
##also update dropbox
