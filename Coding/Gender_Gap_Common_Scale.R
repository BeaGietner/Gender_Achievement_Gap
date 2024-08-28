# Define a function to transform scores to a common scale (0 to 100)
transform_to_100 <- function(x, max_score) {
  (x / max_score) * 100
}

# Apply transformation
Oaxaca_Blinder <- Oaxaca_Blinder %>%
  mutate(
    LC_English_100 = transform_to_100(LC_English_Points, 100),
    JC_English_100 = transform_to_100(JC_English_Points, 12),
    LC_Maths_100 = transform_to_100(LC_Maths_Points, 125),
    JC_Maths_100 = transform_to_100(JC_Maths_Points, 12)
  )

data_high_income_W2 <- Oaxaca_Blinder %>% filter(Income_Quin_Eq_W2 %in% c(4, 5))
data_low_income_W2 <- Oaxaca_Blinder %>% filter(Income_Quin_Eq_W2 %in% c(1, 2, 3))
data_high_educ_PCG_W2 <- Oaxaca_Blinder %>% filter(PCG_Educ_W2 %in% c(5, 6))
data_low_educ_PCG_W2 <- Oaxaca_Blinder %>% filter(PCG_Educ_W2 %in% c(1, 2, 3, 4))
data_high_educ_SCG_W2 <- Oaxaca_Blinder %>% filter(SCG_Educ_W2 %in% c(5, 6))
data_low_educ_SCG_W2 <- Oaxaca_Blinder %>% filter(SCG_Educ_W2 %in% c(1, 2, 3, 4))

data_high_income_W3 <- Oaxaca_Blinder %>% filter(Income_Quin_Eq_W3 %in% c(4, 5))
data_low_income_W3 <- Oaxaca_Blinder %>% filter(Income_Quin_Eq_W3 %in% c(1, 2, 3))
data_high_educ_PCG_W3 <- Oaxaca_Blinder %>% filter(PCG_Educ_W3 %in% c(5, 6))
data_low_educ_PCG_W3 <- Oaxaca_Blinder %>% filter(PCG_Educ_W3 %in% c(1, 2, 3, 4))
data_high_educ_SCG_W3 <- Oaxaca_Blinder %>% filter(SCG_Educ_W3 %in% c(5, 6))
data_low_educ_SCG_W3 <- Oaxaca_Blinder %>% filter(SCG_Educ_W3 %in% c(1, 2, 3, 4))


calculate_means_JC <- function(data) {
  aggregate(cbind(JC_Maths_100, JC_English_100) ~ Gender_YP_W2, data, mean)
}

means_high_income_W2 <- calculate_means_JC(data_high_income_W2)
means_low_income_W2 <- calculate_means_JC(data_low_income_W2)
means_high_educ_PCG_W2 <- calculate_means_JC(data_high_educ_PCG_W2)
means_low_educ_PCG_W2 <- calculate_means_JC(data_low_educ_PCG_W2)
means_high_educ_SCG_W2 <- calculate_means_JC(data_high_educ_SCG_W2)
means_low_educ_SCG_W2 <- calculate_means_JC(data_low_educ_SCG_W2)

calculate_gender_gap_JC <- function(means) {
  female_means_JC <- means %>% filter(Gender_YP_W2 == 0)
  male_means_JC <- means %>% filter(Gender_YP_W2 == 1)
  
  data.frame(
    Maths_Gap_JC = female_means_JC$JC_Maths_100 - male_means_JC$JC_Maths_100,
    English_Gap_JC = female_means_JC$JC_English_100 - male_means_JC$JC_English_100
  )
}

gender_gap_high_income_W2 <- calculate_gender_gap_JC(means_high_income_W2)
gender_gap_low_income_W2 <- calculate_gender_gap_JC(means_low_income_W2)
gender_gap_high_educ_PCG_W2 <- calculate_gender_gap_JC(means_high_educ_PCG_W2)
gender_gap_low_educ_PCG_W2 <- calculate_gender_gap_JC(means_low_educ_PCG_W2)
gender_gap_high_educ_SCG_W2 <- calculate_gender_gap_JC(means_high_educ_SCG_W2)
gender_gap_low_educ_SCG_W2 <- calculate_gender_gap_JC(means_low_educ_SCG_W2)

gender_gaps_JC <- bind_rows(
  tibble(Subgroup = "High Income", Certification = "Junior Cert", gender_gap_high_income_W2),
  tibble(Subgroup = "Low Income", Certification = "Junior Cert", gender_gap_low_income_W2),
  tibble(Subgroup = "High Educ PCG", Certification = "Junior Cert", gender_gap_high_educ_PCG_W2),
  tibble(Subgroup = "Low Educ PCG", Certification = "Junior Cert", gender_gap_low_educ_PCG_W2),
  tibble(Subgroup = "High Educ SCG", Certification = "Junior Cert", gender_gap_high_educ_SCG_W2),
  tibble(Subgroup = "Low Educ SCG", Certification = "Junior Cert", gender_gap_low_educ_SCG_W2)
)

gender_gaps_long_JC <- gender_gaps_JC %>%
  pivot_longer(cols = c(Maths_Gap_JC, English_Gap_JC), names_to = "Subject", values_to = "Gap") %>%
  mutate(Subject = recode(Subject, Maths_Gap_JC = "Maths", English_Gap_JC = "English"))


calculate_means_LC <- function(data) {
  aggregate(cbind(LC_Maths_100, LC_English_100) ~ Gender_YP_W3, data, mean)
}

means_high_income_W3 <- calculate_means_LC(data_high_income_W3)
means_low_income_W3 <- calculate_means_LC(data_low_income_W3)
means_high_educ_PCG_W3 <- calculate_means_LC(data_high_educ_PCG_W3)
means_low_educ_PCG_W3 <- calculate_means_LC(data_low_educ_PCG_W3)
means_high_educ_SCG_W3 <- calculate_means_LC(data_high_educ_SCG_W3)
means_low_educ_SCG_W3 <- calculate_means_LC(data_low_educ_SCG_W3)

calculate_gender_gap_LC <- function(means) {
  female_means_LC <- means %>% filter(Gender_YP_W3 == 0)
  male_means_LC <- means %>% filter(Gender_YP_W3 == 1)
  
  data.frame(
    Maths_Gap_LC = female_means_LC$LC_Maths_100 - male_means_LC$LC_Maths_100,
    English_Gap_LC = female_means_LC$LC_English_100 - male_means_LC$LC_English_100
  )
}

gender_gap_high_income_W3 <- calculate_gender_gap_LC(means_high_income_W3)
gender_gap_low_income_W3 <- calculate_gender_gap_LC(means_low_income_W3)
gender_gap_high_educ_PCG_W3 <- calculate_gender_gap_LC(means_high_educ_PCG_W3)
gender_gap_low_educ_PCG_W3 <- calculate_gender_gap_LC(means_low_educ_PCG_W3)
gender_gap_high_educ_SCG_W3 <- calculate_gender_gap_LC(means_high_educ_SCG_W3)
gender_gap_low_educ_SCG_W3 <- calculate_gender_gap_LC(means_low_educ_SCG_W3)

gender_gaps_LC <- bind_rows(
  tibble(Subgroup = "High Income", Certification = "Leaving Cert", gender_gap_high_income_W3),
  tibble(Subgroup = "Low Income", Certification = "Leaving Cert", gender_gap_low_income_W3),
  tibble(Subgroup = "High Educ PCG", Certification = "Leaving Cert", gender_gap_high_educ_PCG_W3),
  tibble(Subgroup = "Low Educ PCG", Certification = "Leaving Cert", gender_gap_low_educ_PCG_W3),
  tibble(Subgroup = "High Educ SCG", Certification = "Leaving Cert", gender_gap_high_educ_SCG_W3),
  tibble(Subgroup = "Low Educ SCG", Certification = "Leaving Cert", gender_gap_low_educ_SCG_W3)
)

gender_gaps_long_LC <- gender_gaps_LC %>%
  pivot_longer(cols = c(Maths_Gap_LC, English_Gap_LC), names_to = "Subject", values_to = "Gap") %>%
  mutate(Subject = recode(Subject, Maths_Gap_LC = "Maths", English_Gap_LC = "English"))

# Combine JC and LC data for plotting
gender_gaps_combined <- bind_rows(gender_gaps_long_JC, gender_gaps_long_LC)

# Plotting
ggplot(gender_gaps_combined, aes(x = Subgroup, y = Gap, color = Subject, shape = Certification, group = interaction(Subject, Certification))) +
  geom_point(size = 3, position = position_dodge(width = 0.0)) +  
  geom_hline(yintercept = 0, linetype = "dashed", color = "gray") +  
  labs(title = "Gender Achievement Gap by Group, Subject, and Certification",
       x = "Group", y = "Gender Achievement Gap (Girls - Boys)",
       caption = "JC = Junior Cert, LC = Leaving Cert.\nLow income = 1st, 2nd, and 3rd quintile (equiv.), High income = 4th and 5th quintile (equiv.).\nLow education = Primary/Secondary caregiver with less than a Bachelor's degree, \nHigh education = Primary/Secondary caregiver with a Bachelor's degree or higher.") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))