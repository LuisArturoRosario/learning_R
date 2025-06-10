library(tidyverse)
library(ggplot2)
library(maps)
library(countrycode)

covid_data <- read_csv("datasets/country_wise_latest.csv")

covid_data <- covid_data %>%
  mutate(Standardized_region = countrycode(
    Country,
    origin = "country.name",
    destination = "country.name"
  ))

map_data <- map_data("world") %>%
  mutate(Standardized_region = countrycode(
    region,
    origin = "country.name",
    destination = "country.name"
  ))

world_map <- map_data %>%
  left_join(covid_data, by = "Standardized_region")

valid_data <- world_map %>%
  filter(!is.na(Confirmed) & !is.na(Deaths) & !is.na(Recovered) & !is.na(Active))

covid_19_plot <- ggplot(valid_data, aes(x = long, y = lat, group = group, fill = Confirmed)) +
  geom_polygon(aes(fill = Confirmed), color = "white", alpha = 0.7) +
  labs(title = "Confirmed Cases by Country", fill = "Confirmed") +
  theme_minimal()

covid_19_plot
