# -*- coding: utf-8 -*-
"""
Created on Fri Apr 11 14:26:20 2025

@author: bgiet
"""

import pandas as pd
import numpy as np
import statsmodels.api as sm
from statsmodels.discrete.discrete_model import Logit
import matplotlib.pyplot as plt
from scipy import stats




# Load and prepare data
df = pd.read_csv("C:/Users/bgiet/OneDrive/Documents/decomposition_dataset.csv")
df = df.dropna()


# Wave 1 without the father's education data

# Step 1: Define the variables for the gender model (excluding the problematic variable)
X_gender = df[['Cog_Maths_W1_l', 'Cog_Reading_W1_l', 'SDQ_emot_PCG_W1', 'SDQ_cond_PCG_W1',
              'SDQ_hyper_PCG_W1', 'SDQ_peer_PCG_W1', 'PCG_Educ_W1_Dummy34', 'PCG_Educ_W1_Dummy56',
              'Income_equi_quint_W1', 'mixed_school_w1']]  # Excluded Father_Educ_Missing_W1

# Step 2: Create a binary variable for gender
y_gender = df['Gender_binary']

# Step 3: Fit the logit model
logit_model = Logit(y_gender, sm.add_constant(X_gender)).fit(disp=0)
print(logit_model.summary())

# Step 4: Calculate propensity scores and weights
df['p_boy'] = logit_model.predict()

# Ensure propensity scores aren't too close to 0 or 1
epsilon = 0.001
df['p_boy'] = df['p_boy'].clip(epsilon, 1-epsilon)

# Calculate weights for girls
df['weight'] = np.where(df['Gender_binary'] == 0, 
                      df['p_boy'] / (1 - df['p_boy']), 
                      1)

# Step 5: Generate distributions
boys_actual = df[df['Gender_binary'] == 1]['Maths_Points_Adjusted']
girls_actual = df[df['Gender_binary'] == 0]['Maths_Points_Adjusted']

# Sample with replacement using weights
girls_weights = df.loc[df['Gender_binary'] == 0, 'weight']
girls_weights = girls_weights / girls_weights.sum()  # Normalize weights to sum to 1

girls_counterfactual = np.random.choice(
    girls_actual, 
    size=len(girls_actual), 
    replace=True, 
    p=girls_weights
)

# Step 6: Analyze distributions
print("\nDescriptive Statistics:")
print(f"Boys actual - Mean: {boys_actual.mean():.2f}, Std: {boys_actual.std():.2f}")
print(f"Girls actual - Mean: {girls_actual.mean():.2f}, Std: {girls_actual.std():.2f}")
print(f"Girls counterfactual - Mean: {np.mean(girls_counterfactual):.2f}, Std: {np.std(girls_counterfactual):.2f}")

# Step 7: Decomposition
total_gap = boys_actual.mean() - girls_actual.mean()
composition_effect = np.mean(girls_counterfactual) - girls_actual.mean()
structure_effect = boys_actual.mean() - np.mean(girls_counterfactual)

print("\nDFL Decomposition at the Mean:")
print(f"Total gap: {total_gap:.2f}")
print(f"Composition effect: {composition_effect:.2f} ({100 * composition_effect / total_gap:.2f}%)")
print(f"Structure effect: {structure_effect:.2f} ({100 * structure_effect / total_gap:.2f}%)")

# Step 8: Create visualizations
plt.figure(figsize=(10, 6))

# Plot kernel density estimates
boys_kde = stats.gaussian_kde(boys_actual)
girls_kde = stats.gaussian_kde(girls_actual)
counterfactual_kde = stats.gaussian_kde(girls_counterfactual)

x = np.linspace(0, 150, 1000)
plt.plot(x, boys_kde(x), 'b-', label='Boys Actual')
plt.plot(x, girls_kde(x), 'r-', label='Girls Actual')
plt.plot(x, counterfactual_kde(x), 'g--', label='Girls Counterfactual')

plt.xlabel('Mathematics Score, Leaving Cert')
plt.ylabel('Density')
plt.title('DFL Decomposition - Math Score Distributions, Age 9 Predictors')
plt.legend()
plt.grid(True, alpha=0.3)

# Step 9: Analyze at quantiles
quantiles = [0.1, 0.25, 0.5, 0.75, 0.9]
boys_quant = np.quantile(boys_actual, quantiles)
girls_quant = np.quantile(girls_actual, quantiles)
counter_quant = np.quantile(girls_counterfactual, quantiles)

print("\nDecomposition at Different Quantiles:")
for i, q in enumerate(quantiles):
    q_total = boys_quant[i] - girls_quant[i]
    q_composition = counter_quant[i] - girls_quant[i]
    q_structure = boys_quant[i] - counter_quant[i]
    
    print(f"Quantile {q}:")
    print(f"  Total gap: {q_total:.2f}")
    
    # Handle division by zero
    if abs(q_total) < 0.001:  # If gap is essentially zero
        comp_pct = "N/A (gap is approximately zero)"
        struct_pct = "N/A (gap is approximately zero)"
    else:
        comp_pct = f"{100 * q_composition / q_total:.2f}%"
        struct_pct = f"{100 * q_structure / q_total:.2f}%"
    
    print(f"  Composition effect: {q_composition:.2f} ({comp_pct})")
    print(f"  Structure effect: {q_structure:.2f} ({struct_pct})")

plt.figure(figsize=(10, 6))
plt.plot(quantiles, boys_quant, 'b-o', label='Boys')
plt.plot(quantiles, girls_quant, 'r-o', label='Girls')
plt.plot(quantiles, counter_quant, 'g--o', label='Girls Counterfactual')
plt.xlabel('Quantile')
plt.ylabel('Mathematics Score, Leaving Cert')
plt.title("Quantile Decomposition - Predictors at age 9, without Father's Education")
plt.legend()
plt.grid(True)
plt.show()





# Wave 1 with the father's education data

# Step 1: Define the variables for the gender model (excluding the problematic variable)
X_gender = df[['Cog_Maths_W1_l', 'Cog_Reading_W1_l', 'SDQ_emot_PCG_W1', 'SDQ_cond_PCG_W1',
              'SDQ_hyper_PCG_W1', 'SDQ_peer_PCG_W1', 'PCG_Educ_W1_Dummy34', 'PCG_Educ_W1_Dummy56', 
              'SCG_Educ_W1_Dummy34', 'SCG_Educ_W1_Dummy56',
              'Income_equi_quint_W1', 'mixed_school_w1']]  # Excluded Father_Educ_Missing_W1

# Step 2: Create a binary variable for gender
y_gender = df['Gender_binary']

# Step 3: Fit the logit model
logit_model = Logit(y_gender, sm.add_constant(X_gender)).fit(disp=0)
print(logit_model.summary())

# Step 4: Calculate propensity scores and weights
df['p_boy'] = logit_model.predict()

# Ensure propensity scores aren't too close to 0 or 1
epsilon = 0.001
df['p_boy'] = df['p_boy'].clip(epsilon, 1-epsilon)

# Calculate weights for girls
df['weight'] = np.where(df['Gender_binary'] == 0, 
                      df['p_boy'] / (1 - df['p_boy']), 
                      1)

# Step 5: Generate distributions
boys_actual = df[df['Gender_binary'] == 1]['Maths_Points_Adjusted']
girls_actual = df[df['Gender_binary'] == 0]['Maths_Points_Adjusted']

# Sample with replacement using weights
girls_weights = df.loc[df['Gender_binary'] == 0, 'weight']
girls_weights = girls_weights / girls_weights.sum()  # Normalize weights to sum to 1

girls_counterfactual = np.random.choice(
    girls_actual, 
    size=len(girls_actual), 
    replace=True, 
    p=girls_weights
)

# Step 6: Analyze distributions
print("\nDescriptive Statistics:")
print(f"Boys actual - Mean: {boys_actual.mean():.2f}, Std: {boys_actual.std():.2f}")
print(f"Girls actual - Mean: {girls_actual.mean():.2f}, Std: {girls_actual.std():.2f}")
print(f"Girls counterfactual - Mean: {np.mean(girls_counterfactual):.2f}, Std: {np.std(girls_counterfactual):.2f}")

# Step 7: Decomposition
total_gap = boys_actual.mean() - girls_actual.mean()
composition_effect = np.mean(girls_counterfactual) - girls_actual.mean()
structure_effect = boys_actual.mean() - np.mean(girls_counterfactual)

print("\nDFL Decomposition at the Mean:")
print(f"Total gap: {total_gap:.2f}")
print(f"Composition effect: {composition_effect:.2f} ({100 * composition_effect / total_gap:.2f}%)")
print(f"Structure effect: {structure_effect:.2f} ({100 * structure_effect / total_gap:.2f}%)")

# Step 8: Create visualizations
plt.figure(figsize=(10, 6))

# Plot kernel density estimates
boys_kde = stats.gaussian_kde(boys_actual)
girls_kde = stats.gaussian_kde(girls_actual)
counterfactual_kde = stats.gaussian_kde(girls_counterfactual)

x = np.linspace(0, 150, 1000)
plt.plot(x, boys_kde(x), 'b-', label='Boys Actual')
plt.plot(x, girls_kde(x), 'r-', label='Girls Actual')
plt.plot(x, counterfactual_kde(x), 'g--', label='Girls Counterfactual')

plt.xlabel('Mathematics Score, Leaving Cert')
plt.ylabel('Density')
plt.title('DFL Decomposition - Math Score Distributions, Age 9 Predictors')
plt.legend()
plt.grid(True, alpha=0.3)

# Step 9: Analyze at quantiles
quantiles = [0.1, 0.25, 0.5, 0.75, 0.9]
boys_quant = np.quantile(boys_actual, quantiles)
girls_quant = np.quantile(girls_actual, quantiles)
counter_quant = np.quantile(girls_counterfactual, quantiles)

print("\nDecomposition at Different Quantiles:")
for i, q in enumerate(quantiles):
    q_total = boys_quant[i] - girls_quant[i]
    q_composition = counter_quant[i] - girls_quant[i]
    q_structure = boys_quant[i] - counter_quant[i]
    
    print(f"Quantile {q}:")
    print(f"  Total gap: {q_total:.2f}")
    
    # Handle division by zero
    if abs(q_total) < 0.001:  # If gap is essentially zero
        comp_pct = "N/A (gap is approximately zero)"
        struct_pct = "N/A (gap is approximately zero)"
    else:
        comp_pct = f"{100 * q_composition / q_total:.2f}%"
        struct_pct = f"{100 * q_structure / q_total:.2f}%"
    
    print(f"  Composition effect: {q_composition:.2f} ({comp_pct})")
    print(f"  Structure effect: {q_structure:.2f} ({struct_pct})")

plt.figure(figsize=(10, 6))
plt.plot(quantiles, boys_quant, 'b-o', label='Boys')
plt.plot(quantiles, girls_quant, 'r-o', label='Girls')
plt.plot(quantiles, counter_quant, 'g--o', label='Girls Counterfactual')
plt.xlabel('Quantile')
plt.ylabel('Mathematics Score')
plt.title("Quantile Decomposition - Predictors at age 9, with Father's Education")
plt.legend()
plt.grid(True)
plt.show()




# Wave 2 - Without the Father's Education

# Step 1: Define the variables for the gender model - using WAVE 2 predictors with proper capitalization
X_gender = df[['Drum_VR_W2_l', 'Drum_NA_W2_l', 'BAS_TS_Mat_W2',  
               'SDQ_emot_PCG_W2', 'SDQ_cond_PCG_W2', 'SDQ_hyper_PCG_W2', 'SDQ_peer_PCG_W2',
               'PCG_Educ_W2_Dummy34', 'PCG_Educ_W2_Dummy56', 'Income_equi_quint_W2',
               'Fee_paying_W2', 'DEIS_W2', 'mixed_school_w2', 'religious_school_w2']]  # Excluded Father_Educ_Missing_W2

# Step 2: Create a binary variable for gender
y_gender = df['Gender_binary']

# Step 3: Fit the logit model
logit_model = Logit(y_gender, sm.add_constant(X_gender)).fit(disp=0)
print(logit_model.summary())

# Step 4: Calculate propensity scores and weights
df['p_boy'] = logit_model.predict()

# Ensure propensity scores aren't too close to 0 or 1
epsilon = 0.001
df['p_boy'] = df['p_boy'].clip(epsilon, 1-epsilon)

# Calculate weights for girls
df['weight'] = np.where(df['Gender_binary'] == 0, 
                      df['p_boy'] / (1 - df['p_boy']), 
                      1)

# Step 5: Generate distributions
boys_actual = df[df['Gender_binary'] == 1]['Maths_Points_Adjusted']
girls_actual = df[df['Gender_binary'] == 0]['Maths_Points_Adjusted']

# Sample with replacement using weights
girls_weights = df.loc[df['Gender_binary'] == 0, 'weight']
girls_weights = girls_weights / girls_weights.sum()  # Normalize weights to sum to 1

# Use a fixed random seed for reproducibility
np.random.seed(42)
girls_counterfactual = np.random.choice(
    girls_actual, 
    size=len(girls_actual), 
    replace=True, 
    p=girls_weights
)

# Step 6: Analyze distributions
print("\nDescriptive Statistics:")
print(f"Boys actual - Mean: {boys_actual.mean():.2f}, Std: {boys_actual.std():.2f}")
print(f"Girls actual - Mean: {girls_actual.mean():.2f}, Std: {girls_actual.std():.2f}")
print(f"Girls counterfactual - Mean: {np.mean(girls_counterfactual):.2f}, Std: {np.std(girls_counterfactual):.2f}")

# Step 7: Decomposition
total_gap = boys_actual.mean() - girls_actual.mean()
composition_effect = np.mean(girls_counterfactual) - girls_actual.mean()
structure_effect = boys_actual.mean() - np.mean(girls_counterfactual)

print("\nDFL Decomposition at the Mean:")
print(f"Total gap: {total_gap:.2f}")
print(f"Composition effect: {composition_effect:.2f} ({100 * composition_effect / total_gap:.2f}%)")
print(f"Structure effect: {structure_effect:.2f} ({100 * structure_effect / total_gap:.2f}%)")

# Step 8: Create visualizations
plt.figure(figsize=(10, 6))

# Plot kernel density estimates
boys_kde = stats.gaussian_kde(boys_actual)
girls_kde = stats.gaussian_kde(girls_actual)
counterfactual_kde = stats.gaussian_kde(girls_counterfactual)

x = np.linspace(0, 150, 1000)
plt.plot(x, boys_kde(x), 'b-', label='Boys Actual')
plt.plot(x, girls_kde(x), 'r-', label='Girls Actual')
plt.plot(x, counterfactual_kde(x), 'g--', label='Girls Counterfactual')

plt.xlabel('Mathematics Score, Leaving Cert')
plt.ylabel('Density')
plt.title('DFL Decomposition - Math Score Distributions,  Age 13 Predictors')
plt.legend()
plt.grid(True, alpha=0.3)

# Step 9: Analyze at quantiles
quantiles = [0.1, 0.25, 0.5, 0.75, 0.9]
boys_quant = np.quantile(boys_actual, quantiles)
girls_quant = np.quantile(girls_actual, quantiles)
counter_quant = np.quantile(girls_counterfactual, quantiles)

print("\nDecomposition at Different Quantiles:")
for i, q in enumerate(quantiles):
    q_total = boys_quant[i] - girls_quant[i]
    q_composition = counter_quant[i] - girls_quant[i]
    q_structure = boys_quant[i] - counter_quant[i]
    
    print(f"Quantile {q}:")
    print(f"  Total gap: {q_total:.2f}")
    
    # Handle division by zero
    if abs(q_total) < 0.001:  # If gap is essentially zero
        comp_pct = "N/A (gap is approximately zero)"
        struct_pct = "N/A (gap is approximately zero)"
    else:
        comp_pct = f"{100 * q_composition / q_total:.2f}%"
        struct_pct = f"{100 * q_structure / q_total:.2f}%"
    
    print(f"  Composition effect: {q_composition:.2f} ({comp_pct})")
    print(f"  Structure effect: {q_structure:.2f} ({struct_pct})")

plt.figure(figsize=(10, 6))
plt.plot(quantiles, boys_quant, 'b-o', label='Boys')
plt.plot(quantiles, girls_quant, 'r-o', label='Girls')
plt.plot(quantiles, counter_quant, 'g--o', label='Girls Counterfactual')
plt.xlabel('Quantile')
plt.ylabel('Mathematics Score')
plt.title("Quantile Decomposition - Predictors at age 13, without Father's Education")
plt.legend()
plt.grid(True)
plt.show()



# Wave 2 - With the Father's Education


# Step 1: Define the variables for the gender model - using WAVE 2 predictors with proper capitalization
X_gender = df[['Drum_VR_W2_l', 'Drum_NA_W2_l', 'BAS_TS_Mat_W2',  
               'SDQ_emot_PCG_W2', 'SDQ_cond_PCG_W2', 'SDQ_hyper_PCG_W2', 'SDQ_peer_PCG_W2',
               'PCG_Educ_W2_Dummy34', 'PCG_Educ_W2_Dummy56', 'Income_equi_quint_W2',
               'SCG_Educ_W2_Dummy34', 'SCG_Educ_W2_Dummy56',
               'Fee_paying_W2', 'DEIS_W2', 'mixed_school_w2', 'religious_school_w2']]  # Excluded Father_Educ_Missing_W2

# Step 2: Create a binary variable for gender
y_gender = df['Gender_binary']

# Step 3: Fit the logit model
logit_model = Logit(y_gender, sm.add_constant(X_gender)).fit(disp=0)
print(logit_model.summary())

# Step 4: Calculate propensity scores and weights
df['p_boy'] = logit_model.predict()

# Ensure propensity scores aren't too close to 0 or 1
epsilon = 0.001
df['p_boy'] = df['p_boy'].clip(epsilon, 1-epsilon)

# Calculate weights for girls
df['weight'] = np.where(df['Gender_binary'] == 0, 
                      df['p_boy'] / (1 - df['p_boy']), 
                      1)

# Step 5: Generate distributions
boys_actual = df[df['Gender_binary'] == 1]['Maths_Points_Adjusted']
girls_actual = df[df['Gender_binary'] == 0]['Maths_Points_Adjusted']

# Sample with replacement using weights
girls_weights = df.loc[df['Gender_binary'] == 0, 'weight']
girls_weights = girls_weights / girls_weights.sum()  # Normalize weights to sum to 1

# Use a fixed random seed for reproducibility
np.random.seed(42)
girls_counterfactual = np.random.choice(
    girls_actual, 
    size=len(girls_actual), 
    replace=True, 
    p=girls_weights
)

# Step 6: Analyze distributions
print("\nDescriptive Statistics:")
print(f"Boys actual - Mean: {boys_actual.mean():.2f}, Std: {boys_actual.std():.2f}")
print(f"Girls actual - Mean: {girls_actual.mean():.2f}, Std: {girls_actual.std():.2f}")
print(f"Girls counterfactual - Mean: {np.mean(girls_counterfactual):.2f}, Std: {np.std(girls_counterfactual):.2f}")

# Step 7: Decomposition
total_gap = boys_actual.mean() - girls_actual.mean()
composition_effect = np.mean(girls_counterfactual) - girls_actual.mean()
structure_effect = boys_actual.mean() - np.mean(girls_counterfactual)

print("\nDFL Decomposition at the Mean:")
print(f"Total gap: {total_gap:.2f}")
print(f"Composition effect: {composition_effect:.2f} ({100 * composition_effect / total_gap:.2f}%)")
print(f"Structure effect: {structure_effect:.2f} ({100 * structure_effect / total_gap:.2f}%)")

# Step 8: Create visualizations
plt.figure(figsize=(10, 6))

# Plot kernel density estimates
boys_kde = stats.gaussian_kde(boys_actual)
girls_kde = stats.gaussian_kde(girls_actual)
counterfactual_kde = stats.gaussian_kde(girls_counterfactual)

x = np.linspace(0, 150, 1000)
plt.plot(x, boys_kde(x), 'b-', label='Boys Actual')
plt.plot(x, girls_kde(x), 'r-', label='Girls Actual')
plt.plot(x, counterfactual_kde(x), 'g--', label='Girls Counterfactual')

plt.xlabel('Mathematics Score, Leaving Cert')
plt.ylabel('Density')
plt.title('DFL Decomposition - Math Score Distributions, Age 13 Predictors')
plt.legend()
plt.grid(True, alpha=0.3)

# Step 9: Analyze at quantiles
quantiles = [0.1, 0.25, 0.5, 0.75, 0.9]
boys_quant = np.quantile(boys_actual, quantiles)
girls_quant = np.quantile(girls_actual, quantiles)
counter_quant = np.quantile(girls_counterfactual, quantiles)

print("\nDecomposition at Different Quantiles:")
for i, q in enumerate(quantiles):
    q_total = boys_quant[i] - girls_quant[i]
    q_composition = counter_quant[i] - girls_quant[i]
    q_structure = boys_quant[i] - counter_quant[i]
    
    print(f"Quantile {q}:")
    print(f"  Total gap: {q_total:.2f}")
    
    # Handle division by zero
    if abs(q_total) < 0.001:  # If gap is essentially zero
        comp_pct = "N/A (gap is approximately zero)"
        struct_pct = "N/A (gap is approximately zero)"
    else:
        comp_pct = f"{100 * q_composition / q_total:.2f}%"
        struct_pct = f"{100 * q_structure / q_total:.2f}%"
    
    print(f"  Composition effect: {q_composition:.2f} ({comp_pct})")
    print(f"  Structure effect: {q_structure:.2f} ({struct_pct})")

plt.figure(figsize=(10, 6))
plt.plot(quantiles, boys_quant, 'b-o', label='Boys')
plt.plot(quantiles, girls_quant, 'r-o', label='Girls')
plt.plot(quantiles, counter_quant, 'g--o', label='Girls Counterfactual')
plt.xlabel('Quantile')
plt.ylabel('Mathematics Score')
plt.title("Quantile Decomposition - Predictors at age 13, with Father's Education")
plt.legend()
plt.grid(True)
plt.show()


# Code to create combined plots for DFL decomposition analysis
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
from scipy import stats
import statsmodels.api as sm
from statsmodels.discrete.discrete_model import Logit

# Run your data prep and model fitting code first (only once)
# ...

# Create figures for all plots
fig_density, axs_density = plt.subplots(2, 2, figsize=(16, 12))
fig_density.suptitle('DFL Decomposition - Math Score Distributions', fontsize=18)

fig_quantile, axs_quantile = plt.subplots(2, 2, figsize=(16, 12))
fig_quantile.suptitle('Quantile Decomposition - Math Score Distributions', fontsize=18)

# Define quantiles for all analyses
quantiles = [0.1, 0.25, 0.5, 0.75, 0.9]

# Function for running DFL analysis and creating plots
def run_dfl_analysis(X_gender, title, ax_density, ax_quantile, row_name):
    """
    Run DFL analysis and create plots
    
    Parameters:
    -----------
    X_gender : DataFrame
        Predictors for the gender model
    title : str
        Title for plots (e.g., "Age 9 Predictors, without Father's Education")
    ax_density : matplotlib axis
        Axis for density plot
    ax_quantile : matplotlib axis
        Axis for quantile plot
    row_name : str
        Used for printing results (e.g., "Wave 1 without father's education")
    """
    # Create binary variable for gender
    y_gender = df['Gender_binary']
    
    # Fit logit model
    logit_model = Logit(y_gender, sm.add_constant(X_gender)).fit(disp=0)
    print(f"\n===== {row_name} =====")
    print(logit_model.summary())
    
    # Calculate propensity scores and weights
    df['p_boy'] = logit_model.predict()
    
    # Ensure propensity scores aren't too close to 0 or 1
    epsilon = 0.001
    df['p_boy'] = df['p_boy'].clip(epsilon, 1-epsilon)
    
    # Calculate weights for girls
    df['weight'] = np.where(df['Gender_binary'] == 0, 
                          df['p_boy'] / (1 - df['p_boy']), 
                          1)
    
    # Generate distributions
    boys_actual = df[df['Gender_binary'] == 1]['Maths_Points_Adjusted']
    girls_actual = df[df['Gender_binary'] == 0]['Maths_Points_Adjusted']
    
    # Sample with replacement using weights
    girls_weights = df.loc[df['Gender_binary'] == 0, 'weight']
    girls_weights = girls_weights / girls_weights.sum()  # Normalize weights to sum to 1
    
    # Use a fixed random seed for reproducibility
    np.random.seed(42)
    girls_counterfactual = np.random.choice(
        girls_actual, 
        size=len(girls_actual), 
        replace=True, 
        p=girls_weights
    )
    
    # Analyze distributions
    print("\nDescriptive Statistics:")
    print(f"Boys actual - Mean: {boys_actual.mean():.2f}, Std: {boys_actual.std():.2f}")
    print(f"Girls actual - Mean: {girls_actual.mean():.2f}, Std: {girls_actual.std():.2f}")
    print(f"Girls counterfactual - Mean: {np.mean(girls_counterfactual):.2f}, Std: {np.std(girls_counterfactual):.2f}")
    
    # Decomposition
    total_gap = boys_actual.mean() - girls_actual.mean()
    composition_effect = np.mean(girls_counterfactual) - girls_actual.mean()
    structure_effect = boys_actual.mean() - np.mean(girls_counterfactual)
    
    print("\nDFL Decomposition at the Mean:")
    print(f"Total gap: {total_gap:.2f}")
    print(f"Composition effect: {composition_effect:.2f} ({100 * composition_effect / total_gap:.2f}%)")
    print(f"Structure effect: {structure_effect:.2f} ({100 * structure_effect / total_gap:.2f}%)")
    
    # Create density plot
    x = np.linspace(0, 150, 1000)
    boys_kde = stats.gaussian_kde(boys_actual)
    girls_kde = stats.gaussian_kde(girls_actual)
    counterfactual_kde = stats.gaussian_kde(girls_counterfactual)
    
    ax_density.plot(x, boys_kde(x), 'b-', label='Boys Actual')
    ax_density.plot(x, girls_kde(x), 'r-', label='Girls Actual')
    ax_density.plot(x, counterfactual_kde(x), 'g--', label='Girls Counterfactual')
    ax_density.set_xlabel('Mathematics Score, Leaving Cert')
    ax_density.set_ylabel('Density')
    ax_density.set_title(title)
    ax_density.legend()
    ax_density.grid(True, alpha=0.3)
    
    # Analyze at quantiles
    boys_quant = np.quantile(boys_actual, quantiles)
    girls_quant = np.quantile(girls_actual, quantiles)
    counter_quant = np.quantile(girls_counterfactual, quantiles)
    
    print("\nDecomposition at Different Quantiles:")
    for i, q in enumerate(quantiles):
        q_total = boys_quant[i] - girls_quant[i]
        q_composition = counter_quant[i] - girls_quant[i]
        q_structure = boys_quant[i] - counter_quant[i]
        
        print(f"Quantile {q}:")
        print(f"  Total gap: {q_total:.2f}")
        
        # Handle division by zero
        if abs(q_total) < 0.001:  # If gap is essentially zero
            comp_pct = "N/A (gap is approximately zero)"
            struct_pct = "N/A (gap is approximately zero)"
        else:
            comp_pct = f"{100 * q_composition / q_total:.2f}%"
            struct_pct = f"{100 * q_structure / q_total:.2f}%"
        
        print(f"  Composition effect: {q_composition:.2f} ({comp_pct})")
        print(f"  Structure effect: {q_structure:.2f} ({struct_pct})")
    
    # Create quantile plot
    ax_quantile.plot(quantiles, boys_quant, 'b-o', label='Boys')
    ax_quantile.plot(quantiles, girls_quant, 'r-o', label='Girls')
    ax_quantile.plot(quantiles, counter_quant, 'g--o', label='Girls Counterfactual')
    ax_quantile.set_xlabel('Quantile')
    ax_quantile.set_ylabel('Mathematics Score, Leaving Cert')
    ax_quantile.set_title(title)
    ax_quantile.legend()
    ax_quantile.grid(True)
    
    return boys_actual, girls_actual, girls_counterfactual

# 1. Wave 1 without father's education
X_gender_w1_no = df[['Cog_Maths_W1_l', 'Cog_Reading_W1_l', 'SDQ_emot_PCG_W1', 'SDQ_cond_PCG_W1',
                  'SDQ_hyper_PCG_W1', 'SDQ_peer_PCG_W1', 'PCG_Educ_W1_Dummy34', 'PCG_Educ_W1_Dummy56',
                  'Income_equi_quint_W1', 'mixed_school_w1']]

run_dfl_analysis(
    X_gender_w1_no, 
    "Age 9 Predictors, without Father's Education",
    axs_density[0, 0], 
    axs_quantile[0, 0],
    "Wave 1 without father's education"
)

# 2. Wave 1 with father's education
X_gender_w1_with = df[['Cog_Maths_W1_l', 'Cog_Reading_W1_l', 'SDQ_emot_PCG_W1', 'SDQ_cond_PCG_W1',
                    'SDQ_hyper_PCG_W1', 'SDQ_peer_PCG_W1', 'PCG_Educ_W1_Dummy34', 'PCG_Educ_W1_Dummy56', 
                    'SCG_Educ_W1_Dummy34', 'SCG_Educ_W1_Dummy56',
                    'Income_equi_quint_W1', 'mixed_school_w1']]

run_dfl_analysis(
    X_gender_w1_with, 
    "Age 9 Predictors, with Father's Education",
    axs_density[0, 1], 
    axs_quantile[0, 1],
    "Wave 1 with father's education"
)

# 3. Wave 2 without father's education
X_gender_w2_no = df[['Drum_VR_W2_l', 'Drum_NA_W2_l', 'BAS_TS_Mat_W2',  
                   'SDQ_emot_PCG_W2', 'SDQ_cond_PCG_W2', 'SDQ_hyper_PCG_W2', 'SDQ_peer_PCG_W2',
                   'PCG_Educ_W2_Dummy34', 'PCG_Educ_W2_Dummy56', 'Income_equi_quint_W2',
                   'Fee_paying_W2', 'DEIS_W2', 'mixed_school_w2', 'religious_school_w2']]

run_dfl_analysis(
    X_gender_w2_no, 
    "Age 13 Predictors, without Father's Education",
    axs_density[1, 0], 
    axs_quantile[1, 0],
    "Wave 2 without father's education"
)

# 4. Wave 2 with father's education
X_gender_w2_with = df[['Drum_VR_W2_l', 'Drum_NA_W2_l', 'BAS_TS_Mat_W2',  
                     'SDQ_emot_PCG_W2', 'SDQ_cond_PCG_W2', 'SDQ_hyper_PCG_W2', 'SDQ_peer_PCG_W2',
                     'PCG_Educ_W2_Dummy34', 'PCG_Educ_W2_Dummy56', 'Income_equi_quint_W2',
                     'SCG_Educ_W2_Dummy34', 'SCG_Educ_W2_Dummy56',
                     'Fee_paying_W2', 'DEIS_W2', 'mixed_school_w2', 'religious_school_w2']]

run_dfl_analysis(
    X_gender_w2_with, 
    "Age 13 Predictors, with Father's Education",
    axs_density[1, 1], 
    axs_quantile[1, 1],
    "Wave 2 with father's education"
)

# Adjust layout and save figures
fig_density.tight_layout(rect=[0, 0, 1, 0.96])
fig_quantile.tight_layout(rect=[0, 0, 1, 0.96])

# Save figures
fig_density.savefig('combined_density_plots.png', dpi=300, bbox_inches='tight')
fig_quantile.savefig('combined_quantile_plots.png', dpi=300, bbox_inches='tight')

plt.show()





import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
from scipy import stats
import statsmodels.api as sm
from statsmodels.discrete.discrete_model import Logit

# Create the figures upfront
fig_density, axs_density = plt.subplots(2, 2, figsize=(16, 12))
fig_density.suptitle('DFL Decomposition - Math Score Distributions', fontsize=18)

fig_quantile, axs_quantile = plt.subplots(2, 2, figsize=(16, 12))
fig_quantile.suptitle('Quantile Decomposition - Math Score Distributions', fontsize=18)

# Define quantiles for all analyses
quantiles = [0.1, 0.25, 0.5, 0.75, 0.9]

# Set random seed for reproducibility
np.random.seed(42)

# 1. Wave 1 without father's education
print("\n===== Wave 1 without father's education =====")

# Define predictors
X_w1_no_father = df[['Cog_Maths_W1_l', 'Cog_Reading_W1_l', 'SDQ_emot_PCG_W1', 'SDQ_cond_PCG_W1',
                     'SDQ_hyper_PCG_W1', 'SDQ_peer_PCG_W1', 'PCG_Educ_W1_Dummy34', 'PCG_Educ_W1_Dummy56',
                     'Income_equi_quint_W1', 'mixed_school_w1']]

# Fit model
logit_w1_no_father = Logit(df['Gender_binary'], sm.add_constant(X_w1_no_father)).fit(disp=0)
print(logit_w1_no_father.summary())

# Calculate propensity scores and weights
df['p_boy_w1_no_father'] = logit_w1_no_father.predict()
df['p_boy_w1_no_father'] = df['p_boy_w1_no_father'].clip(0.001, 0.999)  # Avoid extreme values
df['weight_w1_no_father'] = np.where(df['Gender_binary'] == 0, 
                                   df['p_boy_w1_no_father'] / (1 - df['p_boy_w1_no_father']), 
                                   1)

# Generate distributions
boys_w1_no_father = df[df['Gender_binary'] == 1]['Maths_Points_Adjusted']
girls_w1_no_father = df[df['Gender_binary'] == 0]['Maths_Points_Adjusted']

# Sample with replacement using weights
girls_weights_w1_no_father = df.loc[df['Gender_binary'] == 0, 'weight_w1_no_father']
girls_weights_w1_no_father = girls_weights_w1_no_father / girls_weights_w1_no_father.sum()

girls_counter_w1_no_father = np.random.choice(
    girls_w1_no_father, 
    size=len(girls_w1_no_father), 
    replace=True, 
    p=girls_weights_w1_no_father
)

# Analyze distributions
print("\nDescriptive Statistics:")
print(f"Boys actual - Mean: {boys_w1_no_father.mean():.2f}, Std: {boys_w1_no_father.std():.2f}")
print(f"Girls actual - Mean: {girls_w1_no_father.mean():.2f}, Std: {girls_w1_no_father.std():.2f}")
print(f"Girls counterfactual - Mean: {np.mean(girls_counter_w1_no_father):.2f}, Std: {np.std(girls_counter_w1_no_father):.2f}")

# Decomposition
total_gap_w1_no_father = boys_w1_no_father.mean() - girls_w1_no_father.mean()
composition_w1_no_father = np.mean(girls_counter_w1_no_father) - girls_w1_no_father.mean()
structure_w1_no_father = boys_w1_no_father.mean() - np.mean(girls_counter_w1_no_father)

print("\nDFL Decomposition at the Mean:")
print(f"Total gap: {total_gap_w1_no_father:.2f}")
print(f"Composition effect: {composition_w1_no_father:.2f} ({100 * composition_w1_no_father / total_gap_w1_no_father:.2f}%)")
print(f"Structure effect: {structure_w1_no_father:.2f} ({100 * structure_w1_no_father / total_gap_w1_no_father:.2f}%)")

# Plot density
x = np.linspace(0, 150, 1000)
boys_kde_w1_no_father = stats.gaussian_kde(boys_w1_no_father)
girls_kde_w1_no_father = stats.gaussian_kde(girls_w1_no_father)
counter_kde_w1_no_father = stats.gaussian_kde(girls_counter_w1_no_father)

axs_density[0, 0].plot(x, boys_kde_w1_no_father(x), 'b-', label='Boys Actual')
axs_density[0, 0].plot(x, girls_kde_w1_no_father(x), 'r-', label='Girls Actual')
axs_density[0, 0].plot(x, counter_kde_w1_no_father(x), 'g--', label='Girls Counterfactual')
axs_density[0, 0].set_xlabel('Mathematics Score, Leaving Cert')
axs_density[0, 0].set_ylabel('Density')
axs_density[0, 0].set_title("Age 9 Predictors, without Father's Education")
axs_density[0, 0].legend()
axs_density[0, 0].grid(True, alpha=0.3)

# Calculate quantiles
boys_quant_w1_no_father = np.quantile(boys_w1_no_father, quantiles)
girls_quant_w1_no_father = np.quantile(girls_w1_no_father, quantiles)
counter_quant_w1_no_father = np.quantile(girls_counter_w1_no_father, quantiles)

# Print quantile decomposition
print("\nDecomposition at Different Quantiles:")
for i, q in enumerate(quantiles):
    q_total = boys_quant_w1_no_father[i] - girls_quant_w1_no_father[i]
    q_composition = counter_quant_w1_no_father[i] - girls_quant_w1_no_father[i]
    q_structure = boys_quant_w1_no_father[i] - counter_quant_w1_no_father[i]
    
    print(f"Quantile {q}:")
    print(f"  Total gap: {q_total:.2f}")
    
    # Handle division by zero
    if abs(q_total) < 0.001:
        comp_pct = "N/A (gap is approximately zero)"
        struct_pct = "N/A (gap is approximately zero)"
    else:
        comp_pct = f"{100 * q_composition / q_total:.2f}%"
        struct_pct = f"{100 * q_structure / q_total:.2f}%"
    
    print(f"  Composition effect: {q_composition:.2f} ({comp_pct})")
    print(f"  Structure effect: {q_structure:.2f} ({struct_pct})")

# Plot quantiles
axs_quantile[0, 0].plot(quantiles, boys_quant_w1_no_father, 'b-o', label='Boys')
axs_quantile[0, 0].plot(quantiles, girls_quant_w1_no_father, 'r-o', label='Girls')
axs_quantile[0, 0].plot(quantiles, counter_quant_w1_no_father, 'g--o', label='Girls Counterfactual')
axs_quantile[0, 0].set_xlabel('Quantile')
axs_quantile[0, 0].set_ylabel('Mathematics Score, Leaving Cert')
axs_quantile[0, 0].set_title("Age 9 Predictors, without Father's Education")
axs_quantile[0, 0].legend()
axs_quantile[0, 0].grid(True)


# 2. Wave 1 with father's education
print("\n===== Wave 1 with father's education =====")

# Define predictors
X_w1_with_father = df[['Cog_Maths_W1_l', 'Cog_Reading_W1_l', 'SDQ_emot_PCG_W1', 'SDQ_cond_PCG_W1',
                      'SDQ_hyper_PCG_W1', 'SDQ_peer_PCG_W1', 'PCG_Educ_W1_Dummy34', 'PCG_Educ_W1_Dummy56', 
                      'SCG_Educ_W1_Dummy34', 'SCG_Educ_W1_Dummy56',
                      'Income_equi_quint_W1', 'mixed_school_w1']]

# Fit model
logit_w1_with_father = Logit(df['Gender_binary'], sm.add_constant(X_w1_with_father)).fit(disp=0)
print(logit_w1_with_father.summary())

# Calculate propensity scores and weights
df['p_boy_w1_with_father'] = logit_w1_with_father.predict()
df['p_boy_w1_with_father'] = df['p_boy_w1_with_father'].clip(0.001, 0.999)
df['weight_w1_with_father'] = np.where(df['Gender_binary'] == 0, 
                                     df['p_boy_w1_with_father'] / (1 - df['p_boy_w1_with_father']), 
                                     1)

# Generate distributions (boys and girls actual are the same as before)
boys_w1_with_father = df[df['Gender_binary'] == 1]['Maths_Points_Adjusted']
girls_w1_with_father = df[df['Gender_binary'] == 0]['Maths_Points_Adjusted']

# Sample with replacement using weights
girls_weights_w1_with_father = df.loc[df['Gender_binary'] == 0, 'weight_w1_with_father']
girls_weights_w1_with_father = girls_weights_w1_with_father / girls_weights_w1_with_father.sum()

girls_counter_w1_with_father = np.random.choice(
    girls_w1_with_father, 
    size=len(girls_w1_with_father), 
    replace=True, 
    p=girls_weights_w1_with_father
)

# Analyze distributions
print("\nDescriptive Statistics:")
print(f"Boys actual - Mean: {boys_w1_with_father.mean():.2f}, Std: {boys_w1_with_father.std():.2f}")
print(f"Girls actual - Mean: {girls_w1_with_father.mean():.2f}, Std: {girls_w1_with_father.std():.2f}")
print(f"Girls counterfactual - Mean: {np.mean(girls_counter_w1_with_father):.2f}, Std: {np.std(girls_counter_w1_with_father):.2f}")

# Decomposition
total_gap_w1_with_father = boys_w1_with_father.mean() - girls_w1_with_father.mean()
composition_w1_with_father = np.mean(girls_counter_w1_with_father) - girls_w1_with_father.mean()
structure_w1_with_father = boys_w1_with_father.mean() - np.mean(girls_counter_w1_with_father)

print("\nDFL Decomposition at the Mean:")
print(f"Total gap: {total_gap_w1_with_father:.2f}")
print(f"Composition effect: {composition_w1_with_father:.2f} ({100 * composition_w1_with_father / total_gap_w1_with_father:.2f}%)")
print(f"Structure effect: {structure_w1_with_father:.2f} ({100 * structure_w1_with_father / total_gap_w1_with_father:.2f}%)")

# Plot density
boys_kde_w1_with_father = stats.gaussian_kde(boys_w1_with_father)
girls_kde_w1_with_father = stats.gaussian_kde(girls_w1_with_father)
counter_kde_w1_with_father = stats.gaussian_kde(girls_counter_w1_with_father)

axs_density[0, 1].plot(x, boys_kde_w1_with_father(x), 'b-', label='Boys Actual')
axs_density[0, 1].plot(x, girls_kde_w1_with_father(x), 'r-', label='Girls Actual')
axs_density[0, 1].plot(x, counter_kde_w1_with_father(x), 'g--', label='Girls Counterfactual')
axs_density[0, 1].set_xlabel('Mathematics Score, Leaving Cert')
axs_density[0, 1].set_ylabel('Density')
axs_density[0, 1].set_title("Age 9 Predictors, with Father's Education")
axs_density[0, 1].legend()
axs_density[0, 1].grid(True, alpha=0.3)

# Calculate quantiles
boys_quant_w1_with_father = np.quantile(boys_w1_with_father, quantiles)
girls_quant_w1_with_father = np.quantile(girls_w1_with_father, quantiles)
counter_quant_w1_with_father = np.quantile(girls_counter_w1_with_father, quantiles)

# Print quantile decomposition
print("\nDecomposition at Different Quantiles:")
for i, q in enumerate(quantiles):
    q_total = boys_quant_w1_with_father[i] - girls_quant_w1_with_father[i]
    q_composition = counter_quant_w1_with_father[i] - girls_quant_w1_with_father[i]
    q_structure = boys_quant_w1_with_father[i] - counter_quant_w1_with_father[i]
    
    print(f"Quantile {q}:")
    print(f"  Total gap: {q_total:.2f}")
    
    if abs(q_total) < 0.001:
        comp_pct = "N/A (gap is approximately zero)"
        struct_pct = "N/A (gap is approximately zero)"
    else:
        comp_pct = f"{100 * q_composition / q_total:.2f}%"
        struct_pct = f"{100 * q_structure / q_total:.2f}%"
    
    print(f"  Composition effect: {q_composition:.2f} ({comp_pct})")
    print(f"  Structure effect: {q_structure:.2f} ({struct_pct})")

# Plot quantiles
axs_quantile[0, 1].plot(quantiles, boys_quant_w1_with_father, 'b-o', label='Boys')
axs_quantile[0, 1].plot(quantiles, girls_quant_w1_with_father, 'r-o', label='Girls')
axs_quantile[0, 1].plot(quantiles, counter_quant_w1_with_father, 'g--o', label='Girls Counterfactual')
axs_quantile[0, 1].set_xlabel('Quantile')
axs_quantile[0, 1].set_ylabel('Mathematics Score, Leaving Cert')
axs_quantile[0, 1].set_title("Age 9 Predictors, with Father's Education")
axs_quantile[0, 1].legend()
axs_quantile[0, 1].grid(True)


# 3. Wave 2 without father's education
print("\n===== Wave 2 without father's education =====")

# Define predictors
X_w2_no_father = df[['Drum_VR_W2_l', 'Drum_NA_W2_l', 'BAS_TS_Mat_W2',  
                    'SDQ_emot_PCG_W2', 'SDQ_cond_PCG_W2', 'SDQ_hyper_PCG_W2', 'SDQ_peer_PCG_W2',
                    'PCG_Educ_W2_Dummy34', 'PCG_Educ_W2_Dummy56', 'Income_equi_quint_W2',
                    'Fee_paying_W2', 'DEIS_W2', 'mixed_school_w2', 'religious_school_w2']]

# Fit model
logit_w2_no_father = Logit(df['Gender_binary'], sm.add_constant(X_w2_no_father)).fit(disp=0)
print(logit_w2_no_father.summary())

# Calculate propensity scores and weights
df['p_boy_w2_no_father'] = logit_w2_no_father.predict()
df['p_boy_w2_no_father'] = df['p_boy_w2_no_father'].clip(0.001, 0.999)
df['weight_w2_no_father'] = np.where(df['Gender_binary'] == 0, 
                                   df['p_boy_w2_no_father'] / (1 - df['p_boy_w2_no_father']), 
                                   1)

# Generate distributions
boys_w2_no_father = df[df['Gender_binary'] == 1]['Maths_Points_Adjusted']
girls_w2_no_father = df[df['Gender_binary'] == 0]['Maths_Points_Adjusted']

# Sample with replacement using weights
girls_weights_w2_no_father = df.loc[df['Gender_binary'] == 0, 'weight_w2_no_father']
girls_weights_w2_no_father = girls_weights_w2_no_father / girls_weights_w2_no_father.sum()

girls_counter_w2_no_father = np.random.choice(
    girls_w2_no_father, 
    size=len(girls_w2_no_father), 
    replace=True, 
    p=girls_weights_w2_no_father
)

# Analyze distributions
print("\nDescriptive Statistics:")
print(f"Boys actual - Mean: {boys_w2_no_father.mean():.2f}, Std: {boys_w2_no_father.std():.2f}")
print(f"Girls actual - Mean: {girls_w2_no_father.mean():.2f}, Std: {girls_w2_no_father.std():.2f}")
print(f"Girls counterfactual - Mean: {np.mean(girls_counter_w2_no_father):.2f}, Std: {np.std(girls_counter_w2_no_father):.2f}")

# Decomposition
total_gap_w2_no_father = boys_w2_no_father.mean() - girls_w2_no_father.mean()
composition_w2_no_father = np.mean(girls_counter_w2_no_father) - girls_w2_no_father.mean()
structure_w2_no_father = boys_w2_no_father.mean() - np.mean(girls_counter_w2_no_father)

print("\nDFL Decomposition at the Mean:")
print(f"Total gap: {total_gap_w2_no_father:.2f}")
print(f"Composition effect: {composition_w2_no_father:.2f} ({100 * composition_w2_no_father / total_gap_w2_no_father:.2f}%)")
print(f"Structure effect: {structure_w2_no_father:.2f} ({100 * structure_w2_no_father / total_gap_w2_no_father:.2f}%)")

# Plot density
boys_kde_w2_no_father = stats.gaussian_kde(boys_w2_no_father)
girls_kde_w2_no_father = stats.gaussian_kde(girls_w2_no_father)
counter_kde_w2_no_father = stats.gaussian_kde(girls_counter_w2_no_father)

axs_density[1, 0].plot(x, boys_kde_w2_no_father(x), 'b-', label='Boys Actual')
axs_density[1, 0].plot(x, girls_kde_w2_no_father(x), 'r-', label='Girls Actual')
axs_density[1, 0].plot(x, counter_kde_w2_no_father(x), 'g--', label='Girls Counterfactual')
axs_density[1, 0].set_xlabel('Mathematics Score, Leaving Cert')
axs_density[1, 0].set_ylabel('Density')
axs_density[1, 0].set_title("Age 13 Predictors, without Father's Education")
axs_density[1, 0].legend()
axs_density[1, 0].grid(True, alpha=0.3)

# Calculate quantiles
boys_quant_w2_no_father = np.quantile(boys_w2_no_father, quantiles)
girls_quant_w2_no_father = np.quantile(girls_w2_no_father, quantiles)
counter_quant_w2_no_father = np.quantile(girls_counter_w2_no_father, quantiles)

# Print quantile decomposition
print("\nDecomposition at Different Quantiles:")
for i, q in enumerate(quantiles):
    q_total = boys_quant_w2_no_father[i] - girls_quant_w2_no_father[i]
    q_composition = counter_quant_w2_no_father[i] - girls_quant_w2_no_father[i]
    q_structure = boys_quant_w2_no_father[i] - counter_quant_w2_no_father[i]
    
    print(f"Quantile {q}:")
    print(f"  Total gap: {q_total:.2f}")
    
    if abs(q_total) < 0.001:
        comp_pct = "N/A (gap is approximately zero)"
        struct_pct = "N/A (gap is approximately zero)"
    else:
        comp_pct = f"{100 * q_composition / q_total:.2f}%"
        struct_pct = f"{100 * q_structure / q_total:.2f}%"
    
    print(f"  Composition effect: {q_composition:.2f} ({comp_pct})")
    print(f"  Structure effect: {q_structure:.2f} ({struct_pct})")

# Plot quantiles
axs_quantile[1, 0].plot(quantiles, boys_quant_w2_no_father, 'b-o', label='Boys')
axs_quantile[1, 0].plot(quantiles, girls_quant_w2_no_father, 'r-o', label='Girls')
axs_quantile[1, 0].plot(quantiles, counter_quant_w2_no_father, 'g--o', label='Girls Counterfactual')
axs_quantile[1, 0].set_xlabel('Quantile')
axs_quantile[1, 0].set_ylabel('Mathematics Score, Leaving Cert')
axs_quantile[1, 0].set_title("Age 13 Predictors, without Father's Education")
axs_quantile[1, 0].legend()
axs_quantile[1, 0].grid(True)


# 4. Wave 2 with father's education
print("\n===== Wave 2 with father's education =====")

# Define predictors
X_w2_with_father = df[['Drum_VR_W2_l', 'Drum_NA_W2_l', 'BAS_TS_Mat_W2',  
                      'SDQ_emot_PCG_W2', 'SDQ_cond_PCG_W2', 'SDQ_hyper_PCG_W2', 'SDQ_peer_PCG_W2',
                      'PCG_Educ_W2_Dummy34', 'PCG_Educ_W2_Dummy56', 'Income_equi_quint_W2',
                      'SCG_Educ_W2_Dummy34', 'SCG_Educ_W2_Dummy56',
                      'Fee_paying_W2', 'DEIS_W2', 'mixed_school_w2', 'religious_school_w2']]

# Fit model
logit_w2_with_father = Logit(df['Gender_binary'], sm.add_constant(X_w2_with_father)).fit(disp=0)
print(logit_w2_with_father.summary())

# Calculate propensity scores and weights
df['p_boy_w2_with_father'] = logit_w2_with_father.predict()
df['p_boy_w2_with_father'] = df['p_boy_w2_with_father'].clip(0.001, 0.999)
df['weight_w2_with_father'] = np.where(df['Gender_binary'] == 0, 
                                     df['p_boy_w2_with_father'] / (1 - df['p_boy_w2_with_father']), 
                                     1)

# Generate distributions 
boys_w2_with_father = df[df['Gender_binary'] == 1]['Maths_Points_Adjusted']
girls_w2_with_father = df[df['Gender_binary'] == 0]['Maths_Points_Adjusted']

# Sample with replacement using weights
girls_weights_w2_with_father = df.loc[df['Gender_binary'] == 0, 'weight_w2_with_father']
girls_weights_w2_with_father = girls_weights_w2_with_father / girls_weights_w2_with_father.sum()

girls_counter_w2_with_father = np.random.choice(
    girls_w2_with_father, 
    size=len(girls_w2_with_father), 
    replace=True, 
    p=girls_weights_w2_with_father
)

# Analyze distributions
print("\nDescriptive Statistics:")
print(f"Boys actual - Mean: {boys_w2_with_father.mean():.2f}, Std: {boys_w2_with_father.std():.2f}")
print(f"Girls actual - Mean: {girls_w2_with_father.mean():.2f}, Std: {girls_w2_with_father.std():.2f}")
print(f"Girls counterfactual - Mean: {np.mean(girls_counter_w2_with_father):.2f}, Std: {np.std(girls_counter_w2_with_father):.2f}")

# Decomposition
total_gap_w2_with_father = boys_w2_with_father.mean() - girls_w2_with_father.mean()
composition_w2_with_father = np.mean(girls_counter_w2_with_father) - girls_w2_with_father.mean()
structure_w2_with_father = boys_w2_with_father.mean() - np.mean(girls_counter_w2_with_father)

print("\nDFL Decomposition at the Mean:")
print(f"Total gap: {total_gap_w2_with_father:.2f}")
print(f"Composition effect: {composition_w2_with_father:.2f} ({100 * composition_w2_with_father / total_gap_w2_with_father:.2f}%)")
print(f"Structure effect: {structure_w2_with_father:.2f} ({100 * structure_w2_with_father / total_gap_w2_with_father:.2f}%)")

# Plot density
boys_kde_w2_with_father = stats.gaussian_kde(boys_w2_with_father)
girls_kde_w2_with_father = stats.gaussian_kde(girls_w2_with_father)
counter_kde_w2_with_father = stats.gaussian_kde(girls_counter_w2_with_father)

axs_density[1, 1].plot(x, boys_kde_w2_with_father(x), 'b-', label='Boys Actual')
axs_density[1, 1].plot(x, girls_kde_w2_with_father(x), 'r-', label='Girls Actual')
axs_density[1, 1].plot(x, counter_kde_w2_with_father(x), 'g--', label='Girls Counterfactual')
axs_density[1, 1].set_xlabel('Mathematics Score, Leaving Cert')
axs_density[1, 1].set_ylabel('Density')
axs_density[1, 1].set_title("Age 13 Predictors, with Father's Education")
axs_density[1, 1].legend()
axs_density[1, 1].grid(True, alpha=0.3)

# Calculate quantiles
boys_quant_w2_with_father = np.quantile(boys_w2_with_father, quantiles)
girls_quant_w2_with_father = np.quantile(girls_w2_with_father, quantiles)
counter_quant_w2_with_father = np.quantile(girls_counter_w2_with_father, quantiles)

# Print quantile decomposition
print("\nDecomposition at Different Quantiles:")
for i, q in enumerate(quantiles):
    q_total = boys_quant_w2_with_father[i] - girls_quant_w2_with_father[i]
    q_composition = counter_quant_w2_with_father[i] - girls_quant_w2_with_father[i]
    q_structure = boys_quant_w2_with_father[i] - counter_quant_w2_with_father[i]
    
    print(f"Quantile {q}:")
    print(f"  Total gap: {q_total:.2f}") 
    if abs(q_total) < 0.001:
        comp_pct = "N/A (gap is approximately zero)"
        struct_pct = "N/A (gap is approximately zero)"
    else:
        comp_pct = f"{100 * q_composition / q_total:.2f}%"
        struct_pct = f"{100 * q_structure / q_total:.2f}%"
    
    print(f"  Composition effect: {q_composition:.2f} ({comp_pct})")
    print(f"  Structure effect: {q_structure:.2f} ({struct_pct})")

# Plot quantiles
axs_quantile[1, 1].plot(quantiles, boys_quant_w2_with_father, 'b-o', label='Boys')
axs_quantile[1, 1].plot(quantiles, girls_quant_w2_with_father, 'r-o', label='Girls')
axs_quantile[1, 1].plot(quantiles, counter_quant_w2_with_father, 'g--o', label='Girls Counterfactual')
axs_quantile[1, 1].set_xlabel('Quantile')
axs_quantile[1, 1].set_ylabel('Mathematics Score, Leaving Cert')
axs_quantile[1, 1].set_title("Age 13 Predictors, with Father's Education")
axs_quantile[1, 1].legend()
axs_quantile[1, 1].grid(True)

# Adjust layout and save figures
fig_density.tight_layout(rect=[0, 0, 1, 0.96])
fig_quantile.tight_layout(rect=[0, 0, 1, 0.96])

# Save figures
fig_density.savefig('combined_density_plots.png', dpi=300, bbox_inches='tight')
fig_quantile.savefig('combined_quantile_plots.png', dpi=300, bbox_inches='tight')

plt.show()