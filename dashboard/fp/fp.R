library(magrittr)
library(tidyr)
library(dplyr)


View(dfp2)

bxw_data_fp<-diagnosisdata[c("Promoter", "Date_Created")]

dfp<-(bxw_data_fp$Date_Created)
dfp<-gsub("T", " ",dfp)
dfp<-separate(data.frame(dfp),dfp[1], into = c("Date_Created", "Time"), sep = " ",
                      extra = "merge")

bxw_data_fp2<-diagnosisdata["Promoter"]
dfp2<-cbind( bxw_data_fp2, dfp)

View(dfp2_grouped)

dfp2_grouped <- dfp2 %>%
  mutate(date = as.Date(Date_Created)) %>%
  select(Promoter , date) %>%
  group_by(date = cut(date, breaks = "1 month"), Promoter ) %>%
  count() %>%
  rename(total_freq = n) %>%
  mutate(date = as.Date(date))


dfp2_grouped2 <- dfp2 %>%
  #mutate(date = as.Date(Date_Created)) %>%
  select(Promoter ) %>%
  group_by( Promoter ) %>%
  count() %>%
  rename(total_freq = n) 

dfp2_date <- dfp2 %>%
  mutate(date = as.Date(Date_Created)) %>%
  select(Promoter , date) %>%
  group_by(date = cut(date, breaks = "1 month")) %>%
  count() %>%
  rename(total_freq = n) %>%
  mutate(date = as.Date(date))


write.csv(dfp2_grouped2, "dfp2_grouped2.csv")
write.csv(dfp2_grouped, "dfp2_grouped_m.csv")
write.csv(data_wide, "data_wide.csv")

c<-tapply(dfp2_grouped$`Promoter`, dfp2_grouped$date, c)
c<-aggregate(data=dfp2_grouped,`Promoter`~date,length)
c<-as.data.frame(c)
View(c)
dfp2_grouped2

names(data_wide)<-gsub("total_freq.","",names(data_wide))

data_wide <- reshape(dfp2_grouped,direction="wide", idvar = "Promoter", timevar = "date")
View(data_wide)


plot_mon

plot_mon<-ggplot(dfp2_date, aes(x=as.Date(date), y=total_freq, group =1))+ 
  geom_point(size=1)+
  geom_line(size=0.7, color='red')+
  theme_bw(base_size = 24)+
  
  labs(title="Total Diagnosis by Month", x="", y="Count")+scale_x_date(date_breaks = "1 month",  date_labels = "%m-%Y")+them2


them2<-theme(#panel.background = element_blank(),
  panel.border = element_blank(),
  panel.background = element_blank(),
  plot.background = element_blank(),
  panel.grid.major = element_blank(),
  panel.grid.minor = element_blank(),
  plot.title = element_text(size=12, face="bold",color = "black", hjust = 0.5 ),
  strip.text.x = element_text(size = 15, color = "black", face = "bold"),
  axis.text=element_text(color = "black",size=10),
  axis.text.x = element_text(angle = 60, hjust = 1),
  #axis.text.y = element_blank(),
  #axis.title=element_text(size=16,face="bold"),
  axis.title=element_text(color = "#000000",size=10),
  legend.title = element_text(color = "#000000",face="bold", size = 12),
  legend.text = element_text(color = "#000000", size = 10),
  #legend.background = element_rect(fill = "black"),
  #panel.border = element_blank()
  axis.line.x = element_line(color="black", size = 0.3),
  #scale_x_date(date_breaks = "months" , date_labels = "%b-%y"),
  axis.line.y = element_line(color="black", size = 0.3)
  #axis.line.x = element_blank(),
  #hovertemplate = paste('%{x}', '<br>lifeExp: %{text:.2s}<br>'),
  #zaxis.line.y = element_blank()
)

them3<-theme(panel.background = element_blank(),
  plot.background = element_blank(),
  #panel.background = element_rect(fill = "black"), # bg of the panel
  #plot.background = element_rect(fill = "black", color = NA), # bg of the plot
  panel.grid.major = element_blank(),
  plot.title = element_text(size=12, face="bold",color = "black", hjust = 0.5 ),
  strip.text.x = element_text(size = 15, color = "black", face = "bold"),
  axis.text=element_text(color = "black",size=10),
  axis.text.x = element_text(angle = 60, hjust = 1),
  #axis.text.y = element_blank(),
  #axis.title=element_text(size=16,face="bold"),
  axis.title=element_text(color = "#000000",size=10),
  legend.title = element_text(color = "#000000",face="bold", size = 12),
  legend.text = element_text(color = "#000000", size = 10),
  #legend.background = element_rect(fill = "black"),
  #panel.border = element_blank()
  axis.line.x = element_line(color="black", size = 0.3),
  #scale_x_date(date_breaks = "months" , date_labels = "%b-%y"),
  axis.line.y = element_line(color="black", size = 0.3)
  #axis.line.x = element_blank(),
  #hovertemplate = paste('%{x}', '<br>lifeExp: %{text:.2s}<br>'),
  #axis.line.y = element_blank()
)


