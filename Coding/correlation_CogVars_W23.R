# Load required libraries
library(dplyr)
library(ggplot2)
library(reshape2)

# Assuming your dataset is called 'complete_info_dataset'
# Select the cognitive variables
cog_vars <- c("Cog_VR_W2", "Cog_NA_W2", "Cog_Matrices_W2",
              "Cog_Naming_Total_W3", "Cog_Maths_Total_W3", "Cog_Vocabulary_W3")

# Calculate correlation matrix
cor_matrix <- cor(complete_info_dataset[cog_vars], use = "pairwise.complete.obs")

# Print the correlation matrix
print(cor_matrix)

# Create a function to get the lower triangle of the correlation matrix
get_lower_tri <- function(cormat){
  cormat[upper.tri(cormat)] <- NA
  return(cormat)
}

# Get lower triangle of the correlation matrix
lower_tri <- get_lower_tri(cor_matrix)

# Melt the correlation matrix
melted_cormat <- melt(lower_tri, na.rm = TRUE)

# Create a nicer looking correlation plot
ggplot(data = melted_cormat, aes(Var2, Var1, fill = value)) +
  geom_tile(color = "white") +
  scale_fill_gradient2(low = "blue", high = "red", mid = "white", 
                       midpoint = 0, limit = c(-1,1), space = "Lab", 
                       name="Pearson\nCorrelation") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, vjust = 1, hjust = 1)) +
  coord_fixed() +
  geom_text(aes(Var2, Var1, label = round(value, 2)), color = "black", size = 4) +
  labs(title = "Correlation Matrix of Cognitive Variables",
       x = "", y = "")

# Print descriptive statistics
summary_stats <- complete_info_dataset %>%
  select(all_of(cog_vars)) %>%
  summary()

print(summary_stats)