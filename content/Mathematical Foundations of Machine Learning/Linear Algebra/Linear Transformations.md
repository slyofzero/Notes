>[!SUMMARY] Table of Contents
>- [[Linear Transformations#Linear Transformations|Linear Transformations]]
>- [[Linear Transformations#Representation as matrix|Representation as matrix]]
>- [[Linear Transformations#Transformation across dimensions|Transformation across dimensions]]
>- [[Linear Transformations#Composition of transformations|Composition of transformations]]
>- [[Linear Transformations#Invertibility|Invertibility]]
>	- [[Linear Transformations#Why do singular matrices have det = 0?|Why do singular matrices have det = 0?]]
>	- [[Linear Transformations#Isometry Transformations|Isometry Transformations]]
>- [[Linear Transformations#Column Space|Column Space]]
>- [[Linear Transformations#Null Space|Null Space]]
# Linear Transformations
Linear transformations are mapping between two vector spaces which obey the rules of vector addition and scalar multiplication.

$\underline{\text{Definition}}-$ A linear transformation $T$ is a mapping from $W_1$ to $W_2$ denoted by $T: W_1 \rightarrow W_2$ that obeys the following rules -
1. $T(u)=0$
2. $T(u_1 + u_2) = T(u_1) + T(u_2)$ (Transformation of sum is sum of transformations)
3. $T(\alpha \, u) = \alpha T(u)$ (Transformation of scalar product is a scalar product of transformation)

Here -
- $\operatorname{Domain}(T) = W_1$ 
- $\operatorname{Codomain}(T) = W_2$
- $\operatorname{Range}(T)=\{T(x) | x \in W_1\} =$ [[Linear Transformations#Column Space|Column Space]]$(W_1)$. ^17c71a

Each vector can be transformed into a new vector space by performing a linear combination on it using a specific set of scalars. This linear transformation can be denoted as matrix multiplication too -

$$
\left[\begin{matrix}
a_{11} & \dots & a_{1m} \\
 & \vdots &  \\
a_{n1} & \dots & a_{nm} \\
\end{matrix}\right]

\left[\begin{matrix}
x_{1} \\
\vdots \\
x_{m} \\
\end{matrix}\right] = Mx
$$

This matrix $M$ is used to represent the linear transformation $T$.
# Representation as matrix
Say we have a transformation $T: \mathbb{R}^2 \rightarrow \mathbb{R}^2$ and we are interested in finding its matrix representation.

$$
T\left(\begin{array}
&
x \\
y \\
\end{array}\right)
=
T\left(\begin{array}
&
x+y \\
x-y \\
\end{array}\right)
$$

The column vectors of the matrix are the basis of the transformation. We can simply transform the basis vectors of $\mathbb{R}^2$ to get the new basis of the transformation.

$T((1,0)) = (1,1)$ and $T((0,1)) = (1,-1)$. Thus -

$$
M = \left[\begin{matrix}
1 & 1 \\
1 & -1 \\
\end{matrix}\right]
$$

Similarly the matrix for the linear transformation can be obtained for any linear transformation.
# Transformation across dimensions
Let $A$ be a lower dimensional vector space and $B$ be a higher dimensional vector space.
1. $T_1: B \rightarrow A$
2. $T_2: A \rightarrow B$

Will $T_1$ cover all of $A$? Will $T_2$ cover all of $B$?

1. $T_1$ will cover all of $A$ because we are transforming a higher dimensional space into a lower dimensional space. This is because there is enough information in the basis of $B$ to be able to capture all directions of $A$.
2. $T_2$ will not cover all of $B$ because we are transforming a lower dimensional vector space to a higher dimensional subspace. This is because the number of basis vectors of $A$ is not enough to capture all the directions of $B$. This transformation would instead cover a lower dimensional subspace in $B$.
# Composition of transformations
Let $T_1: U \rightarrow V$ and $T_2: V \rightarrow W$ be two linear transformations. Using these we define a composition of linear combinations $T: U \rightarrow W$ as $T = T_2 \circ T_1$.

$$
\begin{aligned}
T(u_1 +u_2) &= T_2(T_1(u_1 +u_2)) \\[8pt]
&= T_2(T_1(u_1) +T_1(u_2)) \\[8pt]
&= T_2(v_1 + v_2) \\[8pt]
&= T_2(v_1) + T_2(v_2) \\[8pt]
&= w_1 + w_2 \\[8pt]
\end{aligned}
$$

We can represent $T$ as a matrix multiplication of $M_2$ and $M_1$ -

$$
M = M_2 M_1
$$
# Invertibility
For a transformation to be invertible, the mapping needs to be bijective. If multiple inputs could be mapped to the zero vector, then this mapping isn't injective. Hence, **the transformation isn't invertible (singular)** as the zero vector has more than one pre-image to be mapped to in the reverse direction.

Because the transformation is singular, we can say the matrix $M$ representing the transformation is singular too.
## Why do singular matrices have det = 0?
The determinant measures the "volume" of the space formed by the vectors of a matrix. If one of these vectors is a linear combination of the others, this would cause a loss of dimension in the vector space and mean that the vectors lie in a lower-dimensional subspace. The space spanned by a lower-dimensional subspace is always zero, which results in the determinant being zero.
## Isometry Transformations
$\underline{\text{Definition}}-$ Any linear transformation $T$ where $||T(u)||=||u||$ is called an **isometry transformation**.

***Example -*** Rotation and Reflection.
# Column Space
The column space of a matrix is the set of all possible vectors obtained as the linear combinations of columns of a matrix.

In terms of a transformation - The [[Linear Transformations#^17c71a|range]] of the linear transformation is the column space of the matrix used to represent the transformation.
# Null Space
The subspace of vectors that are the solution to the homogeneous system of linear equations $Ax$ is called the **null space**.

$$
Ax = 0 \qquad \forall x \in \operatorname{Null Space}(A)
$$

In terms of a transformation - The subspace of vectors that gets mapped to the zero vector upon performing a linear transformation is called the **null space** or the **kernel** of the linear transformation.

1. **Homogeneous system of equations -** System of equations where no equation has a constant term (all constants are 0.)
2. **Heterogeneous system of equations -** System of equations where at least one equation has a constant term.
