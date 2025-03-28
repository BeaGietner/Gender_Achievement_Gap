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
# Gender YP: p2sexW3
# Grades in Maths and English according to the level: cq3b32a, cq3b32b, cq3b33a, cq3b33b
library(readr)
Merged_Child <- read_csv("GitHub/Gender_Achievement_Gap/Datasets/Merged_Child.csv")
View(Merged_Child)

library(dplyr)

# Select relevant variables from Merged_Child_3
selected_data <- Merged_Child_3 %>%
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
    p2sexW3, cq3b32a, cq3b32b, cq3b33a, cq3b33b
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



# Count occurrences of 99, 999, and 9999 in all columns
selected_data %>%
  summarise(across(everything(), ~ sum(. %in% c(99, 999, 9999), na.rm = TRUE)))
selected_data <- selected_data %>%
  mutate(across(everything(), ~ replace(., . %in% c(99, 999, 9999), NA_real_)))

# Check the number of NAs in each column
colSums(is.na(selected_data))


write.csv(selected_data, "selected_data.csv", row.names = FALSE)



# Summary statistics for selected key variables
summary(selected_data %>%
          select(
            # Parental Education
            PCG_Educ_W1, SCG_Educ_W1, PCG_Educ_W2, SCG_Educ_W2,
            
            # Income
            Income_equi_quint_W1, Income_equi_quint_W2,
            
            # Cognitive Scores
            Cog_Reading_W1_l, Cog_Maths_W1_l,
            Drum_NA_W2_l, Drum_VR_W2_l, Drum_Total_W2_l,
            BAS_TS_Mat_W2, BAS_Age_Mat_W2,
            
            # SDQ Measures
            SDQ_emot_PCG_W1, SDQ_cond_PCG_W1, SDQ_hyper_PCG_W1, SDQ_peer_PCG_W1,
            SDQ_emot_PCG_W2, SDQ_cond_PCG_W2, SDQ_hyper_PCG_W2, SDQ_peer_PCG_W2,
            
            # School Characteristics
            Fee_paying_W2, DEIS_W2, religious_school_w2, mixed_school_w1, mixed_school_w2,
            
            # Junior Cert Scores
            English_points_W3, Maths_points_W3
          ))

library(skimr)

# Skim selected key variables
skim(selected_data %>%
       select(
         PCG_Educ_W1, SCG_Educ_W1, PCG_Educ_W2, SCG_Educ_W2,
         PCG_Educ_W1_Dummy34, PCG_Educ_W1_Dummy56, SCG_Educ_W1_Dummy34, SCG_Educ_W1_Dummy56,
         PCG_Educ_W2_Dummy34, PCG_Educ_W2_Dummy56, SCG_Educ_W2_Dummy34, SCG_Educ_W2_Dummy56,
         Income_equi_quint_W1, Income_equi_quint_W2,
         Cog_Reading_W1_l, Cog_Maths_W1_l,
         Drum_NA_W2_l, Drum_VR_W2_l, Drum_Total_W2_l,
         BAS_TS_Mat_W2, BAS_Age_Mat_W2,
         SDQ_emot_PCG_W1, SDQ_cond_PCG_W1, SDQ_hyper_PCG_W1, SDQ_peer_PCG_W1,
         SDQ_emot_PCG_W2, SDQ_cond_PCG_W2, SDQ_hyper_PCG_W2, SDQ_peer_PCG_W2,
         Gender_W3,
         Fee_paying_W2, DEIS_W2, religious_school_w2, mixed_school_w1, mixed_school_w2,
         English_points_W3, Maths_points_W3
       ))


library(dplyr)

# Compute summary statistics for selected variables
summary_stats <- selected_data %>%
  summarise(
    # Count non-missing observations for each variable
    Obs = colSums(!is.na(.)),
    
    # Mean, standard deviation, min, and max for each variable
    Mean = sapply(., function(x) ifelse(is.numeric(x), mean(x, na.rm = TRUE), NA)),
    SD = sapply(., function(x) ifelse(is.numeric(x), sd(x, na.rm = TRUE), NA)),
    Min = sapply(., function(x) ifelse(is.numeric(x), min(x, na.rm = TRUE), NA)),
    Max = sapply(., function(x) ifelse(is.numeric(x), max(x, na.rm = TRUE), NA))
  ) %>%
  tibble::rownames_to_column("Variable")  # Convert row names to column

# Print the summary statistics
print(summary_stats)


# Convert all columns except 'ID' to numeric (if not already)
selected_data <- selected_data %>%
  mutate(across(where(is.character), as.numeric)) %>%
  mutate(across(where(is.factor), as.numeric))

# Check the structure to confirm changes
str(selected_data)
