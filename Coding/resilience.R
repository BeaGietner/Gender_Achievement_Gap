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
      high_sdq_count >= 2 ~ "High Risk",
      low_sdq_count >= 2 ~ "Low Risk",
      TRUE ~ "Moderate Risk"
    )
  )

# Check the new distribution
table(ml_data_complete$risk_group)

# Compute Maths performance percentiles within each risk group
ml_data_complete <- ml_data_complete %>%
  group_by(risk_group) %>%
  mutate(
    maths_percentile = percent_rank(Maths_points) # Rank Maths scores within each risk group
  ) %>%
  ungroup()

# Define resilience within each risk group
ml_data_complete <- ml_data_complete %>%
  mutate(
    resilience = case_when(
      risk_group %in% c("High Risk", "Moderate Risk") & maths_percentile >= 0.70 ~ "Resilient",
      risk_group %in% c("High Risk", "Moderate Risk") & maths_percentile < 0.70 ~ "Non-Resilient",
      risk_group == "Low Risk" ~ "Not Applicable"
    )
  )

# Check distribution of resilience groups
table(ml_data_complete$resilience, ml_data_complete$risk_group)

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
  "SDQ_emot_PCG_W2_std", "SDQ_cond_PCG_W2_std", "SDQ_hyper_PCG_W2_std", "SDQ_peer_PCG_W2_std", # Noncognitive
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
  "SDQ_emot_PCG_W2", "SDQ_cond_PCG_W2", "SDQ_hyper_PCG_W2", "SDQ_peer_PCG_W2", # Noncognitive
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
  "SDQ_emot_PCG_W2_std", "SDQ_cond_PCG_W2_std", "SDQ_hyper_PCG_W2_std", "SDQ_peer_PCG_W2_std", # Noncognitive (standardized)
  "PCG_Educ_W2_std", "SCG_Educ_W2_std", "Income_equi_std" # Socioeconomic (standardized)
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



# SALVING THE DATASETS ------------------------------------------------------------
write.csv(ml_data, "ml_data.csv", row.names = FALSE)
write.csv(ml_data_complete, "ml_data_complete.csv", row.names = FALSE)