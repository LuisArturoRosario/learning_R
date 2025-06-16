# world_map_analysis.R
# Author: Luis Arturo Rosario Alers
# Date Created: 2025-06-06
# Last Modified: 2025-06-06
# Description: Visualizes world data using maps.
# Dependencies: tidyverse, ggplot2, sf, rnaturalearth, countrycode, rnaturalearthdata, scales, ggtext
# Inputs: datasets/world_data_2023.csv
# Outputs: plots/global_gasoline_prices_2023.png
# License: MIT
# Source: https://github.com/LuisArturoRosario/learning_R
#
# See LICENSE file for details

library(tidyverse)
library(ggplot2)
library(sf)
library(rnaturalearth)
library(countrycode)
library(rnaturalearthdata)
library(scales)
library(ggtext)

map_data <- read_csv("datasets/world_data_2023.csv")

# Standardize country names in the map data
map_data <- map_data %>%
  mutate(Country_std = countrycode(Country, origin = "country.name", destination = "country.name"))

# Get a world map with geometries
world <- ne_countries(scale = "medium", returnclass = "sf")

# Again, standardize country names in the world map data
world <- world %>%
  mutate(name_std = countrycode(name, origin = "country.name", destination = "country.name"))

# Conserve all world data and join it with our map data set
map_merged <- world %>%
  left_join(map_data, by = c("name_std" = "Country_std"))

# Convert the Gasoline Price to numeric after removing the dollar sign
map_merged$`Gasoline Price` <- as.numeric(gsub("[$]", "", map_merged$`Gasoline Price`))

# Don't worry about this, its just the caption for the plot.
caption_text <- "Data source: <b>Nidula Elgiriyewithana</b> (2023). Global Country Information Dataset 2023 [Data set]. Kaggle. doi: 10.34740/KAGGLE/DSV/6101670 | Visualization by <b><i>Luis Rosario</i></b>"

ggplot(map_merged) +
  geom_sf(aes(fill = `Gasoline Price`)) +
  scale_fill_viridis_c(option = "plasma", na.value = "grey90", labels = label_dollar(prefix = "$", accuracy = 0.01)) +
  theme_minimal() +
  labs(
    title = "Global Gasoline Prices (2023)", fill = "Gasoline Price (Per Liter) ",
    caption = caption_text
  ) +
  theme(
    plot.title = element_text(hjust = 0.5, size = 16, face = "bold"),
    plot.caption = ggtext::element_markdown(hjust = 0.5, size = 8),
  )

ggsave("plots/global_gasoline_prices_2023.png")
