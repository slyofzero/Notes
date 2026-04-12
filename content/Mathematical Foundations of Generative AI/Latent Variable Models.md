Latent variable models assume that observed data is generated from hidden (unobserved) variables, and learning means inferring those hidden variables and their relationship to the data.

$$
P_\theta(x) = \sum_z P_\theta(x,z) \qquad \text{or} \qquad P_\theta(x) = \int_z P_\theta(x,z)\,dz
$$

Here $z$ is an latent/unobserved/hidden random variable. Typically $z$ is jointly estimated along with the model parameters $\theta$. For each $x_i \in D$ we assume that there exists a corresponding $z_i$.

1. If $z$ is discrete, $z \in \{z_1,z_2,\dots,z_m\}$. Because for every $x_i \in D$ there would be a corresponding $z_i$, we can create $m$ such buckets for each $x_i$. This is basically what K-Means Clustering and Gaussian Mixture Models aim to do.
2. If $z$ is continuous, $x \in \mathbb{R}^d,\,\, z \in \mathbb{R}^k$. Typically $k \lt\lt d$. Here $z_i|x_i$ represents a feature vector corresponding to the given $x_i$. In doing so, the model is attempting to find a "hidden space", usually lower dimension, in which the data lives.

**TL;DR -** If the latent variable is discrete, then the model can be used for clustering. If the latent variable is continuous, then the model can be used for this feature extraction task. 
# Principle for Learning LVMs
Suppose we have a dataset $D=\{x_i\}_{i=1}^n$ and a Latent Variable Model $P_\theta(x)=\int_ZP(x,z)\,dz$. Our goal here would be to estimate the model parameter $\theta$ given $D$. This can be done by minimizing the [[VDM and GANs#^20cce2|KL Divergence]].

$$
\begin{aligned}
\theta^* &= \arg\min_{\theta} D_{KL}(P_x || P_\theta) \\[8pt]
&= \arg\min_{\theta} \Bigg[ \int_X P_X(x)\,log\left(\frac{P_X(x)}{P_\theta(x)}\right)dx \Bigg] \\[8pt]
&= \arg\min_{\theta} \Bigg[ \int_X P_X(x)\,log\left(P_X(x)\right)dx - \int_X P_X(x)\,log\left(P_\theta(x)\right)dx \Bigg] \\[8pt]
&= \arg\min_{\theta} \Bigg[ \cancel{\int_X P_X(x)\,log\left(P_X(x)\right)dx}^{\text{Independent of }\theta} - \int_X P_X(x)\,log\left(P_\theta(x)\right)dx \Bigg] \\[8pt]
&= \arg\min_{\theta} \Bigg[ - \int_X P_X(x)\,log\left(P_\theta(x)\right)dx \Bigg] \\[8pt]
&= \arg\max_{\theta} \Bigg[ \int_X P_X(x)\,log\left(P_\theta(x)\right)dx \Bigg] \\[8pt]
&= \arg\max_{\theta} \underset{P_X}{\mathbb{E}} \Big[log\left(P_\theta(x)\right)\Big] \\[8pt]
\end{aligned}
$$

Here $log\left(P_\theta(x)\right)$ is the log-likelihood function of $P_\theta(x)$. Thus this optimization problem is called **Maximum Likelihood Estimation**. Because expectation is a linear function and we are calculating the expectation w.r.t $P_X$ not $P_\theta$, we can try to maximize each $log$ term independently and then take the expectation of all to get the final output. So let's just consider the following,

$$
\begin{aligned}
l(\theta)&=log\,P_\theta(x) \\[8pt]
&=log\,\int_Z P_\theta(x,z)\,dz  \\[8pt]
&=log\,\int_Z P_\theta(x,z)\frac{q(z|x)}{q(z|x)}\,dz  \\[8pt]
&=log\,\int_Z q(z|x)\frac{P_\theta(x,z)}{q(z|x)}\,dz  \\[8pt]
&=log\,\underset{q(z|x)}{\mathbb{E}} \left[\frac{P_\theta(x,z)}{q(z|x)}\right]  \\[8pt]
\end{aligned}
$$

By Jensen's Inequality we know that $log\,\mathbb{E}[f(x)] \ge \mathbb{E}\,log\,[f(x)]$. So applying this on the above equation for $l(\theta)$ we get,

$$
\begin{aligned}
l(\theta)&=log\,\underset{q(z|x)}{\mathbb{E}} \left[\frac{P_\theta(x,z)}{q(z|x)}\right]  \\[8pt]
&\ge \underset{q(z|x)}{\mathbb{E}} log\left[\frac{P_\theta(x,z)}{q(z|x)}\right] (\text{denoted as } J_\theta(q))
\end{aligned}
$$

Here $l(\theta)$ is called the **evidence** and thus $J_\theta(q)$ is called the **Evidence Lower Bound (ELBO)**. $J_\theta(q)$ is function of both the model parameters $\theta$ and the density on $z$, $q(z|x)$. $q(z|x)$ is called the **Variational Latent Posterior**. Similar to [[VDM and GANs#Variational Divergence Minimization|VDM]], here too we maximize a lower-bound of a value in order to optimize it. ^7de781

$$
\begin{aligned}
\theta^*,q^* &= \arg\max_{\theta,q} J_\theta(q) \\[8pt]
\text{where, } J_\theta(q) &= \underset{q(z|x)}{\mathbb{E}} \left[log\left[\frac{P_\theta(x,z)}{q(z|x)}\right]\right]
\end{aligned}
$$

# Gaussian Mixture Models (GMM)
In GMMs $z$ is discrete, $z \in \{1,2,\dots,M\}$.

$$
\begin{aligned}
P_\theta(x) &= \sum_Z P_\theta(x,z) \\[8pt]
&= \sum_{j=1}^M P_\theta(z=j)P_\theta(x|z=j) \\[8pt]
\end{aligned}
$$

In a GMM, $P_\theta(z=j)=\alpha_j$, $P_\theta(x|z=j)=\mathcal{N}(x;\mu_j,\Sigma_j)$.

$$
\begin{aligned}
P_\theta(x) &=  \sum_{j=1}^M P_\theta(z=j)P_\theta(x|z=j) \\[8pt]
&= \sum_{j=1}^M \alpha_j \cdot \mathcal{N}(x;\mu_j,\Sigma_j)
\end{aligned}
$$

Parameters of a GMM are,

$$
\theta = \{\alpha_1,\alpha_2,\dots,\mu_1,\mu_2,\dots,\Sigma_1,\Sigma_2,\dots\}
$$

Here $x \in \mathbb{R}^d$, $\mu_j \in \mathbb{R}^d$, and $\Sigma_j \in \mathbb{R}^{d \times d}$ and $0 \le \alpha_j \le 1, \sum_{i=1}^m\alpha_j = 1$ ([[Vectors and Vector Spaces#^63b436|convex combination]] of Gaussian Distributions). Since our goal is to estimate $\theta,q$ via [[Latent Variable Models#^7de781|ELBO optimization]], we can use the **Expectation Maximization Algorithm (EM Algorithm)** which updates both $\theta,q$ alternatively.

$$
\begin{aligned}
\text{For } t=1 \text{ to } T: \\[8pt]
\qquad q^*_{t+1} &= \arg\max_q J_{\theta^t}(q) &(\text{with } \theta_t \text{ as constant})\\[8pt]
\qquad \theta^*_{t+1} &= \arg\max_\theta J_\theta(q_{t+1}) &(\text{with } q_{t+1} \text{ as constant})\\[8pt]
\end{aligned}
$$

It can be shown that EM ensures that $l(\theta_{t+1}) \ge l(\theta_t)$. This doesn't ensure that the likelihood function will keep on increasing, but it ensures that it won't decrease as the parameters get updated.

Applying EM algorithm for the GMM, it can be shown analytically (try once) that,

$$
\begin{aligned}
q_{t+1}^* &= \arg \max_qJ_\theta(q) \\[8pt]
&= P_{\theta_t}(z|x) &\text{(Excercise to show)} \\[8pt]
&= \frac{P_{\theta_t}(x|z) \cdot P_{\theta_t}(z)}{P_{\theta_t}(x)} \\[8pt]
&= \frac{\mathcal{N}(x;\mu_j,\Sigma_j) \cdot \alpha_j}{\sum_{j=1}^\mu\mathcal{N}(x;\mu_j,\Sigma_j) \cdot \alpha_j} &\left(P_\theta(x) =\sum_{j=1}^M P_\theta(z_j)P_\theta(x|z_j)\right) \\[8pt]
\theta_{t+1}^* &= \arg \max_\theta J_\theta(q)
\end{aligned}
$$

ELBO can be optimized for an LVM using the EM algorithm, provided $P_\theta(z|x)$ can be computed. If  $P_\theta(z|x)$ can't be computed, then EM fails.
# Variational Auto-Encoders (VAE)
