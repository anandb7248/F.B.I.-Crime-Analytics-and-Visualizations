install.packages("readxl")
install.packages("sqldf")
install.packages("rgdal")
install.packages("cdlTools")
install.packages("magrittr")

library(sqldf)
library(rgdal)
library(cdlTools)
library(magrittr)
library(leaflet)

data <- read.csv("2015_crimerates_bystate.csv",stringsAsFactors = F)
data <- data[, -1]

states_shp <- readOGR(dsn="./states_shp",layer = "states")
# Remove district of columbia
states_shp <- states_shp[!grepl("District of Columbia", states_shp$STATE_NAME), ]

#Obtain fip codes for each US state
STATE_FIPS <- tapply(data$State, data$State, fips)
STATE_FIPS <- as.character(STATE_FIPS)

for(i in 1:length(STATE_FIPS)){
  if(!is.na(STATE_FIPS[i]) & nchar(STATE_FIPS[i]) == 1){
    STATE_FIPS[i] <- paste("0",STATE_FIPS[i], sep='')
  }
}

STATE_FIPS[8] <- "10"
STATE_FIPS[23] <- "27"
  
#Merge fips with dataframe of crime rates
data <- cbind(data,STATE_FIPS)
# For some reason Minnesota and Delaware have na's as fip.
# I then checked the fips function, for fips(delaware) it returned NA.
# for fips(deleware), which is missplelled, it returned 10, which is the correct fip for Delaware.
# So the function fip has implementation problems.
# So for minnesota and delaware I am placing fip code manually.

data$STATE_FIPS <- factor(data$STATE_FIPS)
states <- merge(states_shp,data,by="STATE_FIPS",all=TRUE)

pal <- colorQuantile("Reds",NULL,n=5)

state_popup <-paste("<strong>State: </strong>", 
                   states$State, 
                   "<br><strong>Violent Crime per 100,000, 2008: </strong>", 
                   states$Robbery)

leaflet(data = states) %>%
  addProviderTiles("CartoDB.Positron") %>%
  addPolygons(fillColor = ~pal(Robbery),
              fillOpacity=0.8,
              color="#2739c4",
              weight=1,
              popup = state_popup)

