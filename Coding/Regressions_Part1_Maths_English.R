# Running regressions

# Wave 1
# Baseline (Model 1) + Father included (Model 2)

table(is.na(selected_data$SCG_Educ_W1_Dummy34))
table(is.na(selected_data$SCG_Educ_W1_Dummy56))
selected_data$Father_Educ_Available_W1 <- ifelse(is.na(selected_data$SCG_Educ_W1_Dummy34) & is.na(selected_data$SCG_Educ_W1_Dummy56), 0, 1)
table(selected_data$Father_Educ_Available_W1)
aggregate(Maths_points_W3 ~ Father_Educ_Available_W1, data = selected_data, FUN = mean)
aggregate(Maths_points_W3 ~ Father_Educ_Available_W1, data = selected_data, FUN = sd)
t.test(Maths_points_W3 ~ Father_Educ_Available_W1, data = selected_data, var.equal = TRUE)
maths <- lm(Maths_points_W3 ~ Father_Educ_Available_W1, data = selected_data)
summary(maths)

maths_income <- lm(Maths_points_W3 ~ Father_Educ_Available_W1 + Income_equi_quint_W1, data = selected_data)
summary(maths_income)
maths_mother <- lm(Maths_points_W3 ~ Father_Educ_Available_W1 + PCG_Educ_W1_Dummy34 + PCG_Educ_W1_Dummy56, data = selected_data)
summary(maths_mother)


selected_data$Father_Educ_Missing_W1 <- ifelse(is.na(selected_data$SCG_Educ_W1_Dummy34) & is.na(selected_data$SCG_Educ_W1_Dummy56), 1, 0)

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



# Wave 2
# Baseline (Model 3) + Father included (Model 4)

table(is.na(selected_data$SCG_Educ_W2_Dummy34))
table(is.na(selected_data$SCG_Educ_W2_Dummy56))
selected_data$Father_Educ_Available_W2 <- ifelse(is.na(selected_data$SCG_Educ_W2_Dummy34) & is.na(selected_data$SCG_Educ_W2_Dummy56), 0, 1)
table(selected_data$Father_Educ_Available_W2)
aggregate(Maths_points_W3 ~ Father_Educ_Available_W2, data = selected_data, FUN = mean)
aggregate(Maths_points_W3 ~ Father_Educ_Available_W2, data = selected_data, FUN = sd)
t.test(Maths_points_W3 ~ Father_Educ_Available_W2, data = selected_data, var.equal = TRUE)
maths <- lm(Maths_points_W3 ~ Father_Educ_Available_W2, data = selected_data)
summary(maths)

maths_income <- lm(Maths_points_W3 ~ Father_Educ_Available_W2 + Income_equi_quint_W2, data = selected_data)
summary(maths_income)
maths_mother <- lm(Maths_points_W3 ~ Father_Educ_Available_W2 + PCG_Educ_W2_Dummy34 + PCG_Educ_W2_Dummy56, data = selected_data)
summary(maths_mother)


selected_data$Father_Educ_Missing_W2 <- ifelse(is.na(selected_data$SCG_Educ_W2_Dummy34) & is.na(selected_data$SCG_Educ_W2_Dummy56), 1, 0)

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



# Look at patterns for the NA cases
na_cases <- selected_data %>%
  filter(is.na(father_absent_status)) %>%
  select(Father_Educ_Missing_W1, Father_Educ_Missing_W2) %>%
  count(Father_Educ_Missing_W1, Father_Educ_Missing_W2)

print(na_cases)

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
dplyr::count(selected_data,father_absent_status_test)


# Remove missing values before plotting
maths_female <- na.omit(selected_data$Maths_points_W3[selected_data$Gender_binary == 0])
maths_male <- na.omit(selected_data$Maths_points_W3[selected_data$Gender_binary == 1])

# Create density plots for Maths scores by gender
plot(density(maths_female), 
     main = "Density Plot of Maths Scores by Gender", 
     xlab = "Maths Points", col = "red", lwd = 2, ylim = c(0, 0.35)) # Adjust ylim to expand y-axis
lines(density(maths_male), 
      col = "blue", lwd = 2)
legend("topleft", legend = c("Female", "Male"), fill = c("red", "blue"))


# ENGLISH RESULTS

# Running regressions

# Wave 1
# Baseline (Model 1) + Father included (Model 2)

table(is.na(selected_data$SCG_Educ_W1_Dummy34))
table(is.na(selected_data$SCG_Educ_W1_Dummy56))
selected_data$Father_Educ_Available_W1 <- ifelse(is.na(selected_data$SCG_Educ_W1_Dummy34) & is.na(selected_data$SCG_Educ_W1_Dummy56), 0, 1)
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


selected_data$Father_Educ_Missing_W1 <- ifelse(is.na(selected_data$SCG_Educ_W1_Dummy34) & is.na(selected_data$SCG_Educ_W1_Dummy56), 1, 0)

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
selected_data$Father_Educ_Available_W2 <- ifelse(is.na(selected_data$SCG_Educ_W2_Dummy34) & is.na(selected_data$SCG_Educ_W2_Dummy56), 0, 1)
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
  filter(is.na(father_absent_status)) %>%
  select(Father_Educ_Missing_W1, Father_Educ_Missing_W2) %>%
  count(Father_Educ_Missing_W1, Father_Educ_Missing_W2)

print(na_cases)

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
dplyr::count(selected_data,father_absent_status_test)


# Remove missing values before plotting
english_female <- na.omit(selected_data$English_points_W3[selected_data$Gender_binary == 0])
english_male <- na.omit(selected_data$English_points_W3[selected_data$Gender_binary == 1])

# Create density plots for English scores by gender
plot(density(english_female), 
     main = "Density Plot of English Scores by Gender", 
     xlab = "English Points", col = "red", lwd = 2, ylim = c(0, 1)) # Adjust ylim to expand y-axis
lines(density(english_male), 
      col = "blue", lwd = 2)
legend("topleft", legend = c("Female", "Male"), fill = c("red", "blue"))
