library(raster)
library(rgdal)
library(purrr)

##6.0

files_path <- "C:\\Users\\dell\\Documents\\WORK\\Analysis2022\\BXWSDM\\MaxEnt\\OUTPUT\\future\\sc6.0\\zall" #path where my files are    
all_files <- list.files(files_path,
                        full.names = TRUE,
                        pattern = ".asc$") #take all the ascii files in    
files_stack <- stack(all_files) #stack them together    

mean_ <- calc(files_stack, mean)

plot(mean_)

writeRaster(mean_, filename="C:\\Users\\dell\\Documents\\WORK\\Analysis2022\\BXWSDM\\MaxEnt\\OUTPUT\\future\\sc6.0\\zall\\BXW_avg_6.0.asc", overwrite=T )


##8.5
files_path2 <- "C:\\Users\\dell\\Documents\\WORK\\Analysis2022\\BXWSDM\\MaxEnt\\OUTPUT\\future\\sc8.5\\zall" #path where my files are    
all_files2 <- list.files(files_path2,
                        full.names = TRUE,
                        pattern = ".asc$") #take all the ascii files in    
files_stack2 <- stack(all_files2) #stack them together    

mean_2 <- calc(files_stack2, mean)

plot(mean_2)

writeRaster(mean_2, filename="C:\\Users\\dell\\Documents\\WORK\\Analysis2022\\BXWSDM\\MaxEnt\\OUTPUT\\future\\sc8.5\\zall\\BXW_avg_8.5.asc", overwrite=T )




###current
current<-raster(" ")