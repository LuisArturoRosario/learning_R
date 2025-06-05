library(ggplot2)
library(tidyverse)

# WARNING!!!
# BEFORE YOU LOOK AT THIS FILE READ THIS

# I am not a statistician or data scientist, it is almost certain
# that some of these plots are not scientifically valid and that
# is okay. Also, you may see some operations that either are not necessary
# or idiomatic for R lang, that is because I am not a R programmer, I am a Python programmer... lol
# Anyway, I just want you to know that before you continue reading.

nba_dataset <- read_csv("datasets/PlayerIndex_nba_stats.csv")

# convert DRAFT_YEAR into a factor
nba_dataset$DRAFT_YEAR <- as.factor(nba_dataset$DRAFT_YEAR)

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

# Now I'm going to include the position of the players
# and their sample size in the plot so we can visualize the sample size and
# the average height of players drafted each year

nba_dataset %>%
  # Group by DRAFT_YEAR and POSITION
  group_by(DRAFT_YEAR, POSITION) %>%
  # then calculate the mean height and sample size
  summarise(MEAN_HEIGHT = mean(HEIGHT_NUMERIC, na.rm = TRUE),
            n = n() ) %>%
  # then plot the data
  ggplot(aes(x = DRAFT_YEAR, y = MEAN_HEIGHT, color = POSITION)) +
  geom_jitter(aes(size = n), alpha = 0.5) +
  geom_smooth(se = FALSE) +
  labs(
    title = "Average Drafted NBA Player Height by Year and Position", 
    x = "Draft Year", 
    y = "Player Height (feet)",
    size = "Sample Size"
  ) +
  theme_minimal() # Found out this makes the plot look cleaner (:

# Now let me think hmmmmmmmm....
# I want to make each year have its own box plot to show
# the full distribution of player heights drafted each year

nba_dataset %>%
  # apparently using DRAFT_YEAR as a factor will ensure that years
  # are treated as categories instead of continuous values.
  ggplot(aes(x = as.factor(DRAFT_YEAR), y = HEIGHT_NUMERIC)) +
  geom_boxplot(outlier.color = "red") +
  labs(
    title = "Distribution of Player Heights Drafted Each Year", 
    x = "Draft Year", 
    y = "Player Height (feet)"
  ) + theme(axis.text.x = element_text(angle = 90, vjust = 0.5))