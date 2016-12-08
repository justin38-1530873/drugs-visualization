### INFO 201 FINAL PROJECT - DRUG TRAFFICKING
## Ian Figon, Lukas Guericke, Ivan Chub, Ankush Puri

# Importing necessary libraries

library(shiny)
library(plotly)
library(markdown)

# Importing necessary .csv's

summary.data <- read.csv("./data/summary.data.csv", stringsAsFactors = FALSE)  

shinyUI(navbarPage('Drug Distribution from 2011 to 2015',
                   
                   # Tab for Drug Trafficking Routes
          
                    tabPanel('Drug Trafficking Routes',
                             
                             # Sets title
                             
                            titlePanel('Map of Drug Trafficking Routes'),
                            
                            sidebarLayout(
                              
                              # Adds widgets on the side where you can choose a drug and region
                              
                              sidebarPanel(
                                radioButtons('Drug', 'Drug', choices = unique(summary.data$Drug.Name)),
                                selectInput('Region', 'Region', choices = unique(summary.data$Region))
                              ),
                              
                              # Adds map
                              
                              mainPanel(
                                plotOutput("map")
                              )
                            )
                   ), 
                   
                   # Tab for Seized Drug Imports
                   
                   tabPanel('Seized Drug Imports',
                            
                            # Sets title
                            
                            titlePanel('Drug Imports'),
                            
                            sidebarLayout(
                              
                              # Adds widgets that allow you to choose a drug
                              
                              sidebarPanel(
                                selectInput("selectDrug", label = h3("Select drug"), 
                                            choices = list("Heroin" = "Heroin", "Cocaine" = "Cocaine", "Cannabis" = "Cannabis"))                               
                              ),
                              
                              # Adds map
                              
                              mainPanel(
                                plotlyOutput('import.map')
                              )
                            )
                   ),                    
                   
                   # Adds seizures by country tab
                   
                   tabPanel('Seizures by Country',
                            
                            # Sets title
                            
                            titlePanel('Country Statistics'),
                            
                            sidebarLayout(
                              
                              # Adds widgets on the side that allow you to choose origin/destination and drug
                              
                              sidebarPanel(
                                radioButtons('route', 'Place in Route', choices = c("Origin", "Destination")),
                                selectInput('drug_bar_graph', 'Drug', choices = union(c("All"), unique(summary.data$Drug.Name)))
                              ),
                              
                              # Adds plot
                              
                              mainPanel(
                                includeMarkdown("./descriptions/seizures_by_country.md"),
                                plotlyOutput("second_plot")
                              )
                            )
                   ),
                   
                   # Adds Seizures by Date tab
                   
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