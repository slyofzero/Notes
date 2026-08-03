>[!SUMMARY] Table of Contents
>- [[Boolean Algebra and Minimization#Overview|Overview]]
>- [[Boolean Algebra and Minimization#1. Fundamental Laws & Theorems of Boolean Algebra|1. Fundamental Laws & Theorems of Boolean Algebra]]
>	- [[Boolean Algebra and Minimization#1.1 Standard Axioms and Basic Postulates|1.1 Standard Axioms and Basic Postulates]]
>	- [[Boolean Algebra and Minimization#1.2 Absorption & Elimination Laws|1.2 Absorption & Elimination Laws]]
>	- [[Boolean Algebra and Minimization#1.3 Consensus (Redundancy) Theorem|1.3 Consensus (Redundancy) Theorem]]
>	- [[Boolean Algebra and Minimization#1.4 Transposition & Shannon's Expansion Theorems|1.4 Transposition & Shannon's Expansion Theorems]]
>- [[Boolean Algebra and Minimization#2. Canonical and Standard Forms|2. Canonical and Standard Forms]]
>	- [[Boolean Algebra and Minimization#2.1 Minterms ($m_i$) and Canonical SOP (CSOP)|2.1 Minterms ($m_i$) and Canonical SOP (CSOP)]]
>	- [[Boolean Algebra and Minimization#2.2 Maxterms ($M_i$) and Canonical POS (CPOS)|2.2 Maxterms ($M_i$) and Canonical POS (CPOS)]]
>	- [[Boolean Algebra and Minimization#2.3 Relationship Between Minterms and Maxterms|2.3 Relationship Between Minterms and Maxterms]]
>- [[Boolean Algebra and Minimization#3. Karnaugh Maps (K-Maps)|3. Karnaugh Maps (K-Maps)]]
>	- [[Boolean Algebra and Minimization#3.1 K-Map Grid & Gray Code Ordering|3.1 K-Map Grid & Gray Code Ordering]]
>	- [[Boolean Algebra and Minimization#3.2 Implicants, Prime Implicants (PI), and Essential Prime Implicants (EPI)|3.2 Implicants, Prime Implicants (PI), and Essential Prime Implicants (EPI)]]
>	- [[Boolean Algebra and Minimization#3.3 Minimization Procedure (SOP vs POS)|3.3 Minimization Procedure (SOP vs POS)]]
>	- [[Boolean Algebra and Minimization#3.4 Don't Care Conditions ($\text{d}$ or $\text{X}$)|3.4 Don't Care Conditions ($\text{d}$ or $\text{X}$)]]
>- [[Boolean Algebra and Minimization#4. GATE PYQ-Style Solved Questions|4. GATE PYQ-Style Solved Questions]]

Digital logic circuits manipulate binary values ($0$ and $1$) using mathematical structures formulated by George Boole. **Boolean algebra** provides the theoretical framework for simplifying complex logic expressions, reducing the physical gate count, power dissipation, and propagation delay of switching circuits.

In this note, we cover fundamental Boolean laws, minimization theorems (such as the Consensus Theorem and Shannon's Expansion), canonical Sum-of-Products (SOP) and Product-of-Sums (POS) representations, and systematic graphical minimization using Karnaugh Maps (K-Maps).

---

# 1. Fundamental Laws & Theorems of Boolean Algebra

Boolean algebra operates over the set $B = \{0, 1\}$ under two binary operations: **OR** ($+$) and **AND** ($\cdot$), alongside a unary operation **NOT** ($\overline{X}$ or $X'$).

---

## 1.1 Standard Axioms and Basic Postulates

| Law / Property | OR Operation ($+$) | AND Operation ($\cdot$) |
| :--- | :--- | :--- |
| **Identity Law** | $A + 0 = A$ | $A \cdot 1 = A$ |
| **Null (Dominance) Law** | $A + 1 = 1$ | $A \cdot 0 = 0$ |
| **Idempotent Law** | $A + A = A$ | $A \cdot A = A$ |
| **Complementarity Law** | $A + \bar{A} = 1$ | $A \cdot \bar{A} = 0$ |
| **Involution Law** | $\overline{(\bar{A})} = A$ | $\overline{(\bar{A})} = A$ |
| **Commutative Law** | $A + B = B + A$ | $A \cdot B = B \cdot A$ |
| **Associative Law** | $(A + B) + C = A + (B + C)$ | $(A \cdot B) \cdot C = A \cdot (B \cdot C)$ |
| **Distributive Law** | $A + (B \cdot C) = (A + B)(A + C)$ | $A \cdot (B + C) = AB + AC$ |
| **De Morgan's Laws** | $\overline{A + B} = \bar{A} \cdot \bar{B}$ | $\overline{A \cdot B} = \bar{A} + \bar{B}$ |

> [!IMPORTANT]
> The second distributive law $A + BC = (A+B)(A+C)$ is unique to Boolean algebra! Unlike conventional arithmetic, addition distributes over multiplication in Boolean logic.

---

## 1.2 Absorption & Elimination Laws

### Absorption Theorem 1
$$ \boxed{A + AB = A} \quad \text{and} \quad \boxed{A(A + B) = A} $$
$\underline{\text{Proof}}-$
$$ A + AB = A(1 + B) = A(1) = A $$

### Absorption (Elimination) Theorem 2
$$ \boxed{A + \bar{A}B = A + B} \quad \text{and} \quad \boxed{A(\bar{A} + B) = AB} $$
$\underline{\text{Proof}}-$
By Distributive Law:
$$ A + \bar{A}B = (A + \bar{A})(A + B) = 1 \cdot (A + B) = A + B $$

---

## 1.3 Consensus (Redundancy) Theorem

The **Consensus Theorem** is one of the most powerful simplification rules in GATE problems. It allows eliminating a redundant term from a 3-variable expression.

### SOP Form of Consensus Theorem
$$ \boxed{AB + \bar{A}C + BC = AB + \bar{A}C} $$

### Conditions for Consensus Reduction:
1. There must be **3 variables** ($A, B, C$).
2. One variable appears in both uncomplemented ($A$) and complemented ($\bar{A}$) forms across two terms.
3. The third term ($BC$) consists of the remaining literal factors of the first two terms. This third term is **redundant** and can be deleted!

$\underline{\text{Proof}}-$
$$
\begin{aligned}
LHS &= AB + \bar{A}C + BC \\
&= AB + \bar{A}C + BC(A + \bar{A}) \quad (\because A + \bar{A} = 1) \\
&= AB + \bar{A}C + ABC + \bar{A}BC \\
&= AB(1 + C) + \bar{A}C(1 + B) \\
&= AB(1) + \bar{A}C(1) \\
&= AB + \bar{A}C = RHS
\end{aligned}
$$

### POS Form of Consensus Theorem (Dual)
$$ \boxed{(A + B)(\bar{A} + C)(B + C) = (A + B)(\bar{A} + C)} $$

---

## 1.4 Transposition & Shannon's Expansion Theorems

### Transposition Theorem
$$ \boxed{AB + \bar{A}C = (A + C)(\bar{A} + B)} $$

### Shannon's Expansion Theorem
Any Boolean function $F(X_1, X_2, \dots, X_n)$ can be expanded with respect to any variable $X_1$:
$$ \boxed{F(X_1, X_2, \dots, X_n) = X_1 \cdot F(1, X_2, \dots, X_n) + \bar{X}_1 \cdot F(0, X_2, \dots, X_n)} $$
> [!NOTE]
> Shannon's expansion is the mathematical foundation for realizing any Boolean function using a **2-to-1 Multiplexer (MUX)**!

---

# 2. Canonical and Standard Forms

## 2.1 Minterms ($m_i$) and Canonical SOP (CSOP)

A **minterm** is a product (AND) of all variables in the function, where each variable appears exactly once in either its uncomplemented or complemented form.

For an $n$-variable function, there are $2^n$ distinct minterms.

- In minterm notation: Uncomplemented literal = $1$, Complemented literal = $0$.
- Example for 3 variables ($A, B, C$):
  - $A=1, B=0, C=1 \implies A\bar{B}C = m_5$ ($101_2 = 5_{10}$).

### Canonical Sum of Products (CSOP)
A Boolean expression is in **CSOP** form if it is expressed as a logical sum (OR) of distinct minterms for which the function output is $1$:
$$ F(A, B, C) = \sum m(1, 3, 5, 7) = \bar{A}\bar{B}C + \bar{A}BC + A\bar{B}C + ABC $$

---

## 2.2 Maxterms ($M_i$) and Canonical POS (CPOS)

A **maxterm** is a sum (OR) of all variables in the function, where each variable appears exactly once in either complemented or uncomplemented form.

- In maxterm notation: Uncomplemented literal = $0$, Complemented literal = $1$.
- Example for 3 variables ($A, B, C$):
  - $A=0, B=1, C=0 \implies A + \bar{B} + C = M_2$ ($010_2 = 2_{10}$).

### Canonical Product of Sums (CPOS)
A Boolean expression is in **CPOS** form if it is expressed as a logical product (AND) of distinct maxterms for which the function output is $0$:
$$ F(A, B, C) = \prod M(0, 2, 4, 6) = (A+B+C)(A+\bar{B}+C)(\bar{A}+B+C)(\bar{A}+\bar{B}+C) $$

---

## 2.3 Relationship Between Minterms and Maxterms

For any minterm $m_i$ and maxterm $M_i$ with identical index $i$:
$$ \boxed{M_i = \bar{m}_i} \quad \text{and} \quad \boxed{m_i = \bar{M}_i} $$

Furthermore, if a function is defined by its minterm set $S$, its complement $\bar{F}$ is defined by the remaining minterms, and its POS representation is the product of maxterms belonging to the complementary set:
$$ \boxed{F = \sum m(1, 3, 5, 7) \iff F = \prod M(0, 2, 4, 6)} $$

---

# 3. Karnaugh Maps (K-Maps)

A **Karnaugh Map (K-Map)** is a graphical tool used to minimize Boolean expressions without performing manual algebraic manipulations. It arranges minterms on a multidimensional grid where adjacent cells differ by **exactly 1 bit**.

---

## 3.1 K-Map Grid & Gray Code Ordering

To preserve single-bit adjacency between neighbouring cells, K-Map rows and columns are ordered using **Gray Code**:
$$ 00 \longrightarrow 01 \longrightarrow 11 \longrightarrow 10 $$

### 4-Variable K-Map Layout ($A, B, C, D$)

![[Pasted image 20260802173913.png|300]]

| $AB \backslash CD$ | **00** ($C'D'$) | **01** ($C'D$) | **11** ($CD$) | **10** ($CD'$) |
| :---: | :---: | :---: | :---: | :---: |
| **00** ($A'B'$) | $m_0$ | $m_1$ | $m_3$ | $m_2$ |
| **01** ($A'B$) | $m_4$ | $m_5$ | $m_7$ | $m_6$ |
| **11** ($AB$) | $m_{12}$ | $m_{13}$ | $m_{15}$ | $m_{14}$ |
| **10** ($AB'$) | $m_8$ | $m_9$ | $m_{11}$ | $m_{10}$ |

> [!WARNING]
> Note the non-binary sequence in the third row and column ($11$ comes before $10$)! This Gray code ordering ensures that top/bottom and left/right edges fold around and are adjacent.

---

## 3.2 Implicants, Prime Implicants (PI), and Essential Prime Implicants (EPI)

Understanding these definitions is critical for GATE questions on minimal expressions:

1. **Implicant**: Any individual minterm or group of adjacent $1\text{s}$ (of size $1, 2, 4, 8, \dots, 2^k$) in a K-Map.
2. **Prime Implicant (PI)**: A rectangular group of $1\text{s}$ (size $2^k$) that **cannot be subsumed** into a larger valid group. A PI corresponds to a product term with a minimal number of literals.
3. **Essential Prime Implicant (EPI)**: A Prime Implicant that contains **at least one minterm ($1$)** that is not covered by *any other* Prime Implicant.
   - **Rule**: Every EPI *must* be included in the final minimal Boolean expression!
4. **Redundant Prime Implicant (RPI)**: A Prime Implicant whose constituent $1\text{s}$ are entirely covered by EPIs. An RPI is excluded from the minimal expression.

---

## 3.3 Minimization Procedure (SOP vs POS)

### Steps for Minimal SOP:
1. Plot $1\text{s}$ for minterms and $\text{X}$ for Don't Care conditions in the K-Map grid.
2. Form the largest possible groups of adjacent $1\text{s}$ (groups must be powers of 2: $1, 2, 4, 8, 16$).
3. Identify all **Essential Prime Implicants (EPIs)** and include them in the expression.
4. Cover any remaining $1\text{s}$ using the minimal set of additional PIs.

### Steps for Minimal POS:
1. Group $0\text{s}$ instead of $1\text{s}$ in the K-Map.
2. Write product of sums for each group (inverting variables: $0 \to \text{literal}$, $1 \to \overline{\text{literal}}$).

---

## 3.4 Don't Care Conditions ($\text{d}$ or $\text{X}$)

In many practical circuits (e.g., BCD to 7-segment decoders), certain input combinations never occur or their output does not affect system operation. These are **Don't Care conditions** ($\text{d}$ or $\text{X}$).

### Rules for Handling Don't Cares ($\text{X}$):
- You may treat an $\text{X}$ as a $1$ **if and only if** it helps create a larger group (reducing literals).
- You may treat an $\text{X}$ as a $0$ if it does not help enlarge any group.
- An $\text{X}$ **never forces** the creation of a new PI on its own (a group consisting purely of $\text{X}$ cells is invalid and ignored).

---

# 4. GATE PYQ-Style Solved Questions

^q1
<h6 class="question">Q1) Simplify the Boolean expression: F(A, B, C) = AB + \bar{A}C + BC</h6>

<u>Sol</u>$^n$ -
Recognize this directly as the **Consensus (Redundancy) Theorem**:
- Variables: $A, B, C$.
- Complemented variable: $A$ and $\bar{A}$.
- Terms: $AB$ contains $A$, $\bar{A}C$ contains $\bar{A}$.
- The consensus term formed by combining remaining variables is $BC$.

Applying Consensus Theorem:
$$ F(A, B, C) = AB + \bar{A}C + BC = AB + \bar{A}C $$

$$ \boxed{F = AB + \bar{A}C} $$

---

^q2
<h6 class="question">Q2) Determine the total number of Prime Implicants (PI) and Essential Prime Implicants (EPI) for the Boolean function: F(A, B, C, D) = \sum m(0, 2, 5, 7, 8, 10, 13, 15)</h6>

<u>Sol</u>$^n$ -
Let's plot minterms on the 4-variable K-Map:
- Minterms $m_0(0000), m_2(0010), m_8(1000), m_{10}(1010)$ occupy the 4 corners of the K-Map!
  - Grouping all 4 corner cells forms a quad: $\boxed{\bar{B}\bar{D}}$.
  - Minterms $0, 2, 8, 10$ are uniquely covered by this corner quad. Hence, $\bar{B}\bar{D}$ is an **EPI**.

- Minterms $m_5(0101), m_7(0111), m_{13}(1101), m_{15}(1111)$ occupy columns 01 and 11 in rows 01 and 11.
  - Grouping these 4 cells forms a quad: $\boxed{BD}$.
  - Minterms $5, 7, 13, 15$ are uniquely covered by this quad. Hence, $BD$ is an **EPI**.

Summary:
- Total Prime Implicants (PI) = 2 ($\bar{B}\bar{D}$ and $BD$).
- Both PIs are Essential Prime Implicants (EPI) = 2.
- Minimal Expression: $F = \bar{B}\bar{D} + BD = B \odot D$.

$$ \boxed{\text{PI} = 2, \text{EPI} = 2, F = B \odot D} $$
