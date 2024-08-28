Oaxaca_Maths_total_TIPI <- oaxaca(
  LC_Maths_Points ~ 
    Cog_Naming_Total_W3 + Cog_Maths_Total_W3 + Cog_Vocabulary_W3 +
    TIPI_Extra_YP_W3 + TIPI_Agreeable_YP_W3 + TIPI_Cons_YP_W3 + TIPI_EmoStab_YP_W3 + TIPI_Open_YP_W3 +
    Self_Esteem_YP_W3 + Locus_Control_YP_W3 + Self_Control_YP_W3 +
    PCG_Educ_W3 + SCG_Educ_W3 + Income_Quin_Eq_W3 + DEIS_W3 + Fee_Paying_W3 + Mixed_W3 | 
    Gender_YP_W3,
  data = na.omit(Oaxaca_Blinder),
  R = 100)

library(ggplot2)
library(dplyr)

# Extract coefficients
coef_df <- data.frame(
  variable = names(Oaxaca_Maths_total_TIPI$beta$beta.diff),
  coefficient = as.numeric(Oaxaca_Maths_total_TIPI$beta$beta.diff)
)

# Clean the data
coef_df_clean <- coef_df %>%
  filter(!is.na(coefficient) & is.finite(coefficient)) %>%
  arrange(desc(abs(coefficient)))

# Print the structure of the cleaned dataframe
print(str(coef_df_clean))


p <- ggplot(coef_df_clean, 
            aes(x = reorder(variable, abs(coefficient)), y = coefficient)) +
  geom_col(aes(fill = coefficient > 0)) +
  geom_text(aes(label = sprintf("%.2f", coefficient), 
                hjust = ifelse(coefficient > 0, -0.1, 1.1)),
            size = 3) +
  geom_hline(yintercept = 0, linetype = "dashed", color = "red") +
  coord_flip() +
  scale_fill_manual(values = c("TRUE" = "skyblue", "FALSE" = "lightcoral")) +
  theme_minimal() +
  labs(title = "Contribution to Gender Gap in Junior Cert Maths Points",
       subtitle = "Coefficients (Male - Female)",
       caption = "Non-cognitive measures include TIPI, Locus of Control, Self-Esteem, and Self-Control scales",
       x = "Variables", 
       y = "Coefficient") +
  theme(axis.text.y = element_text(size = 8),
        legend.position = "none")

print(p)
ggsave("oaxaca_coefficient_plot_updated_tipi.png", plot = p, width = 12, height = 10)