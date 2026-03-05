>[!SUMMARY] Table of Contents
>- [[Probability#Random Experiment|Random Experiment]]
>- [[Probability#Axioms of Probability|Axioms of Probability]]
>	- [[Probability#Important Consequences|Important Consequences]]
>- [[Probability#Types of events|Types of events]]
>	- [[Probability#Mutually Exclusive Events|Mutually Exclusive Events]]
>	- [[Probability#Independent Events|Independent Events]]
>	- [[Probability#Dependent Events|Dependent Events]]
>- [[Probability#Conditional Probability|Conditional Probability]]
>	- [[Probability#Total Probability Theorem|Total Probability Theorem]]
>	- [[Probability#Bayes Theorem|Bayes Theorem]]
>- [[Probability#Measure Theory|Measure Theory]]
>	- [[Probability#Size|Size]]
>	- [[Probability#Sigma Algebra|Sigma Algebra]]
>	- [[Probability#Measure|Measure]]
>	- [[Probability#Measure Space|Measure Space]]
>- [[Probability#Probability Space|Probability Space]]

Probability is the study of certainty/uncertainty around any decision or action. Mathematically, the probability measure $P(\cdot)$ of an element is a function which maps elements of the sample space in the range $[0,1]$.
# Random Experiment
$\underline{\text{Definition}}-$ A random experiment is an experiment with a known set of outcomes, but the outcome of a trial is unknown before the trial is conducted.
- The set of all possible outcomes of a random experiment is called the **sample space**.
- **An event** is a subset of the sample space that is of our interest.
- A trial is a single repetition of a random experiment.

**Parallels to Set Theory -**

| [[Set Theory]] |    Probability Theory     |
| :------------: | :-----------------------: |
| Universal Set  |  Sample Space $(\Omega)$  |
|     Subset     |           Event           |
| Singleton Set  | Atomic Events<br>Outcomes |
# Axioms of Probability
1. **Non-Negativity of Probability Measure -** For any event $A$, $P(A) \ge 0$.
2. $P(\Omega) = 1$, where $\Omega$ is the sample space. This means that upon performing a random trial, the probability of occurrence of an element of the sample space is always 1.
3. For mutually exhaustive/disjoint events $A_1, \dots, A_k$ -

$$
P(A_1 \cup A_2 \cup \dots \cup A_k) = P(A_1) + P(A_2) + \dots + P(A_k)
$$
## Important Consequences
1. Using these axioms we can find $P(\phi)$. We know $\Omega$ and $\phi$ are disjoint sets. So -

$$
\begin{alignedat}{3}
&&P(\Omega \cup \phi) &= P(\Omega) + P(\phi) \\[8pt]
&\Rightarrow &P(\Omega) &=P(\Omega) + P(\phi) \\[8pt]
&\Rightarrow &\cancel{P(\Omega)} &=\cancel{P(\Omega)} + P(\phi) \\[8pt]
&\Rightarrow &P(\phi) &=0 \\[8pt]
\end{alignedat}
$$

 Thus $\phi$ is an **impossible event**. All impossible events are **zero-probability events**, but not all zero-probability events are impossible events.  ^571abe
 
 Consider the sample space $[0,1]$. Here if we pick a range $[a,b]$ such that it is a subset of $[0,1]$, the probability of picking an element such that it belongs to this range is $b-a$. If $b=a$, this range becomes $[a,a]$. So only $a$ can be picked and no other number. But the probability of an element being picked such that it belongs to $[a,a]$ would be $a-a=0$ despite there existing an element in this range. This happens because the $P(a)$ is - ^6f2985

$$
\frac{1}{\text{no. of elements in [0,1]}} = \lim_{n \rightarrow\infty}\frac{1}{n} = 0
$$

2. Let $A$ be some subset of the universal set $\Omega$. We know $A^c$ and $A$ are disjoint sets. So -

$$
\begin{alignedat}{3}
&&P(A \cup A^c) &= P(A) + P(A^c) \\[8pt]
&\Rightarrow &P(\Omega) &=P(A) + P(A^c) \\[8pt]
&\Rightarrow &1 &=P(A) + P(A^c) \\[8pt]
&\Rightarrow &P(A^c) &=1 - P(A) \\[8pt]
\end{alignedat}
$$

3. For any two events $A,B$ of $\Omega$, if we use the formula of [[Set Theory#Principle of Inclusion and Exclusion|Principle of Inclusion and Exclusion]] and divide both sides by $|\Omega|$, we get -

$$
P(A \cup B) = P(A) + P(B) - P(A \cap B)
$$

If two events $A,B$ are disjoint, $P(A \cap B) = P(\phi) = 0$. Thus for **mutually exclusive events**, 

$$
P(A \cup B) = P(A) + P(B)
$$


4. If $A \subseteq B$, then $P(A) \le P(B)$.
# Types of events
## Mutually Exclusive Events
$\underline{\text{Definition}}-$ Events are said to be mutually exclusive if they can't occur simultaneously. If an event occurs and based upon this information we can say that certain events won't occur, then this set of events is mutually exclusive.

This means that if $A$ and $B$ are mutually exclusive events, $P(A \cap B)=0$.
## Independent Events
In case of mutually exclusive events, based on the occurrence of an event we have complete information regarding all other events. We can ask the other way around too.

Are there events where occurrence of one gives no new information regarding occurrence of others? YES. Such events are called independent events.

$\underline{\text{Definition}}-$ Independent events are events where occurrence of one event gives no new information regarding occurrence of other events.

If $A$ and $B$ are independent events then, $P(A \cap B) = P(A) \cdot P(B)$. The reason why is shown in [[Probability#Conditional Probability|conditional probability]].
## Dependent Events
$\underline{\text{Definition}}-$ Events are said to be dependent if occurrence of one gives partial or full information about the occurrence of other events.

| Event Type         | Definition                                                                                                  |
| ------------------ | ----------------------------------------------------------------------------------------------------------- |
| Independent Event  | Occurrence of one event gives no info. about occurrence of rest                                             |
| Dependent Event    | Occurrence of one event gives some info. about occurrence of rest                                           |
| Mutually Exclusive | Occurrence of one event gives complete info. about occurrence of rest<br>(Special case of Dependent Events) |
# Conditional Probability
In the case of mutually exclusive events $P(A \cap B)$ gives complete information about $P(A)$ and $P(B)$ while in case of independent events it gives no information. What of the case where $P(A \cap B)$ gives partial information?

In those cases using $P(A \cap B)$, we can try to determine the probability of $A \cap B$ occurring when $A$ or $B$ occurs. Such a probability is called conditional probability.

$\underline{\text{Definition}}-$ **Conditional Probability** quantifies how the probability of one event occurring changes when another event has already occurred.

$$
P(A|B) = \frac{P(A \cap B)}{P(B)}
$$

The formula of conditional probability changes to this because we are restricting the sample space to $B$ instead of $\Omega$.
- $P(A)$ and $P(B)$ are called **prior probabilities** as they are known before the occurrence of an event. 
- $P(A|B)$ and $P(B|A)$ are called **posterior probabilities** as they becomes known after an event occurs.

For independent events, we know by definition that occurrence of $B$ wouldn't affect the occurrence of $A$. Thus $P(A|B)=P(A)$ and consequently $P(A \cap B) = P(A) \cdot P(B)$.
## Total Probability Theorem
Suppose $A_1, A_2, \dots, A_n$ are [[Set Theory#Partitions|partitions]] of the sample space $\Omega$. This means that $A_i$ and $A_j$ are mutually exclusive events $\forall i \ne j$. The probability of any other event $B$ of $\Omega$ can be written as -

$$
\begin{aligned}
P(B) &= P(B \cap A_1) + P(B \cap A_2) + \dots + P(B \cap A_n) \\[8pt]
&= P(B|A_1)P(A_1) + P(B|A_2)P(A_2) + \dots + P(B|A_n)P(A_n) \\[8pt]
&= \sum_{i=1}^nP(B|A_i)P(A_i)
\end{aligned}
$$

This is called the **Total Probability Theorem**. An intuitive example of this [can be found here](https://youtu.be/gW9x0tHq-K0?list=PLgMDNELGJ1CYPJS6m_ygxb4KtHYxh1HjR&t=220).
## Bayes Theorem
If we know $P(A|B)$, can we say something about $P(B|A)$?

$$
\begin{aligned}
P(B|A) &= \frac{P(B \cap A)}{P(A)} \\[8pt]
&= \frac{P(A \cap B)}{P(A)} \\[8pt]
&= \frac{P(A|B) \cdot P(B)}{P(A)}
\end{aligned}
$$
$\underline{\text{Definition}}-$ Given $A_1, A_2, \dots, A_n$ partitions of $\Omega$ and $B$ be any other event of $\Omega$, 

$$
P(A_k|B) = \frac{P(B|A_k) \cdot P(A_k)}{\sum_{i=1}^nP(B|A_i) \cdot P(A_i)} \qquad \because P(B) = \sum_{i=1}^nP(B|A_i) \cdot P(A_i)
$$

This can be also written as -

$$
\text{Posterior} = \frac{\text{Likelihood} \cdot \text{Prior}}{\text{Evidence}}
$$
 
- **Prior -** Our belief about a hypothesis before *seeing the evidence*.
- **Evidence/Marginal likelihood -** Ignoring any hypothesis, how commonly does this observation occur in the general. 
- **Likelihood -** The probability of observing the evidence, given that the hypothesis is *true*.
- **Posterior -** Our updated belief *after incorporating the evidence*.
# Measure Theory
## Size
A number we attribute to an object that obeys a specific property: If we break an object into smaller parts, the sizes of the smaller parts should add up to the size of the whole object.
## Sigma Algebra
**$\sigma$-algebra** - Let $\Omega$ be the whole object we are considering. The $\sigma$-algebra generated by a partition is the set of all unions of elements of the partition.

Given a set $\Omega$ and a collection of subsets of $\Omega$, $\mathbb B$ is called a $\sigma$-algebra if it obeys the following properties -
1. $\phi \in \mathbb B$.
2. If $A \in B$, then $A^c \in B$.
3. If $A_1, \dots, A_n \in \mathbb B$, then $\bigcup_{i=1}^nA_i \in \mathbb B$.

Interpretation -
1. Each element of the $\sigma$-algebra $\mathbb B$ represents a piece of the object.
2. A null element is also considered as a piece of the object.
3. If we break off a piece $A$ from the object, $A^c$ is also a piece of the object.
4. If we glue a **countable** number of pieces of the object together, we'd end up with another valid piece of the object.
5. Because a piece of the object can either mean existence of a piece or negation of a piece and we know that **countable** union of all such pieces is another piece of the object, the $\sigma$-algebra is closed under all **countable** [[Set Theory#Set Operations|set operations]].
6. The $\sigma$-algebra of some partition $\Pi$ is set of all possible pieces that can be made using the pieces originally in $\Pi$.
## Measure
A measure is a function which assigns each piece of the object $\Omega$ a size.

Given a set $\Omega$ and a $\sigma$-algebra $\mathbb B$ on $\Omega$, the function $\mu: \mathbb B \rightarrow \mathbb R$ is called a measure if it obeys the following properties -
1. $\forall A \in \mathbb B, \mu(A) \gt 0$.
2. $\mu(\phi)=0$.
3. **Countable Additivity -** Given a countably infinite sequence of sets $A_1, \dots \in \mathbb B$, where $A_i \cap A_j = \phi, \forall i \ne j$ then,

$$
\mu\left(\bigcup_{i=1}^\infty A_i \right) = \sum_{i=1}^\infty\mu\left(A_i \right)
$$

Interpretation -
1. Size must be non-negative.
2. Size of the null element must be 0.
3. The sum of the sizes of individual elements should be equal to the size of the element made by gluing them all up.
## Measure Space
The triple $(\Omega, \mathbb{B}, \mu)$ is called a measure space where -
- $\Omega$ is the set.
- $\mathbb B$ is the $\sigma$-algebra on $\Omega$.
- $\mu$ is the measure of $\Omega$ on $\mathbb B$.
# Probability Space
A measure space $(\Omega, \mathbb{B}, P)$ is a probability space if $P(\Omega) = 1$.
