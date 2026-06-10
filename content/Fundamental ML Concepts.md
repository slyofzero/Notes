# R-squared
$R^2$ is used to quantify how much of variance in the data is explained by a relationship. We calculate it by calculating the variance of the data around the mean line and then comparing this variance with the new regression line our model created.

$$
R^2 = \frac{\operatorname{Var(mean)} - \operatorname{Var(line)}}{\operatorname{Var(mean)}} = 1 - \frac{\operatorname{Var(line)}}{\operatorname{Var(mean)}} = 1 -\frac{\text{RSS}}{\text{TSS}}
$$

One major drawback of $R^2$ is that it never decreases as we add more features/predictors to our model. This is a problem because $R^2$ rewards complexity in a model without penalizing it, which might lead to overfitting. An $R^2 = 1$ doesn't mean that the model is extremely good at prediction, it can mean that the model is heavily overfitting. This is why we use **Adjusted R-squared**. 

$$
\text{Adjusted }R^2 = 1 - (1 - R^2) \cdot \frac{m-1}{m-n-1}
$$

where $m =$ number of samples and $n =$ number of features/predictors.
- If a new feature adds noise then the adjusted $R^2$ decreases.
- If a new feature provides new information then the adjusted $R^2$ increases.
- $R_adj^2 \le R^2$ and can even be negative.
# Gauss-Markov Assumptions
The Gauss–Markov assumptions are the conditions under which the **Ordinary Least Squares (OLS)** estimator is guaranteed to be **BLUE** (Best Linear Unbiased Estimator). These assumptions only work for OLS estimators and not all regression models.

So Gauss-Markov assumptions are less about "you must satisfy these" and more about "If OLS stops working well, which assumption failed, and what alternative model should I use?"

1. **Linearity** - The model must be linear in the coefficients.
   
2. **Homoscedasticity** - The variance of errors $(\operatorname{Var}(\epsilon|X) = \sigma^2)$ must be constant for all values of $X$. In the graph below we can see that the spread of the errors is less near the start of $X$ and more near the higher part of $X$.

![[Pasted image 20260610104935.png|450]]

3. **No autocorrelation in errors** - The error made on one observation should not be related to the error made on another observation. Mathematically, $\operatorname{Cov}(\epsilon_i, \epsilon_j) = 0, \text{for } i \ne j$.
   
   This matters because OLS assumes that once you've accounted for the features, the remaining unexplained part is just random noise. If errors are correlated, there is still structure left in the residuals that the model has not captured.
   
4. **Normality of errors -** The normality of errors assumption says that the error term follows a normal distribution $\epsilon \sim N(0, \sigma^2)$. After fitting a regression line through the data, the residual plot should be distributed like a bell curve.
   
   This is NOT needed for the OLS to be BLUE, but is needed for many finite-sampled statistical tests like t-test, F-test, etc. Without normality, the formula for these tests is not valid for small samples.

5. **No perfect multicollinearity** - It is required because OLS needs the matrix $X^TX$ to be invertible. If one feature is an exact linear combination of other features, the regression coefficients are not uniquely identifiable, and OLS cannot produce a unique solution. High multicollinearity does not violate the assumption, but it makes coefficient estimates unstable and increases their variance.
   
   If our goal is to get predictions out of the model then multicollinearity has no affect. However, if our goal is to understand the feature importance given to the features then its a problem.

6. **Exogeneity or no omitted variable bias** - Consider an OLS model which predicts the salary of a person, and one of the features with the highest coefficient is "Education".
   
   In $\text{Salary} = \beta_0 + \beta_1 \text{Education} + \epsilon$ other factors like Ability, Communication Skills, Socio-economic status, Luck, etc. are all contained under $\epsilon$. The exogeneity assumption says that $E[\epsilon|\text{Education}] = 0$ or that the omitted factors are not systematically related to education.
   
   OLS estimates $\beta_1$​ by looking at how $Y$ changes as $X$ changes. But if $X$ is correlated with omitted factors in $\epsilon$, OLS cannot distinguish:
	- the effect of $X$, and
	- the effect of those omitted factors.
# Variance Inflation Factor (VIF)
VIF is typically used to check for multicollinearity in our model. Suppose we have a model like below -

$$
y = \beta_0 + \beta_1x_1 + \beta_2x_2 + \dots
$$

To check if any of the features is highly correlated with the others, we can treat it as the dependent variable and the others as the independent variables which predict the dependent variable.

$$
\begin{aligned}
x_1 &= \alpha_0 + \alpha_2x_2 + \alpha_3x_3 + \dots \\[8pt]
x_2 &= \alpha_0 + \alpha_1x_1 + \alpha_3x_3 + \dots \\[8pt]
\vdots
\end{aligned}
$$

For each such prediction $x_j$ we can calculate the $R_j^2$ to check how much of the variance of the dependent variable is predicted by the independent variables. Using this we calculate the **Tolerance level** $T = 1-R_j^2$ and the VIF $\frac{1}{1-R_j^2}$.

If $T_j \lt 0.1$ or $VIF_j \gt 10$, then we can say that the information present in $x_j$ is already present in the other variables and thus the feature is redundant.
# Confusion Matrix
A confusion matrix shows not just how many predictions are right, but also what kind of errors the model is making.

|          | Pred 0 | Pred 1 |
| :------: | :----: | :----: |
| **Is 0** |   TP   |   FP   |
| **Is 1** |   FN   |   TN   |

- False Positives - Type I error
- False Negatives - Type II error
## Accuracy
Ability of the model to correctly predict samples as the class they belong to.

$$
\text{Accuracy} = \frac{TP + TN}{TP + FP + FN + TN}
$$
## Precision
The precision of the model corresponds to the ability of the model to predict a class correctly.
- If the data has 10 samples corresponding to class 1 and the model is correctly predicting 8 of these samples, the precision of the model for class 1 is 0.8.

$$
\text{Precision} = \frac{TP}{TP + FP}
$$
## Recall
The recall of the model corresponds to how many of the samples predicted as a class truly belong to that class.
- If the model predicts that 9 samples belong to class 1 and out of this only 3 actually belong to class 1, then the recall of the model is 0.33.

$$
\text{Precision} = \frac{TP}{TP + FN}
$$
## F score
In cases like Spam detection the precision of the model is a more important metric as we are more interested in knowing how many correct predictions did the model make. In cases like Cancer-Detection the recall of the model is a more important metric as we don't want someone with cancer to be diagnosed as healthy and vice-versa.

In certain cases we need a mix of both the metrics to get an idea of our model's performance. This is where F-$\beta$ score comes in handy.

$$
F\beta \text{ score} = (1+\beta^2) \cdot \frac{\text{Precision} * \text{Recall}}{\beta *\text{Precision} + \text{Recall}}
$$

If $\beta=1$ we call it the F1 score,

$$
F\beta \text{ score} = 2 \cdot \frac{\text{Precision} * \text{Recall}}{\text{Precision} + \text{Recall}}
$$

- We keep $\beta \gt 1$ if we want Recall to be given more weight. 
	- In case of Cancer-Detection we'd use F2-score.
- We keep $\beta \lt 1$ if we want Precision to be given more weight. 
	- In case of Spam-Detection we'd use F0.2-score.