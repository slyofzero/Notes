>[!SUMMARY] Table of Contents
>- [[Fundamental ML Concepts#The ML Project Life Cycle|The ML Project Life Cycle]]
>- [[Fundamental ML Concepts#1. Exploratory Data Analysis (EDA)|1. EDA]]
>- [[Fundamental ML Concepts#2. Data Cleaning|2. Data Cleaning]]
>- [[Fundamental ML Concepts#3. Data Imputation|3. Data Imputation]]
>- [[Fundamental ML Concepts#4. Feature Engineering & Encoding|4. Feature Engineering & Encoding]]
>- [[Fundamental ML Concepts#5. Feature Scaling|5. Feature Scaling]]
>- [[Fundamental ML Concepts#6. Train-Test Split & Cross-Validation|6. Train-Test Split & Cross-Validation]]
>- [[Fundamental ML Concepts#7. Hyperparameter Tuning|7. Hyperparameter Tuning]]
>- [[Fundamental ML Concepts#8. Evaluation Metrics — Regression|8. Evaluation Metrics — Regression]]
>- [[Fundamental ML Concepts#9. Evaluation Metrics — Classification|9. Evaluation Metrics — Classification]]
>	- [[Fundamental ML Concepts#Confusion Matrix|Confusion Matrix]]
>	- [[Fundamental ML Concepts#ROC-AUC Curve|ROC-AUC Curve]]
>	- [[Fundamental ML Concepts#Precision-Recall Curve|Precision-Recall Curve]]
>- [[Fundamental ML Concepts#10. scikit-learn Models — Theory & Hyperparameters|10. scikit-learn Models]]
>	- [[Fundamental ML Concepts#Linear Regression|Linear Regression]]
>	- [[Fundamental ML Concepts#Ridge & Lasso Regression|Ridge & Lasso]]
>	- [[Fundamental ML Concepts#Logistic Regression|Logistic Regression]]
>	- [[Fundamental ML Concepts#Support Vector Machines (SVM)|SVM]]
>	- [[Fundamental ML Concepts#Decision Trees|Decision Trees]]
>	- [[Fundamental ML Concepts#Ensemble Methods|Ensemble Methods]]
>	- [[Fundamental ML Concepts#K-Nearest Neighbours (KNN)|KNN]]
>	- [[Fundamental ML Concepts#Naïve Bayes|Naïve Bayes]]
>	- [[Fundamental ML Concepts#Neural Networks (MLPClassifier / MLPRegressor)|Neural Networks]]
>	- [[Fundamental ML Concepts#K-Means Clustering|K-Means]]
>	- [[Fundamental ML Concepts#DBSCAN|DBSCAN]]
>	- [[Fundamental ML Concepts#Principal Component Analysis (PCA)|PCA]]
>- [[Fundamental ML Concepts#11. scikit-learn Pipeline API|11. scikit-learn Pipeline API]]
>- [[Fundamental ML Concepts#12. Inference & Deployment Checklist|12. Inference & Deployment Checklist]]
>- [[Fundamental ML Concepts#Appendix — Legacy Notes|Appendix — Legacy Notes]]

This file is a **comprehensive reference for the IITM BSCS2008 Machine Learning Practice** course, covering the full end-to-end project lifecycle in scikit-learn. Use it as your single-stop interview guide.

---

# The ML Project Life Cycle

Every ML project follows a repeatable sequence of steps. Think of it as a pipeline where a mistake early on propagates and amplifies at every downstream stage.

```
Raw Data
   ↓
EDA (understand the data)
   ↓
Train–Validation–Test Split
   ↓
Data Cleaning (remove noise and inconsistencies)
   ↓
Data Imputation (handle missing values)
   ↓
Feature Engineering & Encoding
   ↓
Feature Scaling / Normalization
   ↓
Model Selection & Training
   ↓
Hyperparameter Tuning (with Cross-Validation)
   ↓
Evaluation on held-out Test Set
   ↓
Inference / Deployment
```

---

# 1. Exploratory Data Analysis (EDA)

**Intuition:** Before writing a single line of model code, *look at your data*. EDA helps you understand distributions, spot outliers, find relationships between features, and form hypotheses about which models might work.

## Key EDA Tasks

| Task | What to do | Python / pandas call |
|:---|:---|:---|
| Shape & types | Rows, columns, dtypes | `df.shape`, `df.dtypes`, `df.info()` |
| Summary stats | Mean, std, min, max, quartiles | `df.describe()` |
| Missing values | Count & % per column | `df.isnull().sum()` |
| Unique values | Cardinality of categoricals | `df['col'].nunique()`, `df['col'].value_counts()` |
| Distribution | Histograms, box plots | `df['col'].hist()`, `df.boxplot()` |
| Correlation | Pearson / Spearman heatmap | `df.corr()`, `sns.heatmap(df.corr())` |
| Pairplots | Feature-to-feature scatter | `sns.pairplot(df)` |
| Class balance | For classification targets | `df['target'].value_counts(normalize=True)` |

## What to look for
- **Skewness** — highly skewed features may need log-transform before training.
- **Outliers** — IQR fences: values below $Q_1 - 1.5 \cdot IQR$ or above $Q_3 + 1.5 \cdot IQR$ are suspected outliers.
- **Multicollinearity** — features that are highly correlated add redundant information; detect using a correlation matrix or VIF (see appendix).
- **Target leakage** — a feature that encodes the answer (e.g., `loan_approved` predicting `default`) — drop it.

---

# 2. Data Cleaning

**Intuition:** Garbage in → garbage out. No model — however sophisticated — can compensate for data that is wrong, inconsistent, or corrupted. Data cleaning is the process of detecting and correcting (or removing) those problems *before* they reach the model.

Think of it in layers:

```
1. Structural problems   → wrong shape, wrong types, wrong schema
2. Duplicate records     → exact or near-duplicate rows
3. Inconsistent values   → same thing expressed differently
4. Invalid / impossible values → ages of 999, negative prices
5. Outliers              → statistically extreme values
6. Target leakage        → features that "cheat" by encoding the answer
```

---

## 2.1 Understanding Your Data Types First

Before cleaning anything, you must know what type each column *should* be. `df.info()` shows current dtypes; mismatches are the first red flag.

```python
df.info()
# Shows: column name | non-null count | dtype

df.dtypes
# Quick dtype-per-column view
```

**Common dtype mismatches and their causes:**

| Column should be | But dtype shows | Likely cause |
|:---|:---|:---|
| `int` / `float` | `object` | Mixed numeric + string values (`"N/A"`, `"-"`, `""`) |
| `datetime` | `object` | Dates stored as strings |
| `category` | `object` | Low-cardinality strings not cast yet |
| `bool` | `int64` | Binary flags stored as 0/1 |

---

## 2.2 Fixing Data Types

### Numeric Coercion
```python
# errors='coerce' silently converts unparseable values to NaN
# errors='raise' throws an exception (good for catching hidden issues)
# errors='ignore' leaves unparseable values unchanged

df['price'] = pd.to_numeric(df['price'], errors='coerce')
df['age']   = pd.to_numeric(df['age'],   errors='coerce')
```

After coercion, always check how many `NaN` values appeared — a sudden spike means the column had many masked non-numeric values:
```python
df['price'].isnull().sum()
```

### Datetime Parsing
```python
df['order_date'] = pd.to_datetime(df['order_date'], format='%Y-%m-%d', errors='coerce')

# Once parsed, you can extract components:
df['order_year']       = df['order_date'].dt.year
df['order_month']      = df['order_date'].dt.month
df['order_dayofweek']  = df['order_date'].dt.dayofweek  # 0=Monday, 6=Sunday
df['is_weekend']       = df['order_date'].dt.dayofweek >= 5
```

### Casting to Efficient Types
```python
# Save memory on low-cardinality string columns
df['city'] = df['city'].astype('category')

# Boolean flags
df['is_active'] = df['is_active'].astype(bool)
```

---

## 2.3 Handling Duplicate Records

**Why duplicates exist:** ETL pipeline failures, form re-submissions, data merges without deduplication, web scraping.

**Why they matter:** Exact duplicates artificially inflate model confidence in certain patterns. Near-duplicates (same person, slightly different spelling) introduce contradictory labels.

### Exact Duplicates
```python
print(df.duplicated().sum())          # how many fully duplicate rows?
print(df.duplicated(keep='first').sum())  # same thing, keep=first/last/False

# View the actual duplicate rows
df[df.duplicated(keep=False)]

# Drop, keeping the first occurrence
df.drop_duplicates(keep='first', inplace=True)
```

### Subset-Based Deduplication
Sometimes only a *key* (e.g., `user_id` + `transaction_date`) must be unique, not the full row:
```python
df.drop_duplicates(subset=['user_id', 'transaction_date'], keep='last', inplace=True)
```

### Near-Duplicates (Fuzzy Matching)
When the same entity appears with minor typos (e.g., `"John Smith"` vs `"Jon Smith"`), exact matching fails. Use the `fuzzywuzzy` / `thefuzz` library:
```python
from thefuzz import fuzz, process

# Ratio of similarity between two strings (0–100)
fuzz.ratio("John Smith", "Jon Smith")       # → 91
fuzz.token_sort_ratio("Smith John", "John Smith")  # → 100 (order-independent)

# Find best match for a string from a list of candidates
process.extractOne("Jon Smith", ["John Smith", "Jane Doe", "Jack Jones"])
# → ('John Smith', 91)
```

> [!NOTE]
> Near-duplicate resolution is expensive at scale. In practice, block records by a shared key (e.g., same ZIP code, same first 3 letters of name) before fuzzy-matching within each block.

---

## 2.4 Inconsistent Categories

This is one of the most common and sneakiest problems — the same real-world entity is represented in multiple ways.

### String Normalisation
```python
# Strip whitespace and convert to lowercase
df['gender'] = df['gender'].str.strip().str.lower()
# 'Male', 'male ', '  MALE  ' → 'male'

# Remove special characters
df['city'] = df['city'].str.replace(r'[^a-zA-Z\s]', '', regex=True)

# Standardise known aliases using a mapping dict
gender_map = {'m': 'male', 'f': 'female', 'man': 'male', 'woman': 'female', '1': 'male', '0': 'female'}
df['gender'] = df['gender'].map(gender_map).fillna(df['gender'])
```

### Checking Remaining Unique Values
Always verify after normalisation — surprises lurk:
```python
df['gender'].value_counts()
# male     8200
# female   6100
# other     150
# prefer not to say  45
# n/a       12    ← still some junk
```

### Replacing Placeholder "Missing" Strings
Data engineers often use placeholder strings instead of actual `NaN`:
```python
# Common placeholders to watch out for:
placeholders = ['n/a', 'na', 'none', 'null', 'missing', '-', '--', '?', 'unknown', '']

df.replace(placeholders, np.nan, inplace=True)
# Or during read:
df = pd.read_csv('data.csv', na_values=placeholders)
```

---

## 2.5 Impossible / Invalid Values

These are values that are technically parseable (no dtype error) but semantically wrong.

**Examples:**
- `age = -5` or `age = 999`
- `price = -100`
- `rating = 7` on a 1–5 scale
- `end_date < start_date`
- `percentage = 150`

### Domain-Clipping (Hard Bounds)
```python
# Clip to valid physiological range: age between 0 and 120
df['age'] = df['age'].clip(lower=0, upper=120)

# Set impossible values to NaN for later imputation
df.loc[df['age'] < 0, 'age']   = np.nan
df.loc[df['age'] > 120, 'age'] = np.nan
df.loc[df['price'] < 0, 'price'] = np.nan
```

### Cross-Column Validation
```python
# Flag rows where end_date is before start_date
invalid_dates = df['end_date'] < df['start_date']
print(f"Invalid date ranges: {invalid_dates.sum()}")

# Fix: set end_date to NaN if it precedes start_date
df.loc[invalid_dates, 'end_date'] = np.nan
```

---

## 2.6 Outlier Detection & Treatment

An **outlier** is a data point that deviates markedly from the other observations. But crucially: *outlier ≠ error*. Whether to treat it depends on the *reason* for it.

| Situation | Decision |
|:---|:---|
| Data entry error (age = 999) | Remove or set to NaN |
| Instrument error (sensor spike) | Remove or smooth |
| Real but rare event (billionaire's income) | Keep, but may need robust scaling |
| Ambiguous | Flag it, investigate, document |

### Method 1 — IQR Fence (Tukey's Method)

The most widely used rule-of-thumb. Does not assume normality.

$$Q_1 = \text{25th percentile}, \quad Q_3 = \text{75th percentile}, \quad IQR = Q_3 - Q_1$$

$$\text{Lower fence} = Q_1 - 1.5 \cdot IQR \qquad \text{Upper fence} = Q_3 + 1.5 \cdot IQR$$

Values outside these fences are flagged as suspected outliers. Using **3.0** instead of **1.5** gives "extreme" outliers.

```python
Q1 = df['salary'].quantile(0.25)
Q3 = df['salary'].quantile(0.75)
IQR = Q3 - Q1

lower_fence = Q1 - 1.5 * IQR
upper_fence = Q3 + 1.5 * IQR

outliers = df[(df['salary'] < lower_fence) | (df['salary'] > upper_fence)]
print(f"Number of outliers: {len(outliers)}")

# Option A: Remove
df_clean = df[(df['salary'] >= lower_fence) & (df['salary'] <= upper_fence)]

# Option B: Cap (Winsorize) — clip at the fences rather than removing
df['salary'] = df['salary'].clip(lower=lower_fence, upper=upper_fence)
```

### Method 2 — Z-Score Method

Assumes the data is approximately normally distributed. A point with $|z| > 3$ is typically flagged.

$$z_i = \frac{x_i - \mu}{\sigma}$$

```python
from scipy import stats
z_scores = np.abs(stats.zscore(df['salary'].dropna()))
outlier_mask = z_scores > 3

df_clean = df[~outlier_mask]
```

**When to prefer IQR vs. Z-score:**

| Method | Best when | Weakness |
|:---|:---|:---|
| IQR | Non-normal / skewed data | Less sensitive to mild outliers in normal data |
| Z-score | Data is roughly normal | Breaks badly on heavily skewed distributions (a single extreme outlier inflates $\sigma$, masking others — the **masking effect**) |

### Method 3 — Modified Z-Score (Robust Alternative)
Uses the **Median Absolute Deviation (MAD)** instead of mean/std, making it robust to the masking effect.

$$\text{MAD} = \text{median}(|x_i - \tilde{x}|) \qquad M_i = \frac{0.6745 \cdot (x_i - \tilde{x})}{\text{MAD}}$$

Flag if $|M_i| > 3.5$.

```python
median = df['salary'].median()
mad = np.median(np.abs(df['salary'] - median))
modified_z = 0.6745 * (df['salary'] - median) / mad
outliers = df[np.abs(modified_z) > 3.5]
```

### Method 4 — Isolation Forest (ML-based, multivariate)

Detects outliers in the **joint distribution** of multiple features simultaneously. A random forest that isolates points — anomalous points are isolated with fewer splits because they lie far from the bulk.

```python
from sklearn.ensemble import IsolationForest

iso = IsolationForest(n_estimators=100, contamination=0.05, random_state=42)
# contamination: the expected fraction of outliers (a hyperparameter you set)

iso.fit(X_train[numeric_cols])
preds = iso.predict(X_train[numeric_cols])
# +1 = inlier,  -1 = outlier

inlier_mask = preds == 1
X_clean = X_train[inlier_mask]
```

**Key hyperparameter:** `contamination` — set this based on domain knowledge or grid-search on a validation set. Higher contamination → more points flagged as outliers.

### Outlier Treatment Strategies

| Strategy | How | When to use |
|:---|:---|:---|
| **Remove** | Drop the row | Clear data entry error; small number of outliers |
| **Cap / Winsorize** | Set value = fence value | Real but extreme; don't want to lose the row |
| **Log Transform** | $x' = \log(1+x)$ | Right-skewed data (income, counts) — compresses the tail |
| **Sqrt / Box-Cox** | Power transforms | More general normalisation of skewed features |
| **Separate model** | Flag as binary feature `is_outlier` | Outlier behaviour is genuinely different |
| **Keep** | Do nothing | Model is robust (tree-based); outlier is real |

```python
import numpy as np

# Log transform (add 1 to handle zeros)
df['log_income'] = np.log1p(df['income'])

# Box-Cox (requires all values > 0)
from scipy.stats import boxcox
df['bc_income'], lambda_val = boxcox(df['income'] + 1)

# Yeo-Johnson (handles zeros and negatives)
from sklearn.preprocessing import PowerTransformer
pt = PowerTransformer(method='yeo-johnson')
df[['income_transformed']] = pt.fit_transform(df[['income']])
```

---

## 2.7 String & Text Cleaning

Relevant for any free-text or messy string columns (product names, addresses, comments).

```python
# Convert to lowercase
df['product_name'] = df['product_name'].str.lower()

# Remove leading/trailing whitespace
df['product_name'] = df['product_name'].str.strip()

# Remove extra internal spaces
df['product_name'] = df['product_name'].str.replace(r'\s+', ' ', regex=True)

# Remove punctuation / special characters
df['address'] = df['address'].str.replace(r'[^\w\s]', '', regex=True)

# Extract patterns with regex (e.g., extract ZIP code from address)
df['zip'] = df['address'].str.extract(r'(\d{6})')

# Pad strings to uniform length (e.g., account codes)
df['account_code'] = df['account_code'].str.zfill(8)  # left-pad with zeros to length 8
```

---

## 2.8 Detecting & Preventing Target Leakage

**Target leakage** is when a feature in your training set contains information about the target that would **not be available at prediction time**. It is one of the most dangerous and hard-to-spot bugs in ML.

**Example:** You are predicting whether a loan will default. One of the features is `days_overdue_at_last_check`. But this is only known *after* the loan is active — at prediction time (when the loan is being considered) this value doesn't exist yet. The model will train with nearly perfect accuracy on this feature and completely fail in production.

**Two types of leakage:**

| Type | Description | Example |
|:---|:---|:---|
| **Train-test contamination** | Test data information bleeds into training (e.g., fitting scaler on full data) | Scaling before splitting |
| **Feature leakage** | Feature encodes the label directly or was computed using the label | `days_overdue`, `fraud_score_from_label_tool` |

### How to detect feature leakage
1. **Suspiciously high validation accuracy** on a feature you didn't expect — investigate it.
2. Check if the feature was **derived after the target event occurred**.
3. Check **feature importances** in a trained model — if one feature dominates all others, inspect it.
4. Compute **time-aware** features for time-series data (always use the timestamp of the prediction moment, not hindsight data).

```python
# Quick check: correlation between each feature and target
leakage_suspects = df.corr()['target'].sort_values(ascending=False)
print(leakage_suspects.head(10))
# Correlations > 0.9 with target from a single feature are suspicious
```

---

## 2.9 End-to-End Data Cleaning Checklist

Before passing your data to any imputer or model, run through this:

```python
# 1. Shape and types
print(df.shape)
print(df.dtypes)
df.info()

# 2. Missing values
print(df.isnull().sum())
print((df.isnull().mean() * 100).round(2))  # percentage missing per column

# 3. Duplicate rows
print(df.duplicated().sum())
df.drop_duplicates(inplace=True)

# 4. Fix dtypes
df['price']  = pd.to_numeric(df['price'],  errors='coerce')
df['date']   = pd.to_datetime(df['date'],  errors='coerce')
df['rating'] = df['rating'].astype('category')

# 5. Standardise strings
for col in categorical_cols:
    df[col] = df[col].str.strip().str.lower()

# 6. Replace placeholder missing-value strings
df.replace(['n/a', 'na', 'none', 'null', '-', '?', ''], np.nan, inplace=True)

# 7. Clip impossible values (domain knowledge)
df['age']   = df['age'].clip(0, 120)
df['price'] = df['price'].clip(0, None)  # None means no upper bound

# 8. Detect & treat outliers (choose method based on distribution)
for col in numeric_cols:
    Q1, Q3 = df[col].quantile([0.25, 0.75])
    IQR = Q3 - Q1
    df[col] = df[col].clip(Q1 - 1.5*IQR, Q3 + 1.5*IQR)

# 9. Verify: how much data is left?
print(f"Rows after cleaning: {len(df)}")
print(f"Remaining missing values: {df.isnull().sum().sum()}")
```

> [!IMPORTANT]
> Data cleaning should happen **before** the train-test split only for decisions that are truly global (e.g., dropping columns with > 90% missing). Column-level statistics (mean, Q1/Q3 fences for capping, StandardScaler mean/std) must **always** be computed on the training set only and then applied to the test set. Computing them on the full dataset is a subtle form of data leakage.

---

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

$$\hat{x}_{ij} = \frac{1}{k} \sum_{l \in \text{kNN}(i)} x_{lj}$$

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

**Smoothing:** For rare categories (few samples), the mean is noisy. Smoothing blends the category mean toward the global mean:
$$\hat{\mu}_c = \frac{n_c \cdot \bar{y}_c + m \cdot \bar{y}_\text{global}}{n_c + m}$$
where $m$ is the smoothing parameter and $n_c$ is the number of samples in category $c$.

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

### Encoding Strategy Summary

| Method | Output columns | Handles unknown? | Best for |
|:---|:---:|:---:|:---|
| One-Hot Encoding | $k - 1$ | Via `handle_unknown='ignore'` | Low-cardinality, linear models |
| Ordinal Encoding | 1 | Via `handle_unknown` | Ordered categories |
| Label Encoding | 1 | ❌ (errors on new labels) | Target variable only |
| Target Encoding | 1 | Fallback to global mean | High-cardinality, any model |
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

# 5. Feature Scaling

**Intuition:** Most ML models don't care about the *names* of features — they only see the numbers. If one feature has a range of [0, 100,000] (income in rupees) and another has a range of [0, 5] (number of children), a model that computes distances or dot products will treat the income feature as ~20,000× more important simply because its numbers are larger — not because it is actually more informative. Feature scaling removes this spurious scale-driven dominance.

---

## 5.1 Why Scaling Matters — The Mathematical Root Cause

### Distance-based models (KNN, K-Means, SVM with RBF kernel)
Euclidean distance between two samples:

$$d(\mathbf{x}, \mathbf{x}') = \sqrt{\sum_{j=1}^{p} (x_j - x_j')^2}$$

If feature $j$ has a range 1000× larger than feature $k$, the distance is almost entirely determined by feature $j$. Features with small ranges become invisible to the model.

### Gradient descent convergence (Linear Regression, Logistic Regression, Neural Networks)
The loss surface of an unscaled model is an elongated ellipse — one axis is very steep (for the large-scale feature), the other is nearly flat (for the small-scale feature). Gradient descent bounces back and forth along the steep axis and converges very slowly.

After scaling, the loss surface is roughly circular, and gradient descent converges in far fewer steps.

$$\text{Elongated (unscaled): } \mathcal{L} = (1000 w_1 x_1 + w_2 x_2 - y)^2$$
$$\text{Symmetric (scaled): } \mathcal{L} = (w_1 x_1' + w_2 x_2' - y)^2$$

### Regularisation fairness (Ridge, Lasso)
L1/L2 penalties add $\lambda \sum w_j^2$ or $\lambda \sum |w_j|$ to the loss. If features are on different scales, a large raw feature value forces the model to learn a small coefficient $w_j$ for it — the regularisation then penalises this small coefficient less than the coefficient for a small-range feature that has a proportionally larger $w_j$. This makes regularisation unfair and inconsistent across features.

---

## 5.2 Which Models Need Scaling?

| Model | Needs Scaling? | Why |
|:---|:---:|:---|
| **KNN** | ✅ Critical | Distance computation directly uses feature values |
| **K-Means** | ✅ Critical | Euclidean distance to centroids |
| **SVM (RBF / poly kernel)** | ✅ Critical | Kernel function is distance-based |
| **SVM (linear kernel)** | ✅ Yes | Affects the margin and regularisation |
| **Linear Regression** | ✅ Yes | Gradient descent convergence; coefficient interpretability |
| **Logistic Regression** | ✅ Yes | Same as above |
| **Neural Networks (MLP)** | ✅ Yes | Weight initialisation and gradient flow assume similar scales |
| **PCA** | ✅ Yes | Eigenvectors dominated by high-variance (large-scale) features |
| **Decision Trees** | ❌ No | Splits are threshold comparisons — scale-invariant |
| **Random Forest, GBM, XGBoost** | ❌ No | Ensemble of trees — same reason |
| **Naïve Bayes** | ❌ No | Models each feature's distribution independently |
| **LDA** | ✅ Yes | Covariance-based — influenced by scale |

> [!IMPORTANT]
> The rule of thumb: **any model that computes distances, dot products, or uses gradient-based optimisation needs scaling**. Tree-based models that make decisions via thresholds do not.

---

## 5.3 StandardScaler (Z-score Normalisation)

**What it does:** Subtracts the mean and divides by the standard deviation, making each feature have **mean = 0** and **standard deviation = 1**.

$$\boxed{x' = \frac{x - \mu}{\sigma}}$$

where $\mu = \frac{1}{n}\sum x_i$ and $\sigma = \sqrt{\frac{1}{n}\sum(x_i - \mu)^2}$.

```python
from sklearn.preprocessing import StandardScaler

scaler = StandardScaler(
    with_mean=True,   # subtract the mean (set False for sparse matrices)
    with_std=True     # divide by std dev
)

X_train_scaled = scaler.fit_transform(X_train)  # fit on train, transform train
X_test_scaled  = scaler.transform(X_test)       # only transform test (use train's μ, σ)

# Inspect what was learnt
print(scaler.mean_)    # μ per feature
print(scaler.scale_)   # σ per feature (std dev)

# Inverse transform back to original space
X_original = scaler.inverse_transform(X_train_scaled)
```

### Effect on distribution
StandardScaler **does NOT change the shape** of the distribution — it only shifts and stretches it. A right-skewed distribution remains right-skewed after standardisation; outliers are still extreme (just expressed in units of standard deviation). For a normal distribution, ~68% of values fall in $[-1, 1]$, ~95% in $[-2, 2]$.

### When to use
✅ Features are roughly normally distributed.  
✅ You plan to use Ridge/Lasso/ElasticNet (ensures fair regularisation).  
✅ PCA (ensures equal contribution from all features).  
❌ Data has extreme outliers — $\mu$ and $\sigma$ are both distorted by them.

---

## 5.4 MinMaxScaler

**What it does:** Linearly compresses every feature into a fixed range, by default **[0, 1]**.

$$\boxed{x' = \frac{x - x_{\min}}{x_{\max} - x_{\min}}}$$

To scale to a custom range $[a, b]$:
$$x' = a + \frac{(x - x_{\min})(b - a)}{x_{\max} - x_{\min}}$$

```python
from sklearn.preprocessing import MinMaxScaler

scaler = MinMaxScaler(feature_range=(0, 1))   # default; change to (-1, 1) if needed

X_train_scaled = scaler.fit_transform(X_train)
X_test_scaled  = scaler.transform(X_test)

print(scaler.data_min_)   # x_min per feature (from training data)
print(scaler.data_max_)   # x_max per feature (from training data)
print(scaler.data_range_) # x_max - x_min per feature
```

### The Outlier Sensitivity Problem — Illustrated

Suppose `income` in the training set is mostly 20k–80k, but one value is 5,000,000 (a data entry error or a genuine billionaire):

```
x_min = 15,000
x_max = 5,000,000
data_range = 4,985,000

income = 50,000 → x' = (50,000 - 15,000) / 4,985,000 ≈ 0.007
income = 80,000 → x' = (80,000 - 15,000) / 4,985,000 ≈ 0.013
```

Nearly all data points are compressed into the $[0, 0.02]$ range — 98% of the $[0, 1]$ range is consumed by the single outlier. The scaler is effectively broken.

**Fix:** Remove or cap outliers *before* MinMaxScaling, or use `RobustScaler` instead.

### When to use
✅ Neural networks that require inputs in $[0, 1]$ (e.g., sigmoid output layer).  
✅ Image pixel data (already bounded at $[0, 255]$, no outliers).  
✅ Features genuinely have hard minimum/maximum bounds.  
❌ Data has outliers — they ruin the scale.

---

## 5.5 RobustScaler

**What it does:** Uses the **median** and **IQR** instead of mean and std, making it resistant to outliers.

$$\boxed{x' = \frac{x - Q_2}{Q_3 - Q_1} = \frac{x - \text{median}}{IQR}}$$

where $Q_2$ = 50th percentile (median), $Q_1$ = 25th percentile, $Q_3$ = 75th percentile.

```python
from sklearn.preprocessing import RobustScaler

scaler = RobustScaler(
    with_centering=True,          # subtract the median
    with_scaling=True,            # divide by IQR
    quantile_range=(25.0, 75.0)   # the percentiles to use for IQR (tunable)
)

X_train_scaled = scaler.fit_transform(X_train)
X_test_scaled  = scaler.transform(X_test)

print(scaler.center_)  # median per feature
print(scaler.scale_)   # IQR per feature
```

### Why it's robust

The median is unaffected by extreme values (changing the top 1% of values doesn't change the median). The IQR only looks at the middle 50% of the data, completely ignoring the tails. Compare on the billionaire income example:

```
Data: [20k, 25k, 30k, 50k, 60k, 80k, 5,000k]

StandardScaler: μ ≈ 752k (skewed by 5M outlier), σ ≈ 1,888k
RobustScaler:   median = 50k, IQR = 80k - 25k = 55k

income = 50k → StandardScaler: (50k-752k)/1888k ≈ -0.37
              → RobustScaler:   (50k-50k)/55k   = 0.00   (correctly centred)
```

### When to use
✅ Data has outliers you cannot remove (genuine extreme values).  
✅ Heavy-tailed distributions (income, house prices, user activity).  
❌ Data is truly clean and normal — StandardScaler is slightly more efficient.

---

## 5.6 MaxAbsScaler

**What it does:** Divides each feature by the maximum **absolute value**, scaling to $[-1, 1]$ without shifting (no mean subtraction).

$$x' = \frac{x}{\max(|x|)}$$

```python
from sklearn.preprocessing import MaxAbsScaler

scaler = MaxAbsScaler()
X_scaled = scaler.fit_transform(X_train)
```

### When to use
✅ **Sparse data** (e.g., TF-IDF matrices, one-hot encoded matrices). With sparse matrices, subtracting the mean (like StandardScaler does) would destroy sparsity — every zero becomes a non-zero value, blowing up memory. MaxAbsScaler preserves sparsity because it only divides.  
✅ Data that is already centred around zero (positive and negative values).  
❌ Data with large outliers — the max absolute value is sensitive to extremes.

---

## 5.7 Normalizer (Row-wise Scaling)

**Critical distinction:** All scalers above operate **column-wise** (per feature, across all samples). `Normalizer` operates **row-wise** (per sample, across all features). It rescales each sample independently so that it has unit norm.

$$x'_i = \frac{\mathbf{x}_i}{\|\mathbf{x}_i\|_p}$$

| Norm  |                Formula                 |                           Effect                           |
| :---: | :------------------------------------: | :--------------------------------------------------------: |
| `l1`  |     $\|\mathbf{x}\|_1 = \sum x_j$      |    Each row sums to 1 (like a probability distribution)    |
| `l2`  | $\|\mathbf{x}\|_2 = \sqrt{\sum x_j^2}$ | Each row has unit Euclidean length (lies on a unit sphere) |
| `max` |   $\|\mathbf{x}\|_\infty = \max x_j$   |             Max element in each row becomes 1              |

```python
from sklearn.preprocessing import Normalizer

norm = Normalizer(norm='l2')   # 'l1', 'l2', or 'max'
X_normalised = norm.fit_transform(X_train)
```

### When to use
✅ **Text / NLP** — normalising TF-IDF vectors so document length doesn't dominate similarity.  
✅ Cosine similarity models — L2-normalising makes dot product = cosine similarity.  
❌ Tabular data where absolute magnitudes matter (e.g., income = 10k vs. 100k) — normalising per-row would destroy that information.

---

## 5.8 PowerTransformer (Scale + Normalise Together)

As covered in Section 4.1, `PowerTransformer` applies a Yeo-Johnson (or Box-Cox) power transformation to make each feature more Gaussian, *and* optionally applies Z-score standardisation afterward. It's a useful one-stop alternative to log-transform + StandardScaler.

```python
from sklearn.preprocessing import PowerTransformer

pt = PowerTransformer(method='yeo-johnson', standardize=True)
X_scaled = pt.fit_transform(X_train)
# After transform: each feature is approximately N(0, 1)
```

---

## 5.9 Head-to-Head Comparison

| Scaler | Formula | Output Range | Outlier Robust? | Preserves Sparsity? | Best Use Case |
|:---|:---|:---:|:---:|:---:|:---|
| `StandardScaler` | $(x - \mu) / \sigma$ | $(-\infty, +\infty)$, centred at 0 | ❌ | ❌ | Normal data, Ridge/Lasso, PCA |
| `MinMaxScaler` | $(x - x_{\min}) / (x_{\max} - x_{\min})$ | $[0, 1]$ | ❌ | ❌ | Neural nets, bounded data |
| `RobustScaler` | $(x - Q_2) / IQR$ | Unbounded, centred at 0 | ✅ | ❌ | Skewed / outlier-heavy data |
| `MaxAbsScaler` | $x / \max(\|x\|)$ | $[-1, 1]$ | ❌ | ✅ | Sparse matrices (NLP) |
| `Normalizer` | $x / \|x\|_p$ (row-wise) | Per-row unit norm | ❌ | ✅ | Text similarity, cosine distance |
| `PowerTransformer` | Yeo-Johnson + Z-score | $\approx N(0,1)$ | Partial | ❌ | Skewed numeric features |

---

## 5.10 The Fit-on-Train Rule & Pipeline Best Practice

The same rule from imputation applies here: **fit the scaler only on training data**, then use those learned statistics to transform both train and test sets.

**Wrong ❌ — data leakage:**
```python
scaler = StandardScaler()
X_scaled = scaler.fit_transform(X)       # learns μ, σ from full dataset (including test!)
X_train, X_test = train_test_split(X_scaled)
```

**Correct ✅:**
```python
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)

scaler = StandardScaler()
X_train_scaled = scaler.fit_transform(X_train)   # learn μ, σ from training data only
X_test_scaled  = scaler.transform(X_test)        # apply training μ, σ to test data
```

**Best practice — use a Pipeline:**
```python
from sklearn.pipeline import Pipeline
from sklearn.preprocessing import StandardScaler
from sklearn.svm import SVC

pipe = Pipeline([
    ('scaler', StandardScaler()),
    ('model',  SVC(kernel='rbf', C=1.0))
])

pipe.fit(X_train, y_train)   # scaler.fit_transform(X_train) → svc.fit(X_train_scaled)
pipe.score(X_test, y_test)   # scaler.transform(X_test) → svc.predict(X_test_scaled)
```

Inside a Pipeline, the `fit_transform` / `transform` split is handled automatically — even inside `cross_val_score` and `GridSearchCV`, which re-fit the entire pipeline on each fold.

---

## 5.11 Verifying Your Scaling

After scaling, always sanity-check:

```python
import pandas as pd
import numpy as np

X_scaled_df = pd.DataFrame(X_train_scaled, columns=feature_names)

# StandardScaler: mean ≈ 0, std ≈ 1 for each column
print(X_scaled_df.mean().round(4))   # should be near 0
print(X_scaled_df.std().round(4))    # should be near 1

# MinMaxScaler: min = 0, max = 1 for each column
print(X_scaled_df.min())    # should be 0
print(X_scaled_df.max())    # should be 1

# Check test set is also in a sensible range (not wildly outside train's range)
X_test_df = pd.DataFrame(X_test_scaled, columns=feature_names)
print("Test set min:", X_test_df.min().min())
print("Test set max:", X_test_df.max().max())
# For MinMaxScaler: test values outside [0, 1] mean test has out-of-distribution samples
```

> [!TIP]
> After MinMaxScaling, test set values outside $[0, 1]$ are a signal of **distribution shift** — the test set has values outside the range seen during training. This is worth investigating before deployment.

---

# 6. Train-Test Split & Cross-Validation

**Intuition:** You build a model to generalise to new, unseen data — not to memorise the data it was trained on. The only way to honestly estimate how well your model generalises is to evaluate it on data it has *never seen during training*. Everything in this section is about enforcing that separation correctly.

---

## 6.1 The Anatomy of a Dataset Split

### Why you need at least two sets
- **Training set** — the data the model learns from (fits its parameters).
- **Test set** — held out entirely until the very end; used *once* to report final performance.

If you evaluate on the training set, you get an optimistically biased score — the model has already memorised those examples.

### Why you often need three sets
When you make decisions based on validation performance (choosing hyperparameters, selecting features, picking between models), those decisions are implicitly *fitted* to the validation set. If you then report the validation score as your final result, it is optimistically biased. You need a third set:

- **Training set** — model fits its parameters.
- **Validation set** — model selection, hyperparameter tuning, early stopping.
- **Test set** — touched *once*, reported as the final honest estimate of generalisation.

```
Data
├── 60% Training set   → fit model weights
├── 20% Validation set → tune hyperparameters, select model
└── 20% Test set       → final evaluation (touch once, at the very end)
```

---

## 6.2 `train_test_split` — The Basics

```python
from sklearn.model_selection import train_test_split

X_train, X_test, y_train, y_test = train_test_split(
    X, y,
    test_size=0.2,       # 20% for test; can be a float (proportion) or int (count)
    random_state=42,     # seed for reproducibility
    stratify=y           # preserve class proportions in each split
)
```

### Choosing `test_size`
- **80/20** — the most common default for medium datasets.
- **70/30** — when you need a larger test set (e.g., imbalanced classes, need more test examples per class).
- **90/10** — for very small datasets where training data is precious.

### `stratify` — Why It Matters for Classification

Without stratification, a random split might put 90% of class-1 samples in training and only 10% in test. The model trains on an unrepresentative distribution, and the test set is too small to give stable estimates.

**With** `stratify=y`, each split preserves the original class proportions:
```python
# Example: 80% class 0, 20% class 1 in full dataset
# Without stratify: train might be 82%/18%, test might be 72%/28% — lucky draw
# With stratify:    train is exactly 80%/20%, test is exactly 80%/20%
```

Always use `stratify=y` for classification problems, especially with imbalanced classes.

### Three-Way Split (Train / Validation / Test)
```python
# Step 1: carve off the test set first (20%)
X_trainval, X_test, y_trainval, y_test = train_test_split(
    X, y, test_size=0.2, random_state=42, stratify=y
)

# Step 2: split the remaining 80% into train (75% of 80% = 60%) and val (25% of 80% = 20%)
X_train, X_val, y_train, y_val = train_test_split(
    X_trainval, y_trainval, test_size=0.25, random_state=42, stratify=y_trainval
)

print(f"Train: {len(X_train)}, Val: {len(X_val)}, Test: {len(X_test)}")
```

> [!IMPORTANT]
> The test set must be set aside **before** you do any EDA, feature selection, or hyperparameter tuning. If any decision you make is informed by test set statistics — even indirectly — your final evaluation is compromised.

---

## 6.3 The Problem with a Single Split

Suppose your dataset has 1,000 samples. A single 80/20 split gives you one specific 200-sample test set. Your performance score on those 200 samples has **high variance** — if a different 200 samples happened to be selected, you'd get a meaningfully different score. This variance is especially large when:
- The dataset is small.
- The class distribution is imbalanced.
- The data has high heterogeneity.

**Solution:** Cross-validation — evaluate multiple times on different held-out subsets and average the results.

---

## 6.4 K-Fold Cross-Validation

**How it works:** Split the data into $k$ equally-sized folds. In each of $k$ rounds, one fold serves as the validation set and the remaining $k-1$ folds form the training set. Average the $k$ scores.

$$\text{CV Score} = \frac{1}{k} \sum_{i=1}^{k} \text{Score}_i \qquad \text{Uncertainty} = \text{std}(\{\text{Score}_i\})$$

```
k = 5:
Fold 1: [VAL] [TRN] [TRN] [TRN] [TRN]  → Score₁
Fold 2: [TRN] [VAL] [TRN] [TRN] [TRN]  → Score₂
Fold 3: [TRN] [TRN] [VAL] [TRN] [TRN]  → Score₃
Fold 4: [TRN] [TRN] [TRN] [VAL] [TRN]  → Score₄
Fold 5: [TRN] [TRN] [TRN] [TRN] [VAL]  → Score₅

Final: mean(Score₁...₅) ± std(Score₁...₅)
```

### Choosing $k$
| $k$ | Trade-off | Typical use |
|:---:|:---|:---|
| 5 | Lower variance than 3-fold; fast | Default for large datasets (> 10k samples) |
| 10 | Less bias than 5-fold; standard in literature | Most common default |
| $n$ (LOO) | Lowest bias; very high variance; very slow | Tiny datasets (< 100 samples) |

**Bias-variance of CV itself:** Small $k$ → each training set is smaller → model sees less data → CV score *underestimates* true generalisation performance (pessimistic bias). Large $k$ → training sets are nearly full → less bias, but more variance in the score estimates.

```python
from sklearn.model_selection import cross_val_score, KFold
from sklearn.ensemble import RandomForestClassifier

model = RandomForestClassifier(n_estimators=100, random_state=42)

# Simple interface
scores = cross_val_score(model, X_train, y_train, cv=5, scoring='f1_weighted', n_jobs=-1)
print(f"CV F1: {scores.mean():.4f} ± {scores.std():.4f}")

# With explicit KFold object (more control)
kf = KFold(n_splits=5, shuffle=True, random_state=42)
scores = cross_val_score(model, X_train, y_train, cv=kf, scoring='roc_auc')
```

---

## 6.5 Stratified K-Fold

Standard `KFold` splits randomly — for imbalanced classification, some folds might end up with very few (or zero!) minority class samples. `StratifiedKFold` guarantees that each fold has the same class proportion as the full dataset.

```python
from sklearn.model_selection import StratifiedKFold, cross_val_score

skf = StratifiedKFold(n_splits=5, shuffle=True, random_state=42)

scores = cross_val_score(model, X_train, y_train, cv=skf, scoring='f1_weighted')
print(f"Stratified CV F1: {scores.mean():.4f} ± {scores.std():.4f}")
```

> [!IMPORTANT]
> **Always use `StratifiedKFold` for classification tasks**, especially when classes are imbalanced. Standard `KFold` is appropriate only for regression (where there is no class to stratify on).

---

## 6.6 Repeated K-Fold

Run K-Fold CV multiple times with different random splits and average all results. Reduces the variance of the CV estimate itself.

```python
from sklearn.model_selection import RepeatedStratifiedKFold, RepeatedKFold

# For classification
rskf = RepeatedStratifiedKFold(n_splits=5, n_repeats=10, random_state=42)
# Runs 5-fold CV 10 times → 50 total evaluations

scores = cross_val_score(model, X_train, y_train, cv=rskf, scoring='f1_weighted')
print(f"Repeated CV F1: {scores.mean():.4f} ± {scores.std():.4f}")
```

**When to use:** When you need a high-confidence estimate of model performance, and computation time permits (50+ model fits). Common in research papers comparing models.

---

## 6.7 Leave-One-Out CV (LOO-CV)

$k = n$: each sample is its own validation set. The model is trained on all $n-1$ remaining samples. Repeat $n$ times.

$$\text{LOO estimate} = \frac{1}{n} \sum_{i=1}^{n} \mathcal{L}(y_i, \hat{y}_{-i})$$

where $\hat{y}_{-i}$ is the prediction for sample $i$ from the model trained without sample $i$.

```python
from sklearn.model_selection import LeaveOneOut, cross_val_score

loo = LeaveOneOut()
scores = cross_val_score(model, X_train, y_train, cv=loo, scoring='accuracy')
print(f"LOO accuracy: {scores.mean():.4f}")
# scores has n entries, each 0 or 1 (correct/incorrect on that one test sample)
```

**Pros:** Uses all available data for training in each fold — maximum training data.  
**Cons:** $O(n)$ model fits — extremely slow for large datasets. Also, each training set differs by only one sample, making the $n$ scores highly correlated → the variance estimate (std) is unreliable.  
**Use when:** Dataset has < 100 samples.

---

## 6.8 ShuffleSplit & StratifiedShuffleSplit

Instead of non-overlapping folds, `ShuffleSplit` randomly samples a test set of fixed size on each iteration. Splits can overlap across iterations — it's a Monte Carlo approach.

```python
from sklearn.model_selection import ShuffleSplit, StratifiedShuffleSplit

ss = ShuffleSplit(n_splits=10, test_size=0.2, random_state=42)
# 10 independent random 80/20 splits

sss = StratifiedShuffleSplit(n_splits=10, test_size=0.2, random_state=42)
# Same but stratified — use this for classification

scores = cross_val_score(model, X_train, y_train, cv=sss, scoring='f1_weighted')
```

**When to use:** Large datasets where standard K-Fold is too slow; when you want a specific train/test size ratio that doesn't divide cleanly into $k$ folds.

---

## 6.9 GroupKFold — When Samples Are Not Independent

Standard K-Fold assumes samples are i.i.d. (independent and identically distributed). This breaks when:
- Multiple rows come from the same patient (medical data).
- Multiple transactions from the same user (financial data).
- Multiple frames from the same video.

If the same patient's data appears in both train and test, the model can memorise that patient's patterns — producing an optimistically biased score that won't generalise to new patients.

**Fix:** `GroupKFold` ensures no group appears in both train and test in any fold.

```python
from sklearn.model_selection import GroupKFold, cross_val_score
import numpy as np

groups = df['patient_id'].values   # group identifier for each row

gkf = GroupKFold(n_splits=5)
scores = cross_val_score(model, X_train, y_train, cv=gkf, groups=groups, scoring='roc_auc')
print(f"Group-aware CV AUC: {scores.mean():.4f}")
```

---

## 6.10 TimeSeriesSplit — For Sequential / Time-Series Data

Standard K-Fold shuffles the data randomly. For time-series data, **future data must never be used to predict the past**. `TimeSeriesSplit` uses only past observations for training and future observations for validation — always in forward order.

```
Split 1: [TRN: 1–200]  → [VAL: 201–250]
Split 2: [TRN: 1–450]  → [VAL: 451–500]
Split 3: [TRN: 1–700]  → [VAL: 701–750]
Split 4: [TRN: 1–950]  → [VAL: 951–1000]
```

```python
from sklearn.model_selection import TimeSeriesSplit, cross_val_score

tss = TimeSeriesSplit(n_splits=5, gap=0)
# gap: number of samples to skip between train and test (prevents look-ahead leakage)

scores = cross_val_score(model, X_train, y_train, cv=tss, scoring='neg_mean_squared_error')
rmse_scores = np.sqrt(-scores)
print(f"Time Series CV RMSE: {rmse_scores.mean():.4f}")
```

> [!WARNING]
> Never use standard `KFold` or `StratifiedKFold` on time-series data. Randomly shuffling allows the model to "see the future" during training — a form of data leakage that will produce impossibly good CV scores that fail completely in production.

---

## 6.11 `cross_validate` — Getting Multiple Metrics at Once

`cross_val_score` returns one score per fold for one metric. `cross_validate` returns multiple metrics and also gives train scores (useful for diagnosing overfitting).

```python
from sklearn.model_selection import cross_validate

results = cross_validate(
    model, X_train, y_train,
    cv=5,
    scoring=['accuracy', 'f1_weighted', 'roc_auc'],
    return_train_score=True,   # also compute score on training fold
    n_jobs=-1
)

print(f"Val  Accuracy: {results['test_accuracy'].mean():.4f}")
print(f"Val  F1:       {results['test_f1_weighted'].mean():.4f}")
print(f"Val  AUC:      {results['test_roc_auc'].mean():.4f}")

# Diagnose overfitting
print(f"Train Accuracy: {results['train_accuracy'].mean():.4f}")
print(f"Val   Accuracy: {results['test_accuracy'].mean():.4f}")
# If train >> val → overfitting
```

---

## 6.12 `cross_val_predict` — Out-of-Fold Predictions

Returns the prediction for each sample made when that sample was in the **validation fold** — i.e., every sample gets a prediction from a model that hasn't seen it. Useful for:
- Building a confusion matrix or ROC curve that uses the whole training set.
- Generating meta-features for stacking.

```python
from sklearn.model_selection import cross_val_predict
from sklearn.metrics import confusion_matrix, classification_report

y_pred_oof   = cross_val_predict(model, X_train, y_train, cv=5, method='predict')
y_proba_oof  = cross_val_predict(model, X_train, y_train, cv=5, method='predict_proba')

# Confusion matrix on the full training set, out-of-fold
print(confusion_matrix(y_train, y_pred_oof))
print(classification_report(y_train, y_pred_oof))
```

> [!NOTE]
> `cross_val_predict` is **not** the same as training one model and predicting. Each sample is predicted by a model that never saw it — this gives a more honest estimate of predictions on unseen data. Do not use these predictions to compute a final performance number and report it as test performance — use a real held-out test set for that.

---

## 6.13 CV Inside a Pipeline — Preventing Leakage

The most critical rule: **all preprocessing steps (imputation, scaling, encoding) must be re-fitted from scratch on each training fold** — they must never see the validation fold's data. The correct way to enforce this is to put preprocessing inside a `Pipeline` and pass the pipeline to `cross_val_score`.

**Wrong ❌ — leakage across folds:**
```python
# Scaling the entire training set BEFORE cross_val_score
scaler = StandardScaler()
X_scaled = scaler.fit_transform(X_train)   # scaler sees all of X_train, including fold val sets

scores = cross_val_score(model, X_scaled, y_train, cv=5)
# The validation fold's statistics contaminated the scaler — leakage!
```

**Correct ✅ — Pipeline handles it automatically:**
```python
from sklearn.pipeline import Pipeline
from sklearn.preprocessing import StandardScaler
from sklearn.svm import SVC
from sklearn.model_selection import cross_val_score

pipe = Pipeline([
    ('scaler', StandardScaler()),
    ('model',  SVC(kernel='rbf'))
])

# cross_val_score re-fits the entire pipeline (including scaler) on each training fold
scores = cross_val_score(pipe, X_train, y_train, cv=5, scoring='f1_weighted')
print(f"CV F1: {scores.mean():.4f} ± {scores.std():.4f}")
```

In each of the 5 folds:
1. `StandardScaler` is **fit** on the 4 training folds → computes their mean and std.
2. `StandardScaler` **transforms** the 4 training folds using those statistics.
3. `StandardScaler` **transforms** the validation fold using the *same* statistics (not the validation fold's own mean/std).
4. `SVC` is fit on the scaled training folds and evaluated on the scaled validation fold.

---

## 6.14 CV Strategy Decision Guide

| Situation | Recommended CV Strategy |
|:---|:---|
| Large tabular dataset, classification | `StratifiedKFold(n_splits=5)` |
| Large tabular dataset, regression | `KFold(n_splits=5, shuffle=True)` |
| Imbalanced classes | `StratifiedKFold` or `StratifiedShuffleSplit` |
| Small dataset (< 200 samples) | `LeaveOneOut` or `RepeatedStratifiedKFold` |
| Non-independent samples (patients, users) | `GroupKFold` |
| Time-series / sequential data | `TimeSeriesSplit` |
| Need precise split ratio, large data | `ShuffleSplit` / `StratifiedShuffleSplit` |
| Research comparison, need stable estimate | `RepeatedStratifiedKFold(n_splits=10, n_repeats=10)` |

---

# 7. Hyperparameter Tuning

**Intuition:** A model has two kinds of parameters. **Parameters** (weights, biases, split thresholds) are learned from data during training. **Hyperparameters** (learning rate, regularisation strength, tree depth, number of neighbours) control how the training process runs — they are set *before* training and cannot be learned from the data directly. Hyperparameter tuning is the process of finding the best values for them.

---

## 7.1 Parameters vs. Hyperparameters

| Type | Examples | How set |
|:---|:---|:---|
| **Parameters** | Linear regression weights $\mathbf{w}$, SVM support vectors, tree split thresholds | Learned by the optimisation algorithm during `fit()` |
| **Hyperparameters** | `C` in SVM, `max_depth` in trees, `n_neighbors` in KNN, `alpha` in Ridge | Set by you before `fit()`; tuned via search |

---

## 7.2 Grid Search CV (`GridSearchCV`)

**How it works:** You define a grid of discrete values for each hyperparameter. `GridSearchCV` evaluates every possible combination using cross-validation, and returns the combination with the best mean CV score.

$$\text{Total fits} = \left(\prod_i |\text{values}_i|\right) \times k_{\text{folds}}$$

```python
from sklearn.model_selection import GridSearchCV
from sklearn.svm import SVC

param_grid = {
    'C':      [0.01, 0.1, 1, 10, 100],
    'kernel': ['linear', 'rbf', 'poly'],
    'gamma':  ['scale', 'auto', 0.001, 0.01]  # only relevant for rbf/poly
}
# Total combos: 5 × 3 × 4 = 60; with 5-fold CV → 300 training runs

gs = GridSearchCV(
    estimator=SVC(),
    param_grid=param_grid,
    cv=5,                   # StratifiedKFold by default for classifiers
    scoring='f1_weighted',  # optimise this metric
    n_jobs=-1,              # use all CPU cores
    refit=True,             # after search, refit the best model on the full X_train
    verbose=2,              # print progress
    return_train_score=True # include train scores in results_
)

gs.fit(X_train, y_train)

print(f"Best params:     {gs.best_params_}")
print(f"Best CV score:   {gs.best_score_:.4f}")

# The best model is already re-fitted on all of X_train (because refit=True)
best_model = gs.best_estimator_
print(f"Test score: {best_model.score(X_test, y_test):.4f}")

# Full results table
import pandas as pd
results_df = pd.DataFrame(gs.cv_results_).sort_values('rank_test_score')
print(results_df[['params', 'mean_test_score', 'std_test_score', 'rank_test_score']].head(10))
```

### GridSearchCV with a Pipeline
When tuning a Pipeline, prefix parameter names with the step name + `__` (double underscore):

```python
from sklearn.pipeline import Pipeline
from sklearn.preprocessing import StandardScaler
from sklearn.svm import SVC

pipe = Pipeline([
    ('scaler', StandardScaler()),
    ('model',  SVC())
])

param_grid = {
    'model__C':      [0.1, 1, 10],
    'model__kernel': ['linear', 'rbf'],
    # 'scaler__with_std': [True, False]  # you can even tune preprocessing steps
}

gs = GridSearchCV(pipe, param_grid, cv=5, scoring='f1_weighted', n_jobs=-1)
gs.fit(X_train, y_train)
```

**Pros:** Guaranteed to find the global best within the grid.  
**Cons:** Combinatorial explosion — if you have 5 hyperparameters each with 4 values: $4^5 = 1024$ combinations × 5-fold CV = 5,120 training runs.

---

## 7.3 Randomised Search CV (`RandomizedSearchCV`)

Instead of trying every combination, `RandomizedSearchCV` samples `n_iter` random combinations from the hyperparameter distributions. This allows:
- **Continuous distributions** instead of discrete lists — you can search the real line.
- **Much faster** — 50 iterations cover more of the space than a grid with 50 points (because dimensions are explored independently).

```python
from sklearn.model_selection import RandomizedSearchCV
from sklearn.ensemble import RandomForestClassifier
from scipy.stats import randint, uniform, loguniform

param_dist = {
    'n_estimators':      randint(50, 500),       # uniform integer in [50, 500)
    'max_depth':         randint(3, 20),
    'min_samples_split': randint(2, 20),
    'min_samples_leaf':  randint(1, 10),
    'max_features':      uniform(0.1, 0.9),      # uniform float in [0.1, 1.0)
    'bootstrap':         [True, False]
}

rs = RandomizedSearchCV(
    estimator=RandomForestClassifier(random_state=42),
    param_distributions=param_dist,
    n_iter=100,             # number of random combinations to try
    cv=5,
    scoring='roc_auc',
    n_jobs=-1,
    random_state=42,
    refit=True
)

rs.fit(X_train, y_train)
print(f"Best params: {rs.best_params_}")
print(f"Best AUC:    {rs.best_score_:.4f}")
```

### `loguniform` — The Right Distribution for Scale Parameters
Hyperparameters like learning rate (`eta`) and regularisation strength (`C`, `alpha`) span orders of magnitude. Sampling uniformly in $[0.001, 1000]$ would almost always pick values > 1. Use `loguniform` to sample uniformly on a log scale:

```python
from scipy.stats import loguniform

param_dist = {
    'C':     loguniform(1e-3, 1e3),   # samples: 0.001, 0.01, 0.1, 1, 10, 100, 1000
    'gamma': loguniform(1e-4, 1e0),
}
```

**Rule of thumb:** Randomised search with 50–100 iterations almost always finds a result comparable to exhaustive grid search, in a fraction of the time.

---

## 7.4 Successive Halving (`HalvingGridSearchCV`)

A faster alternative that uses a **tournament bracket** approach. All candidates start with a small budget (few training samples). The weakest are eliminated, survivors get more data, repeat until one winner remains.

```python
from sklearn.experimental import enable_halving_search_cv
from sklearn.model_selection import HalvingGridSearchCV, HalvingRandomSearchCV

hs = HalvingGridSearchCV(
    estimator=RandomForestClassifier(),
    param_grid=param_grid,
    factor=3,           # at each round, keep top 1/3 of candidates
    resource='n_samples',  # the resource to increase each round
    cv=5,
    scoring='f1_weighted',
    n_jobs=-1
)
hs.fit(X_train, y_train)
```

**When to use:** Large datasets with many hyperparameter combinations — it's significantly faster than `GridSearchCV` with minimal loss in quality.

---

## 7.5 The Bias-Variance Tradeoff

Every hyperparameter tuning decision is fundamentally a bias-variance tradeoff:

| Model | High Bias (Underfitting) | High Variance (Overfitting) |
|:---|:---|:---|
| Decision Tree | `max_depth` too small | `max_depth` too large |
| Random Forest | `n_estimators` too small | `min_samples_leaf` too small |
| SVM | `C` too small | `C` too large |
| Ridge/Lasso | `alpha` too large | `alpha` too small |
| KNN | `n_neighbors` too large | `n_neighbors` too small |
| Neural Network | Too few layers/neurons | Too many layers, no dropout |

### Diagnosing from Train vs. Validation Score

```
Train Error:  High  |  Val Error: High  → Underfitting (high bias)
Train Error:  Low   |  Val Error: High  → Overfitting (high variance)
Train Error:  Low   |  Val Error: Low   → Good fit ✅
Train Error:  High  |  Val Error: Low   → Impossible (data bug)
```

```python
from sklearn.model_selection import cross_validate
import numpy as np

results = cross_validate(model, X_train, y_train, cv=5,
                         scoring='neg_mean_squared_error',
                         return_train_score=True)

train_rmse = np.sqrt(-results['train_score'])
val_rmse   = np.sqrt(-results['test_score'])
print(f"Train RMSE: {train_rmse.mean():.4f} ± {train_rmse.std():.4f}")
print(f"Val   RMSE: {val_rmse.mean():.4f} ± {val_rmse.std():.4f}")
```

---

## 7.6 Learning Curves & Validation Curves

### Learning Curve — Diagnoses Bias vs. Variance
Plots model performance vs. training set size. Tells you whether adding more data will help.

```python
from sklearn.model_selection import learning_curve
import matplotlib.pyplot as plt
import numpy as np

train_sizes, train_scores, val_scores = learning_curve(
    estimator=model,
    X=X_train, y=y_train,
    cv=5,
    train_sizes=np.linspace(0.1, 1.0, 10),  # 10%, 20%, ..., 100% of training data
    scoring='f1_weighted',
    n_jobs=-1
)

train_mean = train_scores.mean(axis=1)
val_mean   = val_scores.mean(axis=1)
train_std  = train_scores.std(axis=1)
val_std    = val_scores.std(axis=1)

plt.figure(figsize=(8, 5))
plt.plot(train_sizes, train_mean, 'o-', label='Train score')
plt.fill_between(train_sizes, train_mean - train_std, train_mean + train_std, alpha=0.2)
plt.plot(train_sizes, val_mean, 's-', label='Val score')
plt.fill_between(train_sizes, val_mean - val_std, val_mean + val_std, alpha=0.2)
plt.xlabel('Training set size'); plt.ylabel('Score')
plt.title('Learning Curve'); plt.legend()
```

**Reading a learning curve:**
- Train ≈ Val, both low → high bias; more data won't help; use a more complex model.
- Train >> Val → high variance; more data *will* help; or regularise.
- Train ≈ Val, both high → good fit; more data would help marginally.

### Validation Curve — Diagnoses a Single Hyperparameter
Plots performance vs. a hyperparameter value. Reveals the sweet spot between under- and overfitting.

```python
from sklearn.model_selection import validation_curve

param_range = [1, 2, 4, 6, 8, 10, 15, 20, 30]
train_scores, val_scores = validation_curve(
    estimator=model,
    X=X_train, y=y_train,
    param_name='max_depth',   # hyperparameter name
    param_range=param_range,
    cv=5,
    scoring='f1_weighted',
    n_jobs=-1
)

plt.figure(figsize=(8, 5))
plt.plot(param_range, train_scores.mean(axis=1), 'o-', label='Train')
plt.plot(param_range, val_scores.mean(axis=1), 's-', label='Val')
plt.xlabel('max_depth'); plt.ylabel('F1'); plt.title('Validation Curve')
plt.legend()
# Peak of the val curve is the optimal max_depth
```

---

## 7.7 Tuning Best Practices

1. **Start broad, then narrow.** First `RandomizedSearchCV` over a wide range to identify promising regions, then `GridSearchCV` for fine-tuning within that region.
2. **Use log-scale for scale-sensitive hyperparameters** (`C`, `alpha`, `learning_rate`).
3. **Always use a Pipeline** so preprocessing is re-fitted per fold — no leakage.
4. **Don't tune on the test set.** All tuning decisions use CV on training data only.
5. **Report CV score ± std, not just the mean.** A model with CV score 0.85 ± 0.01 is more reliable than one with 0.87 ± 0.06.
6. **Use `refit=True`** (default) so the best model is automatically refitted on the full training set after search.

---

# 8. Evaluation Metrics — Regression

**Intuition:** After training a regression model, you need a single number that summarises "how wrong are the predictions?" Different metrics penalise different types of errors — choosing the right one depends on your domain and what kinds of errors are most costly.

---

## 8.1 Mean Absolute Error (MAE)

$$\boxed{MAE = \frac{1}{n} \sum_{i=1}^{n} |y_i - \hat{y}_i|}$$

- **Interpretation:** The average magnitude of errors, in the same units as $y$. If MAE = 5 for house price prediction in lakhs, the average prediction is off by ₹5 lakh.
- **Robust to outliers** — because errors are not squared, one very large error doesn't dominate the metric.
- **Gradient is constant** (= ±1) — so the optimal prediction for MAE is the **median** of $y$, not the mean. This also means gradient descent using MAE loss doesn't slow down near the minimum.

```python
from sklearn.metrics import mean_absolute_error
mae = mean_absolute_error(y_test, y_pred)
print(f"MAE: {mae:.4f}")
```

**When to use:** When all errors are roughly equally important and you don't want large outliers to dominate your metric (e.g., demand forecasting, sales prediction).

---

## 8.2 Mean Squared Error (MSE)

$$\boxed{MSE = \frac{1}{n} \sum_{i=1}^{n} (y_i - \hat{y}_i)^2}$$

- **Penalises large errors quadratically** — an error of 10 contributes 100× more than an error of 1. This means MSE is very sensitive to outliers.
- **Units are squared** — MSE for a house price model is in "lakh²", which is hard to interpret directly.
- The optimal prediction for MSE is the **mean** of $y$ — MSE is minimised by the conditional mean $E[y | \mathbf{x}]$.
- **Differentiable everywhere** — gradient is smooth, making it the most common loss function for gradient-based optimisation (linear regression, neural networks).

```python
from sklearn.metrics import mean_squared_error
mse = mean_squared_error(y_test, y_pred)
print(f"MSE: {mse:.4f}")
```

**When to use:** As a training loss function; when large errors are genuinely much worse than small ones (e.g., structural safety prediction where a big miss is catastrophic).

---

## 8.3 Root Mean Squared Error (RMSE)

$$\boxed{RMSE = \sqrt{MSE} = \sqrt{\frac{1}{n} \sum_{i=1}^{n} (y_i - \hat{y}_i)^2}}$$

- **Same units as $y$** — restores interpretability lost from squaring.
- Still dominated by large errors (because it's derived from MSE).
- The most commonly reported regression metric in practice.

```python
import numpy as np
rmse = np.sqrt(mean_squared_error(y_test, y_pred))
# or directly:
rmse = mean_squared_error(y_test, y_pred, squared=False)
print(f"RMSE: {rmse:.4f}")
```

### MAE vs. RMSE — Choosing Between Them

| | MAE | RMSE |
|:---|:---|:---|
| Outlier sensitivity | Low (linear) | High (quadratic) |
| Interpretability | High (same units as $y$) | High (same units as $y$) |
| Optimal predictor | Median | Mean |
| Gradient | Constant ±1 | Smooth, proportional to error |
| Prefer when | Outliers exist; all errors matter equally | Large errors are disproportionately bad |

---

## 8.4 Mean Absolute Percentage Error (MAPE)

$$\boxed{MAPE = \frac{100\%}{n} \sum_{i=1}^{n} \left|\frac{y_i - \hat{y}_i}{y_i}\right|}$$

- **Scale-independent** — expressed as a percentage, making it easy to compare across datasets with different scales.
- **Undefined when $y_i = 0$** — division by zero; also heavily penalises cases where $y_i$ is very small.
- Asymmetric — over-predictions and under-predictions are not penalised equally.

```python
from sklearn.metrics import mean_absolute_percentage_error
mape = mean_absolute_percentage_error(y_test, y_pred) * 100
print(f"MAPE: {mape:.2f}%")
```

---

## 8.5 R-Squared ($R^2$, Coefficient of Determination)

$$\boxed{R^2 = 1 - \frac{RSS}{TSS} = 1 - \frac{\sum_{i=1}^n (y_i - \hat{y}_i)^2}{\sum_{i=1}^n (y_i - \bar{y})^2}}$$

where $RSS$ = Residual Sum of Squares (model's total error), $TSS$ = Total Sum of Squares (variance of $y$ around its mean).

- **Interpretation:** The proportion of variance in $y$ explained by the model. $R^2 = 0.85$ means the model explains 85% of the variance.
- **Range:** $(-\infty, 1]$.
  - $R^2 = 1$: Perfect predictions.
  - $R^2 = 0$: Model is no better than always predicting $\bar{y}$.
  - $R^2 < 0$: Model is *worse* than the naive mean predictor — a red flag.
- **Never decreases** as you add more features (even noise features) — this is a flaw.

```python
from sklearn.metrics import r2_score
r2 = r2_score(y_test, y_pred)
print(f"R²: {r2:.4f}")
```

---

## 8.6 Adjusted R-Squared

$$\boxed{\text{Adj } R^2 = 1 - (1 - R^2) \cdot \frac{n - 1}{n - p - 1}}$$

where $n$ = number of samples, $p$ = number of features (predictors).

- **Penalises the addition of uninformative features** — if you add a noise feature, $R^2$ stays flat or increases, but Adjusted $R^2$ decreases.
- **Can decrease** when adding a feature that doesn't improve the model enough to justify its inclusion.
- Use for **feature selection** and **model comparison** across models with different numbers of features.

```python
n = len(y_test)
p = X_test.shape[1]
adj_r2 = 1 - (1 - r2) * (n - 1) / (n - p - 1)
print(f"Adjusted R²: {adj_r2:.4f}")
```

---

## 8.7 Regression Metrics — When to Use What

| Metric | Use when |
|:---|:---|
| **MAE** | Outliers exist; want interpretable average error; median is the right baseline |
| **RMSE** | Large errors are disproportionately costly; want gradient-friendly metric |
| **MAPE** | Errors should be expressed as relative %; comparing across datasets |
| **R²** | Want to know how much variance is explained; evaluating goodness of fit |
| **Adjusted R²** | Comparing models with different numbers of features |

```python
# One-liner: print all regression metrics
from sklearn.metrics import mean_absolute_error, mean_squared_error, r2_score
import numpy as np

def regression_report(y_true, y_pred, n_features):
    n = len(y_true)
    r2 = r2_score(y_true, y_pred)
    adj_r2 = 1 - (1 - r2) * (n - 1) / (n - n_features - 1)
    print(f"MAE:         {mean_absolute_error(y_true, y_pred):.4f}")
    print(f"MSE:         {mean_squared_error(y_true, y_pred):.4f}")
    print(f"RMSE:        {np.sqrt(mean_squared_error(y_true, y_pred)):.4f}")
    print(f"R²:          {r2:.4f}")
    print(f"Adjusted R²: {adj_r2:.4f}")

regression_report(y_test, y_pred, n_features=X_test.shape[1])
```

---

# 9. Evaluation Metrics — Classification

**Intuition:** Accuracy is not enough. On a dataset with 99% negative samples, a model that always predicts "negative" achieves 99% accuracy and is completely useless. You need metrics that separately measure different types of correctness.

---

## 9.1 The Confusion Matrix

The confusion matrix is the foundation of all classification metrics. It breaks down predictions into four categories based on the actual and predicted classes.

|  | **Predicted: Positive** | **Predicted: Negative** |
|:---|:---:|:---:|
| **Actual: Positive** | **TP** (True Positive) | **FN** (False Negative) |
| **Actual: Negative** | **FP** (False Positive) | **TN** (True Negative) |

- **TP** — Correctly predicted Positive. The model said yes, it was yes.
- **TN** — Correctly predicted Negative. The model said no, it was no.
- **FP** — **Type I Error** (False Alarm). The model said yes, it was actually no. (e.g., flagging a healthy patient as sick)
- **FN** — **Type II Error** (Miss). The model said no, it was actually yes. (e.g., missing a cancerous tumour)

```python
from sklearn.metrics import confusion_matrix, ConfusionMatrixDisplay
import matplotlib.pyplot as plt

cm = confusion_matrix(y_test, y_pred)
print(cm)

# Visualise
disp = ConfusionMatrixDisplay(confusion_matrix=cm, display_labels=['Negative', 'Positive'])
disp.plot(cmap='Blues')
plt.title('Confusion Matrix')
plt.show()

# Normalised version (show proportions instead of counts)
cm_normalised = confusion_matrix(y_test, y_pred, normalize='true')
# normalize='true': normalise by row (actual class)
# normalize='pred': normalise by column (predicted class)
# normalize='all':  normalise by total samples
```

---

## 9.2 Accuracy

$$\boxed{\text{Accuracy} = \frac{TP + TN}{TP + FP + FN + TN}}$$

The proportion of all predictions that are correct.

**The imbalance problem:** On a dataset with 950 negatives and 50 positives (95% negative), a model that blindly predicts "Negative" for everything achieves:

$$\text{Accuracy} = \frac{0 + 950}{0 + 0 + 50 + 950} = 95\%$$

This model is completely useless — it never predicts the positive class. Accuracy gave you a 95% score and told you nothing.

```python
from sklearn.metrics import accuracy_score
print(f"Accuracy: {accuracy_score(y_test, y_pred):.4f}")
```

**When to use:** Only when classes are balanced and misclassification costs are equal. Almost never the right primary metric for real-world problems.

---

## 9.3 Precision

$$\boxed{\text{Precision} = \frac{TP}{TP + FP}}$$

**"Of all the samples I predicted as Positive, what fraction were actually Positive?"**

Precision measures the cost of **false positives**. A high-precision model rarely sounds a false alarm.

**Mnemonic:** Precision = how *precise* your positive calls are. When you predict positive, you're usually right.

```python
from sklearn.metrics import precision_score
print(f"Precision: {precision_score(y_test, y_pred):.4f}")
```

**Use when FP is costly:**
- Email spam filter — a FP (legitimate email flagged as spam) is very bad; user misses important mail.
- Legal system — wrongly convicting an innocent person (FP).
- Search engine — showing irrelevant results (FP) frustrates users.

---

## 9.4 Recall (Sensitivity, True Positive Rate)

$$\boxed{\text{Recall} = \frac{TP}{TP + FN}}$$

**"Of all the samples that actually are Positive, what fraction did I catch?"**

Recall measures the cost of **false negatives**. A high-recall model misses few positive cases.

**Mnemonic:** Recall = how many positives you *recall* (retrieve). Of all the positives out there, how many did you find?

```python
from sklearn.metrics import recall_score
print(f"Recall: {recall_score(y_test, y_pred):.4f}")
```

**Use when FN is costly:**
- Cancer screening — a FN (missed tumour) means the patient goes untreated.
- Fraud detection — a FN (missed fraud) means financial loss.
- Earthquake early warning — a FN (missed earthquake) is catastrophic.

---

## 9.5 Specificity (True Negative Rate)

$$\boxed{\text{Specificity} = \frac{TN}{TN + FP} = 1 - FPR}$$

**"Of all the actual Negatives, what fraction did I correctly identify as Negative?"**

Specificity is the complement of the False Positive Rate (FPR). It's analogous to Recall but for the negative class.

```python
from sklearn.metrics import confusion_matrix
tn, fp, fn, tp = confusion_matrix(y_test, y_pred).ravel()
specificity = tn / (tn + fp)
print(f"Specificity: {specificity:.4f}")
```

**Sensitivity (Recall) vs. Specificity:**
- Sensitivity = catching the sick patients (TP rate for Positives).
- Specificity = correctly clearing the healthy patients (TN rate for Negatives).
- In medical testing, you often want both high sensitivity AND high specificity, but there's a tradeoff.

---

## 9.6 F-β Score

The F-score is the **harmonic mean** of Precision and Recall, with $\beta$ controlling the relative importance.

$$\boxed{F_\beta = (1 + \beta^2) \cdot \frac{\text{Precision} \cdot \text{Recall}}{\beta^2 \cdot \text{Precision} + \text{Recall}}}$$

**Why harmonic mean?** Unlike the arithmetic mean, the harmonic mean is low when *either* component is low. A model with Precision = 1.0 and Recall = 0.01 should not score 0.505 — its harmonic mean is just 0.02. The harmonic mean correctly penalises imbalance between P and R.

### F1 Score ($\beta = 1$) — Equal weight
$$F_1 = 2 \cdot \frac{\text{Precision} \cdot \text{Recall}}{\text{Precision} + \text{Recall}}$$

```python
from sklearn.metrics import f1_score
print(f"F1: {f1_score(y_test, y_pred):.4f}")
```

### F2 Score ($\beta = 2$) — Recall matters twice as much
Use when missing a positive is worse than a false alarm (medical, fraud, safety).

$$F_2 = 5 \cdot \frac{\text{Precision} \cdot \text{Recall}}{4 \cdot \text{Precision} + \text{Recall}}$$

### F0.5 Score ($\beta = 0.5$) — Precision matters twice as much
Use when false alarms are worse than misses (spam filter, recommendation system).

```python
from sklearn.metrics import fbeta_score
f2  = fbeta_score(y_test, y_pred, beta=2)
f05 = fbeta_score(y_test, y_pred, beta=0.5)
```

---

## 9.7 Multiclass Averaging

For problems with $> 2$ classes, metrics like Precision, Recall, and F1 are computed per class and then aggregated:

| Averaging | How | When to use |
|:---|:---|:---|
| **Macro** | Unweighted mean across all classes: $\frac{1}{K}\sum_k \text{metric}_k$ | All classes are equally important, even rare ones |
| **Micro** | Pool all TP, FP, FN globally, then compute: $\frac{\sum TP}{\sum TP + \sum FP}$ | Class imbalance exists; overall correctness matters |
| **Weighted** | Weighted mean by class support (number of true instances): $\frac{\sum n_k \cdot \text{metric}_k}{n}$ | Class imbalance; want to account for class frequency |

```python
from sklearn.metrics import precision_score, recall_score, f1_score

print(f"Macro  F1: {f1_score(y_test, y_pred, average='macro'):.4f}")
print(f"Micro  F1: {f1_score(y_test, y_pred, average='micro'):.4f}")
print(f"Weighted F1: {f1_score(y_test, y_pred, average='weighted'):.4f}")

# Full report — the best way to see all metrics at once
from sklearn.metrics import classification_report
print(classification_report(y_test, y_pred, target_names=['Class 0', 'Class 1', 'Class 2']))
```

---

## 9.8 Matthews Correlation Coefficient (MCC)

A single metric that captures all four cells of the confusion matrix, symmetric with respect to both classes. Particularly useful for **binary classification with imbalanced classes**.

$$\boxed{MCC = \frac{TP \cdot TN - FP \cdot FN}{\sqrt{(TP+FP)(TP+FN)(TN+FP)(TN+FN)}}}$$

- $MCC = +1$: Perfect prediction.
- $MCC = 0$: No better than random.
- $MCC = -1$: Perfect inverse prediction.

```python
from sklearn.metrics import matthews_corrcoef
print(f"MCC: {matthews_corrcoef(y_test, y_pred):.4f}")
```

**Why MCC > Accuracy/F1 for imbalanced data:** MCC uses all four cells of the confusion matrix. It will be high only if the model performs well on *both* classes — you can't fool it by always predicting the majority class.

---

## 9.9 Cohen's Kappa

Measures agreement between predictions and ground truth, **corrected for chance agreement**:

$$\boxed{\kappa = \frac{p_o - p_e}{1 - p_e}}$$

where $p_o$ = observed accuracy, $p_e$ = expected accuracy a random classifier would achieve.

| $\kappa$ | Interpretation |
|:---:|:---|
| $< 0$ | Less agreement than chance |
| $0.0–0.2$ | Slight |
| $0.2–0.4$ | Fair |
| $0.4–0.6$ | Moderate |
| $0.6–0.8$ | Substantial |
| $0.8–1.0$ | Almost perfect |

```python
from sklearn.metrics import cohen_kappa_score
print(f"Cohen's κ: {cohen_kappa_score(y_test, y_pred):.4f}")
```

---

## 9.10 ROC-AUC Curve

### What it is
The **Receiver Operating Characteristic (ROC)** curve plots the **True Positive Rate (Recall/Sensitivity)** against the **False Positive Rate (1 - Specificity)** at every possible classification threshold $t \in [0, 1]$.

$$TPR(t) = \frac{TP(t)}{TP(t) + FN(t)} \qquad FPR(t) = \frac{FP(t)}{FP(t) + TN(t)}$$

At $t = 0$: every sample predicted Positive → TPR = 1, FPR = 1 (top-right corner).  
At $t = 1$: no sample predicted Positive → TPR = 0, FPR = 0 (bottom-left corner).  
As $t$ decreases from 1 to 0, the operating point traces a curve from bottom-left to top-right.

### AUC — Area Under the Curve
AUC is the area under the ROC curve.

| AUC | Interpretation |
|:---:|:---|
| 1.0 | Perfect model — can perfectly rank all positives above all negatives |
| 0.5 | Random classifier — the diagonal line |
| < 0.5 | Model is inversely predicting (flip all predictions to get a model with AUC > 0.5) |

**Probabilistic interpretation:** AUC = the probability that a randomly selected positive sample gets a **higher model score** than a randomly selected negative sample. An AUC of 0.85 means: if you pick a random positive and a random negative, there's an 85% chance the model ranks the positive higher.

**Key property: threshold-independent.** AUC evaluates the model's *ranking* ability across all thresholds, not at any specific threshold. This makes it useful for comparing models independent of the operating point.

```python
from sklearn.metrics import roc_auc_score, roc_curve
import matplotlib.pyplot as plt

# Requires probability scores, not hard predictions
y_proba = model.predict_proba(X_test)[:, 1]   # probability of positive class

fpr, tpr, thresholds = roc_curve(y_test, y_proba)
auc = roc_auc_score(y_test, y_proba)

plt.figure(figsize=(7, 6))
plt.plot(fpr, tpr, lw=2, label=f'ROC curve (AUC = {auc:.3f})')
plt.plot([0, 1], [0, 1], 'k--', lw=1, label='Random (AUC = 0.5)')
plt.fill_between(fpr, tpr, alpha=0.1)
plt.xlabel('False Positive Rate (1 - Specificity)')
plt.ylabel('True Positive Rate (Recall)')
plt.title('ROC Curve')
plt.legend(loc='lower right')
plt.grid(True, alpha=0.3)
plt.show()
```

### Multiclass ROC-AUC
```python
# OVR (One-vs-Rest): compute AUC for each class vs. all others, then average
auc_ovr = roc_auc_score(y_test, y_proba_all_classes, multi_class='ovr', average='macro')

# OVO (One-vs-One): compute AUC for each pair of classes, then average
auc_ovo = roc_auc_score(y_test, y_proba_all_classes, multi_class='ovo', average='macro')
```

---

## 9.11 Precision-Recall Curve & Average Precision

### When to prefer PR curve over ROC
On **highly imbalanced datasets**, the ROC curve can be **misleadingly optimistic**. Why? The FPR term $\frac{FP}{FP + TN}$ has TN in the denominator — when the majority class is Negative, TN is huge, so FPR stays small even with many FPs. The ROC curve doesn't "see" those false positives clearly.

The **PR curve** focuses entirely on the positive class — it uses TP, FP, and FN, completely ignoring TN. It is more discriminating on imbalanced data.

$$\text{PR curve: } \text{Precision}(t) \text{ vs. } \text{Recall}(t) \text{ as threshold } t \text{ varies}$$

- **High recall, low precision:** Model casts a wide net — catches most positives, but many false alarms.
- **High precision, low recall:** Model is conservative — only predicts positive when very confident, but misses many.

### Average Precision (AP)
The area under the PR curve, approximated as a weighted mean of Precisions at each recall level where recall increases:

$$AP = \sum_k (R_k - R_{k-1}) \cdot P_k$$

```python
from sklearn.metrics import precision_recall_curve, average_precision_score
import matplotlib.pyplot as plt

y_proba = model.predict_proba(X_test)[:, 1]

precision, recall, thresholds = precision_recall_curve(y_test, y_proba)
ap = average_precision_score(y_test, y_proba)

plt.figure(figsize=(7, 6))
plt.plot(recall, precision, lw=2, label=f'PR curve (AP = {ap:.3f})')
plt.axhline(y=y_test.mean(), color='k', linestyle='--', label=f'Baseline (prevalence = {y_test.mean():.3f})')
plt.xlabel('Recall')
plt.ylabel('Precision')
plt.title('Precision-Recall Curve')
plt.legend()
plt.grid(True, alpha=0.3)
```

> [!NOTE]
> The random classifier baseline for a PR curve is the **prevalence** (positive rate), not 0.5. If positives make up 5% of the data, a random classifier has AP ≈ 0.05, not 0.5. A good model's AP should be significantly above the prevalence line.

---

## 9.12 Choosing & Tuning the Decision Threshold

Most classifiers output a **probability score** (via `predict_proba`), not a hard label. The default threshold is 0.5 — predict Positive if score > 0.5. This is often *not* the best threshold.

### Tuning the threshold for a specific goal

```python
import numpy as np
from sklearn.metrics import precision_score, recall_score, f1_score

y_proba = model.predict_proba(X_test)[:, 1]
thresholds = np.linspace(0, 1, 101)

results = []
for t in thresholds:
    y_pred_t = (y_proba >= t).astype(int)
    if y_pred_t.sum() == 0:   # no positive predictions
        continue
    results.append({
        'threshold': t,
        'precision': precision_score(y_test, y_pred_t, zero_division=0),
        'recall':    recall_score(y_test, y_pred_t, zero_division=0),
        'f1':        f1_score(y_test, y_pred_t, zero_division=0)
    })

df_thresh = pd.DataFrame(results)
best_f1_thresh = df_thresh.loc[df_thresh['f1'].idxmax(), 'threshold']
print(f"Threshold maximising F1: {best_f1_thresh:.2f}")

# Apply the chosen threshold
y_pred_final = (y_proba >= best_f1_thresh).astype(int)
```

### Finding the optimal threshold from the ROC curve

The point on the ROC curve closest to the top-left corner $(0, 1)$ — perfect TPR with no FPR — often gives a good operating threshold:

```python
fpr, tpr, thresholds = roc_curve(y_test, y_proba)
optimal_idx = np.argmax(tpr - fpr)   # Youden's J statistic
optimal_threshold = thresholds[optimal_idx]
print(f"Optimal ROC threshold (Youden's J): {optimal_threshold:.3f}")
```

---

## 9.13 Metrics Quick-Reference

| Metric | Formula | Best for |
|:---|:---|:---|
| Accuracy | $(TP+TN)/N$ | Balanced classes, equal misclassification costs |
| Precision | $TP/(TP+FP)$ | FP is costly (spam, false alarms) |
| Recall | $TP/(TP+FN)$ | FN is costly (cancer, fraud, safety) |
| Specificity | $TN/(TN+FP)$ | Medical testing (true negative rate) |
| F1 | $2PR/(P+R)$ | Imbalanced classes; balanced P/R tradeoff |
| F2 | $\beta=2$ F-score | Recall matters more than Precision |
| F0.5 | $\beta=0.5$ F-score | Precision matters more than Recall |
| MCC | All 4 cells | Binary, highly imbalanced data |
| Cohen's κ | Chance-corrected accuracy | Agreement tasks, multiclass |
| ROC-AUC | Area under ROC | Ranking ability, threshold-independent |
| Average Precision | Area under PR | Imbalanced binary classification |

---

# 10. scikit-learn Models — Theory & Hyperparameters

---

## 10.1 Linear Regression

**Intuition:** Fit a hyperplane $\hat{y} = \mathbf{w}^T \mathbf{x} + b$ that minimises the sum of squared residuals between predictions and true values.

$$\text{Loss (MSE)} = \frac{1}{n}\sum_{i=1}^n (y_i - \hat{y}_i)^2$$

### Closed-Form Solution (Normal Equation)
$$\hat{\mathbf{w}} = (X^TX)^{-1}X^Ty$$

Requires $X^TX$ to be invertible (fails with perfect multicollinearity). $O(p^3)$ — slow when $p$ (features) is large.

### Gradient Descent Variants

$$w \leftarrow w - \alpha \cdot \nabla_w \text{Loss}$$

| Variant | Batch Size | Pros | Cons |
|:---|:---:|:---|:---|
| **Batch GD** | All $n$ | Stable convergence | Slow on large data |
| **Stochastic GD (SGD)** | 1 | Fast, can escape local minima | Noisy, oscillates |
| **Mini-Batch GD** | $k$ (e.g. 32) | Best of both | Most commonly used |

```python
from sklearn.linear_model import LinearRegression, SGDRegressor

lr  = LinearRegression()   # uses normal equation (via SVD internally)
sgd = SGDRegressor(
    loss='squared_error',
    learning_rate='invscaling',  # 'constant', 'optimal', 'invscaling', 'adaptive'
    eta0=0.01,
    max_iter=1000,
    tol=1e-3,
    random_state=42
)
```

**Assumptions (Gauss-Markov):** Linearity, no perfect multicollinearity, homoscedasticity, no autocorrelation of errors, $E[\epsilon|X]=0$.

---

## 10.2 Ridge, Lasso & Elastic Net (Regularised Regression)

Regularisation adds a penalty on the magnitude of weights to prevent overfitting. The penalty controls a bias-variance tradeoff — larger penalty = simpler model = more bias, less variance.

### Ridge (L2 Regularisation)
$$\boxed{\text{Loss} = MSE + \alpha \sum_{j=1}^{p} w_j^2}$$

- Shrinks all coefficients **toward zero** but rarely to exactly zero.
- The $\ell_2$ penalty is differentiable everywhere → smooth optimisation.
- Has a closed-form solution: $\hat{\mathbf{w}} = (X^TX + \alpha I)^{-1}X^Ty$ — adding $\alpha I$ makes the matrix always invertible, fixing multicollinearity.
- **Use when:** Many features each contribute a small amount.

```python
from sklearn.linear_model import Ridge, RidgeCV
ridge = Ridge(alpha=1.0)
ridge_cv = RidgeCV(alphas=[0.01, 0.1, 1, 10, 100], cv=5)  # auto-tunes alpha
```

### Lasso (L1 Regularisation)
$$\boxed{\text{Loss} = MSE + \alpha \sum_{j=1}^{p} |w_j|}$$

- Can drive some coefficients to **exactly zero** → automatic feature selection.
- The $\ell_1$ penalty is non-differentiable at zero → solved via coordinate descent.
- Produces **sparse** solutions.
- **Use when:** Only a few features are truly relevant.

```python
from sklearn.linear_model import Lasso, LassoCV
lasso = Lasso(alpha=0.1)
lasso_cv = LassoCV(cv=5, random_state=42)  # selects best alpha via CV
```

### Elastic Net (L1 + L2)
$$\text{Loss} = MSE + \alpha \left[ \rho \|w\|_1 + \frac{1-\rho}{2} \|w\|_2^2 \right]$$

Combines Ridge's stability with Lasso's sparsity. `l1_ratio` $= \rho$: 0 = Ridge, 1 = Lasso.

```python
from sklearn.linear_model import ElasticNet
en = ElasticNet(alpha=0.1, l1_ratio=0.5)
```

### Key Hyperparameter: `alpha` ($\alpha$)
- `alpha = 0` → plain Linear Regression.
- ↑ `alpha` → stronger penalty → simpler model → risk of underfitting.
- Use `RidgeCV` / `LassoCV` / `ElasticNetCV` to tune automatically.

> [!TIP]
> Always scale features before Ridge/Lasso/ElasticNet. The penalty treats all coefficients equally, so unscaled features will be penalised unfairly.

---

## 10.3 Polynomial Regression

**Intuition:** Linear regression fits a line. To fit curves, augment features with polynomial terms, then run linear regression on the expanded feature space.

$$[x_1, x_2] \xrightarrow{\text{degree=2}} [x_1, x_2, x_1^2, x_1 x_2, x_2^2]$$

This is still **linear in the parameters** — just in a higher-dimensional feature space.

```python
from sklearn.preprocessing import PolynomialFeatures
from sklearn.pipeline import Pipeline
from sklearn.linear_model import Ridge

pipe = Pipeline([
    ('poly',   PolynomialFeatures(degree=3, include_bias=False)),
    ('scaler', StandardScaler()),
    ('model',  Ridge(alpha=1.0))   # always regularise polynomial regression
])
```

> [!WARNING]
> High `degree` → exponential feature explosion + severe overfitting. Always combine with regularisation and cross-validate the degree.

---

## 10.4 Logistic Regression

**Intuition:** Models the *probability* that a sample belongs to class 1 by squashing a linear combination of features through the **sigmoid function**.

$$\boxed{\hat{p} = \sigma(\mathbf{w}^T \mathbf{x} + b) = \frac{1}{1 + e^{-(\mathbf{w}^T \mathbf{x} + b)}}}$$

**Decision rule:** $\hat{y} = 1$ if $\hat{p} \ge 0.5$, else $\hat{y} = 0$.

**Loss — Binary Cross-Entropy (Log-Loss):**
$$\mathcal{L} = -\frac{1}{n}\sum_{i=1}^n \left[y_i \log(\hat{p}_i) + (1-y_i)\log(1-\hat{p}_i)\right]$$

**Multiclass:** Sigmoid is replaced by **softmax**; loss becomes **categorical cross-entropy**. `multi_class='ovr'` trains $K$ binary classifiers; `multi_class='multinomial'` trains a joint softmax model.

```python
from sklearn.linear_model import LogisticRegression

clf = LogisticRegression(
    C=1.0,                  # inverse of regularisation: C = 1/lambda
    penalty='l2',           # 'l1', 'l2', 'elasticnet', None
    solver='lbfgs',         # 'lbfgs' (L2), 'liblinear' (L1), 'saga' (all)
    max_iter=1000,
    class_weight='balanced',# corrects for class imbalance
    multi_class='auto',
    random_state=42
)
```

### Key Hyperparameters
| Parameter | Meaning | Notes |
|:---|:---|:---|
| `C` | $1/\lambda$ — inverse regularisation strength | Larger C = less regularised |
| `penalty` | Regularisation type | `'l1'` needs `solver='liblinear'` or `'saga'` |
| `solver` | Optimisation algorithm | `'saga'` supports all penalties + large datasets |
| `class_weight` | Handle imbalance | `'balanced'` weights inversely to class frequency |
| `max_iter` | Convergence iterations | Increase if `ConvergenceWarning` |

---

## 10.5 Support Vector Machines (SVM)

**Intuition:** Find the hyperplane that separates classes with the **maximum margin**. The margin is the gap between the hyperplane and the nearest training samples from each class — called **support vectors** because they "support" (define) the decision boundary.

$$\text{Objective: } \max_{\mathbf{w}, b} \frac{2}{\|\mathbf{w}\|} \quad \text{s.t.} \quad y_i(\mathbf{w}^T\mathbf{x}_i + b) \ge 1 \;\forall i$$

Equivalently: $\min \frac{1}{2}\|\mathbf{w}\|^2$

### Hard vs. Soft Margin
- **Hard margin:** Requires perfect linear separability. Fails with any noise or overlap.
- **Soft margin:** Allows violations using **slack variables** $\xi_i \ge 0$:

$$\min \frac{1}{2}\|\mathbf{w}\|^2 + C\sum_i \xi_i \quad \text{s.t.} \quad y_i(\mathbf{w}^T\mathbf{x}_i+b) \ge 1 - \xi_i$$

- **High $C$:** Penalises misclassifications heavily → narrow margin → risk overfitting.
- **Low $C$:** Allows more violations → wider margin → better generalisation.

### The Kernel Trick
Data in the original space may not be linearly separable, but may be in a higher-dimensional space. Kernels compute the dot product in that space *without* explicitly transforming the data:

$$K(\mathbf{x}_i, \mathbf{x}_j) = \phi(\mathbf{x}_i)^T \phi(\mathbf{x}_j)$$

| Kernel | Formula | Use when |
|:---|:---|:---|
| **Linear** | $\mathbf{x}_i^T \mathbf{x}_j$ | Data is linearly separable; high-dimensional (text) |
| **RBF (Gaussian)** | $\exp(-\gamma \|\mathbf{x}_i - \mathbf{x}_j\|^2)$ | General-purpose default; smooth non-linear boundary |
| **Polynomial** | $(\gamma \mathbf{x}_i^T \mathbf{x}_j + r)^d$ | Moderate non-linearity; image classification |
| **Sigmoid** | $\tanh(\gamma \mathbf{x}_i^T \mathbf{x}_j + r)$ | Rarely used |

```python
from sklearn.svm import SVC, SVR, LinearSVC

clf = SVC(
    kernel='rbf',
    C=1.0,
    gamma='scale',       # 'scale'=1/(n_features*Var(X)); 'auto'=1/n_features
    probability=True,    # enable predict_proba (uses Platt scaling; adds cost)
    class_weight='balanced',
    random_state=42
)

# For large datasets: LinearSVC is much faster than SVC(kernel='linear')
lsvc = LinearSVC(C=1.0, max_iter=2000)
```

### Key Hyperparameters
| Parameter | Effect |
|:---|:---|
| `C` | Margin/misclassification tradeoff — high C = harder boundary |
| `kernel` | Shape of decision boundary |
| `gamma` | RBF bandwidth — high gamma = narrow Gaussian = complex boundary (overfit) |
| `degree` | Polynomial kernel degree |

> [!IMPORTANT]
> SVMs are **highly sensitive to feature scale** — always StandardScale before fitting. They also don't natively produce probability estimates; `probability=True` adds a calibration step (Platt scaling) that increases training time.

---

## 10.6 Decision Trees

**Intuition:** Recursively partition the feature space by asking binary yes/no questions. At each internal node, pick the feature and threshold that best separates the classes. Leaves contain the predicted value.

### Splitting Criteria

**Gini Impurity** (default for `DecisionTreeClassifier`):
$$\text{Gini}(S) = 1 - \sum_k p_k^2$$
Ranges from 0 (pure) to $1 - 1/K$ (maximally impure).

**Entropy / Information Gain:**
$$H(S) = -\sum_k p_k \log_2 p_k$$
$$\text{IG} = H(\text{parent}) - \sum_\text{child} \frac{n_\text{child}}{n_\text{parent}} H(\text{child})$$

**MSE Reduction** (for regression trees): split that minimises within-child variance.

> Gini and Entropy produce nearly identical results in practice. Gini is slightly faster to compute (no log).

```python
from sklearn.tree import DecisionTreeClassifier, DecisionTreeRegressor, export_text, plot_tree

clf = DecisionTreeClassifier(
    criterion='gini',         # 'gini' or 'entropy'
    max_depth=5,              # None = grow fully (overfits)
    min_samples_split=10,     # min samples to split an internal node
    min_samples_leaf=5,       # min samples to be a leaf
    max_features=None,        # features to consider at each split
    ccp_alpha=0.0,            # post-pruning: higher = more pruning
    class_weight='balanced',
    random_state=42
)

clf.fit(X_train, y_train)

# Visualise the tree
print(export_text(clf, feature_names=list(X_train.columns)))
```

### Hyperparameter Effects

| Parameter | ↑ value → | Risk |
|:---|:---|:---|
| `max_depth` | More complex | Overfitting |
| `min_samples_split` | Simpler | Underfitting |
| `min_samples_leaf` | Simpler | Underfitting |
| `ccp_alpha` | More pruned | Underfitting |

### Feature Importance
$$\text{importance}(f) = \sum_{\text{nodes split on }f} \frac{n_t}{n} \left[\text{impurity}(t) - \frac{n_{t_L}}{n_t}\text{impurity}(t_L) - \frac{n_{t_R}}{n_t}\text{impurity}(t_R)\right]$$

```python
importances = pd.Series(clf.feature_importances_, index=X_train.columns)
importances.sort_values(ascending=False).head(10).plot(kind='bar')
```

**Advantages:** Interpretable, no scaling needed, handles mixed types, captures non-linear relationships.
**Disadvantages:** High variance (small data changes → completely different tree), overfits without pruning.

---

## 10.7 Ensemble Methods — The Big Picture

The core idea: a single model has high variance or high bias. Combining many models can simultaneously reduce both.

| Method | How models are combined | What it reduces | Base learner |
|:---|:---|:---|:---|
| **Bagging** | Parallel training on bootstrap samples; aggregate by voting/averaging | Variance | Any |
| **Random Forest** | Bagging + random feature subsets at each split | Variance (more than bagging alone) | Decision Trees |
| **AdaBoost** | Sequential; reweight samples based on previous errors | Bias | Stumps (depth-1 trees) |
| **Gradient Boosting** | Sequential; each tree fits the negative gradient (residuals) of loss | Bias + Variance | Shallow trees |
| **Voting** | Average/majority vote of diverse models | Both | Any diverse set |
| **Stacking** | Meta-learner trained on base model predictions | Both | Any |

---

## 10.8 Bagging (Bootstrap AGGregatING)

**Algorithm:**
1. Draw $B$ bootstrap samples $\mathcal{D}_1, \ldots, \mathcal{D}_B$ from training data (sampling with replacement).
2. Train one base learner on each sample independently (can be parallelised).
3. Aggregate: majority vote (classification) or average (regression).

**Why it works:** Each model has high variance individually. Because each is trained on a different random sample, their errors are uncorrelated. The average of $B$ uncorrelated models with variance $\sigma^2$ has variance $\sigma^2/B$.

**Out-of-Bag (OOB) Error:** Each bootstrap sample leaves out ~37% of the original data (on average). These left-out samples can be used as a free validation set — no need for a separate val split.

```python
from sklearn.ensemble import BaggingClassifier
from sklearn.tree import DecisionTreeClassifier

bag = BaggingClassifier(
    estimator=DecisionTreeClassifier(max_depth=None),
    n_estimators=100,
    max_samples=1.0,       # fraction of samples per bootstrap
    max_features=1.0,      # fraction of features per bootstrap
    bootstrap=True,        # True = bagging; False = pasting (no replacement)
    oob_score=True,        # compute OOB score
    n_jobs=-1,
    random_state=42
)
bag.fit(X_train, y_train)
print(f"OOB Score: {bag.oob_score_:.4f}")
```

---

## 10.9 Random Forest

Random Forest = Bagging + **Random Feature Subsets at each split**.

While vanilla Bagging draws bootstrap samples of rows, every tree still evaluates *all* $p$ features at every node split. If one feature is extremely dominant (e.g. `income`), every tree will pick `income` as its root split, making the trees highly correlated and limiting variance reduction.

Random Forest solves this by randomly sampling $m$ features ($m = \sqrt{p}$ for classification, $m = p/3$ for regression) **at every single node split** inside every tree.

### Why Feature Sampling at Each Split Works (Mathematical Proof & Intuition)

The variance of an ensemble of $B$ trees, each with variance $\sigma^2$ and pairwise correlation $\rho$, is:

$$\operatorname{Var}\left(\frac{1}{B}\sum_{i=1}^B T_i\right) = \rho \sigma^2 + \frac{1 - \rho}{B} \sigma^2$$

- As $B \to \infty$, the second term $\frac{1-\rho}{B}\sigma^2 \to 0$.
- The remaining irreducible ensemble variance is $\rho \sigma^2$.

In **Vanilla Bagging**, because strong features appear at the top of almost every tree, the correlation $\rho$ remains high (~0.5–0.7).  
In **Random Forest**, forcing trees to select from a random subset of $m$ features at every node prevents dominant features from appearing everywhere. This drives $\rho$ down significantly (~0.1–0.2), enabling much greater total variance reduction.

```python
from sklearn.ensemble import RandomForestClassifier, RandomForestRegressor

rf = RandomForestClassifier(
    n_estimators=200,       # number of trees; more is generally better (diminishing returns)
    max_depth=None,         # None = grow fully; limit to prevent overfitting
    max_features='sqrt',    # 'sqrt' (classification), 1.0 (all features = vanilla bagging), or 'log2'
    min_samples_split=2,
    min_samples_leaf=1,
    bootstrap=True,
    oob_score=True,         # free validation via out-of-bag samples
    class_weight='balanced',
    n_jobs=-1,
    random_state=42
)

rf.fit(X_train, y_train)
print(f"OOB accuracy: {rf.oob_score_:.4f}")
print(f"Test accuracy: {rf.score(X_test, y_test):.4f}")

# Feature importances
importances = pd.Series(rf.feature_importances_, index=X_train.columns)
print(importances.sort_values(ascending=False).head(10))
```

### Key Hyperparameters
| Parameter | Effect |
|:---|:---|
| `n_estimators` | More trees = lower variance (diminishing returns past ~200) |
| `max_depth` | Limit tree growth to prevent overfitting |
| `max_features` | Lower = more decorrelation between trees = lower variance |
| `min_samples_leaf` | Larger = smoother predictions (regression), less overfit |
| `oob_score` | Free performance estimate on unseen data |

> [!TIP]
> Random Forest's OOB score is an unbiased estimate of generalisation performance — often close to 5-fold CV but computed for free as a byproduct of training. Use it as a quick sanity check.

---

## 10.10 AdaBoost (Adaptive Boosting)

**Intuition:** Train a sequence of weak learners (typically decision stumps — 1-split decision trees). After each round:
1. **Sample weights ($w_i$)** are updated: misclassified samples get **higher weights**, forcing the next learner to focus on hard cases.
2. **Model weight ($\alpha_m$)** is calculated: more accurate weak learners receive higher voting power in the final decision.

---

### Step-by-Step Mathematical Algorithm (AdaBoost.M1 for Classification $y_i \in \{-1, +1\}$)

1. **Initialise Sample Weights:**
   $$w_i^{(1)} = \frac{1}{N} \quad \text{for } i = 1, \ldots, N$$

2. **For iteration $m = 1, \ldots, M$:**
   a. Fit weak learner $h_m(x) \in \{-1, +1\}$ using current sample weights $w^{(m)}$.
   b. Compute total weighted error $\epsilon_m$:
      $$\epsilon_m = \sum_{i=1}^N w_i^{(m)} \cdot \mathbf{1}[h_m(x_i) \ne y_i]$$
   c. Compute **model voting weight** $\alpha_m$:
      $$\boxed{\alpha_m = \frac{1}{2}\ln\left(\frac{1 - \epsilon_m}{\epsilon_m}\right)}$$
      *(If $\epsilon_m$ is small, $\alpha_m$ is large and positive. If $\epsilon_m = 0.5$, $\alpha_m = 0$.)*
   d. Update sample weights:
      $$w_i^{(m+1)} = w_i^{(m)} \cdot \exp\left(-\alpha_m \cdot y_i \cdot h_m(x_i)\right)$$
      - Correctly classified ($y_i \cdot h_m(x_i) = +1$): $w_i \leftarrow w_i \cdot e^{-\alpha_m}$ (weight drops).
      - Misclassified ($y_i \cdot h_m(x_i) = -1$): $w_i \leftarrow w_i \cdot e^{+\alpha_m}$ (weight rises).
   e. Renormalise weights: $w_i^{(m+1)} \leftarrow \frac{w_i^{(m+1)}}{\sum_j w_j^{(m+1)}}$ so they sum to 1.

3. **Final Ensemble Prediction:**
   $$H(x) = \text{sign}\left(\sum_{m=1}^M \alpha_m h_m(x)\right)$$

---

### Step-by-Step Numerical Toy Example

Consider 5 samples in 1D space with binary labels $y \in \{-1, +1\}$:

| Sample $i$ | Feature $X$ | Label $y$ | Initial Weight $w^{(1)}$ |
|:---:|:---:|:---:|:---:|
| **1** | 1 | **+1** | 0.20 |
| **2** | 2 | **+1** | 0.20 |
| **3** | 3 | **-1** | 0.20 |
| **4** | 4 | **+1** | 0.20 |
| **5** | 5 | **-1** | 0.20 |

#### Round 1 ($m = 1$)
- **Selected Stump $h_1(x)$:** Split at $X \le 2.5 \rightarrow +1$, else $-1$.
  - Predictions: $h_1 = [+1, +1, -1, \mathbf{-1}, -1]$.
  - Sample 4 ($y=+1$) is **misclassified**; all others correct.
- **Weighted Error:** $\epsilon_1 = w_4^{(1)} = \mathbf{0.20}$.
- **Model Weight $\alpha_1$:**
  $$\alpha_1 = \frac{1}{2} \ln\left(\frac{1 - 0.20}{0.20}\right) = \frac{1}{2} \ln(4) \approx \mathbf{0.693}$$
- **Update Weights:**
  - Correct ($1, 2, 3, 5$): $0.20 \times e^{-0.693} = 0.10$
  - Incorrect ($4$): $0.20 \times e^{+0.693} = 0.40$
  - Sum of raw weights = $0.80$.
- **Normalised Weights $w^{(2)}$:** $[0.125, 0.125, 0.125, \mathbf{0.500}, 0.125]$.  
  *(Sample 4 now holds 50% of total sample weight!)*

#### Round 2 ($m = 2$)
- **Selected Stump $h_2(x)$:** Forced to fix Sample 4 $\rightarrow$ split at $X \le 4.5 \rightarrow +1$, else $-1$.
  - Predictions: $h_2 = [+1, +1, \mathbf{+1}, +1, -1]$.
  - Sample 3 ($y=-1$) is **misclassified**; Sample 4 is now correct!
- **Weighted Error:** $\epsilon_2 = w_3^{(2)} = \mathbf{0.125}$.
- **Model Weight $\alpha_2$:**
  $$\alpha_2 = \frac{1}{2} \ln\left(\frac{1 - 0.125}{0.125}\right) = \frac{1}{2} \ln(7) \approx \mathbf{0.973}$$

#### Ensemble Output for Sample 4 ($X=4, y=+1$)
- $h_1(4) = -1$, $h_2(4) = +1$.
- Combined Score: $\alpha_1(-1) + \alpha_2(+1) = 0.693(-1) + 0.973(+1) = \mathbf{+0.280} > 0$.
- $\text{sign}(+0.280) = \mathbf{+1}$ ✅ — Stump 2's higher weight ($\alpha_2 = 0.973 > 0.693$) overrode Stump 1's mistake.

---

### AdaBoost for Regression (AdaBoost.R2)

In regression ($y \in \mathbb{R}$), errors are continuous $|y_i - \hat{y}_i|$ rather than binary:

1. **Relative Error ($L_i$):**
   $$D = \max_i |y_i - \hat{y}_i^{(m)}|, \quad L_i = \frac{|y_i - \hat{y}_i^{(m)}|}{D} \in [0, 1]$$
2. **Average Model Error ($\bar{L}_m$):** $\bar{L}_m = \sum_i w_i^{(m)} L_i$.
3. **Confidence Factor ($\beta_m$):** $\beta_m = \frac{\bar{L}_m}{1 - \bar{L}_m}$.
4. **Sample Weight Update:**
   $$w_i^{(m+1)} = w_i^{(m)} \cdot \beta_m^{1 - L_i}$$
   *(Small error $L_i \approx 0 \rightarrow$ weight multiplied by $\beta_m < 1$, decreasing it).*
5. **Final Prediction:** Takes the **Weighted Median** of all weak trees $[T_1(x), \ldots, T_M(x)]$ using tree weights $\ln(1/\beta_m)$, ensuring robustness against outlier predictions.

```python
from sklearn.ensemble import AdaBoostClassifier, AdaBoostRegressor
from sklearn.tree import DecisionTreeClassifier, DecisionTreeRegressor

ada_clf = AdaBoostClassifier(
    estimator=DecisionTreeClassifier(max_depth=1),  # decision stump
    n_estimators=200,
    learning_rate=1.0,
    algorithm='SAMME.R',  # uses real probabilities instead of discrete predictions
    random_state=42
)

ada_reg = AdaBoostRegressor(
    estimator=DecisionTreeRegressor(max_depth=3),
    n_estimators=100,
    learning_rate=1.0,
    loss='linear',        # 'linear', 'square', or 'exponential'
    random_state=42
)
```

| Hyperparameter | Effect |
|:---|:---|
| `n_estimators` | Number of boosting rounds; too many can overfit |
| `learning_rate` | Shrinks contribution of each weak learner; lower rate requires more estimators |
| `estimator` | Base learner (default: `max_depth=1` stump for clf, `max_depth=3` for reg) |
| `loss` (Regressor) | Relative loss formulation (`linear`, `square`, `exponential`) |

**Pros:** Simple, fast, low hyperparameter tuning required; often beats Random Forest on clean data.  
**Cons:** Extremely sensitive to noise and outliers (noisy samples keep getting upweighted exponentially).

---

## 10.11 Gradient Boosting

**Intuition:** Instead of adjusting sample weights like AdaBoost, each new tree in Gradient Boosting directly fits the **negative gradient of the loss function** (the pseudo-residuals) with respect to the current model's predictions.

---

### Gradient Descent in Weight Space vs. Function Space

| Technique | Where Optimization Happens | Update Rule |
|:---|:---|:---|
| **Standard Gradient Descent** | Parameter space (weights $w$) | $w_{t+1} = w_t - \eta \cdot \nabla_w L$ |
| **Gradient Boosting** | Function space (predictions $F(x)$) | $\boxed{F_{t+1}(x) = F_t(x) + \eta \cdot h_t(x)}$ |

Here, the new decision tree $h_t(x)$ is trained to approximate the **negative gradient** $-\nabla_{F} L(y, F(x))$.

---

### Mathematical Algorithm (Regression with MSE Loss)

Given dataset $\{(x_1, y_1), \ldots, (x_N, y_N)\}$ and learning rate $\eta$:

1. **Initialise Constant Base Prediction:**
   $$F_0(x) = \arg\min_\gamma \sum_{i=1}^N L(y_i, \gamma) = \bar{y} = \frac{1}{N}\sum_{i=1}^N y_i$$

2. **For iteration $m = 1, 2, \ldots, M$:**
   a. Compute pseudo-residuals $r_i^{(m)}$ for all samples:
      $$r_i^{(m)} = -\left[ \frac{\partial L(y_i, F(x_i))}{\partial F(x_i)} \right]_{F(x) = F_{m-1}(x)}$$
      *(For MSE Loss $L = \frac{1}{2}(y - F)^2$, pseudo-residual is simply $r_i^{(m)} = y_i - F_{m-1}(x_i)$).*
   b. Fit a regression tree $h_m(x)$ to predict targets $r^{(m)}$.
   c. Update the ensemble prediction:
      $$F_m(x) = F_{m-1}(x) + \eta \cdot h_m(x)$$

---

### Step-by-Step Numerical Toy Example

Predict **House Price (₹ Lakhs)** based on **Size (sq ft)** with learning rate $\eta = 0.1$:

| House | $X$ (Size in sq ft) | $y$ (Price in ₹ Lakhs) |
|:---:|:---:|:---:|
| **1** | 500 | **30** |
| **2** | 1000 | **50** |
| **3** | 1500 | **70** |

#### Step 1: Base Prediction $F_0$
$$F_0 = \bar{y} = \frac{30 + 50 + 70}{3} = \mathbf{50.0}$$
Predictions: $F_0 = [50.0, 50.0, 50.0]$.

#### Round 1 ($m = 1$)
1. **Pseudo-Residuals $r^{(1)} = y - F_0$:**
   - House 1 ($X=500$): $30 - 50 = \mathbf{-20.0}$
   - House 2 ($X=1000$): $50 - 50 = \mathbf{0.0}$
   - House 3 ($X=1500$): $70 - 50 = \mathbf{+20.0}$
2. **Fit Tree $h_1(x)$ to $r^{(1)}$:**
   - Split at $X \le 1250$:
     - Left ($X \le 1250$): Houses 1, 2 $\rightarrow \text{mean}(-20, 0) = \mathbf{-10.0}$
     - Right ($X > 1250$): House 3 $\rightarrow \text{mean}(+20) = \mathbf{+20.0}$
3. **Update Ensemble Prediction $F_1(x) = F_0(x) + 0.1 \cdot h_1(x)$:**
   - House 1: $50.0 + 0.1(-10.0) = \mathbf{49.0}$
   - House 2: $50.0 + 0.1(-10.0) = \mathbf{49.0}$
   - House 3: $50.0 + 0.1(+20.0) = \mathbf{52.0}$

#### Round 2 ($m = 2$)
1. **Pseudo-Residuals $r^{(2)} = y - F_1$:**
   - House 1: $30 - 49.0 = \mathbf{-19.0}$
   - House 2: $50 - 49.0 = \mathbf{+1.0}$
   - House 3: $70 - 52.0 = \mathbf{+18.0}$
2. **Fit Tree $h_2(x)$ to $r^{(2)}$:**
   - Split at $X \le 750$:
     - Left ($X \le 750$): House 1 $\rightarrow \mathbf{-19.0}$
     - Right ($X > 750$): Houses 2, 3 $\rightarrow \text{mean}(+1.0, +18.0) = \mathbf{+9.5}$
3. **Update Ensemble Prediction $F_2(x) = F_1(x) + 0.1 \cdot h_2(x)$:**
   - House 1: $49.0 + 0.1(-19.0) = \mathbf{47.1}$
   - House 2: $49.0 + 0.1(+9.5) = \mathbf{49.95}$
   - House 3: $52.0 + 0.1(+9.5) = \mathbf{52.95}$

Notice how residuals shrink with each round as predictions move closer to true $y$.

---

```python
from sklearn.ensemble import GradientBoostingClassifier, GradientBoostingRegressor, HistGradientBoostingClassifier

gb = GradientBoostingClassifier(
    n_estimators=300,
    learning_rate=0.05,   # shrinkage — lower = needs more trees
    max_depth=4,          # typically 3–6 for GBM
    subsample=0.8,        # stochastic GB: use 80% of samples per tree (reduces variance)
    max_features='sqrt',  # random feature subsets at each split
    min_samples_leaf=10,
    random_state=42
)

# HistGradientBoostingClassifier: faster sklearn implementation (like LightGBM)
hgb = HistGradientBoostingClassifier(
    max_iter=300,
    learning_rate=0.05,
    max_depth=4,
    l2_regularization=0.1,
    early_stopping=True,   # uses a validation set to stop early
    random_state=42
)
```

### The Learning Rate — `n_estimators` Tradeoff
Lower `learning_rate` → each tree contributes less → model changes slowly → need more trees but generalises better. Rule of thumb: set `learning_rate` low (0.01–0.1) and use early stopping to find the right `n_estimators`.

---

## 10.12 XGBoost

XGBoost (Extreme Gradient Boosting) is a highly optimised implementation of gradient boosting with several algorithmic improvements:

1. **Regularised objective:** Adds L1 ($\alpha$) and L2 ($\lambda$) penalties on leaf weights directly in the loss:
$$\mathcal{L} = \sum_i L(y_i, \hat{y}_i) + \sum_m \left[\gamma T_m + \frac{1}{2}\lambda \sum_j w_j^2\right]$$
where $T_m$ = number of leaves, $w_j$ = leaf weights.

2. **Second-order Taylor expansion:** Uses both gradient (first derivative) and Hessian (second derivative) of the loss for more accurate tree fitting.
3. **Column (feature) subsampling** — like Random Forest, reducing overfitting.
4. **Sparsity-aware split finding** — handles missing values natively.
5. **Histogram-based approximate splitting** — much faster than exact greedy.

```python
import xgboost as xgb

xgb_clf = xgb.XGBClassifier(
    n_estimators=500,
    learning_rate=0.05,
    max_depth=5,
    subsample=0.8,         # row subsampling per tree
    colsample_bytree=0.8,  # feature subsampling per tree
    colsample_bylevel=0.8, # feature subsampling per level
    reg_alpha=0.1,         # L1 on leaf weights
    reg_lambda=1.0,        # L2 on leaf weights
    gamma=0.0,             # min loss reduction to make a split
    min_child_weight=1,    # min sum of hessian in a child (controls overfitting)
    scale_pos_weight=1,    # for imbalanced: set to neg/pos ratio
    eval_metric='logloss',
    early_stopping_rounds=20,
    use_label_encoder=False,
    random_state=42,
    n_jobs=-1
)

# Fitting with early stopping
eval_set = [(X_val, y_val)]
xgb_clf.fit(X_train, y_train, eval_set=eval_set, verbose=50)
```

### Key Hyperparameters

| Parameter | Effect |
|:---|:---|
| `n_estimators` | Number of boosting rounds |
| `learning_rate` | Shrinkage per tree |
| `max_depth` | Tree depth; 3–8 typical |
| `subsample` | Row subsampling (0.5–1.0) |
| `colsample_bytree` | Feature subsampling per tree |
| `reg_alpha` / `reg_lambda` | L1/L2 regularisation |
| `gamma` | Min impurity reduction for a split |
| `min_child_weight` | Larger = more conservative splits |
| `early_stopping_rounds` | Stop if val metric doesn't improve for N rounds |

---

## 10.13 LightGBM

LightGBM (Light Gradient Boosting Machine) by Microsoft. Key innovations over XGBoost:

1. **Leaf-wise (best-first) tree growth** instead of level-wise: grows the leaf with the greatest loss reduction first → deeper, more asymmetric trees → faster convergence.
2. **Histogram-based binning**: bins continuous features into ~256 buckets, dramatically reducing split-finding cost.
3. **GOSS (Gradient-based One-Side Sampling)**: keeps samples with large gradients (hard examples) and randomly samples from those with small gradients → faster without losing accuracy.
4. **EFB (Exclusive Feature Bundling)**: bundles mutually exclusive sparse features → reduces effective feature count.

```python
import lightgbm as lgb

lgb_clf = lgb.LGBMClassifier(
    n_estimators=500,
    learning_rate=0.05,
    max_depth=-1,           # -1 = no limit; control via num_leaves instead
    num_leaves=31,          # key parameter: 2^max_depth is a good upper bound
    subsample=0.8,
    colsample_bytree=0.8,
    reg_alpha=0.1,
    reg_lambda=1.0,
    min_child_samples=20,   # min samples in a leaf
    class_weight='balanced',
    random_state=42,
    n_jobs=-1
)

lgb_clf.fit(
    X_train, y_train,
    eval_set=[(X_val, y_val)],
    callbacks=[lgb.early_stopping(stopping_rounds=20), lgb.log_evaluation(50)]
)
```

**LightGBM vs. XGBoost:**

| | LightGBM | XGBoost |
|:---|:---|:---|
| Tree growth | Leaf-wise (asymmetric) | Level-wise (symmetric) |
| Speed | Faster on large datasets | Slightly slower |
| Memory | Lower | Higher |
| Hyperparameter to control depth | `num_leaves` | `max_depth` |
| Categorical support | Native (`categorical_feature=`) | Requires encoding |

---

## 10.14 CatBoost

CatBoost (short for **Categorical Boosting**) by Yandex addresses two primary flaws in traditional gradient boosting: **target leakage in categorical encoding** and **prediction drift in boosting tree construction**.

---

### 1. Ordered Target Encoding
Standard Target Encoding replaces a category with the mean target value of that category in the training set. However, using sample $i$'s target $y_i$ to calculate sample $i$'s own feature encoding causes severe target leakage.

**CatBoost's Solution:** For sample $i$ at position $p$ in a random permutation $\sigma$, compute its target statistic using **only samples appearing BEFORE $i$** in that permutation:

$$\boxed{\hat{x}_i = \frac{\sum_{j: \sigma(j) < \sigma(i), x_j = x_i} y_j + a \cdot P}{\sum_{j: \sigma(j) < \sigma(i), x_j = x_i} 1 + a}}$$

Where $P$ is the global target mean (prior) and $a$ is a smoothing weight. Because sample $i$'s target $y_i$ is never used to compute its own feature encoding, leakage is completely eliminated.

---

### 2. Ordered Boosting (Preventing Prediction Drift)

In standard boosting, the pseudo-residual $r_i^{(m)} = y_i - F_{m-1}(x_i)$ is computed using a model $F_{m-1}$ trained on a dataset that **already included sample $i$**. Because $F_{m-1}$ slightly memorises $x_i$, $r_i$ is artificially small, causing prediction drift.

**CatBoost's Solution:** Train separate auxiliary prefix models $M_1, M_2, \ldots, M_N$ along a random permutation $\sigma$:
- Model $M_{i-1}$ is trained **only on samples $1$ through $i-1$**.
- To compute the residual for sample $i$, CatBoost queries $M_{i-1}(x_i)$.
- Since $M_{i-1}$ has **never seen sample $i$**, the residual $r_i = y_i - M_{i-1}(x_i)$ is an honest, out-of-sample error.

#### Step-by-Step Numerical Toy Example of Ordered Boosting

Consider 4 samples in a random permutation order:

| Order | Sample | $X$ (Feature) | $y$ (Target) |
|:---:|:---:|:---:|:---:|
| **1st** | **A** | 1 | **10** |
| **2nd** | **B** | 2 | **20** |
| **3rd** | **C** | 3 | **30** |
| **4th** | **D** | 4 | **40** |

1. **Train Supported Prefix Models:**
   - $M_1$: Trained **only** on $\{A\}$
   - $M_2$: Trained **only** on $\{A, B\}$
   - $M_3$: Trained **only** on $\{A, B, C\}$

2. **Compute Unbiased Residuals:**
   - For **Sample B**: Residual $r_B = y_B - M_1(B)$ ($M_1$ has never seen $B$).
   - For **Sample C**: Residual $r_C = y_C - M_2(C)$ ($M_2$ has never seen $C$).
   - For **Sample D**: Residual $r_D = y_D - M_3(D)$ ($M_3$ has never seen $D$).

3. **Train Next Tree:** The next boosting tree is trained on these **unbiased out-of-sample residuals** $(r_B, r_C, r_D)$, preventing target leakage and prediction drift.

---

### 3. Symmetric (Oblivious) Trees

CatBoost uses **Oblivious Trees**, where **every node at depth $d$ uses the exact same feature and split threshold**.

```
                  Standard Tree                     Symmetric (Oblivious) Tree
              [ Age ≤ 30 ]                                [ Age ≤ 30 ]
             /            \                              /            \
    [ Income ≤ 50k ]   [ Zip ≤ 90210 ]          [ Income ≤ 50k ]   [ Income ≤ 50k ]
```

- **Execution Speed:** Predictions evaluate as bitwise operations/lookup tables, enabling **up to 8x faster CPU/GPU inference**.
- **Regularisation:** Forces balanced, symmetric tree structures, preventing deep overfitted branches.

---

```python
from catboost import CatBoostClassifier

cat_clf = CatBoostClassifier(
    iterations=500,
    learning_rate=0.05,
    depth=6,
    l2_leaf_reg=3,          # L2 regularisation
    cat_features=['city', 'gender', 'occupation'],  # pass raw string columns!
    eval_metric='AUC',
    early_stopping_rounds=50,
    random_seed=42,
    verbose=100
)

cat_clf.fit(X_train, y_train, eval_set=(X_val, y_val))
```

**Why CatBoost shines:** You can pass raw string categorical columns directly — no encoding needed. It handles the encoding internally in a leakage-free way.

### Boosting Libraries Comparison

| | sklearn GBM | XGBoost | LightGBM | CatBoost |
|:---|:---:|:---:|:---:|:---:|
| Speed | Slow | Fast | Fastest | Fast |
| Native categoricals | ❌ | ❌ | Partial | ✅ |
| Missing values | ❌ | ✅ | ✅ | ✅ |
| GPU support | ❌ | ✅ | ✅ | ✅ |
| Tree structure | Asymmetric | Symmetric (level-wise) | Asymmetric (leaf-wise) | **Oblivious (Symmetric)** |
| Leakage-free categoricals | ❌ | ❌ | ❌ | ✅ |

---

## 10.15 Voting Classifier & Regressor

Combines predictions of diverse models. Works best when models make uncorrelated errors.

```python
from sklearn.ensemble import VotingClassifier, VotingRegressor
from sklearn.linear_model import LogisticRegression
from sklearn.ensemble import RandomForestClassifier
from sklearn.svm import SVC

voting = VotingClassifier(
    estimators=[
        ('lr',  LogisticRegression(max_iter=1000)),
        ('rf',  RandomForestClassifier(n_estimators=100, random_state=42)),
        ('svc', SVC(probability=True, kernel='rbf'))
    ],
    voting='soft',   # 'hard': majority vote; 'soft': average probabilities (usually better)
    weights=[1, 2, 1]  # optional: weight models by their quality
)

voting.fit(X_train, y_train)
```

**Hard voting** — each model votes for a class; majority wins.
**Soft voting** — average the predicted probabilities; pick the class with the highest average. Requires all models to support `predict_proba`. Usually better because it accounts for prediction confidence.

---

## 10.16 Stacking

Trains a **meta-learner** (blender) on the out-of-fold predictions of the base models. The meta-learner learns *how to combine* the base predictions optimally.

```python
from sklearn.ensemble import StackingClassifier

stacking = StackingClassifier(
    estimators=[
        ('rf',  RandomForestClassifier(n_estimators=100, random_state=42)),
        ('svc', SVC(probability=True, kernel='rbf')),
        ('lgr', LogisticRegression(max_iter=1000))
    ],
    final_estimator=LogisticRegression(),   # meta-learner
    cv=5,              # base models generate OOF predictions via 5-fold CV
    stack_method='predict_proba',  # 'predict_proba' or 'predict'
    passthrough=False  # if True, pass original features to meta-learner too
)

stacking.fit(X_train, y_train)
```

**Why OOF predictions?** If base models predict on the same data they were trained on, the meta-learner sees over-fitted predictions. Using cross-validation ensures the meta-learner trains on out-of-fold predictions — what the base models will produce on truly unseen data.

---

## 10.17 K-Nearest Neighbours (KNN)

**Intuition:** A **lazy learner** — no training phase at all. To predict a new sample, find its $k$ nearest neighbours in the stored training data and aggregate their labels.

$$\hat{y} = \text{majority\_vote}\left(\{y_j : j \in \text{kNN}(x)\}\right) \quad \text{(classification)}$$
$$\hat{y} = \frac{1}{k}\sum_{j \in \text{kNN}(x)} y_j \quad \text{(regression)}$$

Distance metrics:
- **Euclidean** ($p=2$): $d = \sqrt{\sum_j (x_j - x_j')^2}$ — most common
- **Manhattan** ($p=1$): $d = \sum_j |x_j - x_j'|$ — more robust in high dimensions
- **Minkowski** (general): $d = \left(\sum_j |x_j - x_j'|^p\right)^{1/p}$

```python
from sklearn.neighbors import KNeighborsClassifier, KNeighborsRegressor

knn = KNeighborsClassifier(
    n_neighbors=5,
    metric='minkowski',
    p=2,               # p=2 → Euclidean; p=1 → Manhattan
    weights='uniform', # 'uniform': equal weight; 'distance': closer = more weight
    algorithm='auto',  # 'auto', 'ball_tree', 'kd_tree', 'brute'
    n_jobs=-1
)
```

### Choosing $k$
- Small $k$ (e.g., 1, 3): Very local → captures fine-grained patterns → high variance, sensitive to noise.
- Large $k$ (e.g., 50, 100): Very smooth → high bias, ignores local structure.
- **Rule of thumb:** Start with $k = \sqrt{n}$; tune via CV.

| Hyperparameter | Effect |
|:---|:---|
| `n_neighbors` | Lower → more complex boundary |
| `weights` | `'distance'` helps when nearby points are more relevant |
| `metric` | Euclidean for numeric; Manhattan for sparse/high-dimensional |

> [!IMPORTANT]
> KNN is $O(n)$ at **prediction time** — every new query scans all $n$ training points. For large datasets, use approximate nearest-neighbour libraries (FAISS, Annoy) or `algorithm='ball_tree'`/`'kd_tree'` for exact but faster search. Always scale features first.

---

## 10.18 Naïve Bayes

**Intuition:** Apply Bayes' theorem with the strong ("naïve") assumption that all features are **conditionally independent** given the class.

$$\boxed{P(y|\mathbf{x}) \propto P(y) \prod_{j=1}^{p} P(x_j | y)}$$

$$\hat{y} = \arg\max_y \left[\log P(y) + \sum_j \log P(x_j|y)\right]$$

The log is used to avoid underflow from multiplying many small probabilities.

### Variants by Likelihood Model

| Variant | $P(x_j|y)$ assumption | Use case |
|:---|:---|:---|
| `GaussianNB` | $\mathcal{N}(\mu_{jy}, \sigma_{jy}^2)$ — Gaussian per feature per class | Continuous features |
| `MultinomialNB` | Multinomial distribution over counts | Text classification (word counts, TF-IDF) |
| `BernoulliNB` | Bernoulli (binary 0/1 per feature) | Binary text features (word present/absent) |
| `ComplementNB` | Uses complement class statistics | Imbalanced text classification (often outperforms MultinomialNB) |
| `CategoricalNB` | Categorical distribution per feature | Purely categorical tabular data |

```python
from sklearn.naive_bayes import GaussianNB, MultinomialNB, BernoulliNB, ComplementNB

gnb = GaussianNB(var_smoothing=1e-9)   # adds small variance to prevent zero probabilities
mnb = MultinomialNB(alpha=1.0)         # alpha = Laplace smoothing (prevents zero likelihoods)
bnb = BernoulliNB(alpha=1.0, binarize=0.0)  # binarize: threshold for binary features
```

**Laplace / Additive Smoothing (`alpha`):** If a word never appeared in class $k$ during training, $P(\text{word}|k) = 0$, making the entire product zero. Smoothing adds a small count $\alpha$ to every feature count.

$$P(x_j|y) = \frac{\text{count}(x_j, y) + \alpha}{\text{count}(y) + \alpha \cdot |V|}$$

**Pros:** Extremely fast ($O(np)$ training), works well on small data, naturally multiclass, robust to irrelevant features.
**Cons:** The independence assumption is almost always violated; correlated features cause systematic bias.

---

## 10.19 Multi-Layer Perceptron (MLP)

**Intuition:** A neural network made of layers of neurons. Each neuron computes a weighted sum of its inputs, applies a non-linear activation function, and passes the result to the next layer. By stacking many such layers, the network can approximate any function.

### Architecture

```
Input Layer → [Hidden Layer 1] → [Hidden Layer 2] → ... → Output Layer
   x             h₁ = σ(W₁x + b₁)    h₂ = σ(W₂h₁ + b₂)       ŷ
```

**Forward pass:**
$$\mathbf{h}^{(l)} = \sigma\left(W^{(l)}\mathbf{h}^{(l-1)} + \mathbf{b}^{(l)}\right)$$

### Activation Functions

| Function | Formula | Properties | Use in |
|:---|:---|:---|:---|
| **ReLU** | $\max(0, x)$ | Fast, no vanishing gradient for $x>0$ | Hidden layers (default) |
| **Leaky ReLU** | $\max(0.01x, x)$ | Fixes "dying ReLU" (zero gradient for $x<0$) | Hidden layers |
| **Tanh** | $\frac{e^x - e^{-x}}{e^x + e^{-x}}$ | Output in $(-1, 1)$, zero-centred | Hidden layers (older) |
| **Sigmoid** | $\frac{1}{1+e^{-x}}$ | Output in $(0,1)$ | Binary output layer |
| **Softmax** | $\frac{e^{x_k}}{\sum_j e^{x_j}}$ | Outputs sum to 1 (probability distribution) | Multiclass output layer |
| **Linear / Identity** | $x$ | No non-linearity | Regression output layer |

### Backpropagation
The loss gradient is propagated backward through the chain rule:

$$\frac{\partial L}{\partial W^{(l)}} = \frac{\partial L}{\partial \mathbf{h}^{(l)}} \cdot \frac{\partial \mathbf{h}^{(l)}}{\partial W^{(l)}}$$

This is computed efficiently layer-by-layer using the chain rule. The computed gradients are used by the optimiser to update weights.

### Optimisers

| Optimiser | Update Rule | Notes |
|:---|:---|:---|
| **SGD** | $w \leftarrow w - \eta \nabla L$ | Simple; needs careful lr tuning |
| **SGD + Momentum** | $v \leftarrow \beta v + \nabla L$; $w \leftarrow w - \eta v$ | Smoother convergence |
| **Adam** | Adaptive per-parameter lr using first and second moment estimates | Default for most deep learning; robust |
| **lbfgs** | Quasi-Newton method | Good for small datasets; full-batch |

### `MLPClassifier` / `MLPRegressor`

```python
from sklearn.neural_network import MLPClassifier, MLPRegressor

mlp = MLPClassifier(
    hidden_layer_sizes=(256, 128, 64),  # 3 hidden layers
    activation='relu',          # 'relu', 'tanh', 'logistic', 'identity'
    solver='adam',              # 'adam', 'sgd', 'lbfgs'
    alpha=1e-4,                 # L2 regularisation on weights
    batch_size='auto',          # 'auto' = min(200, n_samples) for adam/sgd
    learning_rate='adaptive',   # 'constant', 'invscaling', 'adaptive' (sgd only)
    learning_rate_init=1e-3,    # initial learning rate
    max_iter=500,
    early_stopping=True,        # hold out 10% of train as validation set
    validation_fraction=0.1,
    n_iter_no_change=10,        # stop if val score doesn't improve for 10 epochs
    random_state=42
)
```

### Key Hyperparameters

| Parameter | Effect |
|:---|:---|
| `hidden_layer_sizes` | Network architecture — more/deeper layers → more capacity |
| `activation` | Non-linearity; `'relu'` is almost always the right default |
| `solver` | `'adam'` for most cases; `'lbfgs'` for small datasets |
| `alpha` | L2 regularisation — controls overfitting |
| `learning_rate_init` | Step size for weight updates |
| `early_stopping` | Prevents overfitting using a validation hold-out |

> [!IMPORTANT]
> MLP is sensitive to **feature scale** — always StandardScale before fitting. Also, initialisation is random — results vary across runs unless `random_state` is fixed. For serious deep learning work, use PyTorch or TensorFlow instead of sklearn's MLP.

---

## 10.20 K-Means Clustering

**Intuition:** Partition $n$ samples into $K$ clusters by iteratively assigning each sample to its nearest centroid and updating centroids.

**Algorithm:**
```
1. Initialise K centroids (randomly or via K-Means++)
2. Repeat until convergence:
   a. Assign each sample to the nearest centroid (Voronoi assignment)
   b. Update each centroid = mean of all samples assigned to it
```

**Objective (Inertia = Within-Cluster Sum of Squares):**
$$J = \sum_{k=1}^{K} \sum_{\mathbf{x} \in C_k} \|\mathbf{x} - \boldsymbol{\mu}_k\|^2$$

**K-Means++ Initialisation:** Instead of random initialisation, choose each subsequent centroid with probability proportional to its squared distance from the nearest already-chosen centroid. This gives better starting points and faster convergence.

```python
from sklearn.cluster import KMeans
import matplotlib.pyplot as plt

km = KMeans(
    n_clusters=5,
    init='k-means++',  # 'k-means++' (smart init) or 'random'
    n_init=10,         # run 10 times with different seeds; keep the best
    max_iter=300,
    tol=1e-4,
    random_state=42
)

km.fit(X_scaled)
labels   = km.labels_          # cluster assignment for each sample
centers  = km.cluster_centers_ # centroid coordinates
inertia  = km.inertia_         # total WCSS

# Predict cluster for new data
new_labels = km.predict(X_new)
```

### Choosing K — Elbow Method
```python
inertias = []
K_range = range(2, 15)
for k in K_range:
    km = KMeans(n_clusters=k, init='k-means++', n_init=10, random_state=42)
    km.fit(X_scaled)
    inertias.append(km.inertia_)

plt.plot(K_range, inertias, 'bo-')
plt.xlabel('K'); plt.ylabel('Inertia'); plt.title('Elbow Method')
# Pick K at the "elbow" — where the rate of decrease slows down sharply
```

### Silhouette Score
Measures how tight and well-separated clusters are. For sample $i$:
$$s(i) = \frac{b(i) - a(i)}{\max(a(i), b(i))}$$
where $a(i)$ = mean distance to other samples in the same cluster, $b(i)$ = mean distance to samples in the nearest different cluster.

Range: $[-1, 1]$; higher is better. $s=1$ → well-clustered; $s=0$ → on boundary; $s<0$ → misassigned.

```python
from sklearn.metrics import silhouette_score, silhouette_samples

# Overall score
sil = silhouette_score(X_scaled, km.labels_)
print(f"Silhouette Score: {sil:.4f}")

# Per-sample scores (plot to identify poorly clustered samples)
sample_sil = silhouette_samples(X_scaled, km.labels_)
```

**Limitations of K-Means:** Assumes spherical clusters of equal size; sensitive to outliers (which pull centroids); must specify $K$ upfront; non-deterministic (use `n_init > 1`).

---

## 10.21 DBSCAN

**Intuition:** Density-Based Spatial Clustering. Groups together samples in dense regions; marks sparse samples as **noise**. Can find arbitrarily shaped clusters; no need to specify $K$.

**Two parameters:**
- `eps` ($\varepsilon$): neighbourhood radius.
- `min_samples`: minimum points in the $\varepsilon$-neighbourhood to be a core point.

**Point types:**
- **Core point:** has $\ge$ `min_samples` points within `eps` (including itself).
- **Border point:** within `eps` of a core point, but not a core point itself.
- **Noise point:** not a core point and not reachable from any core point. Labelled $-1$.

**Cluster formation:** Start at an unvisited core point; expand by density-reachability (recursively add all points within `eps`).

```python
from sklearn.cluster import DBSCAN

db = DBSCAN(
    eps=0.5,          # neighbourhood radius — tune with a k-distance plot
    min_samples=5,    # min points to form a core point
    metric='euclidean',
    n_jobs=-1
)

labels = db.fit_predict(X_scaled)

n_clusters = len(set(labels)) - (1 if -1 in labels else 0)
n_noise    = (labels == -1).sum()
print(f"Clusters: {n_clusters}, Noise points: {n_noise}")
```

### Tuning `eps` — k-Distance Plot
```python
from sklearn.neighbors import NearestNeighbors
import numpy as np

k = 5  # same as min_samples
nbrs = NearestNeighbors(n_neighbors=k).fit(X_scaled)
distances, _ = nbrs.kneighbors(X_scaled)

# Sort the k-th nearest neighbour distances
kth_distances = np.sort(distances[:, -1])[::-1]
plt.plot(kth_distances)
plt.xlabel('Points (sorted)'); plt.ylabel(f'{k}th nearest neighbour distance')
plt.title('k-Distance Graph — pick eps at the "elbow"')
```

| | K-Means | DBSCAN |
|:---|:---|:---|
| Cluster shape | Spherical only | Arbitrary |
| $K$ specification | Required | Not needed |
| Noise handling | None (all assigned) | Labels noise as $-1$ |
| Scalability | $O(nKT)$ — fast | $O(n \log n)$ with index |
| Sensitivity | To outliers (centroid shift) | To `eps`, `min_samples` |

---

## 10.22 Principal Component Analysis (PCA)

**Intuition:** Find the $k$ directions of **maximum variance** in the data. Project the data onto these directions to get a lower-dimensional representation that preserves as much information as possible.

### Algorithm
1. Centre the data: $\tilde{X} = X - \bar{X}$.
2. Compute the covariance matrix: $\Sigma = \frac{1}{n-1}\tilde{X}^T\tilde{X}$.
3. Compute eigenvectors $\mathbf{u}_1, \ldots, \mathbf{u}_p$ and eigenvalues $\lambda_1 \ge \ldots \ge \lambda_p$ of $\Sigma$.
4. The $i$-th principal component = projection onto $\mathbf{u}_i$.
5. Keep top-$k$ eigenvectors: $Z = \tilde{X} \cdot U_k$ where $U_k \in \mathbb{R}^{p \times k}$.

**Explained variance ratio of PC $i$:** $\frac{\lambda_i}{\sum_j \lambda_j}$ — the fraction of total variance captured.

```python
from sklearn.decomposition import PCA
import matplotlib.pyplot as plt
import numpy as np

# Fit PCA
pca = PCA(n_components=None, random_state=42)  # None = keep all components
pca.fit(X_scaled)

# Scree plot — choose k where explained variance levels off
plt.figure(figsize=(8, 4))
plt.plot(np.cumsum(pca.explained_variance_ratio_), 'o-')
plt.xlabel('Number of Components')
plt.ylabel('Cumulative Explained Variance')
plt.axhline(y=0.95, color='r', linestyle='--', label='95% variance')
plt.legend()
plt.title('PCA Scree Plot')

# Apply with chosen k
pca_k = PCA(n_components=0.95)  # keep enough components to explain 95% variance
X_reduced = pca_k.fit_transform(X_scaled)
print(f"Components to explain 95% variance: {pca_k.n_components_}")
print(f"Explained variance ratio: {pca_k.explained_variance_ratio_}")
```

### PCA in a Pipeline
```python
from sklearn.pipeline import Pipeline
from sklearn.preprocessing import StandardScaler
from sklearn.decomposition import PCA
from sklearn.svm import SVC

pipe = Pipeline([
    ('scaler', StandardScaler()),
    ('pca',    PCA(n_components=50)),
    ('model',  SVC(kernel='rbf'))
])
pipe.fit(X_train, y_train)
```

### Use Cases
- **Visualisation:** Compress to 2–3 components for scatter plots.
- **Noise reduction:** Later PCs capture noise more than signal; dropping them denoises data.
- **Speeding up models:** Reduce dimensionality before passing to expensive models.
- **Multicollinearity removal:** PCs are orthogonal by construction.

> [!CAUTION]
> Always **scale before PCA**. A feature with variance 10,000 (e.g., income in rupees) will dominate the first principal component over a feature with variance 1 (e.g., number of children), regardless of which is more informative. After scaling, PCA treats all features equally.

---

# 11. scikit-learn Pipeline API

**Intuition:** A machine learning workflow consists of multiple sequential steps — missing value imputation, scaling, encoding, dimensionality reduction, and finally a model estimator. A **`Pipeline`** chains all these steps into a single composite estimator. It enforces strict separation between training and test sets, preventing data leakage automatically during cross-validation.

---

## 11.1 Why Pipelines Are Essential

Without a Pipeline, you have to manually call `fit_transform()` on training data and `transform()` on test/validation data for every single transformer. This leads to three major issues:

1. **Data Leakage:** Manually scaling or imputing before `cross_val_score` leaks test fold statistics into the training fold.
2. **Code Duplication & Bugs:** Forgetting to apply the exact same transformation sequence during test/inference leads to prediction errors.
3. **Complex Deployment:** You have to save and load 5 different pickle files (imputer.pkl, scaler.pkl, encoder.pkl, model.pkl). A Pipeline packs everything into **1 pickle file**.

---

## 11.2 `Pipeline` vs. `make_pipeline`

`Pipeline` requires explicit step names. `make_pipeline` automatically names steps based on their class names (lowercased).

```python
from sklearn.pipeline import Pipeline, make_pipeline
from sklearn.impute import SimpleImputer
from sklearn.preprocessing import StandardScaler
from sklearn.linear_model import LogisticRegression

# 1. Standard Pipeline (explicit names — best for GridSearchCV)
pipe1 = Pipeline([
    ('imputer', SimpleImputer(strategy='median')),
    ('scaler',  StandardScaler()),
    ('model',   LogisticRegression())
])

# 2. make_pipeline (shorthand — best for quick code)
pipe2 = make_pipeline(
    SimpleImputer(strategy='median'),
    StandardScaler(),
    LogisticRegression()
)
# Automatically names steps: 'simpleimputer', 'standardscaler', 'logisticregression'
```

---

## 11.3 Mixed Data Types: `ColumnTransformer`

Real-world datasets contain a mixture of numeric, nominal categorical, and ordinal categorical columns. `ColumnTransformer` applies separate transformation pipelines to specific column subsets.

```python
from sklearn.compose import ColumnTransformer, make_column_selector
from sklearn.pipeline import Pipeline
from sklearn.impute import SimpleImputer
from sklearn.preprocessing import StandardScaler, OneHotEncoder, OrdinalEncoder
from sklearn.ensemble import RandomForestClassifier

# Define column groups
num_cols = ['age', 'fare', 'family_size']
cat_cols = ['embarked', 'sex']
ord_cols = ['pclass']  # 1, 2, 3

# 1. Numeric pipeline
num_pipe = Pipeline([
    ('imputer', SimpleImputer(strategy='median')),
    ('scaler',  StandardScaler())
])

# 2. Nominal categorical pipeline
cat_pipe = Pipeline([
    ('imputer', SimpleImputer(strategy='most_frequent')),
    ('ohe',     OneHotEncoder(handle_unknown='ignore', sparse_output=False))
])

# 3. Ordinal categorical pipeline
ord_pipe = Pipeline([
    ('imputer', SimpleImputer(strategy='most_frequent')),
    ('ordinal', OrdinalEncoder(categories=[[3, 2, 1]]))  # explicit ordering
])

# Combine into a ColumnTransformer
preprocessor = ColumnTransformer(
    transformers=[
        ('num', num_pipe, num_cols),
        ('cat', cat_pipe, cat_cols),
        ('ord', ord_pipe, ord_cols)
    ],
    remainder='drop'  # 'drop': drop remaining cols; 'passthrough': keep unmentioned cols as-is
)

# Full end-to-end Pipeline
full_pipeline = Pipeline([
    ('preprocessor', preprocessor),
    ('classifier',   RandomForestClassifier(n_estimators=100, random_state=42))
])

# Fit on training data, predict on test data
full_pipeline.fit(X_train, y_train)
y_pred = full_pipeline.predict(X_test)
```

### Dynamic Column Selection with `make_column_selector`
Instead of hardcoding column names, select columns dynamically by data type:

```python
preprocessor = ColumnTransformer(
    transformers=[
        ('num', num_pipe, make_column_selector(dtype_include=['int64', 'float64'])),
        ('cat', cat_pipe, make_column_selector(dtype_include=['object', 'category']))
    ]
)
```

---

## 11.4 Parallel Extraction: `FeatureUnion` vs. `ColumnTransformer`

- **`ColumnTransformer`:** Applies different transformers to **different disjoint subsets of columns** (non-overlapping).
- **`FeatureUnion`:** Applies multiple transformers to the **SAME columns in parallel**, and concatenates their outputs horizontally.

```python
from sklearn.pipeline import FeatureUnion
from sklearn.decomposition import PCA
from sklearn.feature_selection import SelectKBest, f_classif

# Extract both PCA components AND top univariate features from the SAME numeric data
parallel_features = FeatureUnion([
    ('pca',    PCA(n_components=5)),
    ('k_best', SelectKBest(score_func=f_classif, k=5))
])
# Output matrix will have 5 + 5 = 10 features
```

---

## 11.5 Custom Transformers (`BaseEstimator` & `TransformerMixin`)

You can write your own custom transformation step (e.g. outlier clipping, log-transform, custom feature engineering) that integrates seamlessly into a scikit-learn Pipeline.

```python
import numpy as np
import pandas as pd
from sklearn.base import BaseEstimator, TransformerMixin

class OutlierCapper(BaseEstimator, TransformerMixin):
    """Caps numerical features at specified upper and lower quantiles."""
    
    def __init__(self, lower_quantile=0.01, upper_quantile=0.99):
        self.lower_quantile = lower_quantile
        self.upper_quantile = upper_quantile
        
    def fit(self, X, y=None):
        # Compute capping thresholds on training data ONLY
        X_df = pd.DataFrame(X)
        self.lower_bounds_ = X_df.quantile(self.lower_quantile).values
        self.upper_bounds_ = X_df.quantile(self.upper_quantile).values
        return self
        
    def transform(self, X):
        # Clip data using learned thresholds
        X_array = np.asarray(X)
        return np.clip(X_array, self.lower_bounds_, self.upper_bounds_)

# Use inside a Pipeline
custom_pipe = Pipeline([
    ('capper', OutlierCapper(lower_quantile=0.05, upper_quantile=0.95)),
    ('scaler', StandardScaler()),
    ('model',  LogisticRegression())
])
```

> [!NOTE]
> Inheriting from `TransformerMixin` gives you `fit_transform()` for free. Inheriting from `BaseEstimator` gives you `get_params()` and `set_params()` for free, enabling `GridSearchCV` hyperparameter tuning on your custom transformer parameters!

---

## 11.6 Hyperparameter Tuning Inside Pipelines

Use double underscores `__` to traverse nested pipeline steps in `GridSearchCV` or `RandomizedSearchCV`.

```python
from sklearn.model_selection import GridSearchCV
from sklearn.ensemble import RandomForestClassifier
from sklearn.linear_model import LogisticRegression

# Define hyperparameter grid
param_grid = {
    # Tune preprocessing parameters
    'preprocessor__num__imputer__strategy': ['mean', 'median'],
    'preprocessor__num__scaler__with_std':  [True, False],
    
    # Tune model parameters
    'classifier__n_estimators': [100, 200],
    'classifier__max_depth':    [5, 10, None]
}

grid_search = GridSearchCV(full_pipeline, param_grid, cv=5, scoring='f1_weighted', n_jobs=-1)
grid_search.fit(X_train, y_train)

print("Best Parameters:", grid_search.best_params_)
print("Best CV Score:", grid_search.best_score_)
```

### Swapping Model Algorithms Dynamically
You can even pass different classifier instances into `GridSearchCV` to test multiple algorithms inside the same pipeline:

```python
param_grid = [
    {
        'classifier': [RandomForestClassifier(random_state=42)],
        'classifier__n_estimators': [100, 200],
        'classifier__max_depth': [5, 10]
    },
    {
        'classifier': [LogisticRegression(random_state=42)],
        'classifier__C': [0.1, 1.0, 10.0],
        'classifier__solver': ['lbfgs', 'saga']
    }
]

grid_search = GridSearchCV(full_pipeline, param_grid, cv=5, scoring='f1_weighted')
grid_search.fit(X_train, y_train)
```

---

## 11.7 Inspecting Pipeline Steps & Extracting Feature Names

### Accessing Internal Steps
```python
# Access fitted preprocessor step
fitted_preprocessor = full_pipeline.named_steps['preprocessor']

# Access fitted classifier step
fitted_model = full_pipeline.named_steps['classifier']
print("Tree feature importances:", fitted_model.feature_importances_)
```

### Getting Transformed Feature Names (`get_feature_names_out`)
After one-hot encoding, column names change. Extract the exact feature names output by the preprocessor:

```python
# Get transformed feature names
feature_names = full_pipeline.named_steps['preprocessor'].get_feature_names_out()
print(feature_names)
# Output: ['num__age', 'num__fare', 'cat__embarked_C', 'cat__embarked_S', 'cat__sex_female', ...]

# Create a DataFrame of transformed training data for inspection
X_train_transformed = pd.DataFrame(
    full_pipeline.named_steps['preprocessor'].transform(X_train),
    columns=feature_names
)
```

---

## 11.8 Target Transformation: `TransformedTargetRegressor`

A `Pipeline` only transforms features $X$. It **does not transform the target $y$**. If your target $y$ is right-skewed and needs a log-transform ($y \to \log(1+y)$), wrap your pipeline inside `TransformedTargetRegressor`:

```python
import numpy as np
from sklearn.compose import TransformedTargetRegressor
from sklearn.linear_model import Ridge

# Automatically applies log1p to y during fit(), and expm1 to predictions during predict()
tt_model = TransformedTargetRegressor(
    regressor=full_pipeline,
    func=np.log1p,
    inverse_func=np.expm1
)

tt_model.fit(X_train, y_train)
y_pred_original_scale = tt_model.predict(X_test)  # predictions are automatically back on the original scale!
```

---

## 11.9 Common Pipeline Pitfalls & Summary Checklist

| Rule | Explanation |
|:---|:---|
| ❌ **Don't transform target $y$ inside `Pipeline`** | Use `TransformedTargetRegressor` instead. |
| ❌ **Don't drop rows inside a custom Transformer** | Scikit-learn transformers must preserve the row count ($N$). Dropping rows breaks downstream $y$ alignment. |
| ✅ **Always return a 2D array or DataFrame from `transform()`** | Scikit-learn expects 2D outputs `(n_samples, n_features)`. |
| ✅ **Pass `sparse_output=False` to `OneHotEncoder`** | If combining with `StandardScaler` in `ColumnTransformer`, dense arrays avoid sparsity type conflicts. |
| ✅ **Fit on `X_train`, transform on `X_test`** | Never call `.fit()` or `.fit_transform()` on test data. `pipe.predict(X_test)` calls `.transform(X_test)` internally. |

---

# 12. Inference & Deployment Checklist

Once the final model is trained and evaluated:

1. **Retrain on full data** (train + validation) before deployment if you used a hold-out val set.
2. **Save the fitted pipeline** (not just the model — you need the scaler/imputer too).
   ```python
   import joblib
   joblib.dump(pipe, 'model_pipeline.pkl')
   loaded_pipe = joblib.load('model_pipeline.pkl')
   ```
3. **Prediction on new data:**
   ```python
   y_pred = loaded_pipe.predict(X_new)
   y_proba = loaded_pipe.predict_proba(X_new)  # for probability scores
   ```
4. **Check for distribution shift** — monitor whether real-world input features start drifting from the training distribution.
5. **Calibration** — if probabilities matter (not just class labels), check if `predict_proba` is well-calibrated using a calibration curve. Use `CalibratedClassifierCV` if needed.

---

# Appendix — Legacy Notes

## R-squared
$R^2$ is used to quantify how much of variance in the data is explained by a relationship.

$$R^2 = \frac{\operatorname{Var(mean)} - \operatorname{Var(line)}}{\operatorname{Var(mean)}} = 1 - \frac{\operatorname{Var(line)}}{\operatorname{Var(mean)}} = 1 -\frac{\text{RSS}}{\text{TSS}}$$

One major drawback of $R^2$ is that it never decreases as we add more features/predictors to our model. This is why we use **Adjusted R-squared**. See [[Fundamental ML Concepts#R-squared ($R^2$)|full R² section above]].

## Gauss-Markov Assumptions
The Gauss–Markov assumptions are the conditions under which the **Ordinary Least Squares (OLS)** estimator is guaranteed to be **BLUE** (Best Linear Unbiased Estimator). These assumptions only work for OLS estimators and not all regression models.

1. **Linearity** - The model must be linear in the coefficients.
2. **Homoscedasticity** - $\operatorname{Var}(\epsilon|X) = \sigma^2$ must be constant for all values of $X$.
3. **No autocorrelation in errors** - $\operatorname{Cov}(\epsilon_i, \epsilon_j) = 0, \text{for } i \ne j$.
4. **Normality of errors** - $\epsilon \sim N(0, \sigma^2)$. Not needed for BLUE, but needed for t-test, F-test.
5. **No perfect multicollinearity** - $X^TX$ must be invertible.
6. **Exogeneity** - $E[\epsilon|X] = 0$ — omitted factors must not be correlated with features.

## Variance Inflation Factor (VIF)
VIF checks for multicollinearity. Treat each feature as a dependent variable predicted by the others; compute $R_j^2$; then:

$$VIF_j = \frac{1}{1 - R_j^2}$$

If $VIF_j > 10$ or Tolerance $T_j = 1 - R_j^2 < 0.1$, the feature is redundant.