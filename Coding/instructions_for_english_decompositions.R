library(dplyr)
selected_data <- selected_data %>%
  mutate(
    English_LC_Level = na_if(English_LC_Level, 9),  # turn 9s into NA
    English_LC_Level_Label = factor(
      English_LC_Level,
      levels = c(2, 3),
      labels = c("Ordinary", "Higher")
    )
  )

# Define the outcome variable for decomposition models
dependent_var <- "English_LC_Points"  # Use the harmonized, cleaned outcome

# Wave 1 variables
wave1_vars <- c(
  "Cog_Reading_W1_l", "Cog_Maths_W1_l",
  "SDQ_emot_PCG_W1", "SDQ_cond_PCG_W1", "SDQ_hyper_PCG_W1", "SDQ_peer_PCG_W1",
  "PCG_Educ_W1_Dummy34", "PCG_Educ_W1_Dummy56", 
  "SCG_Educ_W1_Dummy34", "SCG_Educ_W1_Dummy56",
  "Income_equi_quint_W1", "mixed_school_w1", 
  "Father_Educ_Missing_W1"
)

# Wave 2 variables
wave2_vars <- c(
  "Drum_VR_W2_l", "Drum_NA_W2_l", "BAS_TS_Mat_W2",
  "SDQ_emot_PCG_W2", "SDQ_cond_PCG_W2", "SDQ_hyper_PCG_W2", "SDQ_peer_PCG_W2",
  "PCG_Educ_W2_Dummy34", "PCG_Educ_W2_Dummy56", 
  "SCG_Educ_W2_Dummy34", "SCG_Educ_W2_Dummy56",
  "Income_equi_quint_W2", 
  "Fee_paying_W2", "DEIS_W2", "mixed_school_w2", "religious_school_w2",
  "Father_Educ_Missing_W2"
)

# Grouping variables (used for subgroup decompositions)
grouping_vars <- c("Gender_binary", "father_absent_status_test")

# Combine all variable names needed for the full dataset
all_vars <- c(
  "ID", "English_LC_Points", 
  "Grade_System_Dummy", "LC_Year", "Gender_binary",
  wave1_vars, wave2_vars, grouping_vars
)

# Create full decomposition dataset
decomposition_dataset_english <- selected_data %>%
  select(all_of(all_vars)) %>%
  filter(!is.na(English_LC_Points), !is.na(Gender_binary))

# Save full dataset
write.csv(decomposition_dataset_english, "decomposition_dataset_english.csv", row.names = FALSE)

# Print dimensions and distribution checks
cat("Dimensions of decomposition_dataset_english:", dim(decomposition_dataset_english), "\n")

cat("\nFather presence distribution:\n")
with(decomposition_dataset_english, table(Father_Educ_Missing_W1, Father_Educ_Missing_W2, useNA = "always"))

cat("\nGender distribution:\n")
with(decomposition_dataset_english, table(Gender_binary, useNA = "always"))

# Create complete-case subset for decompositions (no missing predictors or group vars)
complete_case_subset_english <- decomposition_dataset_english %>%
  select(all_of(c("ID", dependent_var, wave1_vars, wave2_vars, grouping_vars))) %>%
  filter(complete.cases(.))

# Report how much data is retained
n_total <- nrow(decomposition_dataset_english)
n_kept <- nrow(complete_case_subset_english)
percent_kept <- round((n_kept / n_total) * 100, 2)

cat("\nComplete case subset keeps", percent_kept, "% of decomposition data (", n_kept, "of", n_total, "rows)\n")

# Show sample sizes by gender and father presence
complete_case_subset_english %>%
  group_by(Gender_binary, father_absent_status_test) %>%
  summarise(count = n(), .groups = "drop") %>%
  mutate(
    gender_label = ifelse(Gender_binary == 1, "Boys", "Girls"),
    father_status = ifelse(father_absent_status_test == 1, "Father Absent", "Father Present")
  ) %>%
  select(gender_label, father_status, count)

# Save complete-case subset
write.csv(complete_case_subset_english, "complete_case_subset_english.csv", row.names = FALSE)


# Use harmonized Maths outcome
dependent_var <- "English_LC_Points"

# Wave 1 variables (same for boys and girls)
wave1_vars <- c(
  "Cog_Reading_W1_l", "Cog_Maths_W1_l",
  "SDQ_emot_PCG_W1", "SDQ_cond_PCG_W1", "SDQ_hyper_PCG_W1", "SDQ_peer_PCG_W1",
  "PCG_Educ_W1_Dummy34", "PCG_Educ_W1_Dummy56", "Income_equi_quint_W1",
  "mixed_school_w1"
)

# Wave 2 variables (same for boys and girls)
wave2_vars <- c(
  "Drum_VR_W2_l", "Drum_NA_W2_l", "BAS_TS_Mat_W2",
  "SDQ_emot_PCG_W2", "SDQ_cond_PCG_W2", "SDQ_hyper_PCG_W2", "SDQ_peer_PCG_W2",
  "PCG_Educ_W2_Dummy34", "PCG_Educ_W2_Dummy56", "Income_equi_quint_W2",
  "Fee_paying_W2", "DEIS_W2", "mixed_school_w2", "religious_school_w2"
)

# Grouping variables: used for decomposition subgrouping
grouping_vars <- c("Gender_binary", "father_absent_status_test")

# Combine all needed variables
all_needed_vars <- unique(c(dependent_var, wave1_vars, wave2_vars, grouping_vars))

# Create complete-case subset with harmonized Maths score
complete_case_subset_english <- selected_data %>%
  select(ID, all_of(all_needed_vars)) %>%
  filter(complete.cases(.))

# Output data diagnostics
n_total <- nrow(selected_data)
n_kept <- nrow(complete_case_subset_english)
percent_kept <- round((n_kept / n_total) * 100, 2)

cat("Keeping", percent_kept, "% of the original observations (", n_kept, "of", n_total, ")\n")

# Distribution check by Gender and Father Absence
complete_case_subset_english %>%
  group_by(Gender_binary, father_absent_status_test) %>%
  summarise(count = n(), .groups = "drop") %>%
  mutate(
    gender_label = ifelse(Gender_binary == 1, "Boys", "Girls"),
    father_status = ifelse(father_absent_status_test == 1, "Father Absent", "Father Present")
  ) %>%
  select(gender_label, father_status, count)

# Save to CSV
write.csv(complete_case_subset_english, "complete_case_subset_english.csv", row.names = FALSE)