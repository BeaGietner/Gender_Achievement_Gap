# -*- coding: utf-8 -*-
"""
Created on Thu Mar 13 11:37:24 2025

@author: bgiet
"""

import matplotlib.pyplot as plt
import numpy as np

# MATHS
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


import pandas as pd

# Data extracted from the Oaxaca decomposition results for Wave 1 with and without father's education

# Creating a dictionary with variable names, type (Endowment, Coefficient, Interaction), estimates, confidence intervals, and significance levels
wave1_results = [
    # Without Father's Education
    ("Drumcondra Primary Maths Test - Logit Score", "E", -0.1159, -0.0764, -0.1555, "***"),
    ("Conduct Problems", "E", 0.0122, 0.0216, 0.0029, "**"),
    ("Hyperactivity", "E", 0.0429, 0.0606, 0.0251, "***"),
    ("PCG Education (Higher Secondary to Non-Degree)", "E", -0.0328, -0.0053, -0.0603, "**"),
    ("Drumcondra Primary Reading Test - Logit Score", "C", 0.0267, 0.0537, -0.0003, "*"),
    ("Drumcondra Primary Maths Test - Logit Score", "C", 0.0505, 0.1103, -0.0093, "*"),
    ("Emotional Symptoms", "C", -0.0659, -0.0118, -0.1436, "*"),
    ("Interaction Effect", "I", 0.0502, 0.0985, 0.0019, "**"),

    # With Father's Education
    ("Drumcondra Primary Maths Test - Logit Score", "E", -0.1044, -0.0608, -0.1480, "***"),
    ("Conduct Problems", "E", 0.0137, 0.0246, 0.0029, "**"),
    ("Hyperactivity", "E", 0.0461, 0.0668, 0.0253, "***"),
    ("PCG Education (Higher Secondary to Non-Degree)", "E", -0.0231, -0.0023, -0.0439, "**"),
    ("SCG Education (Higher Secondary to Non-Degree)", "E", -0.0281, -0.0098, -0.0463, "***"),
    ("Drumcondra Primary Maths Test - Logit Score", "C", 0.0469, 0.0948, -0.0009, "*"),
    ("Mixed School Indicator", "C", 0.1409, 0.2807, 0.0010, "**"),
    ("Interaction Effect", "I", 0.0550, 0.1018, 0.0081, "**")
]

# Converting the results into a DataFrame for display
df_wave1_results = pd.DataFrame(wave1_results, columns=["Variable Name", "Type", "Estimate", "CI Upper", "CI Lower", "Significance Level"])

# Displaying the DataFrame to the user
import ace_tools as tools
tools.display_dataframe_to_user(name="Wave 1 Significant Oaxaca Estimates", dataframe=df_wave1_results)


# WAVE 1

import matplotlib.pyplot as plt
import numpy as np

# Data for the sample WITHOUT the father
variables = [
    "Drumcondra Maths Logit Score (E)",
    "Conduct Problems (E)",
    "Hyperactivity (E)",
    "Mother's Education 5-6 (E)",
    "Drumcondra Reading Logit Score (C)",
    "Drumcondra Maths Logit Score (C)"
]

estimates = [
    -0.1159, 0.0122, 0.0429, -0.0328, 0.0267, 0.0505
]

ci_lower = [
    -0.1555, 0.0029, 0.0251, -0.0603, -0.0003, -0.0093
]

ci_upper = [
    -0.0764, 0.0216, 0.0606, -0.0053, 0.0537, 0.1103
]

significance = ["***", "**", "***", "**", "*", "*"]

# Convert lists to NumPy arrays
y_pos = np.arange(len(variables))
errors = [np.array(estimates) - np.array(ci_lower), np.array(ci_upper) - np.array(estimates)]

# Plot
fig, ax = plt.subplots(figsize=(10, 6))
ax.errorbar(estimates, y_pos, xerr=errors, fmt='o', color='b', capsize=5, label="Estimate ± 95% CI")
ax.axvline(x=0, color='gray', linestyle='--', alpha=0.7)
ax.set_yticks(y_pos)
ax.set_yticklabels(variables)
ax.set_xlabel("Estimate")
ax.set_title("Significant Oaxaca-Blinder Decomposition Estimates (Sample without Father)")
ax.invert_yaxis()

# Add significance markers
for i, (est, sig) in enumerate(zip(estimates, significance)):
    ax.text(est + 0.02, i, sig, fontsize=12, verticalalignment='center', color='red')

plt.tight_layout()
plt.show()


import matplotlib.pyplot as plt
import numpy as np

# Data for the sample WITH the father
variables = [
    "Drumcondra Maths Logit Score (E)",
    "Conduct Problems (E)",
    "Hyperactivity (E)",
    "Mother's Education 5-6 (E)",
    "Father's Education 5-6 (E)",
    "Drumcondra Reading Logit Score (C)",
    "Drumcondra Maths Logit Score (C)",
    "Mixed School (CoEd) (C)",
    "Drumcondra Maths Logit Score (I)",
    "Mixed School (CoEd) (I)"
]

estimates = [
    -0.1044, 0.0137, 0.0461, -0.0231, -0.0281, 0.0331, 0.0469, 0.1409, 0.0186, 0.0230
]

ci_lower = [
    -0.1480, 0.0029, 0.0253, -0.0439, -0.0463, -0.0033, -0.0009, 0.0010, -0.0021, -0.0014
]

ci_upper = [
    -0.0608, 0.0246, 0.0668, -0.0023, -0.0098, 0.0695, 0.0948, 0.2807, 0.0392, 0.0474
]

significance = ["***", "**", "***", "**", "***", "*", "*", "**", "*", "*"]

# Convert lists to NumPy arrays
y_pos = np.arange(len(variables))
errors = [np.array(estimates) - np.array(ci_lower), np.array(ci_upper) - np.array(estimates)]

# Plot
fig, ax = plt.subplots(figsize=(10, 6))
ax.errorbar(estimates, y_pos, xerr=errors, fmt='o', color='b', capsize=5, label="Estimate ± 95% CI")
ax.axvline(x=0, color='gray', linestyle='--', alpha=0.7)
ax.set_yticks(y_pos)
ax.set_yticklabels(variables)
ax.set_xlabel("Estimate")
ax.set_title("Significant Oaxaca-Blinder Decomposition Estimates (Sample with Father)")
ax.invert_yaxis()

# Add significance markers
for i, (est, sig) in enumerate(zip(estimates, significance)):
    ax.text(est + 0.02, i, sig, fontsize=12, verticalalignment='center', color='red')

plt.tight_layout()
plt.show()


import matplotlib.pyplot as plt
import numpy as np

# Data for the sample WITHOUT the father
variables = [
    "Conduct Problems (E)",
    "Hyperactivity (E)",
    "Mother's Education 5-6 (E)"
]

estimates = [
    0.0122, 0.0429, -0.0328
]

ci_lower = [
    0.0029, 0.0251, -0.0603
]

ci_upper = [
    0.0216, 0.0606, -0.0053
]

significance = ["**", "***", "**"]

# Convert lists to NumPy arrays
y_pos = np.arange(len(variables))
errors = [np.array(estimates) - np.array(ci_lower), np.array(ci_upper) - np.array(estimates)]

# Plot
fig, ax = plt.subplots(figsize=(10, 6))
ax.errorbar(estimates, y_pos, xerr=errors, fmt='o', color='b', capsize=5, label="Estimate ± 95% CI")
ax.axvline(x=0, color='gray', linestyle='--', alpha=0.7)
ax.set_yticks(y_pos)
ax.set_yticklabels(variables)
ax.set_xlabel("Estimate")
ax.set_title("Significant Oaxaca-Blinder Decomposition Estimates (Sample without Father)")
ax.invert_yaxis()

# Add significance markers
for i, (est, sig) in enumerate(zip(estimates, significance)):
    ax.text(est + 0.02, i, sig, fontsize=12, verticalalignment='center', color='red')

plt.tight_layout()
plt.show()


import matplotlib.pyplot as plt
import numpy as np

# Data for the sample WITH the father
variables = [
    "Conduct Problems (E)",
    "Hyperactivity (E)",
    "Mother's Education 5-6 (E)",
    "Father's Education 5-6 (E)",
    "Mixed School (C)"
]

estimates = [
    0.0137, 0.0461, -0.0231, -0.0281, 0.1409
]

ci_lower = [
    0.0029, 0.0253, -0.0439, -0.0463, 0.0010
]

ci_upper = [
    0.0246, 0.0668, -0.0023, -0.0098, 0.2807
]

significance = ["**", "***", "**", "***", "**"]

# Convert lists to NumPy arrays
y_pos = np.arange(len(variables))
errors = [np.array(estimates) - np.array(ci_lower), np.array(ci_upper) - np.array(estimates)]

# Plot
fig, ax = plt.subplots(figsize=(10, 6))
ax.errorbar(estimates, y_pos, xerr=errors, fmt='o', color='b', capsize=5, label="Estimate ± 95% CI")
ax.axvline(x=0, color='gray', linestyle='--', alpha=0.7)
ax.set_yticks(y_pos)
ax.set_yticklabels(variables)
ax.set_xlabel("Estimate")
ax.set_title("Significant Oaxaca-Blinder Decomposition Estimates (Sample with Father)")
ax.invert_yaxis()

# Add significance markers
for i, (est, sig) in enumerate(zip(estimates, significance)):
    ax.text(est + 0.02, i, sig, fontsize=12, verticalalignment='center', color='red')

plt.tight_layout()
plt.show()




import matplotlib.pyplot as plt
import numpy as np

# Data for the sample WITHOUT the father
variables_without_father = [
    "Conduct Problems (E)",
    "Hyperactivity (E)",
    "Mother's Education 5-6 (E)"
]

estimates_without_father = [
    0.0122, 0.0429, -0.0328
]

ci_lower_without_father = [
    0.0029, 0.0251, -0.0603
]

ci_upper_without_father = [
    0.0216, 0.0606, -0.0053
]

significance_without_father = ["**", "***", "**"]

# Data for the sample WITH the father
variables_with_father = [
    "Conduct Problems (E)",
    "Hyperactivity (E)",
    "Mother's Education 5-6 (E)",
    "Father's Education 5-6 (E)",
    "Mixed School (C)"
]

estimates_with_father = [
    0.0137, 0.0461, -0.0231, -0.0281, 0.1409
]

ci_lower_with_father = [
    0.0029, 0.0253, -0.0439, -0.0463, 0.0010
]

ci_upper_with_father = [
    0.0246, 0.0668, -0.0023, -0.0098, 0.2807
]

significance_with_father = ["**", "***", "**", "***", "**"]

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
fig, ax = plt.subplots(figsize=(10, 8))
ax.errorbar(estimates, y_pos, xerr=errors, fmt='o', color='b', capsize=5, label="Estimate ± 95% CI")
ax.axvline(x=0, color='gray', linestyle='--', alpha=0.7)
ax.axhline(y=split_index - 0.5, color='black', linestyle='-', linewidth=1)
ax.set_yticks(y_pos)
ax.set_yticklabels(variables)
ax.set_xlabel("Estimate")
ax.set_title("Significant Oaxaca-Blinder Decomposition Estimates (Girls - Boys) - 9 year olds")
ax.invert_yaxis()

# Add section labels in the top right
ax.text(ax.get_xlim()[1] - 0.1, split_index - 0.75, "Excluding Father's Education", fontsize=12, fontweight='bold', ha='right')
ax.text(ax.get_xlim()[1] - 0.1, split_index + 0.75, "Including Father's Education", fontsize=12, fontweight='bold', ha='right')

# Add significance markers
for i, (est, sig) in enumerate(zip(estimates, significance)):
    ax.text(est + 0.02, i, sig, fontsize=12, verticalalignment='center', color='red')

plt.tight_layout()
plt.show()

import matplotlib.pyplot as plt
import numpy as np

# Data for the sample WITHOUT the father
variables_without_father = [
    "Numerical Ability (E)",
    "Conduct Problems (E)",
    "Hyperactivity (E)",
    "Mother's Education (Higher Degree) (E)"
]

estimates_without_father = [
    -0.1159, 0.0122, 0.0429, -0.0328
]

ci_lower_without_father = [
    -0.1555, 0.0029, 0.0251, -0.0603
]

ci_upper_without_father = [
    -0.0764, 0.0216, 0.0606, -0.0053
]

significance_without_father = ["***", "**", "***", "**"]

# Data for the sample WITH the father
variables_with_father = [
    "Numerical Ability (E)",
    "Conduct Problems (E)",
    "Hyperactivity (E)",
    "Mother's Education (Higher Degree) (E)",
    "Father's Education (Higher Degree) (E)",
    "Reading Ability (C)",
    "Numerical Ability (C)",
    "Mixed School (CoEd) (C)"
]

estimates_with_father = [
    -0.1044, 0.0137, 0.0461, -0.0231, -0.0281, 0.0331, 0.0469, 0.1409
]

ci_lower_with_father = [
    -0.1479, 0.0029, 0.0253, -0.0439, -0.0463, -0.0033, -0.0009, 0.0010
]

ci_upper_with_father = [
    -0.0608, 0.0246, 0.0668, -0.0023, -0.0098, 0.0695, 0.0948, 0.2807
]

significance_with_father = ["***", "**", "***", "**", "***", "*", "**", "**"]

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
fig, ax = plt.subplots(figsize=(10, 8))
ax.errorbar(estimates, y_pos, xerr=errors, fmt='o', color='b', capsize=5, label="Estimate ± 95% CI")
ax.axvline(x=0, color='gray', linestyle='--', alpha=0.7)
ax.axhline(y=split_index - 0.5, color='black', linestyle='-', linewidth=1)
ax.set_yticks(y_pos)
ax.set_yticklabels(variables)
ax.set_xlabel("Estimate")
ax.set_title("Significant Oaxaca-Blinder Decomposition Estimates (Girls - Boys) - 9 year olds")
ax.invert_yaxis()

# Add section labels
ax.text(ax.get_xlim()[1] - 0.05, split_index - 1, "Excluding Father's Education", fontsize=12, fontweight='bold', ha='right')
ax.text(ax.get_xlim()[1] - 0.05, split_index + 1, "Including Father's Education", fontsize=12, fontweight='bold', ha='right')

# Add significance markers
for i, (est, sig) in enumerate(zip(estimates, significance)):
    ax.text(est + 0.02, i, sig, fontsize=12, verticalalignment='center', color='red')

plt.tight_layout()
plt.show()


import matplotlib.pyplot as plt
import numpy as np

# Data for the sample WITHOUT the father
variables_without_father = [
    "Cognitive Verbal (E)",
    "Cognitive Numerical (E)",
    "Cognitive Total (E)",
    "Hyperactivity (E)",
    "Mother's Education (Higher Degree) (E)",
    "Conduct Problems (C)"
]

estimates_without_father = [
    -0.1728, -0.4240, 0.3083, 0.0578, -0.0270, -0.0748
]

ci_lower_without_father = [
    -0.2767, -0.5776, 0.0897, 0.0369, -0.0477, -0.1455
]

ci_upper_without_father = [
    -0.0690, -0.2703, 0.5269, 0.0787, -0.0062, -0.0042
]

significance_without_father = ["***", "***", "**", "***", "**", "**"]

# Data for the sample WITH the father
variables_with_father = [
    "Cognitive Verbal (E)",
    "Cognitive Numerical (E)",
    "Cognitive Total (E)",
    "Hyperactivity (E)",
    "Mother's Education (Higher Degree) (E)",
    "Father's Education (Higher Degree) (E)",
    "Conduct Problems (C)"
]

estimates_with_father = [
    -0.1403, -0.3789, 0.2627, 0.0552, -0.0227, -0.0174, -0.0755
]

ci_lower_with_father = [
    -0.2314, -0.5349, 0.0517, 0.0319, -0.0447, -0.0335, -0.1593
]

ci_upper_with_father = [
    -0.0493, -0.2229, 0.4737, 0.0784, -0.0008, -0.0013, -0.0082
]

significance_with_father = ["**", "***", "**", "***", "**", "**", "**"]

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
fig, ax = plt.subplots(figsize=(10, 8))
ax.errorbar(estimates, y_pos, xerr=errors, fmt='o', color='b', capsize=5, label="Estimate ± 95% CI")
ax.axvline(x=0, color='gray', linestyle='--', alpha=0.7)
ax.axhline(y=split_index - 0.5, color='black', linestyle='-', linewidth=1)
ax.set_yticks(y_pos)
ax.set_yticklabels(variables)
ax.set_xlabel("Estimate")
ax.set_title("Significant Oaxaca-Blinder Decomposition Estimates (Girls - Boys) - 13 year olds")
ax.invert_yaxis()

# Add section labels
ax.text(ax.get_xlim()[1] - 0.05, split_index - 1, "Excluding Father's Education", fontsize=12, fontweight='bold', ha='right')
ax.text(ax.get_xlim()[1] - 0.05, split_index + 1, "Including Father's Education", fontsize=12, fontweight='bold', ha='right')

# Add significance markers
for i, (est, sig) in enumerate(zip(estimates, significance)):
    ax.text(est + 0.02, i, sig, fontsize=12, verticalalignment='center', color='red')

plt.tight_layout()
plt.show()