####################################################################################################
##################################GIF###############################################################
####################################################################################################
####################################################################################################
####################################################################################################

# Load required libraries and install if not already installed.
if(!require(ggplot2)) install.packages("ggplot2", repos = "http://cran.us.r-project.org")
if(!require(gganimate)) install.packages("gganimate", repos = "http://cran.us.r-project.org")
if(!require(sf)) install.packages("sf", repos = "http://cran.us.r-project.org")
if(!require(dplyr)) install.packages("dplyr", repos = "http://cran.us.r-project.org")
if(!require(png)) install.packages("png", repos = "http://cran.us.r-project.org")
if(!require(purrr)) install.packages("purrr", repos = "http://cran.us.r-project.org")
if(!require(magick)) install.packages("magick", repos = "http://cran.us.r-project.org")
if(!require(lubridate)) install.packages("lubridate", repos = "http://cran.us.r-project.org")
if(!require(ggrepel)) install.packages("ggrepel", repos = "http://cran.us.r-project.org")
if(!require(gtools)) install.packages("gtools", repos = "http://cran.us.r-project.org")


#Working directory matches the surveillance app working directory for easy data access. under (ICT4BXW.Rproject)

# Read the shapefile 
shapefile <- st_read("data/shp/rwa_d.shp")

# diagnosis data...accessed from firebaseimport.R script
# source the firebaseimport.R to import and save diagnosis data -- make sure to replace "${{secrets.FIRE_KEY}}" with the actual API key.
source ("firebaseimport.R")
data <- read.csv('data/Diagnosis_result_Direct.csv')

#format date from char
data$Date<- strptime(data$Date, "%Y-%m-%dT%H:%M:%OS")
data$Date<- as.Date(data$Date, format = "%d/%m/%Y")


# Convert data to an sf object
data_sf <- st_as_sf(data, coords = c("Longitude", "Latitude"), crs = 4326)
data_sf <- data_sf %>%
  mutate(
    longitude = ifelse(st_geometry_type(geometry) == "POINT", st_coordinates(geometry)[, 1], NA),
    latitude = ifelse(st_geometry_type(geometry) == "POINT", st_coordinates(geometry)[, 2], NA)
  )


#function to filter data-monthly- 
# data- the sf data generated above
# start_year- the year for which to start the gif
# end_year - the year for which to end the gif
filter_cumulative_by_month <- function(data, start_year, end_year) {
  data %>%
    mutate(year = year(Date), month = month(Date)) %>%
    filter(year >= start_year & year <= end_year) %>%
    group_by(year, month) %>%
    ungroup()%>%
    mutate(year_month = paste( year,month, sep = "-"))
}

#apply the function and adjust start and end years accordingly. 
filtered_monthly_data<-filter_cumulative_by_month(data_sf, start_year="2021", end_year="2024")

#confirm months
unique(filtered_monthly_data$year_month)

# Order unique_year_month chronologically...cumulative
unique_year_month_ordered <- (filtered_monthly_data$year_month)

# Convert year-month strings to Date objects...cumulative
date_objects <- as.Date(paste(unique_year_month_ordered, "-01", sep = ""), format = "%Y-%m-%d")

# Convert ordered Date objects back to year-month strings...cumulative
ordered_year_month <- format(date_objects, format = "%Y-%m")
filtered_monthly_data$year_month<-ordered_year_month


# Loop through unique year_month values, create plots, and save them
for (unique_year_month in unique(filtered_monthly_data$year_month)) {
  subset_data <- filtered_monthly_data %>%
    filter(year_month == unique_year_month)
  
  plot<-ggplot() +
    geom_sf(data = shapefile, color = "grey",alpha = 0.2) +
    geom_point(data = subset_data, aes(x = longitude, y = latitude, color = Has.BXW), size = 2) +
    geom_sf_label(data = shapefile, aes(label = NAME_2), fill = "transparent", color = "#a9a9a9", size = 2, label.border = 0) +
    labs(title = paste0("BXW Occurrence ",unique_year_month)) +
    scale_color_manual(values = c("NO" = "green", "YES" = "red")) +
    theme(panel.background = element_rect(fill = "black"), # bg of the panel
          plot.background = element_rect(fill = "black", color = NA), # bg of the plot
          panel.grid.major = element_blank(),
          panel.grid.minor = element_blank(),
          plot.title = element_text(size=12, face="bold",color = "#a9a9a9", hjust = 0.5 ),
          strip.text.x = element_text(size = 15, color = "#a9a9a9", face = "bold"),
          axis.text=element_text(color = "#a9a9a9",size=10),
          axis.text.x = element_text(angle = 60, hjust = 1),
          #axis.text.y = element_blank(),
          #axis.title=element_text(size=16,face="bold"),
          axis.title=element_blank(),
          legend.title = element_text(color = "#a9a9a9",face="bold", size = 10),
          legend.text = element_text(color = "#a9a9a9", size = 8),
          #axis.line.x = element_line(color="black", size = 0.3),
          #scale_x_date(date_breaks = "months" , date_labels = "%b-%y"),
          #axis.line.y = element_line(color="black", size = 0.3))
          axis.line.x = element_blank(),
          #hovertemplate = paste('%{x}', '<br>lifeExp: %{text:.2s}<br>'),
          axis.line.y = element_blank(),
          legend.position="bottom",  panel.border = element_rect(colour = "black", fill=NA),legend.key.width=unit(1.0,"cm")
    )
  
  
  plot_filename <- paste0("GIF/plots/plotmonthly/", unique_year_month, ".png")
  ggsave(plot_filename, plot,width = 9, height = 6, dpi = 300)
}



### Create Gif

imgs <- list.files("GIF/plots/plotmonthly/", full.names = TRUE)
img_list <- lapply(imgs, image_read)

## join the images together
img_joined <- image_join(img_list)

## animate at 2 frames per second... #adjust fps to match required speed
img_animated_score <- image_animate(img_joined, fps = 1)

## view animated image
img_animated_score   #view in new window since it's large

## save GIF or mp4 as needed
image_write(image = img_animated_score,
            path = "GIF/plots/bxwoccurrence.gif")
image_write(image = img_animated_score,
            path = "GIF/plots/bxwoccurrence.mp4")
