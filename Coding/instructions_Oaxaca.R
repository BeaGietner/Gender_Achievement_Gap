# Variables:
# From Wave 4:
# Leaving Cert
# did English: cq4F13b1
# did Maths: cq4F13c1
# leaving cert Maths level: cq4F13c2 (1 Foundation, 2 Ordinary, 3 Higher)
# leaving cert English level: cq4F13b2 (2 Ordinary/Foundation, 3 Higher)
# leaving cert Maths points: cq4F13_PointsMaths
# leaving cert English points: cq4F13_PointsEnglish

# TIPI according to YP
# w4cq_agreeable, w4cq_emotstab, w4cq_conscientious, w4cq_extravert, w4cq_openness

# cognitive measures:
# CognitiveNamingFruit

# TIPI according to PCG
# w4pc_agreeable, w4pc_emotstab, w4pc_conscientious, w4pc_extravert, w4pc_openness

# In your final school year, do/did you have any grinds or private tuition in any of
# your school subjects? -> cq4F22
# extra help in English: cq4f27a
# extra help in Maths: cq4F27b
#-------------------------------------------------------------------------
# From Wave 3

# Noncognitive measures

# TIPI YP: 
# w3cq_extravert, w3cq_agreeable, w3cq_conscientious, w3cq_emotstab, w3cq_openness
# TIPI PCG:
# w3pc_extravert, w3pc_agreeable, w3pc_conscientious, w3pc_emotstab, w3pc_openness
# TIPI SCG
# w3sc_extravert, w3sc_agreeable, w3sc_conscientious, w3sc_emotstab, w3sc_openness

# SDQ PCG:
# w3pcg_SDQemotional, w3pcg_SDQconduct, w3pcg_SDQhyper, w3pcg_SDQpeerprobs
# SDQ SCG:
# w3scg_SDQemotional, w3scg_SDQconduct, w3scg_SDQhyper, w3scg_SDQpeerprobs

# Cognitive measures:

# CognitiveNamingTotal, CognitiveMathsTotal, CognitiveVocabularyTotal
#------------------------------------------------------
# Control variables:

# SES
# YP gender:p2sexW3
# Education levels:
# primary caregiver: pc3f1educ
# secondary caregiver: sc3e1educ
# household income (quintile equivalized): w3eincquin

# School characteristics:
# Does your school take part in the DEIS Support Programme? p3q7 (1 = yes)
# What type of school it is: p3q6 (1 = Fee-paying secondary)
# Number of boys: p3q4a (if = 0, it's a girls only school)
# Number of boys: p3q4b (if = 0, it's a boys only school)

# Adding Teacher evaluations from Wave 1
# TC10a Academic performance - reading
# TC10b Academic performance - writing
# TC10c Academic performance - comprehension
# TC10d Academic performance - mathematics
# TC10e Academic performance - imagination/creativity
# TC10f Academic performance - oral communications
# TC10g Academic performance - problem solving

# Cognitive Measures from wave 1:
# The Study Child also completed two academic assessments in a groupsetting within the school. 
# These were the Vocabulary part of the Drumcondra Primary Reading Test – Revised, and Part 1 
# of the Drumcondra Primary Maths Test – Revised. The children completed Level
# 2, 3 or 4 for each test depending on which class level they were in. The
# Drumcondra Maths and Reading Tests were developed for Irish school
# children and are linked to the national curriculum.
# reading class level sat (readclass)
# reading percentage correct (readpct)
# maths class level sat (mathclass)
# maths percentage correct (mathpct)

# Controls from the other waves

# Wave 2
# Type of School
# What type of school is it? -> p2q6

# Single-sex x Mixed
# How many boys enrolled -> p2q4a
# How many girls enrolled -> p2q4b

# Wave 1 

# Income eq quintile -> EIncQuin
# PCG highest level of education  -> MML37
# SCG highest level of education -> FE1

# Wave 1
# Approximately how many hours per week does the Study Child’s class spend on each of the 
# following subjects, within normal school hours? Your best estimate is fine.
# No. of hours per week - English? -> TS11ahrs
# No. of hours per week - Maths? -> TS11chrs
#-----------------------------------------------------------
names(Oaxaca_Blinder)

library(dplyr)
library(haven)

# Create the new dataset by selecting the specified variables
Oaxaca_Blinder_Waves34 <- Merged_Child %>%
  select(
    # Wave 4 variables
    ID,
    cq4F13b1, cq4F13c1, cq4F13c2, cq4F13b2, cq4F13_PointsMaths, cq4F13_PointsEnglish,
    w4cq_agreeable, w4cq_emotstab, w4cq_conscientious, w4cq_extravert, w4cq_openness,
    CognitiveNamingFruit,
    w4pc_agreeable, w4pc_emotstab, w4pc_conscientious, w4pc_extravert, w4pc_openness,
    cq4F22, cq4f27a, cq4F27b,
    
    # Wave 3 variables
    w3cq_extravert, w3cq_agreeable, w3cq_conscientious, w3cq_emotstab, w3cq_openness,
    w3pc_extravert, w3pc_agreeable, w3pc_conscientious, w3pc_emotstab, w3pc_openness,
    w3sc_extravert, w3sc_agreeable, w3sc_conscientious, w3sc_emotstab, w3sc_openness,
    w3pcg_SDQemotional, w3pcg_SDQconduct, w3pcg_SDQhyper, w3pcg_SDQpeerprobs,
    w3scg_SDQemotional, w3scg_SDQconduct, w3scg_SDQhyper, w3scg_SDQpeerprobs,
    CognitiveNamingTotal, CognitiveMathsTotal, CognitiveVocabularyTotal,
    
    # Control variables
    p2sexW3, pc3f1educ, sc3e1educ, w3eincquin, p3q7, p3q6, p3q4a, p3q4b
  )

Oaxaca_Blinder_Waves34 <- Oaxaca_Blinder_Waves34 %>% 
  rename(
    # Wave 4 renames
    Household_ID = ID,
    LC_Did_English = cq4F13b1,
    LC_Did_Maths = cq4F13c1,
    LC_Maths_Level = cq4F13c2,
    LC_English_Level = cq4F13b2,
    LC_Maths_Points = cq4F13_PointsMaths,
    LC_English_Points = cq4F13_PointsEnglish,
    TIPI_Agreeable_YP_W4 = w4cq_agreeable,
    TIPI_EmoStab_YP_W4 = w4cq_emotstab,
    TIPI_Cons_YP_W4 = w4cq_conscientious,
    TIPI_Extra_YP_W4 = w4cq_extravert,
    TIPI_Open_YP_W4 = w4cq_openness,
    CognitiveNamingFruit_W4 = CognitiveNamingFruit,
    TIPI_Agreeable_PCG_W4 = w4pc_agreeable,
    TIPI_EmoStab_PCG_W4 = w4pc_emotstab,
    TIPI_Cons_PCG_W4 = w4pc_conscientious,
    TIPI_Extra_PCG_W4 = w4pc_extravert,
    TIPI_Open_PCG_W4 = w4pc_openness,
    Grinds_All_Subjects_W4 = cq4F22,
    Grinds_English_W4 = cq4f27a,
    Grinds_Maths_W4 = cq4F27b,
    
    # Wave 3 renames
    TIPI_Extra_YP_W3 = w3cq_extravert,
    TIPI_Agreeable_YP_W3 = w3cq_agreeable,
    TIPI_Cons_YP_W3 = w3cq_conscientious,
    TIPI_EmoStab_YP_W3 = w3cq_emotstab,
    TIPI_Open_YP_W3 = w3cq_openness,
    
    TIPI_Extra_PCG_W3 = w3pc_extravert,
    TIPI_Agreeable_PCG_W3 = w3pc_agreeable,
    TIPI_Cons_PCG_W3 = w3pc_conscientious,
    TIPI_EmoStab_PCG_W3 = w3pc_emotstab,
    TIPI_Open_PCG_W3 = w3pc_openness,
    
    TIPI_Extra_SCG_W3 = w3sc_extravert,
    TIPI_Agreeable_SCG_W3 = w3sc_agreeable,
    TIPI_Cons_SCG_W3 = w3sc_conscientious,
    TIPI_EmoStab_SCG_W3 = w3sc_emotstab,
    TIPI_Open_SCG_W3 = w3sc_openness,
    
    SDQ_Emo_PCG_W3 = w3pcg_SDQemotional,
    SDQ_Conduct_PCG_W3 = w3pcg_SDQconduct,
    SDQ_Hyper_PCG_W3 = w3pcg_SDQhyper,
    SDQ_Peer_PCG_W3 = w3pcg_SDQpeerprobs,
    
    SDQ_Emo_SCG_W3 = w3scg_SDQemotional,
    SDQ_Conduct_SCG_W3 = w3scg_SDQconduct,
    SDQ_Hyper_SCG_W3 = w3scg_SDQhyper,
    SDQ_Peer_SCG_W3 = w3scg_SDQpeerprobs,
    
    Cog_Naming_Total_W3 = CognitiveNamingTotal,
    Cog_Maths_Total_W3 = CognitiveMathsTotal,
    Cog_Vocabulary_W3 = CognitiveVocabularyTotal,
    
    Gender_YP_W3 = p2sexW3,
    PCG_Educ_W3 = pc3f1educ,
    SCG_Educ_W3 = sc3e1educ,
    Income_Quin_Eq_W3 = w3eincquin,
    
    DEIS_W3 = p3q7,
    School_Type_W3 = p3q6,
    Number_Boys_School_W3 = p3q4a,
    Number_Girls_School_W3 = p3q4b
  )

# Cleaning and renaming and stuff:

Oaxaca_Blinder_Waves34 <- Oaxaca_Blinder_Waves34 %>%
  mutate(
    # Recode LC_Maths_Level
    LC_Maths_Level = if_else(LC_Maths_Level == 9, NA_real_, LC_Maths_Level),
    LC_Maths_Level = haven::as_factor(LC_Maths_Level),
    
    # Recode LC_English_Level
    LC_English_Level = if_else(LC_English_Level == 9, NA_real_, LC_English_Level),
    LC_English_Level = haven::as_factor(LC_English_Level)
  )

# Clean the LC_Maths_Points and LC_English_Points variables
Oaxaca_Blinder_Waves34 <- Oaxaca_Blinder_Waves34 %>%
  mutate(
    LC_Maths_Points = case_when(
      LC_Maths_Points >= 0 & LC_Maths_Points <= 125 ~ LC_Maths_Points,  # Keep valid scores
      LC_Maths_Points %in% c(996, 997, 999) ~ NA_real_,  # Recode special codes to NA
      TRUE ~ NA_real_  # Recode any other values to NA
    )
  )

Oaxaca_Blinder_Waves34 <- Oaxaca_Blinder_Waves34 %>%
  mutate(
    LC_English_Points = case_when(
      LC_English_Points >= 0 & LC_English_Points <= 100 ~ LC_English_Points,  # Keep valid scores
      LC_English_Points %in% c(996, 997, 999) ~ NA_real_,  # Recode special codes to NA
      TRUE ~ NA_real_  # Recode any other values to NA
    )
  )

# Convert variables to binary
Oaxaca_Blinder_Waves34 <- Oaxaca_Blinder_Waves34 %>%
  mutate(
    Grinds_All_Subjects_W4 = case_when(
      Grinds_All_Subjects_W4 == 1 ~ 1,  # Yes
      Grinds_All_Subjects_W4 == 2 ~ 0,  # No
      TRUE ~ NA_real_  # Keep NA as NA
    ),
    Grinds_English_W4 = case_when(
      Grinds_English_W4 == 1 ~ 1,  # Yes
      Grinds_English_W4 == 2 ~ 0,  # No
      TRUE ~ NA_real_  # Keep NA as NA
    ),
    Grinds_Maths_W4 = case_when(
      Grinds_Maths_W4 == 1 ~ 1,  # Yes
      Grinds_Maths_W4 == 2 ~ 0,  # No
      TRUE ~ NA_real_  # Keep NA as NA
    )
  )
# Function to invert SDQ scale
invert_sdq <- function(x) {
  max_val <- max(x, na.rm = TRUE)
  return(max_val - x)
}

# Create inverted SDQ variables
Oaxaca_Blinder_Waves34 <- Oaxaca_Blinder_Waves34 %>%
  mutate(
    # PCG variables
    SDQ_Emo_Res_PCG_W3 = invert_sdq(SDQ_Emo_PCG_W3),
    SDQ_Good_Conduct_PCG_W3 = invert_sdq(SDQ_Conduct_PCG_W3),
    SDQ_Focus_Behav_PCG_W3 = invert_sdq(SDQ_Hyper_PCG_W3),
    SDQ_Posi_Peer_PCG_W3 = invert_sdq(SDQ_Peer_PCG_W3),
    
    # SCG variables
    SDQ_Emo_Res_SCG_W3 = invert_sdq(SDQ_Emo_SCG_W3),
    SDQ_Good_Conduct_SCG_W3 = invert_sdq(SDQ_Conduct_SCG_W3),
    SDQ_Focus_Behav_SCG_W3 = invert_sdq(SDQ_Hyper_SCG_W3),
    SDQ_Posi_Peer_SCG_W3 = invert_sdq(SDQ_Peer_SCG_W3)
  )

# Convert Gender_YP_W3 to binary
Oaxaca_Blinder_Waves34 <- Oaxaca_Blinder_Waves34 %>%
  mutate(
    Gender_YP_W3 = case_when(
      Gender_YP_W3 == 1 ~ 1,  # Male
      Gender_YP_W3 == 2 ~ 0,  # Female
      TRUE ~ NA_real_  # Keep NA as NA
    )
  )

# Recode PCG_Educ_W3
Oaxaca_Blinder_Waves34 <- Oaxaca_Blinder_Waves34 %>%
  mutate(
    PCG_Educ_W3 = if_else(PCG_Educ_W3 == 99, NA_real_, PCG_Educ_W3)
  )

# Recode DEIS_W3
Oaxaca_Blinder_Waves34 <- Oaxaca_Blinder_Waves34 %>%
  mutate(
    DEIS_W3 = case_when(
      DEIS_W3 == 1 ~ 1,    # Yes, DEIS post-primary
      DEIS_W3 == 5 ~ 0,    # No
      TRUE ~ NA_real_      # All other values (including 9) become NA
    )
  )

# Clean School_Type_W3 and create binary variables for each school type
Oaxaca_Blinder_Waves34 <- Oaxaca_Blinder_Waves34 %>%
  mutate(
    School_Type_W3 = case_when(
      School_Type_W3 %in% 1:5 ~ School_Type_W3,
      TRUE ~ NA_real_  # Change 99 and any other values to NA
    ),
    Fee_Paying_W3 = ifelse(School_Type_W3 == 1, 1, 0),
    Non_Fee_Paying_W3 = ifelse(School_Type_W3 == 2, 1, 0),
    Vocational_W3 = ifelse(School_Type_W3 == 3, 1, 0),
    Community_College_W3 = ifelse(School_Type_W3 == 4, 1, 0),
    Comprehensive_School_W3 = ifelse(School_Type_W3 == 5, 1, 0)
  )
# Create binary variables for each school type in wave 2
Oaxaca_Blinder <- Oaxaca_Blinder %>%
  mutate(
    Fee_Paying_W2 = ifelse(School_Type_W2 == 1, 1, 0),
    Voluntary_W2 = ifelse(School_Type_W2 == 2, 1, 0),
    Vocational_W2 = ifelse(School_Type_W2 == 3, 1, 0),
    Community_College_W2 = ifelse(School_Type_W2 == 4, 1, 0),
    Community_School_W2 = ifelse(School_Type_W2 == 5, 1, 0),
    Comprehensive_School_W2 = ifelse(School_Type_W2 == 6, 1, 0)
  )

# Refine the classification and rename variables to include wave indicator for single and mixed schools
Oaxaca_Blinder_Waves34 <- Oaxaca_Blinder_Waves34 %>%
  mutate(
    School_Gender_Type_W3 = case_when(
      Number_Boys_School_W3 == 0 & Number_Girls_School_W3 > 0 ~ "Girls Only",
      Number_Boys_School_W3 > 0 & Number_Girls_School_W3 == 0 ~ "Boys Only",
      Number_Boys_School_W3 > 0 & Number_Girls_School_W3 > 0 ~ "Mixed",
      Number_Boys_School_W3 == 0 & Number_Girls_School_W3 == 0 ~ "Unknown",
      is.na(Number_Boys_School_W3) | is.na(Number_Girls_School_W3) ~ NA_character_
    ),
    Girls_Only_School_W3 = ifelse(School_Gender_Type_W3 == "Girls Only", 1, 0),
    Boys_Only_School_W3 = ifelse(School_Gender_Type_W3 == "Boys Only", 1, 0),
    Mixed_School_W3 = ifelse(School_Gender_Type_W3 == "Mixed", 1, 0)
  )

# Print summary of the refined variable
cat("Refined School Gender Type (Wave 3):\n")
print(table(Oaxaca_Blinder_Waves34$School_Gender_Type_W3, useNA = "always"))

# Create refined summary table
summary_table <- Oaxaca_Blinder_Waves34 %>%
  group_by(School_Gender_Type_W3) %>%
  summarise(Count = n()) %>%
  mutate(Percentage = Count / sum(Count) * 100)

print(summary_table)

# Print summaries of refined binary variables
cat("\nGirls Only Schools (Wave 3):\n")
print(table(Oaxaca_Blinder_Waves34$Girls_Only_School_W3, useNA = "always"))

cat("\nBoys Only Schools (Wave 3):\n")
print(table(Oaxaca_Blinder_Waves34$Boys_Only_School_W3, useNA = "always"))

cat("\nMixed Schools (Wave 3):\n")
print(table(Oaxaca_Blinder_Waves34$Mixed_School_W3, useNA = "always"))

Oaxaca_Blinder <- Oaxaca_Blinder %>%
  mutate(
    School_Gender_Type_W2 = case_when(
      Number_Boys_School_W2 > 1 & Number_Girls_School_W2 > 1 ~ "Mixed",
      Number_Boys_School_W2 <= 1 & Number_Girls_School_W2 > 1 ~ "Girls Only",
      Number_Boys_School_W2 > 1 & Number_Girls_School_W2 <= 1 ~ "Boys Only",
      is.na(Number_Boys_School_W2) | is.na(Number_Girls_School_W2) ~ NA_character_
    ),
    Girls_Only_School_W2 = ifelse(School_Gender_Type_W2 == "Girls Only", 1, 0),
    Boys_Only_School_W2 = ifelse(School_Gender_Type_W2 == "Boys Only", 1, 0),
    Mixed_School_W2 = ifelse(School_Gender_Type_W2 == "Mixed", 1, 0)
  )

Oaxaca_Blinder %>%
  count(Girls_Only_School_W2)

Oaxaca_Blinder %>%
  count(Boys_Only_School_W2)

Oaxaca_Blinder %>%
  count(Mixed_School_W2)

# Print summary of the refined variable
cat("Refined School Gender Type (Wave 2):\n")
print(table(Oaxaca_Blinder$School_Gender_Type_W2, useNA = "always"))

# Create refined summary table
summary_table <- Oaxaca_Blinder %>%
  group_by(School_Gender_Type_W2) %>%
  summarise(Count = n(), .groups = 'drop') %>%
  mutate(Percentage = Count / sum(Count) * 100)

print(summary_table)


# Adding the data from waves 2 and 3

library(dplyr)
Oaxaca_Blinder <- Oaxaca_Blinder_Waves34 %>%
  inner_join(combined_data %>% 
               select(ID, English_points, Drum_VR_W2_p, Drum_NA_W2_p, BAS_TS_Mat_W2,
                      SDQ_emot_PCG_W2, SDQ_cond_PCG_W2, SDQ_hyper_PCG_W2, SDQ_peer_PCG_W2,
                      PCG_Educ_W2, SCG_Educ_W2, Income_equi_quint,
                      Maths_points,
                      Agreeable_W2_PCG, Conscientious_W2_PCG, 
                      Emo_Stability_W2_PCG, Extravert_W2_PCG, Openness_W2_PCG,
                      DEIS_binary_W2, Fee_paying_W2, Mixed,
                      Gender),
             by = "ID")

Oaxaca_Blinder <- Oaxaca_Blinder %>% 
  rename(
   JC_English_Points = English_points,
   JC_Maths_Points = Maths_points,
   Cog_VR_W2 = Drum_VR_W2_p, 
   Cog_NA_W2 = Drum_NA_W2_p, 
   Cog_Matrices_W2 = BAS_TS_Mat_W2,
   SDQ_Emo_Res_PCG_W2 = SDQ_emot_PCG_W2, 
   SDQ_Good_Conduct_PCG_W2 = SDQ_cond_PCG_W2, 
   SDQ_Focus_Behav_PCG_W2 = SDQ_hyper_PCG_W2, 
   SDQ_Posi_Peer_PCG_W2 = SDQ_peer_PCG_W2,
   Income_Quin_Eq_W2 = Income_equi_quint,
   TIPI_Extra_PCG_W2 = Extravert_W2_PCG,
   TIPI_Agreeable_PCG_W2 = Agreeable_W2_PCG,
   TIPI_Cons_PCG_W2 = Conscientious_W2_PCG,
   TIPI_EmoStab_PCG_W2 = Emo_Stability_W2_PCG,
   TIPI_Open_PCG_W2 = Openness_W2_PCG,
   Mixed_W2 = Mixed,
   Gender_YP_W2 = Gender,
   DEIS_W2 = DEIS_binary_W2,
   Mixed_W3 = Mixed_School_W3,
   Fee_Paying_W2 = Fee_paying_W2
  )

names(Oaxaca_Blinder)

# Selecting variables from Wave 1 - teacher evaluation and cognitive measures 
selected_data <- Merged_Child %>%
  select(
    ID,
    TC_Reading_W1 = TC10a,
    TC_Writing_W1 = TC10b,
    TC_Comprehension_W1 = TC10c,
    TC_Maths_W1 = TC10d,
    TC_Imagination_W1 = TC10e,
    TC_OralComm_W1 = TC10f,
    TC_ProblemSol_W1 = TC10g,
    Reading_Class_Level_W1 = readclass,
    Cog_Reading_W1 = readpct,
    Maths_Class_Level_W1 = mathclass,
    Cog_Maths_W1 = mathpct
  )

Oaxaca_Blinder <- Oaxaca_Blinder %>%
  left_join(selected_data, by = "ID")

# Define the function to invert SDQ scale
invert_sdq <- function(x) {
  max_val <- max(x, na.rm = TRUE)
  return(max_val - x)
}

cleaned_data <- Merged_Child %>%
  mutate(
    # SDQ variables for PCG
    MMH2_SDQemot = ifelse(MMH2_SDQemot == 99, NA, MMH2_SDQemot),
    MMH2_SDQcond = ifelse(MMH2_SDQcond == 99, NA, MMH2_SDQcond),
    MMH2_SDQhyper = ifelse(MMH2_SDQhyper == 99, NA, MMH2_SDQhyper),
    MMH2_SDQpeer = ifelse(MMH2_SDQpeer == 99, NA, MMH2_SDQpeer),
    
    # SDQ variables for TC
    TCSDQemot = ifelse(TCSDQemot == 99, NA, TCSDQemot),
    TCSDQcon = ifelse(TCSDQcon == 99, NA, TCSDQcon),
    TCSDQhyp = ifelse(TCSDQhyp == 99, NA, TCSDQhyp),
    TCSDQpeer = ifelse(TCSDQpeer == 99, NA, TCSDQpeer)
  )

# Adding the control variables from Waves 1 and 2 for SES and School
# Join and rename variables from Merged_Child to Oaxaca_Blinder
Oaxaca_Blinder <- Oaxaca_Blinder %>%
  left_join(
    Merged_Child %>%
      mutate(
        p2q6 = ifelse(p2q6 == 9, NA, p2q6),
        p2q4a = ifelse(p2q4a == 9999, NA, p2q4a),
        p2q4b = ifelse(p2q4b == 9999, NA, p2q4b)
      ) %>%
      select(ID,
             # Wave 2 variables (renamed)
             School_Type_W2 = p2q6,            # Type of School Wave 2
             Number_Boys_School_W2 = p2q4a,    # Boys enrolled Wave 2
             Number_Girls_School_W2 = p2q4b,   # Girls enrolled Wave 2

             # Wave 1 variables (no cleaning needed, just renaming)
             Income_Quin_Eq_W1 = EIncQuin,     # Income eq quintile Wave 1
             PCG_Educ_W1 = MML37,              # PCG highest level of education Wave 1
             SCG_Educ_W1 = FE1                 # SCG highest level of education Wave 1
      ), 
    by = "ID"
  )
dplyr::count(Merged_Child,p2q4a)
dplyr::count(Oaxaca_Blinder,Number_Boys_School_W2)


inverted_data <- cleaned_data %>%
  mutate(
    # Inverted SDQ variables for PCG
    SDQ_Emo_Res_PCG_W1 = invert_sdq(MMH2_SDQemot),
    SDQ_Good_Conduct_PCG_W1 = invert_sdq(MMH2_SDQcond),
    SDQ_Focus_Behav_PCG_W1 = invert_sdq(MMH2_SDQhyper),
    SDQ_Posi_Peer_PCG_W1 = invert_sdq(MMH2_SDQpeer),
    
    # Inverted SDQ variables for TC
    SDQ_Emo_Res_TC_W1 = invert_sdq(TCSDQemot),
    SDQ_Good_Conduct_TC_W1 = invert_sdq(TCSDQcon),
    SDQ_Focus_Behav_TC_W1 = invert_sdq(TCSDQhyp),
    SDQ_Posi_Peer_TC_W1 = invert_sdq(TCSDQpeer)
  )



# Merge the cleaned and inverted columns with Oaxaca_Blinder based on the common 'ID'
Oaxaca_Blinder <- Oaxaca_Blinder %>%
  left_join(inverted_data %>% 
              select(ID, 
                     SDQ_Emo_Res_PCG_W1, 
                     SDQ_Good_Conduct_PCG_W1, 
                     SDQ_Focus_Behav_PCG_W1, 
                     SDQ_Posi_Peer_PCG_W1,
                     SDQ_Emo_Res_TC_W1, 
                     SDQ_Good_Conduct_TC_W1, 
                     SDQ_Focus_Behav_TC_W1, 
                     SDQ_Posi_Peer_TC_W1), 
            by = "ID")

# Adding additional Wave 3 variables: Self-Esteem, Locus of Control, and Self-Control
Oaxaca_Blinder <- Oaxaca_Blinder %>%
  left_join(Merged_Child %>% select(ID, w3cq_selfesteem_total, w3cq_sg2control, w3cq_ILCtot), by = "ID") %>%
  rename(Self_Esteem_YP_W3 = w3cq_selfesteem_total,
         Locus_Control_YP_W3 = w3cq_ILCtot,
         Self_Control_YP_W3 = w3cq_sg2control)


# Adding some vars from Wave 1
Oaxaca_Blinder <- Oaxaca_Blinder %>%
  left_join(Merged_Child %>% select(ID, TS11ahrs, TS11chrs), by = "ID") %>%
  rename(English_Hours_W1 = TS11ahrs,
         Maths_Hours_W1 = TS11chrs)

# Saving the dataset
write.csv(Oaxaca_Blinder, 
          file = "C:/Users/bgiet/OneDrive/Documents/GitHub/ConflictingForces/ConflictingForces/sensitive_files/ConflictingForcesSensitive/Oaxaca_Blinder.csv", 
          row.names = FALSE)

