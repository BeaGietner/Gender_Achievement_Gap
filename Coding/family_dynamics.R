# Wave 1

dplyr::count(Merged_Child_all_observ,MS14) # PCG: Current Marital Status, similar to pc2s12
dplyr::count(Merged_Child_all_observ,FS14) # SCG: Current Marital Status, similar to sc2s12
dplyr::count(Merged_Child_all_observ,Partner) # Partner in household, similar to w2partner
dplyr::count(Merged_Child_all_observ,scgmain) # Secondary Caregiver Q Completed - Wave 1, 0 = No resident partner, 1 = Partner resident, not completed, 2 = Partner resident, completed

# Wave 2


dplyr::count(Merged_Child_all_observ,pc2s12) # PCG: Can you tell me which of these best describes your current marital status?
                                  # 1 = Married and living with husband/wife, 2 = Married and separated from husband/wife 3 = Divorced / Widowed, 4 = Widowed, 5 = Never married
dplyr::count(Merged_Child_all_observ,sc2s12) # SCG: Can you tell me which of these best describes your current marital status?
dplyr::count(Merged_Child_all_observ,scgstatph2) # SCG if present same as Wave 1, 0 = No, 1 = Yes, 
                                      # Wave 1 status of person who is Secondary Caregiver Status at Wave 2
dplyr::count(Merged_Child_all_observ,w2partner) # PCG: Partner in the household
dplyr::count(Merged_Child_all_observ,w2scgmain) # Secondary Caregiver Q Completed - Wave 2 0 = No resident partner, 1 = Partner resident, not completed, 2 = Partner resident, completed

# Wave 3

dplyr::count(Merged_Child_all_observ,pc3s12) # PCG: Current legal marital status
dplyr::count(Merged_Child_all_observ,sc3s12) # SCG Current legal marital status
dplyr::count(Merged_Child_all_observ,w3partner) # PCG: Partner in household, similar to w2partner
dplyr::count(Merged_Child_all_observ,w3scgmain) # Secondary Caregiver Q Completed - Wave 3
dplyr::count(Merged_Child_all_observ,scgstatph3) # SCG if present same as Wave 2

# W1 -> W2 -> W3
# MS14 -> pc2s12 -> pc3s12
# FS14 -> sc2s12 -> sc3s12
# Partner -> w2partner -> w3partner
# scgmain -> w2scgmain -> w3scgmain
# nothing in wave 1, scgstatph2 -> scgstatph3

# Create a transition analysis by ID from wave 1 to wave 2 
transitions_W12 <- Merged_Child_all_observ %>%
  select(ID, Partner, w2partner, w3partner, MS14, pc2s12, scgmain, w2scgmain) %>%
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
partner_transition <- table(Merged_Child_all_observ$Partner, Merged_Child_all_observ$w2partner, 
                            dnn = c("Wave1_Partner", "Wave2_Partner"))
print(partner_transition)

# Create a transition table for PCG marital status
pcg_marital_transition <- table(Merged_Child_all_observ$MS14, Merged_Child_all_observ$pc2s12,
                                dnn = c("Wave1_PCG_Marital", "Wave2_PCG_Marital"))
print(pcg_marital_transition)

# Create a transition table for SCG presence
scg_transition <- table(Merged_Child_all_observ$scgmain, Merged_Child_all_observ$w2scgmain,
                        dnn = c("Wave1_SCG", "Wave2_SCG"))
print(scg_transition)




library(dplyr)


# Create a transition analysis by ID from wave 2 to wave 3
transitions_W23 <- Merged_Child_all_observ %>%
  select(ID, Partner, w2partner, w3partner, pc2s12, pc3s12, w2scgmain, w3scgmain) %>%
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
partner_transition_W23 <- table(Merged_Child_all_observ$w2partner, Merged_Child_all_observ$w3partner, 
                                dnn = c("Wave2_Partner", "Wave3_Partner"))
print(partner_transition_W23)

# Create a transition table for PCG marital status
pcg_marital_transition_W23 <- table(Merged_Child_all_observ$pc2s12, Merged_Child_all_observ$pc3s12,
                                    dnn = c("Wave2_PCG_Marital", "Wave3_PCG_Marital"))
print(pcg_marital_transition_W23)

# Create a transition table for SCG presence
scg_transition_W23 <- table(Merged_Child_all_observ$w2scgmain, Merged_Child_all_observ$w3scgmain,
                            dnn = c("Wave2_SCG", "Wave3_SCG"))
print(scg_transition_W23)


combined_father_dataset %>%
  filter(Father_Educ_Missing_W3 == 1) %>%
  count(w3_absence_type) %>%
  mutate(pct = n / sum(n) * 100)


nrow(combined_father_dataset)
n_distinct(combined_father_dataset$ID)




attrition_check <- Merged_Child_all_observ %>%
  mutate(
    # SCG education availability dummies
    SCG_Educ_Missing_W1 = if_else(FE1 %in% c(98, NA), 1, 0),
    SCG_Educ_Missing_W2 = if_else(sc2e1 %in% c(98, NA), 1, 0),
    
    # Define father_absent_status based on both waves
    father_absent_status = case_when(
      SCG_Educ_Missing_W1 == 1 & SCG_Educ_Missing_W2 == 1 ~ 1,  # consistently absent
      SCG_Educ_Missing_W1 == 0 & SCG_Educ_Missing_W2 == 0 ~ 0,  # consistently present
      TRUE ~ NA_real_  # mixed cases or missing
    ),
    
    # Outcome availability in Wave 4
    Maths_LC_Missing = if_else(cq4F13_PointsMaths %in% c(996, 997, 999, NA), 1, 0)
  )

attrition_summary <- attrition_check %>%
  filter(!is.na(father_absent_status)) %>%
  group_by(father_absent_status) %>%
  summarise(
    total = n(),
    missing = sum(Maths_LC_Missing, na.rm = TRUE),
    missing_pct = round(100 * missing / total, 1),
    present = total - missing,
    present_pct = round(100 * present / total, 1)
  )

print(attrition_summary)

chisq_table <- table(attrition_check$father_absent_status, attrition_check$Maths_LC_Missing)
chisq.test(chisq_table)


attrition_check <- Merged_Child_all_observ %>%
  mutate(
    SCG_Educ_Missing_W1 = if_else(FE1 %in% c(98, NA), 1, 0),
    SCG_Educ_Missing_W2 = if_else(sc2e1 %in% c(98, NA), 1, 0),
    father_absent_status = case_when(
      SCG_Educ_Missing_W1 == 1 & SCG_Educ_Missing_W2 == 1 ~ 1,
      SCG_Educ_Missing_W1 == 0 & SCG_Educ_Missing_W2 == 0 ~ 0,
      TRUE ~ NA_real_
    )
  )

attrition_check <- attrition_check %>%
  mutate(
    w3_absence_type = case_when(
      w3partner == 0 ~ "No partner in household",
      w3partner == 1 & w3scgmain == 1 ~ "Partner present but did not complete questionnaire",
      w3partner == 1 & w3scgmain == 2 ~ "Partner present and completed questionnaire",
      TRUE ~ "Missing data"
    )
  )

w3_absent_group <- attrition_check %>%
  filter(father_absent_status == 1) %>%
  count(w3_absence_type) %>%
  mutate(pct = round(100 * n / sum(n), 1))
print(w3_absent_group)


w3_present_group <- attrition_check %>%
  filter(father_absent_status == 0) %>%
  count(w3_absence_type) %>%
  mutate(pct = round(100 * n / sum(n), 1))
print(w3_present_group)


attrition_check <- attrition_check %>%
  mutate(
    Maths_LC_Missing = if_else(cq4F13_PointsMaths %in% c(996, 997, 999, NA), 1, 0)
  )

attrition_summary <- attrition_check %>%
  filter(!is.na(father_absent_status)) %>%
  group_by(father_absent_status) %>%
  summarise(
    total = n(),
    missing = sum(Maths_LC_Missing),
    missing_pct = round(100 * missing / total, 1)
  )
print(attrition_summary)



filter(Father_Educ_Missing_W3 == 1)

library(dplyr)

# 1. Create updated SCG status dataset with Wave 1–3
scg_status_dataset <- Merged_Child_all_observ %>%
  select(ID, 
         # Wave 1 variables
         Partner, scgmain, 
         # Wave 2 variables  
         w2partner, w2scgmain,
         # Wave 3 variables
         w3partner, w3scgmain
  ) %>%
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
    ),
    w3_absence_type = case_when(
      w3partner == 0 ~ "No partner in household",
      w3partner == 1 & w3scgmain == 1 ~ "Partner present but did not complete questionnaire",
      w3partner == 1 & w3scgmain == 2 ~ "Partner present and completed questionnaire",
      TRUE ~ "Missing data"
    )
  )

# 2. Pull father absence indicators (including W3) from updated dataset
father_absent <- decomposition_dataset_W3 %>%
  select(ID, father_absent_status_test, Father_Educ_Missing_W1, Father_Educ_Missing_W2, Father_Educ_Missing_W3)

# 3. Merge into combined dataset
combined_father_dataset <- scg_status_dataset %>%
  left_join(father_absent, by = "ID")

# 4. Analyze W1–W2–W3 transitions (full 3-wave structure)
absence_analysis <- combined_father_dataset %>%
  filter(!is.na(father_absent_status_test)) %>%
  group_by(father_absent_status_test, w1_absence_type, w2_absence_type, w3_absence_type) %>%
  summarize(count = n(), .groups = "drop") %>%
  group_by(father_absent_status_test) %>%
  mutate(percentage = count / sum(count) * 100)

# Print full 3-wave transitions
print(absence_analysis, width = Inf)

# 5. Wave-specific breakdowns
w1_analysis <- combined_father_dataset %>%
  filter(!is.na(father_absent_status_test)) %>%
  count(father_absent_status_test, w1_absence_type) %>%
  group_by(father_absent_status_test) %>%
  mutate(percentage = n / sum(n) * 100)

w2_analysis <- combined_father_dataset %>%
  filter(!is.na(father_absent_status_test)) %>%
  count(father_absent_status_test, w2_absence_type) %>%
  group_by(father_absent_status_test) %>%
  mutate(percentage = n / sum(n) * 100)

w3_analysis <- combined_father_dataset %>%
  filter(!is.na(Father_Educ_Missing_W3)) %>%
  count(Father_Educ_Missing_W3, w3_absence_type) %>%
  group_by(Father_Educ_Missing_W3) %>%
  mutate(percentage = n / sum(n) * 100)

# 6. Print all three
print(w1_analysis)
print(w2_analysis)
print(w3_analysis)


