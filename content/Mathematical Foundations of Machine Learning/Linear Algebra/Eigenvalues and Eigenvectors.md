>[!SUMMARY] Table of Contents
>- [[Eigenvalues and Eigenvectors#Invariant Subspace|Invariant Subspace]]
>- [[Eigenvalues and Eigenvectors#Eigenvalues|Eigenvalues]]
>	- [[Eigenvalues and Eigenvectors#Multiplicities of Eigenvalues|Multiplicities of Eigenvalues]]
>	- [[Eigenvalues and Eigenvectors#Distinct eigenvalues|Distinct eigenvalues]]
>- [[Eigenvalues and Eigenvectors#Diagonalization|Diagonalization]]
>	- [[Eigenvalues and Eigenvectors#Powers of a diagonalizable matrix|Powers of a diagonalizable matrix]]

If for some vector, the output of a linear transformation is just a scaled multiple of the same vector without any changes in the direction, we call such a vector an "invariant" direction or an **eigenvector** and the scalar the **eigenvalue**.

$$
\begin{alignedat}{3}
&&Au &= \lambda u \\[8pt]
&\Rightarrow &Au - \lambda u & =0 \\[8pt]
&\Rightarrow &(A - \lambda I) u & =0 \\[8pt]
\end{alignedat}
$$

Since $u$ is a non-zero vector, we are looking for a solution to the homogeneous system of equation $A - \lambda I = 0$. Thus $A - \lambda I$ is a singular matrix, and consequently $|A - \lambda I|=0$.
# Invariant Subspace
If some vector $t$ is an eigenvector for some matrix $A$ such that $At=\lambda t$, then all scalar multiples of $t$ are eigenvectors as well.

Because the space of all multiples of $t$ would pass through the origin if $k=0$ in $kt$, these eigenvectors form a subspace. Such a subspace is known as an **invariant subspace**.

$\underline{\text{Definition}}-$ The invariant subspace of a linear transformation $T: V_1 \rightarrow V_2$ is the set of vectors $u$ such that $T(u)=\lambda u$ where $\lambda$ is a scalar.
# Eigenvalues
$\underline{\text{Definition}}-$ The scaling factor by which eigenvectors get scaled upon being transformed are called eigenvalues.

The polynomial equation obtained while doing $\operatorname{det}(A - \lambda I) = 0$ is called the **characteristic polynomial**. The roots of this polynomial are the eigenvalues. Due to this, eigenvalues can be-
1. Real and distinct
2. Real but repeated
3. Complex
## Similarity of Matrices
Two matrices are similar if their eigenvalues are the same.
## Multiplicities of Eigenvalues
1. **Algebraic Multiplicity (AM )-** The number of times an eigenvalue is repeated.
2. **Geometric Multiplicity (GM) -** The number of linearly independent eigenvectors associated with a particular eigenvalue.
3. **Note -** GM $\le$ AM for each eigenvalue $\lambda$. If GM $\lt$ AM for any specific eigenvalue, we say that the corresponding eigenvalue is deficient. ^09bfa8
## Distinct eigenvalues
If the eigenvalues of a transformation are distinct, the eigenvectors are linearly independent.

$\underline{\text{Proof}}-$ Consider a linear transformation on $\mathbb{R}^2$ which has $u_1$ and $u_2$ as its two non-zero eigenvectors and $\lambda_1$ and $\lambda_2$ as the two distinct eigenvalues corresponding to these vectors.

If $u_1$ and $u_2$ are linearly independent, $\alpha_1 u_1 + \alpha_2 u_2 = 0$ for $\alpha_1, \alpha_2 \ne 0$.
$$
\begin{alignat*}{3}
&&\alpha_1 u_1 + \alpha_2 u_2 &= 0 \tag{1}\\[8pt]
&\Rightarrow \,\,&T(\alpha_1 u_1 + \alpha_2 u_2) &= T(0) \\[8pt]
&\Rightarrow \,\,&\alpha_1 T(u_1) + \alpha_2 T(u_2) &= 0 \\[8pt]
&\Rightarrow \,\,&\alpha_1 \lambda_1u_1 + \alpha_2 \lambda_2u_2 &= 0 \tag{2}\\[8pt]
\end{alignat*}
$$

If we multiply $(1)$ by $\lambda_1$ and subtract the result with $(2)$, we get -
$$
\alpha_2 (\lambda_1 - \lambda_2) u_2 = 0 \\[8pt]
$$

Because we know that $\lambda_1$ and $\lambda_2$ are distinct and that $u_2$ is a non-zero eigenvector, $\alpha_2=0$. Using this information we can show that $\alpha_1=0$.

Thus, if the eigenvalues are distinct, the eigenvectors are linearly independent.
# Diagonalization
Let $A$ be a matrix in $\mathbb{R}^n$ with a set of $n$ linearly independent vectors. We can make a matrix $P$ with these eigenvectors as its columns. 

$$
p = \left[
\begin{matrix}
\vdots &\vdots &\vdots &\vdots \\
u_1 & u_2 &\dots &u_n\\
\vdots &\vdots &\vdots &\vdots \\
\end{matrix}
\right]
$$

If we do $AP$ then,

$$
\begin{aligned}
AP &= A[\begin{array}& u_1 & u_2 &\dots &u_n\end{array}] \\[8pt]
&= [\begin{array} &Au_1 & Au_2 &\dots &Au_n\end{array}] \\[8pt]
&= [\begin{array} &\alpha_1u_1 & \alpha_2u_2 &\dots &\alpha_nu_n\end{array}] \\[8pt]
&= [\begin{array}& u_1 & u_2 &\dots &u_n\end{array}] \left[
\begin{matrix}
\alpha_1 & 0 &\dots &0 \\
0 &\alpha_2 &\dots &0 \\
\vdots&\vdots&\vdots&\vdots& \\
0 &0 &\dots &\alpha_n \\
\end{matrix}
\right] \\[8pt]
&= PD
\end{aligned}
$$

So we end up with 
$$
\boxed{AP = PD}
$$

Because $P$ is made up of $n$ linearly independent eigenvectors belonging to $\mathbb{R}^n$, $P$ is a square and invertible matrix. Thus we can also say,
$$
\boxed{A = PDP^{-1}}
$$

$\underline{\text{Definition}}-$ Any matrix in $\mathbb{R}^n$ with $n$ linearly independent eigenvectors can be decomposed as a product of matrices formed using its eigenvalues and eigenvectors. This is called the **diagonalization** or **eigen decomposition** of the matrix.

If any eigenvalue of a matrix is [[Eigenvalues and Eigenvectors#^09bfa8|deficient]], it'll mean that we don't have enough eigenvectors needed to capture the whole $n-$dimensional space. Thus in such a case the matrix is un-diagonalizable.
## Powers of a diagonalizable matrix
If $A$ is diagonalizable, it can be decomposed into a product of eigen matrices. These eigen matrices can be used to write the power of matrix $A$.

$$
\begin{alignedat}{3}
&&A &= PDP^{-1} \\[8pt]
&\Rightarrow &A^2 &= (PDP^{-1})(PDP^{-1}) \\[8pt]
&&&=PD\cancel{P^{-1}P}DP^{-1} \\[8pt]
&&&=PD^2P^{-1} \\[8pt]
\end{alignedat}
$$

This can be generalized to $\boxed{A^n = PD^nP^{-1}}$.

As $D$ is a diagonal matrix, calculating the powers of $D$ becomes trivial.
$$
\begin{alignedat}{2}
&&D^2 &= \left[\begin{matrix}
\alpha_1 & 0 &\dots &0 \\
0 &\alpha_2 &\dots &0 \\
\vdots&\vdots&\vdots&\vdots& \\
0 &0 &\dots &\alpha_n \\
\end{matrix}
\right]

\left[\begin{matrix}
\alpha_1 & 0 &\dots &0 \\
0 &\alpha_2 &\dots &0 \\
\vdots&\vdots&\vdots&\vdots& \\
0 &0 &\dots &\alpha_n \\
\end{matrix}
\right] \\[8pt]

&&& = \left[\begin{matrix}
\alpha_1^2 & 0 &\dots &0 \\
0 &\alpha_2^2 &\dots &0 \\
\vdots&\vdots&\vdots&\vdots& \\
0 &0 &\dots &\alpha_n^2 \\
\end{matrix}
\right] \\[8pt]

&&D^n &= \left[\begin{matrix}
\alpha_1^n & 0 &\dots &0 \\
0 &\alpha_2^n &\dots &0 \\
\vdots&\vdots&\vdots&\vdots& \\
0 &0 &\dots &\alpha_n^n \\
\end{matrix}
\right] \\[8pt]
\end{alignedat}
$$

As $n \rightarrow \infty$, 
- If any eigenvalue $|\alpha_i| \lt 1$ then $\alpha_i^n=0$. 
- If any $|\alpha_i| > 1$ then $\alpha_i^n$ tends to $\pm \infty$.
- If any $|\alpha_i| = \pm1$ then $\alpha_i^n=\pm1$. 
## Spectral Theorem
The **Spectral Theorem** states that every real symmetric matrix can be orthogonally diagonalized.

So if $A$ is a real symmetric matrix, then there always exists an orthogonal matrix $Q$ and a diagonal matrix $\Lambda$ such that,

$$
A = Q\Lambda Q^T
$$
# Singular Value Decomposition
