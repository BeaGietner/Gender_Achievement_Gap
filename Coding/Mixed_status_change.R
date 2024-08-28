# Remove rows with NA values in Mixed_W2 or Mixed_W3
Oaxaca_Blinder_clean <- Oaxaca_Blinder %>%
  filter(!is.na(Mixed_W2) & !is.na(Mixed_W3))

# Create a new variable to track status changes
Oaxaca_Blinder_clean <- Oaxaca_Blinder_clean %>%
  mutate(Status_Change = case_when(
    Mixed_W2 == Mixed_W3 ~ "No Change",
    Mixed_W2 != Mixed_W3 ~ "Changed"
  ))

# Summarize the changes
summary_table <- Oaxaca_Blinder_clean %>%
  count(Status_Change)

print(summary_table)

detailed_summary <- Oaxaca_Blinder_clean %>%
  group_by(Mixed_W2, Mixed_W3) %>%
  count() %>%
  arrange(Mixed_W2, Mixed_W3)

print(detailed_summary)


complete_info_dataset_SDQ_English_clean <- complete_info_dataset_SDQ_English %>%
  mutate(Status_Change = case_when(
    Mixed_W2 == Mixed_W3 ~ "No Change",
    Mixed_W2 != Mixed_W3 ~ "Changed"
  ))

# Summarize the changes
summary_table <- complete_info_dataset_SDQ_English_clean %>%
  count(Status_Change)

print(summary_table)

detailed_summary <- complete_info_dataset_SDQ_English_clean %>%
  group_by(Mixed_W2, Mixed_W3) %>%
  count() %>%
  arrange(Mixed_W2, Mixed_W3)

print(detailed_summary)
