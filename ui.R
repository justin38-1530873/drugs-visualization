### INFO 201 FINAL PROJECT - DRUG TRAFFICKING
## Ian Figon, Lukas Guericke, Ivan Chub, Ankush Puri

# Importing necessary libraries

library(shiny)
library(plotly)
library(markdown)

# Importing necessary .csv's

summary.data <- read.csv("./data/summary.data.csv", stringsAsFactors = FALSE)  

shinyUI(navbarPage(theme = "bootstrap.css",
  'Drug Distribution from 2010 to 2015',
                   
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
                              plotOutput("map"),
                              includeMarkdown("./descriptions/drug_trafficking_routes.md")
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
                              selectInput("selectDrug", label = h3("Select Drug"), 
                                          choices = list("Heroin" = "Heroin", "Cocaine" = "Cocaine", "Cannabis" = "Cannabis"))                               
                            ),
                            
                            # Adds map
                            
                            mainPanel(
                              includeMarkdown("./descriptions/seized_drug_imports.md"),
                              plotlyOutput('import.map')
                            )
                          )
                    ),                    
                    
                    # Tab for Seizures by Country
                    
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
                    
                    # Tab for Seizures by Date
                    
                    tabPanel('Seizures by Date',
                    
                          # Sets title
                          
                          titlePanel('Date Statistics'),
                          
                          sidebarLayout(
                          
                            # Adds widgets on the side that allow you to choose a drug
                            
                            sidebarPanel(
                              radioButtons('Drug', 'Drug', choices = unique(summary.data$Drug.Name))
                            ),
                            
                            # Adds plot and description
                            
                            mainPanel(
                              includeMarkdown("./descriptions/seizures_over_time.md"),
                              plotlyOutput("date_plot")
                            )
                          )
                    ),
  
                    # Adds documentation that specifies the purpose of the project and sources
  
                    tabPanel("Documentation",
                             
                             # Panel that contains documentation
                             
                             mainPanel(
                               includeMarkdown("./descriptions/documentation.md")
                             )
                    )
))