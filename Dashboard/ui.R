library(shiny)
library(shinydashboard)
library(ggplot2)
library(leaflet)
library(reshape)


header <- dashboardHeader(
   title = "Crime in the U.S.",
   titleWidth = 350
)
   
sidebar <-   dashboardSidebar(
   sidebarMenu(
   menuItem("Line Chart", tabName = "Line_Chart", icon = icon("line-chart")),
   menuItem("Map", tabName = "Map", icon = icon("map")),
   menuItem("Pie Chart", tabName = "pie_chart", icon = icon("pie-chart")),
   menuItem("University", tabName = "university", icon = icon("university"))
   )
)
   
body <- dashboardBody(
   tabItems(
   # First tab content
      tabItem(tabName = "Line_Chart",
         fluidRow(
            box(title = 'Range of Years',
                sliderInput('range', "Range of Years:", min = 1995, max = 2015, value = c(1995,2015))
            ),
                    
            box(checkboxGroupInput('choice', label = h3("Select Violent Crime to Graph"), 
                                   selected = NULL, choices = c('Murder' = "murder_rate", 'Rape'="rape_rate", 'Aggravated Assult'="assault_rate", 
                                                                'Robbery'="robbery_rate")))
                    
         ),
                 
         fluidRow(
            box(title='Rates of Violent Crime per 100,000 Inhabitants', width = 12, 
                status='primary', plotOutput('LineChart', height = 350))
         )
      ),
         
      # Second tab content
      tabItem(tabName = "Map", h2("Map of United States Using Leaflet"))
   )
)




dashboardPage(
   skin = 'red',
   header,
   sidebar,
   body
)

