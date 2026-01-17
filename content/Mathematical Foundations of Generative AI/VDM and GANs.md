# Deep Generative Models
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
# Variational Divergence Minimization
Define a diverge between two distributions
## f-divergence
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

## Algorithm for f-divergence minimization
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

So one way to solve an integral like the [[VDM and GANs#f-divergence|f-Divergence]] is by using the above two mentioned laws and equating it to the expected value of function $h(x)=f\left(\frac{P_X(x)}{P_\theta(x)}\right)$. It would be a mathematically valid representation but is not directly computable from the data since the true data distribution $P_X$ is unknown.

### Conjugate of a convex function
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
Substituting this in the [[VDM and GANs#f-divergence|f-Divergence Integral]] we get -

$$
\begin{alignedat}{2}
D_f(P_X || P_\theta) &= \int_X P_\theta(x)f\left(\underbrace{\frac{P_X(x)}{P_\theta(x)}}_u\right)dx & \\[8pt]
&= \int_X P_\theta(x)f(u)dx &\because u=\frac{P_X(x)}{P_\theta(x)} \\[8pt]
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
&\ge \sup_{T(x) \in \text{T}}\int_X P_X(x)\,T(x)\,dx - \int_XP_\theta(x)\,f^*(T(x))\,dx \\[8pt]
D_f &\ge \boxed{\sup_{T(x) \in \text{T}} \Bigg[\underset{P_X}{\mathbb{E}}\, [T(x)] - \underset{P_\theta}{\mathbb{E}} \, [f^*(T(x))\big]\Bigg]}
\end{aligned}
$$
For the sake of understanding, we can replace $\sup$ in the above equation with $\max$.

$$
D_f \ge \max_{T(x) \in \text{T}} \Bigg[\underset{P_X}{\mathbb{E}}\, [T(x)] - \underset{P_\theta}{\mathbb{E}} \, [f^*(T(x))\big]\Bigg]
$$

## Realization of VDM (Variational Divergence Minimization)
We need a $\theta^*$ that minimizes the $f$-divergence $D_f$. $D_f$ is not optimizable due to $P_X$ being unknown. At the true optimum $\theta^*$ the lower bound on $D_f$ becomes a tight bound, thus making the optimization of $D_f$ and the optimization of the lower bound equivalent.

$$
\begin{aligned}
\theta^* & = \arg\min_\theta D_f \\[8pt] 
&\approx \arg\min_\theta \Big[\text{lower bound of } D_f\Big] \\[8pt]
&= \arg\min_\theta \Bigg[\max_{T(x) \in \text{T}} \Big[\underset{P_X}{\mathbb{E}}\, [T(x)] - \underset{P_\theta}{\mathbb{E}} \, [f^*(T(x))\big]\Big]\Bigg]  \\[8pt]
\end{aligned}
$$

The final objective here requires two optimizations -
1. **Generator Network -** The outer minimization w.r.t parameters of $g_\theta(z)$.
2. **Critic/Discriminator Network -** The inner maximization w.r.t a class of functions $T(x) \in \mathbb{T}$.

With this the objective becomes - ^7f2437

$$
\theta^*, w^* = \arg\min_\theta \max_{w} \Big[\underset{P_X}{\mathbb{E}}\, [T_w(x)] - \underset{P_\theta}{\mathbb{E}} \, [f^*(T_w(x))\big]\Big]
$$
Neural networks enter the framework when we need to **perform the saddle-point optimization** of the variational lower bound of the $f$-divergence, since both the generator distribution and the variational function are infinite-dimensional objects.
- The model distribution $P_\theta$ must be learnt to reduce the value of the $f$-divergence metric. Neural networks provide a flexible and differentiable parameterization for learning such complex data-generating distributions using the samples.
- The function class $\mathbb{T}$, being infinite dimensional, is difficult to characterize explicitly. As neural networks are **universal function approximators**, we represent $\mathbb{T}$ using neural networks $T_w(x)$ where $w$ are the parameters of the neural network.
## Implementing VDM for Generative Modelling

![[Pasted image 20260115155152.png]]

Now we have two neural networks, one representing the sampler **(Generator Network)** and the other representing the $\mathbb{T}$ function class **(Critic Network)**. ^3c1491

$$
\begin{aligned}
J(\theta,w) &= \underset{P_X}{\mathbb{E}}\, [T_w(x)] - \underset{P_\theta}{\mathbb{E}} \, [f^*(T_w(x))] \\[8pt]
\theta^*, w^* &= \arg\min_\theta \max_{w} J(\theta,w)
\end{aligned}
$$
Such problems are called a **saddle-point optimization problems** as we are looking for saddle points here or an **adversarial optimization problem** because whatever one network is trying to do is the opposite of what the other network is trying to do.

Usually we avoid saddle-points because they are neither a global minima nor a global maxima, but this is one of the rare instances where we seek a saddle point.

By construction $T_w: X \rightarrow \operatorname{dom}f^*$ is dependent upon the particular choice of $f$. $T_w$ can be rewritten as $T_w = \sigma_f(V_w(x))$ to guarantee that the critic's output lies in the domain of $f^*$ while keeping the network architecture independent of our choice of the $f$-divergence. Here -
- $V_w(x): X \rightarrow \mathbb{R}$ is a function common across all $f$-divergence
- $\sigma_f(v): \mathbb{R} \rightarrow \operatorname{dom}f^*$ is an $f$-divergence specific activation function (need not always be the sigmoid function)

![[Pasted image 20260115180020.png]]

So we can rewrite our [[VDM and GANs#^3c1491|loss function]] as -

$$
J(\theta,w) = \underset{P_X}{\mathbb{E}}\, [\sigma_f(V_w(x))] - \underset{P_\theta}{\mathbb{E}} \, [f^*(\sigma_f(V_w(x)))]
$$
# Generative Adversarial Networks
For GANs the $f$-divergence that is chosen is as follows -

$$
\begin{alignedat}{2}
f(u) &= u\,log\,u-(u+1)\,log\,(u+1) \qquad&\text{(Similar to }f \text{ used in JS-divergence)} \\[8pt]
f^*(t) &= -log\,(1-exp(t)), &\operatorname{dom}f^* = \mathbb{R}^- \\[8pt]
\sigma_f(v) &= -log(1+e^{-v}) &\text{(log-sigmoid)}
\end{alignedat}
$$

The log-sigmoid as $\sigma_f$ ensures that the output of the critic always lies in $\operatorname{dom}f^* = \mathbb{R}^-$. Using the above information, we can write a GAN specific loss function using the equation of a loss function we got earlier.

$$
\begin{aligned}
J_{GAN}(\theta,w) &= \underset{P_X}{\mathbb{E}}\, [log\,D_w(x)] + \underset{P_\theta}{\mathbb{E}} \, [log\,(1-D_w(x))] \\[8pt]
\text{where}\,D_w(x) &= \frac{1}{1+e^{-V_w(x)}} \,\text{(the sigmoid function}\, \&\,D_w(x) \in \{0,1\}) \\[8pt]
\end{aligned}
$$

<h4 class="special">Observations to note -</h4>

- Due to the rearrangement of terms again satisfying the [[VDM and GANs#^7f2437|lower-bound equation]], we can see that $T_w(X) = log\,D_w(x)$.
- It can also be seen that this objective function strangely resembles the **cross-entropy loss**.
- [[VDM and GANs#^c16f0b|The discriminator would try to maximize]] this “cross-entropy” by maximizing the objective function. Since the cross-entropy is large when real and fake samples are easily distinguishable, maximizing it encourages the discriminator to separate samples from $P_X$​ and $P_\theta$​ as effectively as possible. **Thus it is called the "discriminator."**
- [[VDM and GANs#^23984c|The generator would try to minimize]] this "cross-entropy" by only minimizing the second term of the objective function. In general this second term penalizes incorrect predictions made with a high probability. In this case it would be penalizing the fake samples the discriminator confidently distinguishes as fake. By minimizing it, the generator encourages the discriminator to assign higher probabilities to generated samples, which implicitly pushes the generator distribution $P_\theta$​ towards the data distribution $P_X$​.
- The above two observations are solidifying more in [[VDM and GANs#Formulation of classifier guided sampler|Formulation of classifier guided sampler]].
- The discriminator is trying to assign a low probability to the generated samples while the generator pushes the discriminator to assign them a high probability. This causes the adversarial nature of the networks.

The architecture ends up looking like the image below. $log$ doesn't need to be included in the discriminator network as it is not a part of the networks but the error function.

![[Pasted image 20260115185537.png]]
## Implementation of GAN in practice
Pre-requisites -
- Input $D=\{x_1,x_2,\dots\} \stackrel{\text{i.i.d}}{\sim} P_X$.
- Let $B_1=\{x_1,x_2,\dots, x_{B_1}\} \subset D$ (need not be contiguous, is usually random) be a mini-batch taken from the dataset.
- Let $B_2 =\{z_1, z_2, \dots, z_{B_2}\}$ be a batch of random noise vectors taken from the arbitrary distribution we chose, typically $\mathcal{N}(0,1)$.

As we are using these batches during Mini-Batch gradient descent, these batches are resampled each time before an update.
### To train the Discriminator
Optimizing for $w$ - ^c16f0b
$$
\begin{aligned}
w^* &= \arg\max_{w} J_{GAN}(\theta, w) \\[8pt]

&= \arg\max_{w} \Bigg[\underset{P_X}{\mathbb{E}}\, [log\,D_w(x)] + \underset{P_\theta}{\mathbb{E}} \, [log\,(1-D_w(x))]\Bigg] \\[8pt]

&\approx \arg\max_{w} \Bigg[\frac{1}{B_1}\sum_{i=1}^{B_1}log\,D_w(x_i) + \frac{1}{B_2}\sum_{i=1}^{B_2}log\,(1-D_w(\hat{x}_i)) \Bigg] \qquad\because\text{Using batch size} \\[8pt]
\end{aligned}
$$

Steps -
1. Resample $B_1$ and $B_2$.
2. Pass $x_i \in B_1$ through the discriminator $D_w$ to get $D_w(x_i)$. Then using these calculate the first term of the loss function - 

$$
\frac{1}{B_1}\sum_{i=1}^{B_1}log\,D_w(x_i)
$$

3. Keeping $\theta$ constant, pass the random noise vectors $z_i \in B_2$ through the generator to generate **fake samples** $\hat{x}_i=g_\theta(z_i)$. Pass this through the discriminator to get $D_w(\hat{x}_i)$. Using these calculate the second term of the loss function - 

$$
\frac{1}{B_2}\sum_{i=1}^{B_2}log\,(1-D_w(\hat{x}_i))
$$

4. Calculate the gradient $\underset{w}{\nabla} J_{GAN}(\theta, w)$ and backpropagate the gradients back through the discriminator network.
5. Update $w$ using **gradient "ascent"**.

$$
w^{t+1} = w^t + \alpha_1\,\underset{w}{\nabla} J_{GAN}(\theta, w)
$$

![[Pasted image 20260115221930.png]]

### To Train the Generator
Optimizing for $\theta$ - ^23984c

$$
\begin{aligned}
\theta^* &= \arg\min_{\theta} J_{GAN}(\theta, w) \\[8pt]

&= \arg\min_{\theta} \Bigg[\underset{P_X}{\mathbb{E}}\, [log\,D_w(x)] + \underset{P_\theta}{\mathbb{E}} \, [log\,(1-D_w(x))]\Bigg] \\[8pt]

&\approx \arg\min_{\theta} \Bigg[\cancel{\frac{1}{B_1}\sum_{i=1}^{B_1}log\,D_w(x_i)}^{\text{Independent of }\theta} + \frac{1}{B_2}\sum_{i=1}^{B_2}log\,(1-D_w(\hat{x}_i)) \Bigg] \\[8pt]

&= \arg\min_{\theta} \Bigg[\frac{1}{B_2}\sum_{i=1}^{B_2}log\,(1-D_w(\hat{x}_i) \Bigg] \qquad\because \text{Second term stays as } \hat{x}_i=g_\theta(z_j) \in P_\theta \\[8pt]
\end{aligned}
$$
Steps -
1. Resample $B_2$.
2. Keeping $w$ constant, pass the random noise vectors $z_i \in B_2$ through the generator to generate **fake samples** $\hat{x}_i=g_\theta(z_i)$. Pass this through the discriminator to get $D_w(\hat{x}_i)$. Using these calculate the term of the loss function - 

$$
\frac{1}{B_2}\sum_{i=1}^{B_2}log\,(1-D_w(\hat{x}_i))
$$

3. Calculate the gradient $\underset{\theta}{\nabla} J_{GAN}(\theta, w)$ and backpropagate the gradients back through the discriminator network and then through the generator network. The discriminators parameters are not updated as $w$ is set to constant.
4. Update $\theta$ using **gradient descent**.

$$
\theta^{t+1} = \theta^t - \alpha_2\,\underset{\theta}{\nabla} J_{GAN}(\theta, w)
$$

We have to solve these optimization problems alternatively. First update the generator parameters while keeping the discriminator parameters are constant, then update the discriminator parameters while keeping the generator parameters are constant.
## Interpretation of GANs as Classifier guided Generative Samplers
In GANs the discriminator network $D_w$ acts as a binary classifier which is able to predict whether a given sample belongs to $P_X$ or $P_\theta$. 

*Can this classifier be used to bring $P_X$ and $P_\theta$ closer? 
- Yes! If $P_X$ and $P_\theta$ were sufficiently close to each other, even an optimal discriminator would fail to distinguish the samples between them. So we can tweak $\theta$ till the classifier fails to distinguish between samples of $P_X$ and $P_\theta$.
- However, the failure of some weak or arbitrary classifier doesn't imply that $P_X$ and $P_\theta$ are close to each other. So instead of just tweaking $\theta$, we also need to change the binary classifier $D_w$. If all such different variations of the classifiers fail to distinguish the samples then we can confidently say that $P_X$ and $P_\theta$ are close to each other.

![[Pasted image 20260116162004.png]]

**Mode Collapse Problem -**
- During the updation of the generator and the classifier, it can happen that $\theta$ and the classifier keep alternating between two values and get stuck in an infinite loop. This is called the mode collapse problem.
### Formulation of classifier guided sampler
Creating the classifier -
1. Let $D_w: \mathcal{X} \rightarrow [0,1]$ represent the probability of the sample $x$ coming from $P_X$. 
2. We'd need to maximize the log-likelihood of $x$ coming from $P_X$ when $x \sim P_X$ (probability of real samples being marked as real) and also maximize the log-likelihood of $\hat{x}$ coming from $P_\theta$ when $\hat{x} \sim P_\theta$ (probability of fake samples being marked as fake). So the combined objective of the classifier becomes maximizing the sum of these two values.

$$
\begin{aligned}
\mathbb{E}[log\,D_w(x)] &: \text{log-likelihood that } x \sim P_X \\[8pt]
\mathbb{E}[log\,(1-D_w(x))] &: \text{log-likelihood that } \hat{x} \sim P_\theta \\[8pt]
w^* = \arg\max_w \,\,&\Big[\underset{P_X}{\mathbb{E}}[log\,D_w(x)] + \underset{P_\theta}{\mathbb{E}}[log\,(1-D_w(\hat{x}))]\Big] \\[8pt]
\end{aligned}
$$
Similarly for the generator -
1. The objective for the generator is that the classifier has to "fail" in distinguishing samples from $P_X$ and $P_\theta$. So the goal here is to minimize the discriminator’s confidence that fake samples $\hat{x}$ coming from $P_\theta$ are fake.

$$
\theta^* = \arg\min_\theta \Big[\underset{P_\theta}{\mathbb{E}}[log\,(1-D_w(\hat{x}))]\Big]
$$

Thus the overall objective becomes -

$$
\theta^*, w^* = \arg\min_\theta\max_w \,\,\Big[\underset{P_X}{\mathbb{E}}[log\,D_w(x)] + \underset{P_\theta}{\mathbb{E}}[log\,(1-D_w(\hat{x}))]\Big]
$$
# Deep Convolution GAN (DC Gan)
(intentionally left incomplete for now)

# Conditional GAN (cGAN)
![[Pasted image 20260116201623.png]]

To make conditional GANs that sample from a conditional distribution, we pass the conditional variable $y$ through both the generator and the discriminator.
- Instead of just the noise $z \sim p(z)$ we pass $(z,y)$ so the generator learns $P_\theta(x|y)$.
- Instead of just seeing $x$, the discriminator sees $(x,y) \rightarrow D_w(x,y)$. It now answers "Is $x$ a real sample consistent with condition $y$".

The objective function changes to -

$$
J(\theta, w) = \underset{(x,y) \sim P_{X|Y}}{\mathbb{E}}[log\,D_w(x)] + \underset{(\hat{x},y) \sim P_{\hat{X}|Y}}{\mathbb{E}}[log\,(1-D_w(\hat{x}))]
$$
# Inference with GANs/VDM
![[Pasted image 20260116210510.png]]

Suppose $g_\theta^*$ is the optimal generator network achieved via training. For any test input $z_{test} \sim \mathcal{N}(0,1)$ and class label $y$, the output would be a $X_{test}$ corresponding to the class-label specified by $y$.
# Improvisations of GANs

## Why makes GAN training unstable?
**Manifold Hypothesis -** 
- Images in the real world lie in a lower dimension manifold of the ambient space $\mathbb{R}^d$.
- Consider all $28\times 28$ images such that a pixel is 1 if a coin toss results in a heads, else 0. The probability of an image generated in such a manner resembling an English Alphabet is very low. So we can say that the images depicting an English Alphabet lie in a low dimensional manifold on the ambient space $\{0,1\}^{784}$.
- Similarly an image of any natural object lies in a lower dimension manifold of the image's dimension $\mathbb{R}^d$.

The real distribution $P_X$ and the generated distribution $P_\theta$ are both distributions over $\mathbb{R}^{784}$. Since the real data and the generated data would lie over a lower dimensional manifold of $\mathbb{R}^d$, the supports (set on which the corresponding density function has a non-zero value) of $P_X$ and $P_\theta$ **would misalign with a very high probability**.

When the supports of $P_X$ and $P_\theta$ misalign, it can be shown that a perfect discriminator would always exist. In such a case the gradient of the discriminator becomes 0, due to which the discriminator parameters and the generator parameters can't be updated any further (gradients flow through the discriminator into the generator). Thus **GAN training saturates**.

Remedies for GAN training saturation -
- Train the generator and the discriminator at different training ratios, usually training the generator more.
- Instead of using the $f$-divergence metric $D_f(P_x||P_\theta)$ which becomes independent of the generator parameters $\theta$ when GAN training saturates, use a "softer" metric which does not saturate when the manifolds of the supports of $P_X$ and $P_\theta$ misalign.
## Wasserstein's GANs
### Wasserstein's Metric (Optimal Transport)
Given two distributions $P_X$ and $P_{\hat{X}}$, 

$$
\begin{aligned}
W(P_X || P_{\hat{X}}) &= \min_{\lambda \in \Pi(X,\hat{X})} \Big[\underset{x,\hat{x} \sim \lambda}{\mathbb{E}}||x-\hat{x}||_2\Big] \\[8pt]
\lambda &: \text{Joint distribution b/w }P_X,P_{\hat{X}} \\[8pt]
\Pi(X,\hat{X}) &: \text{All Joint distributions such that -} \\[8pt]
&\int_X \Pi(X,\hat{X})\,dx = P_{\hat{X}} \\[8pt]
&\int_{\hat{X}} \Pi(X,\hat{X})\,dx = P_X \\[8pt]
\end{aligned}
$$

Here $W(P_X || P_{\hat{X}})$ corresponds to a "transport plan" that requires the least amount of "work done" in redistributing $P_{\hat{X}}$ to be similar to $P_X$.

![[Pasted image 20260117114455.png|450]]

Imagine piles of dirt here to be $P_\hat{X}$ and $P_X$ to be a pile of dirt shaped like a bell curve. The minimum transport plan just tells you the best plan to shovel dirt in between the two piles such that the final pile resembles $P_X$. 

But how does shoveling dirt relates to redistributing distributions? Every joint distribution between the two distributions $P_\hat{X}$ and $P_X$ can be written as a table whose each row and column sum to 1.

|             |  $x_1$   |  $x_2$   | $\dots$  |  $x_k$   |
| :---------: | :------: | :------: | :------: | :------: |
| $\hat{x}_1$ |  $0.1$   |  $0.6$   | $\dots$  |  $0.05$  |
| $\hat{x}_2$ |   0.3    |   0.2    | $\dots$  |   0.3    |
|  $\vdots$   | $\vdots$ | $\vdots$ | $\vdots$ | $\vdots$ |
| $\hat{x}_k$ |   0.9    |   0.1    | $\dots$  |    0     |

**This is joint distribution is a transport plan** which dictates how much of which random variable in $P_{\hat{X}}$ is required to recreated 