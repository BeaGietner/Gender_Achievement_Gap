# -*- coding: utf-8 -*-
"""
Created on Thu Mar 13 11:37:24 2025

@author: bgiet
"""

import matplotlib.pyplot as plt
import numpy as np

# RESULTS FOR MATHS

# Data for Wave 1 and Wave 2 for Boys
categories = ["Endowments", "Coefficients", "Interaction"]

# Updated values and errors from the decomposition results
wave1_values = [0.467875, 0.5970239, 0.0447067]  
wave1_errors = [0.11541, 0.1118286, 0.1070338]  # Correct standard errors from output

wave2_values = [0.6439431, 0.4812966, -0.0156341]  # Updated values
wave2_errors = [0.1185145, 0.0966306, 0.0780352]  # Updated standard errors

# Significance levels from p-values in the output
wave1_pvalues = [0.000, 0.000, 0.676]  # Updated p-values
wave2_pvalues = [0.000, 0.000, 0.841]  # Updated p-values

# Assign stars based on significance levels
def significance_stars(p_values):
    return ['***' if p <= 0.01 else '**' if p <= 0.05 else '*' if p <= 0.1 else '' for p in p_values]

wave1_stars = significance_stars(wave1_pvalues)
wave2_stars = significance_stars(wave2_pvalues)

# X locations for the groups
x = np.arange(len(categories))
width = 0.35

fig, ax = plt.subplots(figsize=(10, 6))
bars1 = ax.bar(x - width/2, wave1_values, width, yerr=wave1_errors, capsize=5, label="Wave 1", color="orange")
bars2 = ax.bar(x + width/2, wave2_values, width, yerr=wave2_errors, capsize=5, label="Wave 2", color="gold")

# Adding stars above bars for significance
for bars, stars in zip([bars1, bars2], [wave1_stars, wave2_stars]):
    for bar, star in zip(bars, stars):
        height = bar.get_height()
        ax.text(bar.get_x() + bar.get_width()/2, height + 0.05, star, ha='center', va='bottom', fontsize=12, fontweight='bold')

# Labels and Titles
ax.set_xlabel("Decomposition Components")
ax.set_ylabel("Estimated Contribution to Maths Points")
ax.set_title("Oaxaca Decomposition: Maths Points (Boys)")
ax.set_xticks(x)
ax.set_xticklabels(categories)
ax.axhline(0, color='black', linewidth=0.8)  # Zero line

# Manually setting the legend to ensure both bars appear
legend_labels = ["Wave 1: Father Present vs. Absent", "Wave 2: Father Present vs. Absent"]
ax.legend([bars1[0], bars2[0]], legend_labels, title="Comparison Groups")

# Annotating the mean maths points for each group - updated values
# Wave 1 values
wave1_group1_mean = 9.834606  # Father present
wave1_group2_mean = 8.725     # Father absent
# Wave 2 values
wave2_group1_mean = 9.834606  # Father present
wave2_group2_mean = 8.725     # Father absent

annotation_text = (f"Mean Maths Points:\n"
                   f"Wave 1 - Present: {wave1_group1_mean:.2f}, Absent: {wave1_group2_mean:.2f}\n"
                   f"Wave 2 - Present: {wave2_group1_mean:.2f}, Absent: {wave2_group2_mean:.2f}")

ax.text(1.5, min(min(wave1_values), min(wave2_values)) - 0.3, annotation_text,
        fontsize=10, bbox=dict(facecolor='white', edgecolor='black', boxstyle='round,pad=0.5'))

plt.tight_layout()
plt.show()



import matplotlib.pyplot as plt
import numpy as np

# Data for Wave 1 and Wave 2 for Girls
categories = ["Endowments", "Coefficients", "Interaction"]

# Updated values and errors from the decomposition results
wave1_values = [0.4594358, 0.2743683, 0.1997355]
wave1_errors = [0.0998464, 0.1221881, 0.0732378]  # Correct standard errors

wave2_values = [0.6965646, 0.2347151, 0.0022599]  # Updated values
wave2_errors = [0.1221239, 0.0897076, 0.0785829]  # Updated standard errors

# Significance levels from p-values in the output
wave1_pvalues = [0.000, 0.025, 0.006]  # Updated p-values
wave2_pvalues = [0.000, 0.009, 0.977]  # Updated p-values

# Assign stars based on significance levels
def significance_stars(p_values):
    return ['***' if p <= 0.01 else '**' if p <= 0.05 else '*' if p <= 0.1 else '' for p in p_values]

wave1_stars = significance_stars(wave1_pvalues)
wave2_stars = significance_stars(wave2_pvalues)

# X locations for the groups
x = np.arange(len(categories))
width = 0.35

fig, ax = plt.subplots(figsize=(10, 6))
bars1 = ax.bar(x - width/2, wave1_values, width, yerr=wave1_errors, capsize=5, label="Wave 1", color="mediumpurple")
bars2 = ax.bar(x + width/2, wave2_values, width, yerr=wave2_errors, capsize=5, label="Wave 2", color="red")

# Adding stars above bars for significance
for bars, stars in zip([bars1, bars2], [wave1_stars, wave2_stars]):
    for bar, star in zip(bars, stars):
        height = bar.get_height()
        ax.text(bar.get_x() + bar.get_width()/2, height + 0.05, star, ha='center', va='bottom', fontsize=12, fontweight='bold')

# Labels and Titles
ax.set_xlabel("Decomposition Components")
ax.set_ylabel("Estimated Contribution to Maths Points")
ax.set_title("Oaxaca Decomposition: Maths Points (Girls)")
ax.set_xticks(x)
ax.set_xticklabels(categories)
ax.axhline(0, color='black', linewidth=0.8)  # Zero line

# Manually setting the legend to ensure both bars appear
legend_labels = ["Wave 1: Father Present vs. Absent", "Wave 2: Father Present vs. Absent"]
ax.legend([bars1[0], bars2[0]], legend_labels, title="Comparison Groups")

# Annotating the mean maths points for each group
wave1_group1_mean = 9.728411  # Father present
wave1_group2_mean = 8.794872  # Father absent
wave2_group1_mean = 9.728411  # Father present
wave2_group2_mean = 8.794872  # Father absent

annotation_text = (f"Mean Maths Points:\n"
                   f"Wave 1 - Present: {wave1_group1_mean:.2f}, Absent: {wave1_group2_mean:.2f}\n"
                   f"Wave 2 - Present: {wave2_group1_mean:.2f}, Absent: {wave2_group2_mean:.2f}")

ax.text(1.5, min(min(wave1_values), min(wave2_values)) - 0.3, annotation_text,
        fontsize=10, bbox=dict(facecolor='white', edgecolor='black', boxstyle='round,pad=0.5'))

plt.tight_layout()
plt.show()



# ENGLISH

# Data for Wave 1 and Wave 2 for Boys - English
categories = ["Endowments", "Coefficients", "Interaction"]
wave1_values = [0.3420702, 0.2797027, 0.0126546]
wave1_errors = [0.1016822, 0.0794736, 0.0866402]
wave2_values = [0.4150713, 0.2409308, -0.0215746]
wave2_errors = [0.0948812, 0.0925237, 0.066936]

# Significance levels for p-values
wave1_pvalues = [0.001, 0.000, 0.884]
wave2_pvalues = [0.000, 0.009, 0.747]

# Assign stars based on significance levels
def significance_stars(p_values):
    return ['***' if p <= 0.01 else '**' if p <= 0.05 else '*' if p <= 0.1 else '' for p in p_values]

wave1_stars = significance_stars(wave1_pvalues)
wave2_stars = significance_stars(wave2_pvalues)

# X locations for the groups
x = np.arange(len(categories))
width = 0.35

fig, ax = plt.subplots(figsize=(10, 6))
bars1 = ax.bar(x - width/2, wave1_values, width, yerr=wave1_errors, capsize=5, label="Wave 1", color="orange")
bars2 = ax.bar(x + width/2, wave2_values, width, yerr=wave2_errors, capsize=5, label="Wave 2", color="gold")

# Adding stars above bars for significance
for bars, stars in zip([bars1, bars2], [wave1_stars, wave2_stars]):
    for bar, star in zip(bars, stars):
        height = bar.get_height()
        ax.text(bar.get_x() + bar.get_width()/2, height + 0.05, star, ha='center', va='bottom', fontsize=12, fontweight='bold')

# Labels and Titles
ax.set_xlabel("Decomposition Components")
ax.set_ylabel("Estimated Contribution to English Points")
ax.set_title("Oaxaca Decomposition: English Points (Boys)")
ax.set_xticks(x)
ax.set_xticklabels(categories)
ax.axhline(0, color='black', linewidth=0.8)  # Zero line

# Manually setting the legend to ensure both bars appear
legend_labels = ["Wave 1: Father Present vs. Absent", "Wave 2: Father Present vs. Absent"]
ax.legend([bars1[0], bars2[0]], legend_labels, title="Comparison Groups")

# Annotating the mean English points for each group
wave1_group1_mean = 10.07443
wave1_group2_mean = 9.44
wave2_group1_mean = 10.07443
wave2_group2_mean = 9.44

annotation_text = (f"Mean English Points:\n"
                   f"Wave 1 - Present: {wave1_group1_mean:.2f}, Absent: {wave1_group2_mean:.2f}\n"
                   f"Wave 2 - Present: {wave2_group1_mean:.2f}, Absent: {wave2_group2_mean:.2f}")

ax.text(1.5, min(min(wave1_values), min(wave2_values)) - 0.3, annotation_text,
        fontsize=10, bbox=dict(facecolor='white', edgecolor='black', boxstyle='round,pad=0.5'))

plt.show()


import matplotlib.pyplot as plt
import numpy as np

# Data for Wave 1 and Wave 2 for Girls
categories = ["Endowments", "Coefficients", "Interaction"]
wave1_values = [0.3750885, 0.3822161, -0.0033818]
wave1_errors = [0.0829312, 0.0877949, 0.0676499]
wave2_values = [0.4689423, 0.3585748, -0.0735943]
wave2_errors = [0.0886381, 0.0838042, 0.0758005]

# Significance levels for p-values
wave1_pvalues = [0.000, 0.000, 0.960]
wave2_pvalues = [0.000, 0.000, 0.332]

# Assign stars based on significance levels
def significance_stars(p_values):
    return ['***' if p <= 0.01 else '**' if p <= 0.05 else '*' if p <= 0.1 else '' for p in p_values]

wave1_stars = significance_stars(wave1_pvalues)
wave2_stars = significance_stars(wave2_pvalues)

# X locations for the groups
x = np.arange(len(categories))
width = 0.35

fig, ax = plt.subplots(figsize=(10, 6))
bars1 = ax.bar(x - width/2, wave1_values, width, yerr=wave1_errors, capsize=5, label="Wave 1", color="mediumpurple")
bars2 = ax.bar(x + width/2, wave2_values, width, yerr=wave2_errors, capsize=5, label="Wave 2", color="red")

# Adding stars above bars for significance
for bars, stars in zip([bars1, bars2], [wave1_stars, wave2_stars]):
    for bar, star in zip(bars, stars):
        height = bar.get_height()
        ax.text(bar.get_x() + bar.get_width()/2, height + 0.05, star, ha='center', va='bottom', fontsize=12, fontweight='bold')

# Labels and Titles
ax.set_xlabel("Decomposition Components")
ax.set_ylabel("Estimated Contribution to English Points")
ax.set_title("Oaxaca Decomposition: English Points (Girls)")
ax.set_xticks(x)
ax.set_xticklabels(categories)
ax.axhline(0, color='black', linewidth=0.8)  # Zero line

# Manually setting the legend to ensure both bars appear
legend_labels = ["Wave 1: Father Present vs. Absent", "Wave 2: Father Present vs. Absent"]
ax.legend([bars1[0], bars2[0]], legend_labels, title="Comparison Groups")

# Annotating the mean english points for each group
wave1_group1_mean = 10.42914
wave1_group2_mean = 9.675214
wave2_group1_mean = 10.42914
wave2_group2_mean = 9.675214

annotation_text = (f"Mean English Points:\n"
                   f"Wave 1 - Present: {wave1_group1_mean:.2f}, Absent: {wave1_group2_mean:.2f}\n"
                   f"Wave 2 - Present: {wave2_group1_mean:.2f}, Absent: {wave2_group2_mean:.2f}")

ax.text(1.5, min(min(wave1_values), min(wave2_values)) - 0.3, annotation_text,
        fontsize=10, bbox=dict(facecolor='white', edgecolor='black', boxstyle='round,pad=0.5'))

plt.show()



# ARE THE DIFFERENCE IN POINTS SIGNIFICANT?


import matplotlib.pyplot as plt
import numpy as np

# Data for Boys and Girls
categories = ["Maths Points", "English Points"]

# Boys' Data: Means and standard errors
boys_maths_means = [9.834606, 8.725]
boys_english_means = [10.07443, 9.44]
boys_maths_error = [0.1091925, 0.1355945]
boys_english_error = [0.0818415, 0.1059792]

# Girls' Data: Means and standard errors
girls_maths_means = [9.728411, 8.794872]
girls_english_means = [10.429136, 9.675214]
girls_maths_error = [0.1012986, 0.0960112]
girls_english_error = [0.0829312, 0.0877949]

# Labels
x = np.arange(len(categories))
width = 0.35  # Width of the bars

fig, ax = plt.subplots(figsize=(12, 8))

# Plotting the Boys' Data (on the left) using scatter (dots)
ax.errorbar(x - width/2, boys_maths_means, yerr=boys_maths_error, fmt='o', label="Boys - Maths", color="mediumpurple", markersize=8)
ax.errorbar(x - width/2, boys_english_means, yerr=boys_english_error, fmt='o', label="Boys - English", color="orange", markersize=8)

# Plotting the Girls' Data (on the right) using scatter (dots)
ax.errorbar(x + width/2, girls_maths_means, yerr=girls_maths_error, fmt='o', label="Girls - Maths", color="lightcoral", markersize=8)
ax.errorbar(x + width/2, girls_english_means, yerr=girls_english_error, fmt='o', label="Girls - English", color="yellow", markersize=8)

# Adding stars for significance
def add_significance_stars(x_values, y_values, y_errors, p_values, offset=0.05):
    for x_val, y_val, y_err, p_value in zip(x_values, y_values, y_errors, p_values):
        if p_value < 0.01:
            star = "***"
        elif p_value < 0.05:
            star = "**"
        elif p_value < 0.1:
            star = "*"
        else:
            star = ""
        ax.text(x_val, y_val + offset, star, ha='center', va='bottom', fontsize=12, fontweight='bold')

# Significance for Boys (Maths and English)
boys_maths_p_values = [5.571e-14, 3.504e-08]  # p-values for boys' Maths and English
boys_english_p_values = [5.571e-14, 3.504e-08]

# Significance for Girls (Maths and English)
girls_maths_p_values = [4.357e-13, 1.781e-11]  # p-values for girls' Maths and English
girls_english_p_values = [4.357e-13, 1.781e-11]

# Add significance stars
add_significance_stars(x - width/2, boys_maths_means, boys_maths_error, boys_maths_p_values)
add_significance_stars(x - width/2, boys_english_means, boys_english_error, boys_english_p_values)
add_significance_stars(x + width/2, girls_maths_means, girls_maths_error, girls_maths_p_values)
add_significance_stars(x + width/2, girls_english_means, girls_english_error, girls_english_p_values)

# Labels and Titles
ax.set_xlabel("Subjects")
ax.set_ylabel("Average Points")
ax.set_title("Comparison of Maths and English Points by Father Absence Status")
ax.set_xticks(x)
ax.set_xticklabels(categories)
ax.axhline(0, color='black', linewidth=0.8)  # Zero line

# Manually setting the legend to ensure both bars appear
ax.legend(title="Groups", labels=["Boys - Maths", "Boys - English", "Girls - Maths", "Girls - English"])

# Annotating the mean maths points for each group
boys_group1_mean = 9.834606
boys_group2_mean = 8.725
girls_group1_mean = 9.728411
girls_group2_mean = 8.794872

annotation_text = (f"Mean Maths Points:\n"
                   f"Boys - Present: {boys_group1_mean:.2f}, Absent: {boys_group2_mean:.2f}\n"
                   f"Girls - Present: {girls_group1_mean:.2f}, Absent: {girls_group2_mean:.2f}")

ax.text(1.5, min(min(boys_maths_means), min(girls_maths_means)) - 0.3, annotation_text,
        fontsize=10, bbox=dict(facecolor='white', edgecolor='black', boxstyle='round,pad=0.5'))

plt.show()



import matplotlib.pyplot as plt
import numpy as np

# Categories for decomposition components
categories = ["Endowments", "Coefficients", "Interaction"]

# Values and errors for the two Oaxaca decompositions (without and with father's education)
# Using the correct numbers from the table
without_father_values = [-0.098, -0.082, 0.050]  # Corrected values
without_father_errors = [0.038, 0.044, 0.023]    # Corrected standard errors
with_father_values = [-0.085, -0.087, 0.055]     # Corrected values
with_father_errors = [0.038, 0.047, 0.023]       # Corrected standard errors

# Significance levels for p-values (using the corrected p-values)
without_father_pvalues = [0.010, 0.063, 0.031]  # Corrected p-values
with_father_pvalues = [0.025, 0.066, 0.019]     # Corrected p-values

# Assign stars based on significance levels
def significance_stars(p_values):
    return ['***' if p <= 0.01 else '**' if p <= 0.05 else '*' if p <= 0.1 else '' for p in p_values]

without_father_stars = significance_stars(without_father_pvalues)
with_father_stars = significance_stars(with_father_pvalues)

# X locations for the groups
x = np.arange(len(categories))
width = 0.35

fig, ax = plt.subplots(figsize=(10, 6))
bars1 = ax.bar(x - width/2, without_father_values, width, yerr=without_father_errors, capsize=5, label="Without Father's Education", color="orange")
bars2 = ax.bar(x + width/2, with_father_values, width, yerr=with_father_errors, capsize=5, label="With Father's Education", color="gold")

# Adding stars above bars for significance
for bars, stars in zip([bars1, bars2], [without_father_stars, with_father_stars]):
    for bar, star in zip(bars, stars):
        height = bar.get_height()
        y_pos = height + 0.02 if height >= 0 else height - 0.05
        ax.text(bar.get_x() + bar.get_width()/2, y_pos, star, ha='center', va='bottom', fontsize=12, fontweight='bold')

# Labels and Titles
ax.set_xlabel("Decomposition Components", labelpad=10)
ax.set_ylabel("Estimated Contribution to Maths Points (Girls - Boys)")
ax.set_title("Oaxaca Decomposition: Maths Points (Girls vs. Boys) - Wave 1")
ax.set_xticks(x)
ax.set_xticklabels(categories)
ax.axhline(0, color='black', linewidth=0.8)  # Zero line

# Manually setting the legend to ensure both bars appear
legend_labels = ["Without Father's Education", "With Father's Education"]
ax.legend([bars1[0], bars2[0]], legend_labels, title="Comparison Groups")

# Annotating the mean maths points for each group - using table values
# Note: Group 1 is Female, Group 2 is Male in the table
without_father_group1_mean = 9.541  # Female
without_father_group2_mean = 9.671  # Male
with_father_group1_mean = 9.664     # Female
with_father_group2_mean = 9.781     # Male

annotation_text = (f"Mean Maths Points:\n"
                   f"Without Father's Education -\n"
                   f"Girls: {without_father_group1_mean:.2f}, Boys: {without_father_group2_mean:.2f}\n"
                   f"With Father's Education - \n"
                   f"Girls: {with_father_group1_mean:.2f}, Boys: {with_father_group2_mean:.2f}")

ax.text(1.5, ax.get_ylim()[0] + 0.05, annotation_text, fontsize=10, 
        bbox=dict(facecolor='white', edgecolor='black', boxstyle='round,pad=0.5'))

plt.tight_layout()
plt.show()



import matplotlib.pyplot as plt
import numpy as np

# Categories for decomposition components
categories = ["Endowments", "Coefficients", "Interaction"]

# Values and errors for the two Oaxaca decompositions (without and with father's education) for Wave 2
# Updated with correct values from the decomposition output
without_father_values = [-0.2686, 0.1105, 0.0279]  # Corrected values from output
without_father_errors = [0.0424, 0.0411, 0.0255]   # Corrected standard errors
with_father_values = [-0.2484, 0.0926, 0.0236]     # Corrected values
with_father_errors = [0.0435, 0.0466, 0.0293]      # Corrected standard errors

# Significance levels for p-values (from the output z-tests)
without_father_pvalues = [0.000, 0.007, 0.273]  # Corrected p-values
with_father_pvalues = [0.000, 0.047, 0.420]     # Corrected p-values

# Assign stars based on significance levels
def significance_stars(p_values):
    return ['***' if p <= 0.01 else '**' if p <= 0.05 else '*' if p <= 0.1 else '' for p in p_values]

without_father_stars = significance_stars(without_father_pvalues)
with_father_stars = significance_stars(with_father_pvalues)

# X locations for the groups
x = np.arange(len(categories))
width = 0.35

fig, ax = plt.subplots(figsize=(10, 6))
bars1 = ax.bar(x - width/2, without_father_values, width, yerr=without_father_errors, capsize=5, label="Without Father's Education", color="mediumpurple")
bars2 = ax.bar(x + width/2, with_father_values, width, yerr=with_father_errors, capsize=5, label="With Father's Education", color="red")

# Adding stars above bars for significance
for bars, stars in zip([bars1, bars2], [without_father_stars, with_father_stars]):
    for bar, star in zip(bars, stars):
        height = bar.get_height()
        y_pos = height + 0.02 if height >= 0 else height - 0.05
        ax.text(bar.get_x() + bar.get_width()/2, y_pos, star, ha='center', va='bottom', fontsize=12, fontweight='bold')

# Labels and Titles
ax.set_xlabel("Decomposition Components", labelpad=10)
ax.set_ylabel("Estimated Contribution to Maths Points (Girls - Boys)")
ax.set_title("Oaxaca Decomposition: Maths Points (Girls vs. Boys) - Wave 2")
ax.set_xticks(x)
ax.set_xticklabels(categories)
ax.axhline(0, color='black', linewidth=0.8)  # Zero line

# Manually setting the legend to ensure both bars appear
legend_labels = ["Without Father's Education", "With Father's Education"]
ax.legend([bars1[0], bars2[0]], legend_labels, title="Comparison Groups")

# Annotating the mean maths points for each group - correct values from output
without_father_group1_mean = 9.541  # Girls (group_1)
without_father_group2_mean = 9.671  # Boys (group_2)
with_father_group1_mean = 9.695     # Girls (group_1)
with_father_group2_mean = 9.828     # Boys (group_2)

annotation_text = (f"Mean Maths Points:\n"
                   f"Without Father's Education -\n"
                   f"Girls: {without_father_group1_mean:.2f}, Boys: {without_father_group2_mean:.2f}\n"
                   f"With Father's Education - \n"
                   f"Girls: {with_father_group1_mean:.2f}, Boys: {with_father_group2_mean:.2f}")

ax.text(1.5, ax.get_ylim()[0] + 0.05, annotation_text, fontsize=10, 
        bbox=dict(facecolor='white', edgecolor='black', boxstyle='round,pad=0.5'))

plt.tight_layout()
plt.show()


import matplotlib.pyplot as plt
import numpy as np

# Data for the sample WITHOUT the father (from table)
variables_without_father = [
    "Reading Ability (C)",
    "Maths Ability (E)",
    "Maths Ability (C)",
    "Maths Ability (I)",
    "Conduct Problems (E)",
    "Hyperactivity (E)",
    "PCG Education 5-6 (E)"
]
estimates_without_father = [
    0.027,         # Reading Ability (C)
    -0.116,        # Maths Ability (E)
    0.050,         # Maths Ability (C)
    0.020,         # Maths Ability (I)
    0.012,         # Conduct Problems (E)
    0.043,         # Hyperactivity (E)
    -0.033         # PCG Education 5-6 (E)
]
# Calculate confidence intervals from standard errors
std_errors_without_father = [
    0.016,         # Reading Ability (C)
    0.020,         # Maths Ability (E)
    0.026,         # Maths Ability (C)
    0.011,         # Maths Ability (I)
    0.005,         # Conduct Problems (E)
    0.010,         # Hyperactivity (E)
    0.015          # PCG Education 5-6 (E)
]
# Confidence intervals at 95% level (approximating from 1.96 * SE)
ci_lower_without_father = [
    est - 1.96 * se for est, se in zip(estimates_without_father, std_errors_without_father)
]
ci_upper_without_father = [
    est + 1.96 * se for est, se in zip(estimates_without_father, std_errors_without_father)
]
significance_without_father = ["*", "***", "*", "*", "**", "***", "**"]

# Data for the sample WITH the father
variables_with_father = [
    "Reading Ability (C)",
    "Maths Ability (E)",
    "Maths Ability (C)",
    "Maths Ability (I)",
    "Conduct Problems (E)",
    "Hyperactivity (E)",
    "PCG Education 5-6 (E)",
    "SCG Education 5-6 (E)",
    "Mixed School (C)",
    "Mixed School (I)"
]
estimates_with_father = [
    0.033,         # Reading Ability (C)
    -0.104,        # Maths Ability (E)
    0.047,         # Maths Ability (C)
    0.019,         # Maths Ability (I)
    0.014,         # Conduct Problems (E)
    0.046,         # Hyperactivity (E)
    -0.023,        # PCG Education 5-6 (E)
    -0.028,        # SCG Education 5-6 (E)
    0.141,         # Mixed School (C)
    0.023          # Mixed School (I)
]
std_errors_with_father = [
    0.017,         # Reading Ability (C)
    0.020,         # Maths Ability (E)
    0.025,         # Maths Ability (C)
    0.011,         # Maths Ability (I)
    0.006,         # Conduct Problems (E)
    0.010,         # Hyperactivity (E)
    0.012,         # PCG Education 5-6 (E)
    0.010,         # SCG Education 5-6 (E)
    0.078,         # Mixed School (C)
    0.013          # Mixed School (I)
]
# Confidence intervals at 95% level
ci_lower_with_father = [
    est - 1.96 * se for est, se in zip(estimates_with_father, std_errors_with_father)
]
ci_upper_with_father = [
    est + 1.96 * se for est, se in zip(estimates_with_father, std_errors_with_father)
]
significance_with_father = ["**", "***", "*", "*", "**", "***", "*", "***", "*", "*"]

# Combine both sets of data
variables = variables_without_father + variables_with_father
estimates = estimates_without_father + estimates_with_father
ci_lower = ci_lower_without_father + ci_lower_with_father
ci_upper = ci_upper_without_father + ci_upper_with_father
significance = significance_without_father + significance_with_father

# Convert lists to NumPy arrays
y_pos = np.arange(len(variables))
errors = [np.array(estimates) - np.array(ci_lower), np.array(ci_upper) - np.array(estimates)]

# Define split index for separating sections
split_index = len(variables_without_father)

# Plot
fig, ax = plt.subplots(figsize=(12, 10))
ax.errorbar(estimates, y_pos, xerr=errors, fmt='o', color='b', capsize=5, label="Estimate ± 95% CI")
ax.axvline(x=0, color='gray', linestyle='--', alpha=0.7)
ax.axhline(y=split_index - 0.5, color='black', linestyle='-', linewidth=1)
ax.set_yticks(y_pos)
ax.set_yticklabels(variables)
ax.set_xlabel("Estimate")

# Categorize variables with labels (E=Endowments, C=Coefficients, I=Interaction)
ax.set_title("Significant Oaxaca-Blinder Decomposition Estimates (Girls - Boys) - Wave 1\nE=Endowments, C=Coefficients, I=Interaction")
ax.invert_yaxis()

# Add section labels in the top right
ax.text(ax.get_xlim()[1] - 0.01, split_index - 0.75, "Excluding Father's Education", fontsize=12, fontweight='bold', ha='right')
ax.text(ax.get_xlim()[1] - 0.01, split_index + 0.75, "Including Father's Education", fontsize=12, fontweight='bold', ha='right')

# Add significance markers
for i, (est, sig) in enumerate(zip(estimates, significance)):
    ax.text(est + (0.02 if est >= 0 else -0.02), i, sig, fontsize=12, verticalalignment='center', 
            color='red', horizontalalignment='left' if est >= 0 else 'right')

plt.tight_layout()
plt.show()



import matplotlib.pyplot as plt
import numpy as np

# Data for the sample WITHOUT the father (from table)
# Only including variables significant at p<0.05 or better
variables_without_father = [
    "Maths Ability (E)",
    "Conduct Problems (E)",
    "Hyperactivity (E)",
    "Mother's Educ. (Bachelor's/Postgrad) (E)"
]
estimates_without_father = [
    -0.116,        # Maths Ability (E)
    0.012,         # Conduct Problems (E)
    0.043,         # Hyperactivity (E)
    -0.033         # Mother's Educ. (Bachelor's/Postgrad) (E)
]
# Calculate confidence intervals from standard errors
std_errors_without_father = [
    0.020,         # Maths Ability (E)
    0.005,         # Conduct Problems (E)
    0.010,         # Hyperactivity (E)
    0.015          # Mother's Educ. (Bachelor's/Postgrad) (E)
]
# Confidence intervals at 95% level (approximating from 1.96 * SE)
ci_lower_without_father = [
    est - 1.96 * se for est, se in zip(estimates_without_father, std_errors_without_father)
]
ci_upper_without_father = [
    est + 1.96 * se for est, se in zip(estimates_without_father, std_errors_without_father)
]
significance_without_father = ["***", "**", "***", "**"]

# Data for the sample WITH the father
# Only including variables significant at p<0.05 or better
variables_with_father = [
    "Reading Ability (C)",
    "Maths Ability (E)",
    "Conduct Problems (E)",
    "Hyperactivity (E)",
    "Father's Educ. (Bachelor's/Postgrad) (E)"
]
estimates_with_father = [
    0.033,         # Reading Ability (C)
    -0.104,        # Maths Ability (E)
    0.014,         # Conduct Problems (E)
    0.046,         # Hyperactivity (E)
    -0.028         # Mother's Educ. (Bachelor's/Postgrad) (E)
]
std_errors_with_father = [
    0.017,         # Reading Ability (C)
    0.020,         # Maths Ability (E)
    0.006,         # Conduct Problems (E)
    0.010,         # Hyperactivity (E)
    0.010          # Mother's Educ. (Bachelor's/Postgrad) (E)
]
# Confidence intervals at 95% level
ci_lower_with_father = [
    est - 1.96 * se for est, se in zip(estimates_with_father, std_errors_with_father)
]
ci_upper_with_father = [
    est + 1.96 * se for est, se in zip(estimates_with_father, std_errors_with_father)
]
significance_with_father = ["**", "***", "**", "***", "***"]

# Combine both sets of data
variables = variables_without_father + variables_with_father
estimates = estimates_without_father + estimates_with_father
ci_lower = ci_lower_without_father + ci_lower_with_father
ci_upper = ci_upper_without_father + ci_upper_with_father
significance = significance_without_father + significance_with_father

# Convert lists to NumPy arrays
y_pos = np.arange(len(variables))
errors = [np.array(estimates) - np.array(ci_lower), np.array(ci_upper) - np.array(estimates)]

# Define split index for separating sections
split_index = len(variables_without_father)

# Plot
fig, ax = plt.subplots(figsize=(12, 8))
ax.errorbar(estimates, y_pos, xerr=errors, fmt='o', color='b', capsize=5, label="Estimate ± 95% CI")
ax.axvline(x=0, color='gray', linestyle='--', alpha=0.7)
ax.axhline(y=split_index - 0.5, color='black', linestyle='-', linewidth=1)
ax.set_yticks(y_pos)
ax.set_yticklabels(variables)
ax.set_xlabel("Estimate")

# Categorize variables with labels (E=Endowments, C=Coefficients, I=Interaction)
ax.set_title("Significant Oaxaca-Blinder Decomposition Estimates (Girls - Boys) - Wave 1\nE=Endowments, C=Coefficients (p<0.05 or better)")
ax.invert_yaxis()

# Add section labels in the top right
ax.text(ax.get_xlim()[1] - 0.01, split_index - 0.75, "Excluding Father's Education", fontsize=10, fontweight='bold', ha='right')
ax.text(ax.get_xlim()[1] - 0.01, split_index + 0.75, "Including Father's Education", fontsize=10, fontweight='bold', ha='right')

# Add significance markers
for i, (est, sig) in enumerate(zip(estimates, significance)):
    ax.text(est + (0.02 if est >= 0 else -0.02), i, sig, fontsize=12, verticalalignment='center', 
            color='red', horizontalalignment='left' if est >= 0 else 'right')

plt.tight_layout()
plt.show()


import matplotlib.pyplot as plt
import numpy as np

# Data for the sample WITHOUT the father (from table)
# Only including variables significant at p<0.05 or better
variables_without_father = [
    "Verbal Reasoning (E)",
    "Numerical Ability (E)",
    "Hyperactivity (E)",
    "Mother's Educ. (Bachelor's/Postgrad) (E)",
    "Conduct Problems (C)"
]
estimates_without_father = [
    -0.059,        # Verbal Reasoning (E)
    -0.234,        # Numerical Ability (E)
    0.058,         # Hyperactivity (E)
    -0.028,        # Mother's Educ. (Bachelor's/Postgrad) (E)
    -0.074         # Conduct Problems (C)
]
# Calculate confidence intervals from standard errors
std_errors_without_father = [
    0.012,         # Verbal Reasoning (E)
    0.023,         # Numerical Ability (E)
    0.011,         # Hyperactivity (E)
    0.011,         # Mother's Educ. (Bachelor's/Postgrad) (E)
    0.037          # Conduct Problems (C)
]
# Confidence intervals at 95% level (approximating from 1.96 * SE)
ci_lower_without_father = [
    est - 1.96 * se for est, se in zip(estimates_without_father, std_errors_without_father)
]
ci_upper_without_father = [
    est + 1.96 * se for est, se in zip(estimates_without_father, std_errors_without_father)
]
significance_without_father = ["***", "***", "***", "**", "**"]

# Data for the sample WITH the father
# Only including variables significant at p<0.05 or better
variables_with_father = [
    "Verbal Reasoning (E)",
    "Numerical Ability (E)",
    "Hyperactivity (E)",
    "Mother's Educ. (Bachelor's/Postgrad) (E)",
    "Father's Educ. (Bachelor's/Postgrad) (E)"
]
estimates_with_father = [
    -0.049,        # Verbal Reasoning (E)
    -0.211,        # Numerical Ability (E)
    0.055,         # Hyperactivity (E)
    -0.023,        # Mother's Educ. (Bachelor's/Postgrad) (E)
    -0.018         # Father's Educ. (Bachelor's/Postgrad) (E)
]
std_errors_with_father = [
    0.012,         # Verbal Reasoning (E)
    0.024,         # Numerical Ability (E)
    0.011,         # Hyperactivity (E)
    0.011,         # Mother's Educ. (Bachelor's/Postgrad) (E)
    0.008          # Father's Educ. (Bachelor's/Postgrad) (E)
]
# Confidence intervals at 95% level
ci_lower_with_father = [
    est - 1.96 * se for est, se in zip(estimates_with_father, std_errors_with_father)
]
ci_upper_with_father = [
    est + 1.96 * se for est, se in zip(estimates_with_father, std_errors_with_father)
]
significance_with_father = ["***", "***", "***", "**", "**"]

# Combine both sets of data
variables = variables_without_father + variables_with_father
estimates = estimates_without_father + estimates_with_father
ci_lower = ci_lower_without_father + ci_lower_with_father
ci_upper = ci_upper_without_father + ci_upper_with_father
significance = significance_without_father + significance_with_father

# Convert lists to NumPy arrays
y_pos = np.arange(len(variables))
errors = [np.array(estimates) - np.array(ci_lower), np.array(ci_upper) - np.array(estimates)]

# Define split index for separating sections
split_index = len(variables_without_father)

# Plot
fig, ax = plt.subplots(figsize=(12, 8))
ax.errorbar(estimates, y_pos, xerr=errors, fmt='o', color='b', capsize=5, label="Estimate ± 95% CI")
ax.axvline(x=0, color='gray', linestyle='--', alpha=0.7)
ax.axhline(y=split_index - 0.5, color='black', linestyle='-', linewidth=1)
ax.set_yticks(y_pos)
ax.set_yticklabels(variables)
ax.set_xlabel("Estimate")

# Categorize variables with labels
ax.set_title("Significant Oaxaca-Blinder Decomposition Estimates (Girls - Boys) - Wave 2\nE=Endowments, C=Coefficients (p<0.05 or better)")
ax.invert_yaxis()

# Get the current axis limits
xlim = ax.get_xlim()
ylim = ax.get_ylim()

# Add section labels INSIDE the plot area
# Calculate position - placing text at approximately the left edge of the plot area
# and in the middle of each section
x_pos = xlim[0] + (xlim[1] - xlim[0]) * 0.02  # 2% from the left edge

# For the upper section (excluding father's education)
y_pos_upper = (ylim[0] + split_index - 0.5) / 2
ax.text(x_pos, y_pos_upper, "Excluding Father's Education", 
        fontsize=10, fontweight='bold', ha='left', va='center')

# For the lower section (including father's education)
y_pos_lower = (split_index - 0.5 + ylim[1]) / 2
ax.text(x_pos, y_pos_lower, "Including Father's Education", 
        fontsize=10, fontweight='bold', ha='left', va='center')

# Add significance markers
for i, (est, sig) in enumerate(zip(estimates, significance)):
    ax.text(est + (0.02 if est >= 0 else -0.02), i, sig, fontsize=12, verticalalignment='center', 
            color='red', horizontalalignment='left' if est >= 0 else 'right')

plt.tight_layout()
plt.show()

import matplotlib.pyplot as plt
import numpy as np

# BOYS - Significant variables (p<0.05 or better)
# Wave 1 (Age 9)
boy_w1_variables = [
    "Maths Ability (E)",
    "Constant (C)"
]
boy_w1_estimates = [
    0.222,        # Maths Ability (E)
    0.710         # Constant (C)
]
boy_w1_std_errors = [
    0.064,        # Maths Ability (E)
    0.345         # Constant (C)
]
boy_w1_significance = ["***", "**"]

# Wave 2 (Age 13)
boy_w2_variables = [
    "Verbal Reasoning (E)",
    "Numerical Ability (E)",
    "BAS Matrices (E)"
]
boy_w2_estimates = [
    0.121,        # Verbal Reasoning (E)
    0.295,        # Numerical Ability (E)
    0.085         # BAS Matrices (E)
]
boy_w2_std_errors = [
    0.043,        # Verbal Reasoning (E)
    0.081,        # Numerical Ability (E)
    0.033         # BAS Matrices (E)
]
boy_w2_significance = ["***", "***", "***"]

# GIRLS - Significant variables (p<0.05 or better)
# Wave 1 (Age 9)
girl_w1_variables = [
    "Reading Ability (E)",
    "Maths Ability (E)",
    "Mother's Educ. (Higher 2ndary/Tech) (C)"
]
girl_w1_estimates = [
    0.090,        # Reading Ability (E)
    0.162,        # Maths Ability (E)
    0.381         # Mother's Educ. (Higher 2ndary/Tech) (C)
]
girl_w1_std_errors = [
    0.044,        # Reading Ability (E)
    0.045,        # Maths Ability (E)
    0.145         # Mother's Educ. (Higher 2ndary/Tech) (C)
]
girl_w1_significance = ["**", "***", "***"]

# Wave 2 (Age 13)
girl_w2_variables = [
    "Verbal Reasoning (E)",
    "Numerical Ability (E)",
    "Numerical Ability (C)",
    "Numerical Ability (I)",
    "BAS Matrices (E)",
    "Hyperactivity (E)",
    "Mother's Educ. (Higher 2ndary/Tech) (C)"
]
girl_w2_estimates = [
    0.097,        # Verbal Reasoning (E)
    0.373,        # Numerical Ability (E)
    0.154,        # Numerical Ability (C)
    -0.143,       # Numerical Ability (I)
    0.043,        # BAS Matrices (E)
    0.071,        # Hyperactivity (E)
    0.389         # Mother's Educ. (Higher 2ndary/Tech) (C)
]
girl_w2_std_errors = [
    0.041,        # Verbal Reasoning (E)
    0.080,        # Numerical Ability (E)
    0.058,        # Numerical Ability (C)
    0.055,        # Numerical Ability (I)
    0.022,        # BAS Matrices (E)
    0.027,        # Hyperactivity (E)
    0.162         # Mother's Educ. (Higher 2ndary/Tech) (C)
]
girl_w2_significance = ["**", "***", "***", "***", "**", "***", "**"]

# Create subplots with two rows (one for each gender) and extra space for y-labels
fig, (ax1, ax2) = plt.subplots(2, 1, figsize=(14, 12), sharex=True)
plt.subplots_adjust(left=0.3)  # Add more space on the left for labels

# Function to calculate confidence intervals
def calc_ci(estimates, std_errors):
    ci_lower = [est - 1.96 * se for est, se in zip(estimates, std_errors)]
    ci_upper = [est + 1.96 * se for est, se in zip(estimates, std_errors)]
    return [np.array(estimates) - np.array(ci_lower), np.array(ci_upper) - np.array(estimates)]

# PANEL A: BOYS
# Combine Wave 1 and Wave 2 data for boys
boy_variables = boy_w1_variables + boy_w2_variables
boy_estimates = boy_w1_estimates + boy_w2_estimates
boy_std_errors = boy_w1_std_errors + boy_w2_std_errors
boy_significance = boy_w1_significance + boy_w2_significance
boy_waves = ["Wave 1"] * len(boy_w1_variables) + ["Wave 2"] * len(boy_w2_variables)

# Sort by wave and then by absolute value of estimate (for clearer visualization)
boy_sort_idx = np.argsort([1 if w == "Wave 1" else 2 for w in boy_waves])
boy_variables = [boy_variables[i] for i in boy_sort_idx]
boy_estimates = [boy_estimates[i] for i in boy_sort_idx]
boy_std_errors = [boy_std_errors[i] for i in boy_sort_idx]
boy_significance = [boy_significance[i] for i in boy_sort_idx]
boy_waves = [boy_waves[i] for i in boy_sort_idx]

# Plot boys data
y_pos_boy = np.arange(len(boy_variables))
boy_errors = calc_ci(boy_estimates, boy_std_errors)

# Plot the lines for boys without adding labels to the legend yet
for i, (est, err_low, err_high, wave) in enumerate(zip(
        boy_estimates, boy_errors[0], boy_errors[1], boy_waves)):
    color = 'orange' if wave == "Wave 1" else 'gold'
    ax1.errorbar(est, i, xerr=[[err_low], [err_high]], fmt='o', color=color, capsize=5)

# Now add the legend entries manually (just once for each wave)
ax1.errorbar([], [], fmt='o', color='orange', label='Wave 1', capsize=5)
ax1.errorbar([], [], fmt='o', color='gold', label='Wave 2', capsize=5)

# Configure boy axis
ax1.set_yticks(y_pos_boy)
ax1.set_yticklabels(boy_variables)
ax1.axvline(x=0, color='gray', linestyle='--', alpha=0.7)
ax1.set_title("Boys: Significant Factors in Father Absence Impact on Maths Achievement (p<0.05)", 
             fontsize=12, fontweight='bold')
ax1.legend(loc='upper right')

# Add significance markers for boys
for i, (est, sig) in enumerate(zip(boy_estimates, boy_significance)):
    ax1.text(est + (0.03 if est >= 0 else -0.03), i, sig, 
            fontsize=12, verticalalignment='center', color='red',
            horizontalalignment='left' if est >= 0 else 'right')

# Add dividers between waves for boys
wave1_end = boy_waves.index("Wave 2") if "Wave 2" in boy_waves else len(boy_waves)
if wave1_end < len(boy_waves):
    ax1.axhline(y=wave1_end-0.5, color='black', linestyle='-', alpha=0.3)

# PANEL B: GIRLS
# Combine Wave 1 and Wave 2 data for girls
girl_variables = girl_w1_variables + girl_w2_variables
girl_estimates = girl_w1_estimates + girl_w2_estimates
girl_std_errors = girl_w1_std_errors + girl_w2_std_errors
girl_significance = girl_w1_significance + girl_w2_significance
girl_waves = ["Wave 1"] * len(girl_w1_variables) + ["Wave 2"] * len(girl_w2_variables)

# Sort by wave and then by absolute value of estimate
girl_sort_idx = np.argsort([1 if w == "Wave 1" else 2 for w in girl_waves])
girl_variables = [girl_variables[i] for i in girl_sort_idx]
girl_estimates = [girl_estimates[i] for i in girl_sort_idx]
girl_std_errors = [girl_std_errors[i] for i in girl_sort_idx]
girl_significance = [girl_significance[i] for i in girl_sort_idx]
girl_waves = [girl_waves[i] for i in girl_sort_idx]

# Plot girls data
y_pos_girl = np.arange(len(girl_variables))
girl_errors = calc_ci(girl_estimates, girl_std_errors)

# Plot the lines for girls without adding labels to the legend yet
for i, (est, err_low, err_high, wave) in enumerate(zip(
        girl_estimates, girl_errors[0], girl_errors[1], girl_waves)):
    color = 'purple' if wave == "Wave 1" else 'red'
    ax2.errorbar(est, i, xerr=[[err_low], [err_high]], fmt='o', color=color, capsize=5)

# Now add the legend entries manually (just once for each wave)
ax2.errorbar([], [], fmt='o', color='purple', label='Wave 1', capsize=5)
ax2.errorbar([], [], fmt='o', color='red', label='Wave 2', capsize=5)

# Configure girl axis
ax2.set_yticks(y_pos_girl)
ax2.set_yticklabels(girl_variables)
ax2.axvline(x=0, color='gray', linestyle='--', alpha=0.7)
ax2.set_title("Girls: Significant Factors in Father Absence Impact on Maths Achievement (p<0.05)", 
             fontsize=12, fontweight='bold')
ax2.set_xlabel("Estimated Contribution to Maths Points (Father Present - Father Absent)")
ax2.legend(loc='upper right')

# Add significance markers for girls
for i, (est, sig) in enumerate(zip(girl_estimates, girl_significance)):
    ax2.text(est + (0.03 if est >= 0 else -0.03), i, sig, 
            fontsize=12, verticalalignment='center', color='red',
            horizontalalignment='left' if est >= 0 else 'right')

# Add dividers between waves for girls
wave1_end = girl_waves.index("Wave 2") if "Wave 2" in girl_waves else len(girl_waves)
if wave1_end < len(girl_waves):
    ax2.axhline(y=wave1_end-0.5, color='black', linestyle='-', alpha=0.3)

# Final adjustments for both panels
plt.tight_layout()
plt.subplots_adjust(left=0.3, hspace=0.25)  # Add more space on the left AND between panels

# Set the same x-axis limits for both panels for better comparison
x_min = min(min(boy_estimates) - max(boy_errors[0]), min(girl_estimates) - max(girl_errors[0]))
x_max = max(max(boy_estimates) + max(boy_errors[1]), max(girl_estimates) + max(girl_errors[1]))
x_range = x_max - x_min
ax1.set_xlim(x_min - 0.1 * x_range, x_max + 0.1 * x_range)
ax2.set_xlim(x_min - 0.1 * x_range, x_max + 0.1 * x_range)

# Remove the extra text that says "Wave 1" and "Wave 2" at the dividing lines
# This is handled by the legend now

plt.savefig('father_absence_significant_factors.png', dpi=300, bbox_inches='tight')
plt.show()






import matplotlib.pyplot as plt
import numpy as np

# BOYS - Significant variables (p<0.05 or better)
# Wave 1 (Age 9)
boy_w1_variables = [
    "Maths Ability (E)",
    "Constant (C)"
]
boy_w1_estimates = [
    0.222,        # Maths Ability (E)
    0.710         # Constant (C)
]
boy_w1_std_errors = [
    0.064,        # Maths Ability (E)
    0.345         # Constant (C)
]
boy_w1_significance = ["***", "**"]

# Wave 2 (Age 13)
boy_w2_variables = [
    "Verbal Reasoning (E)",
    "Numerical Ability (E)",
    "BAS Matrices (E)"
]
boy_w2_estimates = [
    0.121,        # Verbal Reasoning (E)
    0.295,        # Numerical Ability (E)
    0.085         # BAS Matrices (E)
]
boy_w2_std_errors = [
    0.043,        # Verbal Reasoning (E)
    0.081,        # Numerical Ability (E)
    0.033         # BAS Matrices (E)
]
boy_w2_significance = ["***", "***", "***"]

# GIRLS - Significant variables (p<0.05 or better)
# Wave 1 (Age 9)
girl_w1_variables = [
    "Reading Ability (E)",
    "Maths Ability (E)",
    "Mother's Educ. (Higher 2ndary/Tech) (C)"
]
girl_w1_estimates = [
    0.090,        # Reading Ability (E)
    0.162,        # Maths Ability (E)
    0.381         # Mother's Educ. (Higher 2ndary/Tech) (C)
]
girl_w1_std_errors = [
    0.044,        # Reading Ability (E)
    0.045,        # Maths Ability (E)
    0.145         # Mother's Educ. (Higher 2ndary/Tech) (C)
]
girl_w1_significance = ["**", "***", "***"]

# Wave 2 (Age 13)
girl_w2_variables = [
    "Verbal Reasoning (E)",
    "Numerical Ability (E)",
    "Numerical Ability (C)",
    "Numerical Ability (I)",
    "BAS Matrices (E)",
    "Hyperactivity (E)",
    "Mother's Educ. (Higher 2ndary/Tech) (C)"
]
girl_w2_estimates = [
    0.097,        # Verbal Reasoning (E)
    0.373,        # Numerical Ability (E)
    0.154,        # Numerical Ability (C)
    -0.143,       # Numerical Ability (I)
    0.043,        # BAS Matrices (E)
    0.071,        # Hyperactivity (E)
    0.389         # Mother's Educ. (Higher 2ndary/Tech) (C)
]
girl_w2_std_errors = [
    0.041,        # Verbal Reasoning (E)
    0.080,        # Numerical Ability (E)
    0.058,        # Numerical Ability (C)
    0.055,        # Numerical Ability (I)
    0.022,        # BAS Matrices (E)
    0.027,        # Hyperactivity (E)
    0.162         # Mother's Educ. (Higher 2ndary/Tech) (C)
]
girl_w2_significance = ["**", "***", "***", "***", "**", "***", "**"]

# Create subplots with two rows (one for each gender) and increased figure size
fig, (ax1, ax2) = plt.subplots(2, 1, figsize=(16, 14), sharex=True)
plt.subplots_adjust(left=0.35)  # Add more space on the left for labels

# Function to calculate confidence intervals
def calc_ci(estimates, std_errors):
    ci_lower = [est - 1.96 * se for est, se in zip(estimates, std_errors)]
    ci_upper = [est + 1.96 * se for est, se in zip(estimates, std_errors)]
    return [np.array(estimates) - np.array(ci_lower), np.array(ci_upper) - np.array(estimates)]

# Function to create improved plot formatting
def format_subplot(ax, variables, estimates, std_errors, significance, waves, 
                  title, wave1_color, wave2_color):
    y_pos = np.arange(len(variables))
    errors = calc_ci(estimates, std_errors)
    
    # Plot the data points with error bars
    for i, (est, err_low, err_high, wave) in enumerate(zip(
            estimates, errors[0], errors[1], waves)):
        color = wave1_color if wave == "Wave 1" else wave2_color
        marker_size = 10  # Increase marker size
        line_width = 2    # Increase error bar line width
        ax.errorbar(est, i, xerr=[[err_low], [err_high]], fmt='o', color=color, 
                   capsize=5, markersize=marker_size, elinewidth=line_width)
    
    # Add significance markers with improved positioning
    for i, (est, sig) in enumerate(zip(estimates, significance)):
        # Position text based on error bar length to avoid overlap
        error_length = errors[1][i]  # Use the right side error bar length
        offset = 0.05 + error_length * 0.5  # Adaptive offset
        
        ax.text(est + offset if est >= 0 else est - offset, i, sig, 
                fontsize=12, verticalalignment='center', color='red',
                horizontalalignment='left' if est >= 0 else 'right',
                fontweight='bold')  # Make significance markers bold
    
    # Set up the y-axis labels with improved font size
    ax.set_yticks(y_pos)
    ax.set_yticklabels(variables, fontsize=11)
    
    # Add zero reference line
    ax.axvline(x=0, color='gray', linestyle='--', alpha=0.7, linewidth=1.5)
    
    # Add dividers between waves
    wave1_end = waves.index("Wave 2") if "Wave 2" in waves else len(waves)
    if wave1_end < len(waves):
        ax.axhline(y=wave1_end-0.5, color='black', linestyle='-', alpha=0.3, linewidth=1.5)
    
    # Add wave labels on the right side of the plot
    wave1_y = wave1_end - (wave1_end / 2) - 0.5
    wave2_y = wave1_end + ((len(waves) - wave1_end) / 2) - 0.5
    
    ax.text(1.02, wave1_y, "Wave 1 (Age 9)", transform=ax.transAxes, 
            verticalalignment='center', fontsize=12, fontweight='bold')
    ax.text(1.02, wave2_y, "Wave 2 (Age 13)", transform=ax.transAxes, 
            verticalalignment='center', fontsize=12, fontweight='bold')
    
    # Set title with improved formatting
    ax.set_title(title, fontsize=14, fontweight='bold', pad=20)
    
    # Add legend with better positioning (upper right corner)
    ax.errorbar([], [], fmt='o', color=wave1_color, label='Wave 1', markersize=10)
    ax.errorbar([], [], fmt='o', color=wave2_color, label='Wave 2', markersize=10)
    legend = ax.legend(loc='upper right', fontsize=12, frameon=True)
    legend.get_frame().set_alpha(0.9)
    
    # Add subtle grid lines for easier reading
    ax.grid(axis='x', linestyle=':', color='gray', alpha=0.3)

# PANEL A: BOYS
# Combine and sort data for boys
boy_variables = boy_w1_variables + boy_w2_variables
boy_estimates = boy_w1_estimates + boy_w2_estimates
boy_std_errors = boy_w1_std_errors + boy_w2_std_errors
boy_significance = boy_w1_significance + boy_w2_significance
boy_waves = ["Wave 1"] * len(boy_w1_variables) + ["Wave 2"] * len(boy_w2_variables)

# Sort by wave and estimate size
boy_sort_idx = np.argsort([1 if w == "Wave 1" else 2 for w in boy_waves])
boy_variables = [boy_variables[i] for i in boy_sort_idx]
boy_estimates = [boy_estimates[i] for i in boy_sort_idx]
boy_std_errors = [boy_std_errors[i] for i in boy_sort_idx]
boy_significance = [boy_significance[i] for i in boy_sort_idx]
boy_waves = [boy_waves[i] for i in boy_sort_idx]

# PANEL B: GIRLS
# Combine and sort data for girls
girl_variables = girl_w1_variables + girl_w2_variables
girl_estimates = girl_w1_estimates + girl_w2_estimates
girl_std_errors = girl_w1_std_errors + girl_w2_std_errors
girl_significance = girl_w1_significance + girl_w2_significance
girl_waves = ["Wave 1"] * len(girl_w1_variables) + ["Wave 2"] * len(girl_w2_variables)

# Sort by wave
girl_sort_idx = np.argsort([1 if w == "Wave 1" else 2 for w in girl_waves])
girl_variables = [girl_variables[i] for i in girl_sort_idx]
girl_estimates = [girl_estimates[i] for i in girl_sort_idx]
girl_std_errors = [girl_std_errors[i] for i in girl_sort_idx]
girl_significance = [girl_significance[i] for i in girl_sort_idx]
girl_waves = [girl_waves[i] for i in girl_sort_idx]

# Format each subplot with improved colors
# For better contrast, use darker, more distinguishable colors
format_subplot(ax1, boy_variables, boy_estimates, boy_std_errors, boy_significance, boy_waves,
              "Boys: Significant Factors in Father Absence Impact on Maths Achievement (p<0.05)",
              'orange', 'gold')  # Orange for Wave 1, Dark Orange for Wave 2

format_subplot(ax2, girl_variables, girl_estimates, girl_std_errors, girl_significance, girl_waves,
              "Girls: Significant Factors in Father Absence Impact on Maths Achievement (p<0.05)",
              '#9370DB', '#CC0000')  # Medium Purple for Wave 1, Dark Red for Wave 2

# Set common x-axis label with better positioning
fig.text(0.5, 0.01, "Estimated Contribution to Maths Points (Father Present - Father Absent)", 
         ha='center', fontsize=14, fontweight='bold')

# Set the same x-axis limits for both panels with added padding
x_min = min(min(boy_estimates) - max(boy_errors[0]), min(girl_estimates) - max(girl_errors[0]))
x_max = max(max(boy_estimates) + max(boy_errors[1]), max(girl_estimates) + max(girl_errors[1]))
x_range = x_max - x_min
padding = 0.15  # Increase padding for better spacing
ax1.set_xlim(x_min - padding * x_range, x_max + padding * x_range)
ax2.set_xlim(x_min - padding * x_range, x_max + padding * x_range)

# Add x-axis ticks with better spacing
x_ticks = np.arange(np.floor(x_min - padding * x_range * 0.8) * 0.5, 
                    np.ceil(x_max + padding * x_range * 0.8) * 0.5 + 0.1, 0.5)
ax2.set_xticks(x_ticks)
ax2.set_xticklabels([str(x) for x in x_ticks], fontsize=12)

# Final layout adjustments
plt.tight_layout()
plt.subplots_adjust(left=0.38, right=0.85, bottom=0.06, top=0.95, hspace=0.3)

plt.savefig('improved_father_absence_plot.png', dpi=300, bbox_inches='tight')
plt.show()



import matplotlib.pyplot as plt
import numpy as np

# BOYS - Significant variables (p<0.05 or better)
# Wave 1 (Age 9)
boy_w1_variables = [
    "Maths Ability (E)",
    "Constant (C)"
]
boy_w1_estimates = [
    0.222,        # Maths Ability (E)
    0.710         # Constant (C)
]
boy_w1_std_errors = [
    0.064,        # Maths Ability (E)
    0.345         # Constant (C)
]
boy_w1_significance = ["***", "**"]

# Wave 2 (Age 13)
boy_w2_variables = [
    "Verbal Reasoning (E)",
    "Numerical Ability (E)",
    "BAS Matrices (E)"
]
boy_w2_estimates = [
    0.121,        # Verbal Reasoning (E)
    0.295,        # Numerical Ability (E)
    0.085         # BAS Matrices (E)
]
boy_w2_std_errors = [
    0.043,        # Verbal Reasoning (E)
    0.081,        # Numerical Ability (E)
    0.033         # BAS Matrices (E)
]
boy_w2_significance = ["***", "***", "***"]

# GIRLS - Significant variables (p<0.05 or better)
# Wave 1 (Age 9)
girl_w1_variables = [
    "Reading Ability (E)",
    "Maths Ability (E)",
    "Mother's Educ. (Higher 2ndary/Tech) (C)"
]
girl_w1_estimates = [
    0.090,        # Reading Ability (E)
    0.162,        # Maths Ability (E)
    0.381         # Mother's Educ. (Higher 2ndary/Tech) (C)
]
girl_w1_std_errors = [
    0.044,        # Reading Ability (E)
    0.045,        # Maths Ability (E)
    0.145         # Mother's Educ. (Higher 2ndary/Tech) (C)
]
girl_w1_significance = ["**", "***", "***"]

# Wave 2 (Age 13)
girl_w2_variables = [
    "Verbal Reasoning (E)",
    "Numerical Ability (E)",
    "Numerical Ability (C)",
    "Numerical Ability (I)",
    "BAS Matrices (E)",
    "Hyperactivity (E)",
    "Mother's Educ. (Higher 2ndary/Tech) (C)"
]
girl_w2_estimates = [
    0.097,        # Verbal Reasoning (E)
    0.373,        # Numerical Ability (E)
    0.154,        # Numerical Ability (C)
    -0.143,       # Numerical Ability (I)
    0.043,        # BAS Matrices (E)
    0.071,        # Hyperactivity (E)
    0.389         # Mother's Educ. (Higher 2ndary/Tech) (C)
]
girl_w2_std_errors = [
    0.041,        # Verbal Reasoning (E)
    0.080,        # Numerical Ability (E)
    0.058,        # Numerical Ability (C)
    0.055,        # Numerical Ability (I)
    0.022,        # BAS Matrices (E)
    0.027,        # Hyperactivity (E)
    0.162         # Mother's Educ. (Higher 2ndary/Tech) (C)
]
girl_w2_significance = ["**", "***", "***", "***", "**", "***", "**"]

# Create figure with two separate panels (each in its own figure)
fig_boy = plt.figure(figsize=(10, 6))
ax_boy = fig_boy.add_subplot(111)

fig_girl = plt.figure(figsize=(10, 8))
ax_girl = fig_girl.add_subplot(111)

# Function to calculate confidence intervals
def calc_ci(estimates, std_errors):
    ci_lower = [est - 1.96 * se for est, se in zip(estimates, std_errors)]
    ci_upper = [est + 1.96 * se for est, se in zip(estimates, std_errors)]
    return [np.array(estimates) - np.array(ci_lower), np.array(ci_upper) - np.array(estimates)]

# Function to create improved plot formatting
def format_subplot(ax, variables, estimates, std_errors, significance, waves, 
                  title, wave1_color, wave2_color):
    y_pos = np.arange(len(variables))
    errors = calc_ci(estimates, std_errors)
    
    # Plot the data points with error bars
    for i, (est, err_low, err_high, wave) in enumerate(zip(
            estimates, errors[0], errors[1], waves)):
        color = wave1_color if wave == "Wave 1" else wave2_color
        marker_size = 10  # Increase marker size
        line_width = 2    # Increase error bar line width
        ax.errorbar(est, i, xerr=[[err_low], [err_high]], fmt='o', color=color, 
                   capsize=5, markersize=marker_size, elinewidth=line_width)
    
    # Add significance markers with improved positioning
    for i, (est, sig) in enumerate(zip(estimates, significance)):
        # Position text based on error bar length to avoid overlap
        error_length = errors[1][i]  # Use the right side error bar length
        offset = 0.05 + error_length * 0.5  # Adaptive offset
        
        ax.text(est + offset if est >= 0 else est - offset, i, sig, 
                fontsize=12, verticalalignment='center', color='red',
                horizontalalignment='left' if est >= 0 else 'right',
                fontweight='bold')  # Make significance markers bold
    
    # Set up the y-axis labels with improved font size
    ax.set_yticks(y_pos)
    ax.set_yticklabels(variables, fontsize=11)
    
    # Add zero reference line
    ax.axvline(x=0, color='gray', linestyle='--', alpha=0.7, linewidth=1.5)
    
    # Add dividers between waves
    wave1_end = waves.index("Wave 2") if "Wave 2" in waves else len(waves)
    if wave1_end < len(waves):
        ax.axhline(y=wave1_end-0.5, color='black', linestyle='-', alpha=0.3, linewidth=1.5)
    
    # Add wave labels on the right side of the plot
    wave1_y = wave1_end - (wave1_end / 2) - 0.5
    wave2_y = wave1_end + ((len(waves) - wave1_end) / 2) - 0.5
    
    ax.text(1.02, wave1_y / len(variables), "Wave 1 (Age 9)", transform=ax.transAxes, 
            verticalalignment='center', fontsize=12, fontweight='bold')
    ax.text(1.02, wave2_y / len(variables), "Wave 2 (Age 13)", transform=ax.transAxes, 
            verticalalignment='center', fontsize=12, fontweight='bold')
    
    # Set title with improved formatting
    ax.set_title(title, fontsize=14, fontweight='bold', pad=20)
    
    # Add legend with better positioning
    ax.errorbar([], [], fmt='o', color=wave1_color, label='Wave 1', markersize=10)
    ax.errorbar([], [], fmt='o', color=wave2_color, label='Wave 2', markersize=10)
    legend = ax.legend(loc='upper right', fontsize=12, frameon=True)
    legend.get_frame().set_alpha(0.9)
    
    # Add subtle grid lines for easier reading
    ax.grid(axis='x', linestyle=':', color='gray', alpha=0.3)
    
    # Add x-axis label
    ax.set_xlabel("Estimated Contribution to Maths Points (Father Present - Father Absent)", 
                fontsize=12, fontweight='bold')
    
    return errors

# PANEL A: BOYS
# Combine and sort data for boys
boy_variables = boy_w1_variables + boy_w2_variables
boy_estimates = boy_w1_estimates + boy_w2_estimates
boy_std_errors = boy_w1_std_errors + boy_w2_std_errors
boy_significance = boy_w1_significance + boy_w2_significance
boy_waves = ["Wave 1"] * len(boy_w1_variables) + ["Wave 2"] * len(boy_w2_variables)

# Sort by wave and estimate size
boy_sort_idx = np.argsort([1 if w == "Wave 1" else 2 for w in boy_waves])
boy_variables = [boy_variables[i] for i in boy_sort_idx]
boy_estimates = [boy_estimates[i] for i in boy_sort_idx]
boy_std_errors = [boy_std_errors[i] for i in boy_sort_idx]
boy_significance = [boy_significance[i] for i in boy_sort_idx]
boy_waves = [boy_waves[i] for i in boy_sort_idx]

# PANEL B: GIRLS
# Combine and sort data for girls
girl_variables = girl_w1_variables + girl_w2_variables
girl_estimates = girl_w1_estimates + girl_w2_estimates
girl_std_errors = girl_w1_std_errors + girl_w2_std_errors
girl_significance = girl_w1_significance + girl_w2_significance
girl_waves = ["Wave 1"] * len(girl_w1_variables) + ["Wave 2"] * len(girl_w2_variables)

# Sort by wave
girl_sort_idx = np.argsort([1 if w == "Wave 1" else 2 for w in girl_waves])
girl_variables = [girl_variables[i] for i in girl_sort_idx]
girl_estimates = [girl_estimates[i] for i in girl_sort_idx]
girl_std_errors = [girl_std_errors[i] for i in girl_sort_idx]
girl_significance = [girl_significance[i] for i in girl_sort_idx]
girl_waves = [girl_waves[i] for i in girl_sort_idx]

# Format each panel with improved colors
boy_errors = format_subplot(ax_boy, boy_variables, boy_estimates, boy_std_errors, boy_significance, boy_waves,
              "Boys: Significant Factors in Father Absence Impact on Maths Achievement (p<0.05)",
              'orange', 'gold')  # Orange for Wave 1, Dark Orange for Wave 2

girl_errors = format_subplot(ax_girl, girl_variables, girl_estimates, girl_std_errors, girl_significance, girl_waves,
              "Girls: Significant Factors in Father Absence Impact on Maths Achievement (p<0.05)",
              '#9370DB', '#CC0000')  # Medium Purple for Wave 1, Dark Red for Wave 2

# Set x-axis limits with added padding for both plots
# Calculate common x-limits for consistency across plots
x_min = min(min(boy_estimates) - max(boy_errors[0]), min(girl_estimates) - max(girl_errors[0]))
x_max = max(max(boy_estimates) + max(boy_errors[1]), max(girl_estimates) + max(girl_errors[1]))
x_range = x_max - x_min
padding = 0.15  # Increase padding for better spacing

# Apply common x-limits to both plots
ax_boy.set_xlim(x_min - padding * x_range, x_max + padding * x_range)
ax_girl.set_xlim(x_min - padding * x_range, x_max + padding * x_range)

# Add x-axis ticks with better spacing
x_ticks = np.arange(np.floor(x_min - padding * x_range * 0.8) * 0.5, 
                   np.ceil(x_max + padding * x_range * 0.8) * 0.5 + 0.1, 0.5)
ax_boy.set_xticks(x_ticks)
ax_boy.set_xticklabels([str(x) for x in x_ticks], fontsize=12)
ax_girl.set_xticks(x_ticks)
ax_girl.set_xticklabels([str(x) for x in x_ticks], fontsize=12)

# Adjust layout and margins
plt.tight_layout()
fig_boy.subplots_adjust(left=0.35, right=0.85)
fig_girl.subplots_adjust(left=0.35, right=0.85)

# Save each plot separately
fig_boy.savefig('boys_father_absence_plot.png', dpi=300, bbox_inches='tight')
fig_girl.savefig('girls_father_absence_plot.png', dpi=300, bbox_inches='tight')

# Display plots
plt.figure(fig_boy.number)
plt.figure(fig_girl.number)
plt.show()




# RESULTS FOR ENGLISH


import matplotlib.pyplot as plt
import numpy as np

# Categories for decomposition components
categories = ["Endowments", "Coefficients", "Interaction"]

# Values and errors for English decomposition (without and with father's education)
# Using the numbers from the output you provided
without_father_values = [-0.0104354, 0.2726971, 0.0444101]  # Without father values
without_father_errors = [0.0264448, 0.0346225, 0.0180742]   # Without father standard errors
with_father_values = [0.0042747, 0.317164, 0.0312898]       # With father values
with_father_errors = [0.0280289, 0.0347693, 0.021133]       # With father standard errors

# P-values from the output
without_father_pvalues = [0.693, 0.000, 0.014]  # Without father p-values
with_father_pvalues = [0.879, 0.000, 0.139]     # With father p-values

# Assign stars based on significance levels
def significance_stars(p_values):
    return ['***' if p <= 0.01 else '**' if p <= 0.05 else '*' if p <= 0.1 else '' for p in p_values]

without_father_stars = significance_stars(without_father_pvalues)
with_father_stars = significance_stars(with_father_pvalues)

# X locations for the groups
x = np.arange(len(categories))
width = 0.35

fig, ax = plt.subplots(figsize=(10, 6))
bars1 = ax.bar(x - width/2, without_father_values, width, yerr=without_father_errors, capsize=5, 
              label="Without Father's Education", color="lightblue")
bars2 = ax.bar(x + width/2, with_father_values, width, yerr=with_father_errors, capsize=5, 
              label="With Father's Education", color="blue")

# Adding stars above bars for significance
for bars, stars in zip([bars1, bars2], [without_father_stars, with_father_stars]):
    for bar, star in zip(bars, stars):
        height = bar.get_height()
        y_pos = height + 0.02 if height >= 0 else height - 0.05
        ax.text(bar.get_x() + bar.get_width()/2, y_pos, star, ha='center', va='bottom', 
               fontsize=12, fontweight='bold')

# Labels and Titles
ax.set_xlabel("Decomposition Components", labelpad=10)
ax.set_ylabel("Estimated Contribution to English Points (Girls - Boys)")
ax.set_title("Oaxaca Decomposition: English Points (Girls vs. Boys) - Wave 1")
ax.set_xticks(x)
ax.set_xticklabels(categories)
ax.axhline(0, color='black', linewidth=0.8)  # Zero line

# Manually setting the legend
legend_labels = ["Without Father's Education", "With Father's Education"]
ax.legend([bars1[0], bars2[0]], legend_labels, title="Comparison Groups")

# Annotating the mean English points for each group
without_father_group1_mean = 10.29868  # Female, without father's education
without_father_group2_mean = 9.992004   # Male, without father's education
with_father_group1_mean = 10.39805     # Female, with father's education
with_father_group2_mean = 10.04532     # Male, with father's education

annotation_text = (f"Mean English Points:\n"
                  f"Without Father's Education -\n"
                  f"Girls: {without_father_group1_mean:.2f}, Boys: {without_father_group2_mean:.2f}\n"
                  f"With Father's Education - \n"
                  f"Girls: {with_father_group1_mean:.2f}, Boys: {with_father_group2_mean:.2f}")

ax.text(-0.25, ax.get_ylim()[0] + 0.25, annotation_text, fontsize=10, 
       bbox=dict(facecolor='white', edgecolor='black', boxstyle='round,pad=0.5'))

plt.tight_layout()
plt.show()



import matplotlib.pyplot as plt
import numpy as np

# Categories for decomposition components
categories = ["Endowments", "Coefficients", "Interaction"]

# Values and errors for the two Oaxaca decompositions (without and with father's education) for Wave 2 English
# Using the values from the output you provided
without_father_values = [-0.1228065, 0.4311396, -0.0016613]  # Without father values
without_father_errors = [0.0312956, 0.0359525, 0.0215022]    # Without father standard errors
with_father_values = [-0.1084299, 0.4412015, -0.0082543]     # With father values
with_father_errors = [0.0301929, 0.0381966, 0.0242145]       # With father standard errors

# P-values from the output
without_father_pvalues = [0.000, 0.000, 0.938]  # Without father p-values
with_father_pvalues = [0.000, 0.000, 0.733]     # With father p-values

# Assign stars based on significance levels
def significance_stars(p_values):
    return ['***' if p <= 0.01 else '**' if p <= 0.05 else '*' if p <= 0.1 else '' for p in p_values]

without_father_stars = significance_stars(without_father_pvalues)
with_father_stars = significance_stars(with_father_pvalues)

# X locations for the groups
x = np.arange(len(categories))
width = 0.35

fig, ax = plt.subplots(figsize=(10, 6))
bars1 = ax.bar(x - width/2, without_father_values, width, yerr=without_father_errors, capsize=5, 
              label="Without Father's Education", color="lightgreen")
bars2 = ax.bar(x + width/2, with_father_values, width, yerr=with_father_errors, capsize=5, 
              label="With Father's Education", color="darkgreen")

# Adding stars above bars for significance
for bars, stars in zip([bars1, bars2], [without_father_stars, with_father_stars]):
    for bar, star in zip(bars, stars):
        height = bar.get_height()
        y_pos = height + 0.02 if height >= 0 else height - 0.05
        ax.text(bar.get_x() + bar.get_width()/2, y_pos, star, ha='center', va='bottom', 
               fontsize=12, fontweight='bold')

# Labels and Titles
ax.set_xlabel("Decomposition Components", labelpad=10)
ax.set_ylabel("Estimated Contribution to English Points (Girls - Boys)")
ax.set_title("Oaxaca Decomposition: English Points (Girls vs. Boys) - Wave 2")
ax.set_xticks(x)
ax.set_xticklabels(categories)
ax.axhline(0, color='black', linewidth=0.8)  # Zero line

# Manually setting the legend
legend_labels = ["Without Father's Education", "With Father's Education"]
ax.legend([bars1[0], bars2[0]], legend_labels, title="Comparison Groups")

# Annotating the mean English points for each group
without_father_group1_mean = 10.29868  # Girls (group_1)
without_father_group2_mean = 9.992004   # Boys (group_2)
with_father_group1_mean = 10.40673     # Girls (group_1)
with_father_group2_mean = 10.08221     # Boys (group_2)

annotation_text = (f"Mean English Points:\n"
                  f"Without Father's Education -\n"
                  f"Girls: {without_father_group1_mean:.2f}, Boys: {without_father_group2_mean:.2f}\n"
                  f"With Father's Education - \n"
                  f"Girls: {with_father_group1_mean:.2f}, Boys: {with_father_group2_mean:.2f}")

ax.text(1.5, ax.get_ylim()[0] + 0.3, annotation_text, fontsize=10, 
       bbox=dict(facecolor='white', edgecolor='black', boxstyle='round,pad=0.5'))

plt.tight_layout()
plt.show()



import matplotlib.pyplot as plt
import numpy as np

# Data for the sample WITHOUT the father (from table)
# Only including variables significant at p<0.05 or better
variables_without_father = [
    "Maths Ability (E)",
    "Hyperactivity (E)",
    "Mother's Educ. (Bachelor's/Postgrad) (E)",
    "Mixed School (C)",
    "Mixed School (I)"
]
estimates_without_father = [
    -0.038,        # Maths Ability (E)
    0.043,         # Hyperactivity (E)
    -0.018,        # Mother's Educ. (Bachelor's/Postgrad) (E)
    0.208,         # Mixed School (C)
    0.035          # Mixed School (I)
]
# Standard errors from the table
std_errors_without_father = [
    0.008,         # Maths Ability (E)
    0.008,         # Hyperactivity (E)
    0.009,         # Mother's Educ. (Bachelor's/Postgrad) (E)
    0.063,         # Mixed School (C)
    0.011          # Mixed School (I)
]
# Confidence intervals at 95% level (approximating from 1.96 * SE)
ci_lower_without_father = [
    est - 1.96 * se for est, se in zip(estimates_without_father, std_errors_without_father)
]
ci_upper_without_father = [
    est + 1.96 * se for est, se in zip(estimates_without_father, std_errors_without_father)
]
significance_without_father = ["***", "***", "**", "***", "***"]

# Data for the sample WITH the father
# Only including variables significant at p<0.05 or better
variables_with_father = [
    "Maths Ability (E)",
    "Conduct Problems (E)",
    "Hyperactivity (E)",
    "Mixed School (C)",
    "Mixed School (I)"
]
estimates_with_father = [
    -0.034,        # Maths Ability (E)
    0.010,         # Conduct Problems (E)
    0.043,         # Hyperactivity (E)
    0.204,         # Mixed School (C)
    0.033          # Mixed School (I)
]
std_errors_with_father = [
    0.009,         # Maths Ability (E)
    0.004,         # Conduct Problems (E)
    0.009,         # Hyperactivity (E)
    0.061,         # Mixed School (C)
    0.011          # Mixed School (I)
]
# Confidence intervals at 95% level
ci_lower_with_father = [
    est - 1.96 * se for est, se in zip(estimates_with_father, std_errors_with_father)
]
ci_upper_with_father = [
    est + 1.96 * se for est, se in zip(estimates_with_father, std_errors_with_father)
]
significance_with_father = ["***", "**", "***", "***", "***"]

# Combine both sets of data
variables = variables_without_father + variables_with_father
estimates = estimates_without_father + estimates_with_father
ci_lower = ci_lower_without_father + ci_lower_with_father
ci_upper = ci_upper_without_father + ci_upper_with_father
significance = significance_without_father + significance_with_father

# Convert lists to NumPy arrays
y_pos = np.arange(len(variables))
errors = [np.array(estimates) - np.array(ci_lower), np.array(ci_upper) - np.array(estimates)]

# Define split index for separating sections
split_index = len(variables_without_father)

# Plot
fig, ax = plt.subplots(figsize=(12, 8))
ax.errorbar(estimates, y_pos, xerr=errors, fmt='o', color='b', capsize=5, label="Estimate ± 95% CI")
ax.axvline(x=0, color='gray', linestyle='--', alpha=0.7)
ax.axhline(y=split_index - 0.5, color='black', linestyle='-', linewidth=1)
ax.set_yticks(y_pos)
ax.set_yticklabels(variables)
ax.set_xlabel("Estimate")

# Categorize variables with labels (E=Endowments, C=Coefficients, I=Interaction)
ax.set_title("Significant Oaxaca-Blinder Decomposition Estimates (Girls - Boys) for English - Wave 1\nE=Endowments, C=Coefficients, I=Interaction (p<0.05 or better)")
ax.invert_yaxis()

# Add section labels in the top right
ax.text(ax.get_xlim()[1] - 0.01, split_index - 0.75, "Excluding Father's Education", fontsize=10, fontweight='bold', ha='right')
ax.text(ax.get_xlim()[1] - 0.01, split_index + 0.75, "Including Father's Education", fontsize=10, fontweight='bold', ha='right')

# Add significance markers
for i, (est, sig) in enumerate(zip(estimates, significance)):
    ax.text(est + (0.02 if est >= 0 else -0.02), i, sig, fontsize=12, verticalalignment='center', 
            color='red', horizontalalignment='left' if est >= 0 else 'right')

plt.tight_layout()
plt.show()




import matplotlib.pyplot as plt
import numpy as np

# Data for the sample WITHOUT the father (from table)
# Only including variables significant at p<0.05 or better (not p<0.1)
variables_without_father = [
    "Verbal Reasoning (E)",
    "Numerical Ability (E)",
    "Hyperactivity (E)",
    "Mother's Educ. (Bachelor's/Postgrad) (E)"
]
estimates_without_father = [
    -0.086,        # Verbal Reasoning (E)
    -0.087,        # Numerical Ability (E)
    0.055,         # Hyperactivity (E)
    -0.015         # Mother's Educ. (Bachelor's/Postgrad) (E)
]
# Calculate confidence intervals from standard errors
std_errors_without_father = [
    0.015,         # Verbal Reasoning (E)
    0.013,         # Numerical Ability (E)
    0.009,         # Hyperactivity (E)
    0.007          # Mother's Educ. (Bachelor's/Postgrad) (E)
]
# Confidence intervals at 95% level (approximating from 1.96 * SE)
ci_lower_without_father = [
    est - 1.96 * se for est, se in zip(estimates_without_father, std_errors_without_father)
]
ci_upper_without_father = [
    est + 1.96 * se for est, se in zip(estimates_without_father, std_errors_without_father)
]
significance_without_father = ["***", "***", "***", "**"]

# Data for the sample WITH the father
# Only including variables significant at p<0.05 or better (not p<0.1)
variables_with_father = [
    "Verbal Reasoning (E)",
    "Numerical Ability (E)",
    "Hyperactivity (E)"
]
estimates_with_father = [
    -0.071,        # Verbal Reasoning (E)
    -0.084,        # Numerical Ability (E)
    0.053          # Hyperactivity (E)
]
std_errors_with_father = [
    0.014,         # Verbal Reasoning (E)
    0.015,         # Numerical Ability (E)
    0.010          # Hyperactivity (E)
]
# Confidence intervals at 95% level
ci_lower_with_father = [
    est - 1.96 * se for est, se in zip(estimates_with_father, std_errors_with_father)
]
ci_upper_with_father = [
    est + 1.96 * se for est, se in zip(estimates_with_father, std_errors_with_father)
]
significance_with_father = ["***", "***", "***"]

# Combine both sets of data
variables = variables_without_father + variables_with_father
estimates = estimates_without_father + estimates_with_father
ci_lower = ci_lower_without_father + ci_lower_with_father
ci_upper = ci_upper_without_father + ci_upper_with_father
significance = significance_without_father + significance_with_father

# Convert lists to NumPy arrays
y_pos = np.arange(len(variables))
errors = [np.array(estimates) - np.array(ci_lower), np.array(ci_upper) - np.array(estimates)]

# Define split index for separating sections
split_index = len(variables_without_father)

# Plot
fig, ax = plt.subplots(figsize=(12, 8))
ax.errorbar(estimates, y_pos, xerr=errors, fmt='o', color='b', capsize=5, label="Estimate ± 95% CI")
ax.axvline(x=0, color='gray', linestyle='--', alpha=0.7)
ax.axhline(y=split_index - 0.5, color='black', linestyle='-', linewidth=1)
ax.set_yticks(y_pos)
ax.set_yticklabels(variables)
ax.set_xlabel("Estimate")

# Categorize variables with labels
ax.set_title("Significant Oaxaca-Blinder Decomposition Estimates (Girls - Boys) for English - Wave 2\nE=Endowments, C=Coefficients (p<0.05 or better)")
ax.invert_yaxis()

# Get the current axis limits
xlim = ax.get_xlim()
ylim = ax.get_ylim()

# Add section labels on the RIGHT side of the plot area
x_pos = xlim[1] - (xlim[1] - xlim[0]) * 0.02  # 2% from the right edge

# For the upper section (excluding father's education)
y_pos_upper = (ylim[0] + split_index - 0.5) / 2
ax.text(x_pos, y_pos_upper, "Excluding Father's Education", 
        fontsize=10, fontweight='bold', ha='right', va='center')  # Changed ha='left' to ha='right'

# For the lower section (including father's education)
y_pos_lower = (split_index - 0.5 + ylim[1]) / 2
ax.text(x_pos, y_pos_lower, "Including Father's Education", 
        fontsize=10, fontweight='bold', ha='right', va='center')  # Changed ha='left' to ha='right'

# Add significance markers
for i, (est, sig) in enumerate(zip(estimates, significance)):
    ax.text(est + (0.02 if est >= 0 else -0.02), i, sig, fontsize=12, verticalalignment='center', 
            color='red', horizontalalignment='left' if est >= 0 else 'right')

plt.tight_layout()
plt.show()



import matplotlib.pyplot as plt
import numpy as np

# RESULTS FOR ENGLISH - BOYS
categories = ["Endowments", "Coefficients", "Interaction"]

# Values and errors from the English decomposition results for boys
wave1_values = [0.342, 0.280, 0.013]  # Wave 1 values from table
wave1_errors = [0.093, 0.094, 0.074]  # Standard errors from table
wave2_values = [0.410, 0.246, -0.022]  # Wave 2 values
wave2_errors = [0.097, 0.079, 0.071]  # Standard errors

# Significance levels from p-values in the output
wave1_pvalues = [0.000, 0.003, 0.865]  # p-values derived from table
wave2_pvalues = [0.000, 0.002, 0.755]  # p-values derived from table

# Assign stars based on significance levels
def significance_stars(p_values):
    return ['***' if p <= 0.01 else '**' if p <= 0.05 else '*' if p <= 0.1 else '' for p in p_values]

wave1_stars = significance_stars(wave1_pvalues)
wave2_stars = significance_stars(wave2_pvalues)

# X locations for the groups
x = np.arange(len(categories))
width = 0.35

fig, ax = plt.subplots(figsize=(10, 6))
bars1 = ax.bar(x - width/2, wave1_values, width, yerr=wave1_errors, capsize=5, label="Wave 1", color="lightblue")
bars2 = ax.bar(x + width/2, wave2_values, width, yerr=wave2_errors, capsize=5, label="Wave 2", color="blue")

# Adding stars above bars for significance
for bars, stars in zip([bars1, bars2], [wave1_stars, wave2_stars]):
    for bar, star in zip(bars, stars):
        height = bar.get_height()
        ax.text(bar.get_x() + bar.get_width()/2, height + 0.05, star, ha='center', va='bottom', fontsize=12, fontweight='bold')

# Labels and Titles
ax.set_xlabel("Decomposition Components")
ax.set_ylabel("Estimated Contribution to English Points")
ax.set_title("Oaxaca Decomposition: English Points (Boys)")
ax.set_xticks(x)
ax.set_xticklabels(categories)
ax.axhline(0, color='black', linewidth=0.8)  # Zero line

# Manually setting the legend to ensure both bars appear
legend_labels = ["Wave 1: Father Present vs. Absent", "Wave 2: Father Present vs. Absent"]
ax.legend([bars1[0], bars2[0]], legend_labels, title="Comparison Groups")

# Annotating the mean English points for each group
# Wave 1 values
wave1_group1_mean = 10.074  # Father present (from table)
wave1_group2_mean = 9.440   # Father absent (from table)
# Wave 2 values 
wave2_group1_mean = 10.074  # Father present (from table)
wave2_group2_mean = 9.440   # Father absent (from table)

annotation_text = (f"Mean English Points:\n"
                   f"Wave 1 - Present: {wave1_group1_mean:.2f}, Absent: {wave1_group2_mean:.2f}\n"
                   f"Wave 2 - Present: {wave2_group1_mean:.2f}, Absent: {wave2_group2_mean:.2f}")

ax.text(1.5, min(min(wave1_values), min(wave2_values)) + 0.3, annotation_text,
        fontsize=10, bbox=dict(facecolor='white', edgecolor='black', boxstyle='round,pad=0.5'))

plt.tight_layout()
plt.show()

import matplotlib.pyplot as plt
import numpy as np

# RESULTS FOR ENGLISH - GIRLS
categories = ["Endowments", "Coefficients", "Interaction"]

# Values and errors from the English decomposition results for girls
wave1_values = [0.375, 0.382, -0.003]  # Wave 1 values from table
wave1_errors = [0.090, 0.103, 0.080]  # Standard errors from table
wave2_values = [0.468, 0.359, -0.073]  # Wave 2 values
wave2_errors = [0.094, 0.093, 0.071]  # Standard errors

# Significance levels from p-values in the output
wave1_pvalues = [0.000, 0.000, 0.966]  # p-values derived from table
wave2_pvalues = [0.000, 0.000, 0.308]  # p-values derived from table

# Assign stars based on significance levels
def significance_stars(p_values):
    return ['***' if p <= 0.01 else '**' if p <= 0.05 else '*' if p <= 0.1 else '' for p in p_values]

wave1_stars = significance_stars(wave1_pvalues)
wave2_stars = significance_stars(wave2_pvalues)

# X locations for the groups
x = np.arange(len(categories))
width = 0.35

fig, ax = plt.subplots(figsize=(10, 6))
bars1 = ax.bar(x - width/2, wave1_values, width, yerr=wave1_errors, capsize=5, label="Wave 1", color="pink")
bars2 = ax.bar(x + width/2, wave2_values, width, yerr=wave2_errors, capsize=5, label="Wave 2", color="purple")

# Adding stars above bars for significance
for bars, stars in zip([bars1, bars2], [wave1_stars, wave2_stars]):
    for bar, star in zip(bars, stars):
        height = bar.get_height()
        ax.text(bar.get_x() + bar.get_width()/2, height + 0.05, star, ha='center', va='bottom', fontsize=12, fontweight='bold')

# Labels and Titles
ax.set_xlabel("Decomposition Components")
ax.set_ylabel("Estimated Contribution to English Points")
ax.set_title("Oaxaca Decomposition: English Points (Girls)")
ax.set_xticks(x)
ax.set_xticklabels(categories)
ax.axhline(0, color='black', linewidth=0.8)  # Zero line

# Manually setting the legend to ensure both bars appear
legend_labels = ["Wave 1: Father Present vs. Absent", "Wave 2: Father Present vs. Absent"]
ax.legend([bars1[0], bars2[0]], legend_labels, title="Comparison Groups")

# Annotating the mean English points for each group
# Wave 1 values
wave1_group1_mean = 10.429  # Father present (from table)
wave1_group2_mean = 9.675   # Father absent (from table)
# Wave 2 values 
wave2_group1_mean = 10.429  # Father present (from table)
wave2_group2_mean = 9.675   # Father absent (from table)

annotation_text = (f"Mean English Points:\n"
                   f"Wave 1 - Present: {wave1_group1_mean:.2f}, Absent: {wave1_group2_mean:.2f}\n"
                   f"Wave 2 - Present: {wave2_group1_mean:.2f}, Absent: {wave2_group2_mean:.2f}")

ax.text(1.5, min(min(wave1_values), min(wave2_values)) + 0.3, annotation_text,
        fontsize=10, bbox=dict(facecolor='white', edgecolor='black', boxstyle='round,pad=0.5'))

plt.tight_layout()
plt.show()



import matplotlib.pyplot as plt
import numpy as np

# BOYS - Significant variables (p<0.05 or better)
# Wave 1 (Age 9)
boy_w1_variables = [
    "Reading Ability (E)",
    "Mother's Educ. (Bachelor's/Postgrad) (E)",
    "Mother's Educ. (Bachelor's/Postgrad) (C)"
]
boy_w1_estimates = [
    0.112,        # Reading Ability (E)
    0.105,        # Mother's Educ. (Bachelor's/Postgrad) (E)
    -0.182        # Mother's Educ. (Bachelor's/Postgrad) (C)
]
boy_w1_std_errors = [
    0.046,        # Reading Ability (E)
    0.045,        # Mother's Educ. (Bachelor's/Postgrad) (E)
    0.082         # Mother's Educ. (Bachelor's/Postgrad) (C)
]
boy_w1_significance = ["**", "**", "**"]

# Wave 2 (Age 13)
boy_w2_variables = [
    "Verbal Reasoning (E)",
    "BAS Matrices (E)",
    "Constant (C)"
]
boy_w2_estimates = [
    0.149,        # Verbal Reasoning (E)
    0.063,        # BAS Matrices (E)
    1.476         # Constant (C)
]
boy_w2_std_errors = [
    0.044,        # Verbal Reasoning (E)
    0.030,        # BAS Matrices (E)
    0.658         # Constant (C)
]
boy_w2_significance = ["***", "**", "**"]

# GIRLS - Significant variables (p<0.05 or better)
# Wave 1 (Age 9)
girl_w1_variables = [
    "Reading Ability (E)",
    "Conduct Problems (E)",
    "Conduct Problems (C)",
    "Conduct Problems (I)",
    "Mother's Educ. (Higher 2ndary/Tech) (C)"
]
girl_w1_estimates = [
    0.157,        # Reading Ability (E)
    0.070,        # Conduct Problems (E)
    0.265,        # Conduct Problems (C)
    -0.069,       # Conduct Problems (I)
    0.275         # Mother's Educ. (Higher 2ndary/Tech) (C)
]
girl_w1_std_errors = [
    0.053,        # Reading Ability (E)
    0.028,        # Conduct Problems (E)
    0.095,        # Conduct Problems (C)
    0.029,        # Conduct Problems (I)
    0.137         # Mother's Educ. (Higher 2ndary/Tech) (C)
]
girl_w1_significance = ["***", "**", "***", "**", "**"]

# Wave 2 (Age 13)
girl_w2_variables = [
    "Verbal Reasoning (E)"
]
girl_w2_estimates = [
    0.144         # Verbal Reasoning (E)
]
girl_w2_std_errors = [
    0.040         # Verbal Reasoning (E)
]
girl_w2_significance = ["***"]

# Create figure with two separate panels (each in its own figure)
fig_boy = plt.figure(figsize=(10, 6))
ax_boy = fig_boy.add_subplot(111)

fig_girl = plt.figure(figsize=(10, 8))
ax_girl = fig_girl.add_subplot(111)

# Function to calculate confidence intervals
def calc_ci(estimates, std_errors):
    ci_lower = [est - 1.96 * se for est, se in zip(estimates, std_errors)]
    ci_upper = [est + 1.96 * se for est, se in zip(estimates, std_errors)]
    return [np.array(estimates) - np.array(ci_lower), np.array(ci_upper) - np.array(estimates)]

# Function to create improved plot formatting
def format_subplot(ax, variables, estimates, std_errors, significance, waves, 
                  title, wave1_color, wave2_color):
    y_pos = np.arange(len(variables))
    errors = calc_ci(estimates, std_errors)
    
    # Plot the data points with error bars
    for i, (est, err_low, err_high, wave) in enumerate(zip(
            estimates, errors[0], errors[1], waves)):
        color = wave1_color if wave == "Wave 1" else wave2_color
        marker_size = 10  # Increase marker size
        line_width = 2    # Increase error bar line width
        ax.errorbar(est, i, xerr=[[err_low], [err_high]], fmt='o', color=color, 
                   capsize=5, markersize=marker_size, elinewidth=line_width)
    
    # Add significance markers with improved positioning
    for i, (est, sig) in enumerate(zip(estimates, significance)):
        # Position text based on error bar length to avoid overlap
        error_length = errors[1][i]  # Use the right side error bar length
        offset = 0.05 + error_length * 0.5  # Adaptive offset
        
        ax.text(est + offset if est >= 0 else est - offset, i, sig, 
                fontsize=12, verticalalignment='center', color='red',
                horizontalalignment='left' if est >= 0 else 'right',
                fontweight='bold')  # Make significance markers bold
    
    # Set up the y-axis labels with improved font size
    ax.set_yticks(y_pos)
    ax.set_yticklabels(variables, fontsize=11)
    
    # Add zero reference line
    ax.axvline(x=0, color='gray', linestyle='--', alpha=0.7, linewidth=1.5)
    
    # Add dividers between waves
    wave1_end = waves.index("Wave 2") if "Wave 2" in waves else len(waves)
    if wave1_end < len(waves):
        ax.axhline(y=wave1_end-0.5, color='black', linestyle='-', alpha=0.3, linewidth=1.5)
    
    # Add wave labels on the right side of the plot
    wave1_y = wave1_end - (wave1_end / 2) - 0.5
    wave2_y = wave1_end + ((len(waves) - wave1_end) / 2) - 0.5
    
    ax.text(1.02, wave1_y / len(variables), "Wave 1 (Age 9)", transform=ax.transAxes, 
            verticalalignment='center', fontsize=12, fontweight='bold')
    ax.text(1.02, wave2_y / len(variables), "Wave 2 (Age 13)", transform=ax.transAxes, 
            verticalalignment='center', fontsize=12, fontweight='bold')
    
    # Set title with improved formatting
    ax.set_title(title, fontsize=14, fontweight='bold', pad=20)
    
    # Add legend with better positioning
    ax.errorbar([], [], fmt='o', color=wave1_color, label='Wave 1', markersize=10)
    ax.errorbar([], [], fmt='o', color=wave2_color, label='Wave 2', markersize=10)
    legend = ax.legend(loc='upper right', fontsize=12, frameon=True)
    legend.get_frame().set_alpha(0.9)
    
    # Add subtle grid lines for easier reading
    ax.grid(axis='x', linestyle=':', color='gray', alpha=0.3)
    
    # Add x-axis label
    ax.set_xlabel("Estimated Contribution to English Points (Father Present - Father Absent)", 
                fontsize=12, fontweight='bold')
    
    return errors

# PANEL A: BOYS
# Combine and sort data for boys
boy_variables = boy_w1_variables + boy_w2_variables
boy_estimates = boy_w1_estimates + boy_w2_estimates
boy_std_errors = boy_w1_std_errors + boy_w2_std_errors
boy_significance = boy_w1_significance + boy_w2_significance
boy_waves = ["Wave 1"] * len(boy_w1_variables) + ["Wave 2"] * len(boy_w2_variables)

# Sort by wave and estimate size
boy_sort_idx = np.argsort([1 if w == "Wave 1" else 2 for w in boy_waves])
boy_variables = [boy_variables[i] for i in boy_sort_idx]
boy_estimates = [boy_estimates[i] for i in boy_sort_idx]
boy_std_errors = [boy_std_errors[i] for i in boy_sort_idx]
boy_significance = [boy_significance[i] for i in boy_sort_idx]
boy_waves = [boy_waves[i] for i in boy_sort_idx]

# PANEL B: GIRLS
# Combine and sort data for girls
girl_variables = girl_w1_variables + girl_w2_variables
girl_estimates = girl_w1_estimates + girl_w2_estimates
girl_std_errors = girl_w1_std_errors + girl_w2_std_errors
girl_significance = girl_w1_significance + girl_w2_significance
girl_waves = ["Wave 1"] * len(girl_w1_variables) + ["Wave 2"] * len(girl_w2_variables)

# Sort by wave
girl_sort_idx = np.argsort([1 if w == "Wave 1" else 2 for w in girl_waves])
girl_variables = [girl_variables[i] for i in girl_sort_idx]
girl_estimates = [girl_estimates[i] for i in girl_sort_idx]
girl_std_errors = [girl_std_errors[i] for i in girl_sort_idx]
girl_significance = [girl_significance[i] for i in girl_sort_idx]
girl_waves = [girl_waves[i] for i in girl_sort_idx]

# Format each panel with improved colors
boy_errors = format_subplot(ax_boy, boy_variables, boy_estimates, boy_std_errors, boy_significance, boy_waves,
              "Boys: Significant Factors in Father Absence Impact on English Achievement (p<0.05)",
              'lightblue', 'blue')  # Light Blue for Wave 1, Blue for Wave 2

girl_errors = format_subplot(ax_girl, girl_variables, girl_estimates, girl_std_errors, girl_significance, girl_waves,
              "Girls: Significant Factors in Father Absence Impact on English Achievement (p<0.05)",
              'pink', 'purple')  # Pink for Wave 1, Purple for Wave 2

# Set x-axis limits with added padding for both plots
# Calculate common x-limits for consistency across plots
x_min = min(min(boy_estimates) - max(boy_errors[0]), min(girl_estimates) - max(girl_errors[0]))
x_max = max(max(boy_estimates) + max(boy_errors[1]), max(girl_estimates) + max(girl_errors[1]))
x_range = x_max - x_min
padding = 0.15  # Increase padding for better spacing

# Apply common x-limits to both plots
ax_boy.set_xlim(x_min - padding * x_range, x_max + padding * x_range)
ax_girl.set_xlim(x_min - padding * x_range, x_max + padding * x_range)

# Add x-axis ticks with better spacing
x_ticks = np.arange(np.floor(x_min - padding * x_range * 0.8) * 0.5, 
                   np.ceil(x_max + padding * x_range * 0.8) * 0.5 + 0.1, 0.5)
ax_boy.set_xticks(x_ticks)
ax_boy.set_xticklabels([str(x) for x in x_ticks], fontsize=12)
ax_girl.set_xticks(x_ticks)
ax_girl.set_xticklabels([str(x) for x in x_ticks], fontsize=12)

# Adjust layout and margins
plt.tight_layout()
fig_boy.subplots_adjust(left=0.35, right=0.85)
fig_girl.subplots_adjust(left=0.35, right=0.85)

# Save each plot separately
fig_boy.savefig('boys_father_absence_english_plot.png', dpi=300, bbox_inches='tight')
fig_girl.savefig('girls_father_absence_english_plot.png', dpi=300, bbox_inches='tight')

plt.figure(fig_boy.number)
plt.figure(fig_girl.number)
plt.show()
