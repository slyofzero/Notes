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
