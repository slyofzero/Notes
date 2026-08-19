# 1. Exploratory Data Analysis (EDA)

**Intuition:** Before writing a single line of model code, *look at your data*. EDA helps you understand distributions, spot outliers, find relationships between features, and form hypotheses about which models might work.

## 1.1 Key EDA Tasks

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

## 1.2 Mathematical Foundations of EDA

When inspecting distributions and relationships, rely on these formal mathematical metrics:

### A. Covariance and Correlation
- **Covariance:** Measures the joint variability of two variables $X$ and $Y$.
  $$\text{Cov}(X,Y) = \frac{1}{n-1}\sum_{i=1}^{n} (x_i - \bar{x})(y_i - \bar{y})$$
- **Pearson Correlation ($r$):** The normalized covariance, measuring *linear* correlation (bounded between -1 and +1).
  $$r = \frac{\text{Cov}(X,Y)}{\sigma_X \sigma_Y} = \frac{\sum (x_i - \bar{x})(y_i - \bar{y})}{\sqrt{\sum(x_i - \bar{x})^2 \sum(y_i - \bar{y})^2}}$$
- **Spearman Rank Correlation ($\rho$):** Non-parametric measure of *monotonic* relationships. It computes Pearson correlation on the rank values of $X$ and $Y$, making it robust to outliers.
  $$\rho = 1 - \frac{6 \sum d_i^2}{n(n^2 - 1)}$$
  *(where $d_i = \text{rank}(x_i) - \text{rank}(y_i)$)*

### B. Distribution Shape Metrics
- **Skewness:** Measures the asymmetry of the distribution about its mean. Normal distribution has a skewness of 0.
  $$\text{Skewness} = \frac{E[(X-\mu)^3]}{\sigma^3} = \frac{\frac{1}{n}\sum_{i=1}^{n}(x_i - \bar{x})^3}{\left(\sqrt{\frac{1}{n}\sum_{i=1}^{n}(x_i - \bar{x})^2}\right)^3}$$
  - $> 0$: Right-skewed (long tail on the right, e.g., income). Often requires log transform.
  - $< 0$: Left-skewed (long tail on the left).
- **Kurtosis:** Measures the "tailedness" of the distribution. Normal distribution has a kurtosis of 3 (or excess kurtosis of 0).
  $$\text{Kurtosis} = \frac{E[(X-\mu)^4]}{\sigma^4}$$
  - $> 3$: Leptokurtic (heavy tails, more prone to outliers).
  - $< 3$: Platykurtic (light tails).

### C. Variance Inflation Factor (VIF)
Used to detect **Multicollinearity** (when a feature can be linearly predicted by other features).
$$\text{VIF}_j = \frac{1}{1 - R_j^2}$$
*(where $R_j^2$ is the $R^2$ of regressing feature $X_j$ on all other features)*
- **VIF < 5:** Low multicollinearity.
- **VIF > 10:** Severe multicollinearity; consider dropping feature $X_j$ or applying PCA.

## 1.3 What to look for
- **Skewness** — highly skewed features may need log-transform before training.
- **Outliers** — IQR fences: values below $Q_1 - 1.5 \cdot IQR$ or above $Q_3 + 1.5 \cdot IQR$ are suspected outliers.
- **Target leakage** — a feature that encodes the answer (e.g., `loan_approved` predicting `default`) — drop it.

---
