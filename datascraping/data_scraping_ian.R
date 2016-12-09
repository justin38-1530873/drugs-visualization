library(dplyr)

country.codes <- read.csv('https://raw.githubusercontent.com/plotly/datasets/master/2014_world_gdp_with_codes.csv', stringsAsFactors = FALSE)  
country.codes$GDP..BILLIONS. <- NULL

data <- read.csv('./data/2011-2015_Drug_data.csv', stringsAsFactors = FALSE)

not.unknown <- filter(data, Destination.Country != "" & Destination.Country != "Unknown")

summary.table1 <- group_by(not.unknown, Destination.Country) %>% filter(Drug.Unit == "Kilogram") %>% filter(Drug.Name == "Cannabis Herb (Marijuana)") %>% summarise(Cannabis = sum(Amount))
summary.table2 <- group_by(not.unknown, Destination.Country) %>% filter(Drug.Unit == "Kilogram") %>% filter(Drug.Name == "Cocaine") %>% summarise(Cocaine = sum(Amount))
summary.table3 <- group_by(not.unknown, Destination.Country) %>% filter(Drug.Unit == "Kilogram") %>% filter(Drug.Name == "Heroin") %>% summarise(Heroin = sum(Amount))

summary.table.half <- full_join(summary.table1, summary.table2)
summary.table <- full_join(summary.table.half, summary.table3)


summary.table$Destination.Country <- gsub( "Gambia" ,"Gambia, The", summary.table$Destination.Country)
summary.table$Destination.Country <- gsub( "Iran, Islamic Republic of", "Iran", summary.table$Destination.Country)
summary.table$Destination.Country <- gsub( "Iraq (Kurdistan Region)", "Iraq", summary.table$Destination.Country)
summary.table$Destination.Country <- gsub( "Lao Peoples Democratic Republic", "Laos", summary.table$Destination.Country)
summary.table$Destination.Country <- gsub( "Russian Federation", "Russia", summary.table$Destination.Country)
summary.table$Destination.Country <- gsub( "Syrian Arab Republic", "Syria", summary.table$Destination.Country)
summary.table$Destination.Country <- gsub( "Tanzania, United Republic of", "Tanzania", summary.table$Destination.Country)
summary.table$Destination.Country <- gsub( "Viet Nam", "Vietnam", summary.table$Destination.Country)

summary.table <- filter(summary.table, Destination.Country %in% country.codes$COUNTRY)

country.codes <- filter(country.codes, COUNTRY %in% summary.table$Destination.Country)

colnames(country.codes) <- c("Destination.Country", "code")

summary.table <- full_join(summary.table, country.codes)

write.csv(summary.table, file = "importdata.csv")