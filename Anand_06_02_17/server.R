library(shiny)
library(ggplot2)
library(leaflet)
library(shinydashboard)
#install.packages("readxl")
library(readxl)

function(input, output) {
   #data <- read.table('../crime_data/table_1_crime_in_the_united_states_by_volume_and_rate_per_100000_inhabitants_1996-2015.xls')
  data <- read_xls('../../Crime/Excel/01_crime_in_the_united_states_by_volume_and_rate_per_100000_inhabitants_1996-2015.xls',
                   range = "A4:V24")
  data$Year <- strtrim(data$Year,4) # Some entries in the year had a superscript appended to the end. So this line makes it so that the year only has 4 characters.
  
  crimerate <- reactive({
    as.numeric(input$choice)
    })
  
   output$lineChart <- renderPlot({
     ggplot(data, aes(x=data$Year, y=data[,crimerate()], group=1),xlim=input$Year) + 
       geom_line() + geom_point()
   } )
}