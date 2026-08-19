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

The most widely used rule-of-thumb. Does not assume normality, but is often calibrated against the normal distribution.

$$Q_1 = \text{25th percentile}, \quad Q_3 = \text{75th percentile}, \quad IQR = Q_3 - Q_1$$

$$\text{Lower fence} = Q_1 - 1.5 \cdot IQR \qquad \text{Upper fence} = Q_3 + 1.5 \cdot IQR$$

**Mathematical Insight:** If $X \sim \mathcal{N}(\mu, \sigma^2)$, then $Q_1 \approx -0.675\sigma$ and $Q_3 \approx +0.675\sigma$. 
Thus, $IQR \approx 1.35\sigma$. 
The fences correspond to:
$$\pm (0.675\sigma + 1.5 \times 1.35\sigma) = \pm 2.698\sigma$$
For a perfectly normal distribution, points fall outside these fences with probability $\approx 0.007$ (0.7%). Using **3.0** instead of **1.5** extends fences to $\pm 4.725\sigma$, defining "extreme" outliers.

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

**Mathematical Insight:** Under $X \sim \mathcal{N}(\mu, \sigma^2)$, the probability of observing $|Z| > 3$ is purely governed by the standard normal CDF $\Phi$:
$$P(|Z| > 3) = 2 \times (1 - \Phi(3)) \approx 0.0027 \text{ (or } 0.27\%)$$

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
Uses the **Median Absolute Deviation (MAD)** instead of mean/std, making it robust to the masking effect (its breakdown point is 50%, meaning half the data can be outliers and it still works).

$$\text{MAD} = \text{median}(|x_i - \tilde{x}|)$$
$$M_i = \frac{0.6745 \cdot (x_i - \tilde{x})}{\text{MAD}}$$

**Mathematical Insight:** Why the constant $0.6745$? 
For a normal distribution, the standard deviation $\sigma \approx 1.4826 \times \text{MAD}$. 
Notice that $1 / 1.4826 \approx 0.6745$. This scaling factor aligns the Modified Z-score with the standard Z-score under normality.
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
