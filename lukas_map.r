library(dplyr)
library(ggplot2)
library(ggmap)
library(plotrix)
library(plotly)
library(maps)

setwd("~/GitHub/drugs-visualization")

drug.data <- read.csv('./data/2011-2015_Drug_data.csv', stringsAsFactors = FALSE)

drugs <- c('Cocaine', 'Heroin', 'Cannabis Herb (Marijuana)')

# Filters out big 3
selected.data <- drug.data %>% filter(Drug.Name %in% drugs)

# Filters out unknown origin country and filters to only countries in the Americas
# No unknowns or blanks in Country obtained and Destination country
not.unknown <- filter(cocaine.data, Country.obtained...Departure.Country != "" & Country.obtained...Departure.Country != "Unknown") %>%
  filter(Region == "Americas") %>% 
  filter(Destination.Country != "" & Destination.Country != "Unknown")

# Bolivia's full name was not being recognized by the geocode function 
not.unknown$Country.obtained...Departure.Country <- gsub("Bolivia, Plurinational State of", "Boliva", not.unknown$Country.obtained...Departure.Country)

# Returns a dataframe with the long lat coordinates of each specified country for the countries where the drugs were obtained 
lonlat.country.obtained <- geocode(unique(not.unknown$Country.obtained...Departure.Country)) %>%
  mutate(unique(not.unknown$Country.obtained...Departure.Country))

# Edits column names so that the join will work also for clarity
colnames(lonlat.country.obtained) <- c('long.country.obtained', 'lat.country.obtained', 'Country.obtained...Departure.Country')

# Joins the long lat location with the corresponding counties in our main data set
final.data <- full_join(not.unknown, lonlat.country.obtained, by ='Country.obtained...Departure.Country')

# Returns coordinates of the countries in the Destination Country column 
lonlat.destination.country <- geocode(unique(not.unknown$Destination.Country)) %>%
  mutate(unique(not.unknown$Destination.Country))

colnames(lonlat.destination.country) <- c('long.destination.country', 'lat.destination.country', 'Destination.Country')


# Joins the long lat location with the corresponding counties in our main data set
final.data <- full_join(final.data, lonlat.destination.country, by ='Destination.Country') %>% 
  filter(Country.obtained...Departure.Country != Destination.Country)



# Summary Data 
summary.data <- unique(final.data[, c('Drug.Name','Country.obtained...Departure.Country', 'Destination.Country', 'long.country.obtained','lat.country.obtained','long.destination.country', 'lat.destination.country')])

geo <- list(
  scope = 'americas',
  projection = list(type = 'equirectangular'),
  showland = TRUE,
  landcolor = toRGB("gray95"),
  countrycolor = toRGB("gray80"),
  showcountries =TRUE
)

p <- plot_geo(color = I("red")) %>%
  add_markers(
    data = summary.data, x = ~long.country.obtained, y = ~lat.country.obtained, text = ~Country.obtained...Departure.Country,
    hoverinfo = "text", alpha = 0.5
  ) %>%
  
  add_markers(
    data = summary.data, x = ~long.destination.country, y = ~lat.destination.country, text = ~Destination.Country,
    hoverinfo = "text", alpha = 0.5
  ) %>% 
  add_segments(
    data = group_by(summary.data, Country.obtained...Departure.Country),
    x = ~round(long.country.obtained, digits = 1), xend = ~round(long.destination.country, digits = 1),
    y = ~round(lat.country.obtained, digits = 1), yend = ~round(lat.destination.country, digits = 1),
    alpha = 0.3, size = I(1), hoverinfo = "none"
  ) %>% 
  layout(
    title = 'Cocaine Shipments 2005-2011',
    geo = geo, showlegend = FALSE, height=800
  )

map("world", regions= ".") 
points(x = summary.data$long.country.obtained, y = summary.data$lat.country.obtained, col = "red")
points(x = summary.data$long.destination.country, y = summary.data$lat.destination.country, col = "red")
arrows(x0 = summary.data$long.country.obtained, y0 = summary.data$lat.country.obtained, x = summary.data$long.destination.country, y = summary.data$lat.destination.country, col = "red", lwd = .5)