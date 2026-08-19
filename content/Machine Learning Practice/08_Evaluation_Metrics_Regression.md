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
