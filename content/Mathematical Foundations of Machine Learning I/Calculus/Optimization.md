>[!SUMMARY] Table of Contents
>- [[Optimization#Gradient Descent|Gradient Descent]]
>- [[Optimization#Convexity|Convexity]]
>	- [[Optimization#Convex Sets|Convex Sets]]
>		- [[Optimization#Properties -|Properties -]]
>	- [[Optimization#Convex Combinations|Convex Combinations]]
>	- [[Optimization#Convex Functions|Convex Functions]]
>		- [[Optimization#Properties -|Properties -]]
>- [[Optimization#Questions|Questions]]
# Gradient Descent
\<Intentionally left blank for now\>
# Convexity
## Convex Sets
A set is a convex set if $\forall x_1, x_2 \in S$, $\lambda x_1 + (1 - \lambda)x_2 \in S$ where $\lambda \in [0,1]$. Geometrically speaking, the below sets are a convex set -

![[Pasted image 20260217104309.png|550]]

### Properties -
1. If $A$ and $B$ are two convex sets then $A \cap B$ is also a convex set.
$$
\begin{aligned}
\text{Let } x_1 \text{ and } x_2 \in A \cap B. &\text{We can say,} \\[8pt]
\lambda x_1 + (1 - \lambda)x_2 &\in A \text{ because } x_1, x_2 \in A \\[8pt]
\lambda x_1 + (1 - \lambda)x_2 &\in B \text{ because } x_1, x_2 \in B \\[8pt]
\text{Thus we can say that } x_1, &x_2 \in A \cap B.
\end{aligned}
$$

This property is helpful in showing if a set is convex, by showing that the set is formed by intersection of two other convex sets.
## Convex Combinations
Let $S = \{x_1, x_2, \dots, x_n\} \subseteq \mathbb R ^n$. Then we say that $z \in \mathbb R ^n$ is a convex combination of vectors in $S$ if $\exists \lambda_1, \lambda_2, \dots, \lambda_n$ such that $\lambda_i \ge 0$ and $\sum \lambda_i = 1$ and 

$$
z = \lambda_1 x_1 + \lambda_2x_2 + \dots + \lambda_nx_n
$$

The **convex hull** of a set $S$, denoted by $\operatorname{conv}(S)$ or $\operatorname{CH}(S)$ is the set of all convex combinations of the elements of the set $S$.

$$
CH(\{x_1, x_2, \dots, x_n\}) = \left\{z\,\,|\,\,z=\sum_{i=1}^n\lambda_ix_i, \lambda_i \ge 0 \text{ and } \sum_{i=1}^n \lambda_i = 1\right\}
$$

An alternate definition of a convex hull can be that, the convex hull of a set is the intersection of all convex sets that contain $\{x_1, x_2, \dots, x_n\}$. The two definitions can be shown to be equivalent.

**Important Exercise** – [Show that Euclidean Balls are Convex Sets](https://youtu.be/PfDvKJ2UTPg?list=PLZ2ps__7DhBammhVmBE9f5eezTj2kDfTN&t=1004)
## Convex Functions
$\underline{\text{Definition 1}}$ – A function $f: \mathbb R^d \rightarrow \mathbb R$ is a convex function iff $\operatorname{epi}(f) \in \mathbb R^{d+1}$ is a convex set. 

$\operatorname{epi}$ stands for **epigraph** of a function. An epigraph is the set of all points above the graph's curve -

$$
\begin{aligned}
\operatorname{epi}(f) = \{(x,y) \in \mathbb R^n \times \mathbb R \,\,|\,\, t \ge f(x)\}
\end{aligned}
$$

The opposite of an epigraph is a **hypograph**.

$\underline{\text{Definition 2}}$ – A function $f: \mathbb R^d \rightarrow \mathbb R$ is a convex function iff $\forall x_1, x_2 \in \mathbb R^d$ and all $\lambda \in [0,1]$  ^bec74f

$$
\begin{aligned}
f(\lambda x_1 + (1-\lambda x_2)) &\le \lambda f(x_1) + (1-\lambda)f(x_2)  \\[8pt]
\text{OR more} & \text{ generalized} \\[8pt]
f\left(\sum_{k=1} \lambda_k a_k\right) &\le \sum_{k=1} \lambda_k f(a_k)
\end{aligned}
$$

For concave functions this inequality becomes,

$$
f\left(\sum_{k=1} \lambda_k a_k\right) \ge \sum_{k=1} \lambda_k f(a_k)
$$


![[Pasted image 20260222181747.png|450]]

$\underline{\text{Definition 3}}$ – A function $f: \mathbb R^d \rightarrow \mathbb R$ is a convex function iff $f$ is differentiable and, ^104fc1

$$
f(y) \ge f(x) + \nabla f(x)^T(y-x)  \qquad \forall x,y \in \mathbb R^d
$$

![[Pasted image 20260222181819.png|450]]

This means that the tangent plane lower bounds the function for every point in its domain.

$\underline{\text{Definition 4}}$ – A function $f: \mathbb R^d \rightarrow \mathbb R$ is a convex function iff it is twice differentiable.
### Properties -

<h4>
1) In a convex function f, x* is a global minima iff its gradient is 0.
</h4>

$\underline{\text{Proof}} -$ 
$(1)$ We need to first show that if $x^*$ is a global minima, $\nabla f(x^*) = 0$. This can be shown easily by using the concept of steepest descent. At any point, the direction of steepest descent is $-\nabla f(x^*)$. So if $\nabla f(x) \ne 0$ for any point $x$, we can show that there exists another point in the direction of [[Basics of Calculus#Directional Derivative|steepest descent]] such that $f(x - \eta \nabla f(x^*)) \lt f(x)$. Thus if $\nabla f(x^*) \ne 0$ then $x^*$ can't be a minima, let alone a global minima.

Thus points where no such direction of steepest descent would exist will have $\nabla f(x^*) = 0$. Thus the gradient at the global minima must be $0$.

$(2)$ Now we need to show the reverse, that in convex functions if $\nabla f(x^*) = 0$ then $x^*$ is a global minima. We know by [[#^104fc1|Definition 3]] that the tangent plane at any point of the graph lower bounds the function. So even at the global minima $x^*$ we can say,

$$
\begin{alignedat}{3}
&& f(y) &\ge f(x) + \nabla f(x)^T(y-x) \qquad \forall x,y \in \mathbb R^d\\[8pt]
&\Rightarrow & f(y) &\ge f(x^*) + \nabla f(x^*)^T(y-x^*) \\[8pt]
&\Rightarrow & f(y) &\ge f(x^*) \\[8pt]
\end{alignedat}
$$

Hence we can say that $x^*$ is a global minima.

<h4>
2) If f and g are two convex functions, then h(x) = f(x) + g(x) is also a convex function.
</h4>

This can be proved easily using [[#^bec74f|Jensen's Inequality]] of convex functions. Try it out!
<h4>
3) If f is a convex and non-decreasing function and g is any convex function, then h(x) = fog(x) is also a convex function.
</h4>

This can again be proved easily using [[#^bec74f|Jensen's Inequality]] of convex functions. Try it out!

<h4>
4) If f is a convex function and g is a linear function, then h(x) = fog(x) is also a convex function.
</h4>
This can again be proved easily using [[#^bec74f|Jensen's Inequality]] of convex functions along with the property of linear functions. Try it out!

**Note -** In general if $f$ and $g$ are convex, the composition $h(x) = fog(x)$ may not be convex.

---
# Questions
<h6 class="question">Q1) Show that log is a concave function -</h6>
$\underline{\text{Sol}^n} -$ 
We can use the reverse of [[#^bec74f|Jensen's Inequality]] for this purpose. If we are able to show that,

$$
\operatorname{log}(\lambda x + (1 - \lambda)y) \ge \lambda \operatorname{log}(x) + (1 - \lambda) \operatorname{log}(y) \qquad x,y > 0, \lambda \in [0,1]
$$

For this we can try removing the $\operatorname{log}$ from both sides and put everything to the left side and show that the unified equation is greater than or equal to $0$. So we can rewrite the above requirement as,

$$
\begin{alignat*}{3}
&&\operatorname{log}(\lambda x + (1 - \lambda)y) &\ge \lambda \operatorname{log}(x) + (1 - \lambda) \operatorname{log}(y) \\[8pt]
&\Rightarrow &\,\,\operatorname{log}(\lambda x + (1 - \lambda)y) &\ge \operatorname{log}(x^\lambda) + \operatorname{log}(y^{(1 - \lambda)}) \\[8pt]
&\Rightarrow &\,\,\operatorname{log}(\lambda x + (1 - \lambda)y) &\ge \operatorname{log}(x^\lambda \cdot y^{(1 - \lambda)}) \\[8pt]
&\Rightarrow &\lambda x + (1 - \lambda)y &\ge x^\lambda \cdot y^{(1 - \lambda)} \\[8pt]
&\Rightarrow &\lambda \frac{x}{y} + (1 - \lambda) &\ge x^\lambda \cdot y^{- \lambda} \\[8pt]
&\Rightarrow &\lambda t + (1 - \lambda) &\ge t^\lambda &\because t=\frac{x}{y} \\[8pt]
&\Rightarrow &\lambda t + (1 - \lambda) - t^\lambda &\ge 0 \tag{1} \\[8pt]
\end{alignat*}
$$

We can differentiate this term to get its minima, and if the minima is $\ge 0$ then we can say that the entire equation is always non-negative.

$$
\begin{alignedat}{3}
&& q(t) &= \lambda t + (1 - \lambda) - t^\lambda \\[8pt]
&\Rightarrow& \,\,q'(t) &= \lambda + - \lambda t^{\lambda - 1} \\[8pt]
\end{alignedat}
$$

For the some $t^*$ to be the minima of $q$, $q'(t^*) = 0$. So,

$$
\begin{alignedat}{3}
&& q'(t^*) &= \lambda + - \lambda t^{*^{\lambda - 1}} \\[8pt]
&\Rightarrow& \,\, 0 &= \lambda(1 - t^{*^{\lambda - 1}}) \\[8pt]
\end{alignedat}
$$

If $\lambda \ne 0$ then then only $t^* = 1$ can satisfy the above equation. Because $q(1) = 0$, we can say that $\forall t > 0, q(t) \ge 0$. Hence we have proven that $(1)$ is true and consequently proven that $\operatorname{log}$ is a concave function.