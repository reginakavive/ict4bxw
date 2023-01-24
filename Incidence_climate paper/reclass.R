


currentcla<-current_mask
future_6.0.cla<-future_6.0_mask
future_8.5.cla<-future_8.5_mask

summary(currentcla)
hist(currentcla)

hist(currentcla,
     breaks = c(0, 0.2, 0.4, 0.6, 0.8, 1),
     xlim = c(0, 1),
     ylim = c(0, 1000))



#reclass 0- 2 low 1
#reclass 2- 5 lmedium 2
#reclass 5- 1 high 3

##classification matrix
reclass_df <- c(0, 0.2, 1,
                0.2, 0.5, 2,
                0.5, 1, 3)

reclass_df

reclass_m <- matrix(reclass_df,
                    ncol = 3,
                    byrow = TRUE)
reclass_m                




# reclassify the raster using the reclass object - reclass_m
current_classified <- reclassify(currentcla,
                             reclass_m)

future_6.0_classified <- reclassify(future_6.0.cla,
                                 reclass_m)

future_8.5_classified <- reclassify(future_8.5.cla,
                                 reclass_m)

# view reclassified data
pdf(file="C:\\Users\\dell\\Documents\\WORK\\Analysis2022\\BXWSDM\\MaxEnt\\OUTPUT\\all\\maps\\predictions pixel graph.pdf", width=10, height=5)
par(mfrow=c(1,3), oma=c(0.5,0.5,0.5,0.5), mar=c(0,0,2.5,2.5), mai=c(0.5,0.5,0.5,0.0000000001))

barplot(current_classified,ylim = c(0, 15000),names.arg =c("Low","Medium","High"),xlab="BXW Risk", ylab="No. of Pixels",
        col=c("#3288bd","#fee08b","#d53e4f"),main = "Current")

barplot(future_6.0_classified,ylim = c(0, 15000),names.arg =c("Low","Medium","High"),xlab="BXW Risk", ylab="No. of Pixels",
        col=c("#3288bd","#fee08b","#d53e4f"),main = "Future(RCP 6.0)")

barplot(future_8.5_classified,ylim = c(0, 15000),names.arg =c("Low","Medium","High"),xlab="BXW Risk", ylab="No. of Pixels",
        col=c("#3288bd","#fee08b","#d53e4f"),main = "Future(RCP 8.5)")

dev.off()


#pixels number
histinfo <- hist(current_classified)

res(current_classified)
res(future_6.0_classified)
res(future_8.5_classified)

histinfo$counts
#current:    1==11251 (60.37%); 2==4032(21.63%)  ; 3==3355 (18%)  total== 18638
#current:    1==6206 (32.78%); 2==6398 (33.79%) ; 3==6328 (33.42%) total== 18932
#current:    1==6338 (33.48%); 2==6681(35.29%)  ; 3==5913 (31.23%)  total== 18932

##land area conversion
# 30-arc-second (1 kilometer)
#1km2
#res(1x1) *no of pixels= area

