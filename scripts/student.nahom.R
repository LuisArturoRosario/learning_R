library(ggplot2)
library(tidyverse)

data <- read_csv("C:\\Users\\clester\\Documents\\Code Projects\\learning_R\\datasets\\student_habits_performance.csv")

new_score <-data %>%
  group_by(social_media_hours) %>%
  summarise(exam_scores = mean(exam_score))

social_media_plot <- ggplot(new_score, aes(x = social_media_hours, y = exam_scores)) +
  geom_col() +
  geom_smooth(method = "lm", se = FALSE) +
  labs(
    title = "Does Social Media time affect exam scores?",
    x = 'Socai Media time (Hours Per Day)',
    y = 'Exam Socres'
  ) + 
  coord_cartesian(ylim = c(0, 100))

social_media_plot