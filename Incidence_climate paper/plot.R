library(RColorBrewer)
library(raster)
library(rgdal)
boundary <- readOGR("data/shp/RWA_adm0.shp")
district_shp <- readOGR("data/shp/RWA_adm2.shp")
plot(district_shp)
## read ag predictions


current<-raster("C:\\Users\\dell\\Documents\\WORK\\Analysis2022\\BXWSDM\\MaxEnt\\OUTPUT\\all\\BXW_avg_current.asc")
future_6.0<-raster("C:\\Users\\dell\\Documents\\WORK\\Analysis2022\\BXWSDM\\MaxEnt\\OUTPUT\\all\\BXW_avg_6.0.asc")
future_8.5<-raster("C:\\Users\\dell\\Documents\\WORK\\Analysis2022\\BXWSDM\\MaxEnt\\OUTPUT\\all\\BXW_avg_8.5.asc")


change_6.0<-raster("C:\\Users\\dell\\Documents\\WORK\\Analysis2022\\BXWSDM\\MaxEnt\\OUTPUT\\all\\arcmap\\change601.tif")
change_8.5<-raster("C:\\Users\\dell\\Documents\\WORK\\Analysis2022\\BXWSDM\\MaxEnt\\OUTPUT\\all\\arcmap\\change851.tif")


croplands_mask<-raster("C:\\Users\\dell\\Documents\\WORK\\Analysis2022\\BXWSDM\\MaxEnt\\OUTPUT\\all\\croplands mask\\croplands_rwa1.tif")
  
plot(croplands_mask)

# writeRaster(change_8.5, filename= "C:\\Users\\dell\\Documents\\WORK\\Analysis2022\\BXWSDM\\MaxEnt\\OUTPUT\\all\\change_8.5.asc", overwrite=T )
# writeRaster(change_6.0, filename= "C:\\Users\\dell\\Documents\\WORK\\Analysis2022\\BXWSDM\\MaxEnt\\OUTPUT\\all\\change_6.0.asc", overwrite=T )


extent(croplands_mask)

current_mask<-raster("C:\\Users\\dell\\Documents\\WORK\\Analysis2022\\BXWSDM\\MaxEnt\\OUTPUT\\all\\masked\\BXW_current1.tif")
future_6.0_mask<-raster("C:\\Users\\dell\\Documents\\WORK\\Analysis2022\\BXWSDM\\MaxEnt\\OUTPUT\\all\\masked\\BXW_avg_601.tif")
future_8.5_mask<-raster("C:\\Users\\dell\\Documents\\WORK\\Analysis2022\\BXWSDM\\MaxEnt\\OUTPUT\\all\\masked\\BXW_avg_851.tif")
change_6.0_mask<-raster("C:\\Users\\dell\\Documents\\WORK\\Analysis2022\\BXWSDM\\MaxEnt\\OUTPUT\\all\\masked\\change601.tif")
change_8.5_mask<-raster("C:\\Users\\dell\\Documents\\WORK\\Analysis2022\\BXWSDM\\MaxEnt\\OUTPUT\\all\\masked asc\\change_8.5.asc")


# writeRaster(current_mask, filename= "C:\\Users\\dell\\Documents\\WORK\\Analysis2022\\BXWSDM\\MaxEnt\\OUTPUT\\all\\masked asc\\BXW_current.asc", overwrite=T )
# writeRaster(future_6.0_mask, filename= "C:\\Users\\dell\\Documents\\WORK\\Analysis2022\\BXWSDM\\MaxEnt\\OUTPUT\\all\\masked asc\\BXW_avg_6.0.asc", overwrite=T )
# writeRaster(future_8.5_mask, filename= "C:\\Users\\dell\\Documents\\WORK\\Analysis2022\\BXWSDM\\MaxEnt\\OUTPUT\\all\\masked asc\\BXW_avg_8.5.asc", overwrite=T )
# writeRaster(change_6.0_mask, filename= "C:\\Users\\dell\\Documents\\WORK\\Analysis2022\\BXWSDM\\MaxEnt\\OUTPUT\\all\\masked asc\\change_6.0.asc", overwrite=T )
# writeRaster(change_8.5_mask, filename= "C:\\Users\\dell\\Documents\\WORK\\Analysis2022\\BXWSDM\\MaxEnt\\OUTPUT\\all\\masked asc\\change_8.5.asc", overwrite=T )

current_mask<-raster("C:\\Users\\dell\\Documents\\WORK\\Analysis2022\\BXWSDM\\MaxEnt\\OUTPUT\\all\\masked asc\\BXW_current.asc")
future_6.0_mask<-raster("C:\\Users\\dell\\Documents\\WORK\\Analysis2022\\BXWSDM\\MaxEnt\\OUTPUT\\all\\masked asc\\BXW_avg_6.0.asc")
future_8.5_mask<-raster("C:\\Users\\dell\\Documents\\WORK\\Analysis2022\\BXWSDM\\MaxEnt\\OUTPUT\\all\\masked asc\\BXW_avg_8.5.asc")
change_6.0_mask<-raster("C:\\Users\\dell\\Documents\\WORK\\Analysis2022\\BXWSDM\\MaxEnt\\OUTPUT\\all\\masked asc\\change_6.0.asc")
change_8.5_mask<-raster("C:\\Users\\dell\\Documents\\WORK\\Analysis2022\\BXWSDM\\MaxEnt\\OUTPUT\\all\\masked asc\\change_8.5.asc")

plot(change_8.5_mask)
plot(change_6.0_mask)
plot(future_8.5_mask)
plot(future_6.0_mask)
plot(changercp2)

changercp<-future_8.5_mask-future_6.0_mask
changercp2<-future_6.0_mask-future_8.5_mask


colfunc4<-colorRampPalette(c("#8c510a",
                             "#bf812d",
                             "#dfc27d",
                             "#f6e8c3",
                             "#f5f5f5",
                             "#c7eae5",
                             "#80cdc1",
                             "#35978f",
                             "#01665e"))


colfun_suit<-colorRampPalette(c("white",
                                "#e5f5e0",
                                "#c7e9c0",
                                "#a1d99b",
                                "#74c476",
                                "#41ab5d",
                                "#238b45",
                                "#006d2c",
                                "#00441b"))

colfun_suit<-colorRampPalette(c("white",
                                "#fdae61",
                                "#fee08b",
                                "#ffffbf",
                                "#d9ef8b",
                                "#a6d96a",
                                "#66bd63",
                                "#1a9850"))

colfun_suit<-colorRampPalette(c(
                                "#3288bd",
                                "#99d594",
                                "#e6f598",
                                "#ffffbf",
                                "#fee08b",
                                "#fc8d59",
                                "#d53e4f"
                                ))

#d53e4f
#fc8d59
#fee08b
#ffffbf
#e6f598
#99d594
#3288bd
plot(district_shp)

a = paste0("Starting portfolio value: $", prettyNum(1000000,big.mark=",",scientific=F))
b = "Inflation assumptions of 3% annually"
c = "Average annual returns: 6%"
d ="Average annual volatility: 7%"

pdf('out.pdf',width=5,height=5)
plot(NA, xlim=c(0,5), ylim=c(0,5), bty='n',
     xaxt='n', yaxt='n', xlab='', ylab='')
text(1,4,a, pos=4)
text(1,3,b, pos=4)
text(1,2,c, pos=4)
text(1,1,d, pos=4)
points(rep(1,4),1:4, pch=15)
dev.off()


pdf(file="C:\\Users\\dell\\Documents\\WORK\\Analysis2022\\BXWSDM\\MaxEnt\\OUTPUT\\all\\maps\\predictions.pdf", width=10, height=5)

par(mfrow=c(1,3), oma=c(5,0.5,0.5,0), mar=c(5,0.5,0.5,0), mai=c(0.6,0.5,0.07,0.0000000001))

###Current
plot(current_mask,zlim=c(0,1),legend=F, axes=F, box=F, col=colfun_suit(100), ylab="Latitude")
title("Current", adj=0.02, line=-1.5, cex.main=1.2)

plot(district_shp, add=T, lwd=0.2, border="black")
plot(boundary, add=T, lwd=0.2, border="black")
Axis(side=2)
Axis(side=1)


###Future
plot(future_6.0_mask, zlim=c(0,1),legend=F, axes=F, box=F, col=colfun_suit(100),xlab="Longitude")
title("Future (RCP 6.0)", adj=0.02, line=-1.5, cex.main=1.2)

plot(district_shp, add=T, lwd=0.2, border="black")
plot(boundary, add=T, lwd=0.2, border="black")
Axis(side=1)



plot(future_8.5_mask, zlim=c(0,1),legend=F, axes=F, box=F, col=colfun_suit(100))
title("Future (RCP 8.5)", adj=0.02, line=-1.5, cex.main=1.2)

plot(district_shp, add=T, lwd=0.2, border="black")
plot(boundary, add=T, lwd=0.2, border="black")
Axis(side=1)

par(mfrow=c(1,1), oma=c(2,25,25,0), mar=c(0,0,45,0), new=T, cex=0.6)
plot(current_mask, legend.only=TRUE,col=colfun_suit(100), zlim=c(0,1),legend.width=0.2, legend.shrink=0.1,cex=0.2,horizontal=T,
     smallplot=c(0.05,0.45, 0.05,0.1))



dev.off()


pdf(file="C:\\Users\\dell\\Documents\\WORK\\Analysis2022\\BXWSDM\\MaxEnt\\OUTPUT\\all\\maps\\changes2.pdf", width=12, height=7)

par(mfrow=c(1,2), oma=c(5,2.5,0.5,0), mar=c(0,0,0.5,0), mai=c(0.8,0.8,0.07,0.0000000001))

###Current
plot(change_6.0_mask, zlim=c(-1,1),legend=F, axes=F, box=F,ylab="Latitude",xlab="Longitude",  col=rev(colfunc4(100)))
title("Change (Future-RCP 6.0)", adj=0.02, line=-1.5, cex.main=1.2)

plot(district_shp, add=T, lwd=0.2,border="black")
plot(boundary, add=T, lwd=0.2, border="black")
Axis(side=2)
Axis(side=1)

###Future
plot(change_8.5_mask, zlim=c(-1,1),legend=F, axes=F, box=F, col=rev(colfunc4(100)))
title("Change (Future-RCP 8.5)", adj=0.02, line=-1.5, cex.main=1.2)

plot(district_shp, add=T, lwd=0.2, border="black")
plot(boundary, add=T, lwd=0.2, border="black")
Axis(side=1)


par(mfrow=c(1,1), oma=c(2,25,25,0), mar=c(0,0,45,0), new=T, cex=0.8)
plot(change_6.0_mask, legend.only=TRUE,col=rev(colfunc4(100)), zlim=c(-1,1),legend.width=0.2, legend.shrink=0.1,cex=0.2,horizontal=T,
     smallplot=c(0.05,0.45, 0.05,0.1))



dev.off()


pdf(file="C:\\Users\\dell\\Documents\\WORK\\Analysis2022\\BXWSDM\\MaxEnt\\OUTPUT\\all\\maps\\changes3.pdf", width=10, height=5)

par(mfrow=c(1,3), oma=c(5,0.5,0.5,0), mar=c(0,0,0.5,0), mai=c(0.07,0.2,0.07,0.0000000001))

###Current
plot(change_6.0_mask, zlim=c(-1,1),legend=F, axes=F, box=F, col=rev(colfunc4(100)))
title("Change (Future: RCP 6.0)", adj=0.02, line=-1.5, cex.main=1.2)

plot(district_shp, add=T, lwd=0.2, border="black" )
plot(boundary, add=T, lwd=0.2, border="black")
Axis(side=2)
Axis(side=1)

###Future
plot(change_8.5_mask, zlim=c(-1,1),legend=F, axes=F, box=F, col=rev(colfunc4(100)))
title("Change (Future: RCP 8.5)", adj=0.02, line=-1.5, cex.main=1.2)

plot(district_shp, add=T, lwd=0.2, border="black")
plot(boundary, add=T, lwd=0.2, border="black")
Axis(side=1)

plot(changercp2, zlim=c(-1,1),legend=F, axes=F, box=F, col=rev(colfunc4(100)))
title("Change (RCP 6.0- RCP 8.5)", adj=0.02, line=-1.5, cex.main=1.2)

plot(district_shp, add=T, lwd=0.2, border="black")
plot(boundary, add=T, lwd=0.2, border="black")
Axis(side=1)

par(mfrow=c(1,1), oma=c(2,25,25,0), mar=c(0,0,45,0), new=T, cex=0.6)
plot(change_6.0_mask, legend.only=TRUE,col=rev(colfunc4(100)), zlim=c(-1,1),legend.width=0.2, legend.shrink=0.1,cex=0.2,horizontal=T,
     smallplot=c(0.05,0.45, 0.05,0.1))

dev.off()



#RCP CHANGE
plot(changercp2, zlim=c(-1,1),legend=T, axes=F, box=F, col=rev(colfunc4(100)))
title("Change (RCP 8.5- RCP 6.0)", adj=0.02, line=-1.5, cex.main=1.2)

plot(district_shp, add=T, lwd=0.2, border="black")
plot(boundary, add=T, lwd=0.2, border="black")
Axis(side=1)

