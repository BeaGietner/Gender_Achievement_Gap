# Remove rows with NA values in Gender_YP_W2 or Gender_YP_W3
Oaxaca_Blinder <- Oaxaca_Blinder %>%
  filter(!is.na(Gender_YP_W2) & !is.na(Gender_YP_W3))

# Create a new variable to track status changes
Oaxaca_Blinder <- Oaxaca_Blinder_clean %>%
  mutate(Status_Change = case_when(
    Gender_YP_W2 == Gender_YP_W3 ~ "No Change",
    Gender_YP_W2 != Gender_YP_W3 ~ "Changed"
  ))

# Summarize the changes
summary_table <- Oaxaca_Blinder %>%
  count(Status_Change)

print(summary_table)

detailed_summary <- Oaxaca_Blinder%>%
  group_by(Gender_YP_W2, Gender_YP_W3) %>%
  count() %>%
  arrange(Gender_YP_W2, Gender_YP_W3)

print(detailed_summary)


# Check the records where gender differs between waves
inconsistent_entries <- Oaxaca_Blinder %>%
  filter(Gender_YP_W2 != Gender_YP_W3)

print(inconsistent_entries)

