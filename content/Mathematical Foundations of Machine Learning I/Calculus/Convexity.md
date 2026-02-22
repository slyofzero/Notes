A set is a convex set if $\forall x_1, x_2 \in S$, $\lambda x_1 + (1 - \lambda)x_2 \in S$ where $\lambda \in [0,1]$. Geometrically speaking, the below sets are a convex set -

![[Pasted image 20260217104309.png|550]]

## Properties -
1. If $A$ and $B$ are two convex sets then $A \cap B$ is also a convex set.
$$
\begin{aligned}
\text{Let } x_1 \text{ and } x_2 \in A \cap B. &\text{We can say,} \\[8pt]
\lambda x_1 + (1 - \lambda)x_2 &\in A \text{ because } x_1, x_2 \in A \\[8pt]
\lambda x_1 + (1 - \lambda)x_2 &\in B \text{ because } x_1, x_2 \in B \\[8pt]
\text{Thus we can say that } x_1, &x_2 \in A \cap B.
\end{aligned}
$$

This property is helpful in showing if a set is convex, by showing that the set is formed by intersection of two other convex sets.
