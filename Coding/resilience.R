resilient <- ml_data_complete_60th %>%
  select(ID, resilience) %>%
  inner_join(select(Merged_Child, ID, cq2q7a), by = "ID") %>%
  filter(resilience == "Resilient") %>%
  count(cq2q7a, sort = TRUE)

noresilient <- ml_data_complete_60th %>%
  select(ID, resilience) %>%
  inner_join(select(Merged_Child, ID, cq2q7a), by = "ID") %>%
  filter(resilience == "Non-Resilient") %>%
  count(cq2q7a, sort = TRUE)

print(resilient, width = Inf)
print(noresilient, width = Inf)


# Function to calculate percentages for a given variable
calculate_percentage <- function(variable_name) {
  ml_data_complete_60th %>%
    filter(!is.na(resilience)) %>%  # Ensure resilience is not NA
    select(ID, resilience) %>%
    inner_join(select(Merged_Child, ID, all_of(variable_name)), by = "ID") %>%
    filter(!is.na(.data[[variable_name]])) %>%  # Remove NA values in selected variable
    count(resilience, .data[[variable_name]]) %>%
    group_by(resilience) %>%
    mutate(pct = n / sum(n) * 100) %>%
    ungroup()
}

# Example: Use the function for cq2q7a
cq2q7a_pct <- calculate_percentage("cq2q7a")
print(cq2q7a_pct, width = Inf)

# Example: Use the function for cq2q2b2code1 (Favourite Subject)
subject_data_pct <- calculate_percentage("cq2q2b2code1")
print(subject_data_pct, width = Inf)


library(dplyr)

# Function to compute percentage distribution for categorical variables, excluding "9"
calculate_percentage <- function(variable_name) {
  ml_data_complete_60th %>%
    filter(!is.na(resilience)) %>%  # Remove NA values in resilience
    select(ID, resilience) %>%
    inner_join(select(Merged_Child, ID, all_of(variable_name)), by = "ID") %>%
    filter(!is.na(.data[[variable_name]]), .data[[variable_name]] != 9) %>%  # Exclude '9' responses
    count(resilience, .data[[variable_name]]) %>%
    group_by(resilience) %>%
    mutate(pct = n / sum(n) * 100) %>%
    ungroup()
}

# Compute percentages for categorical variables, excluding '9'
math_perception_pct <- calculate_percentage("MMJ13")  # PCG: Relative performance
math_liking_pct <- calculate_percentage("CQ3a")       # Child: Maths liking

# Teacher-reported academic performance
math_perf_pct <- calculate_percentage("TC10d")  # Maths performance
probsolving_perf_pct <- calculate_percentage("TC10g") # Problem Solving
imagi_perf_pct <- calculate_percentage("TC10e") # Imagination/Creativity
compre_perf_pct <- calculate_percentage("TC10c") # Comprehension

# Print categorical variables as tables
print(math_perception_pct, width = Inf)
print(math_liking_pct, width = Inf)
print(math_perf_pct, width = Inf)
print(probsolving_perf_pct, width = Inf)
print(imagi_perf_pct, width = Inf)
print(compre_perf_pct, width = Inf)

dplyr::count(ml_data_complete,PCG_Educ_W2)
dplyr::count(ml_data_complete,SCG_Educ_W2)

# Compute summary statistics for continuous variables (Drumcondra Maths Test)
math_cont_summary <- ml_data_complete_60th %>%
  filter(!is.na(resilience)) %>%
  select(ID, resilience) %>%
  inner_join(select(Merged_Child, ID, mathclass, mathatt, mathcorr, mathpct, mathsls, mathslsse), by = "ID") %>%
  group_by(resilience) %>%
  summarise(
    mathclass_mean = mean(mathclass, na.rm = TRUE),
    mathclass_sd = sd(mathclass, na.rm = TRUE),
    mathatt_mean = mean(mathatt, na.rm = TRUE),
    mathatt_sd = sd(mathatt, na.rm = TRUE),
    mathcorr_mean = mean(mathcorr, na.rm = TRUE),
    mathcorr_sd = sd(mathcorr, na.rm = TRUE),
    mathpct_mean = mean(mathpct, na.rm = TRUE),
    mathpct_sd = sd(mathpct, na.rm = TRUE),
    mathsls_mean = mean(mathsls, na.rm = TRUE),
    mathsls_sd = sd(mathsls, na.rm = TRUE),
    mathslsse_mean = mean(mathslsse, na.rm = TRUE),
    mathslsse_sd = sd(mathslsse, na.rm = TRUE)
  ) %>%
  ungroup()

# Print continuous variable summary statistics
print(math_cont_summary, width = Inf)



library(dplyr)

# Function to compute percentage distribution for categorical variables
calculate_percentage <- function(variable_name) {
  ml_data_complete_60th %>%
    filter(!is.na(resilience)) %>%  # Remove NA values in resilience
    select(ID, resilience) %>%
    inner_join(select(Merged_Child, ID, all_of(variable_name)), by = "ID") %>%
    filter(!is.na(.data[[variable_name]])) %>%  # Remove NA values in selected variable
    count(resilience, .data[[variable_name]]) %>%
    group_by(resilience) %>%
    mutate(pct = n / sum(n) * 100) %>%
    ungroup()
}

# 📌 Wave 2 - Maths Perception & Performance
math_difficulty_pct <- calculate_percentage("cq2q7a")  # Difficulty with Maths
math_interest_pct <- calculate_percentage("cq2q8a")    # Interest in Maths
math_level_pct <- calculate_percentage("cq2q2c")       # Maths Level Studied

# 📌 Wave 2 - Mathematics Tests
math_wave2_summary <- ml_data_complete_60th %>%
  filter(!is.na(resilience)) %>%
  select(ID, resilience) %>%
  inner_join(select(Merged_Child, ID, napct, nals, nalsse, matabscore, matage), by = "ID") %>%
  group_by(resilience) %>%
  summarise(
    napct_mean = mean(napct, na.rm = TRUE),
    napct_sd = sd(napct, na.rm = TRUE),
    nals_mean = mean(nals, na.rm = TRUE),
    nals_sd = sd(nals, na.rm = TRUE),
    nalsse_mean = mean(nalsse, na.rm = TRUE),
    nalsse_sd = sd(nalsse, na.rm = TRUE),
    matabscore_mean = mean(matabscore, na.rm = TRUE),
    matabscore_sd = sd(matabscore, na.rm = TRUE),
    matage_mean = mean(matage, na.rm = TRUE),
    matage_sd = sd(matage, na.rm = TRUE)
  ) %>%
  ungroup()

# 📌 Wave 2 - SDQ Scores (Primary Caregiver)
sdq_wave2_summary <- ml_data_complete_60th %>%
  filter(!is.na(resilience)) %>%
  select(ID, resilience) %>%
  inner_join(select(Merged_Child, ID, 
                    w2pcd2_sdqemot, w2pcd2_sdqcond, w2pcd2_sdqhyper, w2pcd2_sdqpeer), by = "ID") %>%
  group_by(resilience) %>%
  summarise(
    PCG_Emotional_Mean = mean(w2pcd2_sdqemot, na.rm = TRUE),
    PCG_Conduct_Mean = mean(w2pcd2_sdqcond, na.rm = TRUE),
    PCG_Hyperactivity_Mean = mean(w2pcd2_sdqhyper, na.rm = TRUE),
    PCG_Peer_Mean = mean(w2pcd2_sdqpeer, na.rm = TRUE)
  ) %>%
  ungroup()

# 📌 Wave 3 - Maths Perception & Performance
math_performance_pct <- calculate_percentage("cq3b11c")  # Perceived maths performance

# 📌 Wave 3 - Mathematics Test Scores
math_wave3_summary <- ml_data_complete_60th %>%
  filter(!is.na(resilience)) %>%
  select(ID, resilience) %>%
  inner_join(select(Merged_Child, ID, CognitiveMathsTotal), by = "ID") %>%
  group_by(resilience) %>%
  summarise(
    CognitiveMathsTotal_mean = mean(CognitiveMathsTotal, na.rm = TRUE),
    CognitiveMathsTotal_sd = sd(CognitiveMathsTotal, na.rm = TRUE)
  ) %>%
  ungroup()

# 📌 Wave 3 - SDQ Scores (Primary and Secondary Caregiver)
sdq_wave3_summary <- ml_data_complete_60th %>%
  filter(!is.na(resilience)) %>%
  select(ID, resilience) %>%
  inner_join(select(Merged_Child, ID, 
                    w3pcg_SDQemotional, w3pcg_SDQconduct, w3pcg_SDQhyper, w3pcg_SDQpeerprobs,
                    w3scg_SDQemotional, w3scg_SDQconduct, w3scg_SDQhyper, w3scg_SDQpeerprobs), by = "ID") %>%
  group_by(resilience) %>%
  summarise(
    PCG_Emotional_Mean = mean(w3pcg_SDQemotional, na.rm = TRUE),
    PCG_Conduct_Mean = mean(w3pcg_SDQconduct, na.rm = TRUE),
    PCG_Hyperactivity_Mean = mean(w3pcg_SDQhyper, na.rm = TRUE),
    PCG_Peer_Mean = mean(w3pcg_SDQpeerprobs, na.rm = TRUE),
    
    SCG_Emotional_Mean = mean(w3scg_SDQemotional, na.rm = TRUE),
    SCG_Conduct_Mean = mean(w3scg_SDQconduct, na.rm = TRUE),
    SCG_Hyperactivity_Mean = mean(w3scg_SDQhyper, na.rm = TRUE),
    SCG_Peer_Mean = mean(w3scg_SDQpeerprobs, na.rm = TRUE)
  ) %>%
  ungroup()

# 📌 Print Results
print(math_difficulty_pct, width = Inf)
print(math_interest_pct, width = Inf)
print(math_level_pct, width = Inf)
print(math_wave2_summary, width = Inf)
print(sdq_wave2_summary, width = Inf)
print(math_performance_pct, width = Inf)
print(math_wave3_summary, width = Inf)
print(sdq_wave3_summary, width = Inf)



dplyr::count(Merged_Child,Partner) # Wave 1, Partner in household, 0 = no partner, 1 = has partner
dplyr::count(Merged_Child,Int_type) # wave 1, Household interview participation, 
                                    # 1 Both caregivers in household and interviewed
                                    # 2 Main caregiver interviewed, no partner in household
                                    # 3 Main caregiver interviewed, partner eligible but no response



