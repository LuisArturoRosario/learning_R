# salary_usd	Annual salary in USD	Integer
# remote_ratio	0 (No remote), 50 (Hybrid), 100 (Fully remote)	Integer

library(ggplot2)
library(tidyverse)
library(scales)

ai_jobs <- read_csv("datasets/ai_jobs_dataset.csv")

get_factor <- function(x) {
  if (x == 0) {
    return("Completely In-Person")
  } else if (x == 50) {
    return("Hybrid")
  } else {
    return("Fully Remote")
  }
}

# convert remote ratio to string equivalent
ai_jobs$remote_ratio <- sapply(ai_jobs$remote_ratio, get_factor)

ai_jobs$salary_usd[is.na(ai_jobs$salary_usd)] <- mean(ai_jobs$salary_usd, na.rm = TRUE) 

# create a new avg salary group with remote ratio and avg salary in USD (might be a better way to do it idk)
avg_salary <- ai_jobs %>%
  group_by(remote_ratio) %>%
  summarise(avg_salary_usd = mean(salary_usd))

ai_plot <- ggplot(avg_salary, aes(x = remote_ratio, y = avg_salary_usd, fill = remote_ratio)) +
  geom_col(show.legend = FALSE) +
  scale_y_continuous(labels = dollar) +
  labs(
    title = "AI Job Remote Ratio vs. Average Salary in USD",
    subtitle = "Does working remotely for AI jobs make you more money?",
    x = "Remote Ratio", 
    y = "Average Salary (USD)"
  ) +
  coord_cartesian(ylim = c(112000, 117000)) +
  theme_minimal()

ai_plot