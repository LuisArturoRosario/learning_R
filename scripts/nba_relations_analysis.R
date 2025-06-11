library(tidyverse)
library(ggplot2)
library(plotly)
nba_players <- read_csv("C:\\Users\\amariik\\Documents\\learning_R\\datasets\\NBA_PLAYERS.csv")

filtered_players <- nba_players %>%
  filter(HOF == TRUE | PTS >= 20)

p <- ggplot(nba_players, aes(x = G, y = PTS, text = Name)) +
  geom_point(aes(size = PTS / 100, color = HOF, alpha = 0.6)) + 
  scale_color_manual(values = c("TRUE" = "green", "FALSE" = "red")) + 
  labs(title = "NBA Players PPG compared to Games played",
       x = "Games",
       y = "Points per game") +
  coord_cartesian(xlim = c(400, 1000)) +
  theme_minimal()

ggplotly(p, tooltip = "text")