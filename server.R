library(dplyr)
library(plotly)
library(maps)
library(shiny)


summary.data <- read.csv("summary.data.csv", stringsAsFactors = FALSE)


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
  
})