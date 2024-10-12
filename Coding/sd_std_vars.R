variables_to_standardize <- c(
  "TIPI_Extra_PCG_W2",
  "TIPI_Agreeable_PCG_W2",
  "TIPI_Cons_PCG_W2",
  "TIPI_EmoStab_PCG_W2",
  "TIPI_Open_PCG_W2",
  "SDQ_EmoRes_PCG_W2",
  "SDQ_Good_Conduct_PCG_W2",
  "SDQ_Focus_Behav_PCG_W2",
  "SDQ_Posi_Peer_PCG_W2"
)

for (var in variables_to_standardize) {
  new_var_name <- paste0(var, "_std")
  Dataset_Test[[new_var_name]] <- scale(Dataset_Test[[var]])
}

library(psych)

# Create a vector of the new standardized variable names
std_vars <- paste0(variables_to_standardize, "_std")

# Get descriptive statistics
desc_stats <- describe(Dataset_Test[std_vars])

# Print the results
print(desc_stats)

# Function to calculate percentage
calc_percentage <- function(min, max) {
  range <- max - min
  percentage <- (1 / range) * 100
  return(round(percentage, 2))
}

# Dataframe with min and max values
vars_data <- data.frame(
  variable = c("TIPI_Extra_PCG_W2_std", "TIPI_Agreeable_PCG_W2_std", "TIPI_Cons_PCG_W2_std", 
               "TIPI_EmoStab_PCG_W2_std", "TIPI_Open_PCG_W2_std", "SDQ_EmoRes_PCG_W2_std", 
               "SDQ_Good_Conduct_PCG_W2_std", "SDQ_Focus_Behav_PCG_W2_std", "SDQ_Posi_Peer_PCG_W2_std"),
  min = c(-1.75, -2.30, -1.87, -1.94, -2.30, -4.41, -6.89, -3.34, -6.23),
  max = c(1.53, 1.02, 1.28, 1.33, 1.25, 0.92, 0.78, 1.07, 0.74)
)

# Calculate percentages
vars_data$percentage <- mapply(calc_percentage, vars_data$min, vars_data$max)

# Print results
print(vars_data)