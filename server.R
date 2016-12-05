library(dplyr)
library(plotly)
library(maps)
library(shiny)




summary.data <- read.csv('summary.data.csv', stringsAsFactors = FALSE)





shinyServer(function(input, output) { 

  
  
  output$map <- renderPlot({
   
   selected.data <-  reactive({
      if(input$Drug == "Cocaine"){
        selected.data <- filter(summary.data, Drug.Name == "Cocaine")
        return(selected.data)
      }
      if(input$Drug == "Heroin"){
        selected.data <- filter(summary.data, Drug.Name == "Heroin")
        return(selected.data)
      }
      else if(input$Drug == "Cannabis Herb (Marijuana)"){
        selected.data <- filter(summary.data, Drug.Name == "Cannabis Herb (Marijuana)")
        return(selected.data)
      }})
    
   
    
    map("world", regions= ".", mar = c(1,1,1,1)*5) 
    points(x = selected.data$long.country.obtained, y = selected.data$lat.country.obtained, col = "red")
    points(x =  selected.data$long.destination.country, y = selected.data$lat.destination.country, col = "red")
    arrows(x0 = selected.data$long.country.obtained, y0 = selected.data$lat.country.obtained, x1 = selected.data$long.destination.country, y1 = selected.data$lat.destination.country, col = "red", lwd = .5)
  })
  
})