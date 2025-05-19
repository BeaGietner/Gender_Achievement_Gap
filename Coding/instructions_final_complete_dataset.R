# Wave 1
# PCG highest level of education: MML37
# SCG highest level of education: FE1
# Income quintile equivalized: EIncQuin
# Drumcondra Maths test - Logit score: mathsls
# Drumcondra Reading test - Logit score: readingls
# Main Carer SDQ Emotional Subscale: MMH2_SDQemot
# Main Carer SDQ Conduct Subscale: MMH2_SDQcond
# Main Carer SDQ Hyperactivity Subscale: MMH2_SDQhyper
# Main Carer SDQ Peer Subscale: MMH2_SDQpeer
# How many boys enrolled: p4boyscat
# How many girls enrolled: p4girlscat

# Wave 2:
# PCG highest level of education: pc2h1
# SCG highest level of education: sc2e1
# Income quintile equivalized: w2eincquin
# Drumcondra Numerical Ability test - Logit score: nals
# Drumcondra Verbal Reasoning test - Logit score: vrls
# Drumcondra Total Score test - Logit score: totls
# BAS - total ability score for matrices: matabscore
# BAS - matrices age equivalent: matage
# Main Carer SDQ Emotional Subscale: w2pcd2_sdqemot
# Main Carer SDQ Conduct Subscale: w2pcd2_sdqcond
# Main Carer SDQ Hyperactivity Subscale: w2pcd2_sdqhyper
# Main Carer SDQ Peer Subscale: w2pcd2_sdqpeer
# What type of school is it?: p2q6 (1 = Fee-paying secondary (create dummy))
# Does your school take part in the DEIS Support Programme: p2q7
# Describe religious ethos of school? -> p2q5  (dummy for religious?)
# How many boys enrolled: p2q4a
# How many girls enrolled: p2q4b

# Wave 3
# PCG highest level of education: pc3f1educ
# SCG highest level of education: sc3e1educ
# Gender YP: p2sexW3
# Grades in Maths and English according to the level: cq3b32a, cq3b32b, cq3b33a, cq3b33b

# Wave 4
# LC points Maths: cq4F13_PointsMaths 
# LC level Maths: cq4F13c2
# LC points English: cq4F13_PointsEnglish
# LC level English: cq4F13b2
# Which points system applied to your (most recent) Leaving Cert examination?: cq4F10
# Did you sit the Leaving Certificate examinations?: cq4F8
# In what year did you sit your (most recent) Leaving Certificate examinations?: cq4F9

library(ggplot2)
library(haven)
library(dplyr)
library(labelled)
library(writexl)
library(readr)


# Loading the Waves
GUI_Chi_1 <- read_dta("C:/Users/bgiet/OneDrive/Documents/Paper 4 - GUI/0020-00 GUI_Child_Waves_1_2_3_4/0020-01 GUI Child Cohort Wave 1/0020-01 GUI Child Cohort Wave 1_Data/9 Year Cohort Data/Stata/GUI Data_9YearCohort.dta")
GUI_Chi_2 <- read_dta("C:/Users/bgiet/OneDrive/Documents/Paper 4 - GUI/0020-00 GUI_Child_Waves_1_2_3_4/0020-02 GUI Child Cohort Wave 2/0020-02 GUI Child Cohort Wave 2_Data/13 year cohort data/Stata/GUI Data_ChildCohortWave2.dta")
GUI_Chi_3 <- read_dta("C:/Users/bgiet/OneDrive/Documents/Paper 4 - GUI/0020-00 GUI_Child_Waves_1_2_3_4/0020-03 GUI Child Cohort Wave 3 revised/0020-03 GUI Child Cohort Wave 3_Data revised/Stata/0020-03_GUI_Data_ChildCohortWave3_V1.3.dta")
GUI_Chi_4 <- read_dta("C:/Users/bgiet/OneDrive/Documents/Paper 4 - GUI/0020-00 GUI_Child_Waves_1_2_3_4/0020-04 GUI Child Cohort Wave 4/0020-04 GUI Child Cohort Wave 4_Data/STATA/0020-04_GUI_Data_ChildCohortWave4.dta")


# Preserving all observations:
library(dplyr)
Merged_Child_all_observ <- GUI_Chi_1 %>%
  full_join(GUI_Chi_2, by = "ID") %>%
  full_join(GUI_Chi_3, by = "ID") %>%
  full_join(GUI_Chi_4, by = "ID")

# Select relevant variables 
selected_data <- Merged_Child_all_observ %>%
  select(ID,
         # Wave 1 Variables
         MML37, FE1, EIncQuin, mathsls, readingls, 
         MMH2_SDQemot, MMH2_SDQcond, MMH2_SDQhyper, MMH2_SDQpeer,
         p4boyscat, p4girlscat, # School Indicators
         
         # Wave 2 Variables
         pc2h1, sc2e1, w2eincquin, nals, vrls, totls, matabscore, matage,
         w2pcd2_sdqemot, w2pcd2_sdqcond, w2pcd2_sdqhyper, w2pcd2_sdqpeer,
         p2q6, p2q7, p2q5, p2q4a, p2q4b, # School indicators (Fee-paying, DEIS, Religious, Mixed versus Single-Sex)
         
         # Wave 3 Variables (Junior Cert Scores and Gender)
         p2sexW3, cq3b32a, cq3b32b, cq3b33a, cq3b33b,
         
         # Wave 4 Variables (Leaving Cert Scores)
         cq4F13_PointsMaths, cq4F13c2, cq4F13_PointsEnglish, cq4F13b2, cq4F10, cq4F8, cq4F9
  )

# Code for Mixed versus single-sex schools from wave 1
selected_data <- selected_data %>%
  mutate(
    mixed_school_w1 = case_when(
      p4boyscat == 1 | p4girlscat == 1 ~ 0,  # Single-sex school (either only boys or only girls)
      p4boyscat %in% 2:10 & p4girlscat %in% 2:10 ~ 1,  # Mixed school (both boys and girls enrolled)
      p4boyscat == 9999 | p4girlscat == 9999 ~ NA_real_,  # Don't know → NA
      TRUE ~ NA_real_  # Catch-all
    )
  )

# Check counts
table(selected_data$mixed_school_w1, useNA = "always")

# Code for Mixed versus single-sex schools from wave 2
selected_data <- selected_data %>%
  mutate(
    mixed_school_w2 = case_when(
      p2q4a == 1 | p2q4b == 1 ~ 0,  # Only boys or only girls (single-sex school)
      p2q4a %in% 2:10 & p2q4b %in% 2:10 ~ 1,  # Both boys and girls enrolled (mixed school)
      p2q4a %in% c(9998, 9999) | p2q4b %in% c(9998, 9999) ~ NA_real_,  # Refusal or Don't Know → NA
      TRUE ~ NA_real_  # Catch-all (should not happen)
    )
  )

# Check counts
table(selected_data$mixed_school_w2, useNA = "always")

# Code for religious school from Wave 2
selected_data <- selected_data %>%
  mutate(religious_school_w2 = ifelse(p2q5 %in% c(1, 2), 1, 0))


# Function to convert level and grade for English and Maths in Wave 3 into points
grade_to_point <- function(level, grade) {
  case_when(
    is.na(level) | is.na(grade) ~ NA_real_,
    
    level == 1 & grade == 1 ~ 12,  # Higher - A
    level == 1 & grade == 2 ~ 11,  # Higher - B
    level == 1 & grade == 3 ~ 10,  # Higher - C
    level == 1 & grade == 4 ~ 9,   # Higher - D
    level == 1 & grade == 5 ~ 8,   # Higher - E or lower
    
    level == 2 & grade == 1 ~ 9,   # Ordinary - A
    level == 2 & grade == 2 ~ 8,   # Ordinary - B
    level == 2 & grade == 3 ~ 7,   # Ordinary - C
    level == 2 & grade == 4 ~ 6,   # Ordinary - D
    level == 2 & grade == 5 ~ 5,   # Ordinary - E or lower
    
    level == 3 & grade == 1 ~ 6,   # Foundation - A
    level == 3 & grade == 2 ~ 5,   # Foundation - B
    level == 3 & grade == 3 ~ 4,   # Foundation - C
    level == 3 & grade == 4 ~ 3,   # Foundation - D
    level == 3 & grade == 5 ~ 2,   # Foundation - E or lower
    
    TRUE ~ NA_real_  # Catch-all for Don't know / Refusal
  )
}

selected_data <- selected_data %>%
  mutate(
    # Junior Cert English Points (Wave 3)
    English_points_W3 = case_when(
      cq3b32a %in% c(1, 2) & cq3b32b %in% c(1, 2, 3, 4, 5) ~ grade_to_point(cq3b32a, cq3b32b),
      TRUE ~ NA_real_
    ),
    
    # Junior Cert Maths Points (Wave 3)
    Maths_points_W3 = case_when(
      cq3b33a %in% c(1, 2, 3) & cq3b33b %in% c(1, 2, 3, 4, 5) ~ grade_to_point(cq3b33a, cq3b33b),
      TRUE ~ NA_real_
    )
  )

# Check if new columns were correctly created
glimpse(selected_data)
table(selected_data$English_points_W3, useNA = "always")
table(selected_data$Maths_points_W3, useNA = "always")

# Creating Fee_paying_W2 and DEIS_W2 Dummy Variables
selected_data <- selected_data %>%
  mutate(
    # Fee-paying school dummy (1 if school is fee-paying, 0 otherwise)
    Fee_paying_W2 = ifelse(p2q6 == 1, 1, 0),
    
    # DEIS school dummy (1 if school is part of DEIS programme, 0 otherwise)
    DEIS_W2 = ifelse(p2q7 == 1, 1, 0)
  )

# Check counts to verify
table(selected_data$Fee_paying_W2, useNA = "always")
table(selected_data$DEIS_W2, useNA = "always")


# Rename SDQ Variables in selected_data
selected_data <- selected_data %>%
  rename(
    # Wave 1 SDQ Variables
    SDQ_emot_PCG_W1 = MMH2_SDQemot,
    SDQ_cond_PCG_W1 = MMH2_SDQcond,
    SDQ_hyper_PCG_W1 = MMH2_SDQhyper,
    SDQ_peer_PCG_W1 = MMH2_SDQpeer,
    
    # Wave 2 SDQ Variables
    SDQ_emot_PCG_W2 = w2pcd2_sdqemot,
    SDQ_cond_PCG_W2 = w2pcd2_sdqcond,
    SDQ_hyper_PCG_W2 = w2pcd2_sdqhyper,
    SDQ_peer_PCG_W2 = w2pcd2_sdqpeer
  )

# Check if renaming was successful
glimpse(selected_data)

# Rename Education Variables
selected_data <- selected_data %>%
  rename(
    # Wave 1 Education Levels
    PCG_Educ_W1 = MML37,
    SCG_Educ_W1 = FE1,
    
    # Wave 2 Education Levels
    PCG_Educ_W2 = pc2h1,
    SCG_Educ_W2 = sc2e1
  )

selected_data <- selected_data %>%
  mutate(
    PCG_Educ_W2 = if_else(PCG_Educ_W2 == 98, NA_real_, PCG_Educ_W2),
    SCG_Educ_W2 = if_else(SCG_Educ_W2 == 98, NA_real_, SCG_Educ_W2)
  )

selected_data <- selected_data %>%
  mutate(
    # Wave 1 - PCG & SCG Education Dummies (Preserving NA)
    PCG_Educ_W1_Dummy34 = if_else(is.na(PCG_Educ_W1), NA_integer_, if_else(PCG_Educ_W1 %in% c(3, 4), 1, 0)),
    PCG_Educ_W1_Dummy56 = if_else(is.na(PCG_Educ_W1), NA_integer_, if_else(PCG_Educ_W1 %in% c(5, 6), 1, 0)),
    SCG_Educ_W1_Dummy34 = if_else(is.na(SCG_Educ_W1), NA_integer_, if_else(SCG_Educ_W1 %in% c(3, 4), 1, 0)),
    SCG_Educ_W1_Dummy56 = if_else(is.na(SCG_Educ_W1), NA_integer_, if_else(SCG_Educ_W1 %in% c(5, 6), 1, 0)),
    
    # Wave 2 - PCG & SCG Education Dummies (Preserving NA)
    PCG_Educ_W2_Dummy34 = if_else(is.na(PCG_Educ_W2), NA_integer_, if_else(PCG_Educ_W2 %in% c(3, 4), 1, 0)),
    PCG_Educ_W2_Dummy56 = if_else(is.na(PCG_Educ_W2), NA_integer_, if_else(PCG_Educ_W2 %in% c(5, 6), 1, 0)),
    SCG_Educ_W2_Dummy34 = if_else(is.na(SCG_Educ_W2), NA_integer_, if_else(SCG_Educ_W2 %in% c(3, 4), 1, 0)),
    SCG_Educ_W2_Dummy56 = if_else(is.na(SCG_Educ_W2), NA_integer_, if_else(SCG_Educ_W2 %in% c(5, 6), 1, 0))
  )

# Check counts of dummies
table(selected_data$PCG_Educ_W1_Dummy34, useNA = "always")
table(selected_data$PCG_Educ_W1_Dummy56, useNA = "always")
table(selected_data$SCG_Educ_W1_Dummy34, useNA = "always")
table(selected_data$SCG_Educ_W1_Dummy56, useNA = "always")

table(selected_data$PCG_Educ_W2_Dummy34, useNA = "always")
table(selected_data$PCG_Educ_W2_Dummy56, useNA = "always")
table(selected_data$SCG_Educ_W2_Dummy34, useNA = "always")
table(selected_data$SCG_Educ_W2_Dummy56, useNA = "always")

# Rename income variables
selected_data <- selected_data %>%
  rename(
    # Wave 1 Income Quintile
    Income_equi_quint_W1 = EIncQuin,
    
    # Wave 2 Income Quintile
    Income_equi_quint_W2 = w2eincquin
  )

# Fixing cognitive names
selected_data <- selected_data %>%
  rename(
    # Wave 1 Cognitive Variables
    Cog_Reading_W1_l = readingls,
    Cog_Maths_W1_l = mathsls,
    
    # Wave 2 Cognitive Variables (Drumcondra Scores)
    Drum_VR_W2_l = vrls,  # Verbal Reasoning (VR)
    Drum_NA_W2_l = nals,  # Numerical Ability (NA)
    Drum_Total_W2_l = totls,  # Total Score
    
    # Wave 2 Cognitive Variables (BAS Matrices)
    BAS_TS_Mat_W2 = matabscore,  # Total Score
    BAS_Age_Mat_W2 = matage  # Age Equivalent Score
  )

# Fixing gender
selected_data <- selected_data %>%
  rename(
    Gender_W3 = p2sexW3  # Rename gender variable for clarity
  ) %>%
  mutate(
    Gender_binary = if_else(Gender_W3 == 1, 1, 0)  # 1 = Male, 0 = Female
  )

# Check distribution
table(selected_data$Gender_binary, useNA = "always")

# Process Leaving Certificate (LC) Math and English variables
# Convert invalid values to NA instead of filtering out rows
selected_data <- selected_data %>%
  mutate(
    # Convert invalid values to NA for Maths LC points
    cq4F13_PointsMaths = if_else(cq4F13_PointsMaths %in% c(996, 997, 999), NA_real_, cq4F13_PointsMaths),
    cq4F13_PointsEnglish = if_else(cq4F13_PointsEnglish %in% c(996, 997, 999), NA_real_, cq4F13_PointsEnglish)
  ) %>%
  rename(
    Maths_LC_Points = cq4F13_PointsMaths,
    Maths_LC_Level = cq4F13c2,
    English_LC_Points = cq4F13_PointsEnglish,
    English_LC_Level = cq4F13b2,
    Grade_System = cq4F10,
    Sat_LC = cq4F8,
    Year_Sat_LC = cq4F9
  )

# Add derived Maths variables and Grade System harmonization
selected_data <- selected_data %>%
  mutate(
    # Raw Maths score after cleaning 996–999
    Maths_Points_Raw = Maths_LC_Points,
    
    # Adjusted Maths score (correct for bonus overreporting and cap)
    Maths_Points_Adjusted = case_when(
      Maths_LC_Points %in% c(115, 120, 125, 105, 110, 113, 102) ~ Maths_LC_Points - 25,
      Maths_LC_Points > 100 & Maths_LC_Level %in% c(1, 2) ~ NA_real_,  # Invalid: no bonus allowed
      Maths_LC_Points <= 100 ~ Maths_LC_Points,
      TRUE ~ NA_real_
    ),
    
    # Grading system dummy: 1 = new (post-2017), 0 = old
    Grade_System_Dummy = case_when(
      Grade_System == 2 ~ 1,
      Grade_System == 1 ~ 0,
      TRUE ~ NA_real_
    ),
    
    # Year student sat LC — categorical for exploration
    LC_Year = case_when(
      Year_Sat_LC == 1 ~ "2014/2015",
      Year_Sat_LC == 2 ~ "2016",
      Year_Sat_LC == 3 ~ "2017/2018",
      TRUE ~ NA_character_
    )
  )

selected_data <- selected_data %>%
  mutate(
    Maths_LC_Level_Label = factor(Maths_LC_Level,
                                  levels = c(1, 2, 3),
                                  labels = c("Foundation", "Ordinary", "Higher")
    )
  )


# Create father education availability/missing indicators
selected_data$Father_Educ_Available_W1 <- ifelse(is.na(selected_data$SCG_Educ_W1_Dummy34) & is.na(selected_data$SCG_Educ_W1_Dummy56), 0, 1)
selected_data$Father_Educ_Missing_W1 <- ifelse(is.na(selected_data$SCG_Educ_W1_Dummy34) & is.na(selected_data$SCG_Educ_W1_Dummy56), 1, 0)
selected_data$Father_Educ_Available_W2 <- ifelse(is.na(selected_data$SCG_Educ_W2_Dummy34) & is.na(selected_data$SCG_Educ_W2_Dummy56), 0, 1)
selected_data$Father_Educ_Missing_W2 <- ifelse(is.na(selected_data$SCG_Educ_W2_Dummy34) & is.na(selected_data$SCG_Educ_W2_Dummy56), 1, 0)

# Create father_absent_status variable
selected_data$father_absent_status_test <- case_when(
  # Father consistently present (provided education data in both waves)
  selected_data$Father_Educ_Missing_W1 == 0 & selected_data$Father_Educ_Missing_W2 == 0 ~ 0,
  
  # Father consistently absent (missing education data in both waves)
  selected_data$Father_Educ_Missing_W1 == 1 & selected_data$Father_Educ_Missing_W2 == 1 ~ 1,
  
  # Inconsistent patterns (present in one wave, absent in another)
  # Father present in Wave 1 only
  selected_data$Father_Educ_Missing_W1 == 0 & selected_data$Father_Educ_Missing_W2 == 1 ~ NA_real_,
  
  # Father present in Wave 2 only
  selected_data$Father_Educ_Missing_W1 == 1 & selected_data$Father_Educ_Missing_W2 == 0 ~ NA_real_,
  
  # Handle any other cases (shouldn't occur based on your data)
  TRUE ~ NA_real_
)

# Count occurrences of 99, 999, and 9999 in all columns
selected_data %>%
  summarise(across(everything(), ~ sum(. %in% c(99, 999, 9999), na.rm = TRUE)))
selected_data <- selected_data %>%
  mutate(across(everything(), ~ replace(., . %in% c(99, 999, 9999), NA_real_)))

# Check the number of NAs in each column
colSums(is.na(selected_data))
write.csv(selected_data, "selected_data.csv", row.names = FALSE)


# Define the outcome variable for decomposition models
dependent_var <- "Maths_Points_Adjusted"  # Use the harmonized, cleaned outcome

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
  "ID", "Maths_LC_Points", "Maths_Points_Raw", "Maths_Points_Adjusted", 
  "Grade_System_Dummy", "LC_Year", "Gender_binary",
  wave1_vars, wave2_vars, grouping_vars
)

# Create full decomposition dataset
decomposition_dataset <- selected_data %>%
  select(all_of(all_vars)) %>%
  filter(!is.na(Maths_Points_Adjusted), !is.na(Gender_binary))

# Save full dataset
write.csv(decomposition_dataset, "decomposition_dataset.csv", row.names = FALSE)

# Print dimensions and distribution checks
cat("Dimensions of decomposition_dataset:", dim(decomposition_dataset), "\n")

cat("\nFather presence distribution:\n")
with(decomposition_dataset, table(Father_Educ_Missing_W1, Father_Educ_Missing_W2, useNA = "always"))

cat("\nGender distribution:\n")
with(decomposition_dataset, table(Gender_binary, useNA = "always"))

# Create complete-case subset for decompositions (no missing predictors or group vars)
complete_case_subset <- decomposition_dataset %>%
  select(all_of(c("ID", dependent_var, wave1_vars, wave2_vars, grouping_vars))) %>%
  filter(complete.cases(.))

# Report how much data is retained
n_total <- nrow(decomposition_dataset)
n_kept <- nrow(complete_case_subset)
percent_kept <- round((n_kept / n_total) * 100, 2)

cat("\nComplete case subset keeps", percent_kept, "% of decomposition data (", n_kept, "of", n_total, "rows)\n")

# Show sample sizes by gender and father presence
complete_case_subset %>%
  group_by(Gender_binary, father_absent_status_test) %>%
  summarise(count = n(), .groups = "drop") %>%
  mutate(
    gender_label = ifelse(Gender_binary == 1, "Boys", "Girls"),
    father_status = ifelse(father_absent_status_test == 1, "Father Absent", "Father Present")
  ) %>%
  select(gender_label, father_status, count)

# Save complete-case subset
write.csv(complete_case_subset, "complete_case_subset.csv", row.names = FALSE)


# Use harmonized Maths outcome
dependent_var <- "Maths_Points_Adjusted"

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
complete_case_subset <- selected_data %>%
  select(ID, all_of(all_needed_vars)) %>%
  filter(complete.cases(.))

# Output data diagnostics
n_total <- nrow(selected_data)
n_kept <- nrow(complete_case_subset)
percent_kept <- round((n_kept / n_total) * 100, 2)

cat("Keeping", percent_kept, "% of the original observations (", n_kept, "of", n_total, ")\n")

# Distribution check by Gender and Father Absence
complete_case_subset %>%
  group_by(Gender_binary, father_absent_status_test) %>%
  summarise(count = n(), .groups = "drop") %>%
  mutate(
    gender_label = ifelse(Gender_binary == 1, "Boys", "Girls"),
    father_status = ifelse(father_absent_status_test == 1, "Father Absent", "Father Present")
  ) %>%
  select(gender_label, father_status, count)

# Save to CSV
write.csv(complete_case_subset, "complete_case_subset.csv", row.names = FALSE)

# Optional: Export to Stata
# library(haven)
# write_dta(complete_case_subset, "complete_case_subset.dta")

names(decomposition_dataset)

# Load libraries
library(tidyverse)
library(psych)
library(kableExtra)
library(skimr)
library(xtable)

# ---------------------
# Variable groups
# ---------------------
names(selected_data)
parental_educ_vars <- c("PCG_Educ_W1", "SCG_Educ_W1", "PCG_Educ_W2", "SCG_Educ_W2")
income_vars        <- c("Income_equi_quint_W1", "Income_equi_quint_W2")
cognitive_vars     <- c("Cog_Reading_W1_l", "Cog_Maths_W1_l", "Drum_NA_W2_l", "Drum_VR_W2_l", 
                        "Drum_Total_W2_l", "BAS_TS_Mat_W2", "BAS_Age_Mat_W2")
sdq_vars           <- c("SDQ_emot_PCG_W1", "SDQ_cond_PCG_W1", "SDQ_hyper_PCG_W1", "SDQ_peer_PCG_W1",
                        "SDQ_emot_PCG_W2", "SDQ_cond_PCG_W2", "SDQ_hyper_PCG_W2", "SDQ_peer_PCG_W2")
school_vars        <- c("Fee_paying_W2", "DEIS_W2", "religious_school_w2", "mixed_school_w1", "mixed_school_w2")
outcome_vars       <- c("English_points_W3", "Maths_points_W3", "Maths_LC_Points", "English_LC_Points", )

all_vars <- c(parental_educ_vars, income_vars, cognitive_vars, sdq_vars, school_vars, outcome_vars)

# ---------------------
# Summary Function
# ---------------------
create_summary <- function(data, vars, group_name) {
  data %>%
    select(all_of(vars)) %>%
    psych::describe() %>%
    as_tibble(rownames = "Variable") %>%
    select(Variable, n, mean, sd, median, min, max, skew, kurtosis) %>%
    mutate(Group = group_name) %>%
    mutate(across(where(is.numeric), round, 2))
}

# ---------------------
# Generate Grouped Summaries
# ---------------------
summaries <- list(
  create_summary(selected_data, parental_educ_vars, "Parental Education"),
  create_summary(selected_data, income_vars, "Income"),
  create_summary(selected_data, cognitive_vars, "Cognitive Scores"),
  create_summary(selected_data, sdq_vars, "SDQ Measures"),
  create_summary(selected_data, school_vars, "School Characteristics"),
  create_summary(selected_data, outcome_vars, "Educational Outcomes")
)

# Combine all into one
summary_all <- bind_rows(summaries)

# ---------------------
# Print full summary
# ---------------------
print(summary_all, width = Inf)

# ---------------------
# Generate HTML Table
# ---------------------
nice_table <- summary_all %>%
  select(Group, Variable, n, mean, sd, median, min, max) %>%
  kable(format = "html", caption = "Comprehensive Summary Statistics") %>%
  kable_styling(bootstrap_options = c("striped", "hover", "condensed")) %>%
  pack_rows(index = table(summary_all$Group))

# ---------------------
# Generate LaTeX Table
# ---------------------
latex_table <- summary_all %>%
  select(Group, Variable, n, mean, sd, median, min, max) %>%
  kable(format = "latex", caption = "Comprehensive Summary Statistics",
        booktabs = TRUE, col.names = c("Group", "Variable", "N", "Mean", "SD", "Median", "Min", "Max")) %>%
  kable_styling(latex_options = c("striped", "scale_down")) %>%
  pack_rows(index = table(summary_all$Group))

# Save LaTeX
cat(latex_table, file = "summary_statistics.tex")

# Optional: xtable export
xtable_output <- xtable(summary_all, caption = "Comprehensive Summary Statistics")
print(xtable_output, file = "summary_statistics_xtable.tex", include.rownames = FALSE)

# ---------------------
# Gender Comparison (optional)
# ---------------------
gender_comparison <- function(gender_val, label) {
  selected_data %>%
    filter(Gender_binary == gender_val) %>%
    select(all_of(outcome_vars)) %>%
    psych::describe() %>%
    as_tibble(rownames = "Variable") %>%
    mutate(Group = label)
}

boys_summary <- gender_comparison(1, "Boys")
girls_summary <- gender_comparison(0, "Girls")

gender_compare_table <- boys_summary %>%
  select(Variable, n_boys = n, mean_boys = mean, sd_boys = sd) %>%
  left_join(girls_summary %>%
              select(Variable, n_girls = n, mean_girls = mean, sd_girls = sd),
            by = "Variable") %>%
  mutate(diff = round(mean_boys - mean_girls, 2)) %>%
  mutate(across(where(is.numeric), round, 2))

# Export gender comparison
gender_latex <- gender_compare_table %>%
  kable(format = "latex", booktabs = TRUE, caption = "Gender Comparison of Educational Outcomes")

cat(gender_latex, file = "gender_comparison.tex")


# adding new educ variables from wave 3:
wave3_educ <- Merged_Child_all_observ %>%
  select(ID,
         PCG_Educ_W3 = pc3f1educ,
         SCG_Educ_W3 = sc3e1educ) %>%
  mutate(
    PCG_Educ_W3_Dummy34 = if_else(is.na(PCG_Educ_W3), NA_integer_, if_else(PCG_Educ_W3 %in% c(3, 4), 1, 0)),
    PCG_Educ_W3_Dummy56 = if_else(is.na(PCG_Educ_W3), NA_integer_, if_else(PCG_Educ_W3 %in% c(5, 6), 1, 0)),
    SCG_Educ_W3_Dummy34 = if_else(is.na(SCG_Educ_W3), NA_integer_, if_else(SCG_Educ_W3 %in% c(3, 4), 1, 0)),
    SCG_Educ_W3_Dummy56 = if_else(is.na(SCG_Educ_W3), NA_integer_, if_else(SCG_Educ_W3 %in% c(5, 6), 1, 0))
  )

decomposition_dataset_W3 <- decomposition_dataset %>%
  left_join(wave3_educ, by = "ID")

decomposition_dataset_W3 <- decomposition_dataset_W3 %>%
  mutate(Father_Educ_Missing_W3 = if_else(is.na(SCG_Educ_W3), 1, 0))


