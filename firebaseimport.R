
# Install httr if not installed
if (!requireNamespace("httr", quietly = TRUE)) {
  install.packages("httr")
}
if (!requireNamespace("jsonlite", quietly = TRUE)) {
  install.packages("jsonlite")
}
if (!requireNamespace("tools", quietly = TRUE)) {
  install.packages("tools")
}

library(httr)
library(jsonlite)
library(tools)
library(magrittr)
library(dplyr)

# Your Firebase project URL and API key
firebase_url <- "https://stepwise-rwanda.firebaseio.com/"
api_key <- "${{secrets.FIRE_KEY}}"

# Function to make a GET request
firebase_get <- function(path) {
  url <- paste0(firebase_url, path, ".json?auth=", api_key)
  response <- GET(url)
  stop_for_status(response)
  content(response, "text", encoding = "UTF-8")
}

fire.data <- firebase_get("/diagnosis-results")

# Convert JSON data to a data frame (adjust this based on your data structure)
fire.df <- fromJSON(fire.data, flatten = TRUE)


extract_variables <- function(sublists) {
  extracted_data <- list()
  
  for (sublist in sublists) {
    date <- sublist$dateCreated
    hasBXW <- sublist$hasBXW
    id<-sublist$key
    lat<-sublist$lat
    lon<-sublist$lon
    gender<-sublist$farmer$gender
    district<-sublist$farmer$district
    sector<-sublist$farmer$sector
    village<-sublist$farmer$village
    cell<-sublist$farmer$cell
    farmerkey<-sublist$farmer$key
    answers<-sublist$answers
    
    extracted_data[[length(extracted_data) + 1]] <- list(id=id, farmerkey=farmerkey, date = date,gender=gender,district=district,sector=sector, village=village, cell=cell,  hasBXW = hasBXW,lat=lat,lon=lon)
  }
  
  return(extracted_data)
}

result <- extract_variables(fire.df)


result_df <- data.frame(
  id = sapply(result, function(x) ifelse(!is.null(x$id), x$id, NA)),
  farmerkey = sapply(result, function(x) ifelse(!is.null(x$farmerkey), x$farmerkey, NA)),
  date = sapply(result, function(x) ifelse(!is.null(x$date), x$date, NA)),
  gender = sapply(result, function(x) ifelse(!is.null(x$gender), x$gender, NA)),
  district = sapply(result, function(x) ifelse(!is.null(x$district), x$district, NA)),
  sector = sapply(result, function(x) ifelse(!is.null(x$sector), x$sector, NA)),
  village = sapply(result, function(x) ifelse(!is.null(x$village), x$village, NA)),
  cell = sapply(result, function(x) ifelse(!is.null(x$cell), x$cell, NA)),
  lat = sapply(result, function(x) ifelse(!is.null(x$lat), x$lat, NA)),
  lon = sapply(result, function(x) ifelse(!is.null(x$lon), x$lon, NA)),
  hasBXW = sapply(result, function(x) ifelse(!is.null(x$hasBXW), x$hasBXW, NA))
)

result_df_D <- result_df[!duplicated(result_df[c("lat", "lon")]), ]
result_df_D <- result_df_D[complete.cases(result_df_D$date), ]
result_df_D <- subset(result_df_D, !grepl("15778332", as.character(date)))
result_df_D$hasBXW<- ifelse(is.na(result_df_D$hasBXW), "NO", ifelse(result_df_D$hasBXW, "YES", "NO"))


###############cleaning##########
# Remove rows where district has 3 or fewer letters
result_df_D2 <- result_df_D[nchar(result_df_D$district) > 3, ] #very high chance it was a test submission if district has less than 3 letters
result_df_D2$district <- toTitleCase(tolower (result_df_D2$district))
result_df_D2$sector <- toTitleCase(tolower (result_df_D2$sector))
result_df_D2$village <- toTitleCase(tolower (result_df_D2$village))
result_df_D2$cell <- toTitleCase(tolower (result_df_D2$cell))

# List of characters to check for in the district column ....also test submissipns
characters_to_remove <- c("Bxw-District 3", "Gdgd","Gjkll","Gsssd", "Gjkll" ,"Shshsh","Dgjkl" ,"Nothing","Vhhn","None" ,"Gggg" , "Chji","Fghjjjk", 
                          "Ghhhh","Vgjrfh","Jenda ", "Muko","Ka Karegamazi " ,"District")
result_df_D2 <- result_df_D2[!grepl(paste(characters_to_remove, collapse = "|"), result_df_D2$district), ]

#misspelled districts... Define letters to be replaced and their replacements
letters_to_replace <- c("1","Ka"," ","\n","2","9","6","3","5")
replacement_letters <- c("","", "","","", "","","","")

# Replace specified letters in the district column
result_df_D2$district <- gsub(paste(letters_to_replace, collapse = "|"), replacement_letters, result_df_D2$district)

replacelist <- c("rongi", "rangi", "Bure", "Bur" , "yonza", "Gatsib0" , "Gstsib0"  ,   "Krongi", 
                        "Rubau","Ķayonza",  "muhanga","Muhaga", "MuhaNga", "Birera","Burers", "Rurido",  "Nyamashecye" ,"Nyamadhekd","Nyamashwke" ,
                        "Gisagara⁷",   "Ruhangi"  ,   "rusizi"  ,    "Gisagata" ,"Rusii", "Ruhabgo", "Tuhango", "Burerra", "Rulimdo","Mahanga",
                        "Ŕurìñdo", "yonzs"  ,     "Muhan"     ,  "yonxa"  ,     ".muhanga" ,   "Rutsiri" , "Nyamagsbe" ,  "Burerar"  ,   "Gakenje",    
                        "Rurinda","Gikonko",  "Anyamasheke" ,  "Kurera", "Ruvabu", "Rurindo" )
toreplacelist <- c("Karongi", "Karongi", "Burera","Burera", "Kayonza", "Gatsibo",  "Gatsibo","Karongi" ,
                         "Rubavu","Kayonza", "Muhanga","Muhanga","Muhanga", "Burera" ,"Burera","Rulindo","Nyamasheke" ,"Nyamasheke","Nyamasheke",
                         "Gisagara"  , "Ruhango"  ,   "Rusizi"   ,   "Gisagara", "Rusizi","Ruhango","Ruhango" ,"Burera" , "Rulindo" ,"Muhanga",
                         "Rulindo","Kayonza"  ,     "Muhanga"   ,    "Kayonza"     ,  "Muhanga"  ,  "Rutsiro" , "Nyamagabe" ,  "Burera"  ,   "Gakenke" ,   
                         "Rulindo", "Gakenke" , "Nyamasheke" , "Burera", "Rubavu", "Rurindo" )

result_df_D2$district[result_df_D2$district %in% replacelist] <- 
  toreplacelist[match(result_df_D2$district[result_df_D2$district%in% replacelist], replacelist)]

#keep values within boundary
#xmin: 28.86171 ymin: -2.839973 xmax: 30.89907 ymax: -1.04745
# Specify the range
xmin <- 28.86171  ; ymin <- -2.839973 ; xmax <- 30.89907 ;ymax <- -1.04745

result_df_D2$lon<-as.numeric(result_df_D2$lon)
result_df_D2$lat<-as.numeric(result_df_D2$lat)
# Filter rows based on the specified range
#& result_df_D2$lon <= xmax & result_df_D2$lat >= ymin & result_df_D2$lat <= ymax
result_df_D2R <- result_df_D2[(result_df_D2$lon >= xmin & result_df_D2$lon <= xmax), ]
result_df_D2R <- result_df_D2R[(result_df_D2R$lat >= ymin & result_df_D2R$lat <= ymax), ]

result_df_D2R <- na.omit(result_df_D2R)

result_df_D2R<-result_df_D2R%>%
  rename(Has.BXW =hasBXW,
         Date.Created = date,
         Longitude =lon,
         Latitude = lat,
         Has.BXW =hasBXW,
         Gender = gender,
         District =district,
         Sector = sector,
         Village = village,
         Farmer = farmerkey,
         Cell= cell)


write.csv(result_df_D2R ,"data/Diagnosis_result_Direct.csv", row.names = FALSE)

