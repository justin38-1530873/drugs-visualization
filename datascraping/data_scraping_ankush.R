library(dplyr)

data <- read.csv('./data/2011-2015_Drug_data.csv', stringsAsFactors = FALSE)

known <- filter(data, Seizure.Date != "" & Amount != "")

cannabis.table <- group_by(known, Seizure.Date) %>% filter(Drug.Unit == "Kilogram") %>% filter(Drug.Name == "Cannabis Herb (Marijuana)") %>% summarise(Cannabis = sum(Amount))
cocaine.table <- group_by(known, Seizure.Date) %>% filter(Drug.Unit == "Kilogram") %>% filter(Drug.Name == "Cocaine") %>% summarise(Cocaine = sum(Amount))
heroin.table <- group_by(known, Seizure.Date) %>% filter(Drug.Unit == "Kilogram") %>% filter(Drug.Name == "Heroin") %>% summarise(Heroin = sum(Amount))

drug.table.half <- full_join(cannabis.table, cocaine.table)
drug.table <- full_join(drug.table.half, heroin.table)

write.csv(drug.table, file = "datedata.csv")