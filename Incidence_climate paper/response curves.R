

#Main plots

annualpreci<-read.csv("C:\\Users\\dell\\Documents\\WORK\\Analysis2022\\BXWSDM\\MaxEnt\\OUTPUT\\all\\response curves\\main\\BXW_annualpreci_only.csv")
elevation<-read.csv("C:\\Users\\dell\\Documents\\WORK\\Analysis2022\\BXWSDM\\MaxEnt\\OUTPUT\\all\\response curves\\main\\BXW_elevation_only.csv")
precicoldq<-read.csv("C:\\Users\\dell\\Documents\\WORK\\Analysis2022\\BXWSDM\\MaxEnt\\OUTPUT\\all\\response curves\\main\\BXW_precicoldestquarter_only.csv")
tmax10<-read.csv("C:\\Users\\dell\\Documents\\WORK\\Analysis2022\\BXWSDM\\MaxEnt\\OUTPUT\\all\\response curves\\main\\BXW_tmax_10yrs_only.csv")
roadprox<-read.csv("C:\\Users\\dell\\Documents\\WORK\\Analysis2022\\BXWSDM\\MaxEnt\\OUTPUT\\all\\response curves\\main\\BXW_road_prox_only.csv")
tempcoldq<-read.csv("C:\\Users\\dell\\Documents\\WORK\\Analysis2022\\BXWSDM\\MaxEnt\\OUTPUT\\all\\response curves\\main\\BXW_meantempcoldquarter_only.csv")


#plot

pdf(file="C:\\Users\\dell\\Documents\\WORK\\Analysis2022\\BXWSDM\\MaxEnt\\OUTPUT\\all\\maps\\Response curves_main4.pdf", width=12, height=10)

par(mfrow=c(3,3), oma=c(0.7,0.5,1.5,0.5), mar=c(0.7,0.5,0.5,0.5), mai=c(0.77,0.5,0.2,0.0000000009))


plot(elevation$x,elevation$y, type='l',col= 'red',ylim=c(0,1.0), axes=F,lwd=2.0, 
     xlab='Elevation (m)', ylab='BXW Risk')
title("a) Response of BXW to Elevation", adj=0.02,  cex.main=1.0)
Axis(side=2);Axis(side=1)

plot(annualpreci$x,annualpreci$y, type='l',col= 'red',ylim=c(0,1.0), axes=F,lwd=2.0, 
     xlab='Annual Precipitation (mm)', ylab='BXW Risk')
title("b) Response of BXW to Annual Precipitation", adj=0.02,  cex.main=1.0)
Axis(side=2);Axis(side=1)

plot(tmax17$x,tmax17$y, type='l',col= 'red',ylim=c(0,1.0), axes=F,lwd=2.0, 
     xlab='Maximum Temperature (2018) (\u00B0C)', ylab='BXW Risk')
title("a) Response of BXW to Maximum Temperature (2018)", adj=0.02,  cex.main=1.0)
Axis(side=2);Axis(side=1)

plot(preciwetq$x,preciwetq$y, type='l',col= 'red',ylim=c(0,1.0), axes=F,lwd=2.0,
     xlab='Precipitation Wettest Quarter (mm)', ylab='BXW Risk')
title("f) Response of BXW to Precipitation Wettest Quarter", adj=0.02,  cex.main=1.0)
Axis(side=2);Axis(side=1)

plot(tempcoldq$x,tempcoldq$y, type='l',col= 'red',ylim=c(0,1.0), axes=F,lwd=2.0, 
     xlab='Mean Temperature Coldest Quarter (\u00B0C)', ylab='BXW Risk')
title("e) Response of BXW to Mean Temperature Coldest Quarter", adj=0.02,  cex.main=1.0)
Axis(side=2);Axis(side=1)

plot(mintemp$x,mintemp$y, type='l',col= 'red',ylim=c(0,1.0), axes=F,lwd=2.0, 
     xlab='Minimum Temperature (long term) (\u00B0C)', ylab='BXW Risk')
title("h) Response of BXW to Minimum Temperature (long term)", adj=0.02,  cex.main=1.0)
Axis(side=2);Axis(side=1)


dev.off()


#supplementary material other response curves



dailypreci18<-read.csv("C:\\Users\\dell\\Documents\\WORK\\Analysis2022\\BXWSDM\\MaxEnt\\OUTPUT\\all\\response curves\\others.supplementary\\BXW_avdailypreci_2018_only.csv")
landcover<-read.csv("C:\\Users\\dell\\Documents\\WORK\\Analysis2022\\BXWSDM\\MaxEnt\\OUTPUT\\all\\response curves\\others.supplementary\\BXW_Landcover_only.csv")
maxtemp<-read.csv("C:\\Users\\dell\\Documents\\WORK\\Analysis2022\\BXWSDM\\MaxEnt\\OUTPUT\\all\\response curves\\others.supplementary\\BXW_maxtemperature_only.csv")
tempcoldq<-read.csv("C:\\Users\\dell\\Documents\\WORK\\Analysis2022\\BXWSDM\\MaxEnt\\OUTPUT\\all\\response curves\\others.supplementary\\BXW_meantempcoldquarter_only.csv")
tempdryq<-read.csv("C:\\Users\\dell\\Documents\\WORK\\Analysis2022\\BXWSDM\\MaxEnt\\OUTPUT\\all\\response curves\\others.supplementary\\BXW_meantempdriestqtr_only.csv")
tempwarmq<-read.csv("C:\\Users\\dell\\Documents\\WORK\\Analysis2022\\BXWSDM\\MaxEnt\\OUTPUT\\all\\response curves\\others.supplementary\\BXW_meantempwarmquarter_only.csv")


tempwetq<-read.csv("C:\\Users\\dell\\Documents\\WORK\\Analysis2022\\BXWSDM\\MaxEnt\\OUTPUT\\all\\response curves\\others.supplementary\\BXW_meantempwettestqtr_only.csv")
mintemp<-read.csv("C:\\Users\\dell\\Documents\\WORK\\Analysis2022\\BXWSDM\\MaxEnt\\OUTPUT\\all\\response curves\\others.supplementary\\BXW_mintemperature_only.csv")
precidryq<-read.csv("C:\\Users\\dell\\Documents\\WORK\\Analysis2022\\BXWSDM\\MaxEnt\\OUTPUT\\all\\response curves\\others.supplementary\\BXW_precidriestquarter_only.csv")
preciwarmq<-read.csv("C:\\Users\\dell\\Documents\\WORK\\Analysis2022\\BXWSDM\\MaxEnt\\OUTPUT\\all\\response curves\\others.supplementary\\BXW_preciwarmestquarter_only.csv")
preciwetq<-read.csv("C:\\Users\\dell\\Documents\\WORK\\Analysis2022\\BXWSDM\\MaxEnt\\OUTPUT\\all\\response curves\\others.supplementary\\BXW_preciwettestquarter_only.csv")
#roadprox<-read.csv("C:\\Users\\dell\\Documents\\WORK\\Analysis2022\\BXWSDM\\MaxEnt\\OUTPUT\\all\\response curves\\main\\BXW_meantempcoldquarter_only.csv")

tmax17<-read.csv("C:\\Users\\dell\\Documents\\WORK\\Analysis2022\\BXWSDM\\MaxEnt\\OUTPUT\\all\\response curves\\others.supplementary\\BXW_tmax_2017_only.csv")
tmin10<-read.csv("C:\\Users\\dell\\Documents\\WORK\\Analysis2022\\BXWSDM\\MaxEnt\\OUTPUT\\all\\response curves\\others.supplementary\\BXW_tmin_10years_only.csv")
tmin17<-read.csv("C:\\Users\\dell\\Documents\\WORK\\Analysis2022\\BXWSDM\\MaxEnt\\OUTPUT\\all\\response curves\\others.supplementary\\BXW_tmin_2017_only.csv")
windspeed<-read.csv("C:\\Users\\dell\\Documents\\WORK\\Analysis2022\\BXWSDM\\MaxEnt\\OUTPUT\\all\\response curves\\others.supplementary\\BXW_windspeed_only.csv")



pdf(file="C:\\Users\\dell\\Documents\\WORK\\Analysis2022\\BXWSDM\\MaxEnt\\OUTPUT\\all\\maps\\Response curves_others6.pdf", width=15, height=15)

par(mfrow=c(5,3), oma=c(0.8,0.5,1.5,0.5), mar=c(0.8,0.5,0.5,0.5), mai=c(0.9,0.5,0.2,0.0000000009))



plot(tmax10$x,tmax10$y, type='l',col= 'red',ylim=c(0,1.0), axes=F,lwd=2.0, 
     xlab='Average Monthly Maximum Temperature(10 years)(\u00B0C)', ylab='BXW Risk')
title("d) Response of BXW to Tmax(10 years)", adj=0.02,  cex.main=1.2)
Axis(side=2);Axis(side=1)

plot(tmin10$x,tmin10$y, type='l',col= 'red', ylim=c(0,1.0), axes=F,lwd=2.0, 
     xlab='Minimum Temperature (10years) (\u00B0C)', ylab='BXW Risk')
title("b) Response of BXW to Minimum Temperature (10years)", adj=0.02,  cex.main=1.2)
Axis(side=2);Axis(side=1)

plot(tmin17$x,tmin17$y, type='l',col= 'red',ylim=c(0,1.0), axes=F,lwd=2.0, 
     xlab='Minimum Temperature (2018) (\u00B0C)', ylab='BXW Risk')
title("c) Response of BXW to Minimum Temperature (2018)", adj=0.02,  cex.main=1.2)
Axis(side=2);Axis(side=1)

plot(windspeed$x,windspeed$y, type='l',col= 'red',ylim=c(0,1.0), axes=F,lwd=2.0, 
     xlab='Average Wind Speed (m/s)', ylab='BXW Risk')
title("d) Response of BXW to  Wind Speed", adj=0.02,  cex.main=1.2)
Axis(side=2);Axis(side=1)

plot(precidryq$x,precidryq$y, type='l',col= 'red',ylim=c(0,1.0), axes=F,lwd=2.0, 
     xlab='Precipitation Dryiest Quarter (mm)', ylab='BXW Risk')
title("e) Response of BXW to Precipitation Dryiest Quarter", adj=0.02,  cex.main=1.2)
Axis(side=2);Axis(side=1)

# plot(preciwetq$x,preciwetq$y, type='l',col= 'red',ylim=c(0,1.0), axes=F,lwd=2.0, 
#      xlab='Precipitation Wettest Quarter (mm)', ylab='BXW Risk')
# title("f) Response of BXW to Precipitation Wettest Quarter", adj=0.02,  cex.main=1.0)
# Axis(side=2);Axis(side=1)

plot(precicoldq$x,precicoldq$y, type='l',col= 'red', ylim=c(0,1.0),axes=F,lwd=2.0, 
     xlab='Precipitation of the Coldest Quarter (mm)', ylab='BXW Risk')
title("c) Response of BXW to Precipitation of the Coldest Quarter", adj=0.02,  cex.main=1.2)
Axis(side=2);Axis(side=1)

plot(tempwetq$x,tempwetq$y, type='l',col= 'red',ylim=c(0,1.0), axes=F,lwd=2.0, 
     xlab='Mean Temperature of Wettest Quarter (\u00B0C) ', ylab='BXW Risk')
title("g) Response of BXW to Mean Temperature of Wettest Quarter", adj=0.02,  cex.main=1.2)
Axis(side=2);Axis(side=1)


plot(maxtemp$x,maxtemp$y, type='l',col= 'red',ylim=c(0,1.0), axes=F,lwd=2.0, 
     xlab='Maximum Temperature (\u00B0C)', ylab='BXW Risk')
title("i) Response of Maximum Temperature", adj=0.02,  cex.main=1.2)
Axis(side=2);Axis(side=1)

plot(dailypreci18$x,dailypreci18$y, type='l',col= 'red',ylim=c(0,1.0), axes=F,lwd=2.0, 
     xlab='Average Daily Precipitation (2018) (mm)', ylab='BXW Risk')
title("j) Response of BXW to Average Daily Precipitation (2018)", adj=0.02,  cex.main=1.2)
Axis(side=2);Axis(side=1)

# plot(tempcoldq$x,tempcoldq$y, type='l',col= 'red', axes=F,lwd=2.0, 
#      xlab='Mean Temperature of Coldest Quarter (\u00B0C) ', ylab='BXW Risk')
# title("k) Response of BXW to Mean Temperature of Coldest Quarter", adj=0.02,  cex.main=1.0)
# Axis(side=2);Axis(side=1)

plot(tempdryq$x,tempdryq$y, type='l',col= 'red', ylim=c(0,1.0),axes=F,lwd=2.0, 
     xlab='Mean Temperature of Driest Quarter (\u00B0C)', ylab='BXW Risk')
title("l) Response of BXW to Mean Temperature of Driest Quarter", adj=0.02,  cex.main=1.2)
Axis(side=2);Axis(side=1)

plot(preciwarmq$x,preciwarmq$y, type='l',col= 'red',ylim=c(0,1.0), axes=F,lwd=2.0, 
     xlab='Precipitation of Warmest Quarter (mm)', ylab='BXW Risk')
title("m) Response of BXW to Precipitation of Warmest Quarter", adj=0.02,  cex.main=1.2)
Axis(side=2);Axis(side=1)

plot(tempwarmq$x,tempwarmq$y, type='l',col= 'red',ylim=c(0,1.0), axes=F,lwd=2.0, 
     xlab='Mean Temperature of Warmest Quarter (\u00B0C)', ylab='BXW Risk')
title("n) Response of BXW to Mean Temperature of Warmest Quarter", adj=0.02,  cex.main=1.2)
Axis(side=2);Axis(side=1)

plot(roadprox$x,roadprox$y, type='l',col= 'red',ylim=c(0,1.0), axes=F,lwd=2.0, 
     xlab='Road Proximity (m)', ylab='BXW Risk')
title("f) Response of BXW to Road Proximity", adj=0.02,  cex.main=1.2)
Axis(side=2);Axis(side=1)

barplot(height=landcover$y, names=landcover$x, 
        col=rgb(0.8,0.1,0.1,0.6),
        las=2,cex.main=1.2,
        #xlab="Landcover", 
        ylab="BXW Risk", 
        main="o) Response of BXW to Landcover", 
        ylim=c(0,1)
)

dev.off()

library(ggplot2)
ggplot(landcover, aes(x=x, y=y))+geom_bar()
plot(landcover$x,landcover$y, type='h',col = "red", lwd = 10,
     xlab='Landcover', ylab='BXW Risk')
barplot(landcover$x,landcover$y)
barplot(height=landcover$y, names=landcover$x, 
        col=rgb(0.8,0.1,0.1,0.6),
        srt=45,
        #xlab="Landcover", 
        ylab="BXW Risk", 
        main="My title", 
        ylim=c(0,1)
)
text(seq(1.5, landcover$x, by = 2), par("usr")[3]-0.25, 
     srt = 60, adj = 1, xpd = TRUE, cex = 0.65)
barplot(height=landcover$y, names=landcover$x,
        col="#69b3a2",
        horiz=T, las=1
)
