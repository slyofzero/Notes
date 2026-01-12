>[!SUMMARY] Table of Contents
>- [[Stack#Postfix expressions|Postfix expressions]]
>	- [[Stack#Infix to Postfix|Infix to Postfix]]
>	- [[Stack#Evaluating Postfix expressions|Evaluating Postfix expressions]]
>- [[Stack#Infix to Prefix|Infix to Prefix]]
>	- [[Stack#Evaluating Prefix expressions|Evaluating Prefix expressions]]

A stack is a linear data structure that follows the LIFO rule of handling elements stored in it. It has a few basic operations such as PUSH, POP, and PEEK.

Using a stack we implement various things like the undo and redo operation. One common type of questions asked around Stack are related to **Infix to Postfix/Prefix conversion** of expressions.
# Postfix expressions
Infix expression - $(A + B) - C * D / E - F$
Corresponding Postfix expression - $AB+CD*E/-F-$
## Infix to Postfix
Steps of conversion -
1. Scan the infix expression from **left to right**, one character at a time and store the current character as `curr`. Use a stack `S` to keep track of operator precedence and a variable `Y` for the output expression.
2. If `curr` is an operand, `PUSH(curr, Y)`, else
3. If `curr` is a bracket then,
	1. if `curr` is an opening bracket, `PUSH(curr, S)`, else
	2. if `curr` is a closing bracket, `POP(S)` until `SEEK(S)` is an opening bracket and `POP(S)` once more to remove that too. Basically, keep popping until the operators in the enclosed expression are removed from the stack.
4. If `curr` is an operator then,
    1. if `SEEK(S) >= curr`, then `POP(S)` until `SEEK(S) <= curr`, else
    2. if `SEEK(S) < curr`, then `PUSH(curr, S)`.
5. If `curr` is `$/EOF` (end of expression) `POP(S)` until the stack is empty.
## Evaluating Postfix expressions
1. Scan from left to right.
2. Push any operand onto a stack.
3. If the current character is an operator, `s1=POP(S); s2=POP(S)` and perform `s2 op s1`. Push the output back on the stack.
4. Keep doing this until the stack is empty.

# Infix to Prefix
Infix expression - $(A + B) - C * D / E - F$
Corresponding Prefix expression - $--+AB/*CDEF$

Steps of conversion -
1. Scan the infix expression from **right to left**, one character at a time and store the current character as `curr`. Use a stack `S` to keep track of operator precedence and a variable `Y` for the output expression.
2. 2. If `curr` is an operand, `PUSH(curr, Y)`, else
3. If `curr` is a bracket then,
	1. if `curr` is a closing bracket, `PUSH(curr, S)`, else
	2. if `curr` is an opening bracket, `POP(S)` until `SEEK(S)` is a closing bracket and `POP(S)` once more to remove that too. Basically, keep popping until the operators in the enclosed expression are removed from the stack.
4. If `curr` is an operator then,
    1. if `SEEK(S) < curr`, then `POP(S)` until `SEEK(S) >= curr`, else
    2. if `SEEK(S) >= curr`, then `PUSH(curr, S)`.
5. If `curr` is `$/EOF` (end of expression) `POP(S)` until the stack is empty.
6. Reverse `Y` to some `Z`. `Z` is the resultant prefix expression.
## Evaluating Prefix expressions
1. Scan from right to left.
2. Push any operand onto a stack.
3. If the current character is an operator, `s1=POP(S); s2=POP(S)` and perform `s1 op s2`. Push the output back on the stack.
4. Keep doing this until the stack is empty.