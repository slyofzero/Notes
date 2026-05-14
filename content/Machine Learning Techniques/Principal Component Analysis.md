# Direction of maximum variance

![[Pasted image 20260513195843.png]]

Let's say we have a set of datapoints for which we wish to obtain a "compressed" representation using a line. The line that can best act as a representative for these data points must have the minimum reconstruction error.

For any datapoint $x_i$ and the representative line $w$, the representation of $x_i$ on $w$ is the [[Othogonality#Orthogonal Projections|projection]] of $x_i$ on $w$, i.e. $(x_i^Tw)w$.

To find such a $w$, we wish to obtain $\arg\min \operatorname{Error(Line, Dataset)}$ where,

$$
\begin{aligned}
\operatorname{Error(Line, Dataset)} &= \frac{1}{n}\sum_{i=1}^n \operatorname{length}(x_i - (x_i^Tw)w) \\[8pt]
&= \frac{1}{n}\sum_{i=1}^n (x_i - (x_i^Tw)w)^T (x_i - (x_i^Tw)w) \\[8pt]
&= \frac{1}{n}\sum_{i=1}^n \left[x_i^Tx_i - (x_i^Tw)^2 - (x_i^Tw)^2 + (x_i^Tw)^2w^Tw \right]\\[8pt]
&= \frac{1}{n}\sum_{i=1}^n \left[x_i^Tx_i - (x_i^Tw)^2 \right] \qquad (\text{If w is a unit vector}) \\[8pt]
\end{aligned}
$$

In this above error term, the $x_i^Tx_i$ term is independent of $w$. Thus the error can be re-written as,

$$
\begin{aligned}
\operatorname{Error(Line, Dataset)} = \frac{1}{n}\sum_{i=1}^n - (x_i^Tw)^2 \\[8pt]
\end{aligned}
$$

^cd6f99

And thus the optimization problem can becomes a maximization of error instead. ^fff7db

$$
\begin{aligned}
\arg\max \, &\operatorname{Error(Line, Dataset)} \\[8pt]

\operatorname{Error(Line, Dataset)} &= \frac{1}{n}\sum_{i=1}^n (x_i^Tw)^2 \\[8pt]
&= \frac{1}{n}\sum_{i=1}^n (w^Tx_i)(x_i^Tw) \\[8pt]
&= \frac{1}{n}\sum_{i=1}^n w^T(x_ix_i^T)w \\[8pt]
&= w^T \left(\frac{1}{n}\sum_{i=1}^n (x_ix_i^T) \right)w \\[8pt]
&= w^T \Sigma_x w \\[8pt]
\end{aligned}
$$

Where $\Sigma_x$ is the covariance matrix for the random vector $[x_1, x_2, \dots, x_n]$. If we recall the properties of the covariance matrix, we can see that the above form of the error function heavily resembles the [[Random Variables#^1db2b3|variance of a random vector]].

> Also notice how the formula we arrive at is similar to the [[Random Variables#^504a5c|covariance formula for a random vector]], with just the mean being 0. This means that **centering the data is essential for variance maximization.**

Thus the best representative line $w$ will be the one that captures that maximum variance in the dataset.
# Residual Analysis
The residue left after determining a representation for $x_i$ need not be error. It can still hold some information crucial for a full reconstruction of the original dataset.

Some observation about the residues -
1. All residues are orthogonal to the first representation $w_1$.
2. Any line which minimizes the sum of errors w.r.t the residuals must also be orthogonal to $w_1$ as all such lines would lie in the [[Othogonality#Orthogonal Complement|orthogonal complement]] of $w_1$.

If $\{x_1, x_2, \dots, x_n\}$ are our original datapoints, the residues left after representing them using $w_1$ would be 

$$
\{x_1 - (x_1^Tw_1)w_1, \,\,x_2 - (x_2^Tw_1)w_1, \,\,\dots, \,\,x_n - (x_n^Tw_1)w_1\}
$$

We can then find another line in the orthogonal complement of $w_1$ which would minimize the sum of errors w.r.t these residuals and yield us new residues $-$

$$
\begin{aligned}
&&\{x_1 - (x_1^Tw_1)w_1 - ((x_1 - (x_1^Tw_1)w_1)^Tw_2)w_2\} \\[8pt]
&\Rightarrow &\{x_1 - (x_1^Tw_1)w_1 - (x_1^Tw_2 - (x_1^Tw_1)w_1^Tw_2)w_2\} \\[8pt]
&\Rightarrow &\{x_1 - (x_1^Tw_1)w_1 - (x_1^Tw_2)w_2\} \\[8pt]
\end{aligned}
$$

Thus the residue after $d$ rounds would be,

$$
\left\{x_1 - \sum_{i=1}^d(x_1^Tw_1)w_1 = \vec 0\right\}
$$

because after $d$ rounds, we'd be left with $d$ orthonormal basis which would span all of $\mathbb R^d$.

**Note -** If the datapoints lie in a low dimensional subspace of $\mathbb R^d$ then the residues would become 0 much earlier than $d$ rounds.

For any $w \in \mathbb R^d$, such that $||w||_2^2 = 1$

$$
\begin{alignedat}{2}
&&||x_i||^2 &= ||x_i - (x_i^Tw)||^2 + ||(x_i^Tw)w||^2 \\[8pt]
&\Rightarrow &||x_i||^2 &= \underbrace{||x_i - (x_i^Tw)||^2}_{\text{Error}} + \underbrace{||(x_i^Tw)w||^2}_{\text{Representation}} \\[8pt]
\end{alignedat}
$$

We want this representation term to be as large as possible for a better fit.
# Eigenvalues of the Covariance Matrix
The [[#^fff7db|optimization problem]] discussed above can be solved using the **Hilbert's Min-Max Theorem**. This tells us that $w_1$ is the eigenvector of $\Sigma_x$ corresponding to the largest eigenvalue of $\Sigma_x$.

If $w_1$ is an eigenvector of $\Sigma_x$, we can say that

$$
\begin{aligned}
&&\Sigma_xw_1 &= \lambda_1w_1 \\[8pt]
&\Rightarrow &w_1^T\Sigma_xw_1 &= w_1^T\lambda_1w_1 \\[8pt]
&\Rightarrow &w_1^T\Sigma_xw_1 &= \lambda_1 \qquad &\because w^Tw = 1\\[8pt]
&\Rightarrow &\lambda_1 &= w_1^T \frac{1}{n}\sum_{i=1}^n(x_ix_i^T) w_1 \\[8pt]
&\Rightarrow &\lambda_1 &= \frac{1}{n}\sum_{i=1}^n(x_i^Tw_1)^2 \\[8pt]
\end{aligned}
$$

This is exactly the [[#^cd6f99|optimization error]] term we used earlier to restructure the error as variance. Thus we can say that the largest eigenvalue of the covariance matrix is literally the variance of the data projected onto $w_1$. 

Because the covariance matrix is symmetric, the eigenvectors for it will be orthogonal. Thus the eigenvector $w_2$ corresponding to the second highest eigenvalue $\lambda_2$ will naturally lie in the orthogonal complement of $w_1$ and $\lambda_2$ would correspond to the variance of the data projected onto $w_2$.

Sequentially, all eigenvalues of the covariance matrix would in-turn correspond to the variance of the data projected onto the eigenvector corresponding to them.
## Rule of thumb for dimensions
The most common assumption is that any data point $x_i$ is made up of two components. The actual signal $s_i$ and the random noise $\epsilon_i$. Because this noise is random in nature, it doesn't have a particular pattern which it follows. It has not preferred direction, tends to be small in magnitude, and contributes a small and roughly equal amount of variance in every direction.

Thus by looking at the eigenvalues of our covariance matrix, we can say that the smaller eigenvalues may correspond to this random noise and the eigenvectors corresponding to these eigenvalues are redundant for a proper reconstruction of the original data. So instead of trying to capture all the variance in our original data, we can only use some top $k$ eigenvalues and their corresponding eigenvectors to capture some $t$ threshold of variance, typically 0.95.

We can identify our top $k$ directions by doing $-$

$$
\frac{\sum_{i=1}^k \lambda_i(\Sigma_x)}{\sum_{i=1}^d \lambda_i(\Sigma_x)} \ge 0.95
$$

Because all eigenvalues correspond to variance which is non-negative, this summation will be non-decreasing.

![[Pasted image 20260514095301.png]]

Let the green line represent $w_1$ and the blue line represent $w_2$. Notice how the variance of the data along $w_1$ is much more than the variance of the data on $w_2$.