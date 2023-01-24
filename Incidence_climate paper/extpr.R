
files_path <- "C:\\Users\\dell\\Documents\\WORK\\Analysis2022\\BXWSDM\\data\\Environmental\\future\\sc6.0\\mohc_hadgem2" #path where my files are    
all_files <- list.files(files_path,
                        full.names = TRUE,
                        pattern = ".asc$") #take all the ascii files in    


r <- lapply(all_files, raster)

#define the required extent for all files

ras=raster("C:\\Users\\dell\\Documents\\WORK\\Analysis2022\\BXWSDM\\data\\Environmental\\future\\sc8.5\\nimr\\bio_10.asc")
crs(ras)<-"+proj=longlat +datum=WGS84 +no_defs"
extent(ras)
st_ext <- extent(ras)

#create a loop to set new extent

for (i in 1:NROW(r)){
  r[[i]] <- setExtent(r[[i]], st_ext)
  r[[i]]
  }


r

crs(r[[12]])<-"+proj=longlat +datum=WGS84 +no_defs"
r[[12]]
writeRaster(r[[12]], filename= "C:\\Users\\dell\\Documents\\WORK\\Analysis2022\\BXWSDM\\data\\Environmental\\future\\sc6.0\\tmax_avg.asc", overwrite=T )

crs(r[[12]])

crs(r[[3]])
extent(ras)
st_ext
ras2=raster("C:\\Users\\dell\\Documents\\WORK\\Analysis2022\\BXWSDM\\data\\Environmental\\future\\sc6.0\\tmax_avg.asc")
ras2

files_stack <- stack(all_files) #stack them together    


proj4Str <- "+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs"


new_crs_myrasterlist <- sapply(files_stack, function(x) spTransform(files_stack, CRSobj=proj4Str))

new_crs_myrasterlist <- sapply(1:length(files_stack), function(i) spTransform(files_stack[[i]], CRSobj=proj4Str))

#  mohc_hadgem2    bcc_csm1_1
ras=raster("C:\\Users\\dell\\Documents\\WORK\\Analysis2022\\BXWSDM\\data\\Environmental\\future\\sc6.0\\bio_8.asc")
extent(ras)<- st_ext
crs(ras)<-"+proj=longlat +datum=WGS84 +no_defs"
ras
writeRaster(ras, filename= "C:\\Users\\dell\\Documents\\WORK\\Analysis2022\\BXWSDM\\data\\Environmental\\future\\sc6.0\\tmin_avg.asc", overwrite=T )

ras=raster("C:\\Users\\dell\\Documents\\WORK\\Analysis2022\\BXWSDM\\data\\Environmental\\future\\sc6.0\\mohc_hadgem2\\tmax_avg.asc")
crs(ras)<-"+proj=longlat +datum=WGS84 +no_defs"
extent(ras)<- st_ext
ras
writeRaster(ras, filename= "C:\\Users\\dell\\Documents\\WORK\\Analysis2022\\BXWSDM\\data\\Environmental\\future\\sc6.0\\tmax_avg.asc", overwrite=T )




## loop for bioclimatics
my_range <- c(8:12, 16:19)                                        # Create numeric range
my_range 
for (i in my_range){
  path<-paste0("C:\\Users\\dell\\Documents\\WORK\\Analysis2022\\BXWSDM\\data\\Environmental\\future\\sc6.0\\mohc_hadgem2\\bio_",i,".asc")
  ras=raster(path)
  crs(ras)<-"+proj=longlat +datum=WGS84 +no_defs"
  ras<-setExtent(ras, st_ext2)
  path2<-paste0("C:\\Users\\dell\\Documents\\WORK\\Analysis2022\\BXWSDM\\data\\Environmental\\future\\sc6.0\\bio_",i,".asc")
  writeRaster(ras, filename= path2, overwrite=T )
  
}



for(i in my_range) {                                        # Head of for-loop
  print(paste("This iteration represents range value", i))  # Code block
}

##current data extent, projection res

ras<-raster("C:\\Users\\dell\\Documents\\WORK\\Analysis2022\\BXWSDM\\data\\Environmental\\current\\windspeed.asc")
crs(ras)<-"+proj=longlat +datum=WGS84 +no_defs"
extent(ras)<-st_ext
res(ras)<-resol
ras
writeRaster(myraster.crop2, filename="C:\\Users\\dell\\Documents\\WORK\\Analysis2022\\BXWSDM\\data\\Environmental\\currentt\\windspeed.asc", overwrite=T )







