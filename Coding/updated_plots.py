# -*- coding: utf-8 -*-
"""
Created on Fri Apr 11 13:43:57 2025

@author: bgiet
"""

import matplotlib.pyplot as plt
import numpy as np
import matplotlib.patches as mpatches

# Set figure size and style
plt.style.use('seaborn-v0_8-whitegrid')
plt.figure(figsize=(14, 8))  # Wider figure to accommodate the larger legend

# Categories and positions
categories = ["Endowments", "Coefficients", "Interaction"]
x = np.arange(len(categories))
width = 0.15  # Thinner bars for a more compact look

# Data for Wave 1
wave1_without_father_values = [-1.870689, -6.523005, 0.852121]
wave1_without_father_errors = [0.7787979, 1.063569, 0.4744426]
wave1_without_father_pvalues = [0.016, 0.000, 0.072]

wave1_with_father_values = [-1.691801, -5.993568, 0.8414848]
wave1_with_father_errors = [0.8796024, 1.132278, 0.6602358]
wave1_with_father_pvalues = [0.054, 0.000, 0.202]

# Data for Wave 2
wave2_without_father_values = [-5.217316, -3.036094, 0.763698]
wave2_without_father_errors = [0.8021306, 1.101744, 0.6320127]
wave2_without_father_pvalues = [0.000, 0.006, 0.227]

wave2_with_father_values = [-5.338124, -2.939874, 0.9415447]
wave2_with_father_errors = [1.053133, 1.217175, 0.6669096]
wave2_with_father_pvalues = [0.000, 0.016, 0.158]

# Function to assign significance stars
def significance_stars(p_values):
    return ['***' if p <= 0.01 else '**' if p <= 0.05 else '*' if p <= 0.1 else '' for p in p_values]

# Get significance stars
wave1_without_father_stars = significance_stars(wave1_without_father_pvalues)
wave1_with_father_stars = significance_stars(wave1_with_father_pvalues)
wave2_without_father_stars = significance_stars(wave2_without_father_pvalues)
wave2_with_father_stars = significance_stars(wave2_with_father_pvalues)

# Plot bars with adjusted spacing for thinner bars
bar1 = plt.bar(x - 1.65*width, wave1_without_father_values, width, yerr=wave1_without_father_errors, 
       capsize=4, label="Wave 1 - Without Father's Education", color="orange")
bar2 = plt.bar(x - 0.55*width, wave1_with_father_values, width, yerr=wave1_with_father_errors, 
       capsize=4, label="Wave 1 - With Father's Education", color="gold")
bar3 = plt.bar(x + 0.55*width, wave2_without_father_values, width, yerr=wave2_without_father_errors, 
       capsize=4, label="Wave 2 - Without Father's Education", color="mediumpurple")
bar4 = plt.bar(x + 1.65*width, wave2_with_father_values, width, yerr=wave2_with_father_errors, 
       capsize=4, label="Wave 2 - With Father's Education", color="red")

# Function to add significance stars next to the top of error bars
def add_significance_stars(bars, stars, errors):
    for bar, star, error in zip(bars, stars, errors):
        if not star:  # Skip if no significance star
            continue
            
        height = bar.get_height()
        # Position stars at the top of the error bars
        if height < 0:
            star_y_pos = height - error - 0.3  # Below the error bar for negative values
        else:
            star_y_pos = height + error + 0.15  # Above the error bar for positive values
            
        plt.text(bar.get_x() + bar.get_width()/2., star_y_pos,
                star, ha='center', va='center', fontweight='bold', fontsize=10)

# Add stars with adjusted function that takes error values
add_significance_stars(bar1, wave1_without_father_stars, wave1_without_father_errors)
add_significance_stars(bar2, wave1_with_father_stars, wave1_with_father_errors)
add_significance_stars(bar3, wave2_without_father_stars, wave2_without_father_errors)
add_significance_stars(bar4, wave2_with_father_stars, wave2_with_father_errors)

# Add zero line
plt.axhline(0, color='black', linewidth=0.8)

# Labels and styling
plt.xlabel("Decomposition Components", fontsize=12, labelpad=10)
plt.ylabel("Estimated Contribution to Maths Points (Girls - Boys)", fontsize=12)
plt.title("Oaxaca Decomposition: Maths Points (Girls vs. Boys) - Waves 1 & 2", fontsize=14, pad=15)
plt.xticks(x, categories, fontsize=11)
plt.ylim(-8, 2)

# Create custom labels with means information
custom_labels = [
    f"Wave 1 - Without Father's Education\n(Girls: {56.69:.2f}, Boys: {64.24:.2f})",
    f"Wave 1 - With Father's Education\n(Girls: {58.92:.2f}, Boys: {65.76:.2f})",
    f"Wave 2 - Without Father's Education\n(Girls: {57.88:.2f}, Boys: {65.37:.2f})",
    f"Wave 2 - With Father's Education\n(Girls: {60.30:.2f}, Boys: {67.64:.2f})"
]

# Add legend with custom labels
legend = plt.legend(
    handles=[
        mpatches.Patch(color="orange", label=custom_labels[0]),
        mpatches.Patch(color="gold", label=custom_labels[1]),
        mpatches.Patch(color="mediumpurple", label=custom_labels[2]),
        mpatches.Patch(color="red", label=custom_labels[3])
    ],
    title="Comparison Groups",
    title_fontsize=11,
    fontsize=9,
    loc='lower right',
    bbox_to_anchor=(1, 0.05)
)

# Add text for statistical significance explanation
plt.figtext(0.15, 0.01, "Significance: *** p≤0.01, ** p≤0.05, * p≤0.1", 
            fontsize=10, ha="left")

plt.tight_layout()
plt.subplots_adjust(bottom=0.15)  # Make room for the significance explanation
plt.show()