library(dplyr)
library(ggplot2)
library(haven)

# Create readable labels for Maths Level
level_labels <- c("1" = "Foundation", "2" = "Ordinary", "3" = "Higher")

# ----------------------------------------
# 📊 1. Summary stats: Maths LC Points by Grade System
# ----------------------------------------

summary_stats <- Merged_Child_all_observ %>%
  filter(cq4F10 %in% c(1, 2)) %>%
  mutate(
    Grade_System = haven::as_factor(cq4F10),
    Maths_LC_Points = if_else(cq4F13_PointsMaths %in% c(996, 997, 999), NA_real_, cq4F13_PointsMaths)
  ) %>%
  filter(!is.na(Maths_LC_Points)) %>%
  group_by(Grade_System) %>%
  summarise(
    n = n(),
    Mean = mean(Maths_LC_Points),
    SD = sd(Maths_LC_Points),
    .groups = "drop"
  )

print(summary_stats)

# ----------------------------------------
# 📈 2. t-test: LC Maths Points by Grade System
# ----------------------------------------

cleaned_data <- Merged_Child_all_observ %>%
  filter(cq4F10 %in% c(1, 2)) %>%
  mutate(
    Grade_System = haven::as_factor(cq4F10),
    Maths_LC_Points = if_else(cq4F13_PointsMaths %in% c(996, 997, 999), NA_real_, cq4F13_PointsMaths)
  ) %>%
  filter(!is.na(Maths_LC_Points))

t.test(Maths_LC_Points ~ Grade_System, data = cleaned_data)

# ----------------------------------------
# 📊 3. Group comparison by Maths Level (Higher/Ordinary only)
# ----------------------------------------

cleaned_split <- Merged_Child_all_observ %>%
  filter(cq4F10 %in% c(1, 2), cq4F13c2 %in% c(2, 3)) %>%
  mutate(
    Grade_System = haven::as_factor(cq4F10),
    Maths_LC_Points = if_else(cq4F13_PointsMaths %in% c(996, 997, 999), NA_real_, cq4F13_PointsMaths),
    Maths_Level = recode(as.character(cq4F13c2), !!!level_labels)
  ) %>%
  filter(!is.na(Maths_LC_Points))

# Summary stats by level
cleaned_split %>%
  group_by(Maths_Level, Grade_System) %>%
  summarise(n = n(), Mean = mean(Maths_LC_Points), SD = sd(Maths_LC_Points), .groups = "drop")

# t-tests for each level
t.test(Maths_LC_Points ~ Grade_System, data = filter(cleaned_split, Maths_Level == "Ordinary"))
t.test(Maths_LC_Points ~ Grade_System, data = filter(cleaned_split, Maths_Level == "Higher"))

# Share of levels within each grading system
cleaned_split %>%
  count(Grade_System, Maths_Level) %>%
  group_by(Grade_System) %>%
  mutate(share = round(n / sum(n), 3))

# Foundation level counts
Merged_Child_all_observ %>%
  filter(cq4F10 %in% c(1, 2), cq4F13c2 == 1) %>%
  mutate(Grade_System = haven::as_factor(cq4F10)) %>%
  count(Grade_System)

# ----------------------------------------
# 📊 4. Distribution plot: Raw Maths LC Points
# ----------------------------------------

plot_data_raw <- Merged_Child_all_observ %>%
  filter(cq4F10 %in% c(1, 2), !cq4F13_PointsMaths %in% c(996, 997, 999)) %>%
  mutate(
    Grade_System = haven::as_factor(cq4F10),
    Maths_Points = cq4F13_PointsMaths
  )

ggplot(plot_data_raw, aes(x = Maths_Points, fill = Grade_System, color = Grade_System)) +
  geom_density(alpha = 0.3) +
  labs(
    title = "Distribution of Maths Points by Grading System",
    x = "Maths Points (Raw)",
    y = "Density"
  ) +
  theme_minimal(base_size = 14)

# ----------------------------------------
# 🧽 5. Clean adjusted Maths Points (remove/report bonus)
# ----------------------------------------

cleaned_bonus <- Merged_Child_all_observ %>%
  mutate(
    Maths_Points_Clean = case_when(
      cq4F13_PointsMaths %in% c(115, 120, 125, 105, 110, 113, 102) ~ cq4F13_PointsMaths - 25,
      cq4F13_PointsMaths > 100 & cq4F13c2 %in% c(1, 2) ~ NA_real_,  # Bonus invalid
      cq4F13_PointsMaths <= 100 ~ cq4F13_PointsMaths,
      TRUE ~ NA_real_
    ),
    Grade_System = haven::as_factor(cq4F10)
  ) %>%
  filter(cq4F10 %in% c(1, 2), !is.na(Maths_Points_Clean))

# Summary
cleaned_bonus %>%
  group_by(Grade_System) %>%
  summarise(n = n(), Mean = mean(Maths_Points_Clean), SD = sd(Maths_Points_Clean), .groups = "drop")

# Plot
ggplot(cleaned_bonus, aes(x = Maths_Points_Clean, fill = Grade_System, color = Grade_System)) +
  geom_density(alpha = 0.3) +
  labs(
    title = "Distribution of Cleaned Maths Points by Grading System",
    x = "Maths Points (Adjusted for Bonus)",
    y = "Density"
  ) +
  theme_minimal(base_size = 14)

# t-test on cleaned points
t.test(Maths_Points_Clean ~ Grade_System, data = cleaned_bonus)

# ----------------------------------------
# 📏 6. Optional: z-score within Grade System (standardized comparison)
# ----------------------------------------

standardized_plot <- cleaned_bonus %>%
  group_by(Grade_System) %>%
  mutate(Maths_Points_z = scale(Maths_Points_Clean)) %>%
  ungroup()

# Plot standardized
ggplot(standardized_plot, aes(x = Maths_Points_z, fill = Grade_System, color = Grade_System)) +
  geom_density(alpha = 0.3) +
  labs(
    title = "Standardized Maths Points (z-score within Grading System)",
    x = "Standardized Score (z)",
    y = "Density"
  ) +
  theme_minimal(base_size = 14)

# ----------------------------------------
# 📦 Bonus: Check how many observations have scores >100
# ----------------------------------------

Merged_Child_all_observ %>%
  filter(cq4F13_PointsMaths > 100) %>%
  count(cq4F13_PointsMaths) %>%
  arrange(desc(cq4F13_PointsMaths))

Merged_Child_all_observ %>%
  filter(cq4F13_PointsMaths > 100) %>%
  count(cq4F13c2)  # Level of Maths



# Standardize Maths points within each grading system
standardized_plot <- cleaned_bonus %>%
  group_by(Grade_System) %>%
  mutate(Maths_Points_z = scale(Maths_Points_Clean)) %>%
  ungroup()

# Plot the standardized (z-scored) Maths points
ggplot(standardized_plot, aes(x = Maths_Points_z, fill = Grade_System, color = Grade_System)) +
  geom_density(alpha = 0.3) +
  labs(
    title = "Standardized Maths Points (z-score within Grading System)",
    x = "Standardized Score (z)",
    y = "Density",
    fill = "Grading System",
    color = "Grading System"
  ) +
  theme_minimal(base_size = 14)

# Summarize standardized Maths points by Grade System
standardized_plot %>%
  group_by(Grade_System) %>%
  summarise(
    n = n(),
    Mean = mean(Maths_Points_z, na.rm = TRUE),
    SD = sd(Maths_Points_z, na.rm = TRUE),
    .groups = "drop"
  )

