library(shiny)
library(shinydashboard)
library(ggplot2)
library(leaflet)
library(reshape)


header <- dashboardHeader(
   title = "Crime in the U.S.",
   titleWidth = 250
)
   
sidebar <-   dashboardSidebar(
   sidebarMenu(
   menuItem("Line Chart", tabName = "LineChart", icon = icon("line-chart")),
   menuItem("Map", tabName = "Map", icon = icon("map")),
   menuItem("Pie Chart", tabName = "PieChart", icon = icon("pie-chart")),
   menuItem("University", tabName = "University", icon = icon("university"))
   )
)
   
body <- dashboardBody(
   tabItems(
   # First tab content
      tabItem(tabName = "LineChart", h2('Crime Rate Trends in U.S.', style=('text-align:center;')),
         fluidRow(
            box(title = 'Range of Years',
                sliderInput('range', "Range of Years:", min = 1995, max = 2015, value = c(1995,2015))
            ),
                    
            box(checkboxGroupInput('choice', label = h3("Select Violent Crime to Graph"), 
                                   selected = 'assault_rate', choices = c('Murder' = "murder_rate", 'Rape'="rape_rate", 'Aggravated Assult'="assault_rate", 
                                                                'Robbery'="robbery_rate")))
                    
         ),
                 
         fluidRow(
            box(title='Rates of Violent Crime per 100,000 Inhabitants', width = 12, 
                status='primary', plotOutput('LineChart', height = 350))
         )
      ),
         
      # Second tab content
      tabItem(
         tabName = "Map", 
         h2("Rate of Violent Crime in U.S. per 100,0000", style=('text-align: center;')),
         
         fluidRow(
            column(width = 12,
               box(width = NULL, solidHeader = TRUE, leafletOutput("mymap", height = 500))
            )
         ),
         
         fluidRow(
            box(width = NULL, status = "warning", 
                selectInput("crime", "Select Crime",
                            choices = c("Murder" = 'Murder',"Rape" = 'Rape',
                                        "Assult" = 'Assult',
                                        "Burglary" = 'Burglary'),
                            selected = "Murder")
               )
         )
      ),
      
      #third tab item
      tabItem(
         tabName = 'PieChart',
         h2('Proportion of Violent Crimes per Year', style=('text-align: center;')),
         
         fluidRow(),
         
         fluidRow()
      ),
      
      tabItem(
         tabName = 'University',
         h2('Crime at U.S. Universities', style=('text-align:center;')),
         
         fluidRow(),
         
         fluidRow()
      )
   )
)

dashboardPage(
   skin = 'red',
   header,
   sidebar,
   body
)

