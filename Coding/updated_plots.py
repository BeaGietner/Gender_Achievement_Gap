# -*- coding: utf-8 -*-
"""
Revised Oaxaca Decomposition Plots with Consistent Formatting
"""

import matplotlib.pyplot as plt
import numpy as np
import matplotlib.patches as mpatches

# Common style settings
plt.style.use('seaborn-v0_8-whitegrid')
FIGURE_SIZE = (14, 8)
TITLE_FONTSIZE = 14
AXIS_LABEL_FONTSIZE = 12
TICK_FONTSIZE = 11
LEGEND_TITLE_FONTSIZE = 11
LEGEND_FONTSIZE = 9
BAR_WIDTH = 0.15
TITLE_PAD = 15
XLABEL_PAD = 10

# Consistent color scheme
# First plot colors (Gender Gap Analysis) - using a green-purple palette
GENDER_GAP_COLOR1 = "#6B8E23"  # olive green for Wave 1 - Without Father's Education
GENDER_GAP_COLOR2 = "#9ACD32"  # yellowgreen for Wave 1 - With Father's Education
GENDER_GAP_COLOR3 = "#8A2BE2"  # blueviolet for Wave 2 - Without Father's Education
GENDER_GAP_COLOR4 = "#BA55D3"  # mediumorchid for Wave 2 - With Father's Education

# Second plot colors (Father Presence Analysis) - keeping the blue-red palette
WAVE1_COLOR1 = "#4472C4"  # blue for boys - Wave 1
WAVE1_COLOR2 = "#8FAADC"  # light blue for boys - Wave 2
WAVE2_COLOR1 = "#C00000"  # dark red for girls - Wave 1
WAVE2_COLOR2 = "#FF8080"  # light red for girls - Wave 2

# Function to assign significance stars
def significance_stars(p_values):
    return ['***' if p <= 0.01 else '**' if p <= 0.05 else '*' if p <= 0.1 else '' for p in p_values]

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

# ------------------------------------------------------------------------------
# FIRST PLOT: Gender Gap Analysis
# ------------------------------------------------------------------------------

plt.figure(figsize=FIGURE_SIZE)

# Categories and positions
categories = ["Endowments", "Coefficients", "Interaction"]
x = np.arange(len(categories))

# Gender gap analysis: Detailed information (preserved for reference)
# Wave 1 - Without Father's Education Control:
# - Girls: mean=52.83, n=1,886
# - Boys: mean=58.04, n=1,804
# - Total sample: n=3,690

# Wave 1 - With Father's Education Control:
# - Girls: mean=54.75, n=1,635
# - Boys: mean=59.18, n=1,606
# - Total sample: n=3,241

# Wave 2 - Without Father's Education Control:
# - Girls: mean=54.21, n=1,724
# - Boys: mean=59.09, n=1,677
# - Total sample: n=3,401

# Wave 2 - With Father's Education Control:
# - Girls: mean=56.27, n=1,377
# - Boys: mean=60.91, n=1,400
# - Total sample: n=2,777

# Data for Wave 1 - Without Father's Education Control
wave1_without_father_values = [-1.570203, -4.214544, 0.5723686]
wave1_without_father_errors = [0.6152778, 0.9093228, 0.5056119]
wave1_without_father_pvalues = [0.011, 0.000, 0.258]

# Data for Wave 1 - With Father's Education Control
wave1_with_father_values = [-1.297806, -3.641, 0.5049772]
wave1_with_father_errors = [0.6671425, 0.9052379, 0.4986865]
wave1_with_father_pvalues = [0.052, 0.000, 0.311]

# Data for Wave 2 - Without Father's Education Control
wave2_without_father_values = [-4.149911, -1.236041, 0.5035347]
wave2_without_father_errors = [0.7520002, 0.9127105, 0.5369147]
wave2_without_father_pvalues = [0.000, 0.176, 0.348]

# Data for Wave 2 - With Father's Education Control
wave2_with_father_values = [-4.038863, -1.128265, 0.5323162]
wave2_with_father_errors = [0.7758151, 0.9836547, 0.5621363]
wave2_with_father_pvalues = [0.000, 0.251, 0.344]

# Get significance stars
wave1_without_father_stars = significance_stars(wave1_without_father_pvalues)
wave1_with_father_stars = significance_stars(wave1_with_father_pvalues)
wave2_without_father_stars = significance_stars(wave2_without_father_pvalues)
wave2_with_father_stars = significance_stars(wave2_with_father_pvalues)

# Plot bars with adjusted spacing for thinner bars
bar1 = plt.bar(x - 1.65*BAR_WIDTH, wave1_without_father_values, BAR_WIDTH, yerr=wave1_without_father_errors, 
       capsize=4, label="Wave 1 - Without Father's Education Control", color=GENDER_GAP_COLOR1)
bar2 = plt.bar(x - 0.55*BAR_WIDTH, wave1_with_father_values, BAR_WIDTH, yerr=wave1_with_father_errors, 
       capsize=4, label="Wave 1 - With Father's Education Control", color=GENDER_GAP_COLOR2)
bar3 = plt.bar(x + 0.55*BAR_WIDTH, wave2_without_father_values, BAR_WIDTH, yerr=wave2_without_father_errors, 
       capsize=4, label="Wave 2 - Without Father's Education Control", color=GENDER_GAP_COLOR3)
bar4 = plt.bar(x + 1.65*BAR_WIDTH, wave2_with_father_values, BAR_WIDTH, yerr=wave2_with_father_errors, 
       capsize=4, label="Wave 2 - With Father's Education Control", color=GENDER_GAP_COLOR4)

# Add stars
add_significance_stars(bar1, wave1_without_father_stars, wave1_without_father_errors)
add_significance_stars(bar2, wave1_with_father_stars, wave1_with_father_errors)
add_significance_stars(bar3, wave2_without_father_stars, wave2_without_father_errors)
add_significance_stars(bar4, wave2_with_father_stars, wave2_with_father_errors)

# Add zero line
plt.axhline(0, color='black', linewidth=0.8)

# Labels and styling
plt.xlabel("Decomposition Components", fontsize=AXIS_LABEL_FONTSIZE, labelpad=XLABEL_PAD)
plt.ylabel("Estimated Contribution to Maths Points (Girls - Boys)", fontsize=AXIS_LABEL_FONTSIZE)
plt.title("Oaxaca Decomposition: Gender Gap in Maths Achievement", fontsize=TITLE_FONTSIZE, pad=TITLE_PAD)
plt.xticks(x, categories, fontsize=TICK_FONTSIZE)
plt.ylim(-6, 2)

# Create simplified labels without detailed statistics (for cleaner plot)
custom_labels = [
    "Wave 1 - Without Father's Education Control",
    "Wave 1 - With Father's Education Control",
    "Wave 2 - Without Father's Education Control",
    "Wave 2 - With Father's Education Control"
]

# Add legend with simple labels for first plot
legend = plt.legend(
    handles=[
        mpatches.Patch(color=GENDER_GAP_COLOR1, label=custom_labels[0]),
        mpatches.Patch(color=GENDER_GAP_COLOR2, label=custom_labels[1]),
        mpatches.Patch(color=GENDER_GAP_COLOR3, label=custom_labels[2]),
        mpatches.Patch(color=GENDER_GAP_COLOR4, label=custom_labels[3])
    ],
    title="Comparison Groups",
    title_fontsize=LEGEND_TITLE_FONTSIZE,
    fontsize=LEGEND_FONTSIZE,
    loc='lower right',
    bbox_to_anchor=(1, 0.05)
)

# Add text for statistical significance explanation
plt.figtext(0.15, 0.01, "Significance: *** p≤0.01, ** p≤0.05, * p≤0.1", 
            fontsize=10, ha="center")

plt.tight_layout()
plt.subplots_adjust(bottom=0.15)
plt.savefig('gender_gap_oaxaca.png', dpi=300, bbox_inches='tight')
plt.show()

# ------------------------------------------------------------------------------
# SECOND PLOT: Father Presence Analysis  
# ------------------------------------------------------------------------------

plt.figure(figsize=FIGURE_SIZE)

# Categories and positions
categories = ["Endowments", "Coefficients", "Interaction"]
x = np.arange(len(categories))

# Father presence analysis: Detailed information (preserved for reference)
# Boys Wave 1:
# - Father present: mean=60.83, n=1,188
# - Father absent: mean=47.27, n=126
# - Difference: 13.56

# Boys Wave 2: 
# - Same sample as Wave 1, with same outcome measure
# - Father present: mean=60.83, n=1,188
# - Father absent: mean=47.27, n=126
# - Difference: 13.56

# Girls Wave 1:
# - Father present: mean=55.80, n=1,142
# - Father absent: mean=40.57, n=150
# - Difference: 15.23

# Girls Wave 2:
# - Same sample as Wave 1, with same outcome measure
# - Father present: mean=55.80, n=1,142
# - Father absent: mean=40.57, n=150
# - Difference: 15.23

# Data from Oaxaca decompositions
boys_wave1_vals = [5.984225, 6.611602, 0.9685071]
boys_wave1_errs = [2.560869, 2.736841, 2.65944]
boys_wave1_pvals = [0.019, 0.016, 0.716]

boys_wave2_vals = [7.40563, 4.992226, 1.166477]
boys_wave2_errs = [2.556972, 2.310633, 1.640097]
boys_wave2_pvals = [0.004, 0.031, 0.477]

girls_wave1_vals = [3.122116, 7.456075, 4.647074]
girls_wave1_errs = [2.262908, 2.122815, 1.939404]
girls_wave1_pvals = [0.168, 0.000, 0.017]

girls_wave2_vals = [7.405171, 6.350724, 1.46937]
girls_wave2_errs = [2.260619, 2.019631, 1.874461]
girls_wave2_pvals = [0.001, 0.002, 0.433]

# Get significance stars
boys_w1_stars = significance_stars(boys_wave1_pvals)
boys_w2_stars = significance_stars(boys_wave2_pvals)
girls_w1_stars = significance_stars(girls_wave1_pvals)
girls_w2_stars = significance_stars(girls_wave2_pvals)

# Plot bars
bar1 = plt.bar(x - 1.65*BAR_WIDTH, boys_wave1_vals, BAR_WIDTH, yerr=boys_wave1_errs,
               capsize=4, label="Boys - Wave 1", color=WAVE1_COLOR1)
bar2 = plt.bar(x - 0.55*BAR_WIDTH, boys_wave2_vals, BAR_WIDTH, yerr=boys_wave2_errs,
               capsize=4, label="Boys - Wave 2", color=WAVE1_COLOR2)
bar3 = plt.bar(x + 0.55*BAR_WIDTH, girls_wave1_vals, BAR_WIDTH, yerr=girls_wave1_errs,
               capsize=4, label="Girls - Wave 1", color=WAVE2_COLOR1)
bar4 = plt.bar(x + 1.65*BAR_WIDTH, girls_wave2_vals, BAR_WIDTH, yerr=girls_wave2_errs,
               capsize=4, label="Girls - Wave 2", color=WAVE2_COLOR2)

# Add stars
add_significance_stars(bar1, boys_w1_stars, boys_wave1_errs)
add_significance_stars(bar2, boys_w2_stars, boys_wave2_errs)
add_significance_stars(bar3, girls_w1_stars, girls_wave1_errs)
add_significance_stars(bar4, girls_w2_stars, girls_wave2_errs)

# Labels and styling
plt.axhline(0, color='black', linewidth=0.8)
plt.xlabel("Decomposition Components", fontsize=AXIS_LABEL_FONTSIZE, labelpad=XLABEL_PAD)
plt.ylabel("Estimated Contribution to Maths Points\n(Father Present – Father Absent)", fontsize=AXIS_LABEL_FONTSIZE)
plt.title("Oaxaca Decomposition: Impact of Father Presence on Maths Achievement by Gender ", fontsize=TITLE_FONTSIZE, pad=TITLE_PAD)
plt.xticks(x, categories, fontsize=TICK_FONTSIZE)
plt.ylim(-2, 12)

# Create simplified labels for the second plot
simple_labels = [
    "Boys - Wave 1",
    "Boys - Wave 2",
    "Girls - Wave 1", 
    "Girls - Wave 2"
]

# Add legend with simple labels
legend = plt.legend(
    handles=[
        mpatches.Patch(color=WAVE1_COLOR1, label=simple_labels[0]),
        mpatches.Patch(color=WAVE1_COLOR2, label=simple_labels[1]),
        mpatches.Patch(color=WAVE2_COLOR1, label=simple_labels[2]),
        mpatches.Patch(color=WAVE2_COLOR2, label=simple_labels[3])
    ],
    title="Comparison Groups",
    title_fontsize=LEGEND_TITLE_FONTSIZE,
    fontsize=LEGEND_FONTSIZE,
    loc='upper right',
    bbox_to_anchor=(1, 0.95)
)

# Add text for statistical significance explanation
plt.figtext(0.15, 0.01, "Significance: *** p≤0.01, ** p≤0.05, * p≤0.1", 
            fontsize=10, ha="center")

plt.tight_layout()
plt.subplots_adjust(bottom=0.15)
plt.savefig('father_presence_oaxaca.png', dpi=300, bbox_inches='tight')
plt.show()