Oaxaca_with_SCG <- production_data %>%
  select(
    ID, Maths_points, English_points, Gender_factor,  # Outcomes & Demographics
    Drum_VR_W2_p, Drum_NA_W2_p, BAS_TS_Mat_W2,  # Cognitive (raw)
    SDQ_emot_PCG_W2, SDQ_cond_PCG_W2, SDQ_hyper_PCG_W2, SDQ_peer_PCG_W2,  # Noncognitive (raw)
    PCG_Educ_W2, SCG_Educ_W2, Income_equi_quint,  # Socioeconomic (raw)
    DEIS_binary_W2, Fee_paying_W2, Mixed  # School indicators (if needed later)
  )


Oaxaca_with_SCG <- Oaxaca_with_SCG %>% 
mutate(
  SDQ_emot_PCG_W2 = 10 - SDQ_emot_PCG_W2,
  SDQ_cond_PCG_W2 = 10 -  SDQ_cond_PCG_W2,
  SDQ_hyper_PCG_W2 = 10 - SDQ_hyper_PCG_W2,
  SDQ_peer_PCG_W2 = 10 - SDQ_peer_PCG_W2
)

# Dummy for male
Oaxaca_with_SCG <- Oaxaca_with_SCG %>%
  mutate(gender_binary = if_else(Gender_factor == "Male", 1, 0))

# Creating dummies for education
Oaxaca_with_SCG <- Oaxaca_with_SCG %>%
  mutate(
    PCG_Educ_W2_Dummy34 = if_else(PCG_Educ_W2 %in% c(3, 4), 1, 0),
    PCG_Educ_W2_Dummy56 = if_else(PCG_Educ_W2 %in% c(5, 6), 1, 0),
    SCG_Educ_W2_Dummy34 = if_else(SCG_Educ_W2 %in% c(3, 4), 1, 0),
    SCG_Educ_W2_Dummy56 = if_else(SCG_Educ_W2 %in% c(5, 6), 1, 0)
  )

Oaxaca_with_SCG <- Oaxaca_with_SCG %>%
  inner_join(Merged_Child %>% select(ID, readpct,mathpct,
                                     MMH2_SDQemot,MMH2_SDQcond,MMH2_SDQhyper,MMH2_SDQpeer,
                                     MML37, FE1,
                                     EIncQuin), by = "ID")

Oaxaca_with_SCG <- Oaxaca_with_SCG %>% 
  rename(
    Cog_Reading_W1 = readpct,
    Cog_Maths_W1 = mathpct,
    SDQ_emot_PCG_W1 = MMH2_SDQemot, 
    SDQ_cond_PCG_W1 = MMH2_SDQcond,
    SDQ_hyper_PCG_W1 = MMH2_SDQhyper,
    SDQ_peer_PCG_W1 = MMH2_SDQpeer,
    PCG_Educ_W1 = MML37,
    SCG_Educ_W1 = FE1,
    Income_equi_quint_W1 = EIncQuin
  )

Oaxaca_with_SCG <- Oaxaca_with_SCG %>%
  mutate(
    PCG_Educ_W1_Dummy34 = if_else(PCG_Educ_W1 %in% c(3, 4), 1, 0),
    PCG_Educ_W1_Dummy56 = if_else(PCG_Educ_W1 %in% c(5, 6), 1, 0),
    SCG_Educ_W1_Dummy34 = if_else(SCG_Educ_W1 %in% c(3, 4), 1, 0),
    SCG_Educ_W1_Dummy56 = if_else(SCG_Educ_W1 %in% c(5, 6), 1, 0) 
  )

Oaxaca_with_SCG <- na.omit(Oaxaca_with_SCG)
# 2. Let's check missing values
missing_summary <- sapply(Oaxaca_with_SCG, function(x) sum(is.na(x)))
print("Missing values per variable:")
print(missing_summary)

write.csv(Oaxaca_with_SCG, "Oaxaca_with_SCG.csv", row.names = FALSE)

# Load necessary library
library(lmtest)

# Run regression for Maths Points
maths_model <- lm(Maths_points ~ Cog_Maths_W1 + Drum_NA_W2_p + 
                    PCG_Educ_W1 + PCG_Educ_W2 + SCG_Educ_W1 + SCG_Educ_W2 +
                    SDQ_emot_PCG_W1 + SDQ_hyper_PCG_W1 + SDQ_cond_PCG_W1 + SDQ_peer_PCG_W1 +
                    SDQ_emot_PCG_W2 + SDQ_hyper_PCG_W2 + SDQ_cond_PCG_W2 + SDQ_peer_PCG_W2 +
                    Income_equi_quint_W1 + Income_equi_quint, data = Oaxaca_with_SCG)

summary(maths_model)

# Run regression for English Points
english_model <- lm(English_points ~ Cog_Reading_W1 + Drum_VR_W2_p + 
                      PCG_Educ_W1 + PCG_Educ_W2 + SCG_Educ_W1 + SCG_Educ_W2 +
                      SDQ_emot_PCG_W1 + SDQ_hyper_PCG_W1 + SDQ_cond_PCG_W1 + SDQ_peer_PCG_W1 +
                      SDQ_emot_PCG_W2 + SDQ_hyper_PCG_W2 + SDQ_cond_PCG_W2 + SDQ_peer_PCG_W2 +
                      Income_equi_quint_W1 + Income_equi_quint, data = Oaxaca_with_SCG)

summary(english_model)


# Create change variables
Oaxaca_with_SCG$maths_change <- Oaxaca_with_SCG$Drum_NA_W2_p - Oaxaca_with_SCG$Cog_Maths_W1
Oaxaca_with_SCG$reading_change <- Oaxaca_with_SCG$Drum_VR_W2_p - Oaxaca_with_SCG$Cog_Reading_W1

# Compare means by gender
maths_change_by_gender <- tapply(Oaxaca_with_SCG$maths_change, Oaxaca_with_SCG$gender_binary, mean, na.rm = TRUE)
reading_change_by_gender <- tapply(Oaxaca_with_SCG$reading_change, Oaxaca_with_SCG$gender_binary, mean, na.rm = TRUE)

# Print results
cat("Average Maths Growth: Boys =", maths_change_by_gender[2], "Girls =", maths_change_by_gender[1], "\n")
cat("Average Reading Growth: Boys =", reading_change_by_gender[2], "Girls =", reading_change_by_gender[1], "\n")

# Standardizing cognitive ability variables
Oaxaca_with_SCG <- Oaxaca_with_SCG %>%
  mutate(
    Cog_Maths_W1_z = scale(Cog_Maths_W1),
    Drum_NA_W2_p_z = scale(Drum_NA_W2_p),
    Cog_Reading_W1_z = scale(Cog_Reading_W1),
    Drum_VR_W2_p_z = scale(Drum_VR_W2_p)
  )

maths_model_z <- lm(Maths_points ~ Cog_Maths_W1_z + Drum_NA_W2_p_z + 
                      PCG_Educ_W1 + PCG_Educ_W2 + SCG_Educ_W1 + SCG_Educ_W2 +
                      SDQ_emot_PCG_W1 + SDQ_hyper_PCG_W1 + SDQ_cond_PCG_W1 + SDQ_peer_PCG_W1 +
                      SDQ_emot_PCG_W2 + SDQ_hyper_PCG_W2 + SDQ_cond_PCG_W2 + SDQ_peer_PCG_W2 +
                    Income_equi_quint_W1 + Income_equi_quint, 
                  data = Oaxaca_with_SCG)

english_model_z <- lm(English_points ~ Cog_Reading_W1_z + Drum_VR_W2_p_z + 
                        PCG_Educ_W1 + PCG_Educ_W2 + SCG_Educ_W1 + SCG_Educ_W2 +
                        SDQ_emot_PCG_W1 + SDQ_hyper_PCG_W1 + SDQ_cond_PCG_W1 + SDQ_peer_PCG_W1 +
                        SDQ_emot_PCG_W2 + SDQ_hyper_PCG_W2 + SDQ_cond_PCG_W2 + SDQ_peer_PCG_W2 +
                      Income_equi_quint_W1 + Income_equi_quint, 
                    data = Oaxaca_with_SCG)

summary(maths_model_z)
summary(english_model_z)


# Maths Model with Gender
maths_model_gender <- lm(Maths_points ~ gender_binary + Cog_Maths_W1_z + Drum_NA_W2_p_z + 
                           PCG_Educ_W1 + PCG_Educ_W2 + SCG_Educ_W1 + SCG_Educ_W2 +
                           SDQ_emot_PCG_W1 + SDQ_hyper_PCG_W1 + SDQ_cond_PCG_W1 + SDQ_peer_PCG_W1 +
                           SDQ_emot_PCG_W2 + SDQ_hyper_PCG_W2 + SDQ_cond_PCG_W2 + SDQ_peer_PCG_W2 +
                           Income_equi_quint_W1 + Income_equi_quint, 
                         data = Oaxaca_with_SCG)

# English Model with Gender
english_model_gender <- lm(English_points ~ gender_binary + Cog_Reading_W1_z + Drum_VR_W2_p_z + 
                             PCG_Educ_W1 + PCG_Educ_W2 + SCG_Educ_W1 + SCG_Educ_W2 +
                             SDQ_emot_PCG_W1 + SDQ_hyper_PCG_W1 + SDQ_cond_PCG_W1 + SDQ_peer_PCG_W1 +
                             SDQ_emot_PCG_W2 + SDQ_hyper_PCG_W2 + SDQ_cond_PCG_W2 + SDQ_peer_PCG_W2 +
                             Income_equi_quint_W1 + Income_equi_quint, 
                           data = Oaxaca_with_SCG)
summary(maths_model_gender)
summary(english_model_gender)

library(splines)

maths_model_spline <- lm(
  Maths_points ~ gender_binary * ns(Cog_Maths_W1_z, df = 3) + gender_binary * ns(Drum_NA_W2_p_z, df = 3) +
    PCG_Educ_W1 + PCG_Educ_W2 + SCG_Educ_W1 + SCG_Educ_W2 +
    SDQ_emot_PCG_W1 + SDQ_hyper_PCG_W1 + SDQ_cond_PCG_W1 + SDQ_peer_PCG_W1 +
    SDQ_emot_PCG_W2 + SDQ_hyper_PCG_W2 + SDQ_cond_PCG_W2 + SDQ_peer_PCG_W2 + 
    Income_equi_quint_W1 + Income_equi_quint,
  data = Oaxaca_with_SCG
)

english_model_spline <- lm(
  English_points ~ gender_binary * ns(Cog_Reading_W1_z, df = 3) + gender_binary * ns(Drum_VR_W2_p_z, df = 3) +
    PCG_Educ_W1 + PCG_Educ_W2 + SCG_Educ_W1 + SCG_Educ_W2 +
    SDQ_emot_PCG_W1 + SDQ_hyper_PCG_W1 + SDQ_cond_PCG_W1 + SDQ_peer_PCG_W1 +
    SDQ_emot_PCG_W2 + SDQ_hyper_PCG_W2 + SDQ_cond_PCG_W2 + SDQ_peer_PCG_W2 +
    Income_equi_quint_W1 + Income_equi_quint,
  data = Oaxaca_with_SCG
)

summary(maths_model_spline)
summary(english_model_spline)


