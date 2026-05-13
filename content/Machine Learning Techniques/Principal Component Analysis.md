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

And thus the optimization problem can becomes a maximization of error instead.

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
# Early Stopping
For any $w \in \mathbb R^d$, such that $||w||_2^2 = 1$

$$
\begin{alignedat}{2}
&&||x_i||^2 &= ||x_i - (x_i^Tw)||^2 + ||(x_i^Tw)w||^2 \\[8pt]
&\Rightarrow &||x_i||^2 &= \underbrace{||x_i - (x_i^Tw)||^2}_{\text{Error}} + \underbrace{||(x_i^Tw)w||^2}_{\text{Representation}} \\[8pt]
\end{alignedat}
$$

We want this representation term to be as large as possible, 