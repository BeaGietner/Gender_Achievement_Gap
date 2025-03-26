library(splines)

maths_model_spline <- lm(
  Maths_points ~ gender_binary * ns(Cog_Maths_W1_z, df = 3) + gender_binary * ns(Drum_NA_W2_p_z, df = 3) +
    PCG_Educ_W1 + PCG_Educ_W2 + 
    SDQ_emot_PCG_W1 + SDQ_hyper_PCG_W1 + SDQ_cond_PCG_W1 + SDQ_peer_PCG_W1 +
    SDQ_emot_PCG_W2 + SDQ_hyper_PCG_W2 + SDQ_cond_PCG_W2 + SDQ_peer_PCG_W2 + 
    Income_equi_quint_W1 + Income_equi_quint,
  data = Oaxaca_without_SCG
)

english_model_spline <- lm(
  English_points ~ gender_binary * ns(Cog_Reading_W1_z, df = 3) + gender_binary * ns(Drum_VR_W2_p_z, df = 3) +
    PCG_Educ_W1 + PCG_Educ_W2 + 
    SDQ_emot_PCG_W1 + SDQ_hyper_PCG_W1 + SDQ_cond_PCG_W1 + SDQ_peer_PCG_W1 +
    SDQ_emot_PCG_W2 + SDQ_hyper_PCG_W2 + SDQ_cond_PCG_W2 + SDQ_peer_PCG_W2 +
    Income_equi_quint_W1 + Income_equi_quint,
  data = Oaxaca_without_SCG
)

summary(maths_model_spline)
summary(english_model_spline)

library(dplyr)

# Compute mean values for continuous variables
comparison_table <- data.frame(
  Variable = c("Mean Maths Score", "Mean English Score", 
               "Mean Income Quintile", 
               "Fee-Paying Enrollment (%)", "DEIS Enrollment (%)", "Mixed-Sex School (%)",
               "PCG Education (Level 3-4) (%)", "PCG Education (Level 5-6) (%)"),
  
  Only_Mother = c(
    mean(sample_only_mother$Maths_points, na.rm = TRUE),
    mean(sample_only_mother$English_points, na.rm = TRUE),
    mean(sample_only_mother$Income_equi_quint, na.rm = TRUE),
    mean(sample_only_mother$Fee_paying_W2, na.rm = TRUE) * 100,
    mean(sample_only_mother$DEIS_binary_W2, na.rm = TRUE) * 100,
    mean(sample_only_mother$Mixed, na.rm = TRUE) * 100,
    mean(sample_only_mother$PCG_Educ_W2_Dummy34, na.rm = TRUE) * 100,
    mean(sample_only_mother$PCG_Educ_W2_Dummy56, na.rm = TRUE) * 100
  ),
  
  Both_Parents = c(
    mean(sample_both_parents$Maths_points, na.rm = TRUE),
    mean(sample_both_parents$English_points, na.rm = TRUE),
    mean(sample_both_parents$Income_equi_quint, na.rm = TRUE),
    mean(sample_both_parents$Fee_paying_W2, na.rm = TRUE) * 100,
    mean(sample_both_parents$DEIS_binary_W2, na.rm = TRUE) * 100,
    mean(sample_both_parents$Mixed, na.rm = TRUE) * 100,
    mean(sample_both_parents$PCG_Educ_W2_Dummy34, na.rm = TRUE) * 100,
    mean(sample_both_parents$PCG_Educ_W2_Dummy56, na.rm = TRUE) * 100
  )
)

# Perform t-tests for continuous variables
p_values <- c(
  t.test(sample_only_mother$Maths_points, sample_both_parents$Maths_points, var.equal = FALSE)$p.value,
  t.test(sample_only_mother$English_points, sample_both_parents$English_points, var.equal = FALSE)$p.value,
  t.test(sample_only_mother$Income_equi_quint, sample_both_parents$Income_equi_quint, var.equal = FALSE)$p.value,
  
  # Convert categorical variables into contingency tables for chi-square tests
  chisq.test(table(sample_only_mother$Fee_paying_W2))$p.value,
  chisq.test(table(sample_only_mother$DEIS_binary_W2))$p.value,
  chisq.test(table(sample_only_mother$Mixed))$p.value,
  chisq.test(table(sample_only_mother$PCG_Educ_W2_Dummy34))$p.value,
  chisq.test(table(sample_only_mother$PCG_Educ_W2_Dummy56))$p.value
)

# Add p-values to the table
comparison_table$p_value <- p_values

# Print results
print(comparison_table)


for (i in 1:nrow(comparison_table)) {
  cat(comparison_table$Variable[i], 
      "\nOnly Mother:", comparison_table$Only_Mother[i], 
      "\nBoth Parents:", comparison_table$Both_Parents[i], 
      "\nP-value:", comparison_table$p_value[i], "\n\n")
}


# Wave 1

dplyr::count(Merged_Child,MS14) # PCG: Current Marital Status, similar to pc2s12
dplyr::count(Merged_Child,FS14) # SCG: Current Marital Status, similar to sc2s12
dplyr::count(Merged_Child,Partner) # Partner in household, similar to w2partner
dplyr::count(Merged_Child,scgmain) # Secondary Caregiver Q Completed - Wave 1, 0 = No resident partner, 1 = Partner resident, not completed, 2 = Partner resident, completed

# Wave 2

dplyr::count(Merged_Child,pc2s12) # PCG: Can you tell me which of these best describes your current marital status?
                                  # 1 = Married and living with husband/wife, 2 = Married and separated from husband/wife 3 = Divorced / Widowed, 4 = Widowed, 5 = Never married
dplyr::count(Merged_Child,sc2s12) # SCG: Can you tell me which of these best describes your current marital status?
dplyr::count(Merged_Child,scgstatph2) # SCG if present same as Wave 1, 0 = No, 1 = Yes, 
                                      # Wave 1 status of person who is Secondary Caregiver Status at Wave 2
dplyr::count(Merged_Child,w2partner) # PCG: Partner in the household
dplyr::count(Merged_Child,w2scgmain) # Secondary Caregiver Q Completed - Wave 2 0 = No resident partner, 1 = Partner resident, not completed, 2 = Partner resident, completed

# Wave 3

dplyr::count(Merged_Child,pc3s12) # PCG: Current legal marital status
dplyr::count(Merged_Child,sc3s12) # SCG Current legal marital status
dplyr::count(Merged_Child,w3partner) # PCG: Partner in household, similar to w2partner
dplyr::count(Merged_Child,w3scgmain) # Secondary Caregiver Q Completed - Wave 3
dplyr::count(Merged_Child,scgstatph3) # SCG if present same as Wave 2

# W1 -> W2 -> W3
# MS14 -> pc2s12 -> pc3s12
# FS14 -> sc2s12 -> sc3s12
# Partner -> w2partner -> w3partner
# scgmain -> w2scgmain -> w3scgmain
# nothing in wave 1, scgstatph2 -> scgstatph3

# Create a transition analysis by ID from wave 1 to wave 2 
transitions_W12 <- Merged_Child %>%
  select(ID, w2partner, w3partner, MS14, pc2s12, scgmain, w2scgmain) %>%
  mutate(
    partner_change = case_when(
      Partner == 1 & w2partner == 0 ~ "Lost partner",
      Partner == 0 & w2partner == 1 ~ "Gained partner",
      Partner == w2partner ~ "No change",
      TRUE ~ "Missing data"
    ),
    pcg_marital_change = case_when(
      MS14 == 1 & pc2s12 == 2 ~ "Married to separated",
      MS14 == 1 & pc2s12 == 3 ~ "Married to divorced",
      MS14 != pc2s12 ~ "Other change",
      MS14 == pc2s12 ~ "No change",
      TRUE ~ "Missing data"
    )
  )

# Analyze transitions_W12
partner_transitions_W12 <- transitions_W12 %>%
  count(partner_change) %>%
  mutate(pct = n/sum(n) * 100)

marital_transitions_W12 <- transitions_W12 %>%
  count(pcg_marital_change) %>%
  mutate(pct = n/sum(n) * 100)

# Create a simple transition table for partner status
partner_transition <- table(Merged_Child$Partner, Merged_Child$w2partner, 
                            dnn = c("Wave1_Partner", "Wave2_Partner"))
print(partner_transition)

# Create a transition table for PCG marital status
pcg_marital_transition <- table(Merged_Child$MS14, Merged_Child$pc2s12,
                                dnn = c("Wave1_PCG_Marital", "Wave2_PCG_Marital"))
print(pcg_marital_transition)

# Create a transition table for SCG presence
scg_transition <- table(Merged_Child$scgmain, Merged_Child$w2scgmain,
                        dnn = c("Wave1_SCG", "Wave2_SCG"))
print(scg_transition)




library(dplyr)

# Create a transition analysis by ID from wave 2 to wave 3
transitions_W23 <- Merged_Child %>%
  select(ID, w2partner, w3partner, pc2s12, pc3s12, w2scgmain, w3scgmain) %>%
  mutate(
    partner_change = case_when(
      w2partner == 1 & w3partner == 0 ~ "Lost partner",
      w2partner == 0 & w3partner == 1 ~ "Gained partner",
      w2partner == w3partner ~ "No change",
      TRUE ~ "Missing data"
    ),
    pcg_marital_change = case_when(
      pc2s12 == 1 & pc3s12 == 2 ~ "Married to separated",
      pc2s12 == 1 & pc3s12 == 3 ~ "Married to divorced",
      pc2s12 != pc3s12 ~ "Other change",
      pc2s12 == pc3s12 ~ "No change",
      TRUE ~ "Missing data"
    )
  )

# Analyze transitions_W23
partner_transitions_W23 <- transitions_W23 %>%
  count(partner_change) %>%
  mutate(pct = n/sum(n) * 100)

marital_transitions_W23 <- transitions_W23 %>%
  count(pcg_marital_change) %>%
  mutate(pct = n/sum(n) * 100)

# Create a simple transition table for partner status
partner_transition_W23 <- table(Merged_Child$w2partner, Merged_Child$w3partner, 
                                dnn = c("Wave2_Partner", "Wave3_Partner"))
print(partner_transition_W23)

# Create a transition table for PCG marital status
pcg_marital_transition_W23 <- table(Merged_Child$pc2s12, Merged_Child$pc3s12,
                                    dnn = c("Wave2_PCG_Marital", "Wave3_PCG_Marital"))
print(pcg_marital_transition_W23)

# Create a transition table for SCG presence
scg_transition_W23 <- table(Merged_Child$w2scgmain, Merged_Child$w3scgmain,
                            dnn = c("Wave2_SCG", "Wave3_SCG"))
print(scg_transition_W23)


Oaxaca_full <- left_join(Oaxaca_full, 
                         Merged_Child %>%
                           select(ID, MS14, FS14, Partner, scgmain,  # Wave 1
                                  pc2s12, sc2s12, scgstatph2, w2partner, w2scgmain,  # Wave 2
                                  pc3s12, sc3s12, w3partner, w3scgmain, scgstatph3),  # Wave 3
                         by = "ID")



Oaxaca_full <- Oaxaca_full %>%
  rename(
    PCG_Marital_W1 = MS14,
    SCG_Marital_W1 = FS14,
    Partner_W1 = Partner,
    SCG_Status_W1 = scgmain,
    
    PCG_Marital_W2 = pc2s12,
    SCG_Marital_W2 = sc2s12,
    SCG_SameAs_W1_W2 = scgstatph2,
    Partner_W2 = w2partner,
    SCG_Status_W2 = w2scgmain,
    
    PCG_Marital_W3 = pc3s12,
    SCG_Marital_W3 = sc3s12,
    Partner_W3 = w3partner,
    SCG_Status_W3 = w3scgmain,
    SCG_SameAs_W2_W3 = scgstatph3
  )


# Create a transition analysis by ID from Wave 1 to Wave 2
transitions_W12 <- Oaxaca_full %>%
  select(ID, Partner_W1, Partner_W2, PCG_Marital_W1, PCG_Marital_W2, SCG_Status_W1, SCG_Status_W2) %>%
  mutate(
    partner_change = case_when(
      Partner_W1 == 1 & Partner_W2 == 0 ~ "Lost partner",
      Partner_W1 == 0 & Partner_W2 == 1 ~ "Gained partner",
      Partner_W1 == Partner_W2 ~ "No change",
      TRUE ~ "Missing data"
    ),
    pcg_marital_change = case_when(
      PCG_Marital_W1 == 1 & PCG_Marital_W2 == 2 ~ "Married to separated",
      PCG_Marital_W1 == 1 & PCG_Marital_W2 == 3 ~ "Married to divorced",
      PCG_Marital_W1 != PCG_Marital_W2 ~ "Other change",
      PCG_Marital_W1 == PCG_Marital_W2 ~ "No change",
      TRUE ~ "Missing data"
    )
  )

# Analyze transitions_W12
partner_transitions_W12 <- transitions_W12 %>%
  count(partner_change) %>%
  mutate(pct = n / sum(n) * 100)

marital_transitions_W12 <- transitions_W12 %>%
  count(pcg_marital_change) %>%
  mutate(pct = n / sum(n) * 100)

# Create a transition table for partner status
partner_transition_W12 <- table(Oaxaca_full$Partner_W1, Oaxaca_full$Partner_W2, 
                                dnn = c("Wave1_Partner", "Wave2_Partner"))
print(partner_transition_W12)

# Create a transition table for PCG marital status
pcg_marital_transition_W12 <- table(Oaxaca_full$PCG_Marital_W1, Oaxaca_full$PCG_Marital_W2,
                                    dnn = c("Wave1_PCG_Marital", "Wave2_PCG_Marital"))
print(pcg_marital_transition_W12)

# Create a transition table for SCG presence
scg_transition_W12 <- table(Oaxaca_full$SCG_Status_W1, Oaxaca_full$SCG_Status_W2,
                            dnn = c("Wave1_SCG", "Wave2_SCG"))
print(scg_transition_W12)


# Create a transition analysis by ID from Wave 2 to Wave 3
transitions_W23 <- Oaxaca_full %>%
  select(ID, Partner_W2, Partner_W3, PCG_Marital_W2, PCG_Marital_W3, SCG_Status_W2, SCG_Status_W3) %>%
  mutate(
    partner_change = case_when(
      Partner_W2 == 1 & Partner_W3 == 0 ~ "Lost partner",
      Partner_W2 == 0 & Partner_W3 == 1 ~ "Gained partner",
      Partner_W2 == Partner_W3 ~ "No change",
      TRUE ~ "Missing data"
    ),
    pcg_marital_change = case_when(
      PCG_Marital_W2 == 1 & PCG_Marital_W3 == 2 ~ "Married to separated",
      PCG_Marital_W2 == 1 & PCG_Marital_W3 == 3 ~ "Married to divorced",
      PCG_Marital_W2 != PCG_Marital_W3 ~ "Other change",
      PCG_Marital_W2 == PCG_Marital_W3 ~ "No change",
      TRUE ~ "Missing data"
    )
  )

# Analyze transitions_W23
partner_transitions_W23 <- transitions_W23 %>%
  count(partner_change) %>%
  mutate(pct = n / sum(n) * 100)

marital_transitions_W23 <- transitions_W23 %>%
  count(pcg_marital_change) %>%
  mutate(pct = n / sum(n) * 100)

# Create a transition table for partner status
partner_transition_W23 <- table(Oaxaca_full$Partner_W2, Oaxaca_full$Partner_W3, 
                                dnn = c("Wave2_Partner", "Wave3_Partner"))
print(partner_transition_W23)

# Create a transition table for PCG marital status
pcg_marital_transition_W23 <- table(Oaxaca_full$PCG_Marital_W2, Oaxaca_full$PCG_Marital_W3,
                                    dnn = c("Wave2_PCG_Marital", "Wave3_PCG_Marital"))
print(pcg_marital_transition_W23)

# Create a transition table for SCG presence
scg_transition_W23 <- table(Oaxaca_full$SCG_Status_W2, Oaxaca_full$SCG_Status_W3,
                            dnn = c("Wave2_SCG", "Wave3_SCG"))
print(scg_transition_W23)


library(dplyr)
library(tidyr)  # Ensure tidyr is loaded for pivot_wider()


# Define "Only Mother Sample" based on SCG presence & missing SCG education at Wave 2
Oaxaca_full <- Oaxaca_full %>%
  mutate(only_mother = case_when(
    !is.na(SCG_Educ_W2) ~ "PCG and SCG Info",  # SCG education available
    is.na(SCG_Educ_W2) & SCG_Status_W2 == 0 ~ "Only Mother",  # SCG absent at Wave 2
    TRUE ~ "Other"
  ))

# Calculate sample sizes
sample_distribution <- Oaxaca_full %>%
  group_by(only_mother, Gender_factor) %>%
  summarise(n = n(), .groups = "drop") %>%
  pivot_wider(names_from = Gender_factor, values_from = n, values_fill = 0) %>%
  mutate(Total = Female + Male)

# Rename levels to match table labels
sample_distribution <- sample_distribution %>%
  mutate(only_mother = recode(only_mother,
                              "PCG and SCG Info" = "Sample with PCG and SCG information",
                              "Only Mother" = "Only Mother Sample"))

# Add Full Sample count
full_sample <- Oaxaca_full %>%
  count(Gender_factor) %>%
  pivot_wider(names_from = Gender_factor, values_from = n, values_fill = 0) %>%
  mutate(Total = Female + Male, only_mother = "Full Sample")

# Combine into final dataset
final_sample_distribution <- bind_rows(full_sample, sample_distribution)


library(dplyr)
library(tidyr)

# Define the updated samples
sample_only_mother <- Oaxaca_full %>%
  filter(is.na(SCG_Educ_W2) & SCG_Status_W2 == 0)  # SCG absent & missing education info

sample_both_parents <- Oaxaca_full %>%
  filter(!is.na(SCG_Educ_W2) & !is.na(PCG_Educ_W2))  # Both PCG and SCG education available

# Combine both groups into one dataset
comparison_data <- Oaxaca_full %>%
  mutate(group = case_when(
    is.na(SCG_Educ_W2) & SCG_Status_W2 == 0 ~ "Only Mother",
    !is.na(SCG_Educ_W2) & !is.na(PCG_Educ_W2) ~ "Both Parents",
    TRUE ~ NA_character_
  )) %>%
  filter(!is.na(group))  # Keep only the two relevant groups

# Compute mean values for continuous variables
comparison_table <- data.frame(
  Variable = c("Mean Maths Score", "Mean English Score", 
               "Mean Income Quintile", 
               "Fee-Paying Enrollment (%)", "DEIS Enrollment (%)", "Mixed-Sex School (%)",
               "PCG Education (Level 3-4) (%)", "PCG Education (Level 5-6) (%)"),
  
  Only_Mother = c(
    mean(sample_only_mother$Maths_points, na.rm = TRUE),
    mean(sample_only_mother$English_points, na.rm = TRUE),
    mean(sample_only_mother$Income_equi_quint, na.rm = TRUE),
    mean(sample_only_mother$Fee_paying_W2, na.rm = TRUE) * 100,
    mean(sample_only_mother$DEIS_binary_W2, na.rm = TRUE) * 100,
    mean(sample_only_mother$Mixed, na.rm = TRUE) * 100,
    mean(sample_only_mother$PCG_Educ_W2_Dummy34, na.rm = TRUE) * 100,
    mean(sample_only_mother$PCG_Educ_W2_Dummy56, na.rm = TRUE) * 100
  ),
  
  Both_Parents = c(
    mean(sample_both_parents$Maths_points, na.rm = TRUE),
    mean(sample_both_parents$English_points, na.rm = TRUE),
    mean(sample_both_parents$Income_equi_quint, na.rm = TRUE),
    mean(sample_both_parents$Fee_paying_W2, na.rm = TRUE) * 100,
    mean(sample_both_parents$DEIS_binary_W2, na.rm = TRUE) * 100,
    mean(sample_both_parents$Mixed, na.rm = TRUE) * 100,
    mean(sample_both_parents$PCG_Educ_W2_Dummy34, na.rm = TRUE) * 100,
    mean(sample_both_parents$PCG_Educ_W2_Dummy56, na.rm = TRUE) * 100
  )
)

# Perform t-tests for continuous variables
p_values <- c(
  t.test(sample_only_mother$Maths_points, sample_both_parents$Maths_points, var.equal = FALSE)$p.value,
  t.test(sample_only_mother$English_points, sample_both_parents$English_points, var.equal = FALSE)$p.value,
  t.test(sample_only_mother$Income_equi_quint, sample_both_parents$Income_equi_quint, var.equal = FALSE)$p.value,
  
  # Convert categorical variables into contingency tables for chi-square tests
  chisq.test(table(comparison_data$group, comparison_data$Fee_paying_W2))$p.value,
  chisq.test(table(comparison_data$group, comparison_data$DEIS_binary_W2))$p.value,
  chisq.test(table(comparison_data$group, comparison_data$Mixed))$p.value,
  chisq.test(table(comparison_data$group, comparison_data$PCG_Educ_W2_Dummy34))$p.value,
  chisq.test(table(comparison_data$group, comparison_data$PCG_Educ_W2_Dummy56))$p.value
)

# Add p-values to the table
comparison_table$p_value <- p_values

# Print results
print(comparison_table)

# Print detailed summary
for (i in 1:nrow(comparison_table)) {
  cat(comparison_table$Variable[i], 
      "\nOnly Mother:", comparison_table$Only_Mother[i], 
      "\nBoth Parents:", comparison_table$Both_Parents[i], 
      "\nP-value:", comparison_table$p_value[i], "\n\n")
}







library(dplyr)
library(tidyr)

# Define samples
sample_only_mother_female <- Oaxaca_full %>%
  filter(Gender_factor == "Female", is.na(SCG_Educ_W2) & SCG_Status_W2 == 0)

sample_only_mother_male <- Oaxaca_full %>%
  filter(Gender_factor == "Male", is.na(SCG_Educ_W2) & SCG_Status_W2 == 0)

sample_both_parents_female <- Oaxaca_full %>%
  filter(Gender_factor == "Female", !is.na(SCG_Educ_W2) & !is.na(PCG_Educ_W2))

sample_both_parents_male <- Oaxaca_full %>%
  filter(Gender_factor == "Male", !is.na(SCG_Educ_W2) & !is.na(PCG_Educ_W2))

# Create comparison table
comparison_table_gender <- data.frame(
  Variable = c("Mean Maths Score", "Mean English Score", 
               "Mean Income Quintile", 
               "Fee-Paying Enrollment (%)", "DEIS Enrollment (%)", "Mixed-Sex School (%)",
               "PCG Education (Level 3-4) (%)", "PCG Education (Level 5-6) (%)"),
  
  Female_Only_Mother = c(
    mean(sample_only_mother_female$Maths_points, na.rm = TRUE),
    mean(sample_only_mother_female$English_points, na.rm = TRUE),
    mean(sample_only_mother_female$Income_equi_quint, na.rm = TRUE),
    mean(sample_only_mother_female$Fee_paying_W2, na.rm = TRUE) * 100,
    mean(sample_only_mother_female$DEIS_binary_W2, na.rm = TRUE) * 100,
    mean(sample_only_mother_female$Mixed, na.rm = TRUE) * 100,
    mean(sample_only_mother_female$PCG_Educ_W2_Dummy34, na.rm = TRUE) * 100,
    mean(sample_only_mother_female$PCG_Educ_W2_Dummy56, na.rm = TRUE) * 100
  ),
  
  Female_Both_Parents = c(
    mean(sample_both_parents_female$Maths_points, na.rm = TRUE),
    mean(sample_both_parents_female$English_points, na.rm = TRUE),
    mean(sample_both_parents_female$Income_equi_quint, na.rm = TRUE),
    mean(sample_both_parents_female$Fee_paying_W2, na.rm = TRUE) * 100,
    mean(sample_both_parents_female$DEIS_binary_W2, na.rm = TRUE) * 100,
    mean(sample_both_parents_female$Mixed, na.rm = TRUE) * 100,
    mean(sample_both_parents_female$PCG_Educ_W2_Dummy34, na.rm = TRUE) * 100,
    mean(sample_both_parents_female$PCG_Educ_W2_Dummy56, na.rm = TRUE) * 100
  ),
  
  Male_Only_Mother = c(
    mean(sample_only_mother_male$Maths_points, na.rm = TRUE),
    mean(sample_only_mother_male$English_points, na.rm = TRUE),
    mean(sample_only_mother_male$Income_equi_quint, na.rm = TRUE),
    mean(sample_only_mother_male$Fee_paying_W2, na.rm = TRUE) * 100,
    mean(sample_only_mother_male$DEIS_binary_W2, na.rm = TRUE) * 100,
    mean(sample_only_mother_male$Mixed, na.rm = TRUE) * 100,
    mean(sample_only_mother_male$PCG_Educ_W2_Dummy34, na.rm = TRUE) * 100,
    mean(sample_only_mother_male$PCG_Educ_W2_Dummy56, na.rm = TRUE) * 100
  ),
  
  Male_Both_Parents = c(
    mean(sample_both_parents_male$Maths_points, na.rm = TRUE),
    mean(sample_both_parents_male$English_points, na.rm = TRUE),
    mean(sample_both_parents_male$Income_equi_quint, na.rm = TRUE),
    mean(sample_both_parents_male$Fee_paying_W2, na.rm = TRUE) * 100,
    mean(sample_both_parents_male$DEIS_binary_W2, na.rm = TRUE) * 100,
    mean(sample_both_parents_male$Mixed, na.rm = TRUE) * 100,
    mean(sample_both_parents_male$PCG_Educ_W2_Dummy34, na.rm = TRUE) * 100,
    mean(sample_both_parents_male$PCG_Educ_W2_Dummy56, na.rm = TRUE) * 100
  )
)

# Perform t-tests for continuous variables by gender
p_values_gender <- c(
  t.test(sample_only_mother_female$Maths_points, sample_both_parents_female$Maths_points, var.equal = FALSE)$p.value,
  t.test(sample_only_mother_female$English_points, sample_both_parents_female$English_points, var.equal = FALSE)$p.value,
  t.test(sample_only_mother_female$Income_equi_quint, sample_both_parents_female$Income_equi_quint, var.equal = FALSE)$p.value,
  
  t.test(sample_only_mother_male$Maths_points, sample_both_parents_male$Maths_points, var.equal = FALSE)$p.value,
  t.test(sample_only_mother_male$English_points, sample_both_parents_male$English_points, var.equal = FALSE)$p.value,
  t.test(sample_only_mother_male$Income_equi_quint, sample_both_parents_male$Income_equi_quint, var.equal = FALSE)$p.value
)

# Create a full-length vector for p-values, adding NA for categorical variables
p_values_female <- c(
  p_values_gender[1:3],  # Maths, English, Income
  rep(NA, 5)  # No p-values for categorical variables
)

p_values_male <- c(
  p_values_gender[4:6],  # Maths, English, Income
  rep(NA, 5)  # No p-values for categorical variables
)

# Add p-values to the table
comparison_table_gender$p_value_female <- p_values_female
comparison_table_gender$p_value_male <- p_values_male

# Print results
print(comparison_table_gender)


# Print detailed summary
for (i in 1:nrow(comparison_table_gender)) {
  cat(comparison_table_gender$Variable[i], 
      "\nFemale Only Mother:", comparison_table_gender$Female_Only_Mother[i], 
      "\nFemale Both Parents:", comparison_table_gender$Female_Both_Parents[i], 
      "\nMale Only Mother:", comparison_table_gender$Male_Only_Mother[i], 
      "\nMale Both Parents:", comparison_table_gender$Male_Both_Parents[i], 
      "\nP-value (Female):", comparison_table_gender$p_value_female[i], 
      "\nP-value (Male):", comparison_table_gender$p_value_male[i], "\n\n")
}


library(dplyr)
library(tidyr)

# Create a combined dataset for chi-square tests (Female)
comparison_data_female <- Oaxaca_full %>%
  filter(Gender_factor == "Female") %>%
  mutate(group = case_when(
    is.na(SCG_Educ_W2) & SCG_Status_W2 == 0 ~ "Only Mother",
    !is.na(SCG_Educ_W2) & !is.na(PCG_Educ_W2) ~ "Both Parents",
    TRUE ~ NA_character_
  )) %>%
  filter(!is.na(group))  # Keep only the two relevant groups

# Create a combined dataset for chi-square tests (Male)
comparison_data_male <- Oaxaca_full %>%
  filter(Gender_factor == "Male") %>%
  mutate(group = case_when(
    is.na(SCG_Educ_W2) & SCG_Status_W2 == 0 ~ "Only Mother",
    !is.na(SCG_Educ_W2) & !is.na(PCG_Educ_W2) ~ "Both Parents",
    TRUE ~ NA_character_
  )) %>%
  filter(!is.na(group))  # Keep only the two relevant groups

# Perform chi-square tests for categorical variables (Female)
p_value_female_fee <- chisq.test(table(comparison_data_female$group, comparison_data_female$Fee_paying_W2))$p.value
p_value_female_deis <- chisq.test(table(comparison_data_female$group, comparison_data_female$DEIS_binary_W2))$p.value
p_value_female_mixed <- chisq.test(table(comparison_data_female$group, comparison_data_female$Mixed))$p.value
p_value_female_educ34 <- chisq.test(table(comparison_data_female$group, comparison_data_female$PCG_Educ_W2_Dummy34))$p.value
p_value_female_educ56 <- chisq.test(table(comparison_data_female$group, comparison_data_female$PCG_Educ_W2_Dummy56))$p.value

# Perform chi-square tests for categorical variables (Male)
p_value_male_fee <- chisq.test(table(comparison_data_male$group, comparison_data_male$Fee_paying_W2))$p.value
p_value_male_deis <- chisq.test(table(comparison_data_male$group, comparison_data_male$DEIS_binary_W2))$p.value
p_value_male_mixed <- chisq.test(table(comparison_data_male$group, comparison_data_male$Mixed))$p.value
p_value_male_educ34 <- chisq.test(table(comparison_data_male$group, comparison_data_male$PCG_Educ_W2_Dummy34))$p.value
p_value_male_educ56 <- chisq.test(table(comparison_data_male$group, comparison_data_male$PCG_Educ_W2_Dummy56))$p.value

# Update the comparison table with chi-square p-values
comparison_table_gender$p_value_female <- c(
  p_values_gender[1:3],  # Maths, English, Income
  p_value_female_fee, p_value_female_deis, p_value_female_mixed, 
  p_value_female_educ34, p_value_female_educ56  # Categorical chi-square p-values
)

comparison_table_gender$p_value_male <- c(
  p_values_gender[4:6],  # Maths, English, Income
  p_value_male_fee, p_value_male_deis, p_value_male_mixed, 
  p_value_male_educ34, p_value_male_educ56  # Categorical chi-square p-values
)

# Print results
print(comparison_table_gender)



library(dplyr)
# Create a dataset from Merged_Child with the partner/SCG information
scg_status_dataset <- Merged_Child_3 %>%
  select(ID, 
         # Wave 1 variables
         Partner, scgmain, 
         # Wave 2 variables  
         w2partner, w2scgmain) %>%
  mutate(
    w1_absence_type = case_when(
      Partner == 0 ~ "No partner in household",
      Partner == 1 & scgmain == 1 ~ "Partner present but did not complete questionnaire",
      Partner == 1 & scgmain == 2 ~ "Partner present and completed questionnaire",
      TRUE ~ "Missing data"
    ),
    w2_absence_type = case_when(
      w2partner == 0 ~ "No partner in household",
      w2partner == 1 & w2scgmain == 1 ~ "Partner present but did not complete questionnaire",
      w2partner == 1 & w2scgmain == 2 ~ "Partner present and completed questionnaire",
      TRUE ~ "Missing data"
    )
  )

# Take your existing father_absent_status from selected_data
father_status_dataset <- selected_data %>%
  select(ID, father_absent_status, Father_Educ_Missing_W1, Father_Educ_Missing_W2)

# Join them to create your complete analysis dataset
combined_father_dataset <- scg_status_dataset %>%
  left_join(father_status_dataset, by = "ID")

# Now analyze the relationships
absence_analysis <- combined_father_dataset %>%
  # Filter to only include records where we have father_absent_status data
  filter(!is.na(father_absent_status)) %>%
  # Count the relationships
  group_by(father_absent_status, w1_absence_type, w2_absence_type) %>%
  summarize(count = n()) %>%
  ungroup() %>%
  # Add percentages
  group_by(father_absent_status) %>%
  mutate(percentage = count / sum(count) * 100)

# Print the results
print(absence_analysis, windth = Inf)
# Wave 1 analysis
w1_analysis <- combined_father_dataset %>%
  filter(!is.na(father_absent_status)) %>%
  count(father_absent_status, w1_absence_type) %>%
  group_by(father_absent_status) %>%
  mutate(percentage = n / sum(n) * 100)

# Wave 2 analysis
w2_analysis <- combined_father_dataset %>%
  filter(!is.na(father_absent_status)) %>%
  count(father_absent_status, w2_absence_type) %>%
  group_by(father_absent_status) %>%
  mutate(percentage = n / sum(n) * 100)

print(w1_analysis)
print(w2_analysis)