### INFO 201 FINAL PROJECT - DRUG TRAFFICKING
## Ian Figon, Lukas Guericke, Ivan Chub, Ankush Puri

# Importing necessary libraries

library(dplyr)
library(plotly)
library(maps)
library(shiny)

# Importing necessary .csv's

summary.data <- read.csv('./data/summary.data.csv', stringsAsFactors = FALSE)
import.data <- read.csv('./data/importdata.csv', stringsAsFactors = FALSE)
date.data <- read.csv('./data/datedata.csv', stringsAsFactors = FALSE)

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
  
  output$second_plot <- renderPlotly( {
    sorted_by_amount_seized <- summary.data
    
    # Sorts data depending on widget
    
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
    
    # Formats and arranges data for plot
    
    sorted_by_amount_seized <- sorted_by_amount_seized %>% 
      summarize(count = n()) %>%
      filter(count > 1) %>%
      arrange(desc(count))
    
    # Names columns
    
    colnames(sorted_by_amount_seized) <- c("area", "count")
    
    # Sets up plot dimensions
    
    m = list(
      l = 100,
      r = 0,
      b = 300,
      t = 50,
      pad = 0
    )
    
    # Renders plot
    
    plot_ly(
      sorted_by_amount_seized, 
      x = ~sorted_by_amount_seized$area, 
      y = ~sorted_by_amount_seized$count, 
      type = 'bar', name = 'Country') %>%
      
      # Sets layout of plot
      
      layout(
        title="Drug Seizures by Country",
        yaxis = list(title = 'Amount of Seizures'), 
        barmode = 'group',
        xaxis = list(categoryarray = count, categoryorder = "array", title = "Country"),
        autosize = F,
        height= 800,
        margin = m)
  } )
  
  
  # Plot for Drug Seizures over Time tab
  
  output$date_plot <- renderPlotly( {
    
    seized_over_time <- date.data
    
    # Months for x-axis
    
    months <- c('January', 'February', 'March', 'April', 'May', 'June', 'July',
                'August', 'September', 'October', 'November', 'December')
    
    # Sums of data seizures by month by year
    
    sums.cannabis.2010 <- c(183871, 305306, 487481, 51007, 103311,
                            41159, 30375, 70956, 38073, 98220, 97359,
                            9138)
    sums.cocaine.2010 <- c(7320, 4833, 4653, 12737, 4690, 4437,
                           11979, 6459, 4778, 4670, 2007, 4627)
    sums.heroin.2010 <- c(387, 578, 537, 599, 814, 829, 832, 419,
                          494, 347, 1053, 392)
    
    sums.cannabis.2013 <- c(50859, 51443, 66260, 128642, 219515,
                            77287, 66495, 72860, 94984, 72297,
                            50686, 28765)
    sums.cocaine.2013 <- c(17168, 12152, 36825, 21450, 19286, 12763,
                           15274, 19007, 15621, 30169, 20213, 9448)
    sums.heroin.2013 <- c(2073, 2312, 978, 787, 609, 1276, 766, 712,
                          328, 1262, 1427, 958)
    
    sums.cannabis.2014 <- c(32141, 71172, 41745, 49814, 68564, 30750,
                            37945, 31094, 41940, 23746, 82776, 22834)
    sums.cocaine.2014 <- c(12848, 19854, 21002, 31881, 18552, 22874,
                           20688, 11750, 19037, 13058, 15378, 16087)
    sums.heroin.2014 <- c(1430, 310, 370, 1744, 803, 557, 248, 208,
                          238, 642, 753, 1368)
    
    sums.cannabis.2015 <- c(1828, 1475, 1262, 48773, 2309, 893, 1620,
                            298, 854, 428, 115, 757)
    sums.cocaine.2015 <- c(339, 153, 182, 163, 1187, 117, 539, 3347,
                           444, 68, 43, 298)
    sums.heroin.2015 <- c(1897, 1184, 308, 1244, 252, 2030, 1147, 654,
                          3145, 978, 218, 128)
    
    # Series of 'if' statements to determine which data set to use for
    # sums of drug seizures organized by month by year
    
    if (input$Year = "2010") {
      if (input$Drug = "Cannabis") {
        seized_over_time <- sums.cannabis.2010
      } else if (input$Drug == "Cocaine") {
        seized_over_time <- sums.cocaine.2010
      } else {
        seized_over_time <- sums.heroin.2010
      }
    } else if (input$Year = "2013") {
      if (input$Drug = "Cannabis") {
        seized_over_time <- sums.cannabis.2013
      } else if (input$Drug = "Cocaine") {
        seized_over_time <- sums.cocaine.2013
      } else {
        seized_over_time <- sums.heroin.2013
      }
    } else if (input$Year = "2014") {
      if (input$Drug = "Cannabis") {
        seized_over_time <- sums.cannabis.2014
      } else if (input$Drug = "Cocaine") {
        seized_over_time <- sums.cocaine.2014
      } else {
        seized_over_time <- sums.heroin.2014
      }
    } else {
      if (input$Drug = "Cannabis") {
        seized_over_time <- sums.cannabis.2015
      } else if (input$Drug = "Cocaine") {
        seized_over_time <- sums.cocaine.2015
      } else {
        seized_over_time <- sums.heroin.2015
      }
    }
    
    # Final data set to be used
    
    seized_over_time_final <- data.frame(month, seized_over_time)
    
    # Maintain order of months
    
    seized_over_time$month <- factor(data$month, levels = data[["month"]])
    
    # Renders the plot
    
    p <- plot_ly(seized_over_time_final, x = ~month, y = seized_over_time,
                 name = 'Selected Year and Drug Plot', type = 'scatter',
                 mode = 'lines', line = list(color = 'rgb(255, 0, 0)', width = 4)) %>%
      
      # Sets the layout of the plot
      
      layout(title = "Seizures of Drugs over Time",
             xaxis = list(title = "Months"),
             yaxis = list(title = "Amount of Drugs Seized (kg)"))
    
  } )
  
  
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
      colorbar(title = 'Amount Seized (in kg)') %>%
      layout(
        title = 'International Drug Imports',
        geo = g
      )
    
    # Returns map
    
    return(p)
  } )

})