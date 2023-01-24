library(raster)
library(rgdal)
library(purrr)
boundary <- readOGR("data/shp/RWA_adm0.shp")
plot(boundary)


files_path <- "F:/WORK/WORK/bxwsdm/Cache/bcc_csm1_1_m_rcp8_5_2050s_prec_30s_r1i1p1_no_tile_asc" #path where my files are    
all_files <- list.files(files_path,
                        full.names = TRUE,
                        pattern = ".asc$") #take all the ascii files in    
files_stack <- stack(all_files) #stack them together    

mean_ <- calc(files_stack, mean)


files_stack_crop <- lapply(X = files_stack, FUN = crop, y = boundary)

rcat_crop <- map(files_stack, crop, boundary)
