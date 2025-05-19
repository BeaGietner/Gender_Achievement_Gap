import pandas as pd
import numpy as np
import statsmodels.api as sm
from statsmodels.discrete.discrete_model import Logit
import matplotlib.pyplot as plt
from scipy import stats

# Load and prepare data
# Replace this with actual file path
df = pd.read_csv("C:/Users/bgiet/OneDrive/Documents/complete_case_subset.csv")  # You'll need to adjust the file path
df = df.dropna()

# ---------------------------------------------------------
# First analysis: Wave 1 predictors, Boys only
# ---------------------------------------------------------
print("Running DiNardo decomposition for Wave 1, Boys only")

# Filter for boys only
boys_df = df[df['Gender_binary'] == 1].copy()

# Step 1: Define the variables for the father absence model
X_father = boys_df[['Cog_Reading_W1_l', 'Cog_Maths_W1_l',
                    'SDQ_emot_PCG_W1', 'SDQ_cond_PCG_W1', 'SDQ_hyper_PCG_W1', 'SDQ_peer_PCG_W1',
                    'PCG_Educ_W1_Dummy34', 'PCG_Educ_W1_Dummy56', 'Income_equi_quint_W1',
                    'mixed_school_w1']]

# Step 2: Define the father absence status
y_father = boys_df['father_absent_status_test']

# Step 3: Fit the logit model
logit_model = Logit(y_father, sm.add_constant(X_father)).fit(disp=0)
print(logit_model.summary())

# Step 4: Calculate propensity scores and weights
boys_df['p_father_absent'] = logit_model.predict()

# Ensure propensity scores aren't too close to 0 or 1
epsilon = 0.001
boys_df['p_father_absent'] = boys_df['p_father_absent'].clip(epsilon, 1-epsilon)

# Calculate weights for father-present boys (counterfactual to absent fathers)
boys_df['weight'] = np.where(boys_df['father_absent_status_test'] == 0, 
                           boys_df['p_father_absent'] / (1 - boys_df['p_father_absent']), 
                           1)

# Step 5: Generate distributions
father_absent_actual = boys_df[boys_df['father_absent_status_test'] == 1]['Maths_Points_Adjusted']
father_present_actual = boys_df[boys_df['father_absent_status_test'] == 0]['Maths_Points_Adjusted']

# Sample with replacement using weights
father_present_weights = boys_df.loc[boys_df['father_absent_status_test'] == 0, 'weight']
father_present_weights = father_present_weights / father_present_weights.sum()  # Normalize weights to sum to 1

# Use a fixed random seed for reproducibility
np.random.seed(42)
father_present_counterfactual = np.random.choice(
    father_present_actual, 
    size=len(father_absent_actual), 
    replace=True, 
    p=father_present_weights
)

# Step 6: Analyze distributions
print("\nDescriptive Statistics - Wave 1, Boys:")
print(f"Father absent - Mean: {father_absent_actual.mean():.2f}, Std: {father_absent_actual.std():.2f}")
print(f"Father present actual - Mean: {father_present_actual.mean():.2f}, Std: {father_present_actual.std():.2f}")
print(f"Father present counterfactual - Mean: {np.mean(father_present_counterfactual):.2f}, Std: {np.std(father_present_counterfactual):.2f}")

# Step 7: Decomposition
total_gap = father_absent_actual.mean() - father_present_actual.mean()
composition_effect = np.mean(father_present_counterfactual) - father_present_actual.mean()
structure_effect = father_absent_actual.mean() - np.mean(father_present_counterfactual)

print("\nDFL Decomposition at the Mean - Wave 1, Boys:")
print(f"Total gap: {total_gap:.2f}")
print(f"Composition effect: {composition_effect:.2f} ({100 * composition_effect / total_gap:.2f}% of total)")
print(f"Structure effect: {structure_effect:.2f} ({100 * structure_effect / total_gap:.2f}% of total)")

# Step 8: Create visualizations
plt.figure(figsize=(10, 6))

# Plot kernel density estimates
father_absent_kde = stats.gaussian_kde(father_absent_actual)
father_present_kde = stats.gaussian_kde(father_present_actual)
counterfactual_kde = stats.gaussian_kde(father_present_counterfactual)

x = np.linspace(0, 150, 1000)
plt.plot(x, father_absent_kde(x), 'b-', label='Father Absent Actual')
plt.plot(x, father_present_kde(x), 'r-', label='Father Present Actual')
plt.plot(x, counterfactual_kde(x), 'g--', label='Father Present Counterfactual')

plt.xlabel('Maths Score, Leaving Cert')
plt.ylabel('Density')
plt.title('DFL Decomposition - Math Score Distributions, Boys, Age 9 Predictors')
plt.legend()
plt.grid(True, alpha=0.3)
plt.savefig('dfl_boys_wave1.png')

# Step 9: Analyze at quantiles
quantiles = [0.1, 0.25, 0.5, 0.75, 0.9]
absent_quant = np.quantile(father_absent_actual, quantiles)
present_quant = np.quantile(father_present_actual, quantiles)
counter_quant = np.quantile(father_present_counterfactual, quantiles)

print("\nDecomposition at Different Quantiles - Wave 1, Boys:")
for i, q in enumerate(quantiles):
    q_total = absent_quant[i] - present_quant[i]
    q_composition = counter_quant[i] - present_quant[i]
    q_structure = absent_quant[i] - counter_quant[i]
    
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
plt.plot(quantiles, absent_quant, 'b-o', label='Father Absent')
plt.plot(quantiles, present_quant, 'r-o', label='Father Present')
plt.plot(quantiles, counter_quant, 'g--o', label='Father Present Counterfactual')
plt.xlabel('Quantile')
plt.ylabel('Maths Score')
plt.title("Quantile Decomposition - Boys, Age 9 Predictors")
plt.legend()
plt.grid(True)
plt.savefig('dfl_quantile_boys_wave1.png')

# ---------------------------------------------------------
# Second analysis: Wave 1 predictors, Girls only
# ---------------------------------------------------------
print("\n\nRunning DiNardo decomposition for Wave 1, Girls only")

# Filter for girls only
girls_df = df[df['Gender_binary'] == 0].copy()

# Step 1: Define the variables for the father absence model
X_father = girls_df[['Cog_Reading_W1_l', 'Cog_Maths_W1_l',
                    'SDQ_emot_PCG_W1', 'SDQ_cond_PCG_W1', 'SDQ_hyper_PCG_W1', 'SDQ_peer_PCG_W1',
                    'PCG_Educ_W1_Dummy34', 'PCG_Educ_W1_Dummy56', 'Income_equi_quint_W1',
                    'mixed_school_w1']]

# Step 2: Define the father absence status
y_father = girls_df['father_absent_status_test']

# Step 3: Fit the logit model
logit_model = Logit(y_father, sm.add_constant(X_father)).fit(disp=0)
print(logit_model.summary())

# Step 4: Calculate propensity scores and weights
girls_df['p_father_absent'] = logit_model.predict()

# Ensure propensity scores aren't too close to 0 or 1
epsilon = 0.001
girls_df['p_father_absent'] = girls_df['p_father_absent'].clip(epsilon, 1-epsilon)

# Calculate weights for father-present girls (counterfactual to absent fathers)
girls_df['weight'] = np.where(girls_df['father_absent_status_test'] == 0, 
                           girls_df['p_father_absent'] / (1 - girls_df['p_father_absent']), 
                           1)

# Step 5: Generate distributions
father_absent_actual = girls_df[girls_df['father_absent_status_test'] == 1]['Maths_Points_Adjusted']
father_present_actual = girls_df[girls_df['father_absent_status_test'] == 0]['Maths_Points_Adjusted']

# Sample with replacement using weights
father_present_weights = girls_df.loc[girls_df['father_absent_status_test'] == 0, 'weight']
father_present_weights = father_present_weights / father_present_weights.sum()  # Normalize weights to sum to 1

# Use a fixed random seed for reproducibility
np.random.seed(42)
father_present_counterfactual = np.random.choice(
    father_present_actual, 
    size=len(father_absent_actual), 
    replace=True, 
    p=father_present_weights
)

# Step 6: Analyze distributions
print("\nDescriptive Statistics - Wave 1, Girls:")
print(f"Father absent - Mean: {father_absent_actual.mean():.2f}, Std: {father_absent_actual.std():.2f}")
print(f"Father present actual - Mean: {father_present_actual.mean():.2f}, Std: {father_present_actual.std():.2f}")
print(f"Father present counterfactual - Mean: {np.mean(father_present_counterfactual):.2f}, Std: {np.std(father_present_counterfactual):.2f}")

# Step 7: Decomposition
total_gap = father_absent_actual.mean() - father_present_actual.mean()
composition_effect = np.mean(father_present_counterfactual) - father_present_actual.mean()
structure_effect = father_absent_actual.mean() - np.mean(father_present_counterfactual)

print("\nDFL Decomposition at the Mean - Wave 1, Girls:")
print(f"Total gap: {total_gap:.2f}")
print(f"Composition effect: {composition_effect:.2f} ({100 * composition_effect / total_gap:.2f}% of total)")
print(f"Structure effect: {structure_effect:.2f} ({100 * structure_effect / total_gap:.2f}% of total)")

# Create visualizations and save them
plt.figure(figsize=(10, 6))

# Plot kernel density estimates
father_absent_kde = stats.gaussian_kde(father_absent_actual)
father_present_kde = stats.gaussian_kde(father_present_actual)
counterfactual_kde = stats.gaussian_kde(father_present_counterfactual)

x = np.linspace(0, 150, 1000)
plt.plot(x, father_absent_kde(x), 'b-', label='Father Absent Actual')
plt.plot(x, father_present_kde(x), 'r-', label='Father Present Actual')
plt.plot(x, counterfactual_kde(x), 'g--', label='Father Present Counterfactual')

plt.xlabel('Maths Score, Leaving Cert')
plt.ylabel('Density')
plt.title('DFL Decomposition - Math Score Distributions, Girls, Age 9 Predictors')
plt.legend()
plt.grid(True, alpha=0.3)
plt.savefig('dfl_girls_wave1.png')

# Analyze at quantiles
quantiles = [0.1, 0.25, 0.5, 0.75, 0.9]
absent_quant = np.quantile(father_absent_actual, quantiles)
present_quant = np.quantile(father_present_actual, quantiles)
counter_quant = np.quantile(father_present_counterfactual, quantiles)

print("\nDecomposition at Different Quantiles - Wave 1, Girls:")
for i, q in enumerate(quantiles):
    q_total = absent_quant[i] - present_quant[i]
    q_composition = counter_quant[i] - present_quant[i]
    q_structure = absent_quant[i] - counter_quant[i]
    
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

plt.figure(figsize=(10, 6))
plt.plot(quantiles, absent_quant, 'b-o', label='Father Absent')
plt.plot(quantiles, present_quant, 'r-o', label='Father Present')
plt.plot(quantiles, counter_quant, 'g--o', label='Father Present Counterfactual')
plt.xlabel('Quantile')
plt.ylabel('Maths Score')
plt.title("Quantile Decomposition - Girls, Age 9 Predictors")
plt.legend()
plt.grid(True)
plt.savefig('dfl_quantile_girls_wave1.png')

# ---------------------------------------------------------
# Third analysis: Wave 2 predictors, Boys only
# ---------------------------------------------------------
print("\n\nRunning DiNardo decomposition for Wave 2, Boys only")

# Filter for boys only
boys_df = df[df['Gender_binary'] == 1].copy()

# Step 1: Define the variables for the father absence model - using WAVE 2 predictors
X_father = boys_df[['Drum_VR_W2_l', 'Drum_NA_W2_l', 'BAS_TS_Mat_W2',
                    'SDQ_emot_PCG_W2', 'SDQ_cond_PCG_W2', 'SDQ_hyper_PCG_W2', 'SDQ_peer_PCG_W2',
                    'PCG_Educ_W2_Dummy34', 'PCG_Educ_W2_Dummy56', 'Income_equi_quint_W2',
                    'Fee_paying_W2', 'DEIS_W2', 'mixed_school_w2', 'religious_school_w2']]

# Step 2: Define the father absence status
y_father = boys_df['father_absent_status_test']

# Step 3: Fit the logit model
logit_model = Logit(y_father, sm.add_constant(X_father)).fit(disp=0)
print(logit_model.summary())

# Step 4: Calculate propensity scores and weights
boys_df['p_father_absent'] = logit_model.predict()

# Ensure propensity scores aren't too close to 0 or 1
epsilon = 0.001
boys_df['p_father_absent'] = boys_df['p_father_absent'].clip(epsilon, 1-epsilon)

# Calculate weights for father-present boys (counterfactual to absent fathers)
boys_df['weight'] = np.where(boys_df['father_absent_status_test'] == 0, 
                           boys_df['p_father_absent'] / (1 - boys_df['p_father_absent']), 
                           1)

# Step 5: Generate distributions
father_absent_actual = boys_df[boys_df['father_absent_status_test'] == 1]['Maths_Points_Adjusted']
father_present_actual = boys_df[boys_df['father_absent_status_test'] == 0]['Maths_Points_Adjusted']

# Sample with replacement using weights
father_present_weights = boys_df.loc[boys_df['father_absent_status_test'] == 0, 'weight']
father_present_weights = father_present_weights / father_present_weights.sum()  # Normalize weights to sum to 1

# Use a fixed random seed for reproducibility
np.random.seed(42)
father_present_counterfactual = np.random.choice(
    father_present_actual, 
    size=len(father_absent_actual), 
    replace=True, 
    p=father_present_weights
)

# Step 6: Analyze distributions
print("\nDescriptive Statistics - Wave 2, Boys:")
print(f"Father absent - Mean: {father_absent_actual.mean():.2f}, Std: {father_absent_actual.std():.2f}")
print(f"Father present actual - Mean: {father_present_actual.mean():.2f}, Std: {father_present_actual.std():.2f}")
print(f"Father present counterfactual - Mean: {np.mean(father_present_counterfactual):.2f}, Std: {np.std(father_present_counterfactual):.2f}")

# Step 7: Decomposition
total_gap = father_absent_actual.mean() - father_present_actual.mean()
composition_effect = np.mean(father_present_counterfactual) - father_present_actual.mean()
structure_effect = father_absent_actual.mean() - np.mean(father_present_counterfactual)

print("\nDFL Decomposition at the Mean - Wave 2, Boys:")
print(f"Total gap: {total_gap:.2f}")
print(f"Composition effect: {composition_effect:.2f} ({100 * composition_effect / total_gap:.2f}% of total)")
print(f"Structure effect: {structure_effect:.2f} ({100 * structure_effect / total_gap:.2f}% of total)")

# Create visualizations
plt.figure(figsize=(10, 6))

# Plot kernel density estimates
father_absent_kde = stats.gaussian_kde(father_absent_actual)
father_present_kde = stats.gaussian_kde(father_present_actual)
counterfactual_kde = stats.gaussian_kde(father_present_counterfactual)

x = np.linspace(0, 150, 1000)
plt.plot(x, father_absent_kde(x), 'b-', label='Father Absent Actual')
plt.plot(x, father_present_kde(x), 'r-', label='Father Present Actual')
plt.plot(x, counterfactual_kde(x), 'g--', label='Father Present Counterfactual')

plt.xlabel('Maths Score, Leaving Cert')
plt.ylabel('Density')
plt.title('DFL Decomposition - Math Score Distributions, Boys, Age 13 Predictors')
plt.legend()
plt.grid(True, alpha=0.3)
plt.savefig('dfl_boys_wave2.png')

# Analyze at quantiles
quantiles = [0.1, 0.25, 0.5, 0.75, 0.9]
absent_quant = np.quantile(father_absent_actual, quantiles)
present_quant = np.quantile(father_present_actual, quantiles)
counter_quant = np.quantile(father_present_counterfactual, quantiles)

print("\nDecomposition at Different Quantiles - Wave 2, Boys:")
for i, q in enumerate(quantiles):
    q_total = absent_quant[i] - present_quant[i]
    q_composition = counter_quant[i] - present_quant[i]
    q_structure = absent_quant[i] - counter_quant[i]
    
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

plt.figure(figsize=(10, 6))
plt.plot(quantiles, absent_quant, 'b-o', label='Father Absent')
plt.plot(quantiles, present_quant, 'r-o', label='Father Present')
plt.plot(quantiles, counter_quant, 'g--o', label='Father Present Counterfactual')
plt.xlabel('Quantile')
plt.ylabel('Maths Score')
plt.title("Quantile Decomposition - Boys, Age 13 Predictors")
plt.legend()
plt.grid(True)
plt.savefig('dfl_quantile_boys_wave2.png')

# ---------------------------------------------------------
# Fourth analysis: Wave 2 predictors, Girls only
# ---------------------------------------------------------
print("\n\nRunning DiNardo decomposition for Wave 2, Girls only")

# Filter for girls only
girls_df = df[df['Gender_binary'] == 0].copy()

# Step 1: Define the variables for the father absence model - using WAVE 2 predictors
X_father = girls_df[['Drum_VR_W2_l', 'Drum_NA_W2_l', 'BAS_TS_Mat_W2',
                     'SDQ_emot_PCG_W2', 'SDQ_cond_PCG_W2', 'SDQ_hyper_PCG_W2', 'SDQ_peer_PCG_W2',
                     'PCG_Educ_W2_Dummy34', 'PCG_Educ_W2_Dummy56', 'Income_equi_quint_W2',
                     'Fee_paying_W2', 'DEIS_W2', 'mixed_school_w2', 'religious_school_w2']]

# Step 2: Define the father absence status
y_father = girls_df['father_absent_status_test']

# Step 3: Fit the logit model
logit_model = Logit(y_father, sm.add_constant(X_father)).fit(disp=0)
print(logit_model.summary())

# Step 4: Calculate propensity scores and weights
girls_df['p_father_absent'] = logit_model.predict()

# Ensure propensity scores aren't too close to 0 or 1
epsilon = 0.001
girls_df['p_father_absent'] = girls_df['p_father_absent'].clip(epsilon, 1-epsilon)

# Calculate weights for father-present girls (counterfactual to absent fathers)
girls_df['weight'] = np.where(girls_df['father_absent_status_test'] == 0, 
                           girls_df['p_father_absent'] / (1 - girls_df['p_father_absent']), 
                           1)

# Step 5: Generate distributions
father_absent_actual = girls_df[girls_df['father_absent_status_test'] == 1]['Maths_Points_Adjusted']
father_present_actual = girls_df[girls_df['father_absent_status_test'] == 0]['Maths_Points_Adjusted']

# Sample with replacement using weights
father_present_weights = girls_df.loc[girls_df['father_absent_status_test'] == 0, 'weight']
father_present_weights = father_present_weights / father_present_weights.sum()  # Normalize weights to sum to 1

# Use a fixed random seed for reproducibility
np.random.seed(42)
father_present_counterfactual = np.random.choice(
    father_present_actual, 
    size=len(father_absent_actual), 
    replace=True, 
    p=father_present_weights
)

# Step 6: Analyze distributions
print("\nDescriptive Statistics - Wave 2, Girls:")
print(f"Father absent - Mean: {father_absent_actual.mean():.2f}, Std: {father_absent_actual.std():.2f}")
print(f"Father present actual - Mean: {father_present_actual.mean():.2f}, Std: {father_present_actual.std():.2f}")
print(f"Father present counterfactual - Mean: {np.mean(father_present_counterfactual):.2f}, Std: {np.std(father_present_counterfactual):.2f}")

# Step 7: Decomposition
total_gap = father_absent_actual.mean() - father_present_actual.mean()
composition_effect = np.mean(father_present_counterfactual) - father_present_actual.mean()
structure_effect = father_absent_actual.mean() - np.mean(father_present_counterfactual)

print("\nDFL Decomposition at the Mean - Wave 2, Girls:")
print(f"Total gap: {total_gap:.2f}")
print(f"Composition effect: {composition_effect:.2f} ({100 * composition_effect / total_gap:.2f}% of total)")
print(f"Structure effect: {structure_effect:.2f} ({100 * structure_effect / total_gap:.2f}% of total)")

# Create visualizations
plt.figure(figsize=(10, 6))

# Plot kernel density estimates
father_absent_kde = stats.gaussian_kde(father_absent_actual)
father_present_kde = stats.gaussian_kde(father_present_actual)
counterfactual_kde = stats.gaussian_kde(father_present_counterfactual)

x = np.linspace(0, 150, 1000)
plt.plot(x, father_absent_kde(x), 'b-', label='Father Absent Actual')
plt.plot(x, father_present_kde(x), 'r-', label='Father Present Actual')
plt.plot(x, counterfactual_kde(x), 'g--', label='Father Present Counterfactual')

plt.xlabel('Maths Score, Leaving Cert')
plt.ylabel('Density')
plt.title('DFL Decomposition - Math Score Distributions, Girls, Age 13 Predictors')
plt.legend()
plt.grid(True, alpha=0.3)
plt.savefig('dfl_girls_wave2.png')

# Analyze at quantiles
quantiles = [0.1, 0.25, 0.5, 0.75, 0.9]
absent_quant = np.quantile(father_absent_actual, quantiles)
present_quant = np.quantile(father_present_actual, quantiles)
counter_quant = np.quantile(father_present_counterfactual, quantiles)

print("\nDecomposition at Different Quantiles - Wave 2, Girls:")
for i, q in enumerate(quantiles):
    q_total = absent_quant[i] - present_quant[i]
    q_composition = counter_quant[i] - present_quant[i]
    q_structure = absent_quant[i] - counter_quant[i]
    
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

plt.figure(figsize=(10, 6))
plt.plot(quantiles, absent_quant, 'b-o', label='Father Absent')
plt.plot(quantiles, present_quant, 'r-o', label='Father Present')
plt.plot(quantiles, counter_quant, 'g--o', label='Father Present Counterfactual')
plt.xlabel('Quantile')
plt.ylabel('Maths Score')
plt.title("Quantile Decomposition - Girls, Age 13 Predictors")
plt.legend()
plt.grid(True)
plt.savefig('dfl_quantile_girls_wave2.png')
