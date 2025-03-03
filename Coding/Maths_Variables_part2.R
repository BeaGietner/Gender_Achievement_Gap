library(dplyr)

# Extract the variable for IDs in your subsample
responses <- ml_data_complete %>%
  select(ID) %>%
  inner_join(select(Merged_Child, ID, cq4F6c), by = "ID")

# View the responses
head(responses)

library(dplyr)


# Merge to get the favourite subjects for IDs in ml_data_complete
resilient_subjects <- ml_data_complete %>%
  select(ID, resilience) %>%
  inner_join(select(Merged_Child, ID, CQ3a), by = "ID") %>%
  filter(resilience == "Resilient") %>%
  count(CQ3a, sort = TRUE)

# View results
print(resilient_subjects, n = Inf)

# Create a lookup table for subject labels
labels <- c(
  "1" = "Above Average", "2" = "Just above average", "3" = "Average", "4" = "Just below average", 
  "5" = "Below average", "6" = "Don't know/Didn't do"
)

# Replace numeric codes with labels
resilient_subjects <- resilient_subjects %>%
  mutate(subject = labels[as.character(cq4F6c)])

# View results
print(resilient_subjects, n = Inf)

# Merge to get the favourite subjects for IDs in ml_data_complete
noresilient_subjects <- ml_data_complete %>%
  select(ID, resilience) %>%
  inner_join(select(Merged_Child, ID, CQ3a), by = "ID") %>%
  filter(resilience == "Non-Resilient") %>%
  count(CQ3a, sort = TRUE)

# View results
print(noresilient_subjects, n = Inf)

# Create a lookup table for subject labels
labels <- c(
  "1" = "Above Average", "2" = "Just above average", "3" = "Average", "4" = "Just below average", 
  "5" = "Below average", "6" = "Don't know/Didn't do"
)

# Replace numeric codes with labels
noresilient_subjects <- noresilient_subjects %>%
  mutate(subject = labels[as.character(cq4F6c)])

# View results
print(noresilient_subjects, n = Inf)

library(dplyr)
library(ggplot2)

# Merge the teacher feedback variable with ml_data_complete
feedback_data <- ml_data_complete %>%
  select(ID, resilience) %>%
  right_join(select(Merged_Child, ID, cq2q5a), by = "ID") %>%
  count(resilience, cq2q5a) %>%
  arrange(resilience, desc(n))

# View distribution
print(feedback_data, n = Inf)
# Define response labels
feedback_labels <- c(
  "1" = "Very often",
  "2" = "Often",
  "3" = "A few times",
  "4" = "Never",
  "8" = "Refusal",
  "9" = "Don't Know"
)

# Replace numeric codes with labels for readability
feedback_data <- feedback_data %>%
  mutate(response_label = feedback_labels[as.character(cq2q5a)])

# Plot the results
ggplot(feedback_data, aes(x = response_label, y = n, fill = resilience)) +
  geom_bar(stat = "identity", position = "dodge") +
  labs(
    title = "Teacher Feedback Responses: Resilient vs. Non-Resilient Students",
    x = "Teacher Feedback (Q5a1)",
    y = "Number of Students",
    fill = "Resilience"
  ) +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

             



library(dplyr)
library(ggplot2)

# Compute percentages
feedback_data_pct <- ml_data_complete %>%
  select(ID, resilience) %>%
  right_join(select(Merged_Child, ID, cq2q5a), by = "ID") %>%
  count(resilience, cq2q5a) %>%
  group_by(resilience) %>%
  mutate(pct = n / sum(n) * 100) %>%
  ungroup()

# Define response labels
feedback_labels <- c(
  "1" = "Very often",
  "2" = "Often",
  "3" = "A few times",
  "4" = "Never",
  "8" = "Refusal",
  "9" = "Don't Know"
)

# Replace numeric codes with labels for readability
feedback_data_pct <- feedback_data_pct %>%
  mutate(response_label = feedback_labels[as.character(cq2q5a)])

# Plot percentages
ggplot(feedback_data_pct, aes(x = response_label, y = pct, fill = resilience)) +
  geom_bar(stat = "identity", position = "dodge") +
  labs(
    title = "Teacher Feedback Responses: Resilient vs. Non-Resilient Students",
    x = "Teacher Feedback (Q5a1)",
    y = "Percentage of Group",
    fill = "Resilience"
  ) +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))



library(dplyr)
library(ggplot2)

# Compute percentages of favourite subjects within each resilience group
subject_data_pct <- ml_data_complete %>%
  select(ID, resilience) %>%
  right_join(select(Merged_Child, ID, cq2q2b2code1), by = "ID") %>%
  count(resilience, cq2q2b2code1) %>%
  group_by(resilience) %>%
  mutate(pct = n / sum(n) * 100) %>%
  ungroup()

# Define subject labels
subject_labels <- c(
  "1" = "Irish", "2" = "English", "3" = "Mathematics", "4" = "History", 
  "5" = "Geography", "6" = "French", "7" = "German", "8" = "Spanish", 
  "9" = "Italian", "10" = "Art, Craft & Design", "11" = "Music Science", 
  "12" = "Science", "13" = "Science (with Local Studies)", "14" = "Home Economics", 
  "15" = "Materials Technology (Wood)", "16" = "Metalwork", "17" = "Technical Graphics", 
  "18" = "Business Studies", "19" = "Typewriting", "20" = "Environmental and Social Studies (ESS)", 
  "21" = "Technology", "22" = "Latin", "23" = "Ancient Greek Classical Studies", 
  "24" = "Hebrew Studies", "25" = "Religious Education", 
  "26" = "Civic, Social and Political Education (CSPE)", 
  "27" = "Physical Education", "28" = "Social, Personal and Health Education (SPHE)", 
  "29" = "Computer Studies", "30" = "Other (please specify)"
)

# Replace numeric codes with labels for readability
subject_data_pct <- subject_data_pct %>%
  mutate(subject_label = subject_labels[as.character(cq2q2b2code1)])

# Plot percentages
ggplot(subject_data_pct, aes(x = reorder(subject_label, pct), y = pct, fill = resilience)) +
  geom_bar(stat = "identity", position = "dodge") +
  coord_flip() +  # Flip axes for better readability
  labs(
    title = "Favourite Subjects by Resilience Group (Adjusted for Sample Size)",
    x = "Favourite Subject",
    y = "Percentage of Group",
    fill = "Resilience"
  ) +
  theme_minimal()


library(dplyr)
library(ggplot2)

# Compute percentages of favourite subjects within each resilience group (excluding NA)
subject_data_pct <- ml_data_complete %>%
  select(ID, resilience) %>%
  right_join(select(Merged_Child, ID, cq2q2b2code1), by = "ID") %>%
  filter(!is.na(cq2q2b2code1)) %>%  # Remove NA values
  count(resilience, cq2q2b2code1) %>%
  group_by(resilience) %>%
  mutate(pct = n / sum(n) * 100) %>%
  ungroup()

# Define subject labels
subject_labels <- c(
  "1" = "Irish", "2" = "English", "3" = "Mathematics", "4" = "History", 
  "5" = "Geography", "6" = "French", "7" = "German", "8" = "Spanish", 
  "9" = "Italian", "10" = "Art, Craft & Design", "11" = "Music Science", 
  "12" = "Science", "13" = "Science (with Local Studies)", "14" = "Home Economics", 
  "15" = "Materials Technology (Wood)", "16" = "Metalwork", "17" = "Technical Graphics", 
  "18" = "Business Studies", "19" = "Typewriting", "20" = "Environmental and Social Studies (ESS)", 
  "21" = "Technology", "22" = "Latin", "23" = "Ancient Greek Classical Studies", 
  "24" = "Hebrew Studies", "25" = "Religious Education", 
  "26" = "Civic, Social and Political Education (CSPE)", 
  "27" = "Physical Education", "28" = "Social, Personal and Health Education (SPHE)", 
  "29" = "Computer Studies", "30" = "Other (please specify)"
)

# Replace numeric codes with labels for readability
subject_data_pct <- subject_data_pct %>%
  mutate(subject_label = subject_labels[as.character(cq2q2b2code1)])

# Plot percentages (excluding NA)
ggplot(subject_data_pct, aes(x = reorder(subject_label, pct), y = pct, fill = resilience)) +
  geom_bar(stat = "identity", position = "dodge") +
  coord_flip() +  # Flip axes for better readability
  labs(
    title = "Favourite Subjects by Resilience Group (Adjusted for Sample Size)",
    x = "Favourite Subject",
    y = "Percentage of Group",
    fill = "Resilience"
  ) +
  theme_minimal()


library(dplyr)
library(ggplot2)

# Compute percentages of favourite subjects within each resilience group (excluding all NAs)
subject_data_pct <- ml_data_complete %>%
  filter(!is.na(resilience)) %>%  # Remove NA values in resilience
  select(ID, resilience) %>%
  right_join(select(Merged_Child, ID, cq2q2b2code1), by = "ID") %>%
  filter(!is.na(cq2q2b2code1)) %>%  # Remove NA values in subject choice
  count(resilience, cq2q2b2code1) %>%
  group_by(resilience) %>%
  mutate(pct = n / sum(n) * 100) %>%
  ungroup()

# Define subject labels
subject_labels <- c(
  "1" = "Irish", "2" = "English", "3" = "Mathematics", "4" = "History", 
  "5" = "Geography", "6" = "French", "7" = "German", "8" = "Spanish", 
  "9" = "Italian", "10" = "Art, Craft & Design", "11" = "Music Science", 
  "12" = "Science", "13" = "Science (with Local Studies)", "14" = "Home Economics", 
  "15" = "Materials Technology (Wood)", "16" = "Metalwork", "17" = "Technical Graphics", 
  "18" = "Business Studies", "19" = "Typewriting", "20" = "Environmental and Social Studies (ESS)", 
  "21" = "Technology", "22" = "Latin", "23" = "Ancient Greek Classical Studies", 
  "24" = "Hebrew Studies", "25" = "Religious Education", 
  "26" = "Civic, Social and Political Education (CSPE)", 
  "27" = "Physical Education", "28" = "Social, Personal and Health Education (SPHE)", 
  "29" = "Computer Studies", "30" = "Other (please specify)"
)

# Replace numeric codes with labels for readability
subject_data_pct <- subject_data_pct %>%
  mutate(subject_label = subject_labels[as.character(cq2q2b2code1)])

# Plot percentages (excluding NA)
ggplot(subject_data_pct, aes(x = reorder(subject_label, pct), y = pct, fill = resilience)) +
  geom_bar(stat = "identity", position = "dodge") +
  coord_flip() +  # Flip axes for better readability
  labs(
    title = "Favourite Subjects by Resilience Group (Adjusted for Sample Size)",
    x = "Favourite Subject",
    y = "Percentage of Group",
    fill = "Resilience"
  ) +
  theme_minimal()



library(dplyr)

# Extract the variable for IDs in your subsample
responses <- ml_data_complete %>%
  select(ID) %>%
  inner_join(select(Merged_Child, ID, cq4F6c), by = "ID")

# View the responses
head(responses)

library(dplyr)


# Merge to get the favourite subjects for IDs in ml_data_complete
resilient_subjects <- ml_data_complete %>%
  select(ID, resilience) %>%
  inner_join(select(Merged_Child, ID, cq4F6c), by = "ID") %>%
  filter(resilience == "Resilient") %>%
  count(cq4F6c, sort = TRUE)

# View results
print(resilient_subjects, n = Inf)

# Create a lookup table for subject labels
labels <- c(
  "1" = "Above Average", "2" = "Just above average", "3" = "Average", "4" = "Just below average", 
  "5" = "Below average", "6" = "Don't know/Didn't do"
)

# Replace numeric codes with labels
resilient_subjects <- resilient_subjects %>%
  mutate(subject = labels[as.character(cq4F6c)])

# View results
print(resilient_subjects, n = Inf)

# Merge to get the favourite subjects for IDs in ml_data_complete
noresilient_subjects <- ml_data_complete %>%
  select(ID, resilience) %>%
  inner_join(select(Merged_Child, ID, cq4F6c), by = "ID") %>%
  filter(resilience == "Non-Resilient") %>%
  count(cq4F6c, sort = TRUE)

# View results
print(noresilient_subjects, n = Inf)

# Create a lookup table for subject labels
labels <- c(
  "1" = "Above Average", "2" = "Just above average", "3" = "Average", "4" = "Just below average", 
  "5" = "Below average", "6" = "Don't know/Didn't do"
)

# Replace numeric codes with labels
noresilient_subjects <- noresilient_subjects %>%
  mutate(subject = labels[as.character(cq4F6c)])

# View results
print(noresilient_subjects, n = Inf)

