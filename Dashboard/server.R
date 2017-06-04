library(shiny)
library(shinydashboard)
library(ggplot2)
library(leaflet)


function(input, output) {
   data <- read.csv('../Crime/CSV/01_crime_in_the_united_states_by_volume_and_rate_per_100000_inhabitants_1996-2015.csv')
   
   output$lineChart <- renderPlot({
      ggplot(data, aes(x=input$choice, y=data[ , crimerate()], group=1),xlim=input$range) + 
         geom_line() + geom_point()
   } )
   

   
}
