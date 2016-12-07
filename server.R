library(dplyr)
library(plotly)
library(maps)
library(shiny)


summary.data <- read.csv("summary.data.csv", stringsAsFactors = FALSE)


shinyServer(function(input, output) { 

  

  
  output$map <- renderPlot({
   
  
   selected.data <- switch (input$Drug,
      "Cocaine" = filter(summary.data, Drug.Name == "Cocaine"),
      "Heroin"= filter(summary.data, Drug.Name == "Heroin"),
      "Cannabis Herb (Marijuana)" = filter(summary.data, Drug.Name == "Cannabis Herb (Marijuana)")
   )
  
   selected.data <- switch(input$Region, 
    "Europe" = filter(selected.data, Region == "Europe"),
    "Americas" = filter(selected.data, Region == "Americas"),
    "Africa" = filter(selected.data, Region == "Africa"),
    "Asia" = filter(selected.data, Region == "Asia")
    ) 
  
    map("world", regions= ".", mar = c(.5,.5,.5,.5), namefield = )
   points(x = selected.data$long.country.obtained, y = selected.data$lat.country.obtained, col = "red")
   points(x =  selected.data$long.destination.country, y = selected.data$lat.destination.country, col = "red")
   arrows(x0 = selected.data$long.country.obtained, y0 = selected.data$lat.country.obtained, x1 = selected.data$long.destination.country, y1 = selected.data$lat.destination.country, col = "red", lwd = .4)
  })
  
  
  
  output$second_plot <- renderPlotly({
    if (input$route == "Origin") {
      sorted_by_amount_seized <- 
        group_by(summary.data, Country.obtained...Departure.Country)
    } else {
      sorted_by_amount_seized <- 
        group_by(summary.data, Destination.Country)
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
})