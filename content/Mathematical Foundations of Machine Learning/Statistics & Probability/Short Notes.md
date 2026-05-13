# Basic Definitions
1. **Probability -** Study of uncertainty around anything.

2. **Random Experiment -** An experiment whose set of all possible outcomes is known, but the outcome of any trial is unknown until the trial is conducted.

3. **Sample Space -** Set of all possible outcomes of a random experiment.

4. **Event -** A set of outcomes of the random experiment. A subset of the sample space.

5. **Trial -** One repetition of a random experiment.
# Types of Events
1. **Independent Events -** Set of events where occurrence of one event has no affect on occurrence of another.

2. **Dependent Events -** Set of events where occurrence of one event has some effect on occurrence of another.

3. **Mutually Exclusive Events -** Set of events where occurrence of one event guarantees that other events in the sample space won't occur.
# Conditional Probability
1. **Conditional Probability -** Probability of one event occurring given that another has occurred.

$$
P(A|B) = \frac{P(A \cap B)}{P(B)}
$$

2. **Total Probability Theorem -** The probability of one event is the sum of intersections of that event and partitions of the sample space.

$$
\begin{aligned}
P(B) &= \sum_{i=1}^nP(A \cap B) \\[8pt]
P(B) &= \sum_{i=1}^nP(B|A_i)P(A_i)
\end{aligned}
$$

3. **Bayes Theorem -** It tells us how knowing the $P(H|D)$ and $P(D|H)$ are related.

$$
\begin{aligned}
P(H|D) &= \frac{P(D|H) \cdot P(H)}{P(D)} \\[8pt]
\text{Posterior} &= \frac{\text{Likelihood} \cdot \text{Prior}}{\text{Evidence}}
\end{aligned}
$$
Here -
- **Prior** $P(H)$ means probability of the hypothesis before seeing the data.
- **Likelihood** $P(D|H)$ means how likely is the data if the hypothesis is true.
- Evidence $P(D)$ means the probability of the data.
- **Posterior** - $P(B|A)$ means probability of the hypothesis after seeing the data.
# Random Variable
1. **Random Variable -** A real number associated to every outcome of a random experiment.

2. **Range of a random variable** - The set of values a random variable can hold.

3. **Discrete Random Variable -** Random variable whose range is a finite or countably infinite set.

4. **Continuous Random Variable -** Random variable whose range is an uncountably infinite set.
# Probability Distributions
1. **Probability Distribution -** Describes the probability of a random variable holding a value.

2. **Probability Mass Function -** A function which describes how probability is distributed over the values of a continuous random variable.

3. **Cumulative Distribution -** A function which describes the probability of the random variable holding any value less than some $x$. It holds the accumulated probabilities till $x$.

4. **Independent and Identically Distributed -** Events are i.i.d. if occurrence of one doesn't affect the occurrence of another and the probabilities of both events is the same.

General distributions -
1. **Bernoulli Distribution -** The probability distribution where success has a probability of $p$ and failure has a probability of $1-p$.
$$
\begin{aligned}
X &\sim \operatorname{Bernoulli}(p) \\[8pt]
P(\mathcal X) &= 
\begin{cases}
p & ,\text{if }k=1 \\
1-p & ,\text{otherwise} \\
\end{cases}
\end{aligned}
$$

2. **Binomial Distribution -** The probability of achieving $k$ successes upon performing $n$ i.i.d. Bernoulli trials.
$$
\begin{aligned}
X &\sim \operatorname{Binomial}(n,p) \\[8pt]
P(\mathcal X=k) &= \,{}^nC_k \cdot p^k (1-p)^{(n-k)}
\end{aligned}
$$

3. **Geometric Distribution -** The probability of achieving the first success after $k-1$ failures upon performing $n$ i.i.d. Bernoulli trials.
$$
\begin{aligned}
X &\sim \operatorname{Geometric}(p) \\[8pt]
P(\mathcal X = k) &= \begin{cases}
p(1-p)^{k-1} & ,\text{if }k=1,2,\dots \\
0 & ,\text{otherwise} \\
\end{cases}
\end{aligned}
$$

4. **Poisson Distribution -** The probability of a number of events occurring in a fixed interval given the average rate of events.
$$
\begin{aligned}
&\mathcal X \sim \operatorname{Poisson(\lambda)} \\[8pt]
&P(\mathcal X = k) = e^{-\lambda}\frac{\lambda^k}{k!}, \qquad k=0,1,2,\dots
\end{aligned}
$$

5. **Equally Likely Distribution -** Probability of a discrete R.V. where the probabilities of each event occurring is equal.
$$
\begin{aligned}
&\mathcal X \sim \operatorname{Equally Likely(N)} \\[8pt]
&P(\mathcal X = x_i) = \frac{1}{N}, \qquad\forall i=1,2,\dots,N
\end{aligned}
$$

6. **Uniform Distribution -** A probability distribution with a constant probability density over a fixed interval.
$$
\begin{aligned}
\mathcal X &\sim \operatorname{Uniform}(a,b) \\[8pt]
f_{\mathcal X}(x) &=
\begin{cases}
&\frac{1}{b-a} &,\text{if } a\le b \\[8pt]
&0 &,\text{otherwise}
\end{cases}
\end{aligned}
$$

7. **Exponential Distribution -** A probability distribution which models the time until the first event occurs.
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

8. **Normal/Gaussian Distribution -** A probability distribution in which values are **symmetrically distributed about the mean**, with most observations clustering near the mean and fewer occurring as we move away from it.
$$
\begin{aligned}
&\mathcal X \sim \mathcal N(\mu, \sigma^2) \\[8pt]
&f_{\mathcal X}(x) = \frac{1}{\sigma \sqrt{2 \pi}}\,\operatorname{exp}\left(-\frac{(x-\mu)^2}{2\sigma^2}\right) \qquad, \text{where } -\infty \lt x \lt \infty
\end{aligned}
$$
# Expected Values and Variance
1. **Expected Value** - The average of all outcomes of a random variable if the experiment is conducted a large number of times.

$$
\begin{aligned}
E[\mathcal X] &= \sum_{i=1}^n x_i\,P(x_i) &\qquad \text{For Discrete R.V} \\[8pt]
&= \int_{-\infty}^\infty x\,f_{\mathcal X}(x)dx &\qquad \text{For Continuous R.V} \\[8pt]
\end{aligned}
$$

2. The expected values for the popular distributions are -

| Distribution | Expected Value |
| :----------: | :------------: |
|  Bernoulli   |      $p$       |
|   Binomial   |      $np$      |
|  Geometric   |     $1/p$      |
|   Poisson    |   $\lambda$    |
|   Uniform    |   $(b+a)/2$    |
| Exponential  |  $1/\lambda$   |
|   Gaussian   |     $\mu$      |

3. 
	- **Mean -** The expected value of a random variable.
	- **Variance -** The spread of the values of a random variable around the mean.

$$
\begin{aligned}
\operatorname{Var}(\mathcal X) &= E[\mathcal X^2]-E[\mathcal X]^2
\end{aligned}
$$

The variance for the popular distributions are -

| Distribution |     Expected Value      |
| :----------: | :---------------------: |
|  Bernoulli   |        $p(1-p)$         |
|   Binomial   |        $np(1-p)$        |
|  Geometric   |       $(1-p)/p^2$       |
|   Poisson    |        $\lambda$        |
|   Uniform    |      $(b-a)^2/12$       |
| Exponential  |      $1/\lambda^2$      |
|   Gaussian   | $\sigma_{\mathcal X}^2$ |
# Joint Distribution
1. **Joint Distribution -** The joint distribution of multiple random variables is the probability associated to all possible permutation of values the random variables hold simultaneously.

2. **Marginal Distribution -** The probability distribution of one random variable holding a fixed value over all possible values for the rest of the random variable is called the margin distribution for that random variable.

Discrete Marginals -

$$
\begin{aligned}
\sum_{j} p_{\mathcal X \mathcal Y}(x_i,y_j) &= p_{\mathcal X}(x_i) \\[8pt]
\sum_{i} p_{\mathcal X \mathcal Y}(x_i,y_j) &= p_{\mathcal Y}(y_j) \\[8pt]
\end{aligned}
$$

Continuous Marginals -

$$
\begin{aligned}
\int_{y-\triangle y}^{y+\triangle y} f_{\mathcal X \mathcal Y}(x_i,y_j)\,dy &= f_{\mathcal X}(x_i) \\[8pt]
\int_{x-\triangle x}^{x+\triangle x} f_{\mathcal X \mathcal Y}(x_i,y_j)\,dx &= f_{\mathcal Y}(y_j) \\[8pt]
\end{aligned}
$$

3. **Expected Value -** $E[XY]=E[X]E[Y]$ only when $X,Y$ are independent.

4. **Variance -** $\operatorname{Var}(XY)=\operatorname{Var}(X)+\operatorname{Var}(Y)-2\operatorname{Cov}(XY)$ only when $X,Y$ are independent.

5. **Joint Cumulative Distribution** - The joint cumulative distribution function tells the probability of a set of random variables holding values less than or equal to some threshold.

6. **Joint Moments -**
$$
\begin{aligned}
E[\mathcal X^m\mathcal Y^n] &=  \sum_i\sum_j (x_i-c_1)^m (y_j-c_2)^n P_{\mathcal{XY}}(x_i,y_j)  &\qquad(\text{For Discrete})\\[8pt]
E[\mathcal X^m\mathcal Y^n] &=  \int_{-\infty}^\infty \int_{-\infty}^\infty (x_i-c_1)^m (y_j-c_2)^n f_{\mathcal{XY}}(x_i,y_j) \,dy\,dx &\qquad(\text{For Continuous})\\
\end{aligned}
$$
# Covariance
1. **Covariance -** $\operatorname{Cov}(XY) = E[XY] - E[X]E[Y]$

2. **Correlation -** 
$$
\begin{aligned}
\rho_{\mathcal{XY}} &= \frac{\operatorname{Cov}(\mathcal{X,Y})}{\sigma_{\mathcal X}\sigma_{\mathcal Y}} \\[8pt]
&= E\left[\frac{\mathcal X - E[\mathcal X]}{\sigma_{\mathcal X}}\right] \cdot E\left[\frac{\mathcal Y - E[\mathcal Y]}{\sigma_{\mathcal Y}}\right] \\[8pt]
\end{aligned}
$$



If $\mathcal X$ and $\mathcal Y$ are independent, $\mathcal X$ and $\mathcal Y$ are uncorrelated. But if $\mathcal X$ and $\mathcal Y$ are uncorrelated, that doesn't mean $\mathcal X$ and $\mathcal Y$ are independent.

But if $\mathcal X$ and $\mathcal Y$ are two Uncorrelated Gaussian Random Variables, both are always independent.
# Joint Conditional Probability
$$
\begin{aligned}
p_{\mathcal Y |\mathcal X}(y_j|x_i) &= \frac{p_{\mathcal{X,Y}}(x_i,y_j)}{p_{\mathcal X}(x_i)} \\[8pt]
\end{aligned}
$$

Using this we can rewrite the Bayes Theorem w.r.t joint probability.

$$
\begin{aligned}
p_{\mathcal Y |\mathcal X}(y_j|x_i) &= \frac{p_{\mathcal{X|Y}}(x_i|y_j) \cdot p_{\mathcal Y}(y_j)}{\sum_{j}p_{\mathcal{X|Y}}(x_i|y_j) \cdot p_{\mathcal Y}(y_j)} &\qquad(\text{For Discrete}) \\[8pt]

f_{\mathcal Y |\mathcal X}(y_j|x_i) &= \frac{f_{\mathcal{X|Y}}(x_i|y_j) \cdot f_{\mathcal Y}(y_j)}{\int_{-\infty}^\infty f_{\mathcal{X|Y}}(x_i|y_j) \cdot f_{\mathcal Y}(y_j)\,\, dy} &\qquad(\text{For Continuous}) \\[8pt]
\end{aligned}
$$
# Theorems
1. **Markov Inequality -** For any **non-negative random variable** $X$ with a finite $E[X]$ and $k \gt 0$,

$$
P(X \ge k) \le \frac{E[X]}{k}
$$

Markov Inequality gives an exaggerated estimate of the probabilities, especially for tails. At times the upper bound provided by the Markov Inequality can be greater than 1 too.

2. **Chebyshev's Inequality -** For **any real valued random variable** $X$ with mean $\mu$ and variance $\sigma_X^2$, we say that 
$$
P(|X - \mu| \ge k) \le \frac{\sigma_X^2}{k^2}
$$

3. We can apply Chebyshev's inequality for Normal Distributions and try to find the probability of some value lying beyond some $n\sigma_X$ distance away from the mean $\mu$. For such a case,

$$
\begin{aligned}
P(|X - \mu| \ge n\sigma_X) &\le \frac{\sigma_X^2}{n^2\sigma_X^2} \\[8pt]
&\le \frac{1}{n^2}
\end{aligned}
$$
4. **Central Limit Theorem -** The sample mean and the sample variance converge to the population mean and variance, respectively, as the sample size increases.