# Cleaned and organized script for Wave 1 and Wave 2 analysis on father availability and Maths JC scores

library(dplyr)

# ----------------------------
# Wave 1: Father Education and Maths JC Scores (Model 1 & 2)
# ----------------------------

# Check missingness
cat("\nWave 1 - Father Education Dummy (34):\n")
table(is.na(selected_data$SCG_Educ_W1_Dummy34))

cat("\nWave 1 - Father Education Dummy (56):\n")
table(is.na(selected_data$SCG_Educ_W1_Dummy56))

cat("\nWave 1 - Father Education Availability:\n")
table(selected_data$Father_Educ_Available_W1)

# Summary statistics by availability
selected_data %>%
  group_by(Father_Educ_Available_W1) %>%
  summarise(
    Mean_Maths = mean(Maths_points_W3, na.rm = TRUE),
    SD_Maths = sd(Maths_points_W3, na.rm = TRUE),
    Count = sum(!is.na(Maths_points_W3))
  )

# T-test
cat("\nWave 1 - T-test:\n")
t.test(Maths_points_W3 ~ Father_Educ_Available_W1, data = selected_data, var.equal = TRUE)

# Linear model
model1 <- lm(Maths_points_W3 ~ Father_Educ_Available_W1, data = selected_data)
summary(model1)

# ----------------------------
# Wave 2: Father Education and Maths JC Scores (Model 3 & 4)
# ----------------------------

# Check missingness
cat("\nWave 2 - Father Education Dummy (34):\n")
table(is.na(selected_data$SCG_Educ_W2_Dummy34))

cat("\nWave 2 - Father Education Dummy (56):\n")
table(is.na(selected_data$SCG_Educ_W2_Dummy56))

cat("\nWave 2 - Father Education Availability:\n")
table(selected_data$Father_Educ_Available_W2)

# Summary statistics by availability
selected_data %>%
  group_by(Father_Educ_Available_W2) %>%
  summarise(
    Mean_Maths = mean(Maths_points_W3, na.rm = TRUE),
    SD_Maths = sd(Maths_points_W3, na.rm = TRUE),
    Count = sum(!is.na(Maths_points_W3))
  )

# T-test
cat("\nWave 2 - T-test:\n")
t.test(Maths_points_W3 ~ Father_Educ_Available_W2, data = selected_data, var.equal = TRUE)

# Linear model
model2 <- lm(Maths_points_W3 ~ Father_Educ_Available_W2, data = selected_data)
summary(model2)

# ----------------------------
# Inconsistent NA Patterns
# ----------------------------

na_cases <- selected_data %>%
  filter(is.na(father_absent_status_test)) %>%
  count(Father_Educ_Missing_W1, Father_Educ_Missing_W2)

cat("\nNA patterns in father_absent_status_test:\n")
print(na_cases)

# ----------------------------
# Gender-Based Density Plot of JC Maths Points
# ----------------------------

# Prepare non-missing values
maths_female <- na.omit(selected_data$Maths_points_W3[selected_data$Gender_binary == 0])
maths_male <- na.omit(selected_data$Maths_points_W3[selected_data$Gender_binary == 1])

# Plot
plot(density(maths_female), 
     main = "Density Plot of Maths JC Scores by Gender", 
     xlab = "Maths Points (JC)", 
     col = "red", lwd = 2, ylim = c(0, 0.35))
lines(density(maths_male), col = "blue", lwd = 2)
legend("topleft", legend = c("Female", "Male"), fill = c("red", "blue"))




# Regressions for Maths

# Model 1
Maths_W1_nodad <- lm(Maths_points_W3 ~ Cog_Maths_W1_l + Cog_Reading_W1_l +
                       SDQ_emot_PCG_W1 + SDQ_cond_PCG_W1 +  SDQ_hyper_PCG_W1 + SDQ_peer_PCG_W1 +
                       PCG_Educ_W1_Dummy34 + PCG_Educ_W1_Dummy56 + Income_equi_quint_W1 +
                       Gender_binary + mixed_school_w1 + Father_Educ_Missing_W1, 
                     data = selected_data)
summary(Maths_W1_nodad)

#Model 2
Maths_W1_withdad <- lm(Maths_points_W3 ~ Cog_Maths_W1_l + Cog_Reading_W1_l +
                         SDQ_emot_PCG_W1 + SDQ_cond_PCG_W1 +  SDQ_hyper_PCG_W1 + SDQ_peer_PCG_W1 +
                         PCG_Educ_W1_Dummy34 + PCG_Educ_W1_Dummy56 + SCG_Educ_W1_Dummy34 + SCG_Educ_W1_Dummy56 + 
                         Income_equi_quint_W1 + Gender_binary + mixed_school_w1, 
                       data = selected_data)
summary(Maths_W1_withdad)

# Model 3
Maths_W2_nodad <- lm(Maths_points_W3 ~ Drum_NA_W2_l + Drum_VR_W2_l + BAS_TS_Mat_W2 +
                       SDQ_emot_PCG_W2 + SDQ_cond_PCG_W2 +  SDQ_hyper_PCG_W2 + SDQ_peer_PCG_W2 +
                       PCG_Educ_W2_Dummy34 + PCG_Educ_W2_Dummy56 + Income_equi_quint_W2 +
                       Gender_binary + Fee_paying_W2 + DEIS_W2 + religious_school_w2 + mixed_school_w2 + Father_Educ_Missing_W2, 
                     data = selected_data)
summary(Maths_W2_nodad)

# Model 4
Maths_W2_withdad <- lm(Maths_points_W3 ~ Drum_NA_W2_l + Drum_VR_W2_l + BAS_TS_Mat_W2 +
                         SDQ_emot_PCG_W2 + SDQ_cond_PCG_W2 +  SDQ_hyper_PCG_W2 + SDQ_peer_PCG_W2 +
                         PCG_Educ_W2_Dummy34 + PCG_Educ_W2_Dummy56 + SCG_Educ_W2_Dummy34 + SCG_Educ_W2_Dummy56 + 
                         Income_equi_quint_W2 + Gender_binary + Fee_paying_W2 + DEIS_W2 + religious_school_w2 + mixed_school_w2, 
                       data = selected_data)
summary(Maths_W2_withdad)


# ENGLISH RESULTS

# Running regressions

# Wave 1
# Baseline (Model 1) + Father included (Model 2)

table(is.na(selected_data$SCG_Educ_W1_Dummy34))
table(is.na(selected_data$SCG_Educ_W1_Dummy56))
table(selected_data$Father_Educ_Available_W1)
aggregate(English_points_W3 ~ Father_Educ_Available_W1, data = selected_data, FUN = mean)
aggregate(English_points_W3 ~ Father_Educ_Available_W1, data = selected_data, FUN = sd)
t.test(English_points_W3 ~ Father_Educ_Available_W1, data = selected_data, var.equal = TRUE)
english <- lm(English_points_W3 ~ Father_Educ_Available_W1, data = selected_data)
summary(english)

english_income <- lm(English_points_W3 ~ Father_Educ_Available_W1 + Income_equi_quint_W1, data = selected_data)
summary(english_income)
english_mother <- lm(English_points_W3 ~ Father_Educ_Available_W1 + PCG_Educ_W1_Dummy34 + PCG_Educ_W1_Dummy56, data = selected_data)
summary(english_mother)

# Model 1
english_W1_nodad <- lm(English_points_W3 ~ Cog_Maths_W1_l + Cog_Reading_W1_l +
                         SDQ_emot_PCG_W1 + SDQ_cond_PCG_W1 +  SDQ_hyper_PCG_W1 + SDQ_peer_PCG_W1 +
                         PCG_Educ_W1_Dummy34 + PCG_Educ_W1_Dummy56 + Income_equi_quint_W1 +
                         Gender_binary + mixed_school_w1 + Father_Educ_Missing_W1, 
                       data = selected_data)
summary(english_W1_nodad)

#Model 2
english_W1_withdad <- lm(English_points_W3 ~ Cog_Maths_W1_l + Cog_Reading_W1_l +
                           SDQ_emot_PCG_W1 + SDQ_cond_PCG_W1 +  SDQ_hyper_PCG_W1 + SDQ_peer_PCG_W1 +
                           PCG_Educ_W1_Dummy34 + PCG_Educ_W1_Dummy56 + SCG_Educ_W1_Dummy34 + SCG_Educ_W1_Dummy56 + 
                           Income_equi_quint_W1 + Gender_binary + mixed_school_w1, 
                         data = selected_data)
summary(english_W1_withdad)



# Wave 2
# Baseline (Model 3) + Father included (Model 4)

table(is.na(selected_data$SCG_Educ_W2_Dummy34))
table(is.na(selected_data$SCG_Educ_W2_Dummy56))
table(selected_data$Father_Educ_Available_W2)
aggregate(English_points_W3 ~ Father_Educ_Available_W2, data = selected_data, FUN = mean)
aggregate(English_points_W3 ~ Father_Educ_Available_W2, data = selected_data, FUN = sd)
t.test(English_points_W3 ~ Father_Educ_Available_W2, data = selected_data, var.equal = TRUE)
english <- lm(English_points_W3 ~ Father_Educ_Available_W2, data = selected_data)
summary(english)

english_income <- lm(English_points_W3 ~ Father_Educ_Available_W2 + Income_equi_quint_W2, data = selected_data)
summary(english_income)
english_mother <- lm(English_points_W3 ~ Father_Educ_Available_W2 + PCG_Educ_W2_Dummy34 + PCG_Educ_W2_Dummy56, data = selected_data)
summary(english_mother)


selected_data$Father_Educ_Missing_W2 <- ifelse(is.na(selected_data$SCG_Educ_W2_Dummy34) & is.na(selected_data$SCG_Educ_W2_Dummy56), 1, 0)

# Model 3
english_W2_nodad <- lm(English_points_W3 ~ Drum_NA_W2_l + Drum_VR_W2_l + BAS_TS_Mat_W2 +
                         SDQ_emot_PCG_W2 + SDQ_cond_PCG_W2 +  SDQ_hyper_PCG_W2 + SDQ_peer_PCG_W2 +
                         PCG_Educ_W2_Dummy34 + PCG_Educ_W2_Dummy56 + Income_equi_quint_W2 +
                         Gender_binary + Fee_paying_W2 + DEIS_W2 + religious_school_w2 + mixed_school_w2 + Father_Educ_Missing_W2, 
                       data = selected_data)
summary(english_W2_nodad)

# Model 4
english_W2_withdad <- lm(English_points_W3 ~ Drum_NA_W2_l + Drum_VR_W2_l + BAS_TS_Mat_W2 +
                           SDQ_emot_PCG_W2 + SDQ_cond_PCG_W2 +  SDQ_hyper_PCG_W2 + SDQ_peer_PCG_W2 +
                           PCG_Educ_W2_Dummy34 + PCG_Educ_W2_Dummy56 + SCG_Educ_W2_Dummy34 + SCG_Educ_W2_Dummy56 + 
                           Income_equi_quint_W2 + Gender_binary + Fee_paying_W2 + DEIS_W2 + religious_school_w2 + mixed_school_w2, 
                         data = selected_data)
summary(english_W2_withdad)



# Look at patterns for the NA cases
na_cases <- selected_data %>%
  filter(is.na(father_absent_status_test)) %>%
  select(Father_Educ_Missing_W1, Father_Educ_Missing_W2) %>%
  count(Father_Educ_Missing_W1, Father_Educ_Missing_W2)

print(na_cases)

# Remove missing values before plotting
english_female <- na.omit(selected_data$English_points_W3[selected_data$Gender_binary == 0])
english_male <- na.omit(selected_data$English_points_W3[selected_data$Gender_binary == 1])

# Create density plots for English scores by gender
plot(density(english_female, dw = 0.4), 
     main = "Density Plot of English Scores by Gender", 
     xlab = "English Points", col = "red", lwd = 2, ylim = c(0, 1)) # Adjust ylim to expand y-axis
lines(density(english_male), 
      col = "blue", lwd = 2)
legend("topleft", legend = c("Female", "Male"), fill = c("red", "blue"))


# Centering

library(dplyr)

# Create a new dataframe with centered variables
selected_data_centered <- selected_data %>%
  mutate(
    # Age 9 variables
    Cog_Maths_W1_l_c = Cog_Maths_W1_l - mean(Cog_Maths_W1_l, na.rm = TRUE),
    Cog_Reading_W1_l_c = Cog_Reading_W1_l - mean(Cog_Reading_W1_l, na.rm = TRUE),
    SDQ_emot_PCG_W1_c = SDQ_emot_PCG_W1 - mean(SDQ_emot_PCG_W1, na.rm = TRUE),
    SDQ_cond_PCG_W1_c = SDQ_cond_PCG_W1 - mean(SDQ_cond_PCG_W1, na.rm = TRUE),
    SDQ_hyper_PCG_W1_c = SDQ_hyper_PCG_W1 - mean(SDQ_hyper_PCG_W1, na.rm = TRUE),
    SDQ_peer_PCG_W1_c = SDQ_peer_PCG_W1 - mean(SDQ_peer_PCG_W1, na.rm = TRUE),
    Income_equi_quint_W1_c = Income_equi_quint_W1 - mean(Income_equi_quint_W1, na.rm = TRUE),
    
    # Age 13 variables
    Drum_NA_W2_l_c = Drum_NA_W2_l - mean(Drum_NA_W2_l, na.rm = TRUE),
    Drum_VR_W2_l_c = Drum_VR_W2_l - mean(Drum_VR_W2_l, na.rm = TRUE),
    BAS_TS_Mat_W2_c = BAS_TS_Mat_W2 - mean(BAS_TS_Mat_W2, na.rm = TRUE),
    SDQ_emot_PCG_W2_c = SDQ_emot_PCG_W2 - mean(SDQ_emot_PCG_W2, na.rm = TRUE),
    SDQ_cond_PCG_W2_c = SDQ_cond_PCG_W2 - mean(SDQ_cond_PCG_W2, na.rm = TRUE),
    SDQ_hyper_PCG_W2_c = SDQ_hyper_PCG_W2 - mean(SDQ_hyper_PCG_W2, na.rm = TRUE),
    SDQ_peer_PCG_W2_c = SDQ_peer_PCG_W2 - mean(SDQ_peer_PCG_W2, na.rm = TRUE),
    Income_equi_quint_W2_c = Income_equi_quint_W2 - mean(Income_equi_quint_W2, na.rm = TRUE)
  )

# Model 1 – Maths, Age 9 predictors, no father's education
Maths_W1_nodad_c <- lm(Maths_points_W3 ~ Cog_Maths_W1_l_c + Cog_Reading_W1_l_c +
                         SDQ_emot_PCG_W1_c + SDQ_cond_PCG_W1_c + SDQ_hyper_PCG_W1_c + SDQ_peer_PCG_W1_c +
                         PCG_Educ_W1_Dummy34 + PCG_Educ_W1_Dummy56 + Income_equi_quint_W1_c +
                         Gender_binary + mixed_school_w1 + Father_Educ_Missing_W1, 
                       data = selected_data_centered)
summary(Maths_W1_nodad_c)

# Model 2 – Maths, Age 9 predictors, with father's education
Maths_W1_withdad_c <- lm(Maths_points_W3 ~ Cog_Maths_W1_l_c + Cog_Reading_W1_l_c +
                           SDQ_emot_PCG_W1_c + SDQ_cond_PCG_W1_c + SDQ_hyper_PCG_W1_c + SDQ_peer_PCG_W1_c +
                           PCG_Educ_W1_Dummy34 + PCG_Educ_W1_Dummy56 + SCG_Educ_W1_Dummy34 + SCG_Educ_W1_Dummy56 +
                           Income_equi_quint_W1_c + Gender_binary + mixed_school_w1, 
                         data = selected_data_centered)
summary(Maths_W1_withdad_c)

# Model 3 – Maths, Age 13 predictors, no father's education
Maths_W2_nodad_c <- lm(Maths_points_W3 ~ Drum_NA_W2_l_c + Drum_VR_W2_l_c + BAS_TS_Mat_W2_c +
                         SDQ_emot_PCG_W2_c + SDQ_cond_PCG_W2_c + SDQ_hyper_PCG_W2_c + SDQ_peer_PCG_W2_c +
                         PCG_Educ_W2_Dummy34 + PCG_Educ_W2_Dummy56 + Income_equi_quint_W2_c +
                         Gender_binary + Fee_paying_W2 + DEIS_W2 + religious_school_w2 + mixed_school_w2 + Father_Educ_Missing_W2, 
                       data = selected_data_centered)
summary(Maths_W2_nodad_c)

# Model 4 – Maths, Age 13 predictors, with father's education
Maths_W2_withdad_c <- lm(Maths_points_W3 ~ Drum_NA_W2_l_c + Drum_VR_W2_l_c + BAS_TS_Mat_W2_c +
                           SDQ_emot_PCG_W2_c + SDQ_cond_PCG_W2_c + SDQ_hyper_PCG_W2_c + SDQ_peer_PCG_W2_c +
                           PCG_Educ_W2_Dummy34 + PCG_Educ_W2_Dummy56 + SCG_Educ_W2_Dummy34 + SCG_Educ_W2_Dummy56 +
                           Income_equi_quint_W2_c + Gender_binary + Fee_paying_W2 + DEIS_W2 + religious_school_w2 + mixed_school_w2, 
                         data = selected_data_centered)
summary(Maths_W2_withdad_c)


# Model 1 – English, Age 9 predictors, no father's education
english_W1_nodad_c <- lm(English_points_W3 ~ Cog_Maths_W1_l_c + Cog_Reading_W1_l_c +
                           SDQ_emot_PCG_W1_c + SDQ_cond_PCG_W1_c + SDQ_hyper_PCG_W1_c + SDQ_peer_PCG_W1_c +
                           PCG_Educ_W1_Dummy34 + PCG_Educ_W1_Dummy56 + Income_equi_quint_W1_c +
                           Gender_binary + mixed_school_w1 + Father_Educ_Missing_W1, 
                         data = selected_data_centered)
summary(english_W1_nodad_c)

# Model 2 – English, Age 9 predictors, with father's education
english_W1_withdad_c <- lm(English_points_W3 ~ Cog_Maths_W1_l_c + Cog_Reading_W1_l_c +
                             SDQ_emot_PCG_W1_c + SDQ_cond_PCG_W1_c + SDQ_hyper_PCG_W1_c + SDQ_peer_PCG_W1_c +
                             PCG_Educ_W1_Dummy34 + PCG_Educ_W1_Dummy56 + SCG_Educ_W1_Dummy34 + SCG_Educ_W1_Dummy56 +
                             Income_equi_quint_W1_c + Gender_binary + mixed_school_w1, 
                           data = selected_data_centered)
summary(english_W1_withdad_c)

# Model 3 – English, Age 13 predictors, no father's education
english_W2_nodad_c <- lm(English_points_W3 ~ Drum_NA_W2_l_c + Drum_VR_W2_l_c + BAS_TS_Mat_W2_c +
                           SDQ_emot_PCG_W2_c + SDQ_cond_PCG_W2_c + SDQ_hyper_PCG_W2_c + SDQ_peer_PCG_W2_c +
                           PCG_Educ_W2_Dummy34 + PCG_Educ_W2_Dummy56 + Income_equi_quint_W2_c +
                           Gender_binary + Fee_paying_W2 + DEIS_W2 + religious_school_w2 + mixed_school_w2 + Father_Educ_Missing_W2, 
                         data = selected_data_centered)
summary(english_W2_nodad_c)

# Model 4 – English, Age 13 predictors, with father's education
english_W2_withdad_c <- lm(English_points_W3 ~ Drum_NA_W2_l_c + Drum_VR_W2_l_c + BAS_TS_Mat_W2_c +
                             SDQ_emot_PCG_W2_c + SDQ_cond_PCG_W2_c + SDQ_hyper_PCG_W2_c + SDQ_peer_PCG_W2_c +
                             PCG_Educ_W2_Dummy34 + PCG_Educ_W2_Dummy56 + SCG_Educ_W2_Dummy34 + SCG_Educ_W2_Dummy56 +
                             Income_equi_quint_W2_c + Gender_binary + Fee_paying_W2 + DEIS_W2 + religious_school_w2 + mixed_school_w2, 
                           data = selected_data_centered)
summary(english_W2_withdad_c)

#--------------------------------------------------------------------------------------------
# Using the Leaving Cert:
table(is.na(selected_data$Maths_Points_Adjusted))
summary(selected_data$Maths_Points_Adjusted)


# Rerunning with LC:
# Model 1
selected_data %>% filter(!is.na(Maths_Points_Adjusted))
Maths_W1_nodad_LC <- lm(Maths_Points_Adjusted ~ Cog_Maths_W1_l + Cog_Reading_W1_l +
                            SDQ_emot_PCG_W1 + SDQ_cond_PCG_W1 +  SDQ_hyper_PCG_W1 + SDQ_peer_PCG_W1 +
                            PCG_Educ_W1_Dummy34 + PCG_Educ_W1_Dummy56 + Income_equi_quint_W1 +
                            Gender_binary + mixed_school_w1 + Father_Educ_Missing_W1, 
                          data = selected_data)
summary(Maths_W1_nodad_LC)

#Model 2
Maths_W1_withdad_LC <- lm(Maths_Points_Adjusted ~ Cog_Maths_W1_l + Cog_Reading_W1_l +
                         SDQ_emot_PCG_W1 + SDQ_cond_PCG_W1 +  SDQ_hyper_PCG_W1 + SDQ_peer_PCG_W1 +
                         PCG_Educ_W1_Dummy34 + PCG_Educ_W1_Dummy56 + SCG_Educ_W1_Dummy34 + SCG_Educ_W1_Dummy56 + 
                         Income_equi_quint_W1 + Gender_binary + mixed_school_w1, 
                       data = selected_data)
summary(Maths_W1_withdad_LC)


# Model 3

Maths_W2_nodad_LC <- lm(Maths_Points_Adjusted ~ Drum_NA_W2_l + Drum_VR_W2_l + BAS_TS_Mat_W2 +
                       SDQ_emot_PCG_W2 + SDQ_cond_PCG_W2 +  SDQ_hyper_PCG_W2 + SDQ_peer_PCG_W2 +
                       PCG_Educ_W2_Dummy34 + PCG_Educ_W2_Dummy56 + Income_equi_quint_W2 +
                       Gender_binary + Fee_paying_W2 + DEIS_W2 + religious_school_w2 + mixed_school_w2 + Father_Educ_Missing_W2, 
                     data = selected_data)
summary(Maths_W2_nodad_LC)

# Model 4

Maths_W2_withdad_LC <- lm(Maths_Points_Adjusted ~ Drum_NA_W2_l + Drum_VR_W2_l + BAS_TS_Mat_W2 +
                         SDQ_emot_PCG_W2 + SDQ_cond_PCG_W2 +  SDQ_hyper_PCG_W2 + SDQ_peer_PCG_W2 +
                         PCG_Educ_W2_Dummy34 + PCG_Educ_W2_Dummy56 + SCG_Educ_W2_Dummy34 + SCG_Educ_W2_Dummy56 + 
                         Income_equi_quint_W2 + Gender_binary + Fee_paying_W2 + DEIS_W2 + religious_school_w2 + mixed_school_w2, 
                       data = selected_data)
summary(Maths_W2_withdad_LC)


# Significance tests for Leaving Cert
library(dplyr)
library(ggplot2)

# Boys vs Girls
t.test(Maths_Points_Adjusted ~ Gender_binary, data = selected_data)

# Boys x Boys, present x absent father
selected_data %>%
  filter(Gender_binary == 1) %>%
  t.test(Maths_Points_Adjusted ~ father_absent_status_test, data = .)

# Girls x Girls, present x absent father
selected_data %>%
  filter(Gender_binary == 0) %>%
  t.test(Maths_Points_Adjusted ~ father_absent_status_test, data = .)

# Significance tests for Junior Cert
library(dplyr)
library(ggplot2)

# Boys vs Girls
t.test(Maths_points_W3 ~ Gender_binary, data = selected_data)

# Boys x Boys, present x absent father
selected_data %>%
  filter(Gender_binary == 1) %>%
  t.test(Maths_points_W3 ~ father_absent_status_test, data = .)

# Girls x Girls, present x absent father
selected_data %>%
  filter(Gender_binary == 0) %>%
  t.test(Maths_points_W3 ~ father_absent_status_test, data = .)


# Which year are you in: 
# 2 Fifth Year/Pre-Leaving
# 3 Sixth Year/ Leaving Cert
# 4 Sixth Year/ Leaving Cert (Repeat)
dplyr::count(GUI_Chi_3,cq3a2)

# What programme taking at the moment / in your final year in school: 
# 1 Regular (Established) Leaving Certificate
# 2 Leaving Certificate Applied (LCA)
# 3 Leaving Certificate Vocational (LCVP)
# 4 Something else (please specify)
dplyr::count(GUI_Chi_3,cq3b5a)

# Do you plan to / Did you sit the Leaving Certificate examinations
# 1 Yes, plan to sit it
# 2 Yes, have sat it
# 3 Other
dplyr::count(GUI_Chi_3,cq3b5d)

# In what year will / did you sit Leaving Certificate examinations
# 2 2014/15
# 3 2016
# 4 2017/18
dplyr::count(GUI_Chi_3,cq3b5e)


# Remove missing values before plotting
maths_female_lc <- na.omit(selected_data$Maths_Points_Adjusted[selected_data$Gender_binary == 0])
maths_male_lc <- na.omit(selected_data$Maths_Points_Adjusted[selected_data$Gender_binary == 1])

# Create density plots for Maths Leaving Cert scores by gender
plot(density(maths_female_lc), 
     main = "Density Plot of Leaving Cert Maths Scores by Gender", 
     xlab = "Maths LC Points", col = "red", lwd = 2, ylim = c(0, 0.035)) # Adjust ylim as needed
lines(density(maths_male_lc), 
      col = "blue", lwd = 2)
legend("topleft", legend = c("Female", "Male"), fill = c("red", "blue"))

hist()
library(ggplot2)
library(dplyr)

# Ensure you're working with the cleaned dataset
plot_data <- selected_data %>%
  filter(!is.na(Maths_Points_Adjusted), !is.na(Maths_LC_Level))

# Plot density of Maths LC points, colored by level
ggplot(plot_data, aes(x = Maths_Points_Adjusted, fill = Maths_LC_Level)) +
  geom_density(alpha = 0.6) +
  labs(
    title = "Density Plot of Leaving Cert Maths Scores by Level",
    x = "Maths LC Points",
    y = "Density",
    fill = "Maths Level"
  ) +
  theme_minimal() +
  scale_fill_brewer(palette = "Set2")

# Compute means per level
level_means <- plot_data %>%
  group_by(Maths_LC_Level) %>%
  summarise(mean_score = mean(Maths_Points_Adjusted, na.rm = TRUE))

# Plot with vertical lines
ggplot(plot_data, aes(x = Maths_Points_Adjusted, fill = Maths_LC_Level)) +
  geom_density(alpha = 0.6) +
  geom_vline(data = level_means, aes(xintercept = mean_score, color = Maths_LC_Level),
             linetype = "dashed", size = 1, show.legend = FALSE) +
  labs(
    title = "Density Plot of Leaving Cert Maths Scores by Level",
    x = "Maths LC Points",
    y = "Density",
    fill = "Maths Level"
  ) +
  theme_minimal() +
  scale_fill_brewer(palette = "Set2") +
  scale_color_brewer(palette = "Set2")



library(dplyr)
library(ggplot2)

# Filter the data as before
plot_data <- selected_data %>%
  filter(!is.na(Maths_Points_Adjusted),
         Maths_LC_Level %in% c("Foundation", "Ordinary", "Higher"),
         !is.na(Gender_binary)) %>%
  mutate(Gender = ifelse(Gender_binary == 0, "Female", "Male"))

# Calculate mean scores per level *and* gender
means_by_level_gender <- plot_data %>%
  group_by(Gender, Maths_LC_Level) %>%
  summarise(mean_score = mean(Maths_Points_Adjusted, na.rm = TRUE), .groups = "drop")

# Plot
ggplot(plot_data, aes(x = Maths_Points_Adjusted, fill = Maths_LC_Level)) +
  geom_density(alpha = 0.6) +
  facet_wrap(~ Gender) +
  geom_vline(data = means_by_level_gender,
             aes(xintercept = mean_score, color = Maths_LC_Level),
             linetype = "dashed", size = 1, show.legend = FALSE) +
  labs(
    title = "Density Plot of Leaving Cert Maths Scores by Level and Gender",
    x = "Maths LC Points",
    y = "Density",
    fill = "Maths Level"
  ) +
  theme_minimal() +
  scale_fill_brewer(palette = "Set2") +
  scale_color_brewer(palette = "Set2")

# Make sure Gender and Level are factors
selected_data$Gender_binary <- factor(selected_data$Gender_binary, 
                                                 levels = c(0, 1), labels = c("Female", "Male"))
selected_data$Maths_LC_Level <- factor(selected_data$Maths_LC_Level)

# Run two-way ANOVA
anova_model <- aov(Maths_Points_Adjusted ~ Gender_binary * Maths_LC_Level, data = selected_data)

# Output results
summary(anova_model)

# Leaving Cert English Results:

# Using the Leaving Cert:
# Rerunning with LC:
# Model 1
English_W1_nodad_LC <- lm(English_LC_Points ~ Cog_Maths_W1_l + Cog_Reading_W1_l +
                          SDQ_emot_PCG_W1 + SDQ_cond_PCG_W1 +  SDQ_hyper_PCG_W1 + SDQ_peer_PCG_W1 +
                          PCG_Educ_W1_Dummy34 + PCG_Educ_W1_Dummy56 + Income_equi_quint_W1 +
                          Gender_binary + mixed_school_w1 + Father_Educ_Missing_W1, 
                        data = selected_data)
summary(English_W1_nodad_LC)

#Model 2
English_W1_withdad_LC <- lm(English_LC_Points ~ Cog_Maths_W1_l + Cog_Reading_W1_l +
                            SDQ_emot_PCG_W1 + SDQ_cond_PCG_W1 +  SDQ_hyper_PCG_W1 + SDQ_peer_PCG_W1 +
                            PCG_Educ_W1_Dummy34 + PCG_Educ_W1_Dummy56 + SCG_Educ_W1_Dummy34 + SCG_Educ_W1_Dummy56 + 
                            Income_equi_quint_W1 + Gender_binary + mixed_school_w1, 
                          data = selected_data)
summary(English_W1_withdad_LC)


# Model 3

English_W2_nodad_LC <- lm(English_LC_Points ~ Drum_NA_W2_l + Drum_VR_W2_l + BAS_TS_Mat_W2 +
                          SDQ_emot_PCG_W2 + SDQ_cond_PCG_W2 +  SDQ_hyper_PCG_W2 + SDQ_peer_PCG_W2 +
                          PCG_Educ_W2_Dummy34 + PCG_Educ_W2_Dummy56 + Income_equi_quint_W2 +
                          Gender_binary + Fee_paying_W2 + DEIS_W2 + religious_school_w2 + mixed_school_w2 + Father_Educ_Missing_W2, 
                        data = selected_data)
summary(English_W2_nodad_LC)

# Model 4

English_W2_withdad_LC <- lm(English_LC_Points ~ Drum_NA_W2_l + Drum_VR_W2_l + BAS_TS_Mat_W2 +
                            SDQ_emot_PCG_W2 + SDQ_cond_PCG_W2 +  SDQ_hyper_PCG_W2 + SDQ_peer_PCG_W2 +
                            PCG_Educ_W2_Dummy34 + PCG_Educ_W2_Dummy56 + SCG_Educ_W2_Dummy34 + SCG_Educ_W2_Dummy56 + 
                            Income_equi_quint_W2 + Gender_binary + Fee_paying_W2 + DEIS_W2 + religious_school_w2 + mixed_school_w2, 
                          data = selected_data)
summary(English_W2_withdad_LC)


