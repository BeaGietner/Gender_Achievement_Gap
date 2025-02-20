# Load necessary libraries
library(tidyverse)


# Reload production_data (assuming it's already in your workspace)
ml_data_TIPI <- production_data %>%
  select(
    ID, Maths_points, Gender_factor,  # Outcomes & Demographics
    Drum_VR_W2_p, Drum_NA_W2_p, BAS_TS_Mat_W2,  # Cognitive (raw)
    Agreeable_W2_PCG, Emo_Stability_W2_PCG, Conscientious_W2_PCG, Extravert_W2_PCG, Openness_W2_PCG, # Noncognitive (raw)
    Agreeable_W2_PCG_std, Emo_Stability_W2_PCG_std, Conscientious_W2_PCG_std, Extravert_W2_PCG_std, Openness_W2_PCG_std, # Noncognitive (standardized)
    PCG_Educ_W2, SCG_Educ_W2, Income_equi,  # Socioeconomic (raw)
    DEIS_binary_W2, Fee_paying_W2, Mixed  # School indicators (if needed later)
  )

# PREPARING THE DATA -----------------------------------------------------------
ml_data_complete_TIPI <- na.omit(ml_data_TIPI)
# 2. Let's check missing values
missing_summary <- sapply(ml_data_TIPI, function(x) sum(is.na(x)))
print("Missing values per variable:")
print(missing_summary)

# Check if any missing values remain
sum(is.na(ml_data_complete_TIPI)) # Should return 0
dim(ml_data_complete_TIPI) # Check how many rows remain after dropping NAs


ml_data_complete_TIPI <- ml_data_complete_TIPI %>%
  mutate(
    Drum_VR_W2_p_std = scale(Drum_VR_W2_p)[,1],
    Drum_NA_W2_p_std = scale(Drum_NA_W2_p)[,1],
    BAS_TS_Mat_W2_std = scale(BAS_TS_Mat_W2)[,1],
    PCG_Educ_W2_std = scale(PCG_Educ_W2)[,1],
    SCG_Educ_W2_std = scale(SCG_Educ_W2)[,1],
    Income_equi_std = scale(Income_equi)[,1]
  )


# Define percentiles for classification
p25 <- function(x) quantile(x, 0.25, na.rm = TRUE)  # 25th percentile
p75 <- function(x) quantile(x, 0.75, na.rm = TRUE)  # 75th percentile

# Calculate cutoffs
TIPI_cutoffs <- ml_data_complete_TIPI %>%
  summarise(
    TIPI_Agree_75 = p75(Agreeable_W2_PCG),
    TIPI_Emo_75 = p75(Emo_Stability_W2_PCG),
    TIPI_Cons_75 = p75(Conscientious_W2_PCG),
    TIPI_Extra_75 = p75(Extravert_W2_PCG),
    TIPI_Open_75 = p75(Openness_W2_PCG),

    TIPI_Agree_25 = p25(Agreeable_W2_PCG),
    TIPI_Emo_25 = p25(Emo_Stability_W2_PCG),
    TIPI_Cons_25 = p25(Conscientious_W2_PCG),
    TIPI_Extra_25 = p25(Extravert_W2_PCG),
    TIPI_Open_25 = p25(Openness_W2_PCG),
  )


# Assign risk groups based on multiple high/low TIPI scores
ml_data_complete_TIPI <- ml_data_complete_TIPI %>%
  mutate(
    high_TIPI_count = 
      (Agreeable_W2_PCG >= TIPI_cutoffs$TIPI_Agree_75) +
      (Emo_Stability_W2_PCG >= TIPI_cutoffs$TIPI_Emo_75) +
      (Conscientious_W2_PCG >= TIPI_cutoffs$TIPI_Cons_75) +
      (Extravert_W2_PCG >= TIPI_cutoffs$TIPI_Extra_75) +
      (Openness_W2_PCG >= TIPI_cutoffs$TIPI_Open_75),
    
    low_TIPI_count = 
      (Agreeable_W2_PCG <= TIPI_cutoffs$TIPI_Agree_25) +
      (Emo_Stability_W2_PCG <= TIPI_cutoffs$TIPI_Emo_25) +
      (Conscientious_W2_PCG <= TIPI_cutoffs$TIPI_Cons_25) +
      (Extravert_W2_PCG <= TIPI_cutoffs$TIPI_Extra_25) +
      (Openness_W2_PCG <= TIPI_cutoffs$TIPI_Open_25),
    
    risk_group = case_when(
      low_TIPI_count >= 2 ~ "High Risk",     # Students with multiple low personality scores
      high_TIPI_count >= 2 ~ "Low Risk",     # Students with multiple high personality scores
      TRUE ~ "Moderate Risk"
    )
  )

# Then calculate math percentiles and resilience in one step
ml_data_complete_TIPI <- ml_data_complete_TIPI %>%
  mutate(
    maths_percentile = percent_rank(Maths_points),  # Calculate across all students
    resilience = case_when(
      risk_group %in% c("High Risk", "Moderate Risk") & maths_percentile >= 0.70 ~ "Resilient",
      risk_group %in% c("High Risk", "Moderate Risk") & maths_percentile < 0.70 ~ "Non-Resilient",
      risk_group == "Low Risk" ~ "Not Applicable"
    )
  )

# Check the new distribution
table(ml_data_complete_TIPI$risk_group)

# Compute Maths performance percentiles across ALL students
ml_data_complete_TIPI <- ml_data_complete_TIPI %>%
  mutate(
    maths_percentile = percent_rank(Maths_points) # Rank Maths scores across all students
  )

# Compute Maths performance percentiles within each risk group
# ml_data_complete_TIPI <- ml_data_complete_TIPI %>%
#  group_by(risk_group) %>%
#  mutate(
#    maths_percentile = percent_rank(Maths_points) # Rank Maths scores within each risk group
#  ) %>%
#  ungroup()

# Define resilience within each risk group
# ml_data_complete_TIPI <- ml_data_complete_TIPI %>%
#  mutate(
#    resilience = case_when(
#      risk_group %in% c("High Risk", "Moderate Risk") & maths_percentile >= 0.70 ~ "Resilient",
#      risk_group %in% c("High Risk", "Moderate Risk") & maths_percentile < 0.70 ~ "Non-Resilient",
#      risk_group == "Low Risk" ~ "Not Applicable"
#    )
#  )

# Check the distribution of math percentiles before we classify resilience
ml_data_complete_TIPI %>%
  group_by(risk_group) %>%
  summarise(
    min_percentile = min(maths_percentile),
    max_percentile = max(maths_percentile),
    mean_percentile = mean(maths_percentile)
  )

# Also let's look at the actual math scores by risk group
ml_data_complete_TIPI %>%
  group_by(risk_group) %>%
  summarise(
    mean_score = mean(Maths_points),
    sd_score = sd(Maths_points)
  )

# Check distribution of resilience groups
table(ml_data_complete_TIPI$resilience, ml_data_complete_TIPI$risk_group)

# SUMMARY STATS------------------------------------------------------------
# Load necessary libraries
library(tidyverse)

# Compare means and standard deviations across resilience groups
summary_stats <- ml_data_complete_TIPI %>%
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
    Agreeable_W2_PCG_mean = mean(Agreeable_W2_PCG, na.rm = TRUE),
    Agreeable_W2_PCG_sd = sd(Agreeable_W2_PCG, na.rm = TRUE),
    Emo_Stability_W2_PCG_mean = mean(Emo_Stability_W2_PCG, na.rm = TRUE),
    Emo_Stability_W2_PCG_sd = sd(Emo_Stability_W2_PCG, na.rm = TRUE),
    Conscientious_W2_PCG_mean = mean(Conscientious_W2_PCG, na.rm = TRUE),
    Conscientious_W2_PCG_sd = sd(Conscientious_W2_PCG, na.rm = TRUE),
    Extravert_W2_PCG_mean = mean(Extravert_W2_PCG, na.rm = TRUE),
    Extravert_W2_PCG_sd = sd(Extravert_W2_PCG, na.rm = TRUE),
    Openness_W2_PCG_mean = mean(Openness_W2_PCG, na.rm = TRUE),
    Openness_W2_PCG_sd = sd(Openness_W2_PCG, na.rm = TRUE),
    
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
ggplot(ml_data_complete_TIPI, aes(x = Maths_points, fill = resilience)) +
  geom_histogram(binwidth = 1, alpha = 0.7, position = "identity") +
  facet_wrap(~ risk_group) +
  theme_minimal() +
  labs(title = "Distribution of Maths Scores by Resilience and Risk Group",
       x = "Maths Points", y = "Count") +
  scale_fill_manual(values = c("Resilient" = "blue", "Non-Resilient" = "red"))

# Density plot of Maths Points by Resilience within Risk Groups
ggplot(ml_data_complete_TIPI, aes(x = Maths_points, fill = resilience)) +
  geom_density(alpha = 0.5) +
  facet_wrap(~ risk_group) +
  theme_minimal() +
  labs(title = "Density Distribution of Maths Scores by Resilience and Risk Group",
       x = "Maths Points", y = "Density") +
  scale_fill_manual(values = c("Resilient" = "blue", "Non-Resilient" = "red"))

# Jitter plot to visualize distribution by risk group
ggplot(ml_data_complete_TIPI, aes(x = risk_group, y = Maths_points, color = resilience)) +
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

# Load required libraries
library(tidyverse)
library(randomForest)
library(caret)
library(ROSE)


summary(production_data)

# Define predictors for TIPI version
predictor_vars <- c(
  "Drum_VR_W2_p_std", "Drum_NA_W2_p_std", "BAS_TS_Mat_W2_std", # Cognitive
  "Agreeable_W2_PCG", "Emo_Stability_W2_PCG", "Conscientious_W2_PCG", 
  "Extravert_W2_PCG", "Openness_W2_PCG", # TIPI scores (raw)
  "PCG_Educ_W2_std", "SCG_Educ_W2_std", "Income_equi_std" # Socioeconomic
)

# Prepare the dataset for ML
rf_data <- ml_data_complete_TIPI %>%
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

# SMOTE balancing
smote_data <- ROSE::ROSE(resilience ~ ., data = train_data, N = 2*nrow(train_data))$data
table(smote_data$resilience) # Check new class distribution

# Train RF with SMOTE-balanced data
rf_model_smote <- randomForest(resilience ~ ., 
                               data = smote_data, 
                               ntree = 500, 
                               mtry = 3, 
                               importance = TRUE)

# Get feature importance
importance_df <- as.data.frame(importance(rf_model_smote))
importance_df$Feature <- rownames(importance_df)

# Sort by Mean Decrease in Gini
importance_df <- importance_df %>%
  arrange(desc(MeanDecreaseGini))

# View results
print(importance_df)


# SALVING THE DATASETS ------------------------------------------------------------
write.csv(ml_data_TIPI, "ml_data_TIPI.csv", row.names = FALSE)
write.csv(ml_data_complete_TIPI, "ml_data_complete_TIPI.csv", row.names = FALSE)