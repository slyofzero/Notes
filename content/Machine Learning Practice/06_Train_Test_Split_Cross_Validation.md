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
