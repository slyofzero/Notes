# Ordered Relations
### Partial Order Relation
A relation $R$ on $A$ is a partial order relation if and only if - 
1. $R$ is [[Set Theory#Reflexive Relation|reflexive]]
2. $R$ is [[Set Theory#Anti-Symmetric Relation|anti-symmetric]]
3. $R$ is [[Set Theory#Transitive Relation|transitive]]
### Total Order Relation
Let $R$ be a partial order relation on $A$. $R$ is called a **total order relation** if every pair of elements of $A$ are [[Order Theory#Comparability|comparable]] w.r.t $R$.

Example - Let $A = \{1,2,3,4\}$ and $(A,\div)$ be a [[Order Theory#Partially Ordered Set (POSET)|POSET]].
Here as 2 doesn't divide 3 and 3 doesn't divide 2, 2 and 3 are not comparable. Thus $A$ is not a total order relation.
# Partial and Total Orderings
## Partially Ordered Set (POSET)
A pair $(A,R)$ is a **partially ordered set** (POSET), if and only if $R$ is a partial order relation defined on a set $A$.

**Example -** $(A, \le)$ is a POSET for any set $A$ as $\le$ is a partial order relation.
## Comparability
Let $R$ be a relation on some set $A$. For any two elements $a,b \in A$, we say $a$ and $b$ are comparable if and only if $(a,b) \in R$ or $(b,a) \in R$.
## Totally Ordered Set (TOSET)
A pair $(A,R)$ is a **totally ordered set** (TOSET), if and only if $(A,R)$ is a POSET and every pair of elements of $A$ is comparable w.r.t relation $R$.
# Supremum and Infimum
Check [[Order Theory#^q1|Question 1]] for example.
## Supremum (Least Upper Bound)
Let $(A,R)$ be a POSET, for any two elements $a,b \in A$ we can say $c$ is the **supremum**/Least Upper Bound of $a$ and $b$, if -  

$$
\begin{aligned}
&\exists c \in A \,\,\text{s.t.}\,\, a \le c,\,b \le c \\
\text{and} \,\,&\nexists d \in A \,\,\text{s.t.}\,\, a \le d,\,b \le d,\,d \lt c \\
\end{aligned}

\qquad \text{OR in general terms -} \qquad

\begin{aligned}
&\exists c \in A \,\,\text{s.t.}\,\, a^Rc,\,b^Rc \\
\text{and} \,\,&\nexists d \in A \,\,\text{s.t.}\,\, a^Rd,\,b^Rd,\,d^Rc \\
\end{aligned}
$$


This is denoted as $lub(a,b) = c$ or $a \vee b = c$.
## Infimum (Greatest Lower Bound)
Let $(A,R)$ be a POSET, for any two elements $a,b \in A$ we can say $c$ is the **infimum**/Greatest Lower Bound of $a$ and $b$, if -

$$
\begin{aligned}
&\exists c \in A \,\,\text{s.t.}\,\, c \le a,\,c \le b \\
\text{and} \,\,&\nexists d \in A \,\,\text{s.t.}\,\, d \le a,\,d \le a,\,c \lt d
\end{aligned}

\qquad \text{OR in general terms -} \qquad

\begin{aligned}
&\exists c \in A \,\,\text{s.t.}\,\, c^Ra,\,c^Rb \\
\text{and} \,\,&\nexists d \in A \,\,\text{s.t.}\,\, d^Ra,\,d^Ra,\,c^Rd \\
\end{aligned}
$$
This is denoted as $gub(a,b) = c$ or $a \wedge b = c$.

---
# Questions
^q1
<h6 class="question">Q1) If A is a set of all +ve integers, find the supremum and infimum of POSETS -</h6>
$$
(A,\le) \,\,\text{and}\,\, (A,\div)
$$

$\underline{\text{Sol}^n} -$
1. $(A,\le)$, for $a,b \in A$ -
    1. $lub(a,b) = max(a,b)$
    2. $glb(a,b) = min(a,b)$
2. $(A,\div)$, for $a,b \in A$ -
    1. $lub(a,b) = LCM(a,b)$ ($lub(a,b)$ in context of $\div$ means that the supremum is divisible by both $a$ and $b$)
    2. $glb(a,b) = GCD(a,b)$ ($glb(a,b)$ in context of $\div$ means that the infimum divides both $a$ and $b$)