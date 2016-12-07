library(shiny)
library(plotly)


#setwd("~/GitHub/drugs-visualization")


#drug.data <- read.csv('./data/2011-2015_Drug_data.csv', stringsAsFactors = FALSE)
summary.data <- read.csv("summary.data.csv", stringsAsFactors = FALSE)  

shinyUI(navbarPage('Drug Distribution from 2011 to 2015',
          
                    tabPanel('Home-Lukas',
                            titlePanel('Map of Drug Trafficking Routes'),
                            
                            sidebarLayout(
                              
                              sidebarPanel(
                                radioButtons('Drug', 'Drug', choices = unique(summary.data$Drug.Name)),
                                selectInput('Region', 'Region', choices = unique(summary.data$Region))
                              ),
                              
                              mainPanel(
                                plotOutput("map")
                              )
                            )
                   ), 
                   
                   tabPanel('Test2',
                            
                            titlePanel('Country Statistics'),
                            
                            sidebarLayout(
                              
                              sidebarPanel(
                                
                              ),
                              
                              mainPanel(
                                plotlyOutput("second_plot")
                              )
                            )
                   )
))