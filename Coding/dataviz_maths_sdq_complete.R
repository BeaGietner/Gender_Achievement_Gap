# Plotting CDFs of Maths Percentiles
library(ggplot2)

# Calculate percentiles
complete_info_dataset_SDQ_Maths$JC_Maths_Percentile <- rank(complete_info_dataset_SDQ_Maths$JC_Maths_Points) / length(complete_info_dataset_SDQ_Maths$JC_Maths_Points)
complete_info_dataset_SDQ_Maths$LC_Maths_Percentile <- rank(complete_info_dataset_SDQ_Maths$LC_Maths_Points) / length(complete_info_dataset_SDQ_Maths$LC_Maths_Points)

ggplot(complete_info_dataset_SDQ_Maths, aes(x = JC_Maths_Percentile, color = factor(Gender_YP_W2))) + 
  stat_ecdf(size = 1) +
  labs(x = "Junior Cert Maths Percentile", y = "Cumulative Proportion", color = "Gender",
       title = "CDF of Junior Cert Maths Percentiles by Gender") +
  theme_minimal()

ggplot(complete_info_dataset_SDQ_Maths, aes(x = LC_Maths_Percentile, color = factor(Gender_YP_W3))) + 
  stat_ecdf(size = 1) +
  labs(x = "Leaving Cert Maths Percentile", y = "Cumulative Proportion", color = "Gender",
       title = "CDF of Leaving Cert Maths Percentiles by Gender") +
  theme_minimal()

# Creating a Sankey Diagram using networkD3

library(networkD3)
library(dplyr)

sankey_df <- complete_info_dataset_SDQ_Maths %>%
  count(JC_Maths_Points, LC_Maths_Points, Gender_YP_W2) %>%
  mutate(JC_Maths_Points = paste("JC", JC_Maths_Points),
         LC_Maths_Points = paste("LC", LC_Maths_Points))

nodes <- data.frame(
  name = unique(c(as.character(sankey_df$JC_Maths_Points), 
                  as.character(sankey_df$LC_Maths_Points)))
)

sankey_df$IDsource <- match(sankey_df$JC_Maths_Points, nodes$name) - 1
sankey_df$IDtarget <- match(sankey_df$LC_Maths_Points, nodes$name) - 1

links <- sankey_df %>%
  select(IDsource, IDtarget, value = n)

my_color <- 'd3.scaleOrdinal() .domain(["0", "1"]) .range(["#FFC0CB", "#ADD8E6"])'

sankeyNetwork(Links = links, Nodes = nodes, Source = "IDsource", Target = "IDtarget",
              Value = "value", NodeID = "name", sinksRight = FALSE, colourScale = my_color, 
              nodeWidth = 40, fontSize = 13, nodePadding = 20)