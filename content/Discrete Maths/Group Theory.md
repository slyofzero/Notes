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