library(magrittr)

##### sectors ranked by level of incidence

##filter for bxw occurrences only

#incidenceGroupedY<-incidenceGroupedT[which(incidenceGroupedT$Has.BXW == "YES"), ]


# #bxw_data_e$
# dataregions<-bxw_data_e
# tail(dataregions)
# 
# #to lower case - cell col
# dataregions %>% mutate(Cell = tolower(Cell))

#summary by month (no,yes)-total
incidenceGroupedSectors1<-bxw_data_e %>%
  select(Has.BXW,District, Sector, Date.Created) %>%
  #drop_na()%>%
  group_by(month = lubridate::floor_date(Date.Created, "month"),Has.BXW) %>%
  #summarize(Totaldiagnoses = sum(Has_BXW))%>%
  count() %>%
  rename(Total = n) %>%
  suppressWarnings()

bxw_data_e %>%
  select(Has.BXW,District, Sector, Date.Created) %>%
  #drop_na()%>%
  group_by(month = lubridate::floor_date(Date.Created, "month"),Has.BXW) %>%
  #summarize(Totaldiagnoses = sum(Has_BXW))%>%
  count() %>%
  rename(Total = n) %>%
  suppressWarnings()

summary(dataregions)

View(incidenceGroupedSectors1)
# sectordata_alert <- read.csv("C:\\Users\\dell\\Documents\\WORK\\RAB_ICT4BXW\\BXW Alert initiate\\data\\Sector_Incidence.csv", stringsAsFactors = FALSE)
# head(sectordata_alert)

# incidenceGroupedSectors<-sectordata_alert %>%
#   select(District, Sector) %>%
#   #drop_na()%>%
#   group_by(District, Sector) %>%
#   #summarize(Totaldiagnoses = sum(Has_BXW))%>%
#   count() %>%
#   rename(Total = n) %>%
#   suppressWarnings()
# head(incidenceGroupedSectors)
# 
# write.csv(incidenceGroupedSectors,"C:\\Users\\dell\\Documents\\WORK\\RAB_ICT4BXW\\BXW Alert initiate\\data\\Sector_Incidence_grouped.csv")
# 
# 
# sectordata_alert_all <- read.csv("C:\\Users\\dell\\Documents\\WORK\\RAB_ICT4BXW\\BXW Alert initiate\\data\\Sector_Incidence_all.csv", stringsAsFactors = FALSE)
# head(sectordata_alert_all)

#Group by sector-total. no,yes
sectordata_alert_all <-bxw_data_e
incidenceGroupedSectors_all<-sectordata_alert_all %>%
  select(Has.BXW,District, Sector) %>%
  #drop_na()%>%
  group_by(Has.BXW,District, Sector) %>%
  #summarize(Totaldiagnoses = sum(Has_BXW))%>%
  count() %>%
  rename(Total = n) %>%
  suppressWarnings()
head(incidenceGroupedSectors_all)

write.csv(incidenceGroupedSectors_all,"C:\\Users\\dell\\Documents\\WORK\\RAB_ICT4BXW\\BXW Alert initiate\\data\\Sector_Incidence_grouped_all.csv")

#Group by sector-total.all
incidenceGroupedSectors_total<-sectordata_alert_all %>%
  select(Has.BXW,District, Sector) %>%
  #drop_na()%>%
  group_by(District, Sector) %>%
  #summarize(Totaldiagnoses = sum(Has_BXW))%>%
  count() %>%
  rename(Total = n) %>%
  suppressWarnings()
head(incidenceGroupedSectors_total)

write.csv(incidenceGroupedSectors_total,"C:\\Users\\dell\\Documents\\WORK\\RAB_ICT4BXW\\BXW Alert initiate\\data\\Sector_Incidence_grouped_total.csv")



high_risk_sectors <- read.csv("C:\\Users\\dell\\Documents\\WORK\\RAB_ICT4BXW\\BXW Alert initiate\\data\\List of BXW high-risk Sectors.csv", stringsAsFactors = FALSE)
high_risk_sectors

#remove data where district or sector is na
# dataclean<-bxw_data_e[which(bxw_data_e$District !=NA), ] 
# dataclean<-dataclean[which(dataclean$Sector !='n/a'), ] 



##START HERE
#### group by district sector, diagnosis...
library(tidyverse)
library(dplyr)

#remove data where district or sector, or coords is na
#read
data_all <- read.csv("C:\\Users\\dell\\Documents\\WORK\\RAB_ICT4BXW\\BXW Alert initiate\\data_sept.csv", stringsAsFactors = FALSE)
data_all

#rename data values
dataclean<- data_all %>% mutate(District = toupper(District))
dataclean<- dataclean %>% mutate(Sector = toupper(Sector))

#length(dataclean$District)

#remove spaces
dataclean$District <- gsub('\\s+', '', dataclean$District)
dataclean$Sector <- gsub('\\s+', '', dataclean$Sector)

#View(dataclean)
#total diagnosis and incidence
dataclean<-data.frame(dataclean)
library(dplyr)
library(magrittr)
summarydata<-dataclean %>%
  select(Has.BXW,District, Sector) %>%
  #drop_na()%>%
  group_by(District, Sector) %>%
  summarise(Totaldiagnoses = n(),Totalincidence = sum(Has.BXW =="YES"))%>%
  suppressWarnings()
(summarydata)

#WRITE CSV AND CLEAN ...CALCULATE INCIDENCE RATE
write.csv(summarydata,"C:\\Users\\dell\\Documents\\WORK\\RAB_ICT4BXW\\BXW Alert initiate\\data\\DATA_SEPT FOR INCIDENCE CALC.csv")


