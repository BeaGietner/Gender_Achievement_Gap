# Plotting CDFs of English Percentiles
library(ggplot2)

# Calculate percentiles
complete_info_dataset_SDQ_English$JC_English_Percentile <- rank(complete_info_dataset_SDQ_English$JC_English_Points) / length(complete_info_dataset_SDQ_English$JC_English_Points)
complete_info_dataset_SDQ_English$LC_English_Percentile <- rank(complete_info_dataset_SDQ_English$LC_English_Points) / length(complete_info_dataset_SDQ_English$LC_English_Points)

ggplot(complete_info_dataset_SDQ_English, aes(x = JC_English_Percentile, color = factor(Gender_YP_W2))) + 
  stat_ecdf(size = 1) +
  labs(x = "Junior Cert English Percentile", y = "Cumulative Proportion", color = "Gender",
       title = "CDF of Junior Cert English Percentiles by Gender") +
  theme_minimal()

ggplot(complete_info_dataset_SDQ_English, aes(x = LC_English_Percentile, color = factor(Gender_YP_W3))) + 
  stat_ecdf(size = 1) +
  labs(x = "Leaving Cert English Percentile", y = "Cumulative Proportion", color = "Gender",
       title = "CDF of Leaving Cert English Percentiles by Gender") +
  theme_minimal()

# Creating a Sankey Diagram using networkD3

library(networkD3)
library(dplyr)

sankey_df <- complete_info_dataset_SDQ_English %>%
  count(JC_English_Points, LC_English_Points, Gender_YP_W2) %>%
  mutate(JC_English_Points = paste("JC", JC_English_Points),
         LC_English_Points = paste("LC", LC_English_Points))

nodes <- data.frame(
  name = unique(c(as.character(sankey_df$JC_English_Points), 
                  as.character(sankey_df$LC_English_Points)))
)

sankey_df$IDsource <- match(sankey_df$JC_English_Points, nodes$name) - 1
sankey_df$IDtarget <- match(sankey_df$LC_English_Points, nodes$name) - 1

links <- sankey_df %>%
  select(IDsource, IDtarget, value = n)

my_color <- 'd3.scaleOrdinal() .domain(["0", "1"]) .range(["#FFC0CB", "#ADD8E6"])'

sankeyNetwork(Links = links, Nodes = nodes, Source = "IDsource", Target = "IDtarget",
              Value = "value", NodeID = "name", sinksRight = FALSE, colourScale = my_color, 
              nodeWidth = 40, fontSize = 13, nodePadding = 20)


# Subsetting by DEIS_W2 status

library(networkD3)
library(dplyr)

# Filter the data for DEIS_W2 = 0
sankey_df_0 <- complete_info_dataset_SDQ_English %>%
  filter(DEIS_W2 == 0) %>%
  count(JC_English_Points, LC_English_Points, Gender_YP_W2) %>%
  mutate(JC_English_Points = paste("JC", JC_English_Points),
         LC_English_Points = paste("LC", LC_English_Points))

nodes_0 <- data.frame(
  name = unique(c(as.character(sankey_df_0$JC_English_Points), 
                  as.character(sankey_df_0$LC_English_Points)))
)

sankey_df_0$IDsource <- match(sankey_df_0$JC_English_Points, nodes_0$name) - 1
sankey_df_0$IDtarget <- match(sankey_df_0$LC_English_Points, nodes_0$name) - 1

links_0 <- sankey_df_0 %>%
  select(IDsource, IDtarget, value = n)

sankeyNetwork(Links = links_0, Nodes = nodes_0, Source = "IDsource", Target = "IDtarget",
              Value = "value", NodeID = "name", sinksRight = FALSE, colourScale = my_color, 
              nodeWidth = 40, fontSize = 13, nodePadding = 20)

# Plot side by side by DEIS_W2 status

library(networkD3)
library(dplyr)
library(htmltools)

# Filter the data for DEIS_W2 = 0
sankey_df_0 <- complete_info_dataset_SDQ_English %>%
  filter(DEIS_W2 == 0) %>%
  count(JC_English_Points, LC_English_Points, Gender_YP_W2) %>%
  mutate(JC_English_Points = paste("JC", JC_English_Points),
         LC_English_Points = paste("LC", LC_English_Points))

nodes_0 <- data.frame(
  name = unique(c(as.character(sankey_df_0$JC_English_Points), 
                  as.character(sankey_df_0$LC_English_Points)))
)

sankey_df_0$IDsource <- match(sankey_df_0$JC_English_Points, nodes_0$name) - 1
sankey_df_0$IDtarget <- match(sankey_df_0$LC_English_Points, nodes_0$name) - 1

links_0 <- sankey_df_0 %>%
  select(IDsource, IDtarget, value = n)

sankey_0 <- sankeyNetwork(Links = links_0, Nodes = nodes_0, Source = "IDsource", Target = "IDtarget",
                          Value = "value", NodeID = "name", sinksRight = FALSE, colourScale = my_color, 
                          nodeWidth = 40, fontSize = 13, nodePadding = 20)

# Filter the data for DEIS_W2 = 1
sankey_df_1 <- complete_info_dataset_SDQ_English %>%
  filter(DEIS_W2 == 1) %>%
  count(JC_English_Points, LC_English_Points, Gender_YP_W2) %>%
  mutate(JC_English_Points = paste("JC", JC_English_Points),
         LC_English_Points = paste("LC", LC_English_Points))

nodes_1 <- data.frame(
  name = unique(c(as.character(sankey_df_1$JC_English_Points), 
                  as.character(sankey_df_1$LC_English_Points)))
)

sankey_df_1$IDsource <- match(sankey_df_1$JC_English_Points, nodes_1$name) - 1
sankey_df_1$IDtarget <- match(sankey_df_1$LC_English_Points, nodes_1$name) - 1

links_1 <- sankey_df_1 %>%
  select(IDsource, IDtarget, value = n)

sankey_1 <- sankeyNetwork(Links = links_1, Nodes = nodes_1, Source = "IDsource", Target = "IDtarget",
                          Value = "value", NodeID = "name", sinksRight = FALSE, colourScale = my_color, 
                          nodeWidth = 40, fontSize = 13, nodePadding = 20)

# Combine the two Sankey diagrams side by side
browsable(
  tagList(
    div(style = "display: inline-block; width: 48%;", sankey_0),
    div(style = "display: inline-block; width: 48%;", sankey_1)
  )
)
