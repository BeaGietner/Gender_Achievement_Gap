# Load necessary libraries
library(tidyverse)

# Reload production_data (assuming it's already in your workspace)
ml_data <- production_data %>%
  select(
    ID, Maths_points, Gender_factor,  # Outcomes & Demographics
    Drum_VR_W2_p, Drum_NA_W2_p, BAS_TS_Mat_W2,  # Cognitive (raw)
    SDQ_emot_PCG_W2, SDQ_cond_PCG_W2, SDQ_hyper_PCG_W2, SDQ_peer_PCG_W2,  # Noncognitive (raw)
    PCG_Educ_W2, SCG_Educ_W2, Income_equi,  # Socioeconomic (raw)
    DEIS_binary_W2, Fee_paying_W2, Mixed  # School indicators (if needed later)
  )

# Rename and invert SDQ scales (higher = worse)
ml_data <- ml_data %>%
  rename(
    SDQ_emot_res_PCG_W2 = SDQ_emot_PCG_W2,  # Emotional Resilience
    SDQ_good_cond_PCG_W2 = SDQ_cond_PCG_W2,  # Good Conduct
    SDQ_focused_beha_PCG_W2 = SDQ_hyper_PCG_W2,  # Focused Behaviour
    SDQ_positive_peer_PCG_W2 = SDQ_peer_PCG_W2  # Positive Peer Relationships
  ) %>%
  mutate(
    SDQ_emot_PCG_W2 = 10 - SDQ_emot_res_PCG_W2,
    SDQ_cond_PCG_W2 = 10 - SDQ_good_cond_PCG_W2,
    SDQ_hyper_PCG_W2 = 10 - SDQ_focused_beha_PCG_W2,
    SDQ_peer_PCG_W2 = 10 - SDQ_positive_peer_PCG_W2
  )

# Standardize variables
ml_data <- ml_data %>%
  mutate(
    Drum_VR_W2_p_std = scale(Drum_VR_W2_p)[,1],
    Drum_NA_W2_p_std = scale(Drum_NA_W2_p)[,1],
    BAS_TS_Mat_W2_std = scale(BAS_TS_Mat_W2)[,1],
    PCG_Educ_W2_std = scale(PCG_Educ_W2)[,1],
    SCG_Educ_W2_std = scale(SCG_Educ_W2)[,1],
    Income_equi_std = scale(Income_equi)[,1]
  )

# PREPARING THE DATA -----------------------------------------------------------
ml_data_complete <- na.omit(ml_data)
# 2. Let's check missing values
missing_summary <- sapply(ml_data, function(x) sum(is.na(x)))
print("Missing values per variable:")
print(missing_summary)

# Standardize SDQ variables (z-score transformation)
ml_data_complete <- ml_data_complete %>%
  mutate(
    SDQ_emot_PCG_W2_std = scale(SDQ_emot_PCG_W2, center = TRUE, scale = TRUE)[,1],
    SDQ_cond_PCG_W2_std = scale(SDQ_cond_PCG_W2, center = TRUE, scale = TRUE)[,1],
    SDQ_hyper_PCG_W2_std = scale(SDQ_hyper_PCG_W2, center = TRUE, scale = TRUE)[,1],
    SDQ_peer_PCG_W2_std = scale(SDQ_peer_PCG_W2, center = TRUE, scale = TRUE)[,1]
  )


# Check if any missing values remain
sum(is.na(ml_data_complete)) # Should return 0
dim(ml_data_complete) # Check how many rows remain after dropping NAs

# Define percentiles for classification
p25 <- function(x) quantile(x, 0.25, na.rm = TRUE)  # 25th percentile
p75 <- function(x) quantile(x, 0.75, na.rm = TRUE)  # 75th percentile

# Calculate new cutoffs
sdq_cutoffs <- ml_data_complete %>%
  summarise(
    SDQ_emot_75 = p75(SDQ_emot_PCG_W2),
    SDQ_cond_75 = p75(SDQ_cond_PCG_W2),
    SDQ_hyper_75 = p75(SDQ_hyper_PCG_W2),
    SDQ_peer_75 = p75(SDQ_peer_PCG_W2),
    SDQ_emot_25 = p25(SDQ_emot_PCG_W2),
    SDQ_cond_25 = p25(SDQ_cond_PCG_W2),
    SDQ_hyper_25 = p25(SDQ_hyper_PCG_W2),
    SDQ_peer_25 = p25(SDQ_peer_PCG_W2)
  )


# Assign risk groups based on multiple high/low SDQ scores
ml_data_complete <- ml_data_complete %>%
  mutate(
    high_sdq_count = (SDQ_emot_PCG_W2 >= sdq_cutoffs$SDQ_emot_75) +
      (SDQ_cond_PCG_W2 >= sdq_cutoffs$SDQ_cond_75) +
      (SDQ_hyper_PCG_W2 >= sdq_cutoffs$SDQ_hyper_75) +
      (SDQ_peer_PCG_W2 >= sdq_cutoffs$SDQ_peer_75),
    
    low_sdq_count = (SDQ_emot_PCG_W2 <= sdq_cutoffs$SDQ_emot_25) +
      (SDQ_cond_PCG_W2 <= sdq_cutoffs$SDQ_cond_25) +
      (SDQ_hyper_PCG_W2 <= sdq_cutoffs$SDQ_hyper_25) +
      (SDQ_peer_PCG_W2 <= sdq_cutoffs$SDQ_peer_25),
    
    risk_group = case_when(
      high_sdq_count >= 2 ~ "High Risk",     # Keeping this as is because higher SDQ = more problems
      low_sdq_count >= 2 ~ "Low Risk",
      TRUE ~ "Moderate Risk"
    )
  )

# Check the new distribution
table(ml_data_complete$risk_group)

# Calculate math percentiles and resilience in one step (across ALL students)
ml_data_complete <- ml_data_complete %>%
  mutate(
    maths_percentile = percent_rank(Maths_points),  # Calculate across all students
    resilience = case_when(
      risk_group %in% c("High Risk", "Moderate Risk") & maths_percentile >= 0.70 ~ "Resilient",
      risk_group %in% c("High Risk", "Moderate Risk") & maths_percentile < 0.70 ~ "Non-Resilient",
      risk_group == "Low Risk" ~ "Not Applicable"
    )
  )

# Check risk group distribution
table(ml_data_complete$risk_group)

# Check math scores by risk group
ml_data_complete %>%
  group_by(risk_group) %>%
  summarise(
    mean_score = mean(Maths_points),
    sd_score = sd(Maths_points)
  )

# Check resilience distribution
table(ml_data_complete$resilience, ml_data_complete$risk_group)

# Assign risk groups based on multiple high/low SDQ scores
# ml_data_complete <- ml_data_complete %>%
#  mutate(
#    high_sdq_count = (SDQ_emot_PCG_W2 >= sdq_cutoffs$SDQ_emot_75) +
#      (SDQ_cond_PCG_W2 >= sdq_cutoffs$SDQ_cond_75) +
#      (SDQ_hyper_PCG_W2 >= sdq_cutoffs$SDQ_hyper_75) +
#      (SDQ_peer_PCG_W2 >= sdq_cutoffs$SDQ_peer_75),
    
#    low_sdq_count = (SDQ_emot_PCG_W2 <= sdq_cutoffs$SDQ_emot_25) +
#      (SDQ_cond_PCG_W2 <= sdq_cutoffs$SDQ_cond_25) +
#      (SDQ_hyper_PCG_W2 <= sdq_cutoffs$SDQ_hyper_25) +
#      (SDQ_peer_PCG_W2 <= sdq_cutoffs$SDQ_peer_25),
    
#    risk_group = case_when(
#      high_sdq_count >= 2 ~ "High Risk",
#      low_sdq_count >= 2 ~ "Low Risk",
#      TRUE ~ "Moderate Risk"
#    )
#  )

# Check the new distribution
# table(ml_data_complete$risk_group)

# Compute Maths performance percentiles within each risk group
# ml_data_complete <- ml_data_complete %>%
# group_by(risk_group) %>%
#  mutate(
#    maths_percentile = percent_rank(Maths_points) # Rank Maths scores within each risk group
#  ) %>%
#  ungroup()

# Define resilience within each risk group
# ml_data_complete <- ml_data_complete %>%
#  mutate(
#    resilience = case_when(
#      risk_group %in% c("High Risk", "Moderate Risk") & maths_percentile >= 0.70 ~ "Resilient",
#      risk_group %in% c("High Risk", "Moderate Risk") & maths_percentile < 0.70 ~ "Non-Resilient",
#      risk_group == "Low Risk" ~ "Not Applicable"
#    )
#  )

# Check distribution of resilience groups
# table(ml_data_complete$resilience, ml_data_complete$risk_group)

# SUMMARY STATS------------------------------------------------------------
# Load necessary libraries
library(tidyverse)

# Compare means and standard deviations across resilience groups
summary_stats <- ml_data_complete %>%
  filter(resilience %in% c("Resilient", "Non-Resilient")) %>%
  group_by(resilience) %>%
  summarise(
    Maths_points_mean = mean(Maths_points, na.rm = TRUE),
    Maths_points_sd = sd(Maths_points, na.rm = TRUE),
    # Cognitive (standardized)
    Drum_VR_W2_p_std_mean = mean(Drum_VR_W2_p_std, na.rm = TRUE),
    Drum_VR_W2_p_std_sd = sd(Drum_VR_W2_p_std, na.rm = TRUE),
    Drum_NA_W2_p_std_mean = mean(Drum_NA_W2_p_std, na.rm = TRUE),
    Drum_NA_W2_p_std_sd = sd(Drum_NA_W2_p_std, na.rm = TRUE),
    BAS_TS_Mat_W2_std_mean = mean(BAS_TS_Mat_W2_std, na.rm = TRUE),
    BAS_TS_Mat_W2_std_sd = sd(BAS_TS_Mat_W2_std, na.rm = TRUE),
    # Noncognitive (Original Scale)
    SDQ_emot_PCG_W2_mean = mean(SDQ_emot_PCG_W2, na.rm = TRUE),
    SDQ_emot_PCG_W2_sd = sd(SDQ_emot_PCG_W2, na.rm = TRUE),
    SDQ_cond_PCG_W2_mean = mean(SDQ_cond_PCG_W2, na.rm = TRUE),
    SDQ_cond_PCG_W2_sd = sd(SDQ_cond_PCG_W2, na.rm = TRUE),
    SDQ_hyper_PCG_W2_mean = mean(SDQ_hyper_PCG_W2, na.rm = TRUE),
    SDQ_hyper_PCG_W2_sd = sd(SDQ_hyper_PCG_W2, na.rm = TRUE),
    SDQ_peer_PCG_W2_mean = mean(SDQ_peer_PCG_W2, na.rm = TRUE),
    SDQ_peer_PCG_W2_sd = sd(SDQ_peer_PCG_W2, na.rm = TRUE),
    # Socioeconomic (Standardized)
    PCG_Educ_W2_std_mean = mean(PCG_Educ_W2_std, na.rm = TRUE),
    PCG_Educ_W2_std_sd = sd(PCG_Educ_W2_std, na.rm = TRUE),
    SCG_Educ_W2_std_mean = mean(SCG_Educ_W2_std, na.rm = TRUE),
    SCG_Educ_W2_std_sd = sd(SCG_Educ_W2_std, na.rm = TRUE),
    Income_equi_std_mean = mean(Income_equi_std, na.rm = TRUE),
    Income_equi_std_sd = sd(Income_equi_std, na.rm = TRUE)
  )

print(summary_stats, width = Inf)

# PLOTS ------------------------------------------------------------
# Histogram of Maths points by resilience status
ggplot(ml_data_complete, aes(x = Maths_points, fill = resilience)) +
  geom_histogram(binwidth = 1, alpha = 0.7, position = "identity") +
  facet_wrap(~ risk_group) +
  theme_minimal() +
  labs(title = "Distribution of Maths Scores by Resilience and Risk Group",
       x = "Maths Points", y = "Count") +
  scale_fill_manual(values = c("Resilient" = "blue", "Non-Resilient" = "red"))

# Density plot of Maths Points by Resilience within Risk Groups
ggplot(ml_data_complete, aes(x = Maths_points, fill = resilience)) +
  geom_density(alpha = 0.5) +
  facet_wrap(~ risk_group) +
  theme_minimal() +
  labs(title = "Density Distribution of Maths Scores by Resilience and Risk Group",
       x = "Maths Points", y = "Density") +
  scale_fill_manual(values = c("Resilient" = "blue", "Non-Resilient" = "red"))

# Jitter plot to visualize distribution by risk group
ggplot(ml_data_complete, aes(x = risk_group, y = Maths_points, color = resilience)) +
  geom_jitter(alpha = 0.5, width = 0.2) +
  theme_minimal() +
  labs(title = "Jitter Plot of Maths Scores by Risk Group and Resilience",
       x = "Risk Group", y = "Maths Points") +
  scale_color_manual(values = c("Resilient" = "blue", "Non-Resilient" = "red"))

# Bar plot: Resilience by gender and risk group
ggplot(gender_resilience_risk_dist, aes(x = risk_group, y = Percentage, fill = resilience)) +
  geom_bar(stat = "identity", position = "fill") +  # Normalize within each risk group
  facet_wrap(~Gender_factor) +  # Separate by gender
  theme_minimal() +
  labs(title = "Resilience by Gender and Risk Group",
       x = "Risk Group",
       y = "Proportion of Students",
       fill = "Resilience Status") +
  scale_fill_manual(values = c("Resilient" = "blue", "Non-Resilient" = "red"))


# ML ------------------------------------------------------------------
# RANDOM FOREST
table(ml_data_complete$resilience, useNA = "always")


# Load required libraries
library(tidyverse)
library(randomForest)
library(caret)

# Define predictors (excluding Maths_points and Gender)
predictor_vars <- c(
  "Drum_VR_W2_p_std", "Drum_NA_W2_p_std", "BAS_TS_Mat_W2_std", # Cognitive
  "SDQ_emot_PCG_W2", "SDQ_cond_PCG_W2", "SDQ_hyper_PCG_W2", "SDQ_peer_PCG_W2", # Use raw SDQ scores
  "PCG_Educ_W2_std", "SCG_Educ_W2_std", "Income_equi_std" # Socioeconomic
)
# Prepare the dataset (fixing the issue)
rf_data <- ml_data_complete %>%
  filter(resilience %in% c("Resilient", "Non-Resilient")) %>%  # Exclude "Not Applicable"
  select(all_of(predictor_vars), resilience) %>%
  drop_na() %>%  # Remove remaining NAs
  mutate(resilience = factor(resilience, levels = c("Non-Resilient", "Resilient"))) # Convert to factor
table(rf_data$resilience, useNA = "always")


# Split the dataset into training (70%) and testing (30%)
set.seed(123)
train_index <- createDataPartition(rf_data$resilience, p = 0.7, list = FALSE)
train_data <- rf_data[train_index, ]
test_data <- rf_data[-train_index, ]

# Train the Random Forest model
set.seed(123)
rf_model <- randomForest(resilience ~ ., data = train_data, ntree = 500, mtry = 3, importance = TRUE)

# Print model summary
print(rf_model)

# Predict on test data
rf_predictions <- predict(rf_model, newdata = test_data, type = "response")

# Compute accuracy
conf_matrix <- confusionMatrix(rf_predictions, test_data$resilience)
print(conf_matrix)

# Extract variable importance
rf_importance <- as.data.frame(importance(rf_model))
rf_importance$Predictors <- rownames(rf_importance)
rf_importance <- rf_importance %>%
  arrange(desc(MeanDecreaseGini))

# Plot variable importance
ggplot(rf_importance, aes(x = reorder(Predictors, MeanDecreaseGini), y = MeanDecreaseGini)) +
  geom_bar(stat = "identity", fill = "pink") +
  coord_flip() +
  theme_minimal() +
  labs(title = "Variable Importance in Predicting Resilience",
       x = "Predictors", y = "Importance (Gini Decrease)")

# GBM and XGBoost
library(tidyverse)
library(caret)
library(gbm)
library(xgboost)
library(glmnet)

# Define predictors (same as before)
predictor_vars <- c(
  "Drum_VR_W2_p_std", "Drum_NA_W2_p_std", "BAS_TS_Mat_W2_std", # Cognitive
  "SDQ_emot_PCG_W2", "SDQ_cond_PCG_W2", "SDQ_hyper_PCG_W2", "SDQ_peer_PCG_W2", # Use raw SDQ scores consistently
  "PCG_Educ_W2_std", "SCG_Educ_W2_std", "Income_equi_std" # Socioeconomic
)

# Prepare the dataset 
rf_data <- ml_data_complete %>%
  filter(resilience %in% c("Resilient", "Non-Resilient")) %>%  # Exclude "Not Applicable"
  select(all_of(predictor_vars), resilience) %>%
  drop_na() %>%  # Remove remaining NAs
  mutate(resilience = factor(resilience, levels = c("Non-Resilient", "Resilient"))) # Convert to factor
table(rf_data$resilience, useNA = "always")

# Split the dataset into training (70%) and testing (30%)

set.seed(123)
train_index <- createDataPartition(rf_data$resilience, p = 0.7, list = FALSE)
train_data <- rf_data[train_index, ]
test_data <- rf_data[-train_index, ]

# Train GBM model
set.seed(123)
gbm_model <- gbm(
  formula = as.numeric(resilience) - 1 ~ .,  # Convert factor to numeric (0,1)
  data = train_data,
  distribution = "bernoulli",  # Binary classification
  n.trees = 500,
  interaction.depth = 3,
  shrinkage = 0.01,
  cv.folds = 5,
  n.minobsinnode = 10
)

# Predict on test data
gbm_predictions <- predict(gbm_model, newdata = test_data, n.trees = 500, type = "response")
gbm_pred_class <- ifelse(gbm_predictions > 0.5, "Resilient", "Non-Resilient")

# Evaluate performance
gbm_conf_matrix <- confusionMatrix(factor(gbm_pred_class, levels = c("Non-Resilient", "Resilient")), test_data$resilience)
print(gbm_conf_matrix)
summary(gbm_model)

# Convert data to XGBoost matrix format
train_x <- as.matrix(train_data %>% select(-resilience))
train_y <- as.numeric(train_data$resilience) - 1  # Convert to binary (0,1)
test_x <- as.matrix(test_data %>% select(-resilience))
test_y <- as.numeric(test_data$resilience) - 1  # Convert to binary (0,1)

# Train XGBoost model
set.seed(123)
xgb_model <- xgboost(
  data = train_x,
  label = train_y,
  objective = "binary:logistic",
  nrounds = 500,
  max_depth = 3,
  eta = 0.01,
  eval_metric = "error",
  verbose = 0
)

# Predict on test data
xgb_predictions <- predict(xgb_model, test_x)
xgb_pred_class <- ifelse(xgb_predictions > 0.5, "Resilient", "Non-Resilient")

# Evaluate performance
xgb_conf_matrix <- confusionMatrix(factor(xgb_pred_class, levels = c("Non-Resilient", "Resilient")), test_data$resilience)
print(xgb_conf_matrix)

summary(xgb_model)

# LASSO

# Load necessary libraries
library(glmnet)
library(caret)
library(tidyverse)

# Define predictors (same as before)
predictor_vars <- c(
  "Drum_VR_W2_p_std", "Drum_NA_W2_p_std", "BAS_TS_Mat_W2_std", # Cognitive
  "SDQ_emot_PCG_W2", "SDQ_cond_PCG_W2", "SDQ_hyper_PCG_W2", "SDQ_peer_PCG_W2", # Raw SDQ scores
  "PCG_Educ_W2_std", "SCG_Educ_W2_std", "Income_equi_std" # Socioeconomic
)

# Prepare the dataset (removing "Not Applicable" and NAs)
lasso_data <- ml_data_complete %>%
  filter(resilience %in% c("Resilient", "Non-Resilient")) %>%
  select(all_of(predictor_vars), resilience) %>%
  drop_na() %>%
  mutate(resilience = ifelse(resilience == "Resilient", 1, 0)) # Convert outcome to binary (0 = Non-Resilient, 1 = Resilient)

# Convert to matrix format for glmnet
X <- as.matrix(lasso_data %>% select(-resilience)) # Predictors
y <- as.vector(lasso_data$resilience) # Outcome variable

# Set up cross-validation to find optimal lambda
set.seed(123)
lasso_cv <- cv.glmnet(X, y, family = "binomial", alpha = 1, nfolds = 10) # Lasso (alpha = 1)

# Extract the best lambda value
best_lambda <- lasso_cv$lambda.min

# Fit the final model using best lambda
lasso_model <- glmnet(X, y, family = "binomial", alpha = 1, lambda = best_lambda)


# Extract coefficients as a matrix
lasso_coeffs <- coef(lasso_model) %>%
  as.matrix() %>%
  as.data.frame() %>%
  rownames_to_column(var = "Variable") 

# Identify the column name dynamically
col_name <- colnames(lasso_coeffs)[2]  # The second column contains coefficients

# Filter only nonzero coefficients
lasso_coeffs <- lasso_coeffs %>%
  filter(!!sym(col_name) != 0)

# Print selected features
print(lasso_coeffs)


# Split the dataset into training (70%) and testing (30%)
set.seed(123)
train_index <- createDataPartition(y, p = 0.7, list = FALSE)
train_X <- X[train_index, ]
train_y <- y[train_index]
test_X <- X[-train_index, ]
test_y <- y[-train_index]

# Predict probabilities on test set
lasso_prob <- predict(lasso_model, newx = test_X, type = "response")

# Convert probabilities to binary (default threshold 0.5)
lasso_pred <- ifelse(lasso_prob >= 0.5, 1, 0)

# Compute confusion matrix
lasso_conf_matrix <- confusionMatrix(factor(lasso_pred, levels = c(0, 1)), factor(test_y, levels = c(0, 1)))

# Print results
print(lasso_conf_matrix)

# SEPARATING BY GENDER ----------------------------------------------------------

# LASSO

# Define predictors (excluding Maths_points and Gender)
predictor_vars <- c(
  "Drum_VR_W2_p_std", "Drum_NA_W2_p_std", "BAS_TS_Mat_W2_std", # Cognitive
  "SDQ_emot_PCG_W2", "SDQ_cond_PCG_W2", "SDQ_hyper_PCG_W2", "SDQ_peer_PCG_W2", # Raw SDQ scores
  "PCG_Educ_W2_std", "SCG_Educ_W2_std", "Income_equi_std" # Socioeconomic
)

# Split the dataset by gender
ml_data_male <- ml_data_complete %>% filter(Gender_factor == "Male", resilience %in% c("Resilient", "Non-Resilient"))
ml_data_female <- ml_data_complete %>% filter(Gender_factor == "Female", resilience %in% c("Resilient", "Non-Resilient"))

# Define a function to run Lasso for each gender
run_lasso <- function(data, gender) {
  # Prepare X and y
  X <- as.matrix(data %>% select(all_of(predictor_vars))) # Features
  y <- as.factor(data$resilience) # Outcome variable
  
  # Split into training (70%) and testing (30%)
  set.seed(123)
  train_index <- createDataPartition(y, p = 0.7, list = FALSE)
  X_train <- X[train_index, ]
  y_train <- y[train_index]
  X_test <- X[-train_index, ]
  y_test <- y[-train_index]
  
  # Standardize predictors
  X_train_scaled <- scale(X_train)
  X_test_scaled <- scale(X_test, center = attr(X_train_scaled, "scaled:center"), scale = attr(X_train_scaled, "scaled:scale"))
  
  # Train Lasso with cross-validation
  cv_lasso <- cv.glmnet(X_train_scaled, y_train, family = "binomial", alpha = 1)
  best_lambda <- cv_lasso$lambda.min
  
  # Fit final model using best lambda
  lasso_model <- glmnet(X_train_scaled, y_train, family = "binomial", alpha = 1, lambda = best_lambda)
  
  # Extract nonzero coefficients
  lasso_coeffs <- coef(lasso_model) %>%
    as.matrix() %>%
    as.data.frame() %>%
    rownames_to_column(var = "Variable") %>%
    filter(s0 != 0)  # Keep only nonzero coefficients
  
  # Predict on test set
  predictions <- predict(lasso_model, newx = X_test_scaled, type = "class")
  
  # Compute confusion matrix
  conf_matrix <- confusionMatrix(factor(predictions, levels = levels(y_test)), y_test)
  
  # Return results
  return(list(
    gender = gender,
    coefficients = lasso_coeffs,
    confusion_matrix = conf_matrix
  ))
}

# Run Lasso for Males and Females
lasso_male_results <- run_lasso(ml_data_male, "Male")
lasso_female_results <- run_lasso(ml_data_female, "Female")

# Print results
print("Lasso Results for Males:")
print(lasso_male_results$coefficients)

print("Confusion Matrix for Males:")
print(lasso_male_results$confusion_matrix)

print("Lasso Results for Females:")
print(lasso_female_results$coefficients)

print("Confusion Matrix for Females:")
print(lasso_female_results$confusion_matrix)


# DEALING WITH SAMPLE IMBALANCE------------------------------------

# Load additional library for SMOTE
library(ROSE)

# 1. Using SMOTE to balance classes
set.seed(123)
smote_data <- ROSE::ROSE(resilience ~ ., data = train_data, N = 2*nrow(train_data))$data
table(smote_data$resilience) # Check new class distribution

# Train RF with SMOTE-balanced data
rf_model_smote <- randomForest(resilience ~ ., 
                               data = smote_data, 
                               ntree = 500, 
                               mtry = 3, 
                               importance = TRUE)

# 2. Using class weights
# Calculate class weights inversely proportional to class frequencies
class_weights <- nrow(train_data) / (2 * table(train_data$resilience))
rf_model_weighted <- randomForest(resilience ~ ., 
                                  data = train_data, 
                                  ntree = 500, 
                                  mtry = 3,
                                  classwt = class_weights,
                                  importance = TRUE)

# 3. Using undersampling
# Function to undersample majority class
undersample <- function(data, ratio = 1) {
  resilient_cases <- data[data$resilience == "Resilient", ]
  n_resilient <- nrow(resilient_cases)
  
  non_resilient_cases <- data[data$resilience == "Non-Resilient", ]
  non_resilient_sample <- non_resilient_cases[sample(nrow(non_resilient_cases), 
                                                     size = n_resilient * ratio), ]
  
  return(rbind(resilient_cases, non_resilient_sample))
}

# Create balanced dataset with 2:1 ratio of non-resilient to resilient
balanced_data <- undersample(train_data, ratio = 2)
table(balanced_data$resilience) # Check new distribution

rf_model_balanced <- randomForest(resilience ~ ., 
                                  data = balanced_data, 
                                  ntree = 500, 
                                  mtry = 3, 
                                  importance = TRUE)

# Compare models using test data
models <- list(
  SMOTE = rf_model_smote,
  Weighted = rf_model_weighted,
  Balanced = rf_model_balanced
)

# Function to evaluate model performance
evaluate_model <- function(model, test_data) {
  predictions <- predict(model, newdata = test_data)
  conf_matrix <- confusionMatrix(predictions, test_data$resilience)
  
  return(list(
    accuracy = conf_matrix$overall["Accuracy"],
    balanced_accuracy = conf_matrix$byClass["Balanced Accuracy"],
    sensitivity = conf_matrix$byClass["Sensitivity"],
    specificity = conf_matrix$byClass["Specificity"],
    f1_score = conf_matrix$byClass["F1"]
  ))
}

# Compare results
results <- lapply(models, evaluate_model, test_data)
results_df <- do.call(rbind, lapply(results, unlist))
print(results_df)

# Evaluation metrics more suitable for imbalanced data ------------------------

# Enhanced evaluation function with metrics for imbalanced data
evaluate_model_imbalanced <- function(model, test_data) {
  predictions <- predict(model, newdata = test_data)
  conf_matrix <- confusionMatrix(predictions, test_data$resilience)
  
  # Get raw confusion matrix values
  TP <- conf_matrix$table[2,2]  # True Positives (Resilient correctly identified)
  TN <- conf_matrix$table[1,1]  # True Negatives (Non-Resilient correctly identified)
  FP <- conf_matrix$table[2,1]  # False Positives
  FN <- conf_matrix$table[1,2]  # False Negatives
  
  # Calculate additional metrics
  precision <- TP / (TP + FP)
  recall <- TP / (TP + FN)  # Same as Sensitivity
  g_mean <- sqrt(recall * (TN/(TN + FP)))  # Geometric mean of recall and specificity
  
  # Matthews Correlation Coefficient (MCC)
  mcc_numerator <- (TP * TN) - (FP * FN)
  mcc_denominator <- sqrt((TP + FP) * (TP + FN) * (TN + FP) * (TN + FN))
  mcc <- mcc_numerator / mcc_denominator
  
  return(list(
    precision = precision,
    recall = recall,
    g_mean = g_mean,
    mcc = mcc,
    ppv = conf_matrix$byClass["Pos Pred Value"],  # Positive Predictive Value
    npv = conf_matrix$byClass["Neg Pred Value"],  # Negative Predictive Value
    auc = conf_matrix$byClass["Balanced Accuracy"]  # Approximation of AUC
  ))
}

# Apply new metrics to all models
new_results <- lapply(models, evaluate_model_imbalanced, test_data)
new_results_df <- do.call(rbind, lapply(new_results, unlist))
print(new_results_df)


# TESTING OTHER MODEL EVALS -------------------------------------------

# Load required libraries
library(tidyverse)
library(randomForest)
library(caret)
library(ROSE)
library(xgboost)

# Define predictors (excluding Maths_points and Gender)
predictor_vars <- c(
  "Drum_VR_W2_p_std", "Drum_NA_W2_p_std", "BAS_TS_Mat_W2_std", # Cognitive
  "SDQ_emot_PCG_W2", "SDQ_cond_PCG_W2", "SDQ_hyper_PCG_W2", "SDQ_peer_PCG_W2", # Use raw SDQ scores
  "PCG_Educ_W2_std", "SCG_Educ_W2_std", "Income_equi_std" # Socioeconomic
)

# Prepare the dataset for ML
rf_data <- ml_data_complete %>%
  filter(resilience %in% c("Resilient", "Non-Resilient")) %>%  # Exclude "Not Applicable"
  select(all_of(predictor_vars), resilience) %>%
  drop_na() %>%  # Remove remaining NAs
  mutate(resilience = factor(resilience, levels = c("Non-Resilient", "Resilient"))) # Convert to factor

# Check class distribution
table(rf_data$resilience, useNA = "always")

# Split the dataset into training (70%) and testing (30%)
set.seed(123)
train_index <- createDataPartition(rf_data$resilience, p = 0.7, list = FALSE)
train_data <- rf_data[train_index, ]
test_data <- rf_data[-train_index, ]

# 1. RANDOM FOREST WITH DIFFERENT BALANCING APPROACHES -------------------------

# A. SMOTE balancing
smote_data <- ROSE::ROSE(resilience ~ ., data = train_data, N = 2*nrow(train_data))$data
table(smote_data$resilience) # Check new class distribution

rf_model_smote <- randomForest(resilience ~ ., 
                               data = smote_data, 
                               ntree = 500, 
                               mtry = 3, 
                               importance = TRUE)

# B. Class weights
class_weights <- nrow(train_data) / (2 * table(train_data$resilience))
rf_model_weighted <- randomForest(resilience ~ ., 
                                  data = train_data, 
                                  ntree = 500, 
                                  mtry = 3,
                                  classwt = class_weights,
                                  importance = TRUE)

# C. Undersampling
undersample <- function(data, ratio = 1) {
  resilient_cases <- data[data$resilience == "Resilient", ]
  n_resilient <- nrow(resilient_cases)
  
  non_resilient_cases <- data[data$resilience == "Non-Resilient", ]
  non_resilient_sample <- non_resilient_cases[sample(nrow(non_resilient_cases), 
                                                     size = n_resilient * ratio), ]
  
  return(rbind(resilient_cases, non_resilient_sample))
}

balanced_data <- undersample(train_data, ratio = 2)
table(balanced_data$resilience) # Check new distribution

rf_model_balanced <- randomForest(resilience ~ ., 
                                  data = balanced_data, 
                                  ntree = 500, 
                                  mtry = 3, 
                                  importance = TRUE)

# 2. XGBOOST MODEL ----------------------------------------------------------

# Prepare data for XGBoost
prepare_xgb_data <- function(data) {
  x_data <- data.matrix(data[, !names(data) %in% "resilience"])
  y_data <- as.numeric(data$resilience) - 1  # Convert to 0/1
  return(list(x = x_data, y = y_data))
}

# Prepare training and test data
train_xgb <- prepare_xgb_data(train_data)
test_xgb <- prepare_xgb_data(test_data)

# Create XGBoost matrices
dtrain <- xgb.DMatrix(train_xgb$x, label = train_xgb$y)
dtest <- xgb.DMatrix(test_xgb$x, label = test_xgb$y)

# XGBoost parameters
xgb_params <- list(
  objective = "binary:logistic",
  eval_metric = "auc",
  scale_pos_weight = sum(train_xgb$y == 0) / sum(train_xgb$y == 1),
  max_depth = 3,
  eta = 0.01,
  subsample = 0.8,
  colsample_bytree = 0.8
)

# Train XGBoost model
xgb_model <- xgb.train(
  params = xgb_params,
  data = dtrain,
  nrounds = 1000,
  watchlist = list(train = dtrain, test = dtest),
  early_stopping_rounds = 50,
  verbose = 1
)

# 3. MODEL EVALUATION ------------------------------------------------------

# Enhanced evaluation function with metrics for imbalanced data
evaluate_model_imbalanced <- function(model, test_data) {
  predictions <- predict(model, newdata = test_data)
  conf_matrix <- confusionMatrix(predictions, test_data$resilience)
  
  # Get raw confusion matrix values
  TP <- conf_matrix$table[2,2]  # True Positives (Resilient correctly identified)
  TN <- conf_matrix$table[1,1]  # True Negatives (Non-Resilient correctly identified)
  FP <- conf_matrix$table[2,1]  # False Positives
  FN <- conf_matrix$table[1,2]  # False Negatives
  
  # Calculate additional metrics
  precision <- TP / (TP + FP)
  recall <- TP / (TP + FN)  # Same as Sensitivity
  g_mean <- sqrt(recall * (TN/(TN + FP)))  # Geometric mean of recall and specificity
  
  # Matthews Correlation Coefficient (MCC)
  mcc_numerator <- (TP * TN) - (FP * FN)
  mcc_denominator <- sqrt((TP + FP) * (TP + FN) * (TN + FP) * (TN + FN))
  mcc <- mcc_numerator / mcc_denominator
  
  return(list(
    precision = precision,
    recall = recall,
    g_mean = g_mean,
    mcc = mcc,
    ppv = conf_matrix$byClass["Pos Pred Value"],
    npv = conf_matrix$byClass["Neg Pred Value"],
    auc = conf_matrix$byClass["Balanced Accuracy"]
  ))
}

# Evaluate Random Forest models
models <- list(
  SMOTE = rf_model_smote,
  Weighted = rf_model_weighted,
  Balanced = rf_model_balanced
)

# Compare results for RF models
rf_results <- lapply(models, evaluate_model_imbalanced, test_data)
rf_results_df <- do.call(rbind, lapply(rf_results, unlist))
print("Random Forest Results:")
print(rf_results_df)

# For XGBoost evaluation
evaluate_xgboost <- function(predictions, test_data) {
  # Convert probabilities to class predictions
  pred_class <- factor(ifelse(predictions > 0.5, "Resilient", "Non-Resilient"),
                       levels = levels(test_data$resilience))
  
  # Create confusion matrix
  conf_matrix <- confusionMatrix(pred_class, test_data$resilience)
  
  # Get raw confusion matrix values
  TP <- conf_matrix$table[2,2]  # True Positives (Resilient correctly identified)
  TN <- conf_matrix$table[1,1]  # True Negatives (Non-Resilient correctly identified)
  FP <- conf_matrix$table[2,1]  # False Positives
  FN <- conf_matrix$table[1,2]  # False Negatives
  
  # Calculate additional metrics
  precision <- TP / (TP + FP)
  recall <- TP / (TP + FN)  # Same as Sensitivity
  g_mean <- sqrt(recall * (TN/(TN + FP)))  # Geometric mean of recall and specificity
  
  # Matthews Correlation Coefficient (MCC)
  mcc_numerator <- (TP * TN) - (FP * FN)
  mcc_denominator <- sqrt((TP + FP) * (TP + FN) * (TN + FP) * (TN + FN))
  mcc <- mcc_numerator / mcc_denominator
  
  return(list(
    precision = precision,
    recall = recall,
    g_mean = g_mean,
    mcc = mcc,
    ppv = conf_matrix$byClass["Pos Pred Value"],
    npv = conf_matrix$byClass["Neg Pred Value"],
    auc = conf_matrix$byClass["Balanced Accuracy"]
  ))
}

# Evaluate XGBoost
xgb_results <- evaluate_xgboost(xgb_pred_prob, test_data)
print("\nXGBoost Results:")
print(unlist(xgb_results))


# CHOSING THE BETTER MODEL EVAL -------------------

# Get feature importance from the SMOTE Random Forest model
importance_df <- as.data.frame(importance(rf_model_smote))
importance_df$Feature <- rownames(importance_df)

# Sort by Mean Decrease in Gini
importance_df <- importance_df %>%
  arrange(desc(MeanDecreaseGini))

# View results
print(importance_df)

# Create a clear visualization
ggplot(importance_df, aes(x = reorder(Feature, MeanDecreaseGini), y = MeanDecreaseGini)) +
  geom_bar(stat = "identity", fill = "steelblue") +
  coord_flip() +
  theme_minimal() +
  labs(
    title = "Factors Contributing to Educational Resilience",
    x = "Factors",
    y = "Relative Importance"
  )

# SALVING THE DATASETS ------------------------------------------------------------
write.csv(ml_data, "ml_data.csv", row.names = FALSE)
write.csv(ml_data_complete, "ml_data_complete.csv", row.names = FALSE)