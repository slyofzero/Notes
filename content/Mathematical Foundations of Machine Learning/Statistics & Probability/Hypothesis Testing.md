# Basics
Hypothesis testing is a statistical method used to determine if there is enough evidence in sample data to support a specific assumption about a population.

Defining hypothesis -
- Null Hypothesis $(H_0)$: The starting assumption
- Alternative Hypothesis $(H_1)$: The opposite saying there is a difference

Let $A$ be a subset termed as the **acceptance subset**. If $X_1, \dots, X_n \sim \text{i.i.d } X$, then
- Suppose $X \in \mathcal X$, then $X_1, \dots, X_n \in \mathcal X^n$
- Subset $A \subseteq \mathcal X^n$ $\iff$ a hypothesis test 

If $X_1, \dots, X_n\in A$, we accept $H_0$ else we reject $H_0$.

Metrics -
- Significance Level -
	- Denoted as $\alpha$ and corresponds to the probability of a [[Fundamental ML Concepts#^7af2b8|Type I error]].
	- Type I error: Rejecting $H_0$ when $H_0$ is true.
	- $\alpha = \text{P(Type I error)} = \text{P(Reject } H_0 | H_0 \text{ is true)}$.
- Power of a test -
	- Denoted as $1 - \beta$ and corresponds to the probability of a [[Fundamental ML Concepts#^58d13d|Type II error]].
	- Type II error: Accepting $H_0$ when $H_A$ is true.
	- $\beta = \text{P(Type II error)} = \text{P(Accept } H_0 | H_A \text{ is true)}$.
	- $1-\beta = \text{P(Reject } H_0 | H_A \text{ is true)}$.

The art of hypothesis testing is choosing the acceptance subset $A$ wisely, small enough such that the significance level $\alpha$ is low but large enough such that the power $\beta$ is high.
# Types of Hypothesis Testing
1. **Simple Hypothesis -** A hypothesis that completely specifies the distribution of the samples. It's a very well understood and the best approach known, but rarely occurs.
2. **Composite Hypothesis -** A hypothesis that doesn't completely specify the distribution of the samples. Well studied but multiple approaches are possible and is the most common.
	- **One-tailed Test** - Checks if the value is less than or greater than some threshold $c$.
		- **Left Tailed Test** - $H_0 : \mu \ge 50, H_A: \mu \lt 50$.
		- **Right Tailed Test** - $H_0 : \mu \le 50, H_A: \mu \gt 50$.
	- **Two-tailed Test** - Used when we want to see if there is a difference in either direction higher or lower.
		- Example - $H_0 : \mu = 50, H_A: \mu \ne 50$

