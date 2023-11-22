#to automate script #chron daily on git actions
#to be updated when chatbot is stabilized

################################################
#get data from firebase database  ###### refer to firebaseimport.R SCRIPT####

#get chatbot data
#-daily dates update on chatbot data

#AGGREGATE

#-rename columns
#-clean data
#bind_rows to combine data
#save aggregated data on dropbox (
#     -all data and 
#     -specific cols for data sharing)


###  uncomment from here
# 
# library(httr)
# library(readr)
# library(rvest)
# library(V8)
# library(magrittr)
# 
# 
# 
# 
# url<-"https://ict4bxw.arifu.com/diagnosis_results"
# username<-"R.Kilwenge@cgiar.org"
# password<-"Regina2022"
# 
# 
# ###chatbot data
# #create secure connnection
# session<-POST(url, body=list(username=username, password=password),encode = "form", verbose())
# 
# download.file("blob:https://ict4bxw.arifu.com/af13ed74-9b48-4677-8658-4fb415c9897e",destfile = "data/diagnosis-results.csv")
# 
# data<-read.csv("diagnosis-results.csv")
# 
# #initial 
# # data$date<-NA
# # data$date<-ifelse(is.na(data$date), format(Sys.time(), "%Y-%m-%d "),data$date)
# 
# # read daily data updated
# data_update<-read.csv("diagnosis-results2.csv")
# 
# #compare and append new rows in data to data_update
# data_m<-dplyr::bind_rows(data,data_update)
# 
# #check new data with na dates and add sys date
# data_m$date<-ifelse(is.na(data_m$date), format(Sys.time(), "%Y-%m-%d "),data_m$date)
# 
# #update/write the diagnosis-results2 file
# write.csv(data_m,"diagnosis-results2.csv")
# 
# 
# # merge with app data
# #download from firebase project
# token<-Sys.getenv("firebasetoken")
# 
# appdata<-download(projectURL = "https://firedata-b0e54.firebaseio.com/", fileName = "main/-KxwWNTVdplXFRZwGMkH")
# #......... require credentials....
# 
# appdata<-read.csv("Diagnosis Result  App.csv")
# 
# #select req cols from both
# #gender,village,cell,sector,district,lat,l;ong, date
# #rename cols and rowbind both
# library(magrittr)
# library(stringr)
# data_mm<-data_m
# names(data_mm)<-gsub("farmer_","",names(data_mm))
# data_mm<-data_mm%>%
#   dplyr::rename(Latitude =lat,
#          FARMER =name,
#          HAS_BXW =has_bxw_status,
#          Longitude =longi)
# names(data_mm)<-toupper(names(data_mm))
# head(data_mm)
# 
# # dd$longitude<-as.numeric(str_replace(str_replace(dd$longitude, "−", "-"), ",", "."))
# 
# appdataa<-appdata
# appdataa<-appdataa%>%
#   dplyr::rename(HAS_BXW =Has.BXW,
#                 DATE =Date.Created)
# names(appdataa)<-toupper(names(appdataa))
# tail(appdataa)
# #save the file to cloud for sharing  aws??
# #DROP NULL SPECIFIC COLS...REMOVE duplicates : lat, long, has_bxw
# data_mm<-data_mm[complete.cases("LATITUDE","LONGITUDE","HAS_BXW"),]
# 
# #convert to numeric class for lat and long for row binding
# data_mm$LATITUDE<-as.numeric(str_replace(str_replace(data_mm$LATITUDE, "−", "-"), "-", ""))
# data_mm$LONGITUDE<-as.numeric(str_replace(str_replace(data_mm$LONGITUDE, "−", "-"), "-", ""))
# data_mm<-data_mm[complete.cases("LATITUDE","LONGITUDE","HAS_BXW"),]
# 
# binded<-dplyr::bind_rows(data_mm,appdataa)
# #View(binded)
# 
# #save file to dropbox for access by the team and sharing purposes
# #dropbox authentication
# rdrop2::drop_auth(
#   new_user = FALSE,
#   key = "${{secrets.DRP_KEY}}",
#   secret = "${{secrets.DRP_SECRET}}",
#   cache = TRUE,
#   rdstoken = NA
# )
# 
# path<-paste0("data_sourcing/data/Diagnosis Results-Complete.csv")
# write.csv(binded,path)
# 
# #All data (for core team and RAB)
# dropbox.path<-file.path("ICT4BXW_Regina_Outputs/BXW Aggregated Diagnosis Data/")
# rdrop2::drop_upload(path,dropbox.path)
# 
# #Filtered data- for sharing purposes (date,lat,lon,has.bxw)
# filtered<-binded[c("DATE","LATITUDE","LONGITUDE","HAS_BXW"),]
# path2<-paste0("data_sourcing/data/Diagnosis Results-Filtered(ForSharing).csv")
# write.csv(filtered,path2)
# dropbox.path2<-file.path("ICT4BXW_Regina_Outputs/BXW Aggregated Diagnosis Data/")
# rdrop2::drop_upload(path2,dropbox.path2)
# 
# 

