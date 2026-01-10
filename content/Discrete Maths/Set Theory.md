>[!SUMMARY] Table of Contents
>- [[Set Theory#Set|Set]]
>- [[Set Theory#Set Operations|Set Operations]]
>- [[Set Theory#Principle of Inclusion and Exclusion|Principle of Inclusion and Exclusion]]
>- [[Set Theory#Multiset|Multiset]]
>- [[Set Theory#Cartesian Product|Cartesian Product]]
>- [[Set Theory#Relations|Relations]]
>	- [[Set Theory#Types of Relations|Types of Relations]]
>		- [[Set Theory#Diagonal Relation (Identity Relation)|Diagonal Relation (Identity Relation)]]
>		- [[Set Theory#Reflexive Relation |Reflexive Relation ]]
>		- [[Set Theory#Irreflexive Relation|Irreflexive Relation]]
>		- [[Set Theory#Symmetric Relation|Symmetric Relation]]
>		- [[Set Theory#Anti-Symmetric Relation|AntiSymmetric Relation]]
>		- [[Set Theory#Asymmetric Relation|Asymmetric Relation]]
>		- [[Set Theory#Transitive Relation|Transitive Relation]]
>		- [[Set Theory#Equivalence Relation|Equivalence Relation]]
>- [[Set Theory#Closures|Closures]]
>- [[Set Theory#Partitions and Equivalence Class|Partitions and Equivalence Class]]
>	- [[Set Theory#Partitions|Partitions]]
>	- [[Set Theory#Equivalence Class|Equivalence Class]]
>	- [[Set Theory#Bell Number|Bell Number]]
>	- [[Set Theory#Refinement|Refinement]]
>- [[Set Theory#Questions|Questions]]
# Set
A **well-defined** **unordered** collection of **distinct** elements is called a set.

Example -
1. $\{1,2,\text{a},\text{b},\text{Jan},\text{Feb}\}$ is a valid set even if the data types are different.
2. $\{\{1,2\},\{2,1\}\}$  is **not well-defined** as $\{1,2\}=\{2,1\}$ and sets can't have any repeated elements. Thus it is not a set.

Notations -
1. $\{1,2,3\}$ is the **roster form**.
2. $\{\, x \mid 1 \le x \le 3,\ x \in \mathbb{Z} \,\}$ is the **set builder form**.

Types of sets -
1. **Equal Sets -** Two sets $A$ and $B$ are said to be equal if all elements of A are in B and vice versa.
2. **Equivalent Sets -** Two sets $A$ and $B$ are equivalent if their cardinalities are same. In other words there exists a [[Functions#Bijective Function|bijective mapping]] between $A$ and $B$.
3. **Universal Set -** A set containing all elements corresponding to the problem at hand.
4. **Subset -** $A$ is a subset of $B$ if every element of set $A$ is in $B$.
5. **Superset -** $B$ is a superset of $A$ if every element of $A$ is in $B$.
6. **Proper Subset** - $A$ is a proper subset of $B$ if $A$ is a subset of $B$ but not equal to $B$.
7. **Power Set $(P(A)$ or $2^A)$ -** A set of all subsets of $A$ is a power set of $A$.
   A power set only contains sets, not elements.

The total number of elements in a power set can be calculated using [[Counting#Binomial Theorem|Binomial Theorem]] -
$$
\begin{aligned}
&\binom{n}{0} + \binom{n}{1} + \cdots + \binom{n}{n}\\
&= \binom{n}{0}\cdot 1 + \binom{n}{1}\cdot 1 + \cdots + \binom{n}{n}\cdot 1 \\
&= \binom{n}{0}(1^n 1^0) + \binom{n}{1}(1^{n-1} 1^1) + \cdots + \binom{n}{n}(1^0 1^n) \qquad \because \text{Using Binomial Theorem}\\
&= (1 + 1)^n \\
&= \boxed{2^n}
\end{aligned}
$$

# Set Operations
1. Union
2. Intersection
3. Complement
4. Set Difference - Elements in A but not in B.
$$
A - B = A \cap B^c = A - (A \cap B)
$$
5. Symmetric Difference $(\triangle$ or $\oplus)$ - Elements in either A or B, but not in both. Similar to XOR.
$$
\begin{align*}
A \oplus B &= (A \cup B) - (A \cap B) \\
A \oplus B &= (A - B) \cup (B-A)
\end{align*}
$$

Properties -

|    Opeartion     |  Idempotent  |    Identity     |     Domination     |  Complementation  |       Absorption        |
| :--------------: | :----------: | :-------------: | :----------------: | :---------------: | :---------------------: |
|    **Union**     | $A \cup A=A$ | $A \cup \phi=A$ |    $A \cup U=U$    |  $A \cup A^c=U$   | $A \cup (A \cap B) = A$ |
| **Intersection** | $A \cap A=A$ |  $A \cup U=A$   | $A \cap \phi=\phi$ | $A \cap A^c=\phi$ | $A \cap (A \cup B) = A$ |
# Principle of Inclusion and Exclusion
$$
|A \cup B| = |A| + |B| - |A \cap B|
$$

See [[Set Theory#^q2|Question 2]] for a bigger example.
# Multiset
A well-defined unordered collection of elements that allows multiple occurrences of an element.
$$
\{a,a,a,b,b,c,d,d,d\} = \{3.a, 2.b,1.c,3.d\}
$$
Here the numbers $3,2,1,3$ are multiplicities of each element and a multiset can be written this way as well. Multiplicities $\ge 0$ and must be integers.

We can say a set is a multiset where each element's multiplicity is restrict to be $0$ or $1$.

$\bigstar$ **Cardinality of a Multiset** - The summation of the multiplicities of a multiset.

Suppose an element occurs $m$ times in multiset $A$ and $b$ times in multiset $B$. Under this context the count of that element under operations would be -
1. $A \cup B\, -\, m+n$
2. $A \cap B\, -\, min(m,n)$
3. $A - B\, -\, max(0,m-n)$

See [[Set Theory#^q3|Question 3]] for a cardinality example.
# Cartesian Product
Let $A$ and $B$ be two finite sets, then their Cartesian Product $A \times B$ is a set of all ordered pairs $(x,y)$ such that $x \in A$ and $y \in B$.
$$
A \times B = \{(x,y)\,|\,x \in A, y \in B\}
$$
- **Cardinality of a Cartesian Product** - $|A \times B| = |A| \cdot |B|$
- $A \times B = B \times A$, only when either $A = B$ or either one is $\phi$.
# Relations
A relation from $A$ to $B$ defines how elements of $A$ are related to elements of $B$.

- Cartesian Product is a **universal relation**.
- Number of relations possible between $A$ and $B =$ No. of subsets of $A \times B = 2^{|A \times B|}$ 
## Types of Relations
Defined from A to A -
1. Diagonal Relation (Identity Relation)
2. Reflexive Relation - $a^Ra,\, \forall \,a \in A$
3. Irreflexive Relation
4. Symmetric Relation
5. Anti-symmetric Relation
6. Asymmetric Relation
7. Transitive Relation

Defined between any two sets $A$ and $B$ -
1. Complement of a Relation
2. Inverse of a Relation
3. Composite of Relations
### Diagonal Relation (Identity Relation)
Any set of the form - $\{(a,a)\,|\,a \in A\}$ is a diagonal relation.

Eg - $R=\{(1,1), (2,2), (1,2)\}$ is not a diagonal relation over $A = \{1,2\}$ due to $(1,2)$.

A **diagonal order pair** is - $(x,y), \,\text{s.t.}\, x=y$.

$\bigstar$ Called diagonal relation because if you arrange all $n^2$ elements of $A \times A$ in an $n \times n$ grid, all pairs $(a,a)$ lie on the diagonal.
### Reflexive Relation 
Any relation whose elements satisfy $a^Ra,\, \forall \,a \in A$ is a reflexive relation. 

$\qquad(OR)$

All diagonal order pairs of the set should exist in the relation.

Eg - $R=\{(1,1), (2,2), (1,2)\}$ is reflexive over $A = \{1,2\}$.

Here there are no constraints over the set structure. Only the elements need to fulfill the criteria.
1. Every diagonal relation is reflexive, but not vice versa.
2. The smallest reflexive relation on $A$ is the diagonal relation on $A$.

Check [[Set Theory#^q4|Question 4]] for the total number of reflexive relations in a set.
### Irreflexive Relation
Any relation whose elements satisfy $a^{\cancel{R}}a,\, \forall \,a \in A$ is an irreflexive relation.

$\qquad(OR)$

No diagonal order pairs of the set exist in the relation.

Eg - $R=\{(1,2)\}$ is irreflexive over $A = \{1,2\}$ as $(1,1),(2,2)$ are not present.

1. Smallest irreflexive relation on any set is the empty relation.
### Symmetric Relation
If $(x,y) \in R$ then $(y,x) \in R$, $\forall x,y \in A$ then $R$ is said to be a symmetric relation.

Eg - $R_1 = \{(1,1),(2,2)\},\, R_2 = \{(1,2)\}$ over $A = \{1,2\}$, $R_1$ is symmetric but $R_2$ isn't.

$\bigstar$ There are a total of $\frac{n(n-1)}{2}$ non-diagonal symmetric ordered pairs over some set of $n$ elements.
### Anti-Symmetric Relation
If $(x,y) \in R$ and $(y,x) \in R$ then $x=y$, $\forall x,y \in A$ then $R$ is said to be a anti-symmetric relation.

$\qquad(OR)$

If the only symmetric ordered pairs in a relation are also diagonal, the relation is said to be anti-symmetric.

Eg - Over $A = \{1,2,3\}$ -
- $R_1 = \{(1,2),(2,3),(3,1)\}$ is anti-symmetric.
- $R_2 = \{(1,2),(2,3),(1,1)\}$ is anti-symmetric.
- $R_3 = \{(1,2),(2,1),(1,1)\}$ is not anti-symmetric.

$\bigstar$ One visual trick of checking if a relation is symmetric is to write the ordered pairs in an $n \times n$ grid and check whether all pairs of the relation lie in the **upper triangle** or **lower triangle** of the grid.
### Asymmetric Relation
If $(x,y) \in R$ then $(y,x) \notin R$, $\forall x,y \in A$ even if $x=y$ then $R$ is said to be a asymmetric relation.

$\qquad(OR)$

If there exist no symmetric ordered pairs in a relation, the relation is said to be asymmetric.

- $\bigstar$ $\{\}$ is symmetric, anti-symmetric, and asymmetric.
- $\bigstar$ Every asymmetric relation is anti-symmetric.

Eg - Over $A = \{1,2,3\}$ -
- $R_1 = \{(1,2),(2,3),(3,1)\}$ is asymmetric.
- $R_2 = \{(1,2),(2,3),(1,1)\}$ is not asymmetric.
### Transitive Relation
If $(x,y) \in R$ and $(y,z) \in R$ then $(x,z) \in R$, $\forall x,y,z \in A$ is said to be a transitive relation.

Eg - Over $A = \{1,2,3\}$ -
- $R_1 = \{(1,2),(2,1),(1,1)\}$ is not transitive as $(2,1) \in A$ and $(1,2) \in A$ but $(2,2) \notin A$.
### Equivalence Relation
A relation $R$ on $A$ is an equivalence relation if and only if - 
1. $R$ is reflexive
2. $R$ is symmetric
3. $R$ is transitive 
# Closures
Let $R$ be a relation on set $A$. 
1. **Reflexive Closure -** A reflexive closure of $R$ is the smallest reflexive relation on $A$ containing $R$.
2. **Symmetric Closure -** A symmetric closure of $R$ is the smallest symmetric relation on $A$ containing $R$.
3. **Transitive Closure -** A transitive closure of $R$ is the smallest transitive relation on $A$ containing $R$.
    - Warshall's Algorithm can be used to find the Transitive Closure of a relation.
# Partitions and Equivalence Class
## Partitions
A partition of a set $A$ is the grouping of all elements of $A$ into **non-empty subsets** $A_1, A_2, \dots, A_k$  if and only if -
1. $A_i \cap A_j = \phi$,  where $i \ne j,\, \forall i,j$ 
2. $\bigcup_{i=1}^k A_i = A$

$\qquad(OR)$

A partition of a set $A$ is the grouping of all elements of $A$ into **non-empty subsets** such that every element only occurs in one subset.

1. Partition of $A=\phi=\{\}$ is $\phi=\{\}$.

Check [[Set Theory#^q5|Question 5]] to see how to count the number of partitions of a set.
## Equivalence Class
An equivalence class of an element $x$ with respect to an equivalence relation $R$ is a set of all $y$ such that $x^Ry$ in that relation.

$$
[x] = \{y\,|\,(x,y) \in R\}
$$

Notes -
1. $[x_1] \equiv [x_2]$ even if $x_1 \ne x_2$.
2. Set of all distinct equivalence classes of elements of set $A$ define a partition of set $A$ w.r.t the given equivalence relation $R$.
3. Union of self cross product of each subset in a partition will give back the equivalence relation $R$. Check [[Set Theory#^q6|Question 6]] for an example.

There is a one-to-one correspondence between the partitions of set $A$ and the equivalence relations of set $A$.
$$
\text{No. of partitions} = \text{No. of equivalence relations}
$$
## Bell Number
Bell number $B_n$ gives the **number of partitions** (and thus number of equivalence relations) of set $A$, where $|A| =n$. 

Number of partitions are shown by the first column of the **Bell Triangle** - 
$$
\begin{aligned}
B_0 &= \boxed{1} \\
B_1 &= \boxed{1}\,\,\,2 \\
B_2 &= \boxed{2}\,\,\,3\,\,\,5 \\
B_3 &= \boxed{5}\,\,\,7\,\,\,10\,\,\,15 \\
B_4 &= \boxed{15}\,\,\,20\,\,\,27\,\,\,37\,\,\,52 \\
B_5 &= \boxed{52}\,\,\,67\,\,\,87\,\,\,114\,\,\,151\,\,\,203 \\
&\vdots
\end{aligned}
$$
How to form the Bell Triangle -
1. Start with $B_0 = 1$.
2. To create some row $B_{i+1}$, check the last number of row $B_i$ and add it as the first number of $B_{i+1}$.
3. Repeat Step(3) until there's a number in current row $B_{i+1}$ with no number above it in previous row $B_i$. For each number $m$ in $B_{i+1}$ if there is a number above it in $B_i$ say $n$, the next number of $B_{i+1}$ will be $m+n$. 

***Example*** - In $B_3$ we can see that $2$ has $1$ above it, so next number if $2+1=3$.
## Refinement
Let $A$ be any finite set and $\Pi_1$ and $\Pi_2$ be any two partitions of $A$. Partition $\Pi_1$ is a refinement of partition $\Pi_2$ if every subset inside $\Pi_1$ is a subset of subsets in $\Pi_2$.

***Example -*** 
Let $A = \{1,2,3,4\}$ and $\Pi_1 = \{\{a\},\{b\},\{c,d\}\}$ and $\Pi_2 = \{\{a,b\},\{c,d\}\}$. 
Here we can see that every subset $\{a\},\{b\},\{c,d\}$ in $\Pi_1$ is a subset of subsets $\{a,b\},\{c,d\}$ in $\Pi_2$.

---
# Questions
<h6 class="question">Q1) What is -</h6>

$$
|P(P(\phi))|
$$

$\underline{\text{Sol}^n}-$
$P(\phi) = \{\phi\}$, $P(P(\phi)) = \{\phi, \{\phi\}\}$, thus $|P(P(\phi))|=\boxed{2}$

---
^q2
<h6 id="q2" class="question">Q2) What is -</h6>

$$
|A \cup B \cup C \cup D|
$$

$\underline{\text{Sol}^n} -$

Without drawing the Venn Diagram, we can still visualize the basic structure of it. To get $|A \cup B \cup C \cup D|$, we'd need to firstly include all regions of $A,\,B,\,C,\,D$ and correct for all overlapping regions as the elements inside them would be counted multiple times.

Count of Venn diagram regions with elements belonging to only -
1. 1 set = $^4C_1 = 4$, regions are - $A,B,C,D$
2. 2 sets = $^4C_2 = 6$, regions are - $A \cap B, A \cap C, A \cap D, B \cap C, B \cap D, C \cap D$
3. 3 sets = $^4C_3 = 4$, regions are - $A \cap B \cap C, A \cap B \cap D, A \cap C \cap D, B \cap C \cap D$
4. 4 sets = $^4C_4 = 1$, region is - $A \cap B \cap C \cap D$

Steps - 
1. Do $|A|+|B|+|C|+|D|$ as the initial step.
2. After Step (1) elements that lie in the intersection of $2$ sets are counted twice. Thus $-|A \cap B|- |A \cap C|- |A \cap D| -|B \cap C| -|B \cap D| -|C \cap D|$ needs to be done.
3. After Step (2) elements that lie in the intersection of $3$ sets are being counted $3$ times in Step (1) and removed from the count $3$ times in Step (2). Thus net count is $3-3=0$. Thus they need to be added once by doing $+|A \cap B \cap C|+|A \cap B \cap D|+|A \cap C \cap D|+|B \cap C \cap D|$.
4. After Step (3) elements that lie in the intersection of $4$ sets are being counted $4-6+4=2$ times, thus need to be removed once by doing $-|A \cap B \cap C \cap D|$.

Thus total count is -

$$
\begin{aligned}
|A \cup B \cup C \cup D| = &|A|+|B|+|C|+|D| \\
&-|A \cap B|- |A \cap C|- |A \cap D| -|B \cap C| -|B \cap D| -|C \cap D| \\
&+|A \cap B \cap C|+|A \cap B \cap D|+|A \cap C \cap D|+|B \cap C \cap D| \\
&-|A \cap B \cap C \cap D|
\end{aligned}
$$

This alternating process of addition and subtraction ensures that each element is counted **exactly once**, which is the essence of the Principle of Inclusion–Exclusion.

---
^q3
<h6 class="question">Q3) How many multisets are possible for elements of {1,2,3,...,n}?</h6>

$\underline{\text{Sol}^n} -$ $\boxed{\infty}$ as even a single element of the multiset can be repeated $\infty$ times to form multisets.

---
^q4
<h6 class="question">Q4) How many reflexive relations exist for set A = {1,2,...,n}?</h6>

$\underline{\text{Sol}^n} -$
Number of ordered pairs in $A$ is $n^2$. Out of these, $n$ pairs like $(1,1), (2,2), \dots, (n,n)$ would be diagonal ordered pairs.

Any reflexive relation of $A$ must have these $n$ ordered pairs along with some combination of non-diagonal ordered pairs.
1. We can pick $n$ pairs from $n$ diagonal ordered pairs in $\binom{n}{n}=1$ way.
2. We can pick $0,1,\dots,n$ pairs from the rest $n^2-n$ ordered pairs these many times -
$$
\binom{n^2-n}{0} + \binom{n^2-n}{1} + \dots + \binom{n^2-n}{0} =2^{n^2-n}
$$

So total number of ways is $1 * 2^{n^2-n} = \boxed{2^{n^2-n}}$ ways.

---
^q5
<h6 class="question">Q5) How many partitions are possible for {1,2,3,4,5}?</h6>

$\underline{\text{Sol}^n} -$
A partition of 5 elements can be created with subsets of following cardinalities - 
1. 1,1,1,1,1
2. 1,1,1,2
3. 1,1,3
4. 1,4
5. 5
6. 2,3
7. 1,2,2

Count of sets of subsets of the above cardinalities is -
1. (1,1,1,1,1) - After picking elements in required quantities, we can arrange the subsets in $5!$ ways, such that each set of subsets is equivalent. Subsets of equal size are **indistinguishable**, so we divide by the factorial of their multiplicity Because such partitions are equivalent, they shouldn't be counted multiple times. Thus the total number in which we can pick elements in required quantities needs to be divided by 5!.
    - $\{\{1\},\{2\},\{3\},\{4\},\{5\}\} \equiv \{\{3\},\{5\},\{1\},\{4\},\{2\}\}$ and so on...
$$
\frac{\binom{5}{1} * \binom{4}{1} * \binom{3}{1} * \binom{2}{1} * \binom{1}{1}}{5!} = \boxed{1}
$$

2. (1,1,1,2) - Subsets of equal size are **indistinguishable**, so we divide by the factorial of their count. There are $3$ subsets of size $1$, so we need to divide by $2!$ here.
$$
\frac{\binom{5}{1} * \binom{4}{1} * \binom{3}{1} * \binom{2}{2}}{3!} = \boxed{10}
$$

3. (1,1,3) - $2$ subsets of size $1$, so we need to divide by $2!$ here.
$$
\frac{\binom{5}{1} * \binom{4}{1} * \binom{3}{3}}{2!} = \boxed{10}
$$

4. (1,4) - Here there are no subsets of equal sizes, thus no need for division.
$$
\binom{5}{1} * \binom{4}{4} = \boxed{5}
$$

5. (5) - No subsets of equal sizes.
$$
\binom{5}{5} = \boxed{1}
$$

6. (2,3) - No subsets of equal sizes.
$$
\binom{5}{3}*\binom{2}{2} = \boxed{10}
$$

7.  (1,2,2) - $2$ subsets of size $2$, so we need to divide by $2!$ here.
$$
\frac{\binom{5}{1}*\binom{4}{2}*\binom{2}{2}}{2!} = \boxed{15}
$$

If there were $2$ subsets of size $1$ and $2$ subsets of size $2$, we would have divided the permutations by $2!*2!$.

Total number of partitions $=1+10+10+5+1+10+15=\boxed{52}$.

---
^q6
<h6 class="question">Q6) If the partition set for some set A is S , what is its corresponding equivalence relation?</h6>

$$
A = \{1,2,3\}, \qquad S=\{\{1,2\},\{3,4\},\{5\}\}
$$

$\underline{\text{Sol}^n} -$
There are 3 subsets in $S$ - $\{1,2\},\{3,4\}$ and $\{5\}$. Take a self cross product of each -
$$
\begin{aligned}
\{1,2\} \times \{1,2\} &= \{(1,1),(1,2),(2,1),(2,2)\} \\
\{3,4\} \times \{3,4\} &= \{(3,3),(3,4),(4,3),(4,4)\} \\
\{5\} \times \{5\} &= \{(5,5)\}
\end{aligned}
$$
Union of the above cross products would give -
$$
\boxed{R =\{(1,1),(1,2),(2,1),(2,2),(3,3),(3,4),(4,3),(4,4),(5,5)\}}
$$

---