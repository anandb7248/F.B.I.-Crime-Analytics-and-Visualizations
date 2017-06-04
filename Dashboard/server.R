library(shiny)
library(shinydashboard)
library(ggplot2)
library(leaflet)


function(input, output) {
   data <- read.csv('../Data/Cleaned/01_crime_in_the_united_states_1996-2015.csv')
   
   
   
   output$LineChart <- renderPlot({
      ggplot(data, aes(year, rape_rate)) + geom_point() + geom_line(aes(color=rape_rate)) + 
         xlim(input$range) + labs(x = "Year", y = "Crime Rate") + title(main = 'Crime Rate in United States')
      
   })
   

   
}
