# Basic Definitions
**Probability -** Study of uncertainty around anything.

**Random Experiment -** An experiment whose set of all possible outcomes is known, but the outcome of any trial is unknown until the trial is conducted.

**Sample Space -** Set of all possible outcomes of a random experiment.

**Event -** A set of outcomes of the random experiment. A subset of the sample space.

**Trial -** One repetition of a random experiment.
# Types of Events
**Independent Events -** Set of events where occurrence of one event has no affect on occurrence of another.

**Dependent Events -** Set of events where occurrence of one event has some effect on occurrence of another.

**Mutually Exclusive Events -** Set of events where occurrence of one event guarantees that other events in the sample space won't occur.
# Conditional Probability
**Conditional Probability -** Probability of one event occurring given that another has occurred.

$$
P(A|B) = \frac{P(A \cap B)}{P(B)}
$$

**Total Probability Theorem -** The probability of one event is the sum of intersections of that event and partitions of the sample space.

$$
\begin{aligned}
P(B) &= \sum_{i=1}^nP(A \cap B) \\[8pt]
P(B) &= \sum_{i=1}^nP(B|A_i)P(A_i)
\end{aligned}
$$

**Bayes Theorem -** It tells us how knowing the $P(H|D)$ and $P(D|H)$ are related.

$$
\begin{aligned}
P(H|D) &= \frac{P(D|H) \cdot P(H)}{P(D)} \\[8pt]
\text{Posterior} &= \frac{\text{Likelihood} \cdot \text{Prior}}{\text{Evidence}}
\end{aligned}
$$

1. **Prior** $P(H)$ means probability of the hypothesis before seeing the data.
2. **Likelihood** $P(D|H)$ means how likely is the data if the hypothesis is true.
3. Evidence $P(D)$ means the probability of the data.
4. **Posterior** - $P(B|A)$ means probability of the hypothesis after seeing the data.
# Random Variable
**Random Variable -** A real number associated to every outcome of a random experiment.

**Range of a random variable** - The set of values a random variable can hold.

**Discrete Random Variable -** Random variable whose range is a finite or countably infinite set.

**Continuous Random Variable -** Random variable whose range is an uncountably infinite set.
# Probability Distributions
**Probability Distribution -** Describes the probability of a random variable holding a value.

**Probability Mass Function -** A function which describes how probability is distributed over the values of a continuous random variable.

**Cumulative Distribution -** A function which describes the probability of the random variable holding any value less than some $x$. It holds the accumulated probabilities till $x$.

**Independent and Identically Distributed -** Events are i.i.d. if occurrence of one doesn't affect the occurrence of another and the probabilities of both events is the same.

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

8. **Normal Distribution -** A probability distribution in which values are **symmetrically distributed about the mean**, with most observations clustering near the mean and fewer occurring as we move away from it.
$$
\begin{aligned}
&\mathcal X \sim \mathcal N(\mu, \sigma^2) \\[8pt]
&f_{\mathcal X}(x) = \frac{1}{\sigma \sqrt{2 \pi}}\,\operatorname{exp}\left(-\frac{(x-\mu)^2}{2\sigma^2}\right) \qquad, \text{where } -\infty \lt x \lt \infty
\end{aligned}
$$
# Expected Values and Variance
**Expected Value** - The average of all outcomes of a random variable if the experiment is conducted a large number of times.

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

**Mean -** The expected value of a random variable.

**Variance -** The spread of the values of a random variable around the mean.

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
