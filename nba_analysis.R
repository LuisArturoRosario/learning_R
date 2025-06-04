library(ggplot2)
library(tidyverse)
library(dplyr)

nba_dataset <- read_csv("datasets/PlayerIndex_nba_stats.csv")

# Here I clean my data of NULL values and instead replace them with the mean of the column
nba_dataset$HEIGHT[is.na(nba_dataset$HEIGHT)] <- 
  mean(nba_dataset$HEIGHT, na.rm = TRUE)
nba_dataset$DRAFT_YEAR[is.na(nba_dataset$DRAFT_YEAR)] <- 
  mean(nba_dataset$DRAFT_YEAR, na.rm = TRUE)

# I convert the HEIGHT column from a string format (e.g., "6-7") to a numeric format (e.g., 6.58 feet)
nba_dataset$HEIGHT_NUMERIC <- sapply(nba_dataset$HEIGHT, function(x) {
  split_height <- strsplit(x, "-")[[1]]
  feet <- as.numeric(split_height[1])
  inches <- as.numeric(split_height[2])
  
  return(feet + inches / 12)
})

# Then I go here and make a new data frame with the mean height of the players drafted each year
mean_height <- nba_dataset %>%
  group_by(DRAFT_YEAR) %>%
  summarise(HEIGHT = mean(HEIGHT_NUMERIC, na.rm = TRUE))

# Finally, I use ggplot to plot the DRAFT_YEAR against HEIGHT
ggplot(mean_height, aes(x = DRAFT_YEAR, y = HEIGHT)) +
  geom_jitter() +
  geom_smooth() +
  labs(
    title = "Average Drafted NBA Player Height by Year", 
    x = "Draft Year", 
    y = "Player Height (feet)"
  )