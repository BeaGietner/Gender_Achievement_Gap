# Junior Cert

data_high_income_W2 <- Oaxaca_Blinder[Oaxaca_Blinder$Income_Quin_Eq_W2 %in% c(4, 5), ]
data_low_income_W2 <- Oaxaca_Blinder[Oaxaca_Blinder$Income_Quin_Eq_W2 %in% c(1, 2, 3), ]
data_high_educ_PCG_W2 <- Oaxaca_Blinder[Oaxaca_Blinder$PCG_Educ_W2 %in% c(5, 6), ]
data_low_educ_PCG_W2 <- Oaxaca_Blinder[Oaxaca_Blinder$PCG_Educ_W2 %in% c(1, 2, 3, 4), ]
data_high_educ_SCG_W2 <- Oaxaca_Blinder[Oaxaca_Blinder$SCG_Educ_W2 %in% c(5, 6), ]
data_low_educ_SCG_W2 <- Oaxaca_Blinder[Oaxaca_Blinder$SCG_Educ_W2 %in% c(1, 2, 3, 4), ]

# Function to calculate mean points by gender
calculate_means_JC <- function(data) {
  aggregate(cbind(JC_Maths_Points, JC_English_Points) ~ Gender_YP_W2, data, mean)
}

# Apply the function to each dataset
means_high_income_W2 <- calculate_means_JC(data_high_income_W2)
means_low_income_W2 <- calculate_means_JC(data_low_income_W2)
means_high_educ_PCG_W2 <- calculate_means_JC(data_high_educ_PCG_W2)
means_low_educ_PCG_W2 <- calculate_means_JC(data_low_educ_PCG_W2)
means_high_educ_SCG_W2 <- calculate_means_JC(data_high_educ_SCG_W2)
means_low_educ_SCG_W2 <- calculate_means_JC(data_low_educ_SCG_W2)

# Function to calculate the gender gap
calculate_gender_gap_JC <- function(means) {
  female_means_JC <- means[means$Gender_YP_W2 == 0, ]
  male_means_JC <- means[means$Gender_YP_W2 == 1, ]
  
  data.frame(
    Maths_Gap_JC = male_means_JC$JC_Maths_Points - female_means_JC$JC_Maths_Points,
    English_Gap_JC = male_means_JC$JC_English_Points - female_means_JC$JC_English_Points
  )
}

# Apply the function to each mean dataset
gender_gap_high_income_W2 <- calculate_gender_gap_JC(means_high_income_W2)
gender_gap_low_income_W2 <- calculate_gender_gap_JC(means_low_income_W2)
gender_gap_high_educ_PCG_W2 <- calculate_gender_gap_JC(means_high_educ_PCG_W2)
gender_gap_low_educ_PCG_W2 <- calculate_gender_gap_JC(means_low_educ_PCG_W2)
gender_gap_high_educ_SCG_W2 <- calculate_gender_gap_JC(means_high_educ_SCG_W2)
gender_gap_low_educ_SCG_W2 <- calculate_gender_gap_JC(means_low_educ_SCG_W2)

# Combine all gender gap results into one data frame
gender_gaps_JC <- bind_rows(
  tibble(Subgroup = "High Income", gender_gap_high_income_W2),
  tibble(Subgroup = "Low Income", gender_gap_low_income_W2),
  tibble(Subgroup = "High Educ PCG", gender_gap_high_educ_PCG_W2),
  tibble(Subgroup = "Low Educ PCG", gender_gap_low_educ_PCG_W2),
  tibble(Subgroup = "High Educ SCG", gender_gap_high_educ_SCG_W2),
  tibble(Subgroup = "Low Educ SCG", gender_gap_low_educ_SCG_W2)
)

library(ggplot2)

# Reshape the data for plotting
gender_gaps_long_JC <- gender_gaps_JC %>%
  pivot_longer(cols = c(Maths_Gap_JC, English_Gap_JC), names_to = "Subject", values_to = "Gap")

# Combine gender gap data into a single data frame
gender_gap_data_JC <- bind_rows(
  data.frame(Subgroup = "High Income", gender_gap_high_income_W2),
  data.frame(Subgroup = "Low Income", gender_gap_low_income_W2),
  data.frame(Subgroup = "High Education PCG", gender_gap_high_educ_PCG_W2),
  data.frame(Subgroup = "Low Education PCG", gender_gap_low_educ_PCG_W2),
  data.frame(Subgroup = "High Education SCG", gender_gap_high_educ_SCG_W2),
  data.frame(Subgroup = "Low Education SCG", gender_gap_low_educ_SCG_W2)
)

# Invert the gap values for each subject
gender_gap_data_inverted_JC <- gender_gap_data_JC %>%
  pivot_longer(cols = c(Maths_Gap_JC, English_Gap_JC), names_to = "Subject", values_to = "Gap") %>%
  mutate(Gap = ifelse(Subject == "Maths_Gap_JC", -Gap, -Gap))  

# Check the prepared data
head(gender_gap_data_inverted_JC)

ggplot(gender_gap_data_inverted_JC, aes(x = Subgroup, y = Gap, color = Subject, group = Subject)) +
  geom_point(size = 3, position = position_dodge(width = 0.0)) +  
  geom_hline(yintercept = 0, linetype = "dashed", color = "gray") +  
  labs(title = "Gender Achievement Gap by Group and Subject - Junior Cert",
       x = "Group", y = "Gender Achievement Gap (Girls - Boys)",
       caption = "Low income = 1st, 2nd and 3rd quintile (equiv.), High income = 4th and 5th quintile (equiv.).\nLow education = Primary/Secondary caregiver with less than a Bachelor's degree, \nHigh education = Primary/Secondary caregiver with a Bachelor's degree or higher.") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))



# Leaving Cert

data_high_income_W3 <- Oaxaca_Blinder[Oaxaca_Blinder$Income_Quin_Eq_W3 %in% c(4, 5), ]
data_low_income_W3 <- Oaxaca_Blinder[Oaxaca_Blinder$Income_Quin_Eq_W3 %in% c(1, 2, 3), ]
data_high_educ_PCG_W3 <- Oaxaca_Blinder[Oaxaca_Blinder$PCG_Educ_W3 %in% c(5, 6), ]
data_low_educ_PCG_W3 <- Oaxaca_Blinder[Oaxaca_Blinder$PCG_Educ_W3 %in% c(1, 2, 3, 4), ]
data_high_educ_SCG_W3 <- Oaxaca_Blinder[Oaxaca_Blinder$SCG_Educ_W3 %in% c(5, 6), ]
data_low_educ_SCG_W3 <- Oaxaca_Blinder[Oaxaca_Blinder$SCG_Educ_W3 %in% c(1, 2, 3, 4), ]

# Function to calculate mean points by gender
calculate_means_LC <- function(data) {
  aggregate(cbind(LC_Maths_Points, LC_English_Points) ~ Gender_YP_W3, data, mean)
}

# Apply the function to each dataset
means_high_income_W3 <- calculate_means_LC(data_high_income_W3)
means_low_income_W3 <- calculate_means_LC(data_low_income_W3)
means_high_educ_PCG_W3 <- calculate_means_LC(data_high_educ_PCG_W3)
means_low_educ_PCG_W3 <- calculate_means_LC(data_low_educ_PCG_W3)
means_high_educ_SCG_W3 <- calculate_means_LC(data_high_educ_SCG_W3)
means_low_educ_SCG_W3 <- calculate_means_LC(data_low_educ_SCG_W3)

# Function to calculate the gender gap
calculate_gender_gap_LC <- function(means) {
  female_means <- means[means$Gender_YP_W3 == 0, ]
  male_means <- means[means$Gender_YP_W3 == 1, ]
  
  data.frame(
    Maths_Gap = male_means$LC_Maths_Points - female_means$LC_Maths_Points,
    English_Gap = male_means$LC_English_Points - female_means$LC_English_Points
  )
}

# Apply the function to each mean dataset
gender_gap_high_income_W3 <- calculate_gender_gap_LC(means_high_income_W3)
gender_gap_low_income_W3 <- calculate_gender_gap_LC(means_low_income_W3)
gender_gap_high_educ_PCG_W3 <- calculate_gender_gap_LC(means_high_educ_PCG_W3)
gender_gap_low_educ_PCG_W3 <- calculate_gender_gap_LC(means_low_educ_PCG_W3)
gender_gap_high_educ_SCG_W3 <- calculate_gender_gap_LC(means_high_educ_SCG_W3)
gender_gap_low_educ_SCG_W3 <- calculate_gender_gap_LC(means_low_educ_SCG_W3)

# Combine all gender gap results into one data frame
gender_gaps <- bind_rows(
  tibble(Subgroup = "High Income", gender_gap_high_income_W3),
  tibble(Subgroup = "Low Income", gender_gap_low_income_W3),
  tibble(Subgroup = "High Educ PCG", gender_gap_high_educ_PCG_W3),
  tibble(Subgroup = "Low Educ PCG", gender_gap_low_educ_PCG_W3),
  tibble(Subgroup = "High Educ SCG", gender_gap_high_educ_SCG_W3),
  tibble(Subgroup = "Low Educ SCG", gender_gap_low_educ_SCG_W3)
)

library(ggplot2)

# Reshape the data for plotting
gender_gaps_long <- gender_gaps %>%
  pivot_longer(cols = c(Maths_Gap, English_Gap), names_to = "Subject", values_to = "Gap")

# Combine gender gap data into a single data frame
gender_gap_data <- bind_rows(
  data.frame(Subgroup = "High Income", gender_gap_high_income_W3),
  data.frame(Subgroup = "Low Income", gender_gap_low_income_W3),
  data.frame(Subgroup = "High Education PCG", gender_gap_high_educ_PCG_W3),
  data.frame(Subgroup = "Low Education PCG", gender_gap_low_educ_PCG_W3),
  data.frame(Subgroup = "High Education SCG", gender_gap_high_educ_SCG_W3),
  data.frame(Subgroup = "Low Education SCG", gender_gap_low_educ_SCG_W3)
)

# Invert the gap values for each subject
gender_gap_data_inverted <- gender_gap_data %>%
  pivot_longer(cols = c(Maths_Gap, English_Gap), names_to = "Subject", values_to = "Gap") %>%
  mutate(Gap = ifelse(Subject == "Maths_Gap", -Gap, -Gap))  # Invert both Maths and English

# Check the prepared data
head(gender_gap_data_inverted)

ggplot(gender_gap_data_inverted, aes(x = Subgroup, y = Gap, color = Subject, group = Subject)) +
  geom_point(size = 3, position = position_dodge(width = 0.0)) +  
  geom_hline(yintercept = 0, linetype = "dashed", color = "gray") +  
  labs(title = "Gender Achievement Gap by Group and Subject - Leaving Cert",
       x = "Group", y = "Gender Achievement Gap (Girls - Boys)",
       caption = "Low income = 1st, 2nd and 3rd quintile (equiv.), High income = 4th and 5th quintile (equiv.).\nLow education = Primary/Secondary caregiver with less than a Bachelor's degree, \nHigh education = Primary/Secondary caregiver with a Bachelor's degree or higher.") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

