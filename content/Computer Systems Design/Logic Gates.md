>[!SUMMARY] Table of Contents
>- [[Logic Gates#Overview|Overview]]
>- [[Logic Gates#1. Basic Logic Gates|1. Basic Logic Gates]]
>	- [[Logic Gates#1.1 NOT Gate (Inverter)|1.1 NOT Gate (Inverter)]]
>	- [[Logic Gates#1.2 AND Gate|1.2 AND Gate]]
>	- [[Logic Gates#1.3 OR Gate|1.3 OR Gate]]
>- [[Logic Gates#2. Universal Logic Gates|2. Universal Logic Gates]]
>	- [[Logic Gates#2.1 NAND Gate|2.1 NAND Gate]]
>	- [[Logic Gates#2.2 NOR Gate|2.2 NOR Gate]]
>- [[Logic Gates#3. Exclusive Logic Gates|3. Exclusive Logic Gates]]
>	- [[Logic Gates#3.1 XOR Gate (Exclusive-OR)|3.1 XOR Gate (Exclusive-OR)]]
>	- [[Logic Gates#3.2 XNOR Gate (Exclusive-NOR / Equivalence)|3.2 XNOR Gate (Exclusive-NOR / Equivalence)]]
>- [[Logic Gates#4. Functional Completeness & Universality|4. Functional Completeness & Universality]]
>	- [[Logic Gates#4.1 Gate Minimization Matrix|4.1 Gate Minimization Matrix]]
>	- [[Logic Gates#4.2 Implementing Basic Operations using NAND & NOR|4.2 Implementing Basic Operations using NAND & NOR]]
>- [[Logic Gates#5. Key Algebraic Properties & Parity Rules|5. Key Algebraic Properties & Parity Rules]]
>- [[Logic Gates#6. GATE PYQ-Style Solved Questions|6. GATE PYQ-Style Solved Questions]]

At the hardware level, digital computers operate entirely on binary signals represented by discretized voltage levels (typically $0\text{V}$ for logic **0** and $+5\text{V}$ or $+3.3\text{V}$ for logic **1**). **Logic gates** are the fundamental building blocks of digital electronic circuits. They execute primitive Boolean functions by converting one or more binary inputs into a single deterministic binary output. 

In this note, we examine the operation, Boolean expressions, truth tables, algebraic properties, and functional completeness of all standard logic gates tested in GATE CS & DA.

---

# 1. Basic Logic Gates

Basic logic gates perform the foundational operations of Boolean algebra: inversion (NOT), logical multiplication (AND), and logical addition (OR).

---

## 1.1 NOT Gate (Inverter)

The **NOT gate** (or **inverter**) is a single-input, single-output gate that outputs the logical complement of its input.

### Boolean Expression
$$ \boxed{Y = \bar{A} = A'} $$

### Logic Symbol
![Placeholder: NOT Gate Symbol](imgs/not-gate-symbol.png)
> **Student Image Note**: Place an image named `not-gate-symbol.png` in the `imgs/` directory.
> *Search description*: "Standard IEEE logic gate symbol for NOT gate inverter with input label A, triangular body, inversion bubble, and output label Y".

### Truth Table
| Input ($A$) | Output ($Y = \bar{A}$) |
| :---: | :---: |
| 0 | 1 |
| 1 | 0 |

### Key Intuition & Properties
- **Involution Law**: Complements cancel out. $\overline{(\bar{A})} = A$.
- **Switching Concept**: Think of a single switch connected in parallel across a load. When switch $A$ is closed ($1$), current bypasses the load ($Y = 0$).

---

## 1.2 AND Gate

The **AND gate** outputs logic $1$ **if and only if** all of its inputs are logic $1$.

### Boolean Expression
$$ \boxed{Y = A \cdot B = AB} $$

### Logic Symbol
![Placeholder: AND Gate Symbol](imgs/and-gate-symbol.png)
> **Student Image Note**: Place an image named `and-gate-symbol.png` in the `imgs/` directory.
> *Search description*: "Standard IEEE 2-input AND gate logic symbol with inputs A and B and output Y".

### Truth Table
| Input $A$ | Input $B$ | Output ($Y = A \cdot B$) |
| :---: | :---: | :---: |
| 0 | 0 | 0 |
| 0 | 1 | 0 |
| 1 | 0 | 0 |
| 1 | 1 | 1 |

### Key Intuition & Properties
- **Series Switch Analogy**: Two switches $A$ and $B$ connected in series. Current reaches the lamp only when *both* switches are closed.
- **Dominance (Null) Element**: Any input held at $0$ forces the output to $0$. $A \cdot 0 = 0$.
- **Identity Element**: Holding an input at $1$ passes the other input unchanged. $A \cdot 1 = A$ (acts as a buffer/enable pin).

---

## 1.3 OR Gate

The **OR gate** outputs logic $1$ if **at least one** of its inputs is logic $1$.

### Boolean Expression
$$ \boxed{Y = A + B} $$

### Logic Symbol
![Placeholder: OR Gate Symbol](imgs/or-gate-symbol.png)
> **Student Image Note**: Place an image named `or-gate-symbol.png` in the `imgs/` directory.
> *Search description*: "Standard IEEE 2-input OR gate logic symbol with curved input boundary, inputs A and B, and output Y".

### Truth Table
| Input $A$ | Input $B$ | Output ($Y = A + B$) |
| :---: | :---: | :---: |
| 0 | 0 | 0 |
| 0 | 1 | 1 |
| 1 | 0 | 1 |
| 1 | 1 | 1 |

### Key Intuition & Properties
- **Parallel Switch Analogy**: Two switches connected in parallel. Current flows if *either* switch $A$ or switch $B$ is closed.
- **Dominance (Null) Element**: Any input held at $1$ forces the output to $1$. $A + 1 = 1$.
- **Identity Element**: Holding an input at $0$ passes the other input unchanged. $A + 0 = A$.

---

# 2. Universal Logic Gates

A logic gate family is called **universal** if any arbitrary Boolean function can be implemented using *only* instances of that single gate type, without needing any other gate (not even NOT gates). Both **NAND** and **NOR** are universal gates.

---

## 2.1 NAND Gate

The **NAND gate** (NOT-AND) produces an output that is the inverse of an AND gate. Its output is logic $0$ if and only if all inputs are $1$.

### Boolean Expression
$$ \boxed{Y = \overline{A \cdot B} = \bar{A} + \bar{B}} \quad \text{(by De Morgan's Law)} $$

### Logic Symbol
![Placeholder: NAND Gate Symbol](imgs/nand-gate-symbol.png)
> **Student Image Note**: Place an image named `nand-gate-symbol.png` in the `imgs/` directory.
> *Search description*: "Standard IEEE 2-input NAND gate logic symbol with AND gate body, output inversion bubble, inputs A and B, and output Y".

### Truth Table
| Input $A$ | Input $B$ | Output ($Y = \overline{AB}$) |
| :---: | :---: | :---: |
| 0 | 0 | 1 |
| 0 | 1 | 1 |
| 1 | 0 | 1 |
| 1 | 1 | 0 |

### Key Intuition & **Properties**
- **Inverted AND**: $Y = 1$ whenever any input is $0$.
- **Commutative**: $A \uparrow B = B \uparrow A$.
- **NOT Associative**: $(A \uparrow B) \uparrow C \neq A \uparrow (B \uparrow C)$ in general.
  - *Proof*: Let $A=0, B=0, C=0$.
    - LHS: $(0 \uparrow 0) \uparrow 0 = 1 \uparrow 0 = 1$.
    - RHS: $0 \uparrow (0 \uparrow 0) = 0 \uparrow 1 = 1$.
    - Now let $A=1, B=1, C=0$.
    - LHS: $(1 \uparrow 1) \uparrow 0 = 0 \uparrow 0 = 1$.
    - RHS: $1 \uparrow (1 \uparrow 0) = 1 \uparrow 1 = 0$.
    - Since LHS $\neq$ RHS, NAND is **not associative**.

---

## 2.2 NOR Gate

The **NOR gate** (NOT-OR) produces an output that is the inverse of an OR gate. Its output is logic $1$ if and only if all inputs are $0$.

### Boolean Expression
$$ \boxed{Y = \overline{A + B} = \bar{A} \cdot \bar{B}} \quad \text{(by De Morgan's Law)} $$

### Logic Symbol
![Placeholder: NOR Gate Symbol](imgs/nor-gate-symbol.png)
> **Student Image Note**: Place an image named `nor-gate-symbol.png` in the `imgs/` directory.
> *Search description*: "Standard IEEE 2-input NOR gate logic symbol with curved OR gate body, output inversion bubble, inputs A and B, and output Y".

### Truth Table
| Input $A$ | Input $B$ | Output ($Y = \overline{A+B}$) |
| :---: | :---: | :---: |
| 0 | 0 | 1 |
| 0 | 1 | 0 |
| 1 | 0 | 0 |
| 1 | 1 | 0 |

### Key Intuition & Properties
- **Inverted OR**: $Y = 0$ whenever any input is $1$.
- **Commutative**: $A \downarrow B = B \downarrow A$.
- **NOT Associative**: $(A \downarrow B) \downarrow C \neq A \downarrow (B \downarrow C)$ in general.

---

# 3. Exclusive Logic Gates

Exclusive gates are used extensively in arithmetic circuits (adders, subtractors), parity generators/checkers, and digital comparators.

---

## 3.1 XOR Gate (Exclusive-OR)

The **XOR gate** outputs logic $1$ if the inputs are **different** (for 2 inputs), or if an **odd number of inputs are 1** (for $n$ inputs).

### Boolean Expression
$$ \boxed{Y = A \oplus B = A\bar{B} + \bar{A}B = (A + B)(\bar{A} + \bar{B})} $$

### Logic Symbol
![Placeholder: XOR Gate Symbol](imgs/xor-gate-symbol.png)
> **Student Image Note**: Place an image named `xor-gate-symbol.png` in the `imgs/` directory.
> *Search description*: "Standard IEEE 2-input XOR gate logic symbol with double curved input line, inputs A and B, and output Y".

### Truth Table
| Input $A$ | Input $B$ | Output ($Y = A \oplus B$) |
| :---: | :---: | :---: |
| 0 | 0 | 0 |
| 0 | 1 | 1 |
| 1 | 0 | 1 |
| 1 | 1 | 0 |

### Crucial XOR Identities (High-Frequency GATE Formulas)
1. **Self-Complement / Nilpotence**: $A \oplus A = 0$
2. **Complementarity**: $A \oplus \bar{A} = 1$
3. **Identity Element**: $A \oplus 0 = A$ (Acts as a **Buffer**)
4. **Inversion Element**: $A \oplus 1 = \bar{A}$ (Acts as a **Controlled Inverter**)
5. **Commutative**: $A \oplus B = B \oplus A$
6. **Associative**: $(A \oplus B) \oplus C = A \oplus (B \oplus C)$
7. **Inversion Rules**:
   - $\bar{A} \oplus B = A \oplus \bar{B} = \overline{A \oplus B} = A \odot B$
   - $\bar{A} \oplus \bar{B} = A \oplus B$

---

## 3.2 XNOR Gate (Exclusive-NOR / Equivalence)

The **XNOR gate** (also called **Coincidence Gate** or **Equivalence Gate**) outputs logic $1$ if the inputs are **identical** (for 2 inputs).

### Boolean Expression
$$ \boxed{Y = A \odot B = AB + \bar{A}\bar{B}} $$

### Logic Symbol
![Placeholder: XNOR Gate Symbol](imgs/xnor-gate-symbol.png)
> **Student Image Note**: Place an image named `xnor-gate-symbol.png` in the `imgs/` directory.
> *Search description*: "Standard IEEE 2-input XNOR gate logic symbol with double curved input line, output bubble, inputs A and B, and output Y".

### Truth Table
| Input $A$ | Input $B$ | Output ($Y = A \odot B$) |
| :---: | :---: | :---: |
| 0 | 0 | 1 |
| 0 | 1 | 0 |
| 1 | 0 | 0 |
| 1 | 1 | 1 |

### Crucial XNOR Identities
1. $A \odot A = 1$
2. $A \odot \bar{A} = 0$
3. $A \odot 0 = \bar{A}$
4. $A \odot 1 = A$
5. $\bar{A} \odot \bar{B} = A \odot B$

---

# 4. Functional Completeness & Universality

## 4.1 Gate Minimization Matrix

A frequent GATE question asks for the **minimum number of 2-input NAND or NOR gates** needed to realize basic or exclusive logic gates.

| Target Gate | Minimum NAND Gates Required | Minimum NOR Gates Required |
| :---: | :---: | :---: |
| **NOT** | **1** | **1** |
| **AND** | **2** | **3** |
| **OR** | **3** | **2** |
| **XOR** | **4** | **5** |
| **XNOR** | **5** | **4** |

> [!TIP]
> Notice the elegant duality pattern! The count for (AND, OR) and (XOR, XNOR) flips cleanly when switching between NAND and NOR realizations. Memory mnemonic: **1-2-3-4-5** for NAND (NOT, AND, OR, XOR, XNOR) and **1-3-2-5-4** for NOR!

---

## 4.2 Implementing Basic Operations using NAND & NOR

### 1. Realizing NOT using NAND / NOR
- NAND: $Y = \overline{A \cdot A} = \bar{A}$ (Tie both inputs together)
- NOR: $Y = \overline{A + A} = \bar{A}$

### 2. Realizing AND using NAND
- Stage 1: $N_1 = \overline{AB}$
- Stage 2: Invert $N_1$ using a 1-input NAND $\implies Y = \overline{\overline{AB}} = AB$. (Requires **2** NAND gates)

### 3. Realizing OR using NAND
- By De Morgan: $A + B = \overline{\bar{A} \cdot \bar{B}}$.
- Generate $\bar{A}$ (1 NAND) and $\bar{B}$ (1 NAND).
- Feed into 3rd NAND: $\overline{\bar{A} \cdot \bar{B}} = A + B$. (Requires **3** NAND gates)

### 4. Realizing XOR using NAND (Minimal 4 NAND Gates)
$$
\begin{aligned}
N_1 &= \overline{AB} \\
N_2 &= \overline{A \cdot N_1} = \overline{A \overline{AB}} = \bar{A} + AB = \bar{A} + B \\
N_3 &= \overline{B \cdot N_1} = \overline{B \overline{AB}} = \bar{B} + AB = A + \bar{B} \\
Y &= \overline{N_2 \cdot N_3} = \overline{(\bar{A} + B)(A + \bar{B})} = \overline{\bar{A}\bar{B} + AB} = A\bar{B} + \bar{A}B = A \oplus B
\end{aligned}
$$
$$\boxed{\text{Minimum NAND gates for XOR} = 4}$$

---

# 5. Key Algebraic Properties & Parity Rules

## 5.1 Summary of Algebraic Laws

| Property | AND | OR | XOR | XNOR |
| :--- | :--- | :--- | :--- | :--- |
| **Commutative** | $AB = BA$ | $A+B = B+A$ | $A\oplus B = B\oplus A$ | $A\odot B = B\odot A$ |
| **Associative** | $(AB)C = A(BC)$ | $(A+B)+C = A+(B+C)$ | $(A\oplus B)\oplus C = A\oplus (B\oplus C)$ | $(A\odot B)\odot C = A\odot (B\odot C)$ |
| **Idempotent** | $AA = A$ | $A+A = A$ | $A\oplus A = 0$ | $A\odot A = 1$ |
| **Complement** | $A\bar{A} = 0$ | $A+\bar{A} = 1$ | $A\oplus \bar{A} = 1$ | $A\odot \bar{A} = 0$ |

> [!WARNING]
> Neither **NAND** nor **NOR** is associative! $(A \uparrow B) \uparrow C \neq A \uparrow (B \uparrow C)$.

---

## 5.2 Multi-Input XOR vs XNOR Parity Laws (GATE Trap!)

For $n$ inputs $X_1, X_2, \dots, X_n$:

1. **XOR ($n$-inputs)**: Act as an **Odd Parity Detector**.
   $$ Y = X_1 \oplus X_2 \oplus \dots \oplus X_n = 1 \iff \text{Odd number of 1s in inputs} $$

2. **Relationship between Multi-Input XOR and XNOR**:
   - For an **ODD** number of inputs ($n$ is odd):
     $$ \boxed{X_1 \oplus X_2 \oplus \dots \oplus X_n = X_1 \odot X_2 \odot \dots \odot X_n} $$
   - For an **EVEN** number of inputs ($n$ is even):
     $$ \boxed{\overline{X_1 \oplus X_2 \oplus \dots \oplus X_n} = X_1 \odot X_2 \odot \dots \odot X_n} $$

---

# 6. GATE PYQ-Style Solved Questions

^q1
<h6 class="question">Q1) Find the minimum number of 2-input NAND gates required to implement the Boolean function F = A\bar{B} + C.</h6>

<u>Sol</u>$^n$ -
Let's express $F$ using double negation and De Morgan's laws to put it into pure NAND form (AND-OR to NAND-NAND):

$$
\begin{aligned}
F &= A\bar{B} + C \\
&= \overline{\overline{A\bar{B} + C}} \\
&= \overline{\overline{(A\bar{B})} \cdot \bar{C}}
\end{aligned}
$$

Now let's trace the gate count step by step:
1. Generate $\bar{B}$ from $B$ using a 1-input NAND gate $\rightarrow$ **1 NAND gate**.
2. Compute $N_1 = \overline{A\bar{B}}$ using a 2-input NAND gate with inputs $A$ and $\bar{B}$ $\rightarrow$ **1 NAND gate**.
3. Generate $\bar{C}$ from $C$ using a 1-input NAND gate $\rightarrow$ **1 NAND gate**.
4. Compute final output $F = \overline{N_1 \cdot \bar{C}}$ using a 2-input NAND gate $\rightarrow$ **1 NAND gate**.

Total NAND gates required = $1 + 1 + 1 + 1 = 4$.

$$ \boxed{\text{Minimum NAND Gates} = 4} $$

---

^q2
<h6 class="question">Q2) Evaluate the output of a cascading XOR network with 100 inputs where all inputs are set to 1: Y = 1 \oplus 1 \oplus 1 \dots \oplus 1 (100 times).</h6>

<u>Sol</u>$^n$ -
Recall the identity property of XOR:
$$ A \oplus A = 0 $$
Pairing inputs in groups of two:
$$ (1 \oplus 1) \oplus (1 \oplus 1) \dots \oplus (1 \oplus 1) = 0 \oplus 0 \dots \oplus 0 = 0 $$

Alternatively, using the Parity Rule:
- The input string has 100 ones.
- 100 is an **even** number.
- Since XOR is an **odd parity detector**, the output for an even number of 1s is $0$.

$$ \boxed{Y = 0} $$

---

^q3
<h6 class="question">Q3) Which of the following statements is/are TRUE regarding Logic Gates?
(A) NAND gate is associative.
(B) XOR gate can be used as a controlled inverter.
(C) For 3 variables A, B, C: (A \oplus B \oplus C) = (A \odot B \odot C).
(D) Minimum 4 NOR gates are required to implement an XOR gate.</h6>

<u>Sol</u>$^n$ -
Let's analyze each option:
- **(A) FALSE**: As proved in Section 2.1, NAND is NOT associative.
- **(B) TRUE**: $A \oplus 1 = \bar{A}$ and $A \oplus 0 = A$. Setting one input to control signal $C$ inverts or passes $A$.
- **(C) TRUE**: For $n=3$ (odd number of inputs), $A \oplus B \oplus C = A \odot B \odot C$.
- **(D) FALSE**: Minimum **5** NOR gates are required to implement an XOR gate (whereas 4 NAND gates are required).

Correct Statements: **(B) and (C)**.

$$ \boxed{\text{Correct Options: (B), (C)}} $$
