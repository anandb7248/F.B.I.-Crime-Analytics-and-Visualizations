library(shiny)
library(shinydashboard)
library(ggplot2)
library(leaflet)
library(reshape)

function(input, output) {
  data <- read.csv('01_crime_in_the_united_states_1996-2015.csv')
  
   choices <- reactive({
     return(paste0(input$choice,collapse=", "))
   })
   
   #temp <- reactive({
  #   temp <- subset(data,select = -c(X))
  #   temp <- subset(temp, select = c("year",paste0(input$choice,collapse = ", ")))
  # })
   
   output$LineChart <- renderPlot({
     #mdf <- melt(temp, id.vars="year", value.name=c("robbery_rate"))
     temp <- subset(data,select = -c(X))
     temp <- subset(temp, select = c("year",input$choice))
     mdf <- melt(temp, id.vars="year")
     g<-ggplot(mdf, aes(x=year,y=value,colour=variable)) + 
       xlim(input$range) + labs(x = "Year", y = paste("Crime Rate")) + 
       title(main = 'Crime Rate in United States') + geom_line()
     print(g)
   })
   
}
