library(oaxaca)
library(dplyr)
library(ggplot2)

# SDQ English W2 - Junior Cert
library(oaxaca)

Oaxaca_English_SDQ_W2 <- oaxaca(
  JC_English_Points ~ 
    Cog_VR_W2 + Cog_NA_W2 + Cog_Matrices_W2 +
    SDQ_Emo_Res_PCG_W2 + SDQ_Good_Conduct_PCG_W2 + SDQ_Focus_Behav_PCG_W2 + SDQ_Posi_Peer_PCG_W2 +
    PCG_Educ_W2 + SCG_Educ_W2 + Income_Quin_Eq_W2 + DEIS_W2 + Fee_Paying_W2 + Mixed_W2 | 
    Gender_YP_W2,
  data = na.omit(Oaxaca_Blinder[, c("JC_English_Points", "Cog_VR_W2", "Cog_NA_W2", "Cog_Matrices_W2",
                                    "SDQ_Emo_Res_PCG_W2", "SDQ_Good_Conduct_PCG_W2", "SDQ_Focus_Behav_PCG_W2", 
                                    "SDQ_Posi_Peer_PCG_W2", "PCG_Educ_W2", "SCG_Educ_W2", "Income_Quin_Eq_W2", 
                                    "DEIS_W2", "Fee_Paying_W2", "Mixed_W2", "Gender_YP_W2")]),
  R = 100  # Number of bootstrap replications
)

print(Oaxaca_English_SDQ_W2)


# SDQ English W3 - Leaving Cert

Oaxaca_English_SDQ_W3 <- oaxaca(
  LC_English_Points ~ 
    Cog_Naming_Total_W3 + Cog_Maths_Total_W3 + Cog_Vocabulary_W3 +
    SDQ_Emo_Res_PCG_W3 + SDQ_Good_Conduct_PCG_W3 + SDQ_Focus_Behav_PCG_W3 + SDQ_Posi_Peer_PCG_W3 +
    PCG_Educ_W3 + SCG_Educ_W3 + Income_Quin_Eq_W3 + DEIS_W3 + Fee_Paying_W3 + Mixed_W3 | 
    Gender_YP_W3,
  data = na.omit(Oaxaca_Blinder[, c("LC_English_Points", "Cog_Naming_Total_W3", "Cog_Maths_Total_W3", "Cog_Vocabulary_W3",
                                    "SDQ_Emo_Res_PCG_W3", "SDQ_Good_Conduct_PCG_W3", "SDQ_Focus_Behav_PCG_W3", "SDQ_Posi_Peer_PCG_W3",
                                    "PCG_Educ_W3", "SCG_Educ_W3", "Income_Quin_Eq_W3", "DEIS_W3", "Fee_Paying_W3", "Mixed_W3", "Gender_YP_W3")]),
  R = 100  # Number of bootstrap replications
)
print(Oaxaca_English_SDQ_W3)


# Comparison plots

coef_df_Oaxaca_English_SDQ_W2 <- data.frame(
  variable = names(Oaxaca_English_SDQ_W2$beta$beta.diff),
  coefficient = Oaxaca_English_SDQ_W2$beta$beta.diff
)

ggplot(coef_df_Oaxaca_English_SDQ_W2, 
       aes(x = reorder(variable, coefficient), y = coefficient)) +
  geom_col() +
  coord_flip() +
  labs(title = "Contribution to Gender Gap in Junior Cert English Points (SQD W2)",
       x = "Variables", y = "Coefficient")

coef_df_Oaxaca_English_SDQ_W3 <- data.frame(
  variable = names(Oaxaca_English_SDQ_W3$beta$beta.diff),
  coefficient = Oaxaca_English_SDQ_W3$beta$beta.diff
)

ggplot(coef_df_Oaxaca_English_SDQ_W3, 
       aes(x = reorder(variable, coefficient), y = coefficient)) +
  geom_col() +
  coord_flip() +
  labs(title = "Contribution to Gender Gap in Leaving Cert English Points (SQD W3)",
       x = "Variables", y = "Coefficient")


# Running with standardized values

Oaxaca_Blinder <- Oaxaca_Blinder %>%
  mutate(JC_English_Standardized = scale(JC_English_Points),
         LC_English_Standardized = scale(LC_English_Points))

# SDQ English W2 - Junior Cert
library(oaxaca)

Oaxaca_English_SDQ_W2_std <- oaxaca(
  JC_English_Standardized ~ 
    Cog_VR_W2 + Cog_NA_W2 + Cog_Matrices_W2 +
    SDQ_Emo_Res_PCG_W2 + SDQ_Good_Conduct_PCG_W2 + SDQ_Focus_Behav_PCG_W2 + SDQ_Posi_Peer_PCG_W2 +
    PCG_Educ_W2 + SCG_Educ_W2 + Income_Quin_Eq_W2 + DEIS_W2 + Fee_Paying_W2 + Mixed_W2 | 
    Gender_YP_W2,
  data = na.omit(Oaxaca_Blinder[, c("JC_English_Standardized", "Cog_VR_W2", "Cog_NA_W2", "Cog_Matrices_W2",
                                    "SDQ_Emo_Res_PCG_W2", "SDQ_Good_Conduct_PCG_W2", "SDQ_Focus_Behav_PCG_W2", 
                                    "SDQ_Posi_Peer_PCG_W2", "PCG_Educ_W2", "SCG_Educ_W2", "Income_Quin_Eq_W2", 
                                    "DEIS_W2", "Fee_Paying_W2", "Mixed_W2", "Gender_YP_W2")]),
  R = 100  # Number of bootstrap replications
)

print(Oaxaca_English_SDQ_W2_std)


# SDQ English W3 - Leaving Cert

Oaxaca_English_SDQ_W3_std <- oaxaca(
  LC_English_Standardized ~ 
    Cog_Naming_Total_W3 + Cog_Maths_Total_W3 + Cog_Vocabulary_W3 +
    SDQ_Emo_Res_PCG_W3 + SDQ_Good_Conduct_PCG_W3 + SDQ_Focus_Behav_PCG_W3 + SDQ_Posi_Peer_PCG_W3 +
    PCG_Educ_W3 + SCG_Educ_W3 + Income_Quin_Eq_W3 + DEIS_W3 + Fee_Paying_W3 + Mixed_W3 | 
    Gender_YP_W3,
  data = na.omit(Oaxaca_Blinder[, c("LC_English_Standardized", "Cog_Naming_Total_W3", "Cog_Maths_Total_W3", "Cog_Vocabulary_W3",
                                    "SDQ_Emo_Res_PCG_W3", "SDQ_Good_Conduct_PCG_W3", "SDQ_Focus_Behav_PCG_W3", "SDQ_Posi_Peer_PCG_W3",
                                    "PCG_Educ_W3", "SCG_Educ_W3", "Income_Quin_Eq_W3", "DEIS_W3", "Fee_Paying_W3", "Mixed_W3", "Gender_YP_W3")]),
  R = 100  # Number of bootstrap replications
)
print(Oaxaca_English_SDQ_W3_std)


# Comparison plots

coef_df_Oaxaca_English_SDQ_W2_std <- data.frame(
  variable = names(Oaxaca_English_SDQ_W2_std$beta$beta.diff),
  coefficient = Oaxaca_English_SDQ_W2_std$beta$beta.diff
)

ggplot(coef_df_Oaxaca_English_SDQ_W2_std, 
       aes(x = reorder(variable, coefficient), y = coefficient)) +
  geom_col() +
  coord_flip() +
  labs(title = "Contribution to Gender Gap in Junior Cert English Points (SQD W2) - std",
       x = "Variables", y = "Coefficient")

coef_df_Oaxaca_English_SDQ_W3_std <- data.frame(
  variable = names(Oaxaca_English_SDQ_W3_std$beta$beta.diff),
  coefficient = Oaxaca_English_SDQ_W3_std$beta$beta.diff
)

ggplot(coef_df_Oaxaca_English_SDQ_W3_std, 
       aes(x = reorder(variable, coefficient), y = coefficient)) +
  geom_col() +
  coord_flip() +
  labs(title = "Contribution to Gender Gap in Leaving Cert English Points (SQD W3) - std",
       x = "Variables", y = "Coefficient")

# Comparison for sample with only complete cases:

wave2_subset_English_SDQ <- Oaxaca_Blinder %>%
  select(ID, JC_English_Points, Cog_VR_W2, Cog_NA_W2, Cog_Matrices_W2,
         SDQ_Emo_Res_PCG_W2, SDQ_Good_Conduct_PCG_W2, SDQ_Focus_Behav_PCG_W2, SDQ_Posi_Peer_PCG_W2,
         PCG_Educ_W2, SCG_Educ_W2, Income_Quin_Eq_W2, DEIS_W2, Fee_Paying_W2, Mixed_W2, Gender_YP_W2)

wave3_subset_English_SDQ <- Oaxaca_Blinder %>%
  select(ID, LC_English_Points, Cog_Naming_Total_W3, Cog_Maths_Total_W3, Cog_Vocabulary_W3,
         SDQ_Emo_Res_PCG_W3, SDQ_Good_Conduct_PCG_W3, SDQ_Focus_Behav_PCG_W3, SDQ_Posi_Peer_PCG_W3,
         PCG_Educ_W3, SCG_Educ_W3, Income_Quin_Eq_W3, DEIS_W3, Fee_Paying_W3, Mixed_W3, Gender_YP_W3)

# Perform inner join
full_info_dataset <- wave2_subset_English_SDQ %>%
  inner_join(wave3_subset_English_SDQ, by = "ID")

complete_info_dataset_SDQ_English <- full_info_dataset %>%
  filter(complete.cases(.))

print(paste("Number of complete cases:", nrow(complete_info_dataset_SDQ_English)))

original_means <- Oaxaca_Blinder %>%
  summarise(across(c(JC_English_Points, LC_English_Points, Gender_YP_W2), mean, na.rm = TRUE))

complete_info_means <- complete_info_dataset_SDQ_English %>%
  summarise(across(c(JC_English_Points, LC_English_Points, Gender_YP_W2), mean))

print("Original dataset means:")
print(original_means)
print("Complete info dataset means:")
print(complete_info_means)

# Observations:
# JC_English_Points -> Original: 10.2, Complete info: 10.3
# The difference is minimal, suggesting that the complete cases are fairly representative 
# of the original sample for Junior Cert English performance.
# LC_English_Points -> Original: 49.1, Complete info: 52.4
# There's a more noticeable difference here. The complete cases have a higher average score 
# in Leaving Cert English. This could indicate that students with better performance in Leaving
# Cert English were more likely to have complete data.
# Gender_YP_W2 -> Original: 0.484, Complete info: 0.484
# The gender distribution is identical between the two datasets, which is a positive sign. 
# It suggests that the missingness is not related to gender.
# Implications:
# a) Selection Bias: The higher average in LC_English_Points for the complete cases suggests 
# there might be some selection bias. Students with better academic performance might be more 
# likely to have complete data across both waves.
# Representativeness: While the gender distribution and JC_English_Points are very similar, 
# the difference in LC_English_Points indicates that the complete cases might not be fully 
# representative of the original sample, particularly for later academic performance.
# Potential Overestimation: Using only complete cases might slightly overestimate the average 
# Leaving Cert English performance of the cohort.

# Running with standardized values

complete_info_dataset_SDQ_English <- complete_info_dataset_SDQ_English %>%
  mutate(JC_English_Standardized = scale(JC_English_Points),
         LC_English_Standardized = scale(LC_English_Points))

# SDQ English W2 - Junior Cert
library(oaxaca)

Oaxaca_English_SDQ_W2_std_COMPLETE <- oaxaca(
  JC_English_Standardized ~ 
    Cog_VR_W2 + Cog_NA_W2 + Cog_Matrices_W2 +
    SDQ_Emo_Res_PCG_W2 + SDQ_Good_Conduct_PCG_W2 + SDQ_Focus_Behav_PCG_W2 + SDQ_Posi_Peer_PCG_W2 +
    PCG_Educ_W2 + SCG_Educ_W2 + Income_Quin_Eq_W2 + DEIS_W2 + Fee_Paying_W2 + Mixed_W2 | 
    Gender_YP_W2,
  data = complete_info_dataset_SDQ_English,
  R = 100  # Number of bootstrap replications
)

# SDQ English W3 - Leaving Cert

Oaxaca_English_SDQ_W3_std_COMPLETE <- oaxaca(
  LC_English_Standardized ~ 
    Cog_Naming_Total_W3 + Cog_Maths_Total_W3 + Cog_Vocabulary_W3 +
    SDQ_Emo_Res_PCG_W3 + SDQ_Good_Conduct_PCG_W3 + SDQ_Focus_Behav_PCG_W3 + SDQ_Posi_Peer_PCG_W3 +
    PCG_Educ_W3 + SCG_Educ_W3 + Income_Quin_Eq_W3 + DEIS_W3 + Fee_Paying_W3 + Mixed_W3 | 
    Gender_YP_W3,
  data = complete_info_dataset_SDQ_English,
  R = 100  # Number of bootstrap replications
)

# Comparison plots

coef_df_Oaxaca_English_SDQ_W2_std_COMPLETE <- data.frame(
  variable = names(Oaxaca_English_SDQ_W2_std_COMPLETE$beta$beta.diff),
  coefficient = Oaxaca_English_SDQ_W2_std_COMPLETE$beta$beta.diff
)

ggplot(coef_df_Oaxaca_English_SDQ_W2_std_COMPLETE, 
       aes(x = reorder(variable, coefficient), y = coefficient)) +
  geom_col() +
  coord_flip() +
  labs(title = "Contribution to Gender Gap in Junior Cert English Points (SQD W2) - std - COMPLETE",
       x = "Variables", y = "Coefficient")

coef_df_Oaxaca_English_SDQ_W3_std_COMPLETE <- data.frame(
  variable = names(Oaxaca_English_SDQ_W3_std_COMPLETE$beta$beta.diff),
  coefficient = Oaxaca_English_SDQ_W3_std_COMPLETE$beta$beta.diff
)

ggplot(coef_df_Oaxaca_English_SDQ_W3_std_COMPLETE, 
       aes(x = reorder(variable, coefficient), y = coefficient)) +
  geom_col() +
  coord_flip() +
  labs(title = "Contribution to Gender Gap in Leaving Cert English Points (SQD W3) - std - COMPLETE",
       x = "Variables", y = "Coefficient")

# representing the changes between waves
# Load required libraries
library(ggplot2)
library(dplyr)

# Create dataframes for Wave 2 and Wave 3 coefficients
coef_df_W2 <- data.frame(
  variable = names(Oaxaca_English_SDQ_W2_std_COMPLETE$beta$beta.diff),
  coefficient = Oaxaca_English_SDQ_W2_std_COMPLETE$beta$beta.diff,
  wave = "Wave 2"
)

coef_df_W3 <- data.frame(
  variable = names(Oaxaca_English_SDQ_W3_std_COMPLETE$beta$beta.diff),
  coefficient = Oaxaca_English_SDQ_W3_std_COMPLETE$beta$beta.diff,
  wave = "Wave 3"
)

# Combine the dataframes
combined_coef_df <- rbind(coef_df_W2, coef_df_W3)

# Filter for common variables
common_vars <- c("SDQ_Emo_Res_PCG", "SDQ_Good_Conduct_PCG", "SDQ_Focus_Behav_PCG", "SDQ_Posi_Peer_PCG",
                 "PCG_Educ", "SCG_Educ", "Income_Quin_Eq", "DEIS", "Fee_Paying", "Mixed")

combined_coef_df_filtered <- combined_coef_df %>%
  filter(gsub("_W2|_W3", "", variable) %in% common_vars) %>%
  mutate(variable = gsub("_W2|_W3", "", variable))

# Create a named vector for label replacement
label_replacements <- c(
  "SDQ_Emo_Res_PCG" = "Emotional Resilience",
  "SDQ_Good_Conduct_PCG" = "Good Conduct",
  "SDQ_Focus_Behav_PCG" = "Focused Behavior",
  "SDQ_Posi_Peer_PCG" = "Positive Peer Relations",
  "PCG_Educ" = "Primary Caregiver Education",
  "SCG_Educ" = "Secondary Caregiver Education",
  "Income_Quin_Eq" = "Income Quintile",
  "DEIS" = "DEIS Status",
  "Fee_Paying" = "Fee-Paying School",
  "Mixed" = "Mixed-Gender School"
)

# Create the plot
ggplot(combined_coef_df_filtered, 
       aes(x = reorder(variable, coefficient), y = coefficient, fill = wave)) +
  geom_bar(stat = "identity", position = "stack", color = "black", size = 0.2) +
  scale_fill_manual(values = c("Wave 2" = "#FFCCCB", "Wave 3" = "#8B0000"),
                    guide = guide_legend(override.aes = list(
                      fill = c("#FFCCCB", "#8B0000"),
                      pattern = c("stripe", "crosshatch")
                    ))) +
  scale_x_discrete(labels = label_replacements) +
  coord_flip() +
  labs(title = "Comparison of Coefficients between Wave 2 and Wave 3",
       subtitle = "Contribution to Gender Gap in English Points",
       x = "Variables", 
       y = "Coefficient",
       fill = "Wave") +
  theme_minimal() +
  theme(legend.position = "bottom",
        panel.grid.major = element_line(color = "gray90"),
        panel.grid.minor = element_line(color = "gray95"),
        plot.background = element_rect(fill = "white", color = NA),
        panel.background = element_rect(fill = "white", color = NA),
        axis.text.y = element_text(hjust = 1)) +
  geom_hline(yintercept = 0, linetype = "dashed", color = "gray50")














write.csv(complete_info_dataset_SDQ_English, 
          file = "C:/Users/bgiet/OneDrive/Documents/GitHub/ConflictingForces/ConflictingForces/sensitive_files/ConflictingForcesSensitive/complete_info_dataset_SDQ_English.csv", 
          row.names = FALSE)
