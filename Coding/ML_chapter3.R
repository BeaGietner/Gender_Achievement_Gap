# Load required packages
library(tidyverse)
library(caret)
library(rpart)
library(randomForest)
library(rpart.plot)



rm(ml_data)
# 1. First, let's prepare our data with standardized variables
ml_data <- production_data %>%
  select( ID,
    # Outcomes
    Maths_points, 
    # Gender
    Gender_factor,
    # Cognitive (standardized)
    Drum_VR_W2_p_std,    
    Drum_NA_W2_p_std,    
    BAS_TS_Mat_W2_std,   
    # Non-cognitive SDQ (standardized)
    SDQ_emot_PCG_W2,  
    SDQ_cond_PCG_W2,  
    SDQ_hyper_PCG_W2, 
    SDQ_peer_PCG_W2,
    SDQ_emot_PCG_W2_std,  
    SDQ_cond_PCG_W2_std,  
    SDQ_hyper_PCG_W2_std, 
    SDQ_peer_PCG_W2_std,  
    # Socioeconomic (standardized)
    PCG_Educ_W2,      
    SCG_Educ_W2,      
    Income_equi,
    PCG_Educ_W2_std,      
    SCG_Educ_W2_std,      
    Income_equi_std,
    # School indicators
    DEIS_binary_W2,
    Fee_paying_W2,
    Mixed
  )


summary(ml_data)

# 2. Let's check missing values
missing_summary <- sapply(ml_data, function(x) sum(is.na(x)))
print("Missing values per variable:")
print(missing_summary)


# Complete case analysis
ml_data_complete <- na.omit(ml_data)

# Check how many observations we retain
print(paste("Complete cases:", nrow(ml_data_complete), "out of", nrow(ml_data),
            "(", round(nrow(ml_data_complete)/nrow(ml_data)*100, 2), "%)"))

# Look at summary statistics of complete cases vs original data
summary_complete <- summary(ml_data_complete)
summary_original <- summary(ml_data)

# Compare mean achievement scores between complete and original data
comparison <- data.frame(
  Complete_Math_Mean = mean(ml_data_complete$Maths_points),
  Original_Math_Mean = mean(ml_data$Maths_points, na.rm=TRUE)
)

print("Comparison of means between complete cases and original data:")
print(comparison)


ml_data_complete <- ml_data_complete %>%
  mutate(
    math_achievement = cut(Maths_points, 
                           breaks = c(-Inf, 9, 10, 11, Inf), 
                           labels = c("Low", "Medium-Low", "Medium-High", "High"))
  )

# Check the distribution
print("Math achievement distribution:")
table(ml_data_complete$math_achievement)

summary(ml_data_complete)
# Load required packages
library(tidyverse)
library(caret)
library(randomForest)

set.seed(123)  # For reproducibility

### --- FULL SAMPLE MODEL --- ###
math_rf <- randomForest(
  math_achievement ~ .,
  data = cbind(predictors, math_achievement = ml_data_complete$math_achievement),
  importance = TRUE
)

# Display variable importance
cat("\nMath - Full Sample Variable Importance:\n")
print(importance(math_rf))


### --- GENDER-SPECIFIC MODELS --- ###
# Prepare gender-specific datasets
male_data <- ml_data_complete %>%
  filter(Gender_factor == "Male") %>%
  select(-c(Gender_factor, Maths_points))  # Remove outcomes

female_data <- ml_data_complete %>%
  filter(Gender_factor == "Female") %>%
  select(-c(Gender_factor, Maths_points))  # Remove outcomes


# Train models separately
male_math_rf <- randomForest(
  math_achievement ~ .,
  data = male_data,
  importance = TRUE
)

female_math_rf <- randomForest(
  math_achievement ~ .,
  data = female_data,
  importance = TRUE
)

# Display variable importance for gender-specific models
cat("\nMath - Male Variable Importance:\n")
print(importance(male_math_rf))

cat("\nMath - Female Variable Importance:\n")
print(importance(female_math_rf))


write.csv(ml_data_complete, "ml_data_complete.csv", row.names = FALSE)
getwd()

dplyr::count(ml_data_complete,Gender_factor)




### --- COGNITIVE INTERACTION ANALYSIS --- ###
cognitive_interaction <- ml_data_complete %>%
  mutate(NA_VR_interaction = Drum_NA_W2_p_std * Drum_VR_W2_p_std) %>%
  group_by(math_achievement) %>%
  summarise(
    mean_interaction = mean(NA_VR_interaction),
    mean_NA = mean(Drum_NA_W2_p_std),
    mean_VR = mean(Drum_VR_W2_p_std)
  )

cat("\nCognitive Interaction Analysis:\n")
print(cognitive_interaction)


### --- INCOME GROUP DIFFERENCES --- ###
income_analysis <- ml_data_complete %>%
  mutate(income_group = ifelse(Income_equi_std > median(Income_equi_std), "high", "low")) %>%
  group_by(income_group, math_achievement) %>%
  summarise(
    mean_NA = mean(Drum_NA_W2_p_std),
    mean_VR = mean(Drum_VR_W2_p_std)
  )

cat("\nCognitive Skills by Income Group:\n")
print(income_analysis)


### --- NON-LINEAR INTERACTION EFFECTS --- ###
non_linear_effects <- ml_data_complete %>%
  group_by(Gender_factor) %>%
  summarize(
    # Cognitive interactions
    cog_interaction = cor(Drum_VR_W2_p_std * Drum_NA_W2_p_std, Maths_points),
    vr_linear = cor(Drum_VR_W2_p_std, Maths_points),
    na_linear = cor(Drum_NA_W2_p_std, Maths_points),
    
    # Non-cognitive interactions with cognitive
    hyper_na_interaction = cor(SDQ_hyper_PCG_W2_std * Drum_NA_W2_p_std, Maths_points),
    conduct_vr_interaction = cor(SDQ_cond_PCG_W2_std * Drum_VR_W2_p_std, Maths_points)
  )

cat("\nNon-Linear Effects by Gender:\n")
print(non_linear_effects)


### --- SOCIOECONOMIC MEDIATING EFFECTS --- ###
socioeconomic_effects <- ml_data_complete %>%
  group_by(Gender_factor) %>%
  summarize(
    income_na_interaction = cor(Income_equi_std * Drum_NA_W2_p_std, Maths_points),
    pcg_vr_interaction = cor(PCG_Educ_W2_std * Drum_VR_W2_p_std, Maths_points)
  )

cat("\nSocioeconomic Mediating Effects by Gender:\n")
print(socioeconomic_effects)



# Compute interaction effects across achievement levels
interaction_effects <- ml_data_complete %>%
  group_by(math_achievement, Gender_factor) %>%
  summarise(
    income_na_interaction = ifelse(sd(Income_equi_std * Drum_NA_W2_p_std, na.rm = TRUE) > 0, 
                                   cor(Income_equi_std * Drum_NA_W2_p_std, Maths_points, use = "complete.obs"), 
                                   NA),
    
    pcg_vr_interaction = ifelse(sd(PCG_Educ_W2_std * Drum_VR_W2_p_std, na.rm = TRUE) > 0, 
                                cor(PCG_Educ_W2_std * Drum_VR_W2_p_std, Maths_points, use = "complete.obs"), 
                                NA),
    
    mean_income_na_interaction = mean(Income_equi_std * Drum_NA_W2_p_std, na.rm = TRUE),
    mean_pcg_vr_interaction = mean(PCG_Educ_W2_std * Drum_VR_W2_p_std, na.rm = TRUE),
    
    .groups = "drop"
  )

# Display interaction effects
print(interaction_effects)



# Check number of observations and standard deviations per group
ml_data_complete %>%
  group_by(math_achievement, Gender_factor) %>%
  summarise(
    n = n(),
    sd_income_na = sd(Income_equi_std * Drum_NA_W2_p_std, na.rm = TRUE),
    sd_pcg_vr = sd(PCG_Educ_W2_std * Drum_VR_W2_p_std, na.rm = TRUE),
    .groups = "drop"
  ) %>%
  arrange(Gender_factor, math_achievement) %>%
  print()



ml_data_complete %>%
  group_by(math_achievement, Gender_factor) %>%
  summarise(
    n = n(),
    missing_math_points = sum(is.na(Maths_points)),
    missing_income_na = sum(is.na(Income_equi_std * Drum_NA_W2_p_std)),
    missing_pcg_vr = sum(is.na(PCG_Educ_W2_std * Drum_VR_W2_p_std)),
    .groups = "drop"
  )

print(missing_values_summary)



# Compute interaction effects across achievement levels
interaction_effects <- ml_data_complete %>%
  group_by(math_achievement, Gender_factor) %>%
  summarize(
    # Interaction between income and numerical ability
    income_na_interaction = cor(Income_equi_std * Drum_NA_W2_p_std, Maths_points, use = "complete.obs"),
    
    # Interaction between PCG Education and Verbal Reasoning
    pcg_vr_interaction = cor(PCG_Educ_W2_std * Drum_VR_W2_p_std, Maths_points, use = "complete.obs"),
    
    .groups = "drop"
  )

# Display interaction effects
print(interaction_effects)


write.csv(ml_data_complete, "math_achievement_data.csv", row.names = FALSE)








# Analysing income:

# Load required packages
library(tidyverse)
library(randomForest)

# Create income quintiles
ml_data_complete <- ml_data_complete %>%
  mutate(income_quintile = ntile(Income_equi_std, 5)) # Splitting into 5 groups

# Check distribution of income quintiles
table(ml_data_complete$income_quintile)

# Initialize list to store models
math_rf_models <- list()
english_rf_models <- list()

# Run separate Random Forest models for each quintile
for (q in 1:5) {
  subset_data <- ml_data_complete %>% filter(income_quintile == q)
  
  # Math model
  math_rf_models[[q]] <- randomForest(
    math_achievement ~ .,
    data = select(subset_data, -English_points, -english_achievement, -income_quintile),
    importance = TRUE
  )
  
  # English model
  english_rf_models[[q]] <- randomForest(
    english_achievement ~ .,
    data = select(subset_data, -Maths_points, -math_achievement, -income_quintile),
    importance = TRUE
  )
}

# Function to extract variable importance across quintiles
extract_importance <- function(rf_list) {
  importance_df <- map_dfr(1:5, function(q) {
    imp <- importance(rf_list[[q]], type = 1)  # Mean Decrease in Accuracy
    data.frame(Variable = rownames(imp), MDA = imp[,1], Income_Quintile = q)
  })
  return(importance_df)
}

# Extract importance for each quintile
math_importance <- extract_importance(math_rf_models)
english_importance <- extract_importance(english_rf_models)

# Plot variable importance across quintiles
library(ggplot2)

ggplot(math_importance, aes(x = factor(Income_Quintile), y = MDA, fill = Variable)) +
  geom_bar(stat = "identity", position = "dodge") +
  labs(title = "Variable Importance in Maths Achievement by Income Quintile",
       x = "Income Quintile", y = "Mean Decrease in Accuracy") +
  theme_minimal()

ggplot(english_importance, aes(x = factor(Income_Quintile), y = MDA, fill = Variable)) +
  geom_bar(stat = "identity", position = "dodge") +
  labs(title = "Variable Importance in English Achievement by Income Quintile",
       x = "Income Quintile", y = "Mean Decrease in Accuracy") +
  theme_minimal()



summary(production_data, width = Inf)