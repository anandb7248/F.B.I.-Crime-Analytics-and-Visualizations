library(shiny)
library(shinydashboard)
library(ggplot2)
library(leaflet)
library(reshape)

header <- dashboardHeader(
            title = "Crime in the U.S.",
            titleWidth = 400
         )
  
sidebar <- dashboardSidebar(
               width = 200,
               sidebarMenu(
                  menuItem("Line_Chart", tabName = "Line_Chart", icon = icon("line-chart")),
                  menuItem("Map", tabName = "Map", icon = icon("map")),
                  menuItem('Pie_Chart', tabName="Pie_Chart", icon=icon("pie-chart")),
                  menuItem("University", tabName="University", icon=icon("university"))
               )
            )
   
body <- dashboardBody(
         tags$head(
            #tags$link(rel = "stylesheet", type = "text/css", href = "bootstrap.css"),
            tags$link(rel = "stylesheet", type = "text/css", href = "custom.css"),
            tags$link(rel = 'stylesheet', href="http://fonts.googleapis.com/css?family=Open+Sans"),
            tags$link(rel = 'stylesheet', href="https://fonts.googleapis.com/css?family=Montserrat")
         
         ),
     
         tabItems(
            # First tab content
            tabItem(tabName = "Line_Chart",
                    fluidRow(
                        box(tags$p(title = 'Range of Years', style="font-family: Georgia, Times, Times New Roman, serif;"),
                        sliderInput('range', "Range of Years:", min = 1995, max = 2015, value = c(1995,2015))
                        ),
              
                        box(checkboxGroupInput('choice', label = h3("Select Violent Crime to Graph"), 
                                               selected = NULL, choices = c('Murder' = "murder_rate", 'Rape'="rape_rate", 
                                                                            'Aggravated Assult'="assault_rate", 
                                                                            'Robbery'="robbery_rate")))
                     ),
                    
                    fluidRow(
                       column(width = 4, align='left', height='200px',
                              tags$a('Violent Crime Rate Data',
                                     href="https://ucr.fbi.gov/crime-in-the-u.s/2015/crime-in-the-u.s.-2015/tables/table-1"))
                    ),
               
                     fluidRow(
                        box(title='Rates of Violent Crime per 100,000 Inhabitants', width = 12, 
                        status='primary', plotOutput('LineChart', height = 350))
                     )
                    
            ),
         
            # Second tab content
            tabItem(tabName = "Map",
                    fluidRow(
                       column(width = 8, align="center", offset = 2,
                              h2("Map of U.S."), tags$style(type="text/css", 
                                                            "#string { height: 50px; width: 100%; text-align:center; font-size: 
                                                            30px; display: block;}")
                        )
                     ),
                 
                     fluidRow(),
                    
                     fluidRow()
            ),       
         
            tabItem(tabName = "Pie_Chart", h2('This is where content goes!')),
         
            tabItem(tabName = "University", h2("This is where content goes!"))
         
         )#ends tabItems
      )
   



dashboardPage(
   skin = 'red',
   header, 
   sidebar, 
   body
)


