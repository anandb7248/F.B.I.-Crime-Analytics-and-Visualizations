library(shiny)
library(shinydashboard)
library(ggplot2)
library(reshape2)
library(sqldf)
library(rgdal)
library(cdlTools)
library(magrittr)
library(leaflet)
library(readxl)
library(maps)
library(scales)


function(input, output) {
   us_crime <- read.csv('Data/01_crime_in_the_united_states_1996-2015.csv')
   data <- read.csv("Data/2015_crimerates_by_state.csv",stringsAsFactors = F) #used to output choropleth plot
   college <- read.csv('./Data/College_Crime_Rate.csv')
   
   # it says metro_areas cannot be found, but when we run this line by itself we can read in the file
   metro_areas <- read.csv('./Data/MetroAreas.csv') 
   
   choices <- reactive({
      return(paste(input$choice,collapse=", "))
   })
   
   rate_crime <- reactive({
      return(as.character(input$crime))
   })
   
   state_chosen <- reactive({
      return(input$state)
   })
   
   pie_state <- reactive({
      return(input$pie)
   })
   
   area_chosen <- reactive({
      
      df <- subset(metro_areas,Metro_Area == input$area, select = c(Murder, Rape, 
                                                             Robbery, Assault, Vehicle_Theft))
      df <- melt(df)
      colnames(df) <- c('Crime', 'Count')
      return(df)

   })
   
   output$LineChart <- renderPlot({
      years <- subset(us_crime, select = c("year",input$choice))
      mdf <- melt(years, id.vars="year")
      g<-ggplot(mdf, aes(x=year,y=value,colour=variable)) + 
         xlim(input$range) + labs(x = "Year", y = paste("Crime Rate per 100,000 Inhabitants")) + 
         title(main = 'Violent Crime Rates in the U.S.') + geom_line()
      print(g)
   })
   
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
   
   # For some reason Minnesota and Delaware have na's as fip.
   # I then checked the fips function, for fips(delaware) it returned NA.
   # for fips(deleware), which is missplelled, it returned 10, which is the correct fip for Delaware.
   # So the function fip has implementation problems.
   # So for minnesota and delaware I am placing fip code manually.
   STATE_FIPS[8] <- "10"
   STATE_FIPS[23] <- "27"
   
   #Merge fips with dataframe of crime rates
   data <- cbind(data,STATE_FIPS)
   
   #data$STATE_FIPS <- factor(data$STATE_FIPS)
   states <- merge(states_shp, data, by="STATE_FIPS",all=TRUE)
   
   #need o fix last line of state_popup
   #  - trying to output the rate of crime, but cant figure out how to get the state clicked
   
   # Created a reactive variable, that will select a specific subset of dataframe, based on users selected input.
   reactCrimeRate <- reactive({
      if(input$crime == "Murder"){
         return(states$Murder)
      }
      if(input$crime == "Rape"){
         return(states$Rape)
      }
      if(input$crime == "Assault"){
         return(states$Assault)
      }
      if(input$crime == "Burglary"){
         return(states$Burglary)
      }
   })
   
   output$mymap <- renderLeaflet({
      pal <- colorQuantile("Oranges",NULL,n=10)
      state_popup <-paste("<strong>State: </strong>", states$State, 
                          "<br><strong>Violent Crime:</strong>", input$crime,
                          "<br><strong> Year: </strong>", '2008',
                          "<br><strong>Rate:</strong>", reactCrimeRate())
      
      leaflet(data = states) %>%
         setView(lng=-96.416015625, lat= 39.639537564366684, zoom = 4.0) %>%
         addProviderTiles("CartoDB.Positron") %>%
         #addLegend(pal = pal, values = data[,rate_crime()], opacity = 0.7, 
         #          title = 'Rate per 100,000', position = "bottomright") %>%
         addPolygons(fillColor = ~pal(reactCrimeRate()),
                     fillOpacity=0.8,
                     color="#2739c4",
                     weight=1,
                     popup = state_popup)
   })
   
   
   
   # Now formatting data for 3D Pie Chart
   output$PieChart <- renderPlot({
      pie <- ggplot(area_chosen(), aes(x='', y=Count, fill=Crime))+
         geom_bar(width = 1, stat = 'identity') + coord_polar('y', start = 0) + theme_bw() + 
         theme(panel.grid.major = element_blank(),panel.grid.minor = element_blank())
      
      print(pie)
   })   
   
   # Now formatting data for University Bar Graph
   college$X<-NULL
   
   output$BarChart <- renderPlot({
     #get all universities within chosen state
      selection <- subset(college, State==state_chosen())
      selection <-selection[, -c(1,3)] # remove State, and Student_Enrollement columns
      
      selection_crimes<-melt(selection, id.vars='School', variable_name='Crime')
      colnames(selection_crimes) <- c('School', 'Crime', 'Count')
      selection_crimes$Count<-as.numeric(as.character(selection_crimes$Count))
      
      univ <- ggplot(selection_crimes,aes(x=School,y = Count, fill=Crime)) + 
         geom_bar(stat='identity') +
         theme(axis.text.x = element_text(angle=90,hjust=1)) +
         labs(x='University', y='Ocurrences')
      print(univ)
   })
   
}

