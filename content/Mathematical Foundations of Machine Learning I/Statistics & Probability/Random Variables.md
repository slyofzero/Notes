>[!SUMMARY] Table of Contents
>- [[Random Variables#Probability Distribution|Probability Distribution]]
>- [[Random Variables#Discrete Random Variable|Discrete Random Variable]]
>	- [[Random Variables#Probability Mass Function|Probability Mass Function]]
>	- [[Random Variables#Important Discrete Random Variables|Important Discrete Random Variables]]
>		- [[Random Variables#Bernoulli Random Variable|Bernoulli Random Variable]]
>		- [[Random Variables#Binomial Random Variable|Binomial Random Variable]]
>		- [[Random Variables#Geometric Random Variable|Geometric Random Variable]]
>		- [[Random Variables#Equally Likely Random Variable|Equally Likely Random Variable]]
>		- [[Random Variables#Poisson Random Variable|Poisson Random Variable]]
>- [[Random Variables#Continuous Random Variable|Continuous Random Variable]]
>	- [[Random Variables#Probability Density Function|Probability Density Function]]
>	- [[Random Variables#Important Continuous Random Variables|Important Continuous Random Variables]]
>		- [[Random Variables#Uniform Random Variable|Uniform Random Variable]]
>		- [[Random Variables#Exponential Random Variable|Exponential Random Variable]]
>		- [[Random Variables#Gaussian/Normal Distribution|Gaussian/Normal Distribution]]

A random variable is a function which associates every outcome of a random experiment to some real number. This real number is used to denote a "reward" for every outcome.

$\mathcal X$ is a random variable if,

$$
\forall w \in \Omega,\,\,\mathcal X:\Omega \rightarrow \mathbb R
$$

**Range -** The range of a random variable is the set of values the random variable can take.
# Probability Distribution
A probability distribution describes the probability of the outcomes of a random experiment.
# Discrete Random Variable
$\mathcal X$ is a Discrete Random Variable if its range is a countable set (finite set or countably infinite set).
## Probability Mass Function
The probability mass function assigns a probability to each possible value of the discrete random variable.

$$
P(\mathcal X=x_i) = p_{\mathcal X}(x_i)
$$

Here $p_x$ is the probability mass function of $\mathcal X$.

Properties -

1. 
$$
0 \le p_{\mathcal X}(x_i) \le 1
$$

2. 
$$
\begin{aligned}
&\sum_{i=1}^n p_{\mathcal X}(x_i) = 1 &\qquad ,\text{if $\mathcal X$ has a finite range} \\[8pt]
&\sum_{i=1}^\infty p_{\mathcal X}(x_i) = 1 &\qquad ,\text{if $\mathcal X$ has a countably infinite range} \\[8pt]
\end{aligned}
$$

3. 
$$
P(\mathcal X = A) = \sum_{i;x_i \in A}p_{\mathcal X}(x_i)
$$

## Important Discrete Random Variables
### Bernoulli Random Variable
A Bernoulli random variable is a discrete random variable that takes values 0 and 1, representing failure and success respectively.

If $P(X = \text{Success})=p$, then $P(X = \text{Failure})=1-p$. A random variable being a Bernoulli Random Variable is denoted by

$$
X \sim \operatorname{Bernoulli}(p)
$$

where $p$ is the probability of success.
### Binomial Random Variable
A Binomial random variable counts the number of successes of $n$ **independent and identically distributed** Bernoulli trials.

A random variable being a Bernoulli Random Variable is denoted by

$$
X \sim \operatorname{Binomial}(n,p)
$$

where $n$ is the number of Bernoulli trials and $p$ is the probability of success.

Repeated Bernoulli trials are repeated multiple time, we would be interested in the probability of achieving exactly some $k$ successes. The probability of $k$ successes in a sequence of $n$ events would be $p^k(1-p)^{n-k}$. There can be $^nC_k$ number of such sequences where $k$ successes occur, each with the same probability of $p^k(1-p)^{n-k}$. Thus the total probability ends up being -

$$
P(\mathcal X=k) = \,{}^nC_k \cdot p^k (1-p)^{(n-k)}
$$

Requirements -
1. Associated with random experiments with only two outcomes (Trials must be Bernoulli trials).
2. Finite number of trials, $n$.
3. Probability of success = $p$, Probability of failure = $1-p$.
4. Trials must be **independent**.
5. The probability distribution of success and failure across the trials should remain **identical**.
### Geometric Random Variable
A Geometric random variable counts the number of independent and identical Bernoulli trials needed until the first success occurs.

A random variable being a Bernoulli Random Variable is denoted by

$$
X \sim \operatorname{Geometric}(p)
$$

where $p$ is the probability of success.

The random variable holding some value $k$ means that the first success occurs after $k$ trials. The probability of the random variable can be written as -

$$
P(\mathcal X = k) = \begin{cases}
p(1-p)^{k-1} & ,\text{if }k=1,2,\dots \\
0 & ,\text{otherwise} \\
\end{cases}
$$

Requirements -
1. Keep doing trials until the first success occurs.
2. All trials must be **independent**.
3. Probability distribution of success and failure must be **identical** across all trials.
### Equally Likely Random Variable
A random variable is an equally likely random variable if all possible values of the random variable have the same probability.

$$
\begin{aligned}
&\mathcal X \sim \operatorname{Equally Likely(N)} \\[8pt]
&P(\mathcal X = x_i) = \frac{1}{N}, \qquad\forall i=1,2,\dots,N
\end{aligned}
$$

This is also called as the **uniform discrete random variable**.
### Poisson Random Variable
A Poisson random variable counts the **number of events occurring in a fixed interval** of time/space when -
1. Events occur **independently**.
2. The average rate $\lambda \gt 0$ is a constant.
3. Two events do no occur at exactly the same interval.

$$
\begin{aligned}
&\mathcal X \sim \operatorname{Poisson(\lambda)} \\[8pt]
&P(\mathcal X = k) = e^{-\lambda}\frac{\lambda^r}{r!}, \qquad r=0,1,2,\dots
\end{aligned}
$$

Here $\lambda$ is the average arrival rate and is $\gt 0$.
# Continuous Random Variable
$\mathcal X$ is a Continuous Random Variable if its range is an interval. Any interval $[a,b]$ is an uncountably infinite set. Thus $P(\mathcal X = x_0)=0$ because of the reasoning given [[Probability#^6f2985|here]].

This is why we talk about probability around some $\triangle x$ neighbourhood of $x_0$ and not at $x_0$. The probability around some $\triangle x$ neighbourhood of $x_0$ is **literally just the area under the curve** from $x-\frac{\triangle x}{2}$ to $x+\frac{\triangle x}{2}$.

$$
P\left(x-\frac{\triangle x}{2} \le x+\frac{\triangle x}{2} \right) = \int_{x-\frac{\triangle x}{2}}^{x+\frac{\triangle x}{2}} f_{\mathcal X}(x) dx
$$
## Probability Density Function
The probability density function is the probability distribution of a continuous random variable, where the probabilities are obtaining by integrating the function over the interval.

Here $f_{\mathcal X}(x)$ is called the **probability density function**. Properties of PDF -
1. The area under the probability density curve for the entire interval $[a,b]$ is 1.
$$
\int_{a}^b f_{\mathcal X}(x) dx = 1
$$

2. $f_{\mathcal X}(x) \ge 0$ for all $x$.
3. Probability of an interval $A$ is $\int_A f_{\mathcal X}(x) dx$.
## Important Continuous Random Variables
### Uniform Random Variable
A uniform random variable is a continuous random variable whose probability density function is constant for all $x$ in the interval.

If the interval is $[a,b]$ it is denoted by $X \sim \operatorname{Uniform}(a,b)$. As the PDF is a constant, we can say $f_{\mathcal X}(x) = c$, where $c$ is unknown.

$$
\begin{alignedat}{3}
&&\int_a^bf_{\mathcal X}(x)dx &= 1 \\[8pt]
&\Rightarrow &\int_a^b c\,\,dx &= 1 \\[8pt]
&\Rightarrow &c\,(b-a)&= 1 \\[8pt]
&\Rightarrow &c&= \frac{1}{b-a} \\[8pt]
\end{alignedat}
$$

Thus,
$$
f_{\mathcal X}(x) =
\begin{cases}
&\frac{1}{b-a} &,\text{if } a\le b \\[8pt]
&0 &,\text{otherwise}
\end{cases}
$$

This is a continuous analog of the [[Random Variables#Equally Likely Random Variable|Equally Likely Random Variable]].
### Exponential Random Variable
An exponential random variable models the waiting time until the first occurrence of an event in a process with a constant rate.

A continuous random variable is exponentially distributed if its probability density function is -

$$
\begin{aligned}
&\mathcal X \sim \operatorname{Exponential}(\lambda) \\[8pt]
&f_{\mathcal X}(x) =
\begin{cases}
&\lambda e^{-\lambda x} &,\text{if } x\ge 0 \\[8pt]
&0 &,\text{otherwise}
\end{cases}
\end{aligned}
$$

Here $\lambda$ is the rate of occurrence of events and is always $\gt$ 0.

This is a continuous analog of the [[Random Variables#Geometric Random Variable|Geometric Random Variable]].
### Gaussian/Normal Distribution
A Normal Distribution is a continuous distribution where -

$$
\begin{aligned}
&\mathcal X \sim \mathcal N(\mu, \sigma^2) \\[8pt]
&f_{\mathcal X}(x) = \frac{1}{\sigma \sqrt{2 \pi}}\,\operatorname{exp}\left(-\frac{(x-\mu)^2}{2\sigma^2}\right) \qquad, \text{where } -\infty \lt x \lt \infty
\end{aligned}
$$
# Cumulative Distribution
The cumulative distribution of a random variable represents the probability accumulated up to $x$.

$$
F_{\mathcal X}(x) = P(\mathcal X \le x)
$$

Properties -
1. $0 \le F_{\mathcal X}(a) \le 1$, $\forall x \in \operatorname{range}(\mathcal X)$
2. $F_{\mathcal X}(-\infty)=0$
3. $F_{\mathcal X}(\infty)=1$
4. 
$$
\begin{aligned}
P(a \le x \le b) &= P(x \le b) - P(x \le a) \\[8pt]
&= F_{\mathcal X}(b) - F_{\mathcal X}(a)
\end{aligned}
$$

5. $F_{\mathcal X}$ is a non-decreasing function. The graph of $F_{\mathcal X}(x)$ would look like -
	- Step Function for Discrete Random Variable.
	- Sigmoid Function for Continuous Random Variable.
6. $F_{\mathcal X}$ is only right continuous as approaching from left can get stuck at a "jump" in CDF of discrete random variable. This jump is $P_{\mathcal X}(x)$ for that point. We can say that -
$$
P_{\mathcal X}(x) = F_{\mathcal X}(x^+) - F_{\mathcal X}(x^-)
$$

7. CDF always exists irrespective of whether the random variable is discrete or continuous. PDF doesn't exist for discrete random variables, and PMF doesn't exist for continuous random variables.
# Expected Value of a Random Variable
The expected value of a random variable is the average of all outcomes achieved by performing a large number of experimental trials.

$$
\begin{aligned}
E[\mathcal X] &= \sum_{i=1}^n x_i\,P(x_i) &\qquad \text{For Discrete R.V} \\[8pt]
&= \int_{-\infty}^\infty x\,f_{\mathcal X}(x)dx &\qquad \text{For Continuous R.V} \\[8pt]
\end{aligned}
$$

The expected values for the popular distributions are -

| Distribution | Expected Value |
| :----------: | :------------: |
|  Bernoulli   |      $p$       |
|   Binomial   |      $np$      |
|  Geometric   |     $1/p$      |
|   Poisson    |   $\lambda$    |
|   Uniform    |   $(b+a)/2$    |
| Exponential  |  $1/\lambda$   |
|   Gaussian   |     $\mu$      |
These can be obtained by applying the above formulas and simplifying the equations.

Properties of $E[\mathcal X]$ -
1. $E[\mathcal X]$ doesn't generally indicate the most probable value of $\mathcal X$.
2. $E[a \mathcal X] = aE[\mathcal X]$, if $a$ is a scalar.
3. $E[\mathcal X + \mathcal Y] = E[\mathcal X] + E[\mathcal Y]$
4. $E[a]=a$, if $a$ is a scalar.
5. $E[a \mathcal X + b] = aE[\mathcal X] + b$

<h4 class="special">E[X] is the best predictor of outcome of an experiment.</h4>

Suppose the outcome of a random experiment is $b$ and let $\mathcal X$ be the random variable. On an average, we'd like $b$ to be as close to the true outcome of $\mathcal X$. So we want to minimize $(\mathcal X - b)^2$.

$$
\begin{alignedat}{3}
&&\operatorname{MSE}(b) &= E[(\mathcal X - b)^2] \\[8pt]
&&&= E[\mathcal X^2] - 2bE[\mathcal X] + b^2 \\[8pt]
&&\frac{d\text{MSE}}{db} &= 2b - 2E[\mathcal X] \\[8pt]
\end{alignedat}
$$

For $\frac{d\text{MSE}}{db}$ to be 0, $b=E[\mathcal X]$. Thus $E[\mathcal X]$ is the best predictor.
## Raw Moments
The raw moments for a random variable $\mathcal X$ are calculated by doing -

$$
\begin{aligned}
E[(\mathcal X - c)^n] &= \sum_{i=1}^n(x_i-c)^n\,\,p_{\mathcal X}(x_i) \\[8pt]
&= \int_{-\infty}^\infty(x_i-c)^n\,\,f_{\mathcal X}(x)\,dx
\end{aligned}
$$

- If $n=1$, then the moment $E[\mathcal X - c]$ measures the "center of mass" around $c$.
- If $n=2$, then the moment $E[(\mathcal X - c)^2]$ measures the spread of values of $\mathcal X$ around $c$.
- Only difference the value of $n$ makes is whether $n$ is odd or even and how large is $n$. Larger values of $n$ will emphasis more on the "tails" of the distribution of $\mathcal X$.
- If $n$ is **odd** and not 1, then the moment $E[(\mathcal X - c)^n]$ measures the symmetry of $\mathcal X$ around $c$.
- If $n$ is **even** and not 2, then the moment $E[(\mathcal X - c)^n]$ measures the heaviness of the tails of $\mathcal X$ from $c$.

$E[(\mathcal X - \mu)^n]$ is known as the $n^{th}$ central moment with $c=\mu$. "Central" because the mean of $\mathcal X - \mu$ is 0.

Important moments -
1. The **first moment around the origin** $c=0$ is known as the **mean** $\mu$.
2. The **second central moment** is known as the **variance** $\sigma_{\mathcal X}^2$.
3. The **fourth central moment** is known as the **kurtosis**.
# Variance
The variance $\sigma_{\mathcal X}^2$ of a random variable measures the spread of the values of the random variable. The square root of the variance $\sigma_{\mathcal X}$ is called the **standard deviation**.

Properties of $\sigma_{\mathcal X}^2$ -
1. 
$$
\begin{aligned}
\operatorname{Var}(\mathcal X) &= E[(\mathcal X - \mu)^2] \\[8pt]
&= E[\mathcal X^2-2\mu\mathcal X + \mu^2] \\[8pt]
&= E[\mathcal X^2]-2E[\mu\mathcal X] + E[\mu^2] \\[8pt]
&= E[\mathcal X^2]-2\mu E[\mathcal X] + \mu^2 \\[8pt]
&= E[\mathcal X^2]-2\mu^2 + \mu^2 \\[8pt]
&= E[\mathcal X^2]-\mu^2 \\[8pt]
&= \boxed{E[\mathcal X^2]-E[\mathcal X]^2} \\[8pt]
\end{aligned}
$$

2. $\operatorname{Var}(b)=0$, if $b$ is a constant.
3. $\operatorname{Var}(\mathcal X) \ge 0$ as the variance is the expected value of a squared quantity.
4. $\operatorname{Var}(a\mathcal X + b)=a^2\operatorname{Var}(\mathcal X)$.

The variance for the popular distributions are -

| Distribution |     Expected Value      |
| :----------: | :---------------------: |
|  Bernoulli   |        $p(1-p)$         |
|   Binomial   |        $np(1-p)$        |
|  Geometric   |        $1-p/p^2$        |
|   Poisson    |        $\lambda$        |
|   Uniform    |      $(b-a)^2/12$       |
| Exponential  |      $1/\lambda^2$      |
|   Gaussian   | $\sigma_{\mathcal X}^2$ |
These can be obtained by applying the above formulas and simplifying the equations.