library(shiny)
library(shinydashboard)
library(ggplot2)
library(reshape)
library(sqldf)
library(rgdal)
library(cdlTools)
library(magrittr)
library(leaflet)
library(readxl)
library(maps)


function(input, output) {
  us_crime <- read.csv('01_crime_in_the_united_states_1996-2015.csv')
  data <- read.csv("2015_crimerates_by_state.csv",stringsAsFactors = F) #used to output choropleth plot
  
  #us_crime <- us_crime[, -1]
  #data <- data[, -1]
  #choro <- read.csv('choro_state_crimerate_2015.csv')
  
 
   choices <- reactive({
     return(paste(input$choice,collapse=", "))
   })
   
   
   output$LineChart <- renderPlot({
     years <- subset(us_crime, select = c("year",input$choice))
     mdf <- melt(years, id.vars="year")
     g<-ggplot(mdf, aes(x=year,y=value,colour=variable)) + 
       xlim(input$range) + labs(x = "Year", y = paste("Crime Rate per 100,000 Inhabitants")) + 
       title(main = 'Violent Crime Rates in the U.S.') + geom_line()
     print(g)
   })
   
   #output$mymap <- renderLeaflet({
      #mapStates = map('state', fill = TRUE, plot = FALSE)
      #leaflet(states_shp) %>% 
        #addTiles() %>%
         #addPolygons(fillColor = topo.colors(10, alpha = NULL), stroke = FALSE)
   #})
   
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
   
   #data$STATE_FIPS <- factor(data$STATE_FIPS)
   states <- merge(states_shp, data, by="STATE_FIPS",all=TRUE)
   
   rate_crime <- reactive({
      return(input$crime)
   })
   
   output$mymap <- renderLeaflet({
      pal <- colorQuantile("Oranges",NULL,n=5)
      state_popup <-paste("<strong>State: </strong>", states$State, 
                          "<br><strong>Violent Crime:</strong>", rate_crime(),
                          "<br><strong> Year: </strong>", '2008',
                          "<br><strong> per 100,000,000 people </strong>")
      
      leaflet(data = states) %>%
         setView(lng=-96.416015625, lat= 39.639537564366684, zoom = 4.0) %>%
         addProviderTiles("CartoDB.Positron") %>%
         addLegend(pal = pal, values = ~data[,rate_crime()], opacity = 0.7, 
                   title = 'Rate per 100,000', position = "bottomright") %>%
         addPolygons(fillColor = ~pal(data[ , rate_crime()]),
                     fillOpacity=0.8,
                     color="#2739c4",
                     weight=1,
                     popup = state_popup)
   })
   
}
