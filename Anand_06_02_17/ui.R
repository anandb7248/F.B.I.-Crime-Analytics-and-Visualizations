library(shiny)
library(ggplot2)
library(leaflet)

shinyUI(
  fluidPage(
    tabsetPanel(
        tabPanel('Crime in Time', 
                 sidebarLayout(
                   sidebarPanel(
                     sliderInput("Year", "Range of Years:", 
                                 min = 1995, max = 2015, value = c(1995,2015)),
                     selectInput('choice', 'Violent Crimes Committed', 
                                    choices = c('Rate of Murder'=6, 'Rate of Rape'=10, 'Aggravated Assult'=14, 'Rate of Robbery'=12))
                  ),
                  
                  mainPanel(
                    titlePanel(title = h4('Crime in the United States',align='center')),
                    plotOutput('lineChart')
                  )
               )
      ),
               
      tabPanel('Map of U.S.', 'Contents'),
      
      tabPanel('Visualization', 'Contents')
   )
)
)

#sliderInput("range", "Range of Years:",
#           min = 1995, max = 2015, value = c(2010,2015))),
#selectizeInput('crimes', 'Violent Crimes Committed', 
#              choices = c('Murder', 'Rape', 'Aggravated Assult', 'Robbery'),
#              multiple = TRUE, options = list(maxItems = 4)),
