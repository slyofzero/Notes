>[!SUMMARY] Table of Contents
>- [[Asymptotic Notation#Types of Bound|Types of Bound]]
>- [[Asymptotic Notation#Types of Notations|Types of Notations]]
>- [[Asymptotic Notation#Big Notations|Big Notations]]
>	- [[Asymptotic Notation#1. Big Oh |1. Big Oh ]]
>	- [[Asymptotic Notation#2. Big Omega |2. Big Omega ]]
>	- [[Asymptotic Notation#3. Big Theta |3. Big Theta ]]
>- [[Asymptotic Notation#Small Notations|Small Notations]]
>	- [[Asymptotic Notation#1. Small Oh |1. Small Oh ]]
>	- [[Asymptotic Notation#2. Small Omega |2. Small Omega ]]
>- [[Asymptotic Notation#Properties of Asymptotic Notations|Properties of Asymptotic Notations]]
>	- [[Asymptotic Notation#General Properties of Big Oh Notation|General Properties of Big Oh Notation]]
>	- [[Asymptotic Notation#Adding Functions|Adding Functions]]
>	- [[Asymptotic Notation#Multiplying Functions|Multiplying Functions]]
>	- [[Asymptotic Notation#Trichotomy Property|Trichotomy Property]]
>	- [[Asymptotic Notation#Discrete Properties of Asymptotic Notations|Discrete Properties of Asymptotic Notations]]
# Types of Bound
1. Upper Bound -
	1. Tight Upper Bound
	2. Loose Upper Bound
2. Lower Bound -
	1. Tight Lower Bound
	2. Loose Lower Bound

![[bounds.png]]

# Types of Notations
1. Big Notation - Bounds that may or may not be tight.
	1. Big Oh $\rightarrow O$
	2. Big Omega $\rightarrow \Omega$
2. Small Notation - Bound that are always loose, never tight
	1. Small Oh $\rightarrow o$
	2. Small Omega $\rightarrow \omega$
# Big Notations
The big notations always provide lower/upper bound that may or may not be tight.
## 1. Big Oh $(O)$
$f(n) = O(g(n))$ if there exists some constant $c > 0$ and $n_0 > 0$ such that -
$$f(n) \ \le  \  c \ * \ g(n) \ ;\  \forall \ n \ge n_0$$
In simpler words this means – For large values of $n$, the growth of function $f(n)$ is bounded above by a constant multiple of $g(n$).

---
<h6 class="question">Q1) Show that -</h6>

$$f(n) = n^2 + n + 1 = O(n^2)$$
<strong><u>Sol</u></strong>$^n$ - We know that -
1. $n^2 \ge n^2$
2. $n^2 \ge n$
3. $n^2 \ge 1 \ ; \ \forall n \ \ge 1$

Thus $n^2 + n + 1 \ \le 3n^2$ where $c = 3$ and $n_0 = 1$.
Thus $f(n) = O(n^2)$.

$Q.E.D.$

---
## 2. Big Omega $(\Omega)$
$f(n) = \Omega(g(n))$ if there exists some constant $c > 0$ and $n_0 > 0$ such that -
$$f(n) \ \ge  \  c \ * \ g(n) \ ;\  \forall \ n \ge n_0$$
In simpler words this means – For large values of $n$, the growth of function $f(n)$ is bounded below by a constant multiple of $g(n$).

## 3. Big Theta $(\Theta)$
$f(n) = \Theta(g(n))$ if there exists some constant $c_1 > 0, \ c_2 > 0$ and $n_0 > 0$ such that -
$$ c_1 \ * \ g(n)\ \le \ f(n) \ \le  \  c_2 \ * \ g(n) \ ;\  \forall \ n \ge n_0$$
In simpler words – When for large values of $n$ the growth of $f(n)$ is bounded above and below by constant multiples of the same function $g(n)$, we say $g(n)$ is the **Tight-Bound** of $f(n)$.

$f(n) = O(g(n))$ and $f(n) = \Omega(g(n))$.

---
<h6 class="question">Q2) Find the tight bound of the below function -</h6>

$$f(n) = \sum_{a=1}^n \left( \frac{1}{5} \right)^a$$

<u><strong>Sol</strong></u>$^n$ - Using the [[Analysis of Algorithms#Geometric Progression -|Sum of GP]] 
$$f(n) = \frac{1}{4} \left(1 - \frac{1}{5^n} \right)$$
As $\lim_{n\rightarrow\infty} f(n) = \frac{1}{4}$, $f(n) = \Theta(1)$

![[Pasted image 20251225201806.png]]

*Another reasoning can be that $\frac{1}{5}$ being a constant dominated the decreasing function $1-\frac{1}{5^n}$*.

---
<h6 class="question">Q3) Find the tight bound of the below function -</h6>

![[Pasted image 20251225202634.png|400]]

<u><strong>Sol</strong></u>$^n$ -
- Here, $f(n) = n!$. For each $i$ in the product, we can say $i \le n$. Thus $n! = O(n^n)$.
- At the same time $n * (n-1) * (n-2) * \dots * 1 \not\ge c * n^n$ for any value of $c$. 
  Thus $f(n) \ne \Omega(n)$ and thus $f(n) \ne \Theta(n)$.
---
<h6 class="question">Q4) Find the tight bound of the below function -</h6>

$$f(n) = \sum_{a=1}^n log \ i$$
<u><strong>Sol</strong></u>$^n$ -
$$
\begin{aligned}
\sum_{a=1}^n log \ i & = log(1) + log(2) + \dots + log(n) \\
& = log(1 * 2*\dots*n) \\
& = log(n!) \\

\end{aligned}
$$
$$
\begin{aligned}
log(n) &\le log(n) \\
log(n) + log(n-1) + \dots + log(1) &\le log(n) + log(n) + \dots + log(n) \\
log(n!) &\le n \cdot log(n)\\
log(n!) &= O(n\cdot log(n))
\end{aligned}
$$
---
# Small Notations
The big notations always provide lower/upper bound that are loose, never tight.

## 1. Small Oh $(o)$
$f(n) = o(g(n))$ if there exists all constant $c > 0$ and some $n_0 \ge 0$ such that -
$$f(n) \ \lt  \  c \ * \ g(n) \ ;\  \forall \ n \ge n_0$$
In simple words – $f(n)$ grows strictly slower than $g(n)$, and no constant multiple of $g(n)$ is a tight bound for $f(n)$.

Key Difference from $O$ -
1. The inequality constraint must satisfied for **all** positive constants, not **some**.
2. The inequality constraint is a strict inequality.
## 2. Small Omega $(\omega)$
$f(n) = \omega(g(n))$ if for all constant $c > 0$ and some $n_0 \ge 0$ such that -
$$f(n) \ \gt  \  c \ * \ g(n) \ ;\  \forall \ n \ge n_0$$
In simple words – $f(n)$ grows strictly faster than $g(n)$, and no constant multiple of $g(n)$ is a tight bound for $f(n)$.

# Properties of Asymptotic Notations
## General Properties of Big Oh Notation
1. If $d(n) \ = \ O(f(n))$ $\rightarrow$ $a \cdot d(n) \ = \ O(f(n))$
2. If $d(n) \ = \ O(f(n))$ and $e(n) \ = \ O(g(n))$ $\rightarrow$ $d(n) \ + \ e(n) \ = \ O(f(n) + g(n))$
3. If $d(n) \ = \ O(f(n))$ and $e(n) \ = \ O(g(n))$ $\rightarrow$ $d(n) \cdot e(n) \ = \ O(f(n) \cdot g(n))$
4. If $d(n) \ = \ O(f(n))$ and $f(n) \ = \ O(g(n))$ $\rightarrow$ $d(n) \ = \ O(g(n))$
5. $n^x = O(a^n)$  for any fixed $x > 0$ and $a > 1$
6. $log(n^x) = O(log(n))$  for any fixed $x > 0$
7. $log^x(n) = O(n^y)$  for any fixed constants $x > 0$ and $y > 0$
## Adding Functions
1. $O(f(n)) + O(g(n)) \ \rightarrow \ O(max(f(n), \ g(n))$
2. $\Omega(f(n)) + \Omega(g(n)) \ \rightarrow \ \Omega(max(f(n), \ g(n))$
3. $\Theta(f(n)) + \Theta(g(n)) \ \rightarrow \ \Theta(max(f(n), \ g(n))$
## Multiplying Functions
1. $O(f(n)) * O(g(n)) \ \rightarrow \ O(f(n) * g(n))$
2. $\Omega(f(n)) * \Omega(g(n)) \ \rightarrow \ \Omega(f(n) * g(n))$
3. $\Theta(f(n)) * \Theta(g(n)) \ \rightarrow \ \Theta(f(n) * g(n))$
## Trichotomy Property
The Trichotomy Property for real numbers says that for any two real numbers $x$ and $y$ **only** one of the three cases is true -
1. $x \gt y$
2. $x = y$
3. $x \lt y$

The Asymptotic Notations do not define a total order on functions and therefore do not satisfy the Trichotomy Property. For any two functions $f(n)$ and $g(n)$, it is not guaranteed that one of the following holds -
1. $f(n) = O(g(n))$
2. $f(n) = \Theta(g(n))$
3. $f(n) = \Omega(g(n))$

There exist functions that are incomparable under asymptotic growth. One such pair of functions is -
$$f(n) = n \ ; \ g(n) = n^{(1 + sin \ n)}$$
## Discrete Properties of Asymptotic Notations
| Notation | Reflexive | Symmetric | Transitive | Transpose Symmetry |
| :------: | :-------: | :-------: | :--------: | :----------------: |
|   $O$    |     T     |     F     |     T      |         T          |
| $\Omega$ |     T     |     F     |     T      |         T          |
| $\Theta$ |     T     |     T     |     T      |         F          |
|   $o$    |     F     |     F     |     T      |         T          |
| $\omega$ |     F     |     F     |     T      |         T          |
1. **Reflexivity** - All notations that allow equality are reflexive.
2. **Symmetric** - Only possible for tight bound.
3. **Transitivity** - Possible for all.
4. **Transpose Symmetry** - If $f(n) = O(g(n))$ then $g(n) = \Omega(f(n))$. Only $\Theta$ doesn't have any such relation.