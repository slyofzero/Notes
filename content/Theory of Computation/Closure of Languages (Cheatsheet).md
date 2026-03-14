
|   Operation   | RLs | CFLs | CSL | REL |
| :-----------: | :-: | :--: | :-: | :-: |
|     Union     |  ✅  |  ✅   |     |     |
| Intersection  |  ✅  |  ❌   |     |     |
|  Complement   |  ✅  |  ❌   |     |     |
| Concatenation |  ✅  |  ✅   |     |     |
|  Kleene Star  |  ✅  |  ✅   |     |     |
| Positive Star |  ✅  |  ✅   |     |     |
|  Difference   |  ✅  |  ❌   |     |     |
|   Reversal    |  ✅  |  ✅   |     |     |
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
## Extras
- Intersection of CFLs and RLs is closed.