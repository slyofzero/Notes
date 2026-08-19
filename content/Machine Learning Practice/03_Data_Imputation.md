# 3. Data Imputation


**Intuition:** After cleaning, your data will almost always have missing values. Missing values can't be ignored — most scikit-learn models throw an error on `NaN` inputs. Imputation is the process of filling in those gaps with plausible values. Choosing the *wrong* strategy introduces systematic bias into your model; choosing the *right* one recovers information that would otherwise be lost.

---

## 3.1 Diagnosing Missingness — The Three Types

Before picking an imputation strategy, you must understand *why* values are missing. This is the most important and most overlooked step.

| Mechanism | Definition | Example | Safe to impute? |
|:---|:---|:---|:---:|
| **MCAR** — Missing Completely At Random | The probability of a value being missing is independent of all other variables | A sensor randomly fails regardless of the reading | ✅ Yes — any strategy works |
| **MAR** — Missing At Random | The probability of missing depends on *other observed* variables, not the missing variable itself | Older patients less likely to complete an online health survey (age is observed) | ✅ Yes — use the related observed variables |
| **MNAR** — Missing Not At Random | The probability of missing depends on the *missing value itself* | High-income individuals leave income blank; depressed patients stop reporting symptoms | ⚠️ Careful — naive imputation biases results |

### Diagnosing in Practice

You cannot definitively test for MCAR vs. MAR vs. MNAR from the data alone — it requires domain knowledge. But you can look for signals:

```python
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns

# 1. Overall missingness summary
missing = df.isnull().sum()
missing_pct = (df.isnull().mean() * 100).round(2)
print(pd.DataFrame({'count': missing, 'pct': missing_pct}).sort_values('pct', ascending=False))

# 2. Missingness heatmap — reveals patterns (e.g., same rows missing across multiple cols)
sns.heatmap(df.isnull(), cbar=False, yticklabels=False, cmap='viridis')
plt.title("Missingness Map")

# 3. Is missingness in column A correlated with values in column B?
# Create a binary "is_missing" indicator, then correlate with other features
df['income_missing'] = df['income'].isnull().astype(int)
print(df.corr()['income_missing'].sort_values(ascending=False))
# High correlation with 'age' → MAR (missingness depends on age, an observed variable)

# 4. Little's MCAR test (statistical test, requires the 'pyampute' or 'missingno' library)
import missingno as msno
msno.matrix(df)     # visualise patterns
msno.heatmap(df)    # correlations between missing columns
msno.dendrogram(df) # cluster columns by missing patterns
```

**Decision rule of thumb:**
- No pattern found in missingness → assume MCAR → simple imputation is fine.
- Pattern found (missingness correlates with observed variable) → MAR → use model-based or multivariate imputation.
- Domain knowledge says the value itself drives missingness → MNAR → add a `_missing` indicator flag, consider imputing with a sentinel value, and document the assumption.

---

## 3.2 Adding Missingness Indicator Flags

For MNAR (and sometimes MAR), the *fact that something is missing* carries information. Before imputing, create a binary flag column that the model can learn from.

```python
from sklearn.impute import MissingIndicator

# Standalone use
indicator = MissingIndicator(features='missing-only')  # only creates columns for cols that have NaN
missing_flags = indicator.fit_transform(X_train)
# Result: bool matrix with one column per feature that has at least one NaN

# Combined with an imputer in a FeatureUnion pipeline
from sklearn.pipeline import FeatureUnion, Pipeline
from sklearn.impute import SimpleImputer

# Manual version:
df['income_was_missing'] = df['income'].isnull().astype(int)
df['income'] = df['income'].fillna(df['income'].median())
# Now the model sees both the imputed value AND the flag
```

> [!TIP]
> Indicator flags are almost always worth adding for columns with high missingness rates (> 5–10%). The cost is one extra column; the benefit is that the model can learn "missing income → different behaviour" instead of being fooled by an imputed value.

---

## 3.3 Strategy 1 — Dropping Missing Data

Sometimes the best strategy is not to impute at all.

### Drop Columns
Drop a column entirely if it has too many missing values to be useful:
```python
# Rule of thumb: drop columns with > 50-70% missing (domain-dependent)
threshold = 0.5
cols_to_drop = df.columns[df.isnull().mean() > threshold]
df.drop(columns=cols_to_drop, inplace=True)
```

### Drop Rows
Drop rows where the target variable is missing (you cannot impute a label):
```python
df.dropna(subset=['target'], inplace=True)
```

Drop rows if only a tiny fraction are missing and the dataset is large:
```python
# Only drop rows if < 1% of data is affected
if df.isnull().any(axis=1).mean() < 0.01:
    df.dropna(inplace=True)
```

> [!WARNING]
> Dropping rows on non-MCAR data introduces selection bias. If the rows being dropped are systematically different from the rest (e.g., the sickest patients who drop out of a study), the trained model will be biased toward the "easier" cases.

---

## 3.4 Strategy 2 — Simple Statistical Imputation (`SimpleImputer`)

The most common baseline — fast, simple, and interpretable.

```python
from sklearn.impute import SimpleImputer

# --- Numeric columns ---
mean_imputer   = SimpleImputer(strategy='mean')
median_imputer = SimpleImputer(strategy='median')

# --- Categorical columns ---
mode_imputer   = SimpleImputer(strategy='most_frequent')

# --- Custom constant ---
const_imputer  = SimpleImputer(strategy='constant', fill_value=0)
# For categoricals: fill_value='Unknown'
```

### When to use which strategy

| Strategy | Use when | Risk |
|:---|:---|:---|
| `mean` | Feature is normally distributed, no strong outliers | Sensitive to outliers; distorts distribution |
| `median` | Feature is skewed or has outliers | Slightly less statistically efficient than mean on normal data |
| `most_frequent` | Categorical feature | Can overrepresent the dominant class |
| `constant` | Domain default makes sense (e.g., `0` for "no transactions") | May introduce a meaningless cluster at 0 |

### Effect on distribution
Univariate imputation **shrinks variance** — every imputed value is the same (mean/median), so the tails of the distribution disappear. This is acceptable for models that don't care about the exact marginal distribution (trees, SVM), but it subtly biases any variance-based statistic.

```python
import matplotlib.pyplot as plt

original = df['income'].dropna()
imputed  = df['income'].fillna(df['income'].median())

fig, axes = plt.subplots(1, 2, figsize=(10, 4))
original.hist(ax=axes[0], bins=30, title='Original (with NaN excluded)')
imputed.hist(ax=axes[1],  bins=30, title='After Median Imputation')
plt.tight_layout()
```

---

## 3.5 Strategy 3 — KNN Imputation (`KNNImputer`)

**Intuition:** Instead of filling a missing value with a global statistic (mean of everyone), use the mean of the $k$ most *similar* rows. Similar rows are found by computing Euclidean distance across all *observed* features.

**Mathematical Formulation:** The `nan_euclidean` metric scales the distance between two samples $u$ and $v$ to account for missing features.
$$D(u, v) = \sqrt{\frac{N}{N_{present}} \sum_{j \in \text{present}} (u_j - v_j)^2}$$
Where $N$ is the total number of features, and $N_{present}$ is the number of features observed in *both* $u$ and $v$. 
The imputed value for sample $i$ at feature $j$ is the weighted (or uniform) average of the $k$ nearest neighbors:
$$\hat{x}_{ij} = \frac{\sum_{l \in \text{kNN}(i)} w_l x_{lj}}{\sum_{l \in \text{kNN}(i)} w_l}$$

```python
from sklearn.impute import KNNImputer

knn_imp = KNNImputer(
    n_neighbors=5,       # k — tune via cross-validation
    weights='uniform',   # 'uniform': equal weight; 'distance': closer = more weight
    metric='nan_euclidean'  # handles NaN in distance calculation
)

X_train_imputed = knn_imp.fit_transform(X_train)
X_test_imputed  = knn_imp.transform(X_test)   # uses training neighbours only
```

### Choosing `n_neighbors`
- Small `k` (e.g., 3) → more local, can overfit to noise.
- Large `k` (e.g., 20) → smoother, approaches univariate mean imputation.
- Tune with `GridSearchCV` inside a pipeline.

### When to use KNN Imputation
✅ Dataset has meaningful local structure (similar rows should have similar values).  
✅ Multiple columns have related missing patterns (e.g., `height` and `weight` both missing for the same person).  
✅ Dataset is moderate-sized (< 50k rows; beyond that, it becomes slow).  

❌ Very large datasets — $O(n^2)$ distance computation is prohibitive.  
❌ High-dimensional data — Euclidean distance becomes uninformative in high dimensions (**curse of dimensionality**).  

> [!IMPORTANT]
> KNN Imputation is sensitive to feature scale. You must scale the features **before** fitting the `KNNImputer`, otherwise a feature with a large numeric range will dominate the distance computation. In a scikit-learn `Pipeline`, place `StandardScaler` before `KNNImputer`.

---

## 3.6 Strategy 4 — Iterative / Model-Based Imputation (`IterativeImputer`)

**Intuition:** This is the most statistically principled approach. Think of it as "impute by predicting." For each feature with missing values, treat it as the *dependent variable* and all other features as *predictors*, then fit a regression model to estimate the missing values. Repeat this for every column with missingness, cycling through them multiple times until convergence.

This is related to the **MICE** (Multiple Imputation by Chained Equations) algorithm widely used in statistics.

**Mathematical Foundation (Bayesian Ridge):** By default, scikit-learn uses `BayesianRidge`. Unlike standard linear regression, it introduces probabilistic priors over the weights $w$ and the noise precision $\lambda$:
- **Likelihood:** $p(y | X, w, \lambda) = \mathcal{N}(y | Xw, \lambda^{-1} I)$
- **Weight Prior:** $p(w | \alpha) = \mathcal{N}(w | 0, \alpha^{-1} I)$
This formulation naturally regularizes the model (L2 regularization) and provides uncertainty estimates, making it exceptionally robust when predicting missing values from noisy correlated columns.

```python
from sklearn.experimental import enable_iterative_imputer   # must come first
from sklearn.impute import IterativeImputer
from sklearn.linear_model import BayesianRidge              # default estimator

iter_imp = IterativeImputer(
    estimator=BayesianRidge(),   # the model used to predict each column
    max_iter=10,                 # number of full cycles through all columns
    tol=1e-3,                    # stop early if imputed values converge
    initial_strategy='mean',     # strategy for the first round (cold start)
    imputation_order='ascending',# order to process columns: 'ascending' (fewest missing first)
    random_state=42
)

X_train_imputed = iter_imp.fit_transform(X_train)
X_test_imputed  = iter_imp.transform(X_test)
```

### How one iteration works

```
Round 1:
  Feature A (has NaN): 
    Temporarily fill with initial_strategy (mean).
  Feature B (has NaN):
    Use [A_imputed, C, D, ...] to predict B → fill B's NaN.
  Feature C (has NaN):
    Use [A_imputed, B_imputed, D, ...] to predict C → fill C's NaN.

Round 2 (all columns now have initial estimates):
  Feature A:
    Use [B_imputed, C_imputed, D, ...] to re-predict A → update A's NaN.
  Feature B:
    Re-predict using the updated values of all other columns.
  ... continue until max_iter or convergence
```

### Swapping the internal estimator

`BayesianRidge` (default) works well for continuous features. You can swap it for anything:

```python
from sklearn.ensemble import RandomForestRegressor, ExtraTreesRegressor
from sklearn.linear_model import Ridge

# More powerful — can capture non-linear relationships
iter_imp_rf = IterativeImputer(
    estimator=ExtraTreesRegressor(n_estimators=10, random_state=42),
    max_iter=10,
    random_state=42
)
```

> [!NOTE]
> Using a tree-based estimator inside `IterativeImputer` is significantly more accurate on non-linear data but also much slower. For most interview/project scenarios, `BayesianRidge` is the right default to mention.

### When to use Iterative Imputation
✅ Multiple features are missing and they are correlated with each other.  
✅ You have time and a moderate-sized dataset (< 100k rows).  
✅ Statistical validity matters (e.g., research, healthcare).  

❌ Large datasets or real-time pipelines — too slow.  
❌ MNAR data — even this won't fix a fundamentally biased missing mechanism.

---

## 3.7 Strategy 5 — Target Encoding-Based Imputation (Categorical)

For **categorical columns**, the `most_frequent` strategy is a blunt instrument. A better approach for MAR data is to impute based on the conditional distribution of the category given observed variables.

**Practical approach:** Use a simple model to predict the missing category from other features:
```python
from sklearn.ensemble import RandomForestClassifier

# Separate rows into those with and without missing 'city'
known   = df[df['city'].notna()]
unknown = df[df['city'].isna()]

features = ['age', 'income', 'region']  # features correlated with 'city'

clf = RandomForestClassifier(n_estimators=50, random_state=42)
clf.fit(known[features], known['city'])

df.loc[df['city'].isna(), 'city'] = clf.predict(unknown[features])
```

---

## 3.8 Strategy 6 — Using Sentinel / Placeholder Values

For **MNAR** situations, instead of imputing a plausible value (which would be misleading), sometimes you explicitly encode "missing" as its own category — telling the model that missingness itself is a meaningful signal.

```python
# Numeric: fill with an impossible sentinel value and add indicator flag
df['income_was_missing'] = df['income'].isnull().astype(int)
df['income'] = df['income'].fillna(-999)   # model sees -999 as a signal

# Categorical: fill with a literal 'Unknown' category
df['occupation'] = df['occupation'].fillna('Unknown')
```

Tree-based models handle this extremely well — they will learn a specific branch for the sentinel value. Linear models will struggle (they'll interpret -999 as a "very negative income"), which is why the `_was_missing` flag is critical alongside it.

---

## 3.9 Comparing Strategies — Head-to-Head

| Strategy | Computation | Handles Multivariate Patterns | Handles Categoricals | Best for |
|:---|:---:|:---:|:---:|:---|
| Drop | ✅ Fastest | ❌ | ❌ | MCAR, < 1% missing |
| `SimpleImputer` (mean/median) | ✅ Fast | ❌ | Partial | MCAR, baseline |
| `SimpleImputer` (most_frequent) | ✅ Fast | ❌ | ✅ | Categorical, MCAR |
| `KNNImputer` | ⚠️ Moderate | ✅ Partial | ❌ (numeric only) | MAR, moderate-size datasets |
| `IterativeImputer` | ❌ Slow | ✅ Full | ❌ (numeric only) | MAR, high-quality imputation |
| Model-based (categorical) | ⚠️ Moderate | ✅ | ✅ | MAR, high-cardinality categories |
| Sentinel + indicator flag | ✅ Fast | ❌ | ✅ | MNAR |

---

## 3.10 The Golden Rule — Fit on Train, Transform on Test

This is the most critical rule in all of imputation, and a very common interview question.

**Wrong ❌ — data leakage:**
```python
imp = SimpleImputer(strategy='mean')
X_imputed = imp.fit_transform(X)           # fits on full dataset including test!
X_train, X_test = train_test_split(X_imputed)
```

**Correct ✅ — no leakage:**
```python
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)

imp = SimpleImputer(strategy='mean')
X_train_imputed = imp.fit_transform(X_train)   # learn the mean from training data only
X_test_imputed  = imp.transform(X_test)        # apply training mean to test data
```

**Best practice — use a Pipeline to make this automatic:**
```python
from sklearn.pipeline import Pipeline
from sklearn.impute import SimpleImputer
from sklearn.preprocessing import StandardScaler
from sklearn.linear_model import LogisticRegression

pipe = Pipeline([
    ('imputer', SimpleImputer(strategy='median')),
    ('scaler',  StandardScaler()),
    ('model',   LogisticRegression())
])

pipe.fit(X_train, y_train)    # imputer fit only on X_train internally
pipe.score(X_test, y_test)    # imputer only transforms X_test
```

The pipeline guarantees the correct fit/transform split automatically, even inside `cross_val_score` and `GridSearchCV`.

---

## 3.11 Checking Imputation Quality

After imputing, always sanity-check:

```python
# 1. No NaN values remain
assert X_train_imputed.isnull().sum().sum() == 0, "Still have NaN values!"

# 2. Distribution hasn't changed dramatically
print("Before imputation:", df['income'].describe())
print("After imputation: ", pd.Series(X_train_imputed[:, income_col_idx]).describe())

# 3. If you have a baseline model, compare cross-val scores
# across imputation strategies to pick the best one
from sklearn.model_selection import cross_val_score

strategies = ['mean', 'median', 'most_frequent']
for strat in strategies:
    pipe = Pipeline([
        ('imp', SimpleImputer(strategy=strat)),
        ('clf', LogisticRegression(max_iter=1000))
    ])
    scores = cross_val_score(pipe, X_train, y_train, cv=5, scoring='f1_weighted')
    print(f"{strat:15s} → mean F1: {scores.mean():.4f} ± {scores.std():.4f}")
```

---
