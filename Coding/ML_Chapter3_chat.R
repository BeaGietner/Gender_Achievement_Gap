# Load required packages
library(tidyverse)
library(caret)
library(rpart)
library(randomForest)
library(rpart.plot)
library(xgboost)
library(pdp)  # For partial dependence plots
library(DALEX)  # For explainability (SHAP values)
library(vip)  # For variable importance plots

# --- 1. FEATURE ENGINEERING ---
# Add interactions between cognitive and non-cognitive skills
ml_data_complete <- ml_data_complete %>%
  mutate(
    # Interaction terms between cognitive and non-cognitive
    NA_Focused_interaction = Drum_NA_W2_p_std * SDQ_hyper_PCG_W2_std,
    VR_Conscientious_interaction = Drum_VR_W2_p_std * Conscientious_W2_PCG_std,
    # Socioeconomic and skill interactions
    Income_NA_interaction = Income_equi_std * Drum_NA_W2_p_std,
    PCG_VR_interaction = PCG_Educ_W2_std * Drum_VR_W2_p_std
  )

# --- 2. TRAINING RANDOM FOREST MODELS ---
set.seed(123)  # For reproducibility

# Prepare predictors
predictors <- ml_data_complete %>%
  select(-c(Maths_points, English_points, math_achievement, english_achievement)) %>%
  mutate(Gender_factor = as.factor(Gender_factor))

# Train separate models for Math and English achievement
math_rf <- randomForest(
  math_achievement ~ ., 
  data = cbind(predictors, math_achievement = ml_data_complete$math_achievement),
  importance = TRUE
)

# --- 3. VARIABLE IMPORTANCE ---
print("Math - Variable Importance:")
print(importance(math_rf))

# Plot feature importance
library(vip)

vip(math_rf, num_features = 10, main = "Top 10 Features - Math")


# --- 5. SOCIOECONOMIC MEDIATING EFFECTS ---
ml_data_complete %>%
  mutate(income_group = ifelse(Income_equi_std > median(Income_equi_std), "High", "Low")) %>%
  group_by(income_group, math_achievement) %>%
  summarise(
    mean_NA = mean(Drum_NA_W2_p_std),
    mean_VR = mean(Drum_VR_W2_p_std)
  ) %>%
  print()

# --- 6. SPLITTING DATA BY GENDER FOR SEPARATE MODELS ---
male_data <- ml_data_complete %>% filter(Gender_factor == "Male") %>% select(-Gender_factor)
female_data <- ml_data_complete %>% filter(Gender_factor == "Female") %>% select(-Gender_factor)

# Train gender-specific models
male_math_rf <- randomForest(
  math_achievement ~ ., 
  data = select(male_data, -English_points, -english_achievement),
  importance = TRUE
)

female_math_rf <- randomForest(
  math_achievement ~ ., 
  data = select(female_data, -English_points, -english_achievement),
  importance = TRUE
)

# Compare variable importance by gender
print("Math - Male Variable Importance:")
print(importance(male_math_rf))
print("\nMath - Female Variable Importance:")
print(importance(female_math_rf))

# --- 7. BOOSTED TREE MODEL (XGBoost) ---
# Convert categorical variables to numerical for XGBoost
ml_data_complete_xgb <- ml_data_complete %>%
  mutate(math_achievement = as.numeric(as.factor(math_achievement)),
         english_achievement = as.numeric(as.factor(english_achievement)))

# Convert to matrix format for XGBoost
dtrain_math <- xgb.DMatrix(data = as.matrix(select(ml_data_complete_xgb, -math_achievement)), 
                           label = ml_data_complete_xgb$math_achievement)

dtrain_english <- xgb.DMatrix(data = as.matrix(select(ml_data_complete_xgb, -english_achievement)), 
                              label = ml_data_complete_xgb$english_achievement)

# Train an XGBoost model for Math
xgb_math <- xgboost(data = dtrain_math, max.depth = 6, eta = 0.1, nrounds = 100, objective = "multi:softmax")

# Train an XGBoost model for English
xgb_english <- xgboost(data = dtrain_english, max.depth = 6, eta = 0.1, nrounds = 100, objective = "multi:softmax")

# --- 8. SHAP VALUES FOR INTERPRETABILITY ---
explainer_math <- explain(math_rf, data = predictors, y = ml_data_complete$math_achievement, label = "Random Forest")
shap_values_math <- predict_parts(explainer_math, new_observation = predictors[1, ], type = "break_down")
plot(shap_values_math)

explainer_english <- explain(english_rf, data = predictors, y = ml_data_complete$english_achievement, label = "Random Forest")
shap_values_english <- predict_parts(explainer_english, new_observation = predictors[1, ], type = "break_down")
plot(shap_values_english)

# --- 9. NON-LINEAR EFFECTS OF COGNITIVE AND SOCIOECONOMIC FACTORS ---
ml_data_complete %>%
  group_by(Gender_factor) %>%
  summarize(
    cog_interaction = cor(Drum_VR_W2_p_std * Drum_NA_W2_p_std, Maths_points),
    income_na_interaction = cor(Income_equi_std * Drum_NA_W2_p_std, Maths_points),
    pcg_vr_interaction = cor(PCG_Educ_W2_std * Drum_VR_W2_p_std, Maths_points)
  )
