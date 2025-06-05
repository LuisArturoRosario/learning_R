library(ggplot2)
library(tidyverse)


data <- read_csv("datasets/personality_dataset.csv")

spec(data)

# Clean up the data to replace NULL values, with the mean of the column 
# (I have no idea if this is good interpolation of missing data...)

data$Time_spent_Alone[is.na(data$Time_spent_Alone)] <- 
  mean(data$Time_spent_Alone, na.rm = TRUE)
data$Friends_circle_size[is.na(data$Friends_circle_size)] <- 
  mean(data$Friends_circle_size, na.rm = TRUE)

ggplot(data, aes(x = Time_spent_Alone, y = Friends_circle_size)) +
  geom_jitter() +
  geom_smooth(method = "lm") +
  labs(
    title = "The Relationship between talking to people vs Friend Circle Size", 
    x = "time spent alone (in hours)", 
    y = "Friend circle size"
  )
