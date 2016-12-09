### INFO 201 FINAL PROJECT - DRUG TRAFFICKING
## Ian Figon, Lukas Guericke, Ivan Chub, Ankush Puri

# Importing necessary libraries

library(dplyr)
library(plotly)
library(maps)
library(shiny)

# Importing necessary .csv's

summary.data <- read.csv("./data/summary.data.csv", stringsAsFactors = FALSE)
import.data <- read.csv('./data/importdata.csv', stringsAsFactors = FALSE)

shinyServer(function(input, output) { 

  # Map for Drug Trafficking Routes tab
  
  output$map <- renderPlot( {
   
  # Filters data set by drug based on input
    
  selected.data <- switch (input$Drug,
    "Cocaine" = filter(summary.data, Drug.Name == "Cocaine"),
    "Heroin"= filter(summary.data, Drug.Name == "Heroin"),
    "Cannabis Herb (Marijuana)" = filter(summary.data, Drug.Name == "Cannabis Herb (Marijuana)")
  )
   
  # Filters data based on region
   
  selected.data <- switch(input$Region, 
    "Europe" = filter(selected.data, Region == "Europe"),
    "Americas" = filter(selected.data, Region == "Americas"),
    "Africa" = filter(selected.data, Region == "Africa"),
    "Asia" = filter(selected.data, Region == "Asia")
  ) 
   
  # Displays map
   
  map("world", regions= ".", mar = c(.5,.5,.5,.5), namefield = )
    
  # Adds points to map
    
  points(x = selected.data$long.country.obtained, y = selected.data$lat.country.obtained, col = "red")
  points(x =  selected.data$long.destination.country, y = selected.data$lat.destination.country, col = "red")
  arrows(x0 = selected.data$long.country.obtained, y0 = selected.data$lat.country.obtained, x1 = selected.data$long.destination.country, y1 = selected.data$lat.destination.country, col = "red", lwd = .4)
  } )
  
  
  # Plot for Seizures by Country tab
  
  # Plot for Seizures by Country tab
  
  output$second_plot <- renderPlotly({
    sorted_by_amount_seized <- summary.data
    
    # Sets up data from widgets
    
    if (input$drug_bar_graph != "All") {
      sorted_by_amount_seized <- sorted_by_amount_seized %>% filter(Drug.Name == input$drug_bar_graph)
    }
    
    if (input$route == "Origin") {
      sorted_by_amount_seized <- 
        group_by(sorted_by_amount_seized, Country.obtained...Departure.Country)
    } else {
      sorted_by_amount_seized <- 
        group_by(sorted_by_amount_seized, Destination.Country)
    }
    
    # Formats and arranges data
    
    sorted_by_amount_seized <- sorted_by_amount_seized %>% 
      summarize(count = n()) %>%
      filter(count > 1) %>%
      arrange(desc(count))
    
    
    
    colnames(sorted_by_amount_seized) <- c("area", "count")
    
    # Builds plot basics
    
    m = list(
      l = 100,
      r = 0,
      b = 300,
      t = 50,
      pad = 0
    )
    
    # Creates plot
    
    plot_ly(
      sorted_by_amount_seized, 
      x = ~sorted_by_amount_seized$area, 
      y = ~sorted_by_amount_seized$count, 
      type = 'bar', name = 'Country') %>%
      
      # Layout of plot
      
      layout(
        title="Drug Seizures by Country",
        yaxis = list(title = 'Amout of Seizures'), 
        barmode = 'group',
        xaxis = list(categoryarray = count, categoryorder = "array", title = "Country"),
        autosize = F,
        height= 800,
        margin = m)
  })
  
   output$date_plot <- renderPlotly({
    summary.data
  })
  
  
  # Map for Seized Drug Imports tab
  
  output$import.map <- renderPlotly( { 
    
    # Light grey boundaries
    
    l <- list(color = toRGB("grey"), width = 0.5)
    
    # Specify map projection/options
    
    g <- list(
      showframe = FALSE,
      showcoastlines = FALSE,
      projection = list(type = 'Mercator')
    )
    
    # Creates necessary string for widget to work
    
    eq <- paste0("~", input$selectDrug)
    
    # Creates the map
    
    p <- plot_geo(import.data) %>%
      
      # Sets the map setting including color and data
      
      add_trace(
        z = eval(parse(text = eq)), color = eval(parse(text = eq)), colors = 'Reds',
        text = ~Destination.Country, locations = ~code, marker = list(line = 1)
      ) %>%
      colorbar(title = 'Drug Seizures (in kg)') %>%
      layout(
        title = 'International Drug Imports',
        geo = g
      )
    
    # Returns map
    
    return(p)
  })
  
  # Plot for Drug Seizures over Time tab
  
  output$date_plot <- renderPlotly( {
    
    
    
    
    
    
    
    
  } )  
})