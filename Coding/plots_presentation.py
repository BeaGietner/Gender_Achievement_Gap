# -*- coding: utf-8 -*-
"""
Created on Thu Mar 27 09:43:49 2025

@author: bgiet
"""

import pandas as pd
import matplotlib.pyplot as plt
import numpy as np

# Data: Only significant estimates from both models
data = {
    'Variable': [
        'Numerical Ability',
        'Reading Ability',
        'Conduct Problems',
        'Hyperactivity',
        'Mother’s Education\n(HS/Technical)',
        'Mother’s Education\n(Bachelor/Postgrad)',
        'Father’s Education\n(HS/Technical)',
        'Father’s Education\n(Bachelor/Postgrad)',
        'Income',
        'CoEd',
        'Father\'s Educ\nMissing'
    ],
    'Model 1 Coef': [
        0.563,
        0.366,
        -0.092,
        -0.095,
        0.499,
        0.882,
        None,
        None,
        0.156,
        None,
        -0.351
    ],
    'Model 1 SE': [
        0.027,
        0.025,
        0.016,
        0.009,
        0.059,
        0.068,
        None,
        None,
        0.016,
        None,
        0.057
    ],
    'Model 1 Sig': [
        '***',
        '***',
        '***',
        '***',
        '***',
        '***',
        '',
        '',
        '***',
        '',
        '***'
    ],
    'Model 2 Coef': [
        0.551,
        0.332,
        -0.083,
        -0.104,
        0.437,
        0.678,
        0.370,
        0.627,
        0.121,
        0.095,
        None
    ],
    'Model 2 SE': [
        0.028,
        0.027,
        0.017,
        0.010,
        0.065,
        0.076,
        0.052,
        0.063,
        0.017,
        0.048,
        None
    ],
    'Model 2 Sig': [
        '***',
        '***',
        '***',
        '***',
        '***',
        '***',
        '***',
        '***',
        '***',
        '*',
        ''
    ]
}

df = pd.DataFrame(data)

# Remove rows where both models are NaN
df = df[~(df['Model 1 Coef'].isna() & df['Model 2 Coef'].isna())]

# Set positions
x = np.arange(len(df))
width = 0.35

fig, ax = plt.subplots(figsize=(12, 6))

# Bars for Model 1
bars1 = ax.bar(x - width/2, df['Model 1 Coef'], width,
               yerr=df['Model 1 SE'], label='Model 1',
               capsize=5, color='steelblue', edgecolor='black')

# Bars for Model 2
bars2 = ax.bar(x + width/2, df['Model 2 Coef'], width,
               yerr=df['Model 2 SE'], label='Model 2',
               capsize=5, color='orange', edgecolor='black')

# Reference line
ax.axhline(0, color='gray', linestyle='--')

# Labels
ax.set_ylabel('Coefficient')
ax.set_title('Significant Predictors at Age 9 of Maths Scores at Age 15')
ax.set_xticks(x)
ax.set_xticklabels(df['Variable'], rotation=45, ha='right')
ax.legend()

# Add significance stars
for i, (bar1, sig1) in enumerate(zip(bars1, df['Model 1 Sig'])):
    if sig1:
        height = bar1.get_height()
        ax.text(bar1.get_x() + bar1.get_width()/2, height + 0.02 if height > 0 else height - 0.05,
                sig1, ha='center', va='bottom' if height > 0 else 'top', fontsize=12)

for i, (bar2, sig2) in enumerate(zip(bars2, df['Model 2 Sig'])):
    if sig2:
        height = bar2.get_height()
        ax.text(bar2.get_x() + bar2.get_width()/2, height + 0.02 if height > 0 else height - 0.05,
                sig2, ha='center', va='bottom' if height > 0 else 'top', fontsize=12)

plt.tight_layout()
plt.show()



import pandas as pd
import matplotlib.pyplot as plt
import numpy as np

# Data: Only significant estimates from Models 3 and 4
data = {
    'Variable': [
        'Numerical Ability',
        'Verbal Reasoning',
        'BAS Matrices Score',
        'Conduct Problems',
        'Hyperactivity',
        'Emotional Symptoms',
        'Mother’s Educ\n(HS/Technical)',
        'Mother’s Educ\n(Bachelor/Postgrad)',
        'Father’s Educ\n(HS/Technical)',
        'Father’s Educ\n(Bachelor/Postgrad)',
        'Income',
        'Male',
        'Fee-paying School',
        'DEIS School',
        'Mixed School',
        'Father’s Educ\nMissing'
    ],
    'Model 3 Coef': [
        0.723,
        0.343,
        0.012,
        -0.056,
        -0.096,
        None,
        0.431,
        0.669,
        None,
        None,
        0.108,
        -0.149,
        0.192,
        -0.361,
        -0.149,
        -0.228
    ],
    'Model 3 SE': [
        0.026,
        0.025,
        0.001,
        0.015,
        0.009,
        None,
        0.064,
        0.071,
        None,
        None,
        0.014,
        0.037,
        0.063,
        0.060,
        0.043,
        0.045
    ],
    'Model 3 Sig': [
        '***',
        '***',
        '***',
        '***',
        '***',
        '',
        '***',
        '***',
        '',
        '',
        '***',
        '***',
        '**',
        '***',
        '***',
        '***'
    ],
    'Model 4 Coef': [
        0.672,
        0.324,
        0.012,
        -0.058,
        -0.098,
        -0.030,
        0.477,
        0.646,
        0.313,
        0.438,
        0.081,
        -0.115,
        0.156,
        -0.327,
        -0.106,
        None
    ],
    'Model 4 SE': [
        0.028,
        0.028,
        0.001,
        0.018,
        0.010,
        0.012,
        0.077,
        0.085,
        0.058,
        0.067,
        0.016,
        0.041,
        0.068,
        0.070,
        0.047,
        None
    ],
    'Model 4 Sig': [
        '***',
        '***',
        '***',
        '***',
        '***',
        '*',
        '***',
        '***',
        '***',
        '***',
        '***',
        '**',
        '*',
        '***',
        '*',
        ''
    ]
}

df = pd.DataFrame(data)

# Remove rows where both models are NaN
df = df[~(df['Model 3 Coef'].isna() & df['Model 4 Coef'].isna())]

# Set positions
x = np.arange(len(df))
width = 0.35

fig, ax = plt.subplots(figsize=(12, 6))

# Bars for Model 3
bars1 = ax.bar(x - width/2, df['Model 3 Coef'], width,
               yerr=df['Model 3 SE'], label='Model 3',
               capsize=5, color='mediumseagreen', edgecolor='black')

# Bars for Model 4
bars2 = ax.bar(x + width/2, df['Model 4 Coef'], width,
               yerr=df['Model 4 SE'], label='Model 4',
               capsize=5, color='salmon', edgecolor='black')

# Reference line
ax.axhline(0, color='gray', linestyle='--')

# Labels
ax.set_ylabel('Coefficient')
ax.set_title('Significant Predictors at age 13 of Maths Scores at Age 15')
ax.set_xticks(x)
ax.set_xticklabels(df['Variable'], rotation=45, ha='right')
ax.legend()

# Add significance stars
for i, (bar, sig) in enumerate(zip(bars1, df['Model 3 Sig'])):
    if sig:
        height = bar.get_height()
        ax.text(bar.get_x() + bar.get_width()/2, height + 0.02 if height > 0 else height - 0.05,
                sig, ha='center', va='bottom' if height > 0 else 'top', fontsize=12)

for i, (bar, sig) in enumerate(zip(bars2, df['Model 4 Sig'])):
    if sig:
        height = bar.get_height()
        ax.text(bar.get_x() + bar.get_width()/2, height + 0.02 if height > 0 else height - 0.05,
                sig, ha='center', va='bottom' if height > 0 else 'top', fontsize=12)

plt.tight_layout()
plt.show()



import pandas as pd
import matplotlib.pyplot as plt
import matplotlib.patches as patches

# Data for the table
data = {
    "Symbol": [r"$\bar{Y}_A$", r"$\bar{Y}_B$", r"$\bar{X}_A$", r"$\bar{X}_B$", r"$\beta_A$", r"$\beta_B$"],
    "Meaning": [
"Expected average Maths score for girls",
"Expected average Maths score for boys",
"Girls’ average characteristics (e.g., skills, income, etc.)",
"Boys’ average characteristics",
"Effect of each characteristic on girls’ Maths scores",
"Effect of each characteristic on boys’ Maths scores"
    ],
    "Context": [
        "Expected Maths scores for girls",
        "Expected Maths scores for boys",
        "Girls’ average characteristics (e.g. skills, income, etc.)",
        "Boys’ average characteristics",
        "How each characteristic affects girls’ Maths scores",
        "How each characteristic affects boys’ Maths scores"
    ]
}

df = pd.DataFrame(data)
# Create the figure and axis with adjusted aspect ratio for tighter Symbol column
fig, ax = plt.subplots(figsize=(12, 3))
ax.axis('off')

# Manually set column widths by adjusting colWidths (proportional widths)
col_widths = [0.12, 0.45, 0.43]

# Create updated table with custom column widths
table = plt.table(cellText=df.values,
                  colLabels=df.columns,
                  cellLoc='left',
                  colLoc='center',
                  loc='center',
                  colWidths=col_widths)

table.auto_set_font_size(False)
table.set_fontsize(10)
table.scale(1.2, 1.8)

# Style header
for i in range(len(df.columns)):
    table[0, i].set_facecolor("#cccccc")
    table[0, i].set_fontsize(11)
    table[0, i].set_text_props(weight='bold')

plt.tight_layout()



import pandas as pd
import matplotlib.pyplot as plt

# New data for father absence decomposition table
data_father = {
    "Symbol": [r"$\bar{Y}_P$", r"$\bar{Y}_A$", r"$\bar{X}_P$", r"$\bar{X}_A$", r"$\beta_P$", r"$\beta_A$"],
    "Meaning": [
"Expected average Maths score for boys/girls with present fathers",
"Expected average Maths score for boys/girls with absent fathers",
"Average characteristics for boys/girls with present fathers",
"Average characteristics for boys/girls with absent fathers",
"Effect of characteristics on Maths scores for boys/girls with present fathers",
"Effect of characteristics on Maths scores for boys/girls with absent fathers"
    ],
    "Context": [
        "Expected Maths scores for boys/girls with present fathers",
        "Expected Maths scores for boys/girls with absent fathers",
        "Average characteristics for present-father boys/girls",
        "Average characteristics for absent-father boys/girls",
        "How characteristics affect Maths scores for boys/girls with present fathers",
        "How characteristics affect Maths scores for boys/girls with absent fathers"
    ]
}

df_father = pd.DataFrame(data_father)

# Create the figure and axis
fig, ax = plt.subplots(figsize=(12, 3))
ax.axis('off')

# Manually set column widths to optimize layout
col_widths = [0.12, 0.45, 0.43]

# Create the table
table = plt.table(cellText=df_father.values,
                  colLabels=df_father.columns,
                  cellLoc='left',
                  colLoc='center',
                  loc='center',
                  colWidths=col_widths)

table.auto_set_font_size(False)
table.set_fontsize(10)
table.scale(1.2, 1.8)

# Style header
for i in range(len(df_father.columns)):
    table[0, i].set_facecolor("#cccccc")
    table[0, i].set_fontsize(11)
    table[0, i].set_text_props(weight='bold')

plt.tight_layout()
plt.savefig("/mnt/data/Father_Absence_Symbol_Table.png", dpi=300, bbox_inches='tight')
"/mnt/data/Father_Absence_Symbol_Table.png"





# English plots

import pandas as pd
import matplotlib.pyplot as plt
import numpy as np

# Data: Only significant estimates from both English models
data_english = {
    'Variable': [
        'Numerical Ability',
        'Reading Ability',
        'Conduct Problems',
        'Hyperactivity',
        'Mother’s Education\n(HS/Technical)',
        'Mother’s Education\n(Bachelor/Postgrad)',
        'Father’s Education\n(HS/Technical)',
        'Father’s Education\n(Bachelor/Postgrad)',
        'Income',
        'Male',
        'Father\'s Educ\nMissing'
    ],
    'Model 1 Coef': [
        0.169,
        0.456,
        -0.043,
        -0.081,
        0.313,
        0.495,
        None,
        None,
        0.100,
        -0.323,
        -0.229
    ],
    'Model 1 SE': [
        0.022,
        0.020,
        0.013,
        0.007,
        0.047,
        0.055,
        None,
        None,
        0.013,
        0.032,
        0.046
    ],
    'Model 1 Sig': [
        '***',
        '***',
        '***',
        '***',
        '***',
        '***',
        '',
        '',
        '***',
        '***',
        '***'
    ],
    'Model 2 Coef': [
        0.156,
        0.438,
        -0.034,
        -0.086,
        0.274,
        0.379,
        0.213,
        0.317,
        0.078,
        -0.350,
        None
    ],
    'Model 2 SE': [
        0.023,
        0.021,
        0.013,
        0.008,
        0.052,
        0.061,
        0.042,
        0.051,
        0.014,
        0.033,
        None
    ],
    'Model 2 Sig': [
        '***',
        '***',
        '**',
        '***',
        '***',
        '***',
        '***',
        '***',
        '***',
        '***',
        ''
    ]
}

# Create DataFrame
df_eng = pd.DataFrame(data_english)

# Remove rows where both models are NaN
df_eng = df_eng[~(df_eng['Model 1 Coef'].isna() & df_eng['Model 2 Coef'].isna())]

# Set positions
x = np.arange(len(df_eng))
width = 0.35

# Create figure
fig, ax = plt.subplots(figsize=(12, 6))

# Bars for Model 1
bars1 = ax.bar(x - width/2, df_eng['Model 1 Coef'], width,
               yerr=df_eng['Model 1 SE'], label='Model 1',
               capsize=5, color='steelblue', edgecolor='black')

# Bars for Model 2
bars2 = ax.bar(x + width/2, df_eng['Model 2 Coef'], width,
               yerr=df_eng['Model 2 SE'], label='Model 2',
               capsize=5, color='orange', edgecolor='black')

# Reference line at zero
ax.axhline(0, color='gray', linestyle='--')

# Labels
ax.set_ylabel('Coefficient')
ax.set_title('Significant Predictors at Age 9 of English Scores at Age 15')
ax.set_xticks(x)
ax.set_xticklabels(df_eng['Variable'], rotation=45, ha='right')
ax.legend()

# Add significance stars
for i, (bar1, sig1) in enumerate(zip(bars1, df_eng['Model 1 Sig'])):
    if sig1:
        height = bar1.get_height()
        ax.text(bar1.get_x() + bar1.get_width()/2,
                height + 0.02 if height > 0 else height - 0.05,
                sig1, ha='center', va='bottom' if height > 0 else 'top', fontsize=12)

for i, (bar2, sig2) in enumerate(zip(bars2, df_eng['Model 2 Sig'])):
    if sig2:
        height = bar2.get_height()
        ax.text(bar2.get_x() + bar2.get_width()/2,
                height + 0.02 if height > 0 else height - 0.05,
                sig2, ha='center', va='bottom' if height > 0 else 'top', fontsize=12)

plt.tight_layout()
plt.show()


import pandas as pd
import matplotlib.pyplot as plt
import numpy as np

# Data: Only significant estimates from English Models 3 and 4 (Wave 2 predictors)
data_eng_w2 = {
    'Variable': [
        'Numerical Ability',
        'Verbal Reasoning',
        'BAS Matrices',
        'Hyperactivity',
        'Peer-Relationship\nProblems',
        'Mother’s Education\n(HS/Technical)',
        'Mother’s Education\n(Bachelor/Postgrad)',
        'Father’s Education\n(HS/Technical)',
        'Father’s Education\n(Bachelor/Postgrad)',
        'Income',
        'Male',
        'DEIS School',
        'Father\'s Educ\nMissing'
    ],
    'Model 3 Coef': [
        0.277,
        0.461,
        0.004,
        -0.081,
        -0.039,
        0.199,
        0.284,
        None,
        None,
        0.069,
        -0.427,
        -0.365,
        -0.176
    ],
    'Model 3 SE': [
        0.023,
        0.022,
        0.001,
        0.008,
        0.012,
        0.056,
        0.062,
        None,
        None,
        0.012,
        0.032,
        0.053,
        0.039
    ],
    'Model 3 Sig': [
        '***',
        '***',
        '***',
        '***',
        '**',
        '***',
        '***',
        '',
        '',
        '***',
        '***',
        '***',
        '***'
    ],
    'Model 4 Coef': [
        0.271,
        0.441,
        0.004,
        -0.079,
        -0.045,
        0.184,
        0.225,
        0.100,
        0.151,
        0.058,
        -0.418,
        -0.319,
        None
    ],
    'Model 4 SE': [
        0.024,
        0.024,
        0.001,
        0.009,
        0.013,
        0.066,
        0.072,
        0.049,
        0.058,
        0.014,
        0.035,
        0.060,
        None
    ],
    'Model 4 Sig': [
        '***',
        '***',
        '***',
        '***',
        '***',
        '**',
        '***',
        '*',
        '**',
        '***',
        '***',
        '***',
        ''
    ]
}

df_eng_w2 = pd.DataFrame(data_eng_w2)

# Remove rows where both models are NaN
df_eng_w2 = df_eng_w2[~(df_eng_w2['Model 3 Coef'].isna() & df_eng_w2['Model 4 Coef'].isna())]

# Set positions
x = np.arange(len(df_eng_w2))
width = 0.35

fig, ax = plt.subplots(figsize=(12, 6))

# Bars for Model 3
bars1 = ax.bar(x - width/2, df_eng_w2['Model 3 Coef'], width,
               yerr=df_eng_w2['Model 3 SE'], label='Model 3',
               capsize=5, color='mediumseagreen', edgecolor='black')

# Bars for Model 4
bars2 = ax.bar(x + width/2, df_eng_w2['Model 4 Coef'], width,
               yerr=df_eng_w2['Model 4 SE'], label='Model 4',
               capsize=5, color='salmon', edgecolor='black')

# Reference line
ax.axhline(0, color='gray', linestyle='--')

# Labels
ax.set_ylabel('Coefficient')
ax.set_title('Significant Predictors at Age 13 of English Scores at Age 15')
ax.set_xticks(x)
ax.set_xticklabels(df_eng_w2['Variable'], rotation=45, ha='right')
ax.legend()

# Add significance stars
for i, (bar1, sig1) in enumerate(zip(bars1, df_eng_w2['Model 3 Sig'])):
    if sig1:
        height = bar1.get_height()
        ax.text(bar1.get_x() + bar1.get_width()/2,
                height + 0.02 if height > 0 else height - 0.05,
                sig1, ha='center', va='bottom' if height > 0 else 'top', fontsize=12)

for i, (bar2, sig2) in enumerate(zip(bars2, df_eng_w2['Model 4 Sig'])):
    if sig2:
        height = bar2.get_height()
        ax.text(bar2.get_x() + bar2.get_width()/2,
                height + 0.02 if height > 0 else height - 0.05,
                sig2, ha='center', va='bottom' if height > 0 else 'top', fontsize=12)

plt.tight_layout()


import pandas as pd
from tabulate import tabulate

# Create a DataFrame with your summary statistics
data = [
    ["Maths points (Junior Cert)", 5926, 9.57, 1.76, 2, 12],
    ["English points (Junior Cert)", 5906, 10.13, 1.35, 5, 12],
    ["Reading Ability (Logit, W1)", 5917, 0.23, 0.98, -3.36, 2.87],
    ["Maths Ability (Logit, W1)", 5977, -0.57, 0.91, -3.62, 1.90],
    ["Verbal Reasoning (Logit, W2)", 5785, 0.03, 0.89, -2.55, 1.78],
    ["Numerical Ability (Logit, W2)", 5757, 0.02, 0.89, -2.36, 2.11],
    ["Total Reasoning Score (Logit, W2)", 5790, 0.04, 0.92, -2.75, 2.57],
    ["BAS Matrices (W2)", 5537, 117.00, 18.30, 10, 161],
    ["Emotional Symptoms (W1)", 6034, 1.99, 1.96, 0, 10],
    ["Conduct Problems (W1)", 6030, 1.21, 1.41, 0, 10],
    ["Hyperactivity (W1)", 6028, 2.92, 2.41, 0, 10],
    ["Peer Problems (W1)", 6024, 1.12, 1.43, 0, 10],
    ["Emotional Symptoms (W2)", 6038, 1.75, 1.90, 0, 10],
    ["Conduct Problems (W2)", 6038, 1.05, 1.35, 0, 10],
    ["Hyperactivity (W2)", 6038, 2.50, 2.31, 0, 10],
    ["Peer Problems (W2)", 6038, 1.07, 1.45, 0, 10],
    ["Male", 6039, 0.49, 0.50, 0, 1],
    ["PCG Education (W1)", 6039, 3.77, 1.26, 1, 6],
    ["SCG Education (W1)", 5197, 3.61, 1.42, 1, 6],
    ["PCG Education (W2)", 6039, 3.94, 1.24, 1, 6],
    ["SCG Education (W2)", 4704, 3.84, 1.37, 1, 6],
    ["PCG Education (3-4) (W1)", 6039, 0.56, 0.50, 0, 1],
    ["PCG Education (5-6) (W1)", 6039, 0.29, 0.45, 0, 1],
    ["SCG Education (3-4) (W1)", 5197, 0.46, 0.50, 0, 1],
    ["SCG Education (5-6) (W1)", 5197, 0.29, 0.46, 0, 1],
    ["Income Quintile (W1)", 5613, 3.41, 1.34, 1, 5],
    ["PCG Education (3-4) (W2)", 6039, 0.57, 0.50, 0, 1],
    ["PCG Education (5-6) (W2)", 6039, 0.33, 0.47, 0, 1],
    ["SCG Education (3-4) (W2)", 4704, 0.49, 0.50, 0, 1],
    ["SCG Education (5-6) (W2)", 4704, 0.34, 0.47, 0, 1],
    ["Income Quintile (W2)", 5610, 3.31, 1.40, 1, 5],
    ["Fee-Paying (W2)", 5811, 0.10, 0.30, 0, 1],
    ["DEIS (W2)", 5811, 0.13, 0.33, 0, 1],
    ["Religious School (W2)", 6039, 0.66, 0.47, 0, 1],
    ["Mixed School (W1)", 5652, 0.76, 0.43, 0, 1],
    ["Mixed School (W2)", 5663, 0.54, 0.50, 0, 1],
]

# Define column names
columns = ["Variable", "Obs", "Mean", "Std. Dev.", "Min", "Max"]

# Create DataFrame
df = pd.DataFrame(data, columns=columns)

# Print the table nicely
print(tabulate(df, headers="keys", tablefmt="fancy_grid", floatfmt=".2f"))


