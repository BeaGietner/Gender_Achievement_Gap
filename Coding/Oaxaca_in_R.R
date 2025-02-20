# First create binary gender variable (1 for Male, 0 for Female)
production_data <- production_data %>%
  mutate(gender_binary = case_when(
    Gender_factor == "Male" ~ 1,
    Gender_factor == "Female" ~ 0,
    TRUE ~ NA_real_
  ))

# Now run the Oaxaca-Blinder decomposition
Oaxaca_Maths_TIPI <- oaxaca(
  Maths_points ~ 
    Drum_VR_W2_p + Drum_NA_W2_p + BAS_TS_Mat_W2 +                            # Cognitive
    Agreeable_W2_PCG + Emo_Stability_W2_PCG + Conscientious_W2_PCG + 
    Extravert_W2_PCG + Openness_W2_PCG +                                      # TIPI (Non-cognitive)
    PCG_Educ_W2 + SCG_Educ_W2 + Income_equi + 
    DEIS_binary_W2 + Fee_paying_W2 + Mixed |                                  # Socioeconomic & School
    gender_binary,
  data = na.omit(production_data[, c("Maths_points", 
                                     "Drum_VR_W2_p", "Drum_NA_W2_p", "BAS_TS_Mat_W2",
                                     "Agreeable_W2_PCG", "Emo_Stability_W2_PCG", "Conscientious_W2_PCG", 
                                     "Extravert_W2_PCG", "Openness_W2_PCG",
                                     "PCG_Educ_W2", "SCG_Educ_W2", "Income_equi",
                                     "DEIS_binary_W2", "Fee_paying_W2", "Mixed",
                                     "gender_binary")]),
  R = 100  # Number of bootstrap replications
)

print(Oaxaca_Maths_TIPI)


library(oaxaca)
library(dplyr)

# First create binary gender variable (1 for Male, 0 for Female)
ml_data_complete <- ml_data_complete %>%
  mutate(gender_binary = case_when(
    Gender_factor == "Male" ~ 1,
    Gender_factor == "Female" ~ 0,
    TRUE ~ NA_real_
  ))

# Run Oaxaca-Blinder decomposition with SDQ variables
Oaxaca_Maths_SDQ <- oaxaca(
  Maths_points ~ 
    Drum_VR_W2_p + Drum_NA_W2_p + BAS_TS_Mat_W2 +                            # Cognitive
    SDQ_emot_PCG_W2 + SDQ_cond_PCG_W2 + SDQ_hyper_PCG_W2 + SDQ_peer_PCG_W2 + # SDQ (Non-cognitive)
    PCG_Educ_W2 + SCG_Educ_W2 + Income_equi + 
    DEIS_binary_W2 + Fee_paying_W2 + Mixed |                                  # Socioeconomic & School
    gender_binary,
  data = na.omit(ml_data_complete[, c("Maths_points", 
                                      "Drum_VR_W2_p", "Drum_NA_W2_p", "BAS_TS_Mat_W2",
                                      "SDQ_emot_PCG_W2", "SDQ_cond_PCG_W2", "SDQ_hyper_PCG_W2", "SDQ_peer_PCG_W2",
                                      "PCG_Educ_W2", "SCG_Educ_W2", "Income_equi",
                                      "DEIS_binary_W2", "Fee_paying_W2", "Mixed",
                                      "gender_binary")]),
  R = 100  # Number of bootstrap replications
)

print(Oaxaca_Maths_SDQ)


# Check mean hyperactivity scores by gender
ml_data_complete %>%
  group_by(Gender_factor) %>%
  summarise(
    mean_hyperactivity = mean(SDQ_hyper_PCG_W2, na.rm = TRUE),
    sd_hyperactivity = sd(SDQ_hyper_PCG_W2, na.rm = TRUE),
    n = n()
  )



# Function to add significance stars
add_significance <- function(coef, se) {
  z_score <- abs(coef/se)
  stars <- case_when(
    z_score > 2.576 ~ "***",  # p < 0.01
    z_score > 1.96 ~ "**",    # p < 0.05
    z_score > 1.645 ~ "*",    # p < 0.10
    TRUE ~ ""
  )
  return(stars)
}

# Create a results dataframe with significance for the threefold decomposition
results_df <- data.frame(
  component = c("Endowments", "Coefficients", "Interaction"),
  estimate = c(Oaxaca_Maths_SDQ$threefold$overall["coef(endowments)"],
               Oaxaca_Maths_SDQ$threefold$overall["coef(coefficients)"],
               Oaxaca_Maths_SDQ$threefold$overall["coef(interaction)"]),
  std.error = c(Oaxaca_Maths_SDQ$threefold$overall["se(endowments)"],
                Oaxaca_Maths_SDQ$threefold$overall["se(coefficients)"],
                Oaxaca_Maths_SDQ$threefold$overall["se(interaction)"])
)

results_df$significance <- mapply(add_significance, 
                                  results_df$estimate, 
                                  results_df$std.error)

print(results_df)