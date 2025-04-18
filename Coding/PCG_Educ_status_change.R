# Remove rows with NA values in PCG_Educ_W2 or PCG_Educ_W3
Oaxaca_Blinder_clean <- Oaxaca_Blinder %>%
  filter(!is.na(PCG_Educ_W2) & !is.na(PCG_Educ_W3))

# Create a new variable to track status changes
Oaxaca_Blinder_clean <- Oaxaca_Blinder_clean %>%
  mutate(Status_Change = case_when(
    PCG_Educ_W2 == PCG_Educ_W3 ~ "No Change",
    PCG_Educ_W2 != PCG_Educ_W3 ~ "Changed"
  ))

# Summarize the changes
summary_table <- Oaxaca_Blinder_clean %>%
  count(Status_Change)

print(summary_table)

detailed_summary <- Oaxaca_Blinder_clean %>%
  group_by(PCG_Educ_W2, PCG_Educ_W3) %>%
  count() %>%
  arrange(PCG_Educ_W2, PCG_Educ_W3)

print(detailed_summary)


complete_info_dataset_SDQ_English_clean <- complete_info_dataset_SDQ_English %>%
  mutate(Status_Change = case_when(
    PCG_Educ_W2 == PCG_Educ_W3 ~ "No Change",
    PCG_Educ_W2 != PCG_Educ_W3 ~ "Changed"
  ))

# Summarize the changes
summary_table <- complete_info_dataset_SDQ_English_clean %>%
  count(Status_Change)

print(summary_table)

detailed_summary <- complete_info_dataset_SDQ_English_clean %>%
  group_by(PCG_Educ_W2, PCG_Educ_W3) %>%
  count() %>%
  arrange(PCG_Educ_W2, PCG_Educ_W3)

print(detailed_summary)
