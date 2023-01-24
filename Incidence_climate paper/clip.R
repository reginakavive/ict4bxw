library(raster)
library(rgdal)

boundary <- readOGR("data/shp/RWA_adm0.shp")
plot(boundary)

all_files
files_path <- "C:\\Users\\dell\\AppData\\Local\\ccafs\\ccafs\\Cache\\ncc_noresm1_m_rcp6_0_2050s_tmin_30s_r1i1p1_b4_asc\\tmin_b4" #path where my files are    
all_files <- list.files(files_path,
                        full.names = TRUE,
                        pattern = ".asc$") #take all the ascii files in    
files_stack <- stack(all_files) #stack them together    

mean_ <- calc(files_stack, mean)


#files_stack_crop <- lapply(X = mean_, FUN = crop, y = boundary)

#mean_

myraster.crop <- crop(mean_, extent(boundary), snap="out")
myraster.crop2 <- mask(myraster.crop, boundary, snap="out")
crs(myraster.crop2)<-"+proj=longlat +datum=WGS84 +no_defs"
extent(myraster.crop2)<-st_ext
myraster.crop2
writeRaster(myraster.crop2, filename="C:\\Users\\dell\\Documents\\WORK\\Analysis2022\\BXWSDM\\data\\Environmental\\future\\sc6.0\\ncc\\tmin_avg.asc", overwrite=T )


resol<-res(myraster.crop2)


ras<-raster("C:\\Users\\dell\\Documents\\WORK\\Analysis2022\\BXWSDM\\data\\Environmental\\New folder\\rwandalandco.asc")
crs(ras)<-"+proj=longlat +datum=WGS84 +no_defs"
extent(ras)<-st_ext
res(ras)<-resol
ras
writeRaster(myraster.crop2, filename="C:\\Users\\dell\\Documents\\WORK\\Analysis2022\\BXWSDM\\data\\Environmental\\future\\sc6.0\\ncc\\rwandalandco.asc", overwrite=T )


st_ext<-extent(ras)

plot(ras)
st_ext

rast<-raster("C:\\Users\\dell\\Documents\\WORK\\Analysis2022\\BXWSDM\\RAnalysis\\New folder\\env vars\\ncc\\tmin_avg.asc")
myraster.crop <- crop(rast, extent(boundary), snap="out")
myraster.crop2 <- mask(myraster.crop, boundary, snap="out")
crs(myraster.crop2)<-"+proj=longlat +datum=WGS84 +no_defs"
extent(myraster.crop2)<-st_ext
myraster.crop2
#writeRaster(myraster.crop2, filename= "C:\\Users\\dell\\Documents\\WORK\\Analysis2022\\BXWSDM\\data\\Environmental\\future\\sc6.0\\tmin_avg.asc", overwrite=T )
rgdal::writeGDAL(as(myraster.crop2, "SpatialGridDataFrame"), 
                 paste("C:\\Users\\dell\\Documents\\WORK\\Analysis2022\\BXWSDM\\data\\Environmental\\future\\sc6.0\\tmin_avg.asc", sep=""), 
                 drivername = "AAIGrid")


rast<-raster("C:\\Users\\dell\\Documents\\WORK\\Analysis2022\\BXWSDM\\RAnalysis\\New folder\\env vars\\ncc\\tmax_avg.asc")
myraster.crop <- crop(rast, extent(boundary), snap="out")
myraster.crop2 <- mask(myraster.crop, boundary, snap="out")
crs(myraster.crop2)<-"+proj=longlat +datum=WGS84 +no_defs"
extent(myraster.crop2)<-st_ext
myraster.crop2
#writeRaster(myraster.crop2, filename= "C:\\Users\\dell\\Documents\\WORK\\Analysis2022\\BXWSDM\\data\\Environmental\\future\\sc6.0\\tmin_avg.asc", overwrite=T )
rgdal::writeGDAL(as(myraster.crop2, "SpatialGridDataFrame"), 
                 paste("C:\\Users\\dell\\Documents\\WORK\\Analysis2022\\BXWSDM\\data\\Environmental\\future\\sc6.0\\tmax_avg.asc", sep=""), 
                 drivername = "AAIGrid")



rast<-raster("C:\\Users\\dell\\Documents\\WORK\\Analysis2022\\BXWSDM\\data\\Environmental\\future\\sc8.5\\landco\\rwandalandco.asc")
myraster.crop <- crop(rast, extent(boundary), snap="out")
myraster.crop2 <- mask(myraster.crop, boundary, snap="out")
crs(myraster.crop2)<-"+proj=longlat +datum=WGS84 +no_defs"
extent(myraster.crop2)<-st_ext
myraster.crop2
#writeRaster(myraster.crop2, filename= "C:\\Users\\dell\\Documents\\WORK\\Analysis2022\\BXWSDM\\data\\Environmental\\future\\sc6.0\\tmin_avg.asc", overwrite=T )
rgdal::writeGDAL(as(myraster.crop2, "SpatialGridDataFrame"), 
                 paste("C:\\Users\\dell\\Documents\\WORK\\Analysis2022\\BXWSDM\\data\\Environmental\\future\\sc6.0\\rwandalandco.asc", sep=""), 
                 drivername = "AAIGrid")




myraster.crop2
#extent=st_ext, crs="+proj=longlat +datum=WGS84 +no_defs",
 #                      filename="C:\\Users\\dell\\Documents\\WORK\\Analysis2022\\BXWSDM\\data\\Environmental\\future\\sc6.0\\bcc_csm1_1\\tmin_avg.asc")
#C:\Users\dell\Documents\WORK\Analysis2022\BXWSDM\data\Environmental\future\sc6.01\bcc_csm1_1
rastr2<-raster("C:\\Users\\dell\\Documents\\WORK\\Analysis2022\\BXWSDM\\data\\Environmental\\future\\sc6.0\\tmin_avg.asc")
st_ext2<-extent(ras)
st_ext2

rastr<-raster("C:\\Users\\dell\\Documents\\WORK\\Analysis2022\\BXWSDM\\data\\Environmental\\future\\sc6.01\\mohc_hadgem2\\tmin_avg.asc")
myraster.crop <- crop(rastr, extent(boundary), snap="out")
myraster.crop2 <- mask(myraster.crop, boundary, snap="out")
extent(myraster.crop2)<-st_ext2
myraster.crop2
writeRaster(myraster.crop2, filename= "C:\\Users\\dell\\Documents\\WORK\\Analysis2022\\BXWSDM\\data\\Environmental\\future\\sc6.0\\tmin_avg.asc", overwrite=T )

rastr<-raster("C:\\Users\\dell\\Documents\\WORK\\Analysis2022\\BXWSDM\\data\\Environmental\\future\\sc6.01\\mohc_hadgem2\\tmax_avg.asc")
myraster.crop <- crop(rastr, extent(boundary), snap="out")
myraster.crop2 <- mask(myraster.crop, boundary, snap="out")
extent(myraster.crop2)<-st_ext2
myraster.crop2
writeRaster(myraster.crop2, filename= "C:\\Users\\dell\\Documents\\WORK\\Analysis2022\\BXWSDM\\data\\Environmental\\future\\sc6.0\\tmax_avg.asc", overwrite=T )

