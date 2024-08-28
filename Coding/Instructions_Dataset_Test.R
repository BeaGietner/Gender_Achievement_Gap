# Load required libraries
library(dplyr)
library(tidyr)
library(stringr)
library(haven)

# Create Dataset_Test by selecting and processing variables from Merged_Child
Dataset_Test <- Merged_Child %>%
  select(
    ID,
    
    # Select variables from Wave 4
    LC_Did_English = cq4F13b1, LC_Did_Maths = cq4F13c1, 
    LC_Maths_Level = cq4F13c2, LC_English_Level = cq4F13b2,
    LC_Maths_Points = cq4F13_PointsMaths, LC_English_Points = cq4F13_PointsEnglish,
    TIPI_Agreeable_YP_W4 = w4cq_agreeable, TIPI_EmoStab_YP_W4 = w4cq_emotstab,
    TIPI_Cons_YP_W4 = w4cq_conscientious, TIPI_Extra_YP_W4 = w4cq_extravert,
    TIPI_Open_YP_W4 = w4cq_openness, CognitiveNamingFruit_W4 = CognitiveNamingFruit,
    TIPI_Agreeable_PCG_W4 = w4pc_agreeable, TIPI_EmoStab_PCG_W4 = w4pc_emotstab,
    TIPI_Cons_PCG_W4 = w4pc_conscientious, TIPI_Extra_PCG_W4 = w4pc_extravert,
    TIPI_Open_PCG_W4 = w4pc_openness, Grinds_All_Subjects_W4 = cq4F22,
    Grinds_English_W4 = cq4f27a, Grinds_Maths_W4 = cq4F27b,
    
    # Select variables from Wave 3
    TIPI_Extra_YP_W3 = w3cq_extravert, TIPI_Agreeable_YP_W3 = w3cq_agreeable,
    TIPI_Cons_YP_W3 = w3cq_conscientious, TIPI_EmoStab_YP_W3 = w3cq_emotstab,
    TIPI_Open_YP_W3 = w3cq_openness, TIPI_Extra_PCG_W3 = w3pc_extravert,
    TIPI_Agreeable_PCG_W3 = w3pc_agreeable, TIPI_Cons_PCG_W3 = w3pc_conscientious,
    TIPI_EmoStab_PCG_W3 = w3pc_emotstab, TIPI_Open_PCG_W3 = w3pc_openness,
    TIPI_Extra_SCG_W3 = w3sc_extravert, TIPI_Agreeable_SCG_W3 = w3sc_agreeable,
    TIPI_Cons_SCG_W3 = w3sc_conscientious, TIPI_EmoStab_SCG_W3 = w3sc_emotstab,
    TIPI_Open_SCG_W3 = w3sc_openness, SDQ_Emo_PCG_W3 = w3pcg_SDQemotional,
    SDQ_Conduct_PCG_W3 = w3pcg_SDQconduct, SDQ_Hyper_PCG_W3 = w3pcg_SDQhyper,
    SDQ_Peer_PCG_W3 = w3pcg_SDQpeerprobs, SDQ_Emo_SCG_W3 = w3scg_SDQemotional,
    SDQ_Conduct_SCG_W3 = w3scg_SDQconduct, SDQ_Hyper_SCG_W3 = w3scg_SDQhyper,
    SDQ_Peer_SCG_W3 = w3scg_SDQpeerprobs, Cog_Naming_Total_W3 = CognitiveNamingTotal,
    Cog_Maths_Total_W3 = CognitiveMathsTotal, Cog_Vocabulary_W3 = CognitiveVocabularyTotal,
    Gender_YP_W3 = p2sexW3, PCG_Educ_W3 = pc3f1educ, SCG_Educ_W3 = sc3e1educ,
    Income_Quin_Eq_W3 = w3eincquin, DEIS_W3 = p3q7, School_Type_W3 = p3q6,
    Number_Boys_School_W3 = p3q4a, Number_Girls_School_W3 = p3q4b,
    Self_Esteem_YP_W3 = w3cq_selfesteem_total, Locus_Control_YP_W3 = w3cq_ILCtot,
    Self_Control_YP_W3 = w3cq_sg2control,
    
    # Select Junior Certificate variables from Wave 3
    JC_Did_Maths_W3 = cq3b33, JC_Maths_Level_W3 = cq3b33a, JC_Maths_Grade_W3 = cq3b33b,
    JC_Did_English_W3 = cq3b32, JC_English_Level_W3 = cq3b32a, JC_English_Grade_W3 = cq3b32b,
    
    # Select variables from Wave 2
    Cog_VR_W2 = vrpct, Cog_NA_W2 = napct, Cog_Matrices_W2 = matabscore,
    SDQ_Emo_PCG_W2 = w2pcd2_sdqemot, SDQ_Conduct_PCG_W2 = w2pcd2_sdqcond,
    SDQ_Hyper_PCG_W2 = w2pcd2_sdqhyper, SDQ_Peer_PCG_W2 = w2pcd2_sdqpeer,
    PCG_Educ_W2 = pc2h1, SCG_Educ_W2 = sc2e1,
    Income_Quin_Eq_W2 = w2eincquin, TIPI_Extra_PCG_W2 = w2pcd3_extravert,
    TIPI_Agreeable_PCG_W2 = w2pcd3_agreeable, TIPI_Cons_PCG_W2 = w2pcd3_conscientious,
    TIPI_EmoStab_PCG_W2 = w2pcd3_emotstab, TIPI_Open_PCG_W2 = w2pcd3_openness,
    DEIS_W2 = p2q7, School_Type_W2 = p2q6,
    Number_Boys_School_W2 = p2q4a, Number_Girls_School_W2 = p2q4b,
    
    # Select variables from Wave 1
    TC_Reading_W1 = TC10a, TC_Writing_W1 = TC10b, TC_Comprehension_W1 = TC10c,
    TC_Maths_W1 = TC10d, TC_Imagination_W1 = TC10e, TC_OralComm_W1 = TC10f,
    TC_ProblemSol_W1 = TC10g, Reading_Class_Level_W1 = readclass,
    Cog_Reading_W1 = readpct, Maths_Class_Level_W1 = mathclass, Cog_Maths_W1 = mathpct,
    Income_Quin_Eq_W1 = EIncQuin, PCG_Educ_W1 = MML37, SCG_Educ_W1 = FE1,
    English_Hours_W1 = TS11ahrs, Maths_Hours_W1 = TS11chrs,
    SDQ_Emo_PCG_W1 = MMH2_SDQemot, SDQ_Conduct_PCG_W1 = MMH2_SDQcond,
    SDQ_Hyper_PCG_W1 = MMH2_SDQhyper, SDQ_Peer_PCG_W1 = MMH2_SDQpeer,
    SDQ_Emo_TC_W1 = TCSDQemot, SDQ_Conduct_TC_W1 = TCSDQcon,
    SDQ_Hyper_TC_W1 = TCSDQhyp, SDQ_Peer_TC_W1 = TCSDQpeer
  ) %>%
  
  mutate(
    # Recode LC_Maths_Level and LC_English_Level
    LC_Maths_Level = if_else(LC_Maths_Level == 9, NA_real_, LC_Maths_Level),
    LC_Maths_Level = haven::as_factor(LC_Maths_Level),
    LC_English_Level = if_else(LC_English_Level == 9, NA_real_, LC_English_Level),
    LC_English_Level = haven::as_factor(LC_English_Level),
    
    # Clean LC_Maths_Points and LC_English_Points
    LC_Maths_Points = case_when(
      LC_Maths_Points >= 0 & LC_Maths_Points <= 125 ~ LC_Maths_Points,
      LC_Maths_Points %in% c(996, 997, 999) ~ NA_real_,
      TRUE ~ NA_real_
    ),
    LC_English_Points = case_when(
      LC_English_Points >= 0 & LC_English_Points <= 100 ~ LC_English_Points,
      LC_English_Points %in% c(996, 997, 999) ~ NA_real_,
      TRUE ~ NA_real_
    ),
    
    # Convert variables to binary
    across(c(Grinds_All_Subjects_W4, Grinds_English_W4, Grinds_Maths_W4, 
             Gender_YP_W3, DEIS_W3), 
           ~if_else(. == 1, 1, 0)),
    
    # Recode PCG_Educ_W3
    PCG_Educ_W3 = if_else(PCG_Educ_W3 == 99, NA_real_, PCG_Educ_W3),
    
    # Create school type variables
    Fee_Paying_W3 = if_else(School_Type_W3 == 1, 1, 0),
    Non_Fee_Paying_W3 = if_else(School_Type_W3 == 2, 1, 0),
    Vocational_W3 = if_else(School_Type_W3 == 3, 1, 0),
    Community_College_W3 = if_else(School_Type_W3 == 4, 1, 0),
    Comprehensive_School_W3 = if_else(School_Type_W3 == 5, 1, 0),
    
    # Create school gender type variables for Wave 3
    School_Gender_Type_W3 = case_when(
      Number_Boys_School_W3 == 0 & Number_Girls_School_W3 > 0 ~ "Girls Only",
      Number_Boys_School_W3 > 0 & Number_Girls_School_W3 == 0 ~ "Boys Only",
      Number_Boys_School_W3 > 0 & Number_Girls_School_W3 > 0 ~ "Mixed",
      TRUE ~ NA_character_
    ),
    Girls_Only_School_W3 = if_else(School_Gender_Type_W3 == "Girls Only", 1, 0),
    Boys_Only_School_W3 = if_else(School_Gender_Type_W3 == "Boys Only", 1, 0),
    Mixed_School_W3 = if_else(School_Gender_Type_W3 == "Mixed", 1, 0),
    
    # Create school gender type variables for Wave 2
    School_Gender_Type_W2 = case_when(
      Number_Boys_School_W2 > 1 & Number_Girls_School_W2 > 1 ~ "Mixed",
      Number_Boys_School_W2 <= 1 & Number_Girls_School_W2 > 1 ~ "Girls Only",
      Number_Boys_School_W2 > 1 & Number_Girls_School_W2 <= 1 ~ "Boys Only",
      TRUE ~ NA_character_
    ),
    Girls_Only_School_W2 = if_else(School_Gender_Type_W2 == "Girls Only", 1, 0),
    Boys_Only_School_W2 = if_else(School_Gender_Type_W2 == "Boys Only", 1, 0),
    Mixed_School_W2 = if_else(School_Gender_Type_W2 == "Mixed", 1, 0),
    
    # Handle Wave 2 school variables
    School_Type_W2 = if_else(School_Type_W2 == 9, NA_real_, School_Type_W2),
    Number_Boys_School_W2 = if_else(Number_Boys_School_W2 == 9999, NA_real_, Number_Boys_School_W2),
    Number_Girls_School_W2 = if_else(Number_Girls_School_W2 == 9999, NA_real_, Number_Girls_School_W2),
    
    # Clean DEIS_W2
    DEIS_W2 = case_when(
      DEIS_W2 == 1 ~ 1,  # Yes
      DEIS_W2 == 2 ~ 0,  # No
      TRUE ~ NA_real_  # Don't know or NA
    ),
    
    # Clean and create binary variables for School_Type_W2
    School_Type_W2 = if_else(School_Type_W2 %in% c(7, 9), NA_real_, School_Type_W2),
    Fee_Paying_W2 = if_else(School_Type_W2 == 1, 1, 0),
    Voluntary_Secondary_W2 = if_else(School_Type_W2 == 2, 1, 0),
    Vocational_School_W2 = if_else(School_Type_W2 == 3, 1, 0),
    Community_College_W2 = if_else(School_Type_W2 == 4, 1, 0),
    Community_School_W2 = if_else(School_Type_W2 == 5, 1, 0),
    Comprehensive_School_W2 = if_else(School_Type_W2 == 6, 1, 0),
    
       # Handle Wave 1 variables 
           across(c(Income_Quin_Eq_W1, PCG_Educ_W1, SCG_Educ_W1), 
                  ~if_else(. == 99, NA_real_, .)),
           
           # Clean SDQ variables for Wave 1
           across(c(SDQ_Emo_PCG_W1, SDQ_Conduct_PCG_W1, SDQ_Hyper_PCG_W1, SDQ_Peer_PCG_W1,
                    SDQ_Emo_TC_W1, SDQ_Conduct_TC_W1, SDQ_Hyper_TC_W1, SDQ_Peer_TC_W1),
                  ~if_else(. == 99, NA_real_, .)),
           
           # Clean JC variables
           across(c(JC_Maths_Level_W3, JC_Maths_Grade_W3, JC_English_Level_W3, JC_English_Grade_W3),
                  ~if_else(. == 9, NA_real_, .)),
           
           # Create 12-point OPS for JC Maths
           JC_Maths_OPS = case_when(
             JC_Maths_Level_W3 == 1 & JC_Maths_Grade_W3 == 1 ~ 12,  # Higher A
             JC_Maths_Level_W3 == 1 & JC_Maths_Grade_W3 == 2 ~ 11,  # Higher B
             JC_Maths_Level_W3 == 1 & JC_Maths_Grade_W3 == 3 ~ 10,  # Higher C
             JC_Maths_Level_W3 == 1 & JC_Maths_Grade_W3 == 4 ~ 9,   # Higher D
             JC_Maths_Level_W3 == 1 & JC_Maths_Grade_W3 == 5 ~ 8,   # Higher E
             JC_Maths_Level_W3 == 2 & JC_Maths_Grade_W3 == 1 ~ 9,   # Ordinary A
             JC_Maths_Level_W3 == 2 & JC_Maths_Grade_W3 == 2 ~ 8,   # Ordinary B
             JC_Maths_Level_W3 == 2 & JC_Maths_Grade_W3 == 3 ~ 7,   # Ordinary C
             JC_Maths_Level_W3 == 2 & JC_Maths_Grade_W3 == 4 ~ 6,   # Ordinary D
             JC_Maths_Level_W3 == 2 & JC_Maths_Grade_W3 == 5 ~ 5,   # Ordinary E
             JC_Maths_Level_W3 == 3 & JC_Maths_Grade_W3 == 1 ~ 6,   # Foundation A
             JC_Maths_Level_W3 == 3 & JC_Maths_Grade_W3 == 2 ~ 5,   # Foundation B
             JC_Maths_Level_W3 == 3 & JC_Maths_Grade_W3 == 3 ~ 4,   # Foundation C
             JC_Maths_Level_W3 == 3 & JC_Maths_Grade_W3 == 4 ~ 3,   # Foundation D
             JC_Maths_Level_W3 == 3 & JC_Maths_Grade_W3 == 5 ~ 2,   # Foundation E
             TRUE ~ NA_real_
           ),
           
           # Create 12-point OPS for JC English
           JC_English_OPS = case_when(
             JC_English_Level_W3 == 1 & JC_English_Grade_W3 == 1 ~ 12,  # Higher A
             JC_English_Level_W3 == 1 & JC_English_Grade_W3 == 2 ~ 11,  # Higher B
             JC_English_Level_W3 == 1 & JC_English_Grade_W3 == 3 ~ 10,  # Higher C
             JC_English_Level_W3 == 1 & JC_English_Grade_W3 == 4 ~ 9,   # Higher D
             JC_English_Level_W3 == 1 & JC_English_Grade_W3 == 5 ~ 8,   # Higher E
             JC_English_Level_W3 == 2 & JC_English_Grade_W3 == 1 ~ 9,   # Ordinary A
             JC_English_Level_W3 == 2 & JC_English_Grade_W3 == 2 ~ 8,   # Ordinary B
             JC_English_Level_W3 == 2 & JC_English_Grade_W3 == 3 ~ 7,   # Ordinary C
             JC_English_Level_W3 == 2 & JC_English_Grade_W3 == 4 ~ 6,   # Ordinary D
             JC_English_Level_W3 == 2 & JC_English_Grade_W3 == 5 ~ 5,   # Ordinary E
             TRUE ~ NA_real_
           ),
           
           # Standardize JC and LC scores
           JC_Maths_Standardized = scale(JC_Maths_OPS),
           JC_English_Standardized = scale(JC_English_OPS),
           LC_Maths_Standardized = scale(LC_Maths_Points),
           LC_English_Standardized = scale(LC_English_Points),
           
           # Create 100-point scale versions of LC and JC scores
           LC_Maths_100 = LC_Maths_Points * (100/125),
           LC_English_100 = LC_English_Points,
           JC_Maths_100 = JC_Maths_OPS * (100/12),
           JC_English_100 = JC_English_OPS * (100/12),
           
           # Invert SDQ scales
           across(starts_with("SDQ_"), ~ max(., na.rm = TRUE) - ., .names = "inv_{.col}"),
           
           # Rename inverted SDQ variables
           SDQ_EmoRes_PCG_W3 = inv_SDQ_Emo_PCG_W3,
           SDQ_Good_Conduct_PCG_W3 = inv_SDQ_Conduct_PCG_W3,
           SDQ_Focus_Behav_PCG_W3 = inv_SDQ_Hyper_PCG_W3,
           SDQ_Posi_Peer_PCG_W3 = inv_SDQ_Peer_PCG_W3,
           SDQ_EmoRes_SCG_W3 = inv_SDQ_Emo_SCG_W3,
           SDQ_Good_Conduct_SCG_W3 = inv_SDQ_Conduct_SCG_W3,
           SDQ_Focus_Behav_SCG_W3 = inv_SDQ_Hyper_SCG_W3,
           SDQ_Posi_Peer_SCG_W3 = inv_SDQ_Peer_SCG_W3,
           
           SDQ_EmoRes_PCG_W2 = inv_SDQ_Emo_PCG_W2,
           SDQ_Good_Conduct_PCG_W2 = inv_SDQ_Conduct_PCG_W2,
           SDQ_Focus_Behav_PCG_W2 = inv_SDQ_Hyper_PCG_W2,
           SDQ_Posi_Peer_PCG_W2 = inv_SDQ_Peer_PCG_W2,
           
           SDQ_EmoRes_PCG_W1 = inv_SDQ_Emo_PCG_W1,
           SDQ_Good_Conduct_PCG_W1 = inv_SDQ_Conduct_PCG_W1,
           SDQ_Focus_Behav_PCG_W1 = inv_SDQ_Hyper_PCG_W1,
           SDQ_Posi_Peer_PCG_W1 = inv_SDQ_Peer_PCG_W1,
           SDQ_EmoRes_TC_W1 = inv_SDQ_Emo_TC_W1,
           SDQ_Good_Conduct_TC_W1 = inv_SDQ_Conduct_TC_W1,
           SDQ_Focus_Behav_TC_W1 = inv_SDQ_Hyper_TC_W1,
           SDQ_Posi_Peer_TC_W1 = inv_SDQ_Peer_TC_W1
    ) %>%
      
      # Remove only original SDQ variables and intermediate inverted variables
      select(-matches("^SDQ_(Emo|Conduct|Hyper|Peer)_"),  # Remove original SDQ variables
             -starts_with("inv_SDQ_"),                    # Remove intermediate inverted variables
             everything())                                # Keep all other variables, including renamed SDQ variables
    
    # Rename JC_Maths_OPS and JC_English_OPS for consistency
    Dataset_Test <- Dataset_Test %>%
      rename(
        JC_Maths_Points_W3 = JC_Maths_OPS,
        JC_English_Points_W3 = JC_English_OPS
      )
    
    # Update calculations using the new variable names
    Dataset_Test <- Dataset_Test %>%
      mutate(
        JC_Maths_Standardized = scale(JC_Maths_Points_W3),
        JC_English_Standardized = scale(JC_English_Points_W3),
        JC_Maths_100 = JC_Maths_Points_W3 * (100/12),
        JC_English_100 = JC_English_Points_W3 * (100/12)
      )
    
    # Print summary of renamed variables
    summary(Dataset_Test[c("JC_Maths_Points_W3", "JC_English_Points_W3")])
    
    # Check structure of renamed variables
    str(Dataset_Test[c("JC_Maths_Points_W3", "JC_English_Points_W3")])
    
    # Clean up SDQ variables
    Dataset_Test <- Dataset_Test %>%
      # Remove original SDQ variables
      select(-matches("^SDQ_(Emo|Conduct|Hyper|Peer)_")) %>%
      # Remove intermediate "inv_" variables
      select(-starts_with("inv_SDQ_")) %>%
      # Rename any remaining SDQ variables to ensure consistency
      rename_with(~case_when(
        . == "SDQ_Emo_Res_PCG_W3" ~ "SDQ_Emo_Res_PCG_W3",
        . == "SDQ_Emo_Res_SCG_W3" ~ "SDQ_Emo_Res_SCG_W3",
        . == "SDQ_Emo_Res_PCG_W2" ~ "SDQ_Emo_Res_PCG_W2",
        . == "SDQ_Emo_Res_PCG_W1" ~ "SDQ_Emo_Res_PCG_W1",
        . == "SDQ_Emo_Res_TC_W1" ~ "SDQ_Emo_Res_TC_W1",
        . == "SDQ_Good_Conduct_PCG_W3" ~ "SDQ_Good_Conduct_PCG_W3",
        . == "SDQ_Good_Conduct_SCG_W3" ~ "SDQ_Good_Conduct_SCG_W3",
        . == "SDQ_Good_Conduct_PCG_W2" ~ "SDQ_Good_Conduct_PCG_W2",
        . == "SDQ_Good_Conduct_PCG_W1" ~ "SDQ_Good_Conduct_PCG_W1",
        . == "SDQ_Good_Conduct_TC_W1" ~ "SDQ_Good_Conduct_TC_W1",
        . == "SDQ_Focus_Behav_PCG_W3" ~ "SDQ_Focus_Behav_PCG_W3",
        . == "SDQ_Focus_Behav_SCG_W3" ~ "SDQ_Focus_Behav_SCG_W3",
        . == "SDQ_Focus_Behav_PCG_W2" ~ "SDQ_Focus_Behav_PCG_W2",
        . == "SDQ_Focus_Behav_PCG_W1" ~ "SDQ_Focus_Behav_PCG_W1",
        . == "SDQ_Focus_Behav_TC_W1" ~ "SDQ_Focus_Behav_TC_W1",
        . == "SDQ_Posi_Peer_PCG_W3" ~ "SDQ_Posi_Peer_PCG_W3",
        . == "SDQ_Posi_Peer_SCG_W3" ~ "SDQ_Posi_Peer_SCG_W3",
        . == "SDQ_Posi_Peer_PCG_W2" ~ "SDQ_Posi_Peer_PCG_W2",
        . == "SDQ_Posi_Peer_PCG_W1" ~ "SDQ_Posi_Peer_PCG_W1",
        . == "SDQ_Posi_Peer_TC_W1" ~ "SDQ_Posi_Peer_TC_W1",
        TRUE ~ .
      ), .cols = starts_with("SDQ_"))
    
    # Print the names of SDQ variables to verify
    SDQ_vars <- names(Dataset_Test)[grep("^SDQ_", names(Dataset_Test))]
    print(SDQ_vars)
    
    # Print summary of SDQ variables
    summary(Dataset_Test[SDQ_vars])
    
    # Rename variables to match Oaxaca_Blinder
    Dataset_Test <- Dataset_Test %>%
      rename(
        LC_Did_English_W4 = LC_Did_English,
        LC_Did_Maths_W4 = LC_Did_Maths,
        LC_Maths_Level_W4 = LC_Maths_Level,
        LC_English_Level_W4 = LC_English_Level,
        Mixed_W3 = Mixed_School_W3,
        Mixed_W2 = Mixed_School_W2
      ) %>%
      # Remove variables not in Oaxaca_Blinder
      select(-c(JC_Maths_Standardized, JC_English_Standardized,
                LC_Maths_Standardized, LC_English_Standardized,
                LC_Maths_100, LC_English_100,
                JC_Maths_100, JC_English_100))
    
    # Continue adding Wave 1 questions for PCG
    Dataset_Test <- Dataset_Test %>%
      mutate(
        Maths_Performance_PCG_W1 = Merged_Child$MMJ13,
        Reading_Performance_PCG_W1 = Merged_Child$MMJ14) %>%
      mutate(
        # Recode Maths_Performance_PCG_W1 and Reading_Performance_PCG_W1
        Maths_Performance_PCG_W1 = if_else(Maths_Performance_PCG_W1 == 9, NA_real_, Maths_Performance_PCG_W1),
        Reading_Performance_PCG_W1 = if_else(Reading_Performance_PCG_W1 == 9, NA_real_, Reading_Performance_PCG_W1))
    
    # Inverting JC grades (A = 5 and not A = 1)
    Dataset_Test <- Dataset_Test %>%
      mutate(
        JC_Maths_Grade_W3 = if_else(!is.na(JC_Maths_Grade_W3), 6 - JC_Maths_Grade_W3, NA_real_),
        JC_English_Grade_W3 = if_else(!is.na(JC_English_Grade_W3), 6 - JC_English_Grade_W3, NA_real_)
      )
    
    # Inverting JC levels
    Dataset_Test <- Dataset_Test %>%
      mutate(
        # Invert JC_English_Level_W3: Higher (1) becomes 2, Ordinary (2) becomes 1
        JC_English_Level_W3 = case_when(
          JC_English_Level_W3 == 1 ~ 2,
          JC_English_Level_W3 == 2 ~ 1,
          TRUE ~ JC_English_Level_W3  # Preserve other values (e.g., NA)
        ),
        
        # Invert JC_Maths_Level_W3: Higher (1) becomes 3, Foundation (3) becomes 1
        JC_Maths_Level_W3 = case_when(
          JC_Maths_Level_W3 == 1 ~ 3,
          JC_Maths_Level_W3 == 3 ~ 1,
          TRUE ~ JC_Maths_Level_W3  # Preserve other values (e.g., NA)
        )
      )
    
    # Saving the dataset
    write.csv(Dataset_Test, 
              file = "C:/Users/bgiet/OneDrive/Documents/GitHub/ConflictingForces/ConflictingForces/sensitive_files/ConflictingForcesSensitive/OBD/Dataset_Test.csv", 
              row.names = FALSE)
    
    # Define variable groups for each wave
    
    # Wave 1 (W1) Variables
    w1_tc <- c("TC_Reading_W1", "TC_Writing_W1", "TC_Comprehension_W1", 
               "TC_Maths_W1", "TC_Imagination_W1", "TC_OralComm_W1", "TC_ProblemSol_W1")
    
    w1_class_levels <- c("Reading_Class_Level_W1", "Maths_Class_Level_W1")
    
    w1_cognitive <- c("Cog_Reading_W1", "Cog_Maths_W1")
    
    w1_demographic <- c("Income_Quin_Eq_W1", "PCG_Educ_W1", "SCG_Educ_W1")
    
    w1_hours <- c("English_Hours_W1", "Maths_Hours_W1")
    
    w1_sdq_pcg <- c("SDQ_EmoRes_PCG_W1", "SDQ_Good_Conduct_PCG_W1", 
                    "SDQ_Focus_Behav_PCG_W1", "SDQ_Posi_Peer_PCG_W1")
    
    w1_sdq_tc <- c("SDQ_EmoRes_TC_W1", "SDQ_Good_Conduct_TC_W1", 
                   "SDQ_Focus_Behav_TC_W1", "SDQ_Posi_Peer_TC_W1")
    
    w1_performance_pcg <- c("Maths_Performance_PCG_W1", "Reading_Performance_PCG_W1")
    
    # Wave 2 (W2) Variables
    w2_cognitive <- c("Cog_VR_W2", "Cog_NA_W2", "Cog_Matrices_W2")
    
    w2_demographic <- c("PCG_Educ_W2", "SCG_Educ_W2", "Income_Quin_Eq_W2")
    
    w2_tipi_pcg <- c("TIPI_Extra_PCG_W2", "TIPI_Agreeable_PCG_W2", "TIPI_Cons_PCG_W2", 
                     "TIPI_EmoStab_PCG_W2", "TIPI_Open_PCG_W2")
    
    w2_school <- c("DEIS_W2", "School_Type_W2", "Number_Boys_School_W2", "Number_Girls_School_W2", 
                   "School_Gender_Type_W2", "Girls_Only_School_W2", "Boys_Only_School_W2", "Mixed_W2", 
                   "Fee_Paying_W2", "Voluntary_Secondary_W2", "Vocational_School_W2", 
                   "Community_College_W2", "Community_School_W2", "Comprehensive_School_W2")
    
    w2_sdq_pcg <- c("SDQ_EmoRes_PCG_W2", "SDQ_Good_Conduct_PCG_W2", 
                    "SDQ_Focus_Behav_PCG_W2", "SDQ_Posi_Peer_PCG_W2")
    
    # Wave 3 (W3) Variables
    w3_tipi_yp <- c("TIPI_Extra_YP_W3", "TIPI_Agreeable_YP_W3", "TIPI_Cons_YP_W3", 
                    "TIPI_EmoStab_YP_W3", "TIPI_Open_YP_W3")
    
    w3_tipi_pcg <- c("TIPI_Extra_PCG_W3", "TIPI_Agreeable_PCG_W3", "TIPI_Cons_PCG_W3", 
                     "TIPI_EmoStab_PCG_W3", "TIPI_Open_PCG_W3")
    
    w3_tipi_scg <- c("TIPI_Extra_SCG_W3", "TIPI_Agreeable_SCG_W3", "TIPI_Cons_SCG_W3", 
                     "TIPI_EmoStab_SCG_W3", "TIPI_Open_SCG_W3")
    
    w3_cognitive <- c("Cog_Naming_Total_W3", "Cog_Maths_Total_W3", "Cog_Vocabulary_W3")
    
    w3_demographic <- c("Gender_YP_W3", "PCG_Educ_W3", "SCG_Educ_W3", "Income_Quin_Eq_W3")
    
    w3_school <- c("DEIS_W3", "School_Type_W3", "Number_Boys_School_W3", "Number_Girls_School_W3", 
                   "Fee_Paying_W3", "Non_Fee_Paying_W3", "Vocational_W3", "Community_College_W3", 
                   "Comprehensive_School_W3", "School_Gender_Type_W3", "Girls_Only_School_W3", 
                   "Boys_Only_School_W3", "Mixed_W3")
    
    w3_self <- c("Self_Esteem_YP_W3", "Locus_Control_YP_W3", "Self_Control_YP_W3")
    
    w3_jc <- c("JC_Did_Maths_W3", "JC_Maths_Level_W3", "JC_Maths_Grade_W3", 
               "JC_Did_English_W3", "JC_English_Level_W3", "JC_English_Grade_W3", 
               "JC_Maths_Points_W3", "JC_English_Points_W3")
    
    w3_sdq_pcg <- c("SDQ_EmoRes_PCG_W3", "SDQ_Good_Conduct_PCG_W3", 
                    "SDQ_Focus_Behav_PCG_W3", "SDQ_Posi_Peer_PCG_W3")
    
    w3_sdq_scg <- c("SDQ_EmoRes_SCG_W3", "SDQ_Good_Conduct_SCG_W3", 
                    "SDQ_Focus_Behav_SCG_W3", "SDQ_Posi_Peer_SCG_W3")
    
    # Wave 4 (W4) Variables
    w4_lc <- c("LC_Did_English_W4", "LC_Did_Maths_W4", "LC_Maths_Level_W4", 
               "LC_English_Level_W4", "LC_Maths_Points", "LC_English_Points")
    
    w4_tipi_yp <- c("TIPI_Agreeable_YP_W4", "TIPI_EmoStab_YP_W4", "TIPI_Cons_YP_W4", 
                    "TIPI_Extra_YP_W4", "TIPI_Open_YP_W4")
    
    w4_cognitive <- c("CognitiveNamingFruit_W4")
    
    w4_tipi_pcg <- c("TIPI_Agreeable_PCG_W4", "TIPI_EmoStab_PCG_W4", "TIPI_Cons_PCG_W4", 
                     "TIPI_Extra_PCG_W4", "TIPI_Open_PCG_W4")
    
    w4_grinds <- c("Grinds_All_Subjects_W4", "Grinds_English_W4", "Grinds_Maths_W4")
    
    # All waves combined
    all_waves <- c(
      w1_tc, w1_class_levels, w1_cognitive, w1_demographic, w1_hours, w1_sdq_pcg, w1_sdq_tc, w1_performance_pcg,
      w2_cognitive, w2_demographic, w2_tipi_pcg, w2_school, w2_sdq_pcg,
      w3_tipi_yp, w3_tipi_pcg, w3_tipi_scg, w3_cognitive, w3_demographic, w3_school, w3_self, w3_jc, w3_sdq_pcg, w3_sdq_scg,
      w4_lc, w4_tipi_yp, w4_cognitive, w4_tipi_pcg, w4_grinds
    )
    
    # Print summary of all variables
    summary(Dataset_Test[all_waves])
    
    # Check for any missing variables
    missing_vars <- setdiff(all_waves, names(Dataset_Test))
    if (length(missing_vars) > 0) {
      cat("Missing variables:", paste(missing_vars, collapse = ", "), "\n")
    } else {
      cat("All variables are present in the dataset.\n")
    }
