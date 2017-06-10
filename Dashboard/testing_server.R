library(shiny)
library(shinydashboard)
library(ggplot2)
library(reshape)
library(sqldf)
library(rgdal)
library(cdlTools)
library(magrittr)
library(leaflet)


function(input, output) {
  data <- read.csv('01_crime_in_the_united_states_1996-2015.csv')
  state_crime <- read.csv('2015_crimerates_bystate.csv')
  
  
  
  
   choices <- reactive({
     return(paste0(input$choice,collapse=", "))
   })
   
   
   output$LineChart <- renderPlot({
     #mdf <- melt(temp, id.vars="year", value.name=c("robbery_rate"))
     temp <- subset(data,select = -c(X))
     temp <- subset(temp, select = c("year",input$choice))
     mdf <- melt(temp, id.vars="year")
     g<-ggplot(mdf, aes(x=year,y=value,colour=variable)) + 
       xlim(input$range) + labs(x = "Year", y = paste("Crime Rate per 100,000 Inhabitants")) + 
       title(main = 'Violent Crime Rates in the U.S.') + geom_line()
     print(g)
   })
   
   output$mymap <- renderLeaflet({
      mapStates = map("state", regions=c('California', 'Nevada', 'Colorado'), fill = TRUE, plot = FALSE)
      leaflet(data = mapStates) %>% 
         addTiles() %>%
         addPolygons(fillColor = topo.colors(10, alpha = NULL), stroke = FALSE)
   })
   
   
}
