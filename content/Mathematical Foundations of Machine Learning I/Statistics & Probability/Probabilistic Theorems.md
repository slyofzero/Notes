>[!SUMMARY] Table of Contents
>- [[Probabilistic Theorems#Markov Inequality|Markov Inequality]]
>- [[Probabilistic Theorems#Chebyshev Inequality|Chebyshev Inequality]]
>- [[Probabilistic Theorems#Central Limit Theorem|Central Limit Theorem]]
# Markov Inequality
Suppose we have a distribution of a random variable $X$ with a CDF $F_X$. We are interested in finding the probability of the random variable holding a value greater than some threshold $k$, i.e. $P(X \ge k)$.

Let the distribution of $X$ be split into two groups. 
- Group $X_1$ where $X \ge k$
- Group $X_2$ where $X \lt k$

Due to the linearity of expected value, we can say that

$$
\begin{aligned}
\begin{aligned}
E[X] &= E[X_1] + E[X_2] \\[8pt]
&\ge E[X_1] \\[8pt]
&\ge k \, P(X \ge k) \\[8pt]
\end{aligned} \\[8pt]

\text{Thus, } \boxed{P(X \ge k) \le \frac{E[X]}{k}} &\text{ for } k \ne 0
\end{aligned}
$$

$\underline{\text{Definition}}-$ For any **non-negative random variable** $X$ with a finite $E[X]$ and $k \gt 0$,

$$
P(X \ge k) \le \frac{E[X]}{k}
$$

Markov Inequality gives an exaggerated estimate of the probabilities, especially for tails. At times the upper bound provided by the Markov Inequality can be greater than 1 too.
# Chebyshev Inequality
Consider some $k$-neighbourhood around the mean $\mu$ of some random variable $X$. For any value of $X$ to lie outside this neighbourhood, we can say that it should lie in $|X - \mu| \ge k$.

Because $|X - \mu| \ge k \iff |X - \mu|^2 \ge k^2$, we can say that,
$$
P(|X - \mu| \ge k) = P(|X - \mu|^2 \ge k^2) \tag{1}
$$

Because $|X - \mu|^2$ is a non-negative quantity, we can apply Markov's Inequality on it and state,
$$
P(|X - \mu|^2 \ge k^2) \le \frac{E[|X - \mu|^2]}{k^2}
$$

By definition of [[Random Variables#Variance|variance]], $E[|X - \mu|^2 = E[(X - \mu)^2 = \operatorname{Var}(X)$. Using the equality from $(1)$ we can say that,
$$
\boxed{P(|X - \mu| \ge k) \le \frac{\sigma_X^2}{k^2}}
$$

$\underline{\text{Definition}}-$ For **any real valued random variable** $X$ with mean $\mu$ and variance $\sigma_X^2$, we say that 
$$
P(|X - \mu| \ge k) \le \frac{\sigma_X^2}{k^2}
$$

We can apply this inequality for Normal Distributions and try to find the probability of some value lying beyond some $n\sigma_X$ distance away from the mean $\mu$. For such a case,

$$
\begin{aligned}
P(|X - \mu| \ge n\sigma_X) &\le \frac{\sigma_X^2}{n^2\sigma_X^2} \\[8pt]
&\le \frac{1}{n^2}
\end{aligned}
$$

<h4 class="special">Note -</h4>
Both Markov and Chebyshev's Inequality are independent of the random variable's distribution. All they require are the mean and standard deviation of the distribution.
# Central Limit Theorem
Some definitions -
1. **Population -** The entire set of observations of our interest.
2. **Sample -** A subset of the population.
3. **Population mean -** The mean of the population.
4. **Sample mean -** The mean of each individual sample.

---
$\underline{\text{Definition}}-$ If random samples of $n$ observations are drawn from a population with mean $\mu$ and standard deviation $\sigma$, then for a fairly large $n$ the sample distribution of the sample mean $\bar{x}$ is **approximately normally distributed** with a mean $\mu$ and standard deviation $\frac{\sigma}{\sqrt n}$. As $n$ tends to infinity, this standard deviation becomes really small and the distribution of this sample mean gets increasingly concentrated around $\mu$. ^4a304a

$\qquad \text{OR}$

The sample mean and the sample variance converge to the population mean and variance, respectively, as the sample size increases.

---

Consider repeated individual trials of a random experiment. The outcome of each trial is one observation of the random variable $X$.

Each outcome itself is a random variable and we denote each outcome as $X_i$. Upon carrying out $n$ such trials, we have the sample values of the $n$ R.Vs $X_1, X_2, \dots, X_n$.

Assume that each R.V is independent and identically distributed with
$$
E[X_i] = \mu \qquad \text{and} \qquad \operatorname{Var}(X_i) = \sigma^2 \lt \infty
$$

Let the sample mean $M_n(X)$ be 
$$
M_n(X) = \frac{1}{n}\sum_{i=1}^n X_i
$$

Then as $n \rightarrow \infty$, for the sample mean $M_n(X)$,
$$
E[M_n(X)] = E[X] \qquad\text{and} \qquad \operatorname{Var}(M_n(X)) = \frac{\operatorname{Var}(X)}{n}
$$
