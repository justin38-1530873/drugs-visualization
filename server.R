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
    Animals <- c("giraffes", "orangutans", "monkeys")
    SF_Zoo <- c(20, 14, 23)
    LA_Zoo <- c(12, 18, 29)
    data <- data.frame(Animals, SF_Zoo, LA_Zoo)
    
    plot_ly(data, x = ~Animals, y = ~SF_Zoo, type = 'bar', name = 'SF Zoo') %>%
      add_trace(y = ~LA_Zoo, name = 'LA Zoo') %>%
      layout(yaxis = list(title = 'Count'), barmode = 'group')
  })
})