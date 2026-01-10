>[!SUMMARY] Table of Contents
>- [[Group Theory#Algebraic Structure|Algebraic Structure]]
>- [[Group Theory#Semi-group|Semi-group]]
>- [[Group Theory#Monoid|Monoid]]
>- [[Group Theory#Group|Group]]
>- [[Group Theory#Abelian Group|Abelian Group]]
>- [[Group Theory#Finite Group|Finite Group]]
>- [[Group Theory#Addition and multiplication modulo operation|Addition and multiplication modulo operation]]
>- [[Group Theory#Order of an element|Order of an element]]
>- [[Group Theory#Subgroup|Subgroup]]
>- [[Group Theory#Cyclic Group|Cyclic Group]]
>	- [[Group Theory#Klein-4 Groups|Klein-4 Groups]]
>	- [[Group Theory#Number of generators of a cyclic group|Number of generators of a cyclic group]]
>- [[Group Theory#Questions|Questions]]
# Algebraic Structure
A non-empty set $S$ w.r.t binary operation $*$ is called an algebraic structure if and only if -
1. **Closure Property** – $a * b \in S,\,\forall a,b \in S$
**Example -** A [[Order Theory#Lattice|lattice]] is an algebraic structure w.r.t two operations, $\vee$ (least upper bound) and $\wedge$ (greatest lower bound).
# Semi-group
An algebraic structure $(S,*)$ is called a semi-group if and only if -
- **Associative Property –** $a*(b*c)=(a*b)*c,\,\forall a,b,c \in S$
Associativity only depends upon the operation $*$, never the elements it's being performed upon. ^associativity

Subtraction is not associative because -
$$
\begin{aligned}
(a-b)-c &= a-b-c \\
a-(b-c) &= a-b+c \\
\text{Thus}\, (a-b)-c &\ne a-(b-c)
\end{aligned}
$$
# Monoid
A semi-group $(S,*)$ is called a monoid if and only if -
- **Identity Property –** $a * e = e \in S,\,\forall a \in S$
# Group
A monoid $(S,*)$ is called a group if and only if -
- **Inverse Property –** $\forall a \in S, \exists b \in S$ such that $a * b = e \in S$
# Abelian Group
A group $(S,*)$ is called a Abelian Group if and only if -
- **Commutative Property –** $a * b = b * a, \forall a,b \in S$
Commutativity depends upon the operation as well as the type of elements.
# Finite Group
A group $(G,*)$ is called a finite group if the underlying set $G$ is a finite set.

If $e$ is the identity element for any operation $*$, then $(e,*)$ is the smallest finite group.
- $(\{0\},+)$ is the only finite group for real numbers w.r.t addition.
- $(\{1\},\cdot)$ and $(\{1,-1\},\cdot)$ is the only two finite groups of order 2 for real numbers w.r.t multiplication.
- The cube roots of unity - $(\{1,\omega,\omega^2\},\cdot)$ where $\omega^3=1$ form the only group of order 3 for real numbers w.r.t multiplication.
- The fourth roots of unity - $(\{1,-1,i^2,-i^2\},\cdot)$ form the only group of order 4 for real numbers w.r.t multiplication.
- Any set of $n^{th}$ roots of unity form the only group of order $n$ for real numbers w.r.t multiplication.
# Addition and multiplication modulo operation
1. Addition Modulo -
$$
a \oplus_mb = (a+b)\text{ mod } m
$$
The set $\{0,1,\dots,n-1\}$ is a group with respect to addition modulo operation.

2. Multiplication Modul -
$$
a \otimes_mb = (a\times b)\text{ mod } m
$$

The set $\{x\,|\,1\le x \lt n,\text{ and }gcd(x,n)=1\}$ (set of all co-prime numbers w.r.t and less than n) is a group with respect to multiplication modulo operation.

As all numbers less than a prime number $n$ are co-prime w.r.t it $n$, $\{x|1\le x \lt n\}$ is a group w.r.t multiplication modulo.
# Order of an element
For any element $a$ in a group $(G,*)$ the order of $a$ is the **least positive integer** value of $n$ such that $a^n = e$. Here $n$ is not exponentiation but instead performing the $*$ operation $n-1$ times on $a$ like - 

$$
\underbrace{a*a*\dots*a}_{\text{n times}} = e
$$
Example - In $(\{1,\omega,\omega^2\},\cdot)$ the order of the elements w.r.t the operation $\cdot$ is -
1. $1 = e$, thus $O(1)=1$.
2. $\omega \cdot \omega \cdot \omega = e$, thus $O(\omega)=3$.
3. $\omega^2 \cdot \omega^2 \cdot \omega^2 = e$, thus $O(\omega^2)=3$.

Observations -
1. Order of identity elements $e$ is 1.
2. Elements with order 2 are their own inverse.
3. Order of the element of a group is less than or equal to the order of the group.
4. Order of an element $=$ Order of its inverse.
5. Order of an element divides the order of the group. ^sg-obsv5
# Subgroup
Let $(G,*)$ be a group, and $H$ be a non-empty subset of $G$. $(H,*)$ is a subgroup of $G$, **if and only if** $(a*b^{-1}) \in H,\,\forall a,b \in H$. 

This single statement is enough to prove that $(H,*)$ fulfills the closure, identity, and inverse properties for a group. Associativity depends upon the operation $*$.

Observations -
- The smallest subgroup of any group $G$ would be $(\{e\},*)$.
- The largest subgroup of any group $G$ would be $(G,*)$.
- Any other subgroup of $G$ would be called a **proper subgroup**.

Properties -
1. **Lagrange's Theorem** - Let $(G,*)$ be a group and $(H,*)$ be a subgroup of $G$, then $O(H)$ divides $|G|$. ^lag-th
2. Let $(G,*)$ be a group and $(H_1,*)$, $(H_2,*)$ be two subgroups of $G$, then $H_1 \cup H_2$ is a subgroup of $(G,*)$ **if and only if** $H_1 \subseteq H_2$ or $H_2 \subseteq H_1$.
3. Let $(G,*)$ be a group and $(H_1,*)$, $(H_2,*)$ be two subgroups of $G$, then $H_1 \cap H_2$ is **always a subgroup**.
# Cyclic Group
Let $(G,*)$ be a group and let $a \in G$ be some element. If every element of $G$ can be written in the form of $a^n$ for some positive integer $n$, we call $(G,*)$ a **cyclic group** and $a$ the generator of the cyclic group. This is denoted as $G = \langle a \rangle$.

Observations -
- $e$ cannot generate any element other than itself.
- There can be multiple generators.
- If the order of any element is less than $|G|$ then it would generate $e$ before it is able to generate all elements of $G$. Thus the order of a generator is equal to the order of the group. $O(a) = |G|$ where $a$ is the generator of the cyclic group $G$.
- If $a$ is the generator of a group $G$, then $a^{-1}$ would also be the generator of the group.
- If the order of a group is prime, then all elements except $e$ will be a generator for the group.
- If $\nexists a \in G$ such that $O(a)=|G|$, then the group is not cyclic.

Properties -
- Every cyclic group is Abelian.
- Every group of prime order is cyclic.
- Every subgroup of a cyclic group will be a cyclic subgroup, but the generator of this cyclic subgroup need not be the same as the generator of the group.
- Subgroup of a non-cyclic group can be cyclic.
- Every set formed using all elements generated by any element $a$ of a group $G$ will make a subgroup $H$ of $G$. The number of elements in $H$ will be the same as $O(a)$. Because $O(a)$ would divide $|G|$, the order of the subgroup formed, $|H|$ would divide $|G|$ as well.

Special examples -
- Every group of order $\le 3$ is a cyclic group (If $|G|=1$ then $G=(\{1\},*)$. If $|G| \in \{2,3\}$ then both are prime order groups, which are cyclic).
- Every group of order $\le 4$ is a cyclic group except [[Group Theory#Klein-4 Groups|Klein-4 groups]].
- Every group of order $\le 5$ is a cyclic group except Klein-4 groups.
- Every group of order $\le 5$ is Abelian (even Klein-4 groups are Abelian).
## Klein-4 Groups
1. Order of group = 4.
2. Every element is inverse of itself.
3. Binary operation of any 2 non-identity elements produces a third non-identity element.

Klein-4 groups are Abelian.
## Number of generators of a cyclic group
Let $(G,*)$ be a cyclic group of order $n$ with element $a$ as one of its generators. $a^m$ will also be a generator of the cyclic group where $m$ is any positive integer $\lt n$ and co-prime to $n$. Thus

$$
\text{No. of generators} = \underbrace{\text{No. of +ve integers less than and coprime to n}}_{\text{Can be calculated using Euler's Totient Function } \phi_n}
$$
Euler's Totient function -

$$
\phi_n = n*\left(1-\frac{1}{p_1}\right)*\left(1-\frac{1}{p_2}\right)*\dots
$$
where $p_1, p_2, \dots$ are prime factors of $n$.

---
# Questions
<h6 class="question">Q1) If G is a group of prime order, what would be the order of elements of G and how many subgroups of G are possible?</h6>
$\underline{\text{Sol}^n} -$
As mentioned in the [[Group Theory#^sg-obsv5|fifth observation]] in the order of group section, the order of elements of a group should divide the order of the group. As $|G|$ is a prime number, only 1 and $|G|$ can divide it. Thus $\boxed{O(x)=1 \text{ or } O(x)=|G|}, \, \forall x \in G$.

As the [[Group Theory#^lag-th|Lagrange's Theorem]] says, the order of a subgroup should divide the order of the group. As $|G|$ is prime, only two divisors are possible for it – 1 or $|G|$. Thus $\boxed{\text{only 2 subgroups}}$ are possible.