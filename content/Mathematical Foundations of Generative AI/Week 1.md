Family of Deep Generative Models (DGMs) to be covered -
1. Generative Adversarial Networks (GANs)
2. Variational Auto Encoders (VAEs)
3. Denoising Diffusion Probabilistic Models (DDPMs)
	- Score Based Models
4. Auto Regressive Models (AR)
	- Large Language Models (LLMs)
5. State Space Models (SSMs)
	- Example - S4, Mamba
6. RL-based Alignment for LLMs
	- RLHF, PPO, DPO
# Generative Models
Any dataset $D = \{x_i\}_{i=1}^n, \,\, X_i \stackrel{\text{i.i.d}}{\sim}\,\,\mathbb{P}_x, \,\, x_i = X_i(\omega), \,\, x_i \in \mathbb{R}^d$ means that $D$ consists of **independent realizations** of i.i.d. vector valued random variables $X_1, X_2, \dots$ of size $d$, each distributed according to some unknown probability distribution $\mathbb{P}_X$.

**Goal -** Given such a $D$, the goal of using Generative Models is to estimate $\mathbb{P}_X$ and learn to sample from it.

Principles of Generative Models -
1. Assume a parametric family on $\mathbb{P}_X$ denoted using $\mathbb{P}_{\theta}$ where $\mathbb{P}_{\theta}$ is represented using Deep Neural Networks. This is our "model".
2. Define and estimate a divergence metric to measure the distance between $\mathbb{P}_X$ and $\mathbb{P}_{\theta}$.
3. Solve an optimization problem over the parameters of $\mathbb{P}_\theta$ to minimize the divergence metric.

<h4 class="special">Example</h4>

Assume some random variable $z$ with some arbitrary but known distribution $Z$ (because the distribution is known, sampling is possible). Suppose there exists some function $g_\theta(z): Z \rightarrow X$.
- $\tilde{x}=g_\theta(z)$ would have an entirely different distribution that that of $z$ and would depend upon the function $g_\theta$.
- Suppose $g_\theta(z)$ is a Deep Neural Network and the density of $\tilde{x} = g_\theta(z)$ is denoted as $\mathbb{P}_\theta$. We can define a divergence metric $D(\mathbb{P}_X \, || \, \mathbb{P}_\theta)$ between $\mathbb{P}_\theta$ and $\mathbb{P}_X$ such that $D(\mathbb{P}_X \, || \, \mathbb{P}_\theta) \ge 0$ and $D(\mathbb{P}_X \, || \, \mathbb{P}_\theta)=0$ iff $\mathbb{P}_X = \mathbb{P}_\theta$.
- Solving the optimization equation $\theta^*= \arg\min_{\theta} \ \,  D(\mathbb{P}_X \, || \, \mathbb{P}_\theta)$, would allow us to implicitly estimate $\mathbb{P}_X$. This would allow us to sample from  $\mathbb{P}_X$ using $g_{\theta*}(z)$ because a random sample chosen from $z$ and then passed through $g_{\theta*}(z)$ would be very close to $\mathbb{P}_X$.

This method is called a **pushforward method** as we push a probability mass $Z$ into the data space $X$ using a function $g_\theta$.

<h4 class="special">Obstacles towards implementation -</h4>

1. We know random samples from these distributions, the dataset $D$ from $\mathbb{P}_X$ and $g_\theta(z)$ from $\mathbb{P}_\theta$, but not the distributions themselves. How to compute the divergence metric without knowing the distributions $\mathbb{P}_X$ and $\mathbb{P}_\theta$?
2. What should the choice of the divergence metric be?
3. How to choose $g_\theta$ and in turn $\mathbb{P}_\theta$?
4. How to solve the optimization problem of minimizing the divergence metric?
## Variational Divergence Minimization
Define a diverge between two distributions
### f-divergence
Given two probability distribution functions with corresponding probability density functions denoted by $P_X$ and $P_\theta$, the f-divergence between them is -

$$
\begin{aligned}
&D_f(P_X || P_\theta) = \int_X P_\theta(x)f\left(\frac{P_X(x)}{P_\theta(x)}\right)dx \\[8pt]
&f(u): \mathbb{R^+} \rightarrow \mathbb{R} \text{ is a convex, left semi-continous and } f(1) = 0 \,(\text{any function}) \\[8pt]
&x: \text{space on which } P_X \text{ and } P_\theta \text{ are supported}
\end{aligned}
$$

- *Convex function -* A function which has one unique minimum value (can have multiple minima).
- *Strictly Convex function -* A function which has only one global minima.
- *Left Semi-Continuous function -* A function in which the value at a point is equal to the limit when approached from the left.
- Probability density functions are always non-negative, thus their ratio $\frac{P_X(x)}{P_\theta(x)}$ will be a positive value which would satisfy the domain of $f$.
- Range space of $P_X$ and $P_\theta$ would be positive scalars despite $x$ being a $d$-dimensional random vector.

Choice of an $f$ function is what leads to an $f$-divergence.

Properties of $f$-divergence - 
1. $D_f \ge 0$ for any choice of $f$.
2. $D_f(P_X\,||\, P_\theta) = 0$ iff $P_X = P_\theta$.

Examples of $f$-divergence -
1. $f(u) = u\,log\,u$ leads to the **KL (Kullback-Leilber) Divergence** - ^20cce2

$$
\int_X P_X(x)\,log\left(\frac{P_X(x)}{P_\theta(x)}\right)dx = D_{KL}
$$

K.L Divergence is asymmetric, meaning $\underbrace{D(P_X\,||\,P_\theta)}_\text{Forward K.L.} \ne \underbrace{D(P_\theta\,||\,P_X)}_\text{Reverse K.L.}$.

2. $f(u) = \frac{1}{2}\left(u\,log\,u-(u+1)\,log\left(\frac{u+1}{2}\right)\right)$ leads to the **JS (Jensen-Shannon) Divergence**.
3. $f(u)=\frac{1}{2}|u-1|$ leads to the **Total Variation Distance** or TV Distance.

### Algorithm for f-divergence minimization
We need to come up with an algorithm to optimize the $f$-divergence without knowing what the distributions $P_X$ and $P_\theta$ are but instead by using the samples of $P_X$ and $P_\theta$ known to us (dataset $D$ and output of $g_\theta(z)$).

**Key Idea -** Integrals involving density functions can be approximated using samples drawn from the distribution.

For an integral like the one shown below, we have i.i.d samples drawn from $P_X$.

$$
I = \int_Xh(x)P_x(x)dx
$$

$(1)$ By the Law of Unconscious Statistician (LOTUS) we know that if $X$ is a random variable with a probability distribution $P_X$ and $h$ is some measurable function, then

$$
\int_Xh(x)P_x(x)dx=\mathbb{E}_{P_X}(h(x))
$$

$(2)$ By the Law of Large Numbers, we know that as the number of samples grows, the sample mean converges to the true expected value of a function $h$.

$$
\lim_{n\rightarrow \infty} \frac{1}{n}\sum_{i=1}^nh(x_i) \approx \mathbb{E}[h(x)]
$$

So one way to solve an integral like the [[Week 1#f-divergence|f-Divergence]] is by using the above two mentioned laws and equating it to the expected value of function $h(x)=f\left(\frac{P_X(x)}{P_\theta(x)}\right)$. It would be a mathematically valid representation but is not directly computable from the data since the true data distribution $P_X$ is unknown.

#### Conjugate of a convex function
The conjugate of a convex function $f(u)$ is written as 

$$
f^*(t) = \sup_{u \in \text{dom(f)}} \left\{ut - f(u)\right\}
$$
At every point $t$, one constructs multiple lower bounds on that particular $u$ and chooses the tightest of those lower bounds (supremum/max) as value of the conjugate.

Properties of a conjugate of a convex function -
1. $f^*$ is also a convex function.
2. $\left[f^*(t)\right]^*=f(u)$

Using these properties of a conjugate of a convex function, we can write $f(u)$ as -

$$
f(u) = \sup_{t \in \text{dom(f*)}} \left\{tu - f^*(t)\right\}
$$
Substituting this in the [[Week 1#f-divergence|f-Divergence Integral]] we get -

$$
\begin{alignedat}{2}
D_f(P_X || P_\theta) &= \int_X P_\theta(x)f\left(\underbrace{\frac{P_X(x)}{P_\theta(x)}}_u\right)dx & \\[8pt]
&= \int_X P_\theta(x)f(u)dx &u=\frac{P_X(x)}{P_\theta(x)} \\[8pt]
&= \int_X P_\theta(x)\sup_{t \in \text{dom(f*)}} \left\{t*\frac{P_X(x)}{P_\theta(x)} - f^*(t)\right\}dx &\\[8pt]
\end{alignedat}
$$

To represent the $f$-divergence in terms of expectation, we need to somehow take the supremum out of the integral. Since the **Fenchel conjugate** expresses $f(u)$ as a pointwise supremum, and since $u=\frac{P_X(x)}{P_\theta(x)}$​ depends on $x$, the optimizer of the inner problem is generally a function of $x$. Thus we can take the supremum out and rewrite the equation as -

$$
\begin{alignedat}{2}
&= \sup_{T(x) \in \text{T}}\int_X P_\theta(x) \left\{T(x)*\frac{P_X(x)}{P_\theta(x)} - f^*(T(x))\right\}dx &\\[8pt]
\end{alignedat}
$$

where $\mathbb{T}: X \rightarrow \text{dom f*}$ is the space of functions containing solutions for the inner optimization problem. 

The space of functions $\mathbb{T}$ we are optimizing over may or may not containing $T^*(x)$ that is the solution to the inner optimization problem. This can occur either because $\mathbb{T}$ is a restricted function class (e.g., neural networks), or because the supremum defining the conjugate is not attained within $\mathbb{T}$.

Because we are restricting $\mathbb{T}$ and $\mathbb{T} \subseteq \, \{\text{all measurable functions}\}$, by using the fact for any arbitrary function $F$ that $\sup_{t \in A} F(x) \le \sup_{t \in B} F(x)$ if $A \subseteq B$ we can say,

$$
\begin{aligned}
D_f &\ge \sup_{T(x) \in \text{T}}\int_X P_\theta(x) \left\{T(x)*\frac{P_X(x)}{P_\theta(x)} - f^*(T(x))\right\}dx \\[8pt]
&\ge \sup_{T(x) \in \text{T}}\int_X T(x)\,P_X(x)\,dx - \int_XP_\theta(x)\,f^*(T(x)\,dx \\[8pt]
D_f &\ge \boxed{\sup_{T(x) \in \text{T}} \Bigg[\underset{P_X}{\mathbb{E}}\, T(x) - \underset{P_\theta}{\mathbb{E}} \, f^*(T(x))\Bigg]}
\end{aligned}
$$