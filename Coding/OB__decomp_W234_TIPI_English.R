library(oaxaca)
library(dplyr)
library(ggplot2)

# TIPI English W2 - Junior Cert
library(oaxaca)

Oaxaca_English_TIPI_W2 <- oaxaca(
  JC_English_Points ~ 
    Cog_VR_W2 + Cog_NA_W2 + Cog_Matrices_W2 +
    TIPI_Extra_PCG_W2 + TIPI_Agreeable_PCG_W2 + TIPI_Cons_PCG_W2 + TIPI_EmoStab_PCG_W2 + TIPI_Open_PCG_W2 +
    PCG_Educ_W2 + SCG_Educ_W2 + Income_Quin_Eq_W2 + DEIS_W2 + Fee_Paying_W2 + Mixed_W2 | 
    Gender_YP_W2,
  data = na.omit(Oaxaca_Blinder[, c("JC_English_Points", "Cog_VR_W2", "Cog_NA_W2", "Cog_Matrices_W2",
                                    "TIPI_Extra_PCG_W2", "TIPI_Agreeable_PCG_W2", "TIPI_Cons_PCG_W2", "TIPI_Open_PCG_W2",
                                    "TIPI_EmoStab_PCG_W2", "PCG_Educ_W2", "SCG_Educ_W2", "Income_Quin_Eq_W2", 
                                    "DEIS_W2", "Fee_Paying_W2", "Mixed_W2", "Gender_YP_W2")]),
  R = 100  # Number of bootstrap replications
)

print(Oaxaca_English_TIPI_W2)


# TIPI English W3 - Leaving Cert

Oaxaca_English_TIPI_W3 <- oaxaca(
  LC_English_Points ~ 
    Cog_Naming_Total_W3 + Cog_Maths_Total_W3 + Cog_Vocabulary_W3 +
    TIPI_Extra_PCG_W3 + TIPI_Agreeable_PCG_W3 + TIPI_Cons_PCG_W3 + TIPI_EmoStab_PCG_W3 + TIPI_Open_PCG_W3 +
    PCG_Educ_W3 + SCG_Educ_W3 + Income_Quin_Eq_W3 + DEIS_W3 + Fee_Paying_W3 + Mixed_W3 | 
    Gender_YP_W3,
  data = na.omit(Oaxaca_Blinder[, c("LC_English_Points", "Cog_Naming_Total_W3", "Cog_Maths_Total_W3", "Cog_Vocabulary_W3",
                                    "TIPI_Extra_PCG_W3", "TIPI_Agreeable_PCG_W3", "TIPI_Cons_PCG_W3", "TIPI_EmoStab_PCG_W3", "TIPI_Open_PCG_W3",
                                    "PCG_Educ_W3", "SCG_Educ_W3", "Income_Quin_Eq_W3", "DEIS_W3", "Fee_Paying_W3", "Mixed_W3", "Gender_YP_W3")]),
  R = 100  # Number of bootstrap replications
)
print(Oaxaca_English_TIPI_W3)


# Comparison plots

coef_df_Oaxaca_English_TIPI_W2 <- data.frame(
  variable = names(Oaxaca_English_TIPI_W2$beta$beta.diff),
  coefficient = Oaxaca_English_TIPI_W2$beta$beta.diff
)

ggplot(coef_df_Oaxaca_English_TIPI_W2, 
       aes(x = reorder(variable, coefficient), y = coefficient)) +
  geom_col() +
  coord_flip() +
  labs(title = "Contribution to Gender Gap in Junior Cert English Points (SQD W2)",
       x = "Variables", y = "Coefficient")

coef_df_Oaxaca_English_TIPI_W3 <- data.frame(
  variable = names(Oaxaca_English_TIPI_W3$beta$beta.diff),
  coefficient = Oaxaca_English_TIPI_W3$beta$beta.diff
)

ggplot(coef_df_Oaxaca_English_TIPI_W3, 
       aes(x = reorder(variable, coefficient), y = coefficient)) +
  geom_col() +
  coord_flip() +
  labs(title = "Contribution to Gender Gap in Leaving Cert English Points (SQD W3)",
       x = "Variables", y = "Coefficient")


# Running with standardized values

Oaxaca_Blinder <- Oaxaca_Blinder %>%
  mutate(JC_English_Standardized = scale(JC_English_Points),
         LC_English_Standardized = scale(LC_English_Points))

# TIPI English W2 - Junior Cert
library(oaxaca)

Oaxaca_English_TIPI_W2_std <- oaxaca(
  JC_English_Standardized ~ 
    Cog_VR_W2 + Cog_NA_W2 + Cog_Matrices_W2 +
    TIPI_Extra_PCG_W2 + TIPI_Agreeable_PCG_W2 + TIPI_Cons_PCG_W2 + TIPI_EmoStab_PCG_W2 + TIPI_Open_PCG_W2 +
    PCG_Educ_W2 + SCG_Educ_W2 + Income_Quin_Eq_W2 + DEIS_W2 + Fee_Paying_W2 + Mixed_W2 | 
    Gender_YP_W2,
  data = na.omit(Oaxaca_Blinder[, c("JC_English_Standardized", "Cog_VR_W2", "Cog_NA_W2", "Cog_Matrices_W2",
                                    "TIPI_Extra_PCG_W2", "TIPI_Agreeable_PCG_W2", "TIPI_Cons_PCG_W2", "TIPI_Open_PCG_W2",
                                    "TIPI_EmoStab_PCG_W2", "PCG_Educ_W2", "SCG_Educ_W2", "Income_Quin_Eq_W2", 
                                    "DEIS_W2", "Fee_Paying_W2", "Mixed_W2", "Gender_YP_W2")]),
  R = 100  # Number of bootstrap replications
)

print(Oaxaca_English_TIPI_W2_std)


# TIPI English W3 - Leaving Cert

Oaxaca_English_TIPI_W3_std <- oaxaca(
  LC_English_Standardized ~ 
    Cog_Naming_Total_W3 + Cog_Maths_Total_W3 + Cog_Vocabulary_W3 +
    TIPI_Extra_PCG_W3 + TIPI_Agreeable_PCG_W3 + TIPI_Cons_PCG_W3 + TIPI_EmoStab_PCG_W3 + TIPI_Open_PCG_W3 +
    PCG_Educ_W3 + SCG_Educ_W3 + Income_Quin_Eq_W3 + DEIS_W3 + Fee_Paying_W3 + Mixed_W3 | 
    Gender_YP_W3,
  data = na.omit(Oaxaca_Blinder[, c("LC_English_Standardized", "Cog_Naming_Total_W3", "Cog_Maths_Total_W3", "Cog_Vocabulary_W3",
                                    "TIPI_Extra_PCG_W3", "TIPI_Agreeable_PCG_W3", "TIPI_Cons_PCG_W3", "TIPI_EmoStab_PCG_W3", "TIPI_Open_PCG_W3",
                                    "PCG_Educ_W3", "SCG_Educ_W3", "Income_Quin_Eq_W3", "DEIS_W3", "Fee_Paying_W3", "Mixed_W3", "Gender_YP_W3")]),
  R = 100  # Number of bootstrap replications
)
print(Oaxaca_English_TIPI_W3_std)


# Comparison plots

coef_df_Oaxaca_English_TIPI_W2_std <- data.frame(
  variable = names(Oaxaca_English_TIPI_W2_std$beta$beta.diff),
  coefficient = Oaxaca_English_TIPI_W2_std$beta$beta.diff
)

ggplot(coef_df_Oaxaca_English_TIPI_W2_std, 
       aes(x = reorder(variable, coefficient), y = coefficient)) +
  geom_col() +
  coord_flip() +
  labs(title = "Contribution to Gender Gap in Junior Cert English Points (SQD W2) - std",
       x = "Variables", y = "Coefficient")

coef_df_Oaxaca_English_TIPI_W3_std <- data.frame(
  variable = names(Oaxaca_English_TIPI_W3_std$beta$beta.diff),
  coefficient = Oaxaca_English_TIPI_W3_std$beta$beta.diff
)

ggplot(coef_df_Oaxaca_English_TIPI_W3_std, 
       aes(x = reorder(variable, coefficient), y = coefficient)) +
  geom_col() +
  coord_flip() +
  labs(title = "Contribution to Gender Gap in Leaving Cert English Points (SQD W3) - std",
       x = "Variables", y = "Coefficient")

# Comparison for sample with only complete cases:

wave2_subset_English_TIPI <- Oaxaca_Blinder %>%
  select(ID, JC_English_Points, Cog_VR_W2, Cog_NA_W2, Cog_Matrices_W2,
         TIPI_Extra_PCG_W2, TIPI_Agreeable_PCG_W2, TIPI_Cons_PCG_W2, TIPI_EmoStab_PCG_W2, TIPI_Open_PCG_W2,
         PCG_Educ_W2, SCG_Educ_W2, Income_Quin_Eq_W2, DEIS_W2, Fee_Paying_W2, Mixed_W2, Gender_YP_W2)

wave3_subset_English_TIPI <- Oaxaca_Blinder %>%
  select(ID, LC_English_Points, Cog_Naming_Total_W3, Cog_Maths_Total_W3, Cog_Vocabulary_W3,
         TIPI_Extra_PCG_W3, TIPI_Agreeable_PCG_W3, TIPI_Cons_PCG_W3, TIPI_EmoStab_PCG_W3, TIPI_Open_PCG_W3,
         PCG_Educ_W3, SCG_Educ_W3, Income_Quin_Eq_W3, DEIS_W3, Fee_Paying_W3, Mixed_W3, Gender_YP_W3)

# Perform inner join
full_info_dataset_TIPI_English <- wave2_subset_English_TIPI %>%
  inner_join(wave3_subset_English_TIPI, by = "ID")

complete_info_dataset_TIPI_English <- full_info_dataset_TIPI_English %>%
  filter(complete.cases(.))

print(paste("Number of complete cases:", nrow(complete_info_dataset_TIPI_English)))

original_means <- Oaxaca_Blinder %>%
  summarise(across(c(JC_English_Points, LC_English_Points, Gender_YP_W2), mean, na.rm = TRUE))

complete_info_means <- complete_info_dataset_TIPI_English %>%
  summarise(across(c(JC_English_Points, LC_English_Points, Gender_YP_W2), mean))

print("Original dataset means:")
print(original_means)
print("Complete info dataset means:")
print(complete_info_means)

# Observations:
# JC_English_Points -> Original: 9.72, Complete info: 10.1
# The difference is minimal, suggesting that the complete cases are fairly representative 
# of the original sample for Junior Cert English performance.
# LC_English_Points -> Original: 61.4, Complete info: 66.1
# There's a more noticeable difference here. The complete cases have a higher average score 
# in Leaving Cert English. This could indicate that students with better performance in Leaving
# Cert English were more likely to have complete data.
# Gender_YP_W2 -> Original: 0.484, Complete info: 0.518
# The gender distribution is similar between the two datasets, but it's not the same.
# In the original dataset we had a mean < 0.5, which indicated more girls.
# In the complete dataset we have mean > 0.5, which indicates more boys.
# It suggests that the missingness might be a bit related to gender.
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

complete_info_dataset_TIPI_English <- complete_info_dataset_TIPI_English %>%
  mutate(JC_English_Standardized = scale(JC_English_Points),
         LC_English_Standardized = scale(LC_English_Points))

# TIPI English W2 - Junior Cert
library(oaxaca)

Oaxaca_English_TIPI_W2_std_COMPLETE <- oaxaca(
  JC_English_Standardized ~ 
    Cog_VR_W2 + Cog_NA_W2 + Cog_Matrices_W2 +
    TIPI_Extra_PCG_W2 + TIPI_Agreeable_PCG_W2 + TIPI_Cons_PCG_W2 + TIPI_EmoStab_PCG_W2 + TIPI_Open_PCG_W2 +
    PCG_Educ_W2 + SCG_Educ_W2 + Income_Quin_Eq_W2 + DEIS_W2 + Fee_Paying_W2 + Mixed_W2 | 
    Gender_YP_W2,
  data = complete_info_dataset_TIPI_English,
  R = 100  # Number of bootstrap replications
)

# TIPI English W3 - Leaving Cert

Oaxaca_English_TIPI_W3_std_COMPLETE <- oaxaca(
  LC_English_Standardized ~ 
    Cog_Naming_Total_W3 + Cog_Maths_Total_W3 + Cog_Vocabulary_W3 +
    TIPI_Extra_PCG_W3 + TIPI_Agreeable_PCG_W3 + TIPI_Cons_PCG_W3 + TIPI_EmoStab_PCG_W3 + TIPI_Open_PCG_W3 +
    PCG_Educ_W3 + SCG_Educ_W3 + Income_Quin_Eq_W3 + DEIS_W3 + Fee_Paying_W3 + Mixed_W3 | 
    Gender_YP_W3,
  data = complete_info_dataset_TIPI_English,
  R = 100  # Number of bootstrap replications
)

# Comparison plots

coef_df_Oaxaca_English_TIPI_W2_std_COMPLETE <- data.frame(
  variable = names(Oaxaca_English_TIPI_W2_std_COMPLETE$beta$beta.diff),
  coefficient = Oaxaca_English_TIPI_W2_std_COMPLETE$beta$beta.diff
)

ggplot(coef_df_Oaxaca_English_TIPI_W2_std_COMPLETE, 
       aes(x = reorder(variable, coefficient), y = coefficient)) +
  geom_col() +
  coord_flip() +
  labs(title = "Contribution to Gender Gap in Junior Cert English Points (SQD W2) - std - COMPLETE",
       x = "Variables", y = "Coefficient")

coef_df_Oaxaca_English_TIPI_W3_std_COMPLETE <- data.frame(
  variable = names(Oaxaca_English_TIPI_W3_std_COMPLETE$beta$beta.diff),
  coefficient = Oaxaca_English_TIPI_W3_std_COMPLETE$beta$beta.diff
)

ggplot(coef_df_Oaxaca_English_TIPI_W3_std_COMPLETE, 
       aes(x = reorder(variable, coefficient), y = coefficient)) +
  geom_col() +
  coord_flip() +
  labs(title = "Contribution to Gender Gap in Leaving Cert English Points (SQD W3) - std - COMPLETE",
       x = "Variables", y = "Coefficient")

write.csv(complete_info_dataset_TIPI_English, 
          file = "C:/Users/bgiet/OneDrive/Documents/GitHub/ConflictingForces/ConflictingForces/sensitive_files/ConflictingForcesSensitive/complete_info_dataset_TIPI_English.csv", 
          row.names = FALSE)