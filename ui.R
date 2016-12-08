library(shiny)
library(plotly)
library(markdown)

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
                   
                   tabPanel('Seizures by Country',
                            
                            titlePanel('Country Statistics'),
                            
                            sidebarLayout(
                              
                              sidebarPanel(
                                radioButtons('route', 'Place in Route', choices = c("Origin", "Destination")),
                                selectInput('drug_bar_graph', 'Drug', choices = union(c("All"), unique(summary.data$Drug.Name)))
                              ),
                              
                              mainPanel(
                                includeMarkdown("seizures_by_country.md"),
                                plotlyOutput("second_plot")
                              )
                            )
                   ),
                   
                   tabPanel('Seizures by Date',
                            
                            titlePanel('Date Statistics'),
                            
                            sidebarLayout(
                              
                              sidebarPanel(

                              ),
                              
                              mainPanel(
                                plotlyOutput("date_plot")
                              )
                            )
                   )
))