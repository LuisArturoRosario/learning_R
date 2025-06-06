library(tidyverse)
library(ggplot2)
library(maps)

covid_data <- read_csv("datasets/country_wise_latest.csv")

world_map <- map_data("world") %>% 
    left_join(covid_data, by = "region")

valid_data <- world_map %>% 
    filter(!is.na(Confirmed) & !is.na(Deaths) & !is.na(Recovered) & !is.na(Active))

ggplot(valid_data, aes(x = long, y = lat, group = group, fill = Confirmed)) +
    geom_polygon(aes(fill = Confirmed), color = "black") +
    labs(title = "Confirmed Cases by Country", fill = "Confirmed")
