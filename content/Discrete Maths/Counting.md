# Formulas
In addition to these, also see the [[Analysis of Algorithms#Mathematical Series|Mathematical Series]] discussed in Analysis of Algorithms.

1. Permutations -
$$
^nP_r = \frac{n!}{r!}
$$
2. Combinations (Repetition not allowed) -
$$
^nC_r = \frac{^nP_r}{r!} = \frac{n!}{r!(n-r)!}
$$
3. Combinations (Repetition allowed), bars and stars example in [[Counting#^q2|Question 2]] -
$$
= \binom{n+r-1}{r-1} = \frac{(n+r-1)!}{n!(r-1)!}
$$
4. Pascal's rule -
$$
^nC_r =\binom{n}{r} = \binom{n-1}{r} + \binom{n-1}{r-1}
$$
---
<h6 class="question">Q1) Find a formula for counting the number of diagonals in an n-gon</h6>

<u>Sol</u>$^n$ - The $n$ vertices can be connected using a line in $^nC_2$ ways. Out of these connections, $n$ connections would be edges connecting adjacent vertices. Thus the number of diagonals is $^nC_2 - n$.

![[Pasted image 20251226113413.png]]

---
^q2
<h6 class="question">Q2) A shopkeeper has 3 ice-cream flavors. In how many ways can he sell these flavors to 10 kids</h6>

<u>Sol</u>$^n$ - Consider 12 slots and 2 sticks. These 2 sticks can be used to divide the 12 slots into 3 sections like this -
![[Pasted image 20251226115828.png]]

So now the problem has shifted to picking 2 slots from 12 total slots to insert the sticks in. Thus the answer is $^{12}C_2 = 66$. A more general solution to this would be $\binom{n+r-1}{r-1}$ where $n$ is the number of children and $r$ is the number of flavors.

---
<h6 class="question">Q3) In how many ways can we write 100 as a sum of 4 non-negative integers.</h6> 

<u>Sol</u>$^n$ - This can be modelled as a similar problem with 103 slots and 3 sticks. Thus the solution is $$\binom{103}{3} = \frac{103!}{100! \cdot 3!} = \frac{101*102*103}{6} = 176,851$$

---
# Binomial Theorem
In the expansion of $(a+b)^{n}$, each term is of the form $a^xb^y$ where $0 \le x \le n$  and $y = n - x$. For any term $a^xb^y$, $a$ must have been contributed by $x$ number of $(a+b)$ terms while the rest $n-x$ number of terms contributed towards $b$. We can choose $x$ of the $n$ factors from which $a$ is selected in $^nC_x$ ways. Thus the coefficient of any term $a^xb^{n-x}$ is $^nC_x$.

$$
\begin{aligned}
(a+b)^{n} &= \sum_{i=0}^n \ \binom{n}{n-i} \cdot a^{n-i}b^i \\
&= a^n + \binom{n}{n-1}a^{n-1}b + \dots + \binom{n}{1}ab^{n-1} +b^n
\end{aligned}
$$
## Interesting Applications
1. Euler's constant - 
   $$
   \lim_{n\rightarrow\infty} \left(1 + \frac{1}{n} \right)^n = \sum_{k=0}^\infty\frac{1}{k!}
   $$
2. Derivative of $x^n$ 
   $$
   \begin{aligned}\frac{d}{dx} x^n &= \lim_{n \rightarrow \infty} \frac{x^{n+h}-x^n}{h} \\&= n \cdot x^{n-1}\end{aligned}
   $$
3. We know $(a+b)^{n} = \sum_{i=0}^n \ \binom{n}{n-i} \cdot a^{n-i}b^i$. What if $a = b = 1$?    
$$
\begin{aligned}
(1+1)^n &= \sum_{i=0}^n \ \binom{n}{n-i} \cdot 1^{n-i}1^i \\
&= \sum_{i=0}^n \ \binom{n}{n-i} \cdot 1 \\
&= \binom{n}{0} + \binom{n}{1} + \binom{n}{2} + \dots + \binom{n}{n}\\
\\
\text{Thus,} \\
\\
2^n &= \binom{n}{0} + \binom{n}{1} + \binom{n}{2} + \dots + \binom{n}{n}
\end{aligned}
$$

4. Using a similar logic we can find -
$$
\begin{alignedat}{3}
&&\left(1-1\right)^n &= \binom{n}{1} - \binom{n}{2} + \binom{n}{3} - \binom{n}{4} + \dots \\
&&\Rightarrow \binom{n}{2} + \binom{n}{4} + \binom{n}{6} + \dots &= \binom{n}{1} + \binom{n}{3} + \binom{n}{5} + \dots  \\
\end{alignedat}
$$

5. **Extended binomial coefficient** - For any real number $r$, the binomial coefficient is defined by $\binom{r}{k} = \frac{r(r-1)(r-2)\cdots(r-k+1)}{k!}$. Now let $n \in \mathbb{N}$ and substitute $r = -n$. Then,

$$
\begin{aligned}
\binom{-n}{k}
&= \frac{(-n)(-n-1)(-n-2)\cdots(-n-k+1)}{k!} \\[6pt]
&= \frac{(-1)^k\, n(n+1)(n+2)\cdots(n+k-1)}{k!} \\[6pt]
&= (-1)^k \frac{(n+k-1)!}{k!*(n-1)!} \\[6pt]
&= \boxed{(-1)^k \binom{n+k-1}{k}}
\end{aligned}
$$

    - Using this we can find -
$$
\begin{aligned}
\frac{1}{1-x}&=1+x+x^2+x^3+x^4\dots \\
\frac{1}{1+x}&=1-x+x^2-x^3+x^4\dots
\end{aligned}
$$

## $r^{th}$ term of the Binomial Expansion
The $r^{th}$ term of the Binomial Expansion is always -
$$\binom{n}{r-1!}a^{n-r+1}b^{r-1}$$
# Multinomial Theorem
What would the coefficients of each term look like in the expansion of $(a+b+c+\dots)^n$? 

We can consider $(a+b+c+\dots)^n = (a+R_1)^n$ where $R_1 =(b+c+\dots)$. Upon expansion by applying the binomial theorem, any $(n_1+1)^{th}$ term (for simpler calculations without loss of generalization) would be of the form - 
$$
\binom{n}{n_1}a^{n_1}R_1^{n-n_1}
$$

$R_1^{n-n_1}=(b+R_2)^{n-n_1}$ where $R_2 = (c+\dots)$. The coefficient of some $(n_2+1)^{th}$ term of this expansion would be - 

$$
\binom{n-n_1}{n_2}
$$
We can continue doing this expansion until $R_k$ becomes a binomial. By that point, the coefficient of the $(n_1+1)^{th}$ of the original multinomial would be - 

$$
\binom{n}{n_1} \cdot \binom{n-n_1}{n_2} \cdot \binom{n-n_1-n_2}{n_3} \dots \binom{n-n_1-n_2 \dots - n_{k-1}}{n_k}
$$

$$
\begin{aligned}
&= \frac{n!}{n_1! \cdot (n-n_1)!} \cdot \frac{(n-n_1)!}{n_2! \cdot (n-n_1-n_2)!} \dots \frac{(n-n_1-n_2 \dots - n_{k-1})!}{n_k! \cdot (n-n_1-n_2 \dots - n_{k})!}

\\ &= \frac{n!}{n_1! \cdot \cancel{(n-n_1)!}} \cdot \frac{\cancel{(n-n_1)!}}{n_2! \cdot \cancel{(n-n_1-n_2)!}} \dots \frac{\cancel{(n-n_1-n_2 \dots - n_{k-1})!}}{n_k! \cdot (n-n_1-n_2 \dots - n_{k})!}

\\&= \frac{n!}{n_1! \cdot n_2! \dots n_k!}
\end{aligned}
$$
# Pascal's Triangle
![[Pasted image 20251226164039.png | 500]]

Each row $i$ of the Pascal's Triangle contains the Binomial Coefficients of the expansion $(a+b)^i$.
## Fun Facts
1. The second diagonal is the sequence of Natural Numbers.
2. Each $i^{th}$ row's sum is $2^{i-1}$.
3. Each row also denotes $11^{i-1}$.
# Catalan's Numbers
In how many ways can one reach $(5,5)$ from $(0,0)$ in the below  $5 \times 5$ grid?

![[Pasted image 20251226164729.png | 500]]

# Pigeon Hole Principle
The principle states that if we have $m$ pigeons and $n$ pigeon holes such that $m>n$. Then there would at least be one pigeon hole such that at least 2 pigeons reside in it.

Usually used in finding the worst case of the number of item pickings such that it satisfied some constraint. 

---
<h6 class="question">Q4) What is the minimum number of ways people can be seated in a hall such that it always ensures that at least two people share the same first name and last name initials.</h6> 

<u>Sol</u>$^n$ - There are a total of 26 letter in the English Alphabets. So a person's initial can be - A.A., A.B., A.C., $\dots$, Z.Z. Only after all $26^2$ initials have been covered can we say that seating one more person will ensure that at least two people share the same initials. Thus the number of pigeon holes we have is $26^2$ and the number of "pigeons" or minimum number of people needed is $\boxed{26^2+1}$.

---
# Generating Function
The idea of a generating function is if you have some question with the answer associated with some positive integer, you can model the problem as a polynomial such that the coefficients of certain terms would correspond to this answer.

Say we want the number of subsets of $\{1,2,3,4\}$ such that the sum of the elements in each subset is equal to 5. We can model this as a polynomial problem of $f(x) = (1+x)(1+x^2)(1+x^3)(1+x^4)$ such that the coefficient corresponding to $x^5$ in the product would be this count. Here $f(x)$ is your generating function.

No idea how someone thought of this (even [3Blue1Brown](https://www.youtube.com/watch?v=bOXCLR3Wric) doesn't) but it can be seen why the above example would work. A generating function is of the form -

$$
\begin{aligned}
G(x) &= a_0+a_1x+a_2x^2+a_3x^3+\dots \\
&= \sum_{i=0}^na_ix^i
\end{aligned}
$$
# Recurrence Relation
Back Substitution is discussed in [[Analysis of Algorithms#Back Substitution Method|Analysis of Algorithms]], so only method of characteristic roots will be discussed here.
## Method of characteristic roots
