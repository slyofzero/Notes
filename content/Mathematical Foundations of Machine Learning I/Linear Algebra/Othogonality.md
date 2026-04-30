>[!SUMMARY] Table of Contents
>- [[Othogonality#Dot Product|Dot Product]]
>	- [[Othogonality#Cauchy-Schwarz Inequality|Cauchy-Schwarz Inequality]]
>- [[Othogonality#Orthogonal Vectors|Orthogonal Vectors]]
>- [[Othogonality#Orthonormal vectors|Orthonormal vectors]]
>	- [[Othogonality#Fourier Expansion|Fourier Expansion]]
>	- [[Othogonality#Parseval's Theorem|Parseval's Theorem]]
>- [[Othogonality#Orthogonal Projections|Orthogonal Projections]]
>- [[Othogonality#Gram-Schmidt Process|Gram-Schmidt Process]]
>	- [[Othogonality#Orthogonal Matrix|Orthogonal Matrix]]
# Dot Product
$\underline{\text{Definition}}-$ The inner product or the dot product in a vector space $V$ over $\mathbb R$ is a map, that for any 2 vectors $u,v \in V$ there is a real number $<u,v>$ such that,
1. $<u,\alpha v + \beta w> = \alpha <u,v> + \beta <u,w>$ (Linearity Property)
2. $<u,v> = <v,u>$ (Symmetric Property)
3. For any $u \in V$, $<u,v> = 0$ if and only if $u$ is the zero vector. ()

The vector space for which the inner product $(\cdot)$ is defined is called an **inner product vector space**.

![[Pasted image 20260204184218.png|450]]

Suppose the two vectors $u,v \in \mathbb R^2$ are like this. We can write $u_1, u_2, v_1, v_2$ using trigonometric identities as -

$$
\begin{aligned}
u_1 = ||u|| \cos\theta, &\,\,\,\, u_2 = ||u||\sin\theta \\[8pt]
v_1 = ||v|| \cos(\theta+\phi), &\,\,\,\, v_2 = ||v||\sin(\theta+\phi) \\[8pt]
\end{aligned}
$$

$u \cdot v$ is defined as $u_1v_1 + u_2v_2$. So using the above values for this gives us,

$$
\begin{aligned}
u \cdot v &= u_1v_1 + u_2v_2 \\[8pt]
&= \Big(||u||\cos\theta\cdot||v||\cos(\theta+\phi)\Big) + \Big(||u||\sin\theta\cdot||v||\sin(\theta+\phi)\Big) \\[8pt]
&= ||u||\,\,||v|| \cos(\phi + \theta - \theta ) \\[8pt]
&= \boxed{||u||\,\,||v|| \cos(\phi)}
\end{aligned}
$$
## Cauchy-Schwarz Inequality
$$
\begin{aligned}
|u \cdot v| &= ||u||\,||v|| \cos\theta \\[8pt]
|u \cdot v| &\le ||u||\,||v||
\end{aligned}
$$
# Orthogonal Vectors
If $u,v \in V$ are vectors such that $u \cdot v = 0$, then we say that $u$ and $v$ are orthogonal to each other. 
- The zero vector is orthogonal to all vectors in any vector space.
- If $u,v$ are non-zero vectors, then $u \cdot v = 0$ can only happen when the angle between $u,v$ is 90$\degree$.

---
Let $W^{\perp}$ be a set of all vectors orthogonal to every vector in $W$, where $W$ is a subspace of the inner product vector space $V$.

Let $u,v \in W^\perp$ and $w \in V$ -
1. The zero vector is always orthogonal to any vector in any vector space. Thus $W^\perp$ **contains the zero vector** and is non-empty.
2. Because $u\cdot w = 0$ and $v \cdot w = 0$, we can say
$$
\begin{aligned}
&&u\cdot w + v \cdot w &= 0 \\[8pt]
&\Rightarrow &(u+v)\cdot w  &= 0
\end{aligned}
$$

This implies that $u+v \in W^\perp$ too. Thus $W^\perp$ is **closed under vector addition**.
3. Because $u\cdot w = 0$, we can say $\alpha(u\cdot w) = 0$. Consequently this would mean that $\alpha u \cdot w = 0$, and hence $\alpha u \in W^\perp$. Thus $W^\perp$ is **closed under scalar multiplication**.

Hence we can say that $W^\perp$ is a vector space too as it is closed under vector addition and scalar multiplication and contains the zero vector.

The vector space $W^\perp$ is called the **orthogonal complement** of the space $W$.

---
# Orthonormal vectors
A set of vectors is said to be orthonormal if -
- Each vector in the set is orthogonal to every other vector.
- Each vector has a magnitude of 1.

---
Suppose $s = \{v_1, v_2, \dots, v_n\}$ is a set of orthonormal vectors, what can we say about the dependence/independence of this set?

The set of vectors is independent only when $\alpha_1 v_1 + \alpha_2 v_2 + \dots + \alpha_n v_n =0$ only when $\alpha_i = 0 \,\,\forall i \in [1,n]$. Let,

$$
\begin{alignedat}{3}
&&\alpha_1 v_1 + \alpha_2 v_2 + \dots + \alpha_n v_n &= 0 \\[8pt]
&\Rightarrow & v_1 \cdot \Big(\alpha_1 v_1 + \alpha_2 v_2 + \dots + \alpha_n v_n\Big)  &= v_1 \cdot0 \\[8pt]
&\Rightarrow & \qquad\alpha_1 (v_1 \cdot v_1) + \alpha_2 (v_1 \cdot v_2) + \dots + \alpha_n (v_1 \cdot v_n) &= 0 \\[8pt]
&\Rightarrow & \alpha_1 ||v_1||^2 &= 0 \\[8pt]
&\Rightarrow & \alpha_1 * 1 &= 0 \\[8pt]
&\Rightarrow & \alpha_1 &= 0 \\[8pt]
\end{alignedat}
$$

Similarly we can show that $\alpha_i = 0 \,\,\forall i \in [1,n]$. Thus we can say that every set of orthonormal vectors is linearly independent and can be chosen as the basis for their vector space.

---
## Fourier Expansion
Let $b$ be the basis expansion of any vector. We can get the scalars for each basis vector by doing,
$$
\begin{aligned}
&& b &= \alpha_1 v_1 + \alpha_2 v_2 + \dots + \alpha_n v_n \\[8pt]
&\Rightarrow &v_1 \cdot b &= v_1 \cdot (\alpha_1 v_1 + \alpha_2 v_2 + \dots + \alpha_n v_n) \\[8pt]
&\Rightarrow &v_1 \cdot b &=  \alpha_1 (v_1 \cdot v_1) + \alpha_2 (v_1 \cdot v_2) + \dots + \alpha_n (v_1 \cdot v_n) \\[8pt]
&\Rightarrow &v_1 \cdot b &=  \alpha_1 \\[8pt]
&\Rightarrow &\alpha_1 &= v_1 \cdot b \\[8pt]
\end{aligned}
$$

Similarly we can find $\alpha_i=v_i \cdot b \,\,\forall i \in [1,n]$.

Using this knowledge we can rewrite $b$ as,
$$
\begin{aligned}
b &= (b \cdot v_1) v_1 + (b \cdot v_2) v_2 + \dots + (b \cdot v_n) v_n \\[8pt]
&= ||b||\,||v_1|| \cos\theta_1 v_1 +  ||b||\,||v_2|| \cos\theta_2 v_2 + \dots + ||b||\,||v_n|| \cos\theta_n v_n \\[8pt]
&= ||b|| \Big(\cos\theta_1 v_1 +  \cos\theta_2 v_2 + \dots + \cos\theta_n v_n\Big) 
\\[8pt]
&= \boxed{||b|| \sum_{i=1}^n \cos\theta_i v_i} \\[8pt]
\end{aligned}
$$

This is called the **Fourier Expansion** for $b$.
## Parseval's Theorem
We know that $b = \sum_{i=1}^n \alpha_i v_i = \sum_{i=1}^n (b \cdot v_i) v_i$.
$$
\begin{aligned}
&&b &= \sum_{i=1}^n (b \cdot v_i) v_i \\[8pt]
&\Rightarrow &||b||^2 &= \Bigg<\sum_{i=1}^n (b \cdot v_i) v_i,\sum_{j=1}^n (b \cdot v_j) v_j\Bigg> \\[8pt]
&\Rightarrow&&= \sum_{i,j}(b \cdot v_i)(b \cdot v_j)<v_i,vj> \\[8pt]
&\Rightarrow&&= \sum_{i,j}|b \cdot v_i|^2 \\[8pt]
\end{aligned}
$$
# Orthogonal Projections
$\underline{\text{Definition}}-$ A projection of a vector is the best approximation of a vector in a vector space.

Let $u,v$ be two non-zero vectors in an inner product space $V$. What is the information of $v$ 
available in the direction of $u$?

![[Pasted image 20260206212732.png|450]]

We can drop a perpendicular line $v_\perp$ onto $ku$ from $v$, where $k$ is some real scalar. By vector addition -
$$
\begin{aligned}
&&v &= ku + v_\perp \\[8pt]
&\Rightarrow &v_\perp &= v - ku
\end{aligned}
$$

As $v_\perp$ is orthogonal to $ku$ by design, we can say that it's orthogonal to $u$ as well. So,
$$
\begin{aligned}
&&v_\perp \cdot u &= 0 \\[8pt]
&\Rightarrow &(v - ku) \cdot u &= 0 \\[8pt]
&\Rightarrow &v \cdot u - ku\cdot u &= 0 \\[8pt]
&\Rightarrow &k &= \frac{v \cdot u}{u\cdot u} \\[8pt]
&\Rightarrow &ku &= \frac{u^T v}{||u||^2}u \\[8pt]
\end{aligned}
$$

Hence we can call $ku$ the orthogonal project of $v$ along the direction of $u$. The above equation can be rewritten as,
$$
\begin{aligned}
&&P_v &= u\frac{u^T v}{||u||^2} \\[8pt]
&\Rightarrow &P_v &= \frac{uu^T}{||u||^2}v \\[8pt]
\end{aligned}
$$

Here $uu^T$ would be an $n \times n$ matrix if $u$ is an $n-$dimensional vector. It is also called as the **outer product** of the $u$. This is also known as the **projection matrix**. Properties of the outer product -
- $P$ is a rank-1 matrix as all $n$ columns of the outer product would just be multiples of $u$.
- $P$ is a symmetric matrix, meaning $P^T = P$.
- $P$ is an idempotent matrix, meaning $P^2 = P$.
$$
\begin{aligned}
&&P^2 &= \frac{uu^Tuu^T}{u^Tu\,u^Tu} \\[8pt]
&&&= \frac{u\cancel{u^Tu}u^T}{\cancel{u^Tu}\,u^Tu} \\[8pt]
&&&= \frac{uu^T}{u^Tu} \\[8pt]
&&P^2&= P \\[8pt]
\end{aligned}
$$
# Gram-Schmidt Process
Let $W$ be a $d$-dimensional subspace of a $k$-dimensional vector space $V$ where $d \le k$. Let the basis of $W$ be $B = \{u_1, u_2, \dots, u_n\}$ and we wish to create orthogonal basis $O=\{v_1, v_2, \dots, v_n\}$ using these.

We can write,
$$
\begin{aligned}
v_1 &= u_1 \\[8pt]
v_2 &= u_2 - \frac{u_2^Tv_1}{v_1^Tv_1}v_1 \\[8pt]
v_3 &= u_3 - \frac{u_3^Tv_2}{v_2^Tv_2}v_2 - \frac{u_3^Tv_1}{v_1^Tv_1}v_1 \\[8pt]
&\vdots  \\[8pt]
v_d &= u_d - \left(\sum_{i=1}^{d-1}\frac{u_3^Tv_i}{v_i^Tv_i}v_i\right) \\[8pt]
\end{aligned}
$$

From this $u_i$ can be written as -
$$
\begin{aligned}
u_i &= v_i + \left(\sum_{i=1}^{d-1}\frac{u_3^Tv_i}{v_i^Tv_i}v_i\right) \\[8pt]
\end{aligned}
$$

In matrix form this could be written as -
$$
A = \left[\begin{matrix}
u_1 & u_2 &\dots &u_d
\end{matrix}
\right]
= \left[
\begin{matrix}
v_1 & v_2 &\dots &v_d
\end{matrix}
\right]
\\
\left[
\begin{matrix}
1 &\frac{u_2^Tv_1}{v_1^Tv_1} &\dots &\frac{u_d^Tv_1}{v_1^Tv_1} \\
0 &1 &\dots &\frac{u_{d-1}^Tv_2}{v_2^Tv_2} \\
&&\vdots \\
0 &0 &\dots &1 \\
\end{matrix}
\right]
$$

If we instead wish to obtain orthonormal basis $\{q_1, q_2, \dots, q_d\}$, we can just substitute $v_i = ||v_i||q_i$. Thus the matrix representation becomes,
$$
A = QR = \left[
\begin{matrix}
q_1 & q_2 &\dots &q_d
\end{matrix}
\right]
\\
\left[
\begin{matrix}
||v_1|| &\frac{u_2^Tv_1}{v_1^Tv_1} &\dots &\frac{u_d^Tv_1}{v_1^Tv_1} \\
0 &||v_2|| &\dots &\frac{u_{d-1}^Tv_2}{v_2^Tv_2} \\
&&\vdots \\
0 &0 &\dots &||v_d|| \\
\end{matrix}
\right]
$$

To summarize, we start of with a matrix $A$ such that its column space spanned all of $W$. Such a matrix $A$ can be decomposed into product of two matrices $Q$ and $R$, where $Q$ is an **orthogonal matrix**.
# Orthogonal Matrix
A matrix is an **orthogonal matrix** if for all column vectors $u_i$ -
$$
u_i \cdot u_j = \begin{cases}
0, \text{if } i\ne j \\[8pt]
1, \text{if } i=j \\[8pt]
\end{cases}
$$

This means that -
- The columns vectors of the matrix are all of unit length.
- All columns vectors of the matrix are orthogonal to each other.

For orthogonal matrices $Q^TQ = I$, which means that $Q^{-1} = Q^T$.
# Orthogonal Complement
Let $W$ be a subspace of $\mathbb R^n$. The orthogonal complement of $W$, denoted $W^\perp$ is the set of all vectors in $\mathbb R^n$ that are orthogonal to every vector in $W$.

$$
W^\perp = \{v \in \mathbb R^n : v \cdot w = 0, \,\,\forall w \in W\}
$$

- If $\operatorname{dim}(W) = d$, $\operatorname{dim}(W^\perp)=n-d$.
- Let $B_W$ be the orthonormal basis of $W$ and $B_{W_\perp}$ be the orthonormal basis of $W^\perp$. The orthonormal basis of $V$ will be $B_W \cup B_{W_\perp}$.

Using this property of orthogonal complements, any vector in $V$ can be written as a unique composition of any two vectors in $W$ and $W^\perp$.

$$
x = x_W + x_{W_\perp}
$$

$\text{Proof to show that this decomposition is unique -}$
- Assume that there are two decompositions of $x$, $x_W + x_{W_\perp}$ and $x_W' + x_{W_\perp}'$. 
- Because both lead to $x$, we can say that $x_W + x_{W_\perp} = x_W' + x_{W_\perp}'$. Upon rearranging this we can say that $x_W - x_W' = x_{W_\perp}'- x_{W_\perp}$, where the LHS vectors belong to $W$ and the RHS vectors belong to $W_\perp$.
- $W \cap W_\perp = \{0\}$ only, thus if $x_W - x_W' = x_{W_\perp}'- x_{W_\perp}$ then $x_W - x_W'$ and $x_{W_\perp}'- x_{W_\perp}$ both need to be 0. Meaning that $x_W' = x_W$ and $x_{W_\perp}' = x_{W_\perp}$.
- Hence proved that the decomposition of a vector into a sum of two vectors from orthogonal subspaces is unique.

