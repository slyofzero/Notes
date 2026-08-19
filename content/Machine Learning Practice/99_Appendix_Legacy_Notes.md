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
