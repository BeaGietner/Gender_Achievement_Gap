library(ggplot2)
library(dplyr)
library(tidyr)

# Function to extract and clean coefficients
extract_clean_coef <- function(oaxaca_result, subject) {
  data.frame(
    variable = names(oaxaca_result$beta$beta.diff),
    coefficient = as.numeric(oaxaca_result$beta$beta.diff),
    subject = subject
  ) %>%
    filter(!is.na(coefficient) & is.finite(coefficient))
}

# Extract coefficients
english_coef <- extract_clean_coef(Oaxaca_English_total_TIPI, "English")
maths_coef <- extract_clean_coef(Oaxaca_Maths_total_TIPI, "Maths")

# Combine coefficients
combined_coef <- bind_rows(english_coef, maths_coef) %>%
  pivot_wider(names_from = subject, values_from = coefficient) %>%
  mutate(across(c(English, Maths), ~ifelse(is.na(.), 0, .))) %>%
  mutate(total_abs = abs(English) + abs(Maths))

library(ggplot2)
library(dplyr)
library(tidyr)

# ... [Previous code for data preparation remains the same] ...

# Create the plot
p <- ggplot(combined_coef, aes(x = reorder(variable, total_abs))) +
  geom_col(aes(y = English, fill = "English"), position = "identity", alpha = 0.7, color = "orange", linewidth = 0.5) +
  geom_col(aes(y = Maths, fill = "Maths"), position = "identity", alpha = 0.7, color = "red", linewidth = 0.5, linetype = "dashed") +
  geom_text(aes(y = English, 
                label = sprintf("%.2f", English), 
                hjust = ifelse(English > 0, -0.1, 1.1),
                vjust = ifelse(abs(English) < 1, ifelse(English > 0, -0.5, 1.5), 0.5)),
            position = position_dodge(width = 0.5),
            size = 3, color = "orange") +
  geom_text(aes(y = Maths, 
                label = sprintf("%.2f", Maths), 
                hjust = ifelse(Maths > 0, -0.1, 1.1),
                vjust = ifelse(abs(Maths) < 1, ifelse(Maths > 0, 1.5, -0.5), 0.5)),
            position = position_dodge(width = 0.5),
            size = 3, color = "red") +
  geom_hline(yintercept = 0, linetype = "solid", color = "black") +
  coord_flip() +
  scale_fill_manual(values = c("English" = "yellow", "Maths" = "pink"),
                    name = "Subject",
                    labels = c("English (solid outline)", "Maths (dashed outline)")) +
  scale_y_continuous(
    limits = function(x) c(min(x) * 1.2, max(x) * 1.2),  # Increased limits for label space
    breaks = function(x) pretty(x, n = 10)
  ) +
  theme_minimal() +
  labs(title = "Contribution to Gender Gap in Junior Cert English and Maths Points",
       subtitle = "Coefficients (Male - Female)",
       caption = "Non-cognitive measures include TIPI, Locus of Control, Self-Esteem, and Self-Control scales.\nPositive values indicate male advantage, negative values indicate female advantage.",
       x = "Variables", 
       y = "Coefficient") +
  theme(axis.text.y = element_text(size = 8),
        legend.position = "bottom",
        legend.title = element_text(size = 10),
        legend.text = element_text(size = 8),
        panel.grid.major.y = element_line(color = "gray90"),
        panel.grid.minor.y = element_blank())

print(p)
ggsave("combined_oaxaca_coefficient_plot_user_colors.png", plot = p, width = 14, height = 14)


library(ggplot2)
library(dplyr)
library(tidyr)

# Function to extract and clean coefficients
extract_clean_coef <- function(oaxaca_result, subject) {
  data.frame(
    variable = names(oaxaca_result$beta$beta.diff),
    coefficient = as.numeric(oaxaca_result$beta$beta.diff),
    subject = subject
  ) %>%
    filter(!is.na(coefficient) & is.finite(coefficient))
}

# Extract coefficients
english_coef <- extract_clean_coef(Oaxaca_English_total_TIPI, "English")
maths_coef <- extract_clean_coef(Oaxaca_Maths_total_TIPI, "Maths")

# Combine coefficients
combined_coef <- bind_rows(english_coef, maths_coef) %>%
  pivot_wider(names_from = subject, values_from = coefficient) %>%
  mutate(across(c(English, Maths), ~ifelse(is.na(.), 0, .))) %>%
  mutate(total_abs = abs(English) + abs(Maths))

# Create the plot
p <- ggplot(combined_coef, aes(y = reorder(variable, total_abs))) +
  geom_vline(xintercept = 0, color = "black", linetype = "solid") +
  geom_segment(aes(x = 0, xend = English, yend = variable), color = "orange") +
  geom_segment(aes(x = 0, xend = Maths, yend = variable), color = "red") +
  geom_point(aes(x = English), color = "orange", size = 3) +
  geom_point(aes(x = Maths), color = "red", size = 3) +
  geom_text(aes(x = English, label = sprintf("%.2f", English)), 
            color = "orange", vjust = -0.5, hjust = ifelse(combined_coef$English > 0, -0.2, 1.2)) +
  geom_text(aes(x = Maths, label = sprintf("%.2f", Maths)), 
            color = "red", vjust = 1.5, hjust = ifelse(combined_coef$Maths > 0, -0.2, 1.2)) +
  scale_x_continuous(
    limits = function(x) c(min(x) * 1.2, max(x) * 1.2),
    breaks = function(x) pretty(x, n = 10)
  ) +
  theme_minimal() +
  labs(title = "Contribution to Gender Gap in Junior Cert English and Maths Points",
       subtitle = "Coefficients (Male - Female)",
       caption = "Non-cognitive measures include TIPI, Locus of Control, Self-Esteem, and Self-Control scales.\nPositive values indicate male advantage, negative values indicate female advantage.",
       y = "Variables", 
       x = "Coefficient") +
  theme(axis.text.y = element_text(size = 8),
        legend.position = "bottom",
        legend.title = element_text(size = 10),
        legend.text = element_text(size = 8),
        panel.grid.major.x = element_line(color = "gray90"),
        panel.grid.minor.x = element_blank()) +
  annotate("text", x = max(combined_coef$English, combined_coef$Maths, na.rm = TRUE) * 1.1, 
           y = nrow(combined_coef) + 0.5, label = "English", color = "orange", hjust = 1) +
  annotate("text", x = max(combined_coef$English, combined_coef$Maths, na.rm = TRUE) * 1.1, 
           y = nrow(combined_coef), label = "Maths", color = "red", hjust = 1)

print(p)
ggsave("combined_oaxaca_coefficient_plot_inverted.png", plot = p, width = 14, height = 14)



























# Data from wave 3
# Load necessary libraries
library(dplyr)
library(ggplot2)

# Step 1: Clean the data by excluding non-respondents
cleaned_data <- Merged_Child %>%
  filter(cq3j6i1 %in% c(1, 2) & !is.na(p2sexW3))  # Keep only 'Yes' (1) and 'No' (2) responses and valid genders

# Step 2: Count reading behavior by gender
reading_by_gender <- cleaned_data %>%
  group_by(p2sexW3, cq3j6i1) %>%
  tally() %>%
  spread(cq3j6i1, n, fill = 0)  # Pivot to wide format

# Print reading by gender table
print(reading_by_gender)

# Step 3: Calculate total counts and proportions of those who read for pleasure
proportions_by_gender <- cleaned_data %>%
  group_by(p2sexW3) %>%
  summarise(
    total_count = n(),
    read_yes_count = sum(cq3j6i1 == 1),  # Count of 'Yes' (1)
    read_no_count = sum(cq3j6i1 == 2),   # Count of 'No' (2)
    read_proportion = read_yes_count / total_count  # Proportion of 'Yes'
  )

# Print proportions by gender table
print(proportions_by_gender)

# Step 4: Create a bar plot of reading proportions by gender
ggplot(proportions_by_gender, aes(x = as.factor(p2sexW3), y = read_proportion, fill = as.factor(p2sexW3))) +
  geom_bar(stat = "identity") +
  labs(x = "Gender", y = "Regularly doing for fun or to relax - Playing sport (with others)", fill = "Gender") +
  scale_x_discrete(labels = c("1" = "Male", "2" = "Female")) +
  scale_y_continuous(labels = scales::percent) +  # Show proportions as percentages
  theme_minimal()


# Load necessary libraries
library(dplyr)
library(ggplot2)

# Step 1: Clean the data by excluding non-respondents
cleaned_data <- Merged_Child %>%
  filter(cq3j6a1 %in% c(1, 2) & !is.na(p2sexW3))  # Keep only 'Yes' (1) and 'No' (2) responses and valid genders

# Step 2: Count reading behavior by gender
reading_by_gender <- cleaned_data %>%
  group_by(p2sexW3, cq3j6a1) %>%
  tally() %>%
  spread(cq3j6a1, n, fill = 0)  # Pivot to wide format

# Print reading by gender table
print(reading_by_gender)

# Step 3: Calculate total counts and proportions of those who read for pleasure
proportions_by_gender <- cleaned_data %>%
  group_by(p2sexW3) %>%
  summarise(
    total_count = n(),
    read_yes_count = sum(cq3j6a1 == 1),  # Count of 'Yes' (1)
    read_no_count = sum(cq3j6a1 == 2),   # Count of 'No' (2)
    read_proportion = read_yes_count / total_count  # Proportion of 'Yes'
  )

# Print proportions by gender table
print(proportions_by_gender)

# Step 4: Create a bar plot of reading proportions by gender
ggplot(proportions_by_gender, aes(x = as.factor(p2sexW3), y = read_proportion, fill = as.factor(p2sexW3))) +
  geom_bar(stat = "identity") +
  labs(x = "Gender", y = "Regularly doing for fun or to relax - Reading for pleasure", fill = "Gender") +
  scale_x_discrete(labels = c("1" = "Male", "2" = "Female")) +
  scale_y_continuous(labels = scales::percent) +  # Show proportions as percentages
  theme_minimal()



# Load necessary libraries
library(dplyr)
library(ggplot2)

# Step 1: Clean the data by excluding non-respondents
cleaned_data <- Merged_Child %>%
  filter(cq3j6j1 %in% c(1, 2) & !is.na(p2sexW3))  # Keep only 'Yes' (1) and 'No' (2) responses and valid genders

# Step 2: Count reading behavior by gender
reading_by_gender <- cleaned_data %>%
  group_by(p2sexW3, cq3j6j1) %>%
  tally() %>%
  spread(cq3j6j1, n, fill = 0)  # Pivot to wide format

# Print reading by gender table
print(reading_by_gender)

# Step 3: Calculate total counts and proportions of those who read for pleasure
proportions_by_gender <- cleaned_data %>%
  group_by(p2sexW3) %>%
  summarise(
    total_count = n(),
    read_yes_count = sum(cq3j6j1 == 1),  # Count of 'Yes' (1)
    read_no_count = sum(cq3j6j1 == 2),   # Count of 'No' (2)
    read_proportion = read_yes_count / total_count  # Proportion of 'Yes'
  )

# Print proportions by gender table
print(proportions_by_gender)

# Step 4: Create a bar plot of reading proportions by gender
ggplot(proportions_by_gender, aes(x = as.factor(p2sexW3), y = read_proportion, fill = as.factor(p2sexW3))) +
  geom_bar(stat = "identity") +
  labs(x = "Gender", y = "Regularly doing for fun or to relax - Playing individual sport", fill = "Gender") +
  scale_x_discrete(labels = c("1" = "Male", "2" = "Female")) +
  scale_y_continuous(labels = scales::percent) +  # Show proportions as percentages
  theme_minimal()