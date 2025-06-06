library(tidyverse)
library(ggplot2)
library(sf)
library(rnaturalearth)
library(countrycode))
library(rnaturalearthdata)

map_data <- read_csv("datasets/world_data_2023.csv")

map_data <- map_data %>%
  mutate(Country_std = countrycode(Country, origin = 'country.name', destination = 'country.name')

# Get a world map with geometries
world <- ne_countries(scale = "medium", returnclass = "sf")

# Join your gasoline data by country name
map_merged <- world %>%
  left_join(world_map_data, by = c("name" = "Country"))

map_merged$`Gasoline Price` <- as.numeric(gsub("[$]", "", map_merged$`Gasoline Price`))

# Plot it
ggplot(map_merged) +
  geom_sf(aes(fill = `Gasoline Price`)) +
  scale_fill_viridis_c(option = "plasma", na.value = "grey90") +
  theme_minimal() +
  labs(title = "Global Gasoline Prices", fill = "Gasoline Price")