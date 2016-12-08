library(dplyr)
library(plotly)
library(maps)
library(shiny)


summary.data <- read.csv("/Users/ivanchub/Projects/drugs-visualization/summary.data.csv", stringsAsFactors = FALSE)


shinyServer(function(input, output) { 

  

  
  output$map <- renderPlot({
   
  #filters data set by drug based on input
   selected.data <- switch (input$Drug,
      "Cocaine" = filter(summary.data, Drug.Name == "Cocaine"),
      "Heroin"= filter(summary.data, Drug.Name == "Heroin"),
      "Cannabis Herb (Marijuana)" = filter(summary.data, Drug.Name == "Cannabis Herb (Marijuana)")
   )
  #filters data based on region
   selected.data <- switch(input$Region, 
    "Europe" = filter(selected.data, Region == "Europe"),
    "Americas" = filter(selected.data, Region == "Americas"),
    "Africa" = filter(selected.data, Region == "Africa"),
    "Asia" = filter(selected.data, Region == "Asia")
    ) 
  #displays map
    map("world", regions= ".", mar = c(.5,.5,.5,.5), namefield = )
 #adds points to map 
      points(x = selected.data$long.country.obtained, y = selected.data$lat.country.obtained, col = "red")
   points(x =  selected.data$long.destination.country, y = selected.data$lat.destination.country, col = "red")
   arrows(x0 = selected.data$long.country.obtained, y0 = selected.data$lat.country.obtained, x1 = selected.data$long.destination.country, y1 = selected.data$lat.destination.country, col = "red", lwd = .4)
  })
  
  output$second_plot <- renderPlotly({
    sorted_by_amount_seized <- summary.data
    
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
    
    sorted_by_amount_seized <- sorted_by_amount_seized %>% 
      summarize(count = n()) %>%
      filter(count > 1) %>%
      arrange(desc(count))
    
    
    
    colnames(sorted_by_amount_seized) <- c("area", "count")
    
    m = list(
      l = 100,
      r = 0,
      b = 300,
      t = 20,
      pad = 0
    )
    
    plot_ly(
      sorted_by_amount_seized, 
      x = ~sorted_by_amount_seized$area, 
      y = ~sorted_by_amount_seized$count, 
      type = 'bar', name = 'Country') %>%
      layout(
        title="",
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
})