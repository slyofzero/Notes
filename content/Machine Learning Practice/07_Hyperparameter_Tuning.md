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
