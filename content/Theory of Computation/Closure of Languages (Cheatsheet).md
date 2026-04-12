
|         Operation         | RLs | CFLs | DCFL | CSL | Rec-Lang | REL |
| :-----------------------: | :-: | :--: | :--: | :-: | :------: | :-: |
|           Union           |  ✅  |  ✅   |  ❌   |  ✅  |    ✅     |  ✅  |
|       Concatenation       |  ✅  |  ✅   |  ❌   |  ✅  |    ✅     |  ✅  |
|       Intersection        |  ✅  |  ❌   |  ❌   |  ✅  |    ✅     |  ✅  |
|        Complement         |  ✅  |  ❌   |  ✅   |  ✅  |    ✅     |  ❌  |
|        Difference         |  ✅  |  ❌   |  ❌   |  ✅  |    ✅     |  ❌  |
| Intersection with regular |  ✅  |  ✅   |  ✅   |  ✅  |    ✅     |  ✅  |
|  Difference with regular  |  ✅  |  ✅   |  ✅   |  ✅  |    ✅     |  ✅  |
|      Kleene Closure       |  ✅  |  ✅   |  ❌   |  ❌  |    ✅     |  ✅  |
|     Positive Closure      |  ✅  |  ✅   |  ❌   |  ✅  |    ✅     |  ✅  |
|       Substitution        |  ✅  |  ✅   |  ❌   |  ✅  |    ❌     |  ✅  |
|       Homomorphism        |  ✅  |  ✅   |  ❌   |  ❌  |    ❌     |  ✅  |
|   Inverse homomorphism    |  ✅  |  ✅   |  ✅   |  ✅  |    ✅     |  ✅  |
|         Reversal          |  ✅  |  ✅   |  ❌   |  ✅  |    ✅     |  ✅  |
## Operator Precedence
The precedence of regular operators. are
$$
() \gg *,+,R, - \gg \circ \gg \cap, \backslash \gg \cup 
$$
- Parentheses or grouping have highest precedence.
- This is followed by the unary operators of **Kleene star, positive star, reversal**, and **complement** that have the same precedence.
- This is followed by the binary operator of concatenation.
- Then we have binary operators of intersection and difference with the same precedence.
- Finally, the binary operator of the union has the lowest precedence.