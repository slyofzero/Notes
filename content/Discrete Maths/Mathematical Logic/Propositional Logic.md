A **statement** is a declarative statement that is either true or false, never both. A statement can either be primitive or compound.
- **Primitive statement** - India is a nice place to live.
- **Compound statement** - India is a nice place to live and people in India are really friendly.

AND $(\land)$, OR $(\lor)$, and NEGATION $(\lnot)$ are called the **primitive/basic logical operators**. Their truth tables isn't worth discussing.
# Implication
The implication operator $\implies$ in any statement like $A \implies B$ means that if $B$ is true, then $B$ must be true. It doesn't mean that $A$ and $B$ cause each other, it just means that $A$ being true cannot coexist with $B$ being false.

The truth table of the implication operator looks like -

| $A$ | $B$ | $A \implies B$ |
| :-: | :-: | :------------: |
|  0  |  0  |       1        |
|  0  |  1  |       1        |
|  1  |  0  |       0        |
|  1  |  1  |       1        |

The truth table can seem confusing as the implication is considered true even when $A$ is false. This is because it just means that $A$ being true cannot coexist with $B$ being false. When $A$ is false, the implication is vacuously (by default) considered true.

For any statement $A \implies B$ to be an implication, its truth table should be the same as an implication's.
## Double Implication
When for two statements $A$ and $B$, $A \implies B$ and $B \implies A$, we say that $A \iff B$. As we are looking at a two-way implication here, the truth table of double implication will only be false when one statement is true and the other isn't.

| $A$ | $B$ | $A \implies B$ |
| :-: | :-: | :------------: |
|  0  |  0  |       1        |
|  0  |  1  |       0        |
|  1  |  0  |       0        |
|  1  |  1  |       1        |
## Converse, Inverse, and Contrapositive
The implication at hand is $p \implies q$ -
1. Converse of this implication will be $q \implies p$.
2. Inverse of this implication will be $\lnot p \implies \lnot q$.
3. Contrapositive of this implication will be $\lnot q \implies \lnot p$.

