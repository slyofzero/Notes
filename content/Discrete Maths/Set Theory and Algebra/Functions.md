>[!SUMMARY] Table of Contents
>- [[Functions#Injective Functions (one-one)|Injective Functions (oneone)]]
>- [[Functions#Surjective Functions (onto)|Surjective Functions (onto)]]
>	- [[Functions#Count of all Surjective Functions|Count of all Surjective Functions]]
>- [[Functions#Bijective Function|Bijective Function]]
>- [[Functions#Identity Function|Identity Function]]
>- [[Functions#Identical Function|Identical Function]]
>- [[Functions#Function Composition|Function Composition]]
>- [[Functions#Inverse of a Function|Inverse of a Function]]
>- [[Functions#Questions|Questions]]

A [[Set Theory#Relations|relation]] from set $A$ to set $B$ is a function, if and only if every element of set $A$ **relates to exactly one** element of set $B$.
- Number of functions that can be made between $A$ and $B = |B|^{|A|}$.

If $f: A \rightarrow B$ is a function -
- $A$ is called the **domain** of $f$
- $B$ is called the **co-domain** of $f$
- **Range** of a function $f$ is the subset of the co-domain of $f$ containing those elements that are mapped by at least one element of the domain.
- If $f(a)=b$, then image of $a$ w.r.t $f$ is $b$ and pre-image of $b$ w.r.t $f$ is $a$.

A function from set $A$ to itself is called a **function on** $A$.
# Injective Functions (one-one)
A function $f$ is injective if every distinct element in the domain of $f$ has a distinct image in the co-domain of $f$.
- If $f(a) = f(b$) then $a=b$.
- Number of injective functions that can be made between $A$ and $B = ^{|B|}P_{|A|}$.
# Surjective Functions (onto)
A function $f$ is surjective if every element in the co-domain of $f$ has at least one preimage in the domain of $f$.
- A function can never be onto if the size of its co-domain is larger than the size of its domain.

## Count of all Surjective Functions
Number of subjective functions is hard to get directly. One way to get the count is by doing - $\text{Total no. of functions} - \text{No. of non-surjective functions}$

Let $A$ and $B$ be two sets such that $|A|=m$ and $|B|=n$, the general formula for number of onto functions possible from $A$ to $B$ are -

$$
\begin{aligned}
&= n^m - ^nC_1*(n-1)^m + ^nC_2*(n-2)^m - \dots + (-1)^{n-1} * ^nC_{n-1}*(n-(n-1))^m \\
&= \sum_{i=0}^{n-1} (-1)^i * ^nC_i*(n-i)^m
\end{aligned}
$$

**Derivation -**
- $n^m$ is the total number of functions possible. So if we subtract the count of all non-onto functions from this count, we should get the total number of onto functions.
- For a function to not be onto, its codomain can have at most $n-1$ elements and at least $1$ element. 

Thus the count of onto functions would be something of the form -

$$
\begin{aligned}
= \,&\text{Count of all functions}\\ 
&- \text{Count of all functions with exactly one element of B not in their co-domain} \\
&- \text{Count of all functions with exactly two elements of B not in their co-domain} \\
&\qquad \vdots \\
&- \text{Count of all functions with n-1 elements of B not in their co-domain} \\
\end{aligned}
$$
1. Step 1 -
    - To get the count of all functions with exactly one element of B not in their co-domain, we have to consider a subset $B_1$ of $n-1$ elements which acts as the codomain to a non-onto function. We can pick 1 element to remove from $B$ in $^nC_1$ ways.
    - Once this element has been excluded we can make a total of $(n-1)^m$ functions between the $m$ elements in $A$ and $n-1$ elements in $B_1$. 
    - Thus $-^nC_1* (n-1)^m$ functions need to be added to the total number of functions for the first step.
2. Step 2 -
    - To get the count of all functions with exactly one element of B not in their co-domain, we can use a similar logic as Step 1. Thus the total number of functions to exclude would be $^nC_2* (n-2)^m$.
    - But the Step 1 would already exclude the functions with exactly $n-2$ elements in their co-domains twice. Similar to how we do in [[Set Theory#Principle of Inclusion and Exclusion|Principle of Inclusion and Exclusion]], we'd have to reintroduce the count of these functions such that they are only excluded once. (Lecture 17, 33:50)
    - Thus $+^nC_2* (n-2)^m$ functions need to be added to the total number of functions for the second step.
3. Step 3 -
    - Similar to how in Step 2 we saw that functions with co-domain size of $n-2$ elements were excluded twice in Step 1, functions with co-domain size of $n-3$ elements were excluded thrice in Step 1. At the same time in Step 2 they were again added back thrice, thus resulting in a net of $3-3=0$. 
    - Thus they need to be excluded at least one time, and thus $-^nC_3* (n-3)^m$ needs to be added to the total number of functions for the third step.

Using the logic for these steps is what leads to the final formula mentioned above. Check [[Functions#^q1|Question 1]] for an aptitude related application.

# Bijective Function
If a function is both injective (one-one) and surjective (onto), then the function is called a **bijective function**.

Any function $f$ has an inverse function $f^{-1}$ if and only if it is bijective.
# Identity Function
An Identity Function $I_A$ on a set $A$ is a function such that $I_A(x)=x,\,\forall x \in A$.
# Identical Function
Two functions are said to be identical if -
- They have the same domain and range.
- Both the functions generate the same value for all elements in the domain.
# Function Composition
When the output of a function $g$ is passed as the input to a function $f$, we say this is a function composition $fog$, where $f(g(x))=fog(x)$.
# Inverse of a Function
A function $f$ has an inverse function $f^{-1}$ **if and only if $f$ is bijective**. Every bijective function $f:A \rightarrow B$ has an inverse $f^{-1}$ such that, $f^{-1}of=I_A$ and $fof^{-1} = I_B$ where $I_A$ and $I_B$ are the identity functions on set $A$ and $B$.

Function composition is an [[Group Theory#^associativity|associative]] operation.

---
# Questions
^q1
<h6 class="question">Q1) If there are 6 jobs being assigned to 3 computers, in how many ways can they be assigned such that each computer does at least one job?</h6>

$\underline{\text{Sol}^n} -$
Here we can see that the a mapping exists between jobs and computers where a job can only be assigned to a single computer and all computers must have at least one job assigned to them. This is the exact structure of a [[Functions#Surjective Functions (onto)|surjective function]] where the domain is the set of jobs and co-domain is the set of computers. Just apply the formula for [[Functions#Count of all Surjective Functions|count of all onto functions]] with $m=6$ and $n=3$, the answer would come out to be $\boxed{540}$.