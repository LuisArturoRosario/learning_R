library(tidyverse)
library(ggplot2)
library(sf)
library(rnaturalearth)
library(countrycode)
library(rnaturalearthdata)
library(scales)

map_data <- read_csv("datasets/world_data_2023.csv")

# Standardize country names in the map data
map_data <- map_data %>%
  mutate(Country_std = countrycode(Country, origin = 'country.name', destination = 'country.name'))

# Get a world map with geometries
world <- ne_countries(scale = "medium", returnclass = "sf")

# Again, standardize country names in the world map data
world <- world %>%
  mutate(name_std = countrycode(name, origin = 'country.name', destination = 'country.name'))

# Conserve all world data and join it with our map data set
map_merged <- world %>%
  left_join(map_data, by = c("name_std" = "Country_std"))

# Convert the Gasoline Price to numeric after removing the dollar sign
map_merged$`Gasoline Price` <- as.numeric(gsub("[$]", "", map_merged$`Gasoline Price`))

ggplot(map_merged) +
  geom_sf(aes(fill = `Gasoline Price`)) +
  scale_fill_viridis_c(option = "plasma", na.value = "grey90", labels = label_dollar(prefix = "$", accuracy = 0.01)) +
  theme_minimal() +
  labs(title = "Global Gasoline Prices (2023)", fill = "Gasoline Price") +
  theme_minimal()

ggsave("plots/global_gasoline_prices_2023.png")
