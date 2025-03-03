# Basic cross-tabulation of resilience by gender
table(ml_data_complete$resilience, ml_data_complete$Gender_factor)

# Get proportions within each gender
prop.table(table(ml_data_complete$resilience, ml_data_complete$Gender_factor), margin = 2) * 100

# More detailed breakdown including risk groups
ml_data_complete %>%
  group_by(Gender_factor, risk_group) %>%
  summarise(
    n = n(),
    n_resilient = sum(resilience == "Resilient", na.rm = TRUE),
    pct_resilient = mean(resilience == "Resilient", na.rm = TRUE) * 100
  ) %>%
  arrange(Gender_factor, risk_group)



# Chi-square test of independence
# First, remove "Not Applicable" cases to focus on at-risk students
resilience_test <- ml_data_complete %>%
  filter(resilience != "Not Applicable") %>%
  with(., chisq.test(table(resilience, Gender_factor)))
print(resilience_test)



# First, let's confirm the proportion from each risk group
table(ml_data_complete$resilience, ml_data_complete$risk_group) %>%
  prop.table(margin = 1) * 100

# Create comparison of means for all key variables
comparison_stats <- ml_data_complete %>%
  filter(resilience != "Not Applicable") %>%  # Remove low-risk students
  group_by(resilience) %>%
  summarise(
    # Cognitive measures (standardized)
    verbal_reasoning = mean(Drum_VR_W2_p_std, na.rm = TRUE),
    numerical_ability = mean(Drum_NA_W2_p_std, na.rm = TRUE),
    matrix_reasoning = mean(BAS_TS_Mat_W2_std, na.rm = TRUE),
    
    # Non-cognitive measures (SDQ scores)
    emotional_problems = mean(SDQ_emot_PCG_W2, na.rm = TRUE),
    conduct_problems = mean(SDQ_cond_PCG_W2, na.rm = TRUE),
    hyperactivity = mean(SDQ_hyper_PCG_W2, na.rm = TRUE),
    peer_problems = mean(SDQ_peer_PCG_W2, na.rm = TRUE),
    
    # Socioeconomic measures (standardized)
    pcg_education = mean(PCG_Educ_W2_std, na.rm = TRUE),
    scg_education = mean(SCG_Educ_W2_std, na.rm = TRUE),
    income = mean(Income_equi_std, na.rm = TRUE),
    
    # School characteristics
    deis_school = mean(DEIS_binary_W2, na.rm = TRUE),
    fee_paying = mean(Fee_paying_W2, na.rm = TRUE)
  )

# Print results
print(comparison_stats, width = Inf)

# T-tests for key variables
ml_data_subset <- ml_data_complete %>%
  filter(resilience != "Not Applicable")

# Function to run t-test and return formatted results
run_ttest <- function(variable, data) {
  test <- t.test(data[[variable]] ~ data$resilience)
  return(data.frame(
    variable = variable,
    t_stat = test$statistic,
    p_value = test$p.value,
    mean_diff = diff(test$estimate)
  ))
}

# List of variables to test
variables <- c("Drum_VR_W2_p_std", "Drum_NA_W2_p_std", "BAS_TS_Mat_W2_std",
               "SDQ_emot_PCG_W2", "SDQ_cond_PCG_W2", "SDQ_hyper_PCG_W2", "SDQ_peer_PCG_W2",
               "PCG_Educ_W2_std", "SCG_Educ_W2_std", "Income_equi_std")

# Run t-tests for all variables
t_test_results <- lapply(variables, run_ttest, data = ml_data_subset) %>%
  bind_rows()

# Print t-test results
print(t_test_results, width = Inf)

# Add gender stratification
gender_comparison <- ml_data_complete %>%
  filter(resilience != "Not Applicable") %>%
  group_by(Gender_factor, resilience) %>%
  summarise(
    # Cognitive measures
    verbal_reasoning = mean(Drum_VR_W2_p_std, na.rm = TRUE),
    numerical_ability = mean(Drum_NA_W2_p_std, na.rm = TRUE),
    matrix_reasoning = mean(BAS_TS_Mat_W2_std, na.rm = TRUE),
    
    # Non-cognitive measures
    emotional_problems = mean(SDQ_emot_PCG_W2, na.rm = TRUE),
    conduct_problems = mean(SDQ_cond_PCG_W2, na.rm = TRUE),
    hyperactivity = mean(SDQ_hyper_PCG_W2, na.rm = TRUE),
    peer_problems = mean(SDQ_peer_PCG_W2, na.rm = TRUE),
    
    # Socioeconomic measures
    pcg_education = mean(PCG_Educ_W2_std, na.rm = TRUE),
    scg_education = mean(SCG_Educ_W2_std, na.rm = TRUE),
    income = mean(Income_equi_std, na.rm = TRUE)
  )

print(gender_comparison, width = Inf)


# 1. Statistical Significance Tests
t_test_results <- ml_data_subset %>%
  summarise(across(
    c(Drum_VR_W2_p_std, Drum_NA_W2_p_std, BAS_TS_Mat_W2_std,
      SDQ_emot_PCG_W2, SDQ_cond_PCG_W2, SDQ_hyper_PCG_W2, SDQ_peer_PCG_W2,
      PCG_Educ_W2_std, SCG_Educ_W2_std, Income_equi_std),
    ~ t.test(.x ~ resilience, data = ml_data_subset)$p.value
  ))

print(t_test_results,width = Inf)

# 2. Gender-stratified means
gender_stats <- ml_data_complete %>%
  filter(resilience != "Not Applicable") %>%
  group_by(Gender_factor, resilience) %>%
  summarise(
    across(c(Drum_VR_W2_p_std, Drum_NA_W2_p_std, BAS_TS_Mat_W2_std,
             SDQ_emot_PCG_W2, SDQ_cond_PCG_W2, SDQ_hyper_PCG_W2, SDQ_peer_PCG_W2,
             PCG_Educ_W2_std, SCG_Educ_W2_std, Income_equi_std),
           ~ mean(.x, na.rm = TRUE)),
    .groups = 'drop'
  )

print(gender_stats, width = Inf)

# 3. Risk group stratification
risk_stats <- ml_data_complete %>%
  filter(resilience != "Not Applicable") %>%
  group_by(risk_group, resilience) %>%
  summarise(
    across(c(Drum_VR_W2_p_std, Drum_NA_W2_p_std, BAS_TS_Mat_W2_std,
             SDQ_emot_PCG_W2, SDQ_cond_PCG_W2, SDQ_hyper_PCG_W2, SDQ_peer_PCG_W2,
             PCG_Educ_W2_std, SCG_Educ_W2_std, Income_equi_std),
           ~ mean(.x, na.rm = TRUE)),
    .groups = 'drop'
  )

print(risk_stats, width = Inf)



# Function to run t-test and return formatted results
t_test_differences <- ml_data_complete %>%
  filter(resilience != "Not Applicable") %>%  # Remove low-risk students
  group_by(resilience) %>%
  summarise(
    n = n(),
    # Cognitive
    verbal_mean = mean(Drum_VR_W2_p_std),
    verbal_se = sd(Drum_VR_W2_p_std)/sqrt(n()),
    numerical_mean = mean(Drum_NA_W2_p_std),
    numerical_se = sd(Drum_NA_W2_p_std)/sqrt(n()),
    # Non-cognitive
    hyper_mean = mean(SDQ_hyper_PCG_W2),
    hyper_se = sd(SDQ_hyper_PCG_W2)/sqrt(n())
  )

# Then we can use t.test() to get exact p-values
t_test_results <- ml_data_complete %>%
  filter(resilience != "Not Applicable") %>%
  with(., t.test(Drum_VR_W2_p_std ~ resilience))

print(t_test_differences, width = Inf)
print(t_test_results, width = Inf)


# Create separate comparisons for girls and boys
gender_comparisons <- ml_data_complete %>%
  filter(resilience != "Not Applicable") %>%  # Remove low-risk students
  group_by(Gender_factor, resilience) %>%
  summarise(
    n = n(),
    # Academic Achievement
    maths = mean(Maths_points),
    
    # Cognitive Skills
    verbal = mean(Drum_VR_W2_p_std),
    numerical = mean(Drum_NA_W2_p_std),
    matrix = mean(BAS_TS_Mat_W2_std),
    
    # Non-cognitive Skills
    emotional = mean(SDQ_emot_PCG_W2),
    conduct = mean(SDQ_cond_PCG_W2),
    hyperactivity = mean(SDQ_hyper_PCG_W2),
    peer = mean(SDQ_peer_PCG_W2),
    
    # Socioeconomic Background
    pcg_educ = mean(PCG_Educ_W2_std),
    scg_educ = mean(SCG_Educ_W2_std),
    income = mean(Income_equi_std),
    
    # School Characteristics
    deis = mean(DEIS_binary_W2),
    fee_paying = mean(Fee_paying_W2),
    mixed = mean(Mixed)
  ) %>%
  ungroup()

print(gender_comparisons, width = Inf)

# Calculate differences and run t-tests for females
female_tests <- ml_data_complete %>%
  filter(resilience != "Not Applicable", Gender_factor == "Female") %>%
  summarise(across(c(Maths_points, 
                     Drum_VR_W2_p_std, Drum_NA_W2_p_std, BAS_TS_Mat_W2_std,
                     SDQ_emot_PCG_W2, SDQ_cond_PCG_W2, SDQ_hyper_PCG_W2, SDQ_peer_PCG_W2,
                     PCG_Educ_W2_std, SCG_Educ_W2_std, Income_equi_std,
                     DEIS_binary_W2, Fee_paying_W2, Mixed),
                   ~ t.test(.x ~ resilience)$p.value))

# Calculate differences and run t-tests for males
male_tests <- ml_data_complete %>%
  filter(resilience != "Not Applicable", Gender_factor == "Male") %>%
  summarise(across(c(Maths_points, 
                     Drum_VR_W2_p_std, Drum_NA_W2_p_std, BAS_TS_Mat_W2_std,
                     SDQ_emot_PCG_W2, SDQ_cond_PCG_W2, SDQ_hyper_PCG_W2, SDQ_peer_PCG_W2,
                     PCG_Educ_W2_std, SCG_Educ_W2_std, Income_equi_std,
                     DEIS_binary_W2, Fee_paying_W2, Mixed),
                   ~ t.test(.x ~ resilience)$p.value))

print("P-values for female comparisons:")
print(female_tests, width = Inf)
print("P-values for male comparisons:")
print(male_tests, width = Inf)

# Detailed check of math scores by gender and resilience
math_summary <- ml_data_complete %>%
  filter(resilience != "Not Applicable") %>%
  group_by(Gender_factor, resilience) %>%
  summarise(
    n = n(),
    mean = mean(Maths_points),
    sd = sd(Maths_points),
    min = min(Maths_points),
    max = max(Maths_points),
    p25 = quantile(Maths_points, 0.25),
    p50 = quantile(Maths_points, 0.50),
    p75 = quantile(Maths_points, 0.75)
  )

print(math_summary, width = Inf)

# Distribution of scores for resilient students
resilient_dist <- ml_data_complete %>%
  filter(resilience == "Resilient") %>%
  group_by(Maths_points) %>%
  summarise(count = n()) %>%
  arrange(desc(Maths_points))

print("Distribution of math scores for resilient students:")
print(resilient_dist, width = Inf)


# Check the distribution of math scores and relevant percentiles
percentiles <- ml_data_complete %>%
  summarise(
    p70 = quantile(Maths_points, 0.70),
    p75 = quantile(Maths_points, 0.75),
    p80 = quantile(Maths_points, 0.80),
    p85 = quantile(Maths_points, 0.85),
    p90 = quantile(Maths_points, 0.90)
  )

print("Math score percentiles:")
print(percentiles)

# Check distribution of math scores
math_dist <- ml_data_complete %>%
  group_by(Maths_points) %>%
  summarise(
    count = n(),
    percent = n()/nrow(ml_data_complete)*100
  ) %>%
  arrange(desc(Maths_points))

print("\nDistribution of math scores:")
print(math_dist, width = Inf)

