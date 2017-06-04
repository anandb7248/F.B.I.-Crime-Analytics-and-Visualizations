library(shiny)
library(shinydashboard)
library(ggplot2)
library(leaflet)


function(input, output) {
   data <- read.csv('../Data/Cleaned/01_crime_in_the_united_states_1996-2015.csv')
   
   
   
   output$LineChart <- renderPlot({
      ggplot(data, aes(year, violent_crime_rate)) + geom_point() + xlim(input$range) +
         labs(x = "Year", y = "Violent Crime Rate")
      
   })
   

   
}
