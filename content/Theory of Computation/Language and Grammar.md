A grammar $G$ is a 4-tuple $G = (T, N, S, P)$, where
- $T$ is the set of *terminal symbols*.
- $N$ is the set of *non-terminal symbols*.
- $S$ is the set of *start states*.
- $P$ is the set of *production rules*.

Every production rule is of the form -
$$
\alpha \rightarrow \beta
$$

where $\alpha \in (N \cup T)^+$ and $\beta \in (N \cup T)^*$.

1. Grammars are inherently non-deterministic. Reasoning is that they are not a machine, at any step there is no "wrong choice".
2. In a derivation, $\alpha_i$ is in a **Sentential Form** if $\alpha_i \in (N \cup T)^+$. ^e7b4fd
3. $\alpha_i$ is in a **Sentence** if $\alpha_i = w \in T^*$.
# Chomsky Hierarchy
![[Pasted image 20260304165336.png|450]]