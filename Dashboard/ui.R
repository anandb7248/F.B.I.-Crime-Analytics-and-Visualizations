library(shiny)
library(shinydashboard)
library(ggplot2)
library(leaflet)


dashboardPage(
   skin = 'black',
   dashboardHeader(title = "Crime in the U.S."),
   
   dashboardSidebar(
      sidebarMenu(
         menuItem("Line Chart", tabName = "Line_Chart", icon = icon("line-chart")),
         menuItem("Map", tabName = "Map", icon = icon("map"))
      )
   ),
   
   dashboardBody(
      tabItems(
         # First tab content
         tabItem(tabName = "Line_Chart",
            fluidRow(
               box(title = 'Range of Years',
                     sliderInput('range', "Range of Years:", min = 1995, max = 2015, value = c(2010,2015))
               ),
               
               box(selectizeInput('choice', 'Violent Crimes Committed', 
                                      choices = c('Murder'=1, 'Rape'=2, 'Aggravated Assult'=3, 'Robbery'=4),
                                      multiple = TRUE, options = list(maxItems = 4))
               )
            ),
               
            fluidRow(
               column(12,
                      box(title='Rates of Violent Crime', status='danger', solidHeader = TRUE,
                          collapsible = TRUE, plotOutput('LineChart', height = 250))
               )
            )
         ),
            
         # Second tab content
         tabItem(tabName = "Map", h2("Map of United States Using Leaflet"))
         
      )
   )
)
   