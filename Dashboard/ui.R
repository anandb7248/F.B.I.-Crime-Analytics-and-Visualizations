library(shiny)
library(shinydashboard)
library(ggplot2)
library(leaflet)


dashboardPage(
   skin = 'red',
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
                     sliderInput('range', "Range of Years:", min = 1995, max = 2015, value = c(1995,2015))
               ),
               
               box(selectInput('choice', 'Violent Crimes Committed', 
                                      choices = c('Murder'=7, 'Rape'=9, 'Aggravated Assult'=13, 'Robbery'=11))
               )
            ),
               
            fluidRow(
               box(title='Rates of Violent Crime', width = 12, status='primary',
                   plotOutput('LineChart', height = 350))
            )
         ),
            
         # Second tab content
         tabItem(tabName = "Map", h2("Map of United States Using Leaflet"))
         
      )
   )
)
   