library(shiny)
library(ggplot2)
library(leaflet)

fluidPage(
   tabsetPanel(
      tabPanel('Crime in Time', 
               sidebarLayout(
                  sidebarPanel(
                     
                     sliderInput("range", "Range of Years:", 
                                 min = 1995, max = 2015, value = c(2010,2015)),
                     selectizeInput('choice', 'Violent Crimes Committed', 
                                    choices = c('Murder', 'Rape', 'Aggravated Assult', 'Robbery'),
                                    multiple = TRUE, options = list(maxItems = 4))
                  ),
                  
                  mainPanel(
                     plotOutput('lineChart')
                  )
               )
      ),
               
      tabPanel('Map of U.S.', 'Contents'),
      
      tabPanel('Visualization', 'Contents')
   )
)

#sliderInput("range", "Range of Years:",
#           min = 1995, max = 2015, value = c(2010,2015))),
#selectizeInput('crimes', 'Violent Crimes Committed', 
#              choices = c('Murder', 'Rape', 'Aggravated Assult', 'Robbery'),
#              multiple = TRUE, options = list(maxItems = 4)),
