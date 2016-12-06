library(dplyr)
library(ggplot2)
library(ggmap)
library(plotrix)
library(plotly)
library(maps)

setwd("~/GitHub/drugs-visualization")

drug.data <- read.csv('./data/2011-2015_Drug_data.csv', stringsAsFactors = FALSE)


drugs <- c('Cocaine', 'Heroin', 'Cannabis Herb (Marijuana)')
#filters out big 3
selected.data <- drug.data %>%  filter(Drug.Name %in%  drugs )





#filters out unknown origin country and filters to only countries in the americas
#no unknowns or blanks in Country obtained and Destination country 

not.unknown <- filter(selected.data, Country.obtained...Departure.Country != "" & Country.obtained...Departure.Country != "Unknown") %>% 
  filter(Destination.Country != "" & Destination.Country != "Unknown")

#bolivia's full name was not being recognized by the geocode function 
not.unknown$Country.obtained...Departure.Country <- gsub("Bolivia, Plurinational State of", "Boliva", not.unknown$Country.obtained...Departure.Country)

not.unknown$Destination.Country <- gsub("Tanzania, United Republic of", "Tanzania", not.unknown$Destination.Country)

not.unknown$Destination.Country <- gsub("Macedonia, the former Yugoslav Republic of", "Macedonia", not.unknown$Destination.Country)

not.unknown$Destination.Country <- gsub("Kosovo under UNSCR 1244", "Kosovo", not.unknown$Destination.Country)

#returns a dataframe with the long lat coordinates of each specified country for the countries where the drugs were obtained 
lonlat.country.obtained <- geocode(unique(not.unknown$Country.obtained...Departure.Country)) %>%
  mutate(unique(not.unknown$Country.obtained...Departure.Country))

#edits column names so that the join will work also for clarity
colnames(lonlat.country.obtained) <- c('long.country.obtained', 'lat.country.obtained', 'Country.obtained...Departure.Country')

#joins the long lat location with the corresponding counties in our main data set
final.data <- full_join(not.unknown, lonlat.country.obtained, by ='Country.obtained...Departure.Country')

#returns coordinates of the countries in the Destination Country column 
lonlat.destination.country <- geocode(unique(not.unknown$Destination.Country)) %>%
  mutate(unique(not.unknown$Destination.Country))

colnames(lonlat.destination.country) <- c('long.destination.country', 'lat.destination.country', 'Destination.Country')


#joins the long lat location with the corresponding counties in our main data set
final.data <- full_join(final.data, lonlat.destination.country, by ='Destination.Country') %>% 
  filter(Country.obtained...Departure.Country != Destination.Country)


#summarydata 

summary.data <- unique(final.data[, c('Drug.Name', 'Region' ,'Country.obtained...Departure.Country', 'Destination.Country', 'long.country.obtained','lat.country.obtained','long.destination.country', 'lat.destination.country')])

write.csv(summary.data, file = "summary.data.csv")

#amount summmary data
#unit summary data 

kilo.data <- filter(drug.data, Drug.Unit == 'Kilogram')

not.unknown.kilo <- filter(kilo.data, Country.obtained...Departure.Country != "" & Country.obtained...Departure.Country != "Unknown") %>%
  filter(Region == "Americas") %>% 
  filter(Destination.Country != "" & Destination.Country != "Unknown")

group_by(not.unknown.kilo, Country.obtained...Departure.Country, Destination.Country) %>% 
  summarize_each(funs(sum(Amount)))



