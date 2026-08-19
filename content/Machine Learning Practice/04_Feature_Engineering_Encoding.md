# 4. Feature Engineering & Encoding


**Intuition:** A model can only learn from the features you give it. Raw features are rarely in the best shape — they may be on wrong scales, encoded as text the model can't read, hiding useful patterns inside them, or simply redundant. Feature engineering is the craft of transforming raw data into a representation that makes the model's job easier.

Two distinct activities live under this umbrella:
- **Feature Engineering** — creating or transforming *numeric* features (new signals from existing ones).
- **Encoding** — converting *categorical / text* features into numbers the model can process.

---

## 4.1 Numerical Feature Transformations

### Motivation: Why Transform Numeric Features?
Many models assume (or perform better when) features are roughly normally distributed and on a similar scale. Real-world data rarely cooperates — income, counts, prices, and durations are almost always right-skewed. Transformations fix this.

### Log Transform
The most common transformation for right-skewed, strictly positive features.

$$x' = \log(1 + x)$$

Adding 1 handles zeros (since $\log(0)$ is undefined). The result compresses the long right tail and makes the distribution more symmetric.

```python
import numpy as np
import pandas as pd

df['log_income']   = np.log1p(df['income'])      # log(1 + x)
df['log_pageviews'] = np.log1p(df['pageviews'])
```

**When to use:** Revenue, prices, word counts, population, anything with a heavy right tail.  
**When NOT to use:** Negative values, zero-inflated distributions with a structural mass at zero.

### Square Root Transform
Milder compression than log — useful for count data (Poisson-distributed):

```python
df['sqrt_complaints'] = np.sqrt(df['complaints'])
```

### Box-Cox Transform
Finds the *optimal* power $\lambda$ that best normalises the data:

$$x' = \begin{cases} \dfrac{x^\lambda - 1}{\lambda} & \lambda \neq 0 \\ \log(x) & \lambda = 0 \end{cases}$$

**Requirement:** All values must be strictly positive ($x > 0$).

```python
from scipy.stats import boxcox

df['bc_income'], fitted_lambda = boxcox(df['income'] + 1)
# fitted_lambda tells you what power was used
print(f"Optimal lambda: {fitted_lambda:.3f}")
# λ ≈ 0   → log transform
# λ ≈ 0.5 → square root
# λ ≈ 1   → no transform (already normal)
# λ ≈ -1  → reciprocal
```

### Yeo-Johnson Transform
Like Box-Cox, but works on **zero and negative values** too. Usually the better default:

```python
from sklearn.preprocessing import PowerTransformer

pt = PowerTransformer(method='yeo-johnson', standardize=True)
# standardize=True also applies z-score normalization after the power transform

X_transformed = pt.fit_transform(X_train[numeric_cols])
# pt.lambdas_ gives the fitted lambda per column
```

### Choosing a Transform

| Feature characteristic | Recommended transform |
|:---|:---|
| Right-skewed, all positive, mild skew | `sqrt` |
| Right-skewed, all positive, heavy skew | `log1p` |
| Strongly skewed, needs optimal fit | `Box-Cox` (positive only) or `Yeo-Johnson` |
| Has negatives or zeros | `Yeo-Johnson` |
| Already roughly normal | None needed |

---

## 4.2 Binning (Discretisation)

**Intuition:** Sometimes a numeric feature is better modelled as a category. For example, `age` might have non-linear effects where the important boundary is "child vs. adult" rather than every individual year. Binning converts continuous values into discrete buckets.

```python
from sklearn.preprocessing import KBinsDiscretizer

kbd = KBinsDiscretizer(
    n_bins=5,
    encode='ordinal',    # 'ordinal': integer labels 0,1,2,3,4
                         # 'onehot':  one-hot sparse matrix
                         # 'onehot-dense': one-hot dense matrix
    strategy='quantile'  # 'uniform': equal-width bins
                         # 'quantile': equal-frequency bins (same number of samples per bin)
                         # 'kmeans': bin boundaries found by k-means clustering
)

df[['age_binned']] = kbd.fit_transform(df[['age']])
```

### Uniform vs. Quantile vs. KMeans Binning

| Strategy | How bins are determined | Best when |
|:---|:---|:---|
| `uniform` | Equal-width: $[min, min + width), [min+width, ...)$ | Feature is uniformly distributed |
| `quantile` | Equal-frequency: each bin has the same number of samples | Feature is skewed (avoids empty bins) |
| `kmeans` | KMeans clustering on the 1D feature | There are natural clusters in the feature |

### Manual / Custom Binning with pandas
```python
# Custom age groups
bins   = [0, 12, 17, 64, 120]
labels = ['child', 'teen', 'adult', 'senior']

df['age_group'] = pd.cut(df['age'], bins=bins, labels=labels, right=True)

# Quantile-based binning (quartiles)
df['income_quartile'] = pd.qcut(df['income'], q=4, labels=['Q1','Q2','Q3','Q4'])
```

> [!NOTE]
> After binning, you typically apply **one-hot encoding** to the result (since the bin labels are not inherently ordered, unless you chose `strategy='ordinal'` intentionally). The exception is when the bins have a natural order (e.g., child < teen < adult < senior) and you're using a tree-based model that can handle ordinal integers directly.

---

## 4.3 Polynomial & Interaction Features

**Intuition:** Linear models assume the relationship between a feature $x$ and the target $y$ is a straight line. But what if the true relationship curves? We can capture this by adding $x^2$, $x^3$, or by adding *interaction terms* like $x_1 \cdot x_2$ that capture joint effects of two features.

$$[x_1, x_2] \xrightarrow{\text{degree=2}} [1, x_1, x_2, x_1^2, x_1 x_2, x_2^2]$$

```python
from sklearn.preprocessing import PolynomialFeatures

poly = PolynomialFeatures(
    degree=2,            # maximum degree of features to generate
    include_bias=False,  # whether to include the constant '1' column
    interaction_only=False  # if True, only cross-terms (no x^2, x^3, ...)
)

X_poly = poly.fit_transform(X_train[['age', 'income']])
print(poly.get_feature_names_out(['age', 'income']))
# → ['age', 'income', 'age^2', 'age income', 'income^2']
```

### Interaction-only terms
```python
poly_interact = PolynomialFeatures(degree=2, interaction_only=True, include_bias=False)
X_interact = poly_interact.fit_transform(X_train[['age', 'income', 'experience']])
# → ['age', 'income', 'experience', 'age income', 'age experience', 'income experience']
```

> [!WARNING]
> Polynomial features expand the feature space combinatorially. With $p$ features and degree $d$, the number of output features is $\binom{p+d}{d}$. With `degree=3` on 10 features, you get **286 features**. Always combine with regularisation (Ridge/Lasso) or feature selection to prevent overfitting and to keep the model tractable.

---

## 4.4 Date & Time Feature Extraction

Datetime columns are opaque to most models — you must extract numeric signals from them.

```python
df['order_date'] = pd.to_datetime(df['order_date'])

# Calendar components
df['year']        = df['order_date'].dt.year
df['month']       = df['order_date'].dt.month          # 1–12
df['day']         = df['order_date'].dt.day            # 1–31
df['dayofweek']   = df['order_date'].dt.dayofweek      # 0=Mon, 6=Sun
df['quarter']     = df['order_date'].dt.quarter        # 1–4
df['weekofyear']  = df['order_date'].dt.isocalendar().week.astype(int)

# Derived binary flags
df['is_weekend']  = df['order_date'].dt.dayofweek >= 5
df['is_month_end'] = df['order_date'].dt.is_month_end
df['is_month_start'] = df['order_date'].dt.is_month_start

# Time deltas (age of something in days)
df['account_age_days'] = (pd.Timestamp.now() - df['account_created']).dt.days
df['days_since_last_login'] = (pd.Timestamp.now() - df['last_login']).dt.days
```

### Cyclical Encoding for Periodic Features
Month (1–12), day-of-week (0–6), and hour (0–23) are *cyclic* — December is adjacent to January, not far from it. Treating them as plain integers breaks this continuity. Use **sine-cosine encoding** instead:

$$x_{\sin} = \sin\!\left(\frac{2\pi \cdot x}{x_{\max}}\right), \quad x_{\cos} = \cos\!\left(\frac{2\pi \cdot x}{x_{\max}}\right)$$

```python
import numpy as np

# Month (1–12)
df['month_sin'] = np.sin(2 * np.pi * df['month'] / 12)
df['month_cos'] = np.cos(2 * np.pi * df['month'] / 12)

# Day of week (0–6)
df['dow_sin'] = np.sin(2 * np.pi * df['dayofweek'] / 7)
df['dow_cos'] = np.cos(2 * np.pi * df['dayofweek'] / 7)

# Hour of day (0–23)
df['hour_sin'] = np.sin(2 * np.pi * df['hour'] / 24)
df['hour_cos'] = np.cos(2 * np.pi * df['hour'] / 24)
```

Now `month=12` and `month=1` are close in the sine-cosine space, which is the correct representation.

---

## 4.5 Encoding Categorical Variables

This is the core of the "Encoding" half. A categorical variable has a finite set of discrete values (e.g., `city`, `colour`, `education_level`). Models need numbers — the method you choose to convert categories to numbers has a major impact on model performance.

### The Key Question: Is there an order?

```
Is there a natural, meaningful order between the categories?
├── YES → Ordinal Encoding
└── NO  → Do you have many unique values?
          ├── Few (< ~15 unique)    → One-Hot Encoding
          └── Many (high-cardinality) → Target / Hashing / Binary Encoding
```

---

### 4.5.1 One-Hot Encoding (OHE)

Creates one binary column per category. A `1` in a column means "this row belongs to this category."

```python
from sklearn.preprocessing import OneHotEncoder

ohe = OneHotEncoder(
    drop='first',           # drop one column per feature to avoid the dummy variable trap
    sparse_output=False,    # return a dense numpy array (easier to work with)
    handle_unknown='ignore' # unseen categories at inference → all zeros (no error)
)

X_encoded = ohe.fit_transform(X_train[['city', 'colour']])
print(ohe.get_feature_names_out())
# → ['city_Delhi', 'city_Mumbai', 'colour_Blue', 'colour_Red']
# Note: 'city_Pune' and 'colour_Green' are dropped (drop='first')
```

#### The Dummy Variable Trap
If you one-hot encode a feature with $k$ categories into $k$ columns **without** dropping one, the columns are perfectly linearly dependent (they always sum to 1). This causes **multicollinearity** and makes the matrix $X^TX$ singular (non-invertible) for linear models.

**Fix:** Always use `drop='first'` (or `drop='if_binary'`). Tree-based models don't suffer from this, but it's still good practice.

#### When NOT to use OHE
- High-cardinality features (ZIP code with 10,000+ unique values → 10,000 extra columns). This causes:
  - The **curse of dimensionality**
  - Very sparse, mostly-zero feature matrix
  - Huge memory usage
  - Poor generalisation

---

### 4.5.2 Ordinal Encoding

For features with a *meaningful natural order* (Low < Medium < High; No < Yes; Terrible < Poor < OK < Good < Excellent).

```python
from sklearn.preprocessing import OrdinalEncoder

oe = OrdinalEncoder(
    categories=[['Low', 'Medium', 'High']],  # explicit order
    handle_unknown='use_encoded_value',       # unseen categories get -1
    unknown_value=-1
)

df[['edu_encoded']] = oe.fit_transform(df[['education_level']])
# Low → 0, Medium → 1, High → 2
```

> [!IMPORTANT]
> If you use OrdinalEncoder on a feature *without* a real order (e.g., `city`), linear models will incorrectly interpret the integers as having magnitude (Delhi=0 < Mumbai=1 < Pune=2, implying Pune is "more" than Delhi). Only use OrdinalEncoder when the order is semantically real.

---

### 4.5.3 Label Encoding

Converts each unique class to an integer **0, 1, 2, ..., k-1**. Typically used only to encode the **target variable** $y$, not input features.

```python
from sklearn.preprocessing import LabelEncoder

le = LabelEncoder()
y_encoded = le.fit_transform(y_train)
# le.classes_ gives the mapping: array(['cat', 'dog', 'fish'])
# cat→0, dog→1, fish→2

# Inverse transform predictions back to original labels
y_original = le.inverse_transform(y_pred)
```

> [!WARNING]
> **Do not use LabelEncoder on input features.** It assigns arbitrary integers to categories with no order, which linear models will misinterpret. Use OrdinalEncoder (with explicit categories) for ordered features, or OHE for unordered features.

---

### 4.5.4 Target Encoding (Mean Encoding)

Replaces each category with the **mean of the target variable** for all rows belonging to that category.

$$\text{encode}(c) = \frac{1}{|S_c|} \sum_{i \in S_c} y_i \quad \text{where } S_c = \{i : x_i = c\}$$

```python
from sklearn.preprocessing import TargetEncoder

te = TargetEncoder(
    target_type='continuous',  # or 'binary', 'multiclass'
    smooth='auto'              # amount of shrinkage toward the global mean
                               # prevents overfitting for rare categories
)

X_train[['city_encoded']] = te.fit_transform(X_train[['city']], y_train)
X_test[['city_encoded']]  = te.transform(X_test[['city']])
```

**Why it works:** Encodes the predictive power of each category directly — the resulting number is meaningful (it's the expected target value for that category).

**The leakage problem:** If you compute the target mean for city `c` using *all* rows including the current row's label, the encoding leaks label information. `sklearn`'s `TargetEncoder` handles this automatically using **cross-fitting** (like leave-one-out), but you must still be careful to fit only on training data.

**Mathematical Foundation (Smoothing):** For rare categories (few samples), the mean is extremely noisy. Target encoding uses an empirical Bayes approach to *shrink* the category mean toward the global mean:
$$\hat{\mu}_c = \lambda \cdot \bar{y}_c + (1 - \lambda) \cdot \bar{y}_\text{global}$$
Where the shrinkage factor $\lambda$ is defined as:
$$\lambda = \frac{n_c}{n_c + m}$$
- $n_c$ = number of samples in category $c$.
- $m$ = smoothing parameter (the "weight" of the prior global mean).
- If $n_c$ is large ($n_c \gg m$), $\lambda \approx 1$, and we trust the category mean $\bar{y}_c$.
- If $n_c$ is small ($n_c \ll m$), $\lambda \approx 0$, and we fall back to the global mean $\bar{y}_\text{global}$.

---

### 4.5.5 Frequency / Count Encoding

Replace each category with the **number of times** it appears in the training set (count encoding), or its **relative frequency** (proportion).

```python
# Count encoding
count_map = df['city'].value_counts()
df['city_count'] = df['city'].map(count_map)

# Frequency encoding (proportion)
freq_map = df['city'].value_counts(normalize=True)
df['city_freq'] = df['city'].map(freq_map)
```

**Pros:** No OHE explosion, preserves some information about category rarity.  
**Cons:** Two different categories with the same frequency get the same encoding — the model can't distinguish them.  
**Best for:** Tree-based models, as a simple high-cardinality baseline.

---

### 4.5.6 Hashing Encoding

Uses a **hash function** to map each category to one of $n$ fixed buckets. No need to store a vocabulary — works on unseen categories at inference time.

```python
from sklearn.feature_extraction import FeatureHasher

hasher = FeatureHasher(n_features=16, input_type='string')
X_hashed = hasher.fit_transform(df['city'].values.reshape(-1, 1))
```

**Pros:** Fixed, predictable output size regardless of cardinality; handles new categories.  
**Cons:** **Hash collisions** — two different categories can land in the same bucket, making them indistinguishable. Increasing `n_features` reduces collisions.

---

### 4.5.7 Binary Encoding

A middle ground between OHE and hashing. Converts each category to an integer, then encodes that integer in binary (base-2). With $k$ unique categories, you need only $\lceil \log_2 k \rceil$ binary columns instead of $k$.

```python
# Manual illustration: 8 cities → 3 binary columns (vs. 8 for OHE)
# city_0: 0 0 0 0 1 1 1 1
# city_1: 0 0 1 1 0 0 1 1
# city_2: 0 1 0 1 0 1 0 1
```

Available via the `category_encoders` library:
```python
import category_encoders as ce

be = ce.BinaryEncoder(cols=['city'])
X_encoded = be.fit_transform(X_train)
```

---

### 4.5.8 Weight of Evidence (WoE) and Information Value (IV)

Widely used in credit scoring and risk modelling, WoE assesses the predictive power of a category in binary classification by comparing the proportion of "good" (non-events) to "bad" (events) in that category against the overall proportions.

**Mathematical Formulation:**
For a given category $c$:
$$\text{WoE}_c = \ln\left( \frac{\% \text{ of Non-Events in } c}{\% \text{ of Events in } c} \right)$$
- If $\text{WoE}_c > 0$: Category $c$ has a higher proportion of non-events than the global average.
- If $\text{WoE}_c < 0$: Category $c$ has a higher proportion of events (riskier).

We can aggregate WoE across all categories in a feature to calculate its **Information Value (IV)**, measuring the feature's total predictive power:
$$\text{IV}_c = (\% \text{ of Non-Events in } c - \% \text{ of Events in } c) \times \text{WoE}_c$$
$$\text{Total IV} = \sum_c \text{IV}_c$$

| Information Value (IV) | Predictive Power |
|:---|:---|
| $< 0.02$ | Useless |
| $0.02 - 0.1$ | Weak predictor |
| $0.1 - 0.3$ | Medium predictor |
| $> 0.3$ | Strong predictor (Warning: $> 0.5$ is suspicious and might be leakage) |

---

### Encoding Strategy Summary

| Method | Output columns | Handles unknown? | Best for |
|:---|:---:|:---:|:---|
| One-Hot Encoding | $k - 1$ | Via `handle_unknown='ignore'` | Low-cardinality, linear models |
| Ordinal Encoding | 1 | Via `handle_unknown` | Ordered categories |
| Label Encoding | 1 | ❌ (errors on new labels) | Target variable only |
| Target Encoding | 1 | Fallback to global mean | High-cardinality, any model |
| WoE Encoding | 1 | Fallback to 0 (neutral) | Binary classification, Risk modelling |
| Frequency Encoding | 1 | Map to 0 for unknown | High-cardinality, trees |
| Hashing | Fixed $n$ | ✅ (by design) | Very high-cardinality, online learning |
| Binary Encoding | $\lceil \log_2 k \rceil$ | ✅ | High-cardinality, moderate |

---

## 4.6 Feature Selection

Creating many features is easy; keeping only the useful ones is harder. More features → more data needed, slower training, risk of overfitting. Feature selection systematically removes uninformative or redundant features.

### 4.6.1 Removing Low-Variance Features

A feature with near-zero variance carries almost no information (it's nearly constant across all samples).

```python
from sklearn.feature_selection import VarianceThreshold

# Remove features with variance < 0.01
sel = VarianceThreshold(threshold=0.01)
X_reduced = sel.fit_transform(X_train)
print(sel.get_support())           # bool mask of retained features
print(X_train.columns[sel.get_support()])  # names of retained features
```

### 4.6.2 Univariate Statistical Tests (`SelectKBest`)

Rank features by their statistical relationship with the target, keep the top $k$.

```python
from sklearn.feature_selection import SelectKBest, chi2, f_classif, mutual_info_classif

# For classification with non-negative integer features (e.g., word counts)
sel_chi2 = SelectKBest(score_func=chi2, k=10)

# For classification with continuous features
sel_f = SelectKBest(score_func=f_classif, k=10)        # F-statistic (linear relationship)
sel_mi = SelectKBest(score_func=mutual_info_classif, k=10)  # mutual information (non-linear)

X_selected = sel_f.fit_transform(X_train, y_train)

# Get the selected feature names
selected_mask  = sel_f.get_support()
selected_names = X_train.columns[selected_mask]
print(selected_names)

# View scores for all features
scores = pd.DataFrame({'feature': X_train.columns, 'score': sel_f.scores_})
print(scores.sort_values('score', ascending=False))
```

| Score function | Relationship captured | Target type |
|:---|:---|:---|
| `chi2` | Association (non-negative features only) | Classification |
| `f_classif` | Linear correlation via ANOVA F-test | Classification |
| `f_regression` | Linear correlation via F-test | Regression |
| `mutual_info_classif` | Any relationship (linear + non-linear) | Classification |
| `mutual_info_regression` | Any relationship | Regression |

### 4.6.3 Recursive Feature Elimination (RFE)

Trains a model, ranks features by importance, removes the least important, repeats until `n_features_to_select` remain.

```python
from sklearn.feature_selection import RFE, RFECV
from sklearn.linear_model import LogisticRegression

# Fixed number of features
rfe = RFE(
    estimator=LogisticRegression(max_iter=1000),
    n_features_to_select=10,
    step=1   # remove 1 feature per iteration (use a larger step for speed)
)
X_rfe = rfe.fit_transform(X_train, y_train)
print(rfe.support_)   # bool mask
print(rfe.ranking_)   # rank of each feature (1 = selected)

# Auto-select optimal n_features via cross-validation
rfecv = RFECV(estimator=LogisticRegression(max_iter=1000), cv=5, scoring='f1')
rfecv.fit(X_train, y_train)
print(f"Optimal number of features: {rfecv.n_features_}")
```

### 4.6.4 Model-Based Feature Selection (`SelectFromModel`)

Use a model's learned importance scores (tree feature importances, or L1 regularisation coefficients) to select features above a threshold.

```python
from sklearn.feature_selection import SelectFromModel
from sklearn.ensemble import RandomForestClassifier
from sklearn.linear_model import LassoCV

# Random Forest importance (tree-based)
rf = RandomForestClassifier(n_estimators=100, random_state=42)
sf_rf = SelectFromModel(rf, threshold='mean')   # keep features with importance > mean
X_rf_selected = sf_rf.fit_transform(X_train, y_train)

# L1 (Lasso) — drives coefficients to exactly zero
lasso = LassoCV(cv=5, random_state=42)
sf_lasso = SelectFromModel(lasso, threshold=1e-5)  # keep non-zero coefficient features
X_lasso_selected = sf_lasso.fit_transform(X_train, y_train)
```

> [!TIP]
> L1-based feature selection (`Lasso`, `LogisticRegression(penalty='l1')`) is one of the most principled ways to do feature selection for linear models — the regularisation and selection happen in a single step. Random Forest importance is the most practical choice for tree-based pipelines.

---

## 4.7 Putting It Together — `ColumnTransformer`

In a real dataset, you have a mix of numeric, ordinal, and nominal columns. `ColumnTransformer` applies different preprocessing pipelines to different subsets of columns and then horizontally concatenates the results.

```python
from sklearn.compose import ColumnTransformer
from sklearn.pipeline import Pipeline
from sklearn.impute import SimpleImputer
from sklearn.preprocessing import StandardScaler, OneHotEncoder, OrdinalEncoder
from sklearn.ensemble import RandomForestClassifier

# Define your column groups
numeric_cols  = ['age', 'income', 'tenure']
ordinal_cols  = ['education']        # Low < Medium < High
nominal_cols  = ['city', 'gender']   # no order

# Preprocessing sub-pipelines
numeric_pipe = Pipeline([
    ('impute', SimpleImputer(strategy='median')),
    ('scale',  StandardScaler())
])

ordinal_pipe = Pipeline([
    ('impute', SimpleImputer(strategy='most_frequent')),
    ('encode', OrdinalEncoder(categories=[['Low', 'Medium', 'High']]))
])

nominal_pipe = Pipeline([
    ('impute', SimpleImputer(strategy='most_frequent')),
    ('encode', OneHotEncoder(drop='first', handle_unknown='ignore', sparse_output=False))
])

# Combine into one preprocessor
preprocessor = ColumnTransformer([
    ('num', numeric_pipe,  numeric_cols),
    ('ord', ordinal_pipe,  ordinal_cols),
    ('nom', nominal_pipe,  nominal_cols),
], remainder='drop')   # 'drop': ignore remaining cols; 'passthrough': keep them as-is

# Full model pipeline
full_pipe = Pipeline([
    ('preprocessor', preprocessor),
    ('model', RandomForestClassifier(n_estimators=100, random_state=42))
])

full_pipe.fit(X_train, y_train)
print(f"Test accuracy: {full_pipe.score(X_test, y_test):.4f}")
```

> [!IMPORTANT]
> `ColumnTransformer` is the scikit-learn-idiomatic way to handle mixed-type data. It respects the fit-on-train / transform-on-test boundary automatically when used inside a `Pipeline`, and it makes `GridSearchCV` seamless. Always prefer this over manual column-by-column transformations in production code.

---
