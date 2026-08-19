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
