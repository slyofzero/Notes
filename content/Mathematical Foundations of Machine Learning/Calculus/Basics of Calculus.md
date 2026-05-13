# Approximations
We can approximate the value at any point of the curve by using polynomials of increasing orders.
## Linear Approximation
Consider a point $x=a$ on the graph at which we wish to approximate the value of the function using a line centered around some $x=a$. We center at $a$ because the approximation is fundamentally about **local behavior**, and locality is measured relative to the point you care about.

The equation of this approximation line would be $L(x)=m(x-a)+c$. Around some really small $\epsilon-$neighbourhood around $x=a$ we can say that the curve of the graph and the line coincide, thus $f(x) = L(x)$.

![[Pasted image 20260223084831.png|550]]

By plugging in $x=a$ we can get $c = f(a)$. Due to this we can even say that,
$$
\begin{alignedat}{3}
&&\,\,f(x) &= m(x-a) + c \\[8pt]
&\Rightarrow &m &= \frac{f(x)-f(a)}{x-a} \\[8pt]  
&\Rightarrow &\lim_{x\rightarrow a}m &= \lim_{x\rightarrow a}\frac{f(x)-f(a)}{x-a} \\[8pt]
&\Rightarrow & m &= f'(a) \\[8pt]  
\end{alignedat}
$$

Using this information we can finalize it all by doing,

$$
\begin{alignedat}{3}
&&L(x) &= m(x-a) + c \\[8pt]
&\Rightarrow &f(x) &= f(a) + f'(a)(x-a) \\[8pt]
\end{alignedat}
$$

If we consider a fixed point $x$ instead of $a$ and we wish to find the value of any point some $\triangle x$ distance away from $x$, we can rewrite the above equations as

$$
f(x+\triangle x) = f(x) + f'(x)\triangle x
$$

This is the First-Order Approximation of a function, also called as the **Linear Approximation**.
## Quadratic Approximation
Similar to how we had a linear centered around $x=a$ for linear approximation, we can also have a parabola centered around $x=a$ for a second order approximation of the function. This parabola can be represented as,

$$
p(x) = A(x-a)^2 + B(x-a) + C
$$

Again, by plugging in $x=a$ we get that $C = p(a)$. As in some $\epsilon-$neighbourhood around $a$ the parabola and the curve of the graph would coincide, we can say that $p(a) = f(a)$.

We can get $B$ by doing,
$$
\begin{alignat*}{3}
&& f(x) &= A(x-a)^2 + B(x-a) + C \tag{1}\\[8pt]
&\Rightarrow & \,\,f(x) &= A(x-a)^2 + B(x-a) + f(a) \\[8pt]
&\Rightarrow & \,\,\frac{f(x) - f(a)}{x-a} &= A(x-a) + B(x-a) \\[8pt]
&\Rightarrow & \lim_{x \rightarrow a}A(x-a) + B(x-a) &= \lim_{x \rightarrow a}\frac{f(x) - f(a)}{x-a}\\[8pt]
&\Rightarrow & B &= f'(a)\\[8pt]
\end{alignat*}
$$

We can get $A$ by taking the derivative of $(1)$ and solving for $A$.

$$
\begin{alignat*}{3}
&& f(x) &= A(x-a)^2 + B(x-a) + C \tag{1}\\[8pt]
&\Rightarrow & \,\,f'(x) &= 2A(x-a) + B \\[8pt]
&\Rightarrow & \,\,f'(x) &= 2A(x-a) + f'(a) \\[8pt]
&\Rightarrow & \,\,A &= \frac{f'(x) - f'(a)}{2(x-a)} \\[8pt]
&\Rightarrow & \,\,\lim_{x \rightarrow a}A &= \frac{1}{2}\lim_{x \rightarrow a}\frac{f'(x) - f'(a)}{(x-a)} \\[8pt]
&\Rightarrow & \,\,A &= \frac{1}{2}f''(a)\\[8pt]
\end{alignat*}
$$

By putting it all together we get,
$$
f(x) = f(a) + f'(a)(x-a) + \frac{1}{2}f''(a)(x-a)^2
$$

or if we write this in the terms of $\triangle x$, we get
$$
f(x+\triangle x) = f(x) + f'(x)\triangle x + \frac{1}{2}f''(x)\triangle x^2
$$

This same method can then be extended to higher degrees to get higher order approximations of a function. That's the **Taylor Series**.
## Taylor Series
The Taylor series provides a higher order approximation for a function's value around some neighbourhood of any point $x$.

$$
\begin{aligned}
f(x+\triangle x) &= f(x) + f'(x) \triangle x + \frac{1}{2!}f''(x) \triangle x^2 + \frac{1}{3!}f'''(x) \triangle x^3 + \dots \\[8pt]
&= \sum_{i=0} \frac{1}{i!} f^{(i)}(x) \triangle x^i
\end{aligned}
$$
# Cauchy Schwarz Inequality
# Directional Derivative
Direction of steepest descent is $-\nabla f(x^*)$. This can be shown by either using the [[Basics of Calculus#Cauchy Schwarz Inequality|Cauchy Schwarz Inequality]] or [[Basics of Calculus#Taylor Series|Taylor Series]].