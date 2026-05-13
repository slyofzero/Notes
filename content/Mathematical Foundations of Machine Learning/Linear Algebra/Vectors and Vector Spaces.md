>[!SUMMARY] Table of Contents
>- [[Vectors and Vector Spaces#Vector|Vector]]
>- [[Vectors and Vector Spaces#Field|Field]]
>- [[Vectors and Vector Spaces#Vector Space|Vector Space]]
>	- [[Vectors and Vector Spaces#Subspaces|Subspaces]]
>- [[Vectors and Vector Spaces#Linear Combinations|Linear Combinations]]
>	- [[Vectors and Vector Spaces#Affine Combination|Affine Combination]]
>- [[Vectors and Vector Spaces#Linear Dependence|Linear Dependence]]
>- [[Vectors and Vector Spaces#Span, Basis, and Dimension|Span, Basis, and Dimension]]
>	- [[Vectors and Vector Spaces#Span|Span]]
>	- [[Vectors and Vector Spaces#Basis|Basis]]
>		- [[Vectors and Vector Spaces#Uniqueness of Representation Theorem|Uniqueness of Representation Theorem]]
>	- [[Vectors and Vector Spaces#Dimension|Dimension]]
>- [[Vectors and Vector Spaces#Hyperplanes|Hyperplanes]]
>	- [[Vectors and Vector Spaces#Linear Hyperplane|Linear Hyperplane]]
>		- [[Vectors and Vector Spaces#Linear functions|Linear functions]]
>	- [[Vectors and Vector Spaces#Affine Hyperplane|Affine Hyperplane]]
>		- [[Vectors and Vector Spaces#Affine functions|Affine functions]]
# Vector
What is a vector?
- **The Physics definition -** A vector is a quantity with both magnitude and direction.
- **The Computer Science definition -** A vector is an ordered tuple of  $n$ components where each component is a scalar value corresponding to certain parameters.
- **The Mathematics definition -** A vector is an element of a *vector space* over a *field* closed under addition and scalar multiplication.

We are interested in the Mathematical definition of a vector when studying Linear Algebra. So we need to under what [[Vectors and Vector Spaces#Field|fields]] and [[Vectors and Vector Spaces#Vector Space|vector spaces]] are.
# Field
A field $\mathbb{F}$ is a non-empty collection of elements with operators $(+,\cdot)$ where,
- $+$ is Field Addition
- $\cdot$ is Field Multiplication
such that -
- $(\mathbb{F},+)$ is an [[Group Theory#Abelian Group|Abelian Group]].
- $(\mathbb{F}/\{0\},\cdot)$ is an [[Group Theory#Abelian Group|Abelian Group]].

**Additive structure $(\mathbb F, +)$ is an abelian group:**
1. **Closure:** $a+b \in \mathbb F$
2. **Associativity:** $(a+b)+c=a+(b+c)$
3. **Identity:** $a + 0 = 0 + a = a$
4. **Inverse:** $a + (-a) = 0$    
5. **Commutativity:** $a+b=b+a$

**Multiplicative structure $(\mathbb F\setminus\{0\}, \cdot)$ is an abelian group:**  
6. **Closure:** $a\cdot b \in \mathbb F\setminus\{0\}$
7. **Associativity:** $(a\cdot b)\cdot c = a\cdot(b\cdot c)$
8. **Identity:** $a\cdot1=a$
9. **Inverse:** $a\cdot a^{-1} = 1$
10. **Commutativity:** $a\cdot b=b\cdot a$

**Link between them:**  
11. **Distributivity:** $a\cdot(b+c)=a\cdot b+a\cdot c$
# Vector Space
A vector space $V$ over a field $\mathbb F$ is a collection of elements closed over -
- Vector Addition $(+)$
- Scalar Multiplication $(\cdot)$

$V$ **is not a field** but "over a field $\mathbb F$". This means that the scalars for scalar multiplication come from $\mathbb F$, not the components for the vectors in $V$. $V$ is an Abelian Group under vector addition and closed under scalar multiplication by a field $\mathbb F$.

**Example -** $\mathbb R^2$ over $\mathbb Q$ is a vector space where the two components of the vectors come from $\mathbb R$ while the scalars for multiplication come from $\mathbb Q$.

**Vector Addition for $u,v,w \in V$ and $a,b \in \mathbb F$:**
1. **Closure:** $u+v \in V$
2. **Associativity:** $(u+v)+w = u+(v+w)$
3. **Identity:** $v+0=v$
4. **Inverse:** $v+(-v)=0$
5. **Commutativity:** $v+w=w+v$

**Scalar Multiplication:**
6. **Closure:** $av \in V$
7. **Associativity:** $a\cdot(b\cdot v)=(a\cdot b )\cdot v$ 
8. **Identity:** $1.v = v$
9. **Inverse:** Because Associativity works, with $b=a^{-1}$ we can satisfy inversion

**Link between them:** 
10. **Distributivity:** $a\cdot(u+v)=au+av$ and $v\cdot(a+b)=av+bv$
## Subspaces
Any subset of the vector space $V$ which by itself satisfies the conditions of a vector space is a subspace of $V$.
- $V$ is a trivial subspace of $V$.
- The **zero vector** is also a trivial subspace of $V$.
- Any subset of $V$ forming a linear geometric structure that passes through the origin is a subspace of $V$.
# Linear Combinations
Suppose we have $k$ vectors $u_1,\dots,u_k$ and $k$ scalars $\alpha_1,\dots,\alpha_k$, each corresponding to a vector. A resultant vector $v$ is a linear combination of vectors $u_1,\dots,u_k$ when -

$$
v = \alpha_1u_1 + \dots + \alpha_ku_k
$$

When,
- $\alpha_i=1, \forall i \in [0,k]$ $v$ is the sum of all vectors.
- $\alpha_i=\frac{1}{n}, \forall i \in [0,k]$ $v$ is the average of all vectors.
- $\sum_{i=1}^k \alpha_i = 1$, $v$ is an **affine combination** of vectors.
## Affine Combination
When sum of all coefficients/scalars in a linear combination add up to 1, we call such a linear combination an **affine combination**.

If, in addition, all coefficients are non-negative, we call this combination a [[Optimization#Convex Combinations|Convex Combination/Weighted Average]]. ^63b436
# Linear Dependence
If some linear combination of vectors results in $\mathbf 0$ such that not all coefficients were 0, we say the vectors are **linearly dependent**.
- If any set of vectors contains the zero vector, then this set is always a linearly dependent set.

If the only way to get the zero vector by performing a linear combination on the vectors is by setting all coefficients as 0, we say the vectors are **linearly independent**.
- A linearly independent set cannot contain the zero vector.
- A single vector is always linearly independent, unless it is the zero vector.
- Any subset of a linearly independent set is always linearly independent.
- Any superset of a linearly independent set is always linearly dependent.
- Two vectors are linearly independent if one is not a multiple of the other.
# Span, Basis, and Dimension
## Span
A span of vectors is a set of all possible linear combinations of the vectors.
- A span of vectors is a vector space.
- Let $S = \{u_1, \dots, u_n\}$ be a set of $n$ linearly independent $n$-component vectors. The **smallest subspace** containing $S$ is $\operatorname{span}(S)$.
## Basis
The basis of a vector space is a set of linearly independent vectors whose span is the entire vector space.
- In the example under span, $S$ is the basis of $\operatorname{span}(S)$.
- Basis of a vector space **need not be unique**. $\mathbb R^n$ has infinitely many basis.
### Uniqueness of Representation Theorem
This theorem states – Any vector in a vector space, would always have a unique representation in terms of the basis.

$\underline{\text{Proof}} -$
Let $S = u_1, \dots, u_k$ be a set of linearly independent vectors. Let,

$$
\qquad x = \alpha_1u_1 + \dots + \alpha_ku_k  \tag{1} \\[8pt]
$$

Let $x$ be represented using a different set of coefficients,

$$
x = \beta_1u_1 + \dots + \beta_ku_k  \tag{2}\\[8pt]
$$

Doing $(1)-(2)$, we get

$$
0 = (\alpha_1 -\beta_1)u_1 + \dots + (\alpha_k -\beta_k)u_k
$$

As $S$ is a set of linearly independent vectors, their linear combination can only be $0$ when the coefficients are $0$. Thus $\alpha_i = \beta_i\,\, \forall i \in [1,k]$. So, any vector $x$ when expressed as a linear combination of a linearly independent set of vectors $S$ has a **unique set of scalars** corresponding to each vector in $S$.

Thus we can say that any vector in a vector space has a **unique representation** in terms of the basis vectors.
## Dimension
The number of elements/vectors in the basis of a vector space is called the dimension of the vector space.
- The basis for a vector space need not be unique, but the dimension of a vector space is always unique.
# Hyperplanes
## Linear Hyperplane
A **linear hyperplane** in $\mathbb{R}^n$ is:
$$
H =\{x \in \mathbb R^n \,\, | \,\, a^Tx = 0\}, a \ne 0
$$
Properties -
1. It is a linear subspace that always passed through the origin.
2. For any vector $a$ there would exit $n-1$ basis for the subspace orthogonal to it. This is the $n-1$ **degrees of freedom**.
3. Here $H$ is the orthogonal complement of $a$. $H = a^\perp = \{x \,\,|\,\, x \perp a\}$.
4. Geometrically, this is a flat subspace passing through the origin.
### Linear functions
Linear functions map a linear subspace to a linear subspace and have $f(0)=0$.
## Affine Hyperplane
An **affine hyperplane** in $\mathbb{R}^n$ is:
$$
H =\{x \in \mathbb R^n \,\, | \,\, a^Tx = b\}, a \ne 0
$$
Properties -
1. Not a subspace of $\mathbb R^n$ unless $b=0$.
2. Still has $n-1$ degrees of freedom + some constant vector.
3. Here $H$ is a translation of a linear hyperplane by some $x_0$.
4. Geometrically, this is a flat $n-1$ dimension surface shifted away from the origin.

An affine subspace is a shifted version of a linear subspace.
### Affine functions
An affine functions maps a linear subspace to an affine set and have $f(0)=b$. An affine set is of the form $f(S) = AS + b$.