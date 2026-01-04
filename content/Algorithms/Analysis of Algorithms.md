>[!SUMMARY] Table of Contents
>- [[Analysis of Algorithms#Types of Analysis|Types of Analysis]]
>	- [[Analysis of Algorithms#Aposteriori Analysis|Aposteriori Analysis]]
>		- [[Analysis of Algorithms#1. Step Count Method|1. Step Count Method]]
>		- [[Analysis of Algorithms#2. Order of Magnitude Method|2. Order of Magnitude Method]]
>- [[Analysis of Algorithms#Time Complexity|Time Complexity]]
>	- [[Analysis of Algorithms#Cases for Time Complexity |Cases for Time Complexity ]]
>	- [[Analysis of Algorithms#Mathematical Series|Mathematical Series]]
>		- [[Analysis of Algorithms#Arithmetic Progression -	|Arithmetic Progression -	]]
>		- [[Analysis of Algorithms#Geometric Progression -|Geometric Progression -]]
>		- [[Analysis of Algorithms#Harmonic Progression - |Harmonic Progression - ]]
>		- [[Analysis of Algorithms#Sum of Squares of first n Natural Numbers -|Sum of Squares of first n Natural Numbers -]]
>		- [[Analysis of Algorithms#Sum of Cubes of first n Natural Numbers -|Sum of Cubes of first n Natural Numbers -]]
>	- [[Analysis of Algorithms#Time Complexity of Recursive functions|Time Complexity of Recursive functions]]
>		- [[Analysis of Algorithms#Back Substitution Method|Back Substitution Method]]
>	- [[Analysis of Algorithms#Time Complexity of Loops|Time Complexity of Loops]]
>- [[Analysis of Algorithms#Space Complexity|Space Complexity]]
>- [[Analysis of Algorithms#Questions|Questions]]
>	- [[Analysis of Algorithms#1. TC of Recurrence|1. TC of Recurrence]]
>	- [[Analysis of Algorithms#2. TC of loops|2. TC of loops]]
>	- [[Analysis of Algorithms#3. Space Complexity|3. Space Complexity]]
# Types of Analysis
1. Aposteriori Analysis - By code execution
2. Apriori Analysis - Before code execution
## Aposteriori Analysis
Two methods of Aposteriori Analysis -
1. Step Count
2. Order of Magnitude
### 1. Step Count Method
Counting the exact number of fundamental operations done in the code.

Example - 
```c
p = q + r                        // 2 operations
s = t * u                        // 2 operations

for (i=1, i<=n, i++) {           // (1 + n * 4 + 1 = 4n + 2) operations
	a = b + c
}

for (j=1; j<=n, j++) {           // (1 + n * (m+2) + 1) operations
	for (k=1, k<=n, k++) {       // m = 1 + n * 4 + 1 = 4n + 2 operations
		a = b + c                // Total = 4n^2 + 4n + 2 operations
	}
}
```

Total number of operations in the above code is - $4n^2 + 8n + 8$.
### 2. Order of Magnitude Method
Instead of having the exact count, consider the order of magnitude of the fundamental statements executed.

# Time Complexity
The amount of time required by any program to execute, expressed as a function of the input size is called the *Time Complexity*.
## Cases for Time Complexity 
Based upon the input there are 3 cases -
1. <u>Best Case</u> - Minimum number of times.
2. <u>Worst Case</u> - Maximum number of times.
3. <u>Average Case</u> - Probability dependent.

## Mathematical Series
### Arithmetic Progression -	
$$
\text{Sum of AP} = \sum_{i=1}^n \ a+i*d = \frac{n(2a+(n-1)d)}{2}
$$
### Geometric Progression -
$$
\text{Sum of GP} = \sum_{i=0}^n \ a \cdot r^i = \frac{a(r^n - 1)}{r-1}
$$
### Harmonic Progression - 
$$
\text{Sum of HP} = \sum_{i=1}^n \ \frac{1}{i} \approx log \ n
$$
### Sum of Squares of first n Natural Numbers -
$$
\text{Sum of AP} = \sum_{i=1}^n \ i^2 = \frac{n(n+1)(2n+1)}{6}
$$
### Sum of Cubes of first n Natural Numbers -
$$
\text{Sum of AP} = \sum_{i=1}^n \ i^3 = \left( \frac{n(n+1)}{2} \right)^2
$$
## Time Complexity of Recursive functions
1. [[#Back Substitution Method]] - Gives value of recurrence and TC **\[Universal Method\]**
2. [[Divide And Conquer#Master's Method|Master's Method]] - Works only in specific cases and only gives TC
3. Recursive Tree Approach - Only TC

### Back Substitution Method
Consider the code for calculating the Factorial -
```c
f(n) {
	if (n == 1) {
		return 1
	}
	return n * f(n-1)
}
```

Assume that the time complexity of `f(n)` is $T(n)$. We can write $T(n)$ as -
$$
\begin{aligned}
T(n) &= T(n-1) + C_1 \\
T(1) &= C_2
\end{aligned}
$$
Using this information we can solve for $T(n)$ -
$$
\begin{aligned}
T(n) &= T(n - 1) + C_1 \\
     &= T(n - 2) + 2C_1 \qquad &\because T(n-1)=T(n-2)+1 \\
     &= T(n - 3) + 3C_1 \\
\end{aligned}
$$
This can be generalized as $T(n) = T(n-k) + k*C_1$. To reach the base condition we need $n-k=1$  $i.e.$  $k=n-1$.
$$
\begin{aligned}
T(n) &= T(n-(n-1)) + (n-1) * C_1
\\ &= T(1) + C_1n - C_1
\\ &= C_1n - C_1+C_2
\\ &= O(n)
\end{aligned}
$$
## Time Complexity of Loops
The TC for any loop depends upon two factors -
1. The number of times the loop is running/iterating/repeating.
2. The complexity of all the individual statements within the loop body.

How to calculate -
1. Identify the variable(s) determining the termination criteria.
2. Identify the pattern of updation for these variables over each iteration and generalize for some $k^{th}$ iteration.
3. Calculate the iteration $k$ in terms for $n$ for which the termination criteria doesn't satisfy. Thus the loop would run for these $k$ iterations.
Check [[##^q4|Question 4]] for example.

---
# Space Complexity
The amount of Auxiliary memory space (excluding the space required by the input) required by the program, expressed as a function of the input size is called the *Space Complexity*. Check [[##^q5|Question 5]] for example.
# Questions
## 1. TC of Recurrence
<h6 class="question">Q1) Find the time complexity and recurrence value for -</h6>

$$
\begin{aligned}
& T(n) = 2*T\left(\frac{n}{2}\right) + O(n) + a \\
& T(n) = b \qquad &[n = 1]
\end{aligned}
$$
where $a$ and $b$ are constants and $n$ is the input size.

<strong><u>Sol</u></strong>$^n$ -
Since $O(n)$ dominates the constant $a$, we can simplify $T(n)$ to be - 
$$
\begin{align*}
T(n) &= 2*T\left(\frac{n}{2}\right) + n \tag{1} \\
T\!\left(\frac{n}{2}\right) &= 2*T\!\left(\frac{n}{4}\right) + \frac{n}{2} \tag{2} \\
\end{align*} 
$$
$$
\begin{alignat*}{3}
T(n) &= 4\,T\!\left(\frac{n}{4}\right) + 2n 
     && \because && \ \text{Using (2)} \\

&= 8\,T\!\left(\frac{n}{8}\right) + 3n 
     && \because && \ \text{Substituting } T\!\left(\frac{n}{4}\right) \\

&= 2^3\,T\!\left(\frac{n}{2^3}\right) + 3n \\

&= 2^k\,T\!\left(\frac{n}{2^k}\right) + kn
	&&  && \ \text{Generalising for some} \ k^{th} \ term \tag{3}\\
\end{alignat*}
$$
For what value of $k$ would be achieve the base case of $n=1$?
$$
\begin{aligned}
\frac{n}{2^k} &= 1 \\
\Rightarrow\quad n &= 2^k \\
\Rightarrow\quad k &= \log n
\end{aligned}
$$
Putting $k=log\,n$ and $n=2^k$ in $(3)$,
$$
\begin{alignedat}{1}
T(n) &= 2^k\,T\!\left(\frac{n}{2^k}\right) + kn \\
 &= n\,T(1) + n\,log\,n \\
 &= b\,n + n\,log\,n \\
 &= \boxed{O(n\,log\,n)}
\end{alignedat}
$$
---
<h6 class="question">Q2) Find the worst case and best case time complexity for the below diagram </h6>

![[Pasted image 20251227112322.png]]

<strong><u>Sol</u></strong>$^n$ -
Best Case TC is achieved by Path A - $O(n)$
Worst Case TC is achieved by Path A - $O(n^3)$

---
## 2. TC of loops
<h6 class="question">Q3) Find the TC of the below code -</h6>

```c
i = 1, a = 0;
while (i = 2) {
	a += 1;
}
```

<strong><u>Sol</u></strong>$^n$ -
The condition `i=2` is not a comparison but an assignment. Thus the loop's condition is always true and this runs **infinitely**.

---
 ^q4
 <h6 class="question">Q4) Find the TC of the below code -</h6>


![[Pasted image 20251227142309.png | 300]]

<strong><u>Sol</u></strong>$^n$ - 
$$
\begin{aligned}
&1^{st}\,\text{Iteration}\,-\,b=2; \ a=1 + 2; \\
&2^{nd}\,\text{Iteration}\,-\,b=3; \ a=1 + 2 + 3; \\
&3^{rd}\,\text{Iteration}\,-\,b=4; \ a=1 + 2 + 3 + 4; \\
&\qquad\qquad\qquad\qquad\qquad\qquad\qquad\vdots \\
&k^{th}\,\text{Iteration}\,-\,b=k+1; \ a=1 + 2 + \dots + k+1 = \frac{(k+1)(k+2)}{2}; \\
\end{aligned}
$$

For the loop to terminate $a > n$, so $a = n$ will be cause the last iteration.

$$
\begin{alignedat}{3}
& &\frac{(k+1)(k+2)}{2} &= n \\
&\Rightarrow & \frac{k^2}{2} &\approx n \\
&\Rightarrow & k^2 &\approx 2n \\
&\Rightarrow & k &\approx \boxed{\sqrt{n}} \\
\end{alignedat}
$$
Thus the loop would run for $k=\sqrt{n}$  iterations. Thus TC = $O(\sqrt n)$

---
## 3. Space Complexity

^q5
<h6 class="question">Q5) Find the SC of the below code -</h6>

![[Pasted image 20251227162734.png | 300]]

<strong><u>Sol</u></strong>$^n$ - 
The elements that would be added to the recursion stack would be - $n, \frac{n}{2}, \frac{n}{4}, \frac{n}{8}, \dots, \frac{n}{2^{k-1}}, \dots, 1$.
The total number of elements would be -
$$
\begin{alignat*}{3}
&&\frac{n}{2^{k-1}} &= 1 \\
&\Rightarrow \ & n &= 2^{k-1} \\
&\Rightarrow \ & k-1 &= log_2n \\
&\Rightarrow \ & k &\approx \boxed{log_2n} \\
\end{alignat*}
$$
Thus the Space Complexity is $O(log\,n)$.