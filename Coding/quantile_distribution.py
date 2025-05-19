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

plt.xlabel('Maths Score, Leaving Cert')
plt.ylabel('Density')
plt.title('DFL Decomposition - Maths Score Distributions, Age 9 Predictors')
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
plt.ylabel('Maths Score, Leaving Cert')
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

plt.xlabel('Maths Score, Leaving Cert')
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
plt.ylabel('Maths Score')
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

plt.xlabel('Maths Score, Leaving Cert')
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
plt.ylabel('Maths Score')
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

plt.xlabel('Maths Score, Leaving Cert')
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
plt.ylabel('Maths Score')
plt.title("Quantile Decomposition - Predictors at age 13, with Father's Education")
plt.legend()
plt.grid(True)
plt.show()

