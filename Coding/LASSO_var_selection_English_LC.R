library(glmnet)
library(dplyr)

# Function to perform Lasso regression and return selected variables
lasso_select <- function(X, y, lambda = "lambda.min") {
  # Remove rows with any NAs
  complete_cases <- complete.cases(X, y)
  X <- X[complete_cases, ]
  y <- y[complete_cases]
  
  # Only proceed if we have enough data
  if(nrow(X) > ncol(X)) {
    model <- cv.glmnet(as.matrix(X), y, alpha = 1)
    coef <- coef(model, s = model[[lambda]])
    selected <- rownames(coef)[which(coef != 0)]
    selected <- selected[selected != "(Intercept)"]
    return(selected)
  } else {
    warning("Not enough complete cases for this wave")
    return(character(0))
  }
}

# Function to get variables for a specific wave
get_wave_vars <- function(data, wave) {
  vars <- names(data)[grep(paste0("_W", wave, "$"), names(data))]
  return(vars)
}

# Assuming 'Dataset_Test' is your dataset and 'LC_English_Points' is your outcome
y <- Dataset_Test$LC_English_Points

# List to store results
results <- list()

# Loop through waves
for (wave in 1:4) {
  wave_vars <- get_wave_vars(Dataset_Test, wave)
  
  # Skip if no variables found for this wave
  if (length(wave_vars) == 0) next
  
  X <- Dataset_Test[, wave_vars]
  
  # Perform Lasso selection
  selected_vars <- lasso_select(X, y)
  
  # Store results
  results[[paste0("Wave_", wave)]] <- selected_vars
  
  cat("Selected variables for Wave", wave, ":\n")
  print(selected_vars)
  cat("\n")
}

# Combine all selected variables
all_selected_vars <- unique(unlist(results))

# Final model with all selected variables
final_X <- Dataset_Test[, all_selected_vars]
complete_cases <- complete.cases(final_X, y)
final_X <- as.matrix(final_X[complete_cases, ])
final_y <- y[complete_cases]

if(nrow(final_X) > ncol(final_X)) {
  final_model <- cv.glmnet(final_X, final_y, alpha = 1)
  print(coef(final_model, s = "lambda.min"))
} else {
  cat("Not enough complete cases for final model\n")
}
