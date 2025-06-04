# job_id	Unique identifier for each job posting	String
# job_title	Standardized job title	String
# salary_usd	Annual salary in USD	Integer
# salary_currency	Original salary currency	String
# salary_local	Salary in local currency	Float
# experience_level	EN (Entry), MI (Mid), SE (Senior), EX (Executive)	String
# employment_type	FT (Full-time), PT (Part-time), CT (Contract), FL (Freelance)	String
# job_category	ML Engineer, Data Scientist, AI Researcher, etc.	String
# company_location	Country where company is located	String
# company_size	S (Small <50), M (Medium 50-250), L (Large >250)	String
# employee_residence	Country where employee resides	String
# remote_ratio	0 (No remote), 50 (Hybrid), 100 (Fully remote)	Integer
# required_skills	Top 5 required skills (comma-separated)	String
# education_required	Minimum education requirement	String
# years_experience	Required years of experience	Integer
# industry	Industry sector of the company	String
# posting_date	Date when job was posted	Date
# application_deadline	Application deadline	Date
# job_description_length	Character count of job description	Integer
# benefits_score	Numerical score of benefits package (1-10)	Float

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

ai_jobs$remote_ratio <- sapply(ai_jobs$remote_ratio, get_factor)

ai_jobs$salary_usd[is.na(ai_jobs$salary_usd)] <- mean(ai_jobs$salary_usd, na.rm = TRUE) 

avg_salary <- ai_jobs %>%
  group_by(remote_ratio) %>%
  summarise(avg_salary_usd = mean(salary_usd))

ggplot(avg_salary, aes(x = remote_ratio, y = avg_salary_usd)) +
  geom_col(fill = "red", show.legend = FALSE) +
  scale_y_continuous(labels = dollar) +
  labs(
    title = "AI Job Remote Ratio vs. Average Salary in USD",
    subtitle = "Does working remotely for AI jobs make you more money?",
    x = "Remote Ratio", 
    y = "Average Salary (USD)"
  ) +
  coord_cartesian(ylim = c(90000, 115000)) +
  theme_minimal()
