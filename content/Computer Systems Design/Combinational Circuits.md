>[!SUMMARY] Table of Contents
>- [[Combinational Circuits#Overview|Overview]]
>- [[Combinational Circuits#1. Arithmetic Building Blocks (Adders & Subtractors)|1. Arithmetic Building Blocks (Adders & Subtractors)]]
>	- [[Combinational Circuits#1.1 Half Adder (HA) and Full Adder (FA)|1.1 Half Adder (HA) and Full Adder (FA)]]
>	- [[Combinational Circuits#1.2 Half Subtractor (HS) and Full Subtractor (FS)|1.2 Half Subtractor (HS) and Full Subtractor (FS)]]
>	- [[Combinational Circuits#1.3 Propagation Delay Analysis: Ripple Carry Adder vs. Carry Lookahead Adder|1.3 Propagation Delay Analysis: Ripple Carry Adder vs. Carry Lookahead Adder]]
>- [[Combinational Circuits#2. Multiplexers (MUX - Data Selectors)|2. Multiplexers (MUX - Data Selectors)]]
>	- [[Combinational Circuits#2.1 Internal Logic & Expressions|2.1 Internal Logic & Expressions]]
>	- [[Combinational Circuits#2.2 Universal Function Implementation using MUX|2.2 Universal Function Implementation using MUX]]
>	- [[Combinational Circuits#2.3 Implementing Basic Gates using 2:1 MUX|2.3 Implementing Basic Gates using 2:1 MUX]]
>- [[Combinational Circuits#3. Decoders & Demultiplexers (DEMUX)|3. Decoders & Demultiplexers (DEMUX)]]
>	- [[Combinational Circuits#3.1 Decoders ($N \to 2^N$)|3.1 Decoders ($N \to 2^N$)]]
>	- [[Combinational Circuits#3.2 Function Realization using Decoders|3.2 Function Realization using Decoders]]
>	- [[Combinational Circuits#3.3 Demultiplexers ($1 \to 2^N$)|3.3 Demultiplexers ($1 \to 2^N$)]]
>- [[Combinational Circuits#4. Encoders & Priority Encoders|4. Encoders & Priority Encoders]]
>	- [[Combinational Circuits#4.1 Binary Encoder ($2^N \to N$)|4.1 Binary Encoder ($2^N \to N$)]]
>	- [[Combinational Circuits#4.2 Priority Encoder|4.2 Priority Encoder]]
>- [[Combinational Circuits#5. Magnitude Comparators|5. Magnitude Comparators]]
>- [[Combinational Circuits#6. Modular Expansion & Cascading Formulas (Building $Y$ from $X$)|6. Modular Expansion & Cascading Formulas (Building $Y$ from $X$)]]
>	- [[Combinational Circuits#6.1 MUX Tree Expansion Formula|6.1 MUX Tree Expansion Formula]]
>	- [[Combinational Circuits#6.2 Decoder Tree Expansion Formula|6.2 Decoder Tree Expansion Formula]]
>	- [[Combinational Circuits#6.3 Master Gate-Count & Module Reference Matrix|6.3 Master Gate-Count & Module Reference Matrix]]
>- [[Combinational Circuits#7. GATE PYQ-Style Solved Questions|7. GATE PYQ-Style Solved Questions]]

A **combinational logic circuit** is a digital circuit whose outputs at any instant of time depend **solely on the present combination of inputs**, without relying on past inputs or stored memory states. Mathematically, for an input vector $X = (x_1, x_2, \dots, x_n)$, the output vector is given by $Y = f(X)$.

In this note, we cover the design, gate-level implementation, universal functional completeness, and modular cascading formulas for all major combinational building blocks tested in GATE CS & DA.

---

# 1. Arithmetic Building Blocks (Adders & Subtractors)

---

## 1.1 Half Adder (HA) and Full Adder (FA)

### 1. Half Adder (HA)
A **Half Adder** adds two 1-bit inputs $A$ and $B$, producing a **Sum ($S$)** and a **Carry ($C$)**.

- **Boolean Expressions**:
  $$ \boxed{S = A \oplus B = A\bar{B} + \bar{A}B} $$
  $$ \boxed{C = A \cdot B} $$
- **Gate Realization**: 1 XOR gate + 1 AND gate.
- **NAND/NOR Count**: Requires **5** NAND gates or **5** NOR gates.

---

### 2. Full Adder (FA)
A **Full Adder** adds three 1-bit inputs: $A$, $B$, and an input carry $C_{in}$.

- **Boolean Expressions**:
  $$ \boxed{S = A \oplus B \oplus C_{in}} $$
  $$ \boxed{C_{out} = AB + BC_{in} + AC_{in} = AB + C_{in}(A \oplus B)} $$

- **Building a Full Adder from Half Adders**:
  A Full Adder can be constructed using **2 Half Adders + 1 OR gate**.

![Placeholder: Full Adder Circuit from Half Adders](imgs/full-adder-circuit.png)
> **Student Image Note**: Place an image named `full-adder-circuit.png` in the `imgs/` directory.
> *Search description*: "Full adder logic diagram constructed using two half adders and one OR gate showing inputs A B Cin and outputs Sum and Carry out".

- **NAND/NOR Count**: 1 Full Adder requires **9** NAND gates or **9** NOR gates.

---

## 1.2 Half Subtractor (HS) and Full Subtractor (FS)

### 1. Half Subtractor (HS)
Subtracts 1-bit $B$ from $A$ ($A - B$), producing **Difference ($D$)** and **Borrow ($B_{out}$)**.

- **Boolean Expressions**:
  $$ \boxed{D = A \oplus B} $$
  $$ \boxed{B_{out} = \bar{A}B} $$

---

### 2. Full Subtractor (FS)
Subtracts $B$ and input borrow $B_{in}$ from $A$ ($A - B - B_{in}$).

- **Boolean Expressions**:
  $$ \boxed{D = A \oplus B \oplus B_{in}} $$
  $$ \boxed{B_{out} = \bar{A}B + B_{in}(\overline{A \oplus B})} $$
- **Building a Full Subtractor**: Constructed using **2 Half Subtractors + 1 OR gate**.

---

## 1.3 Propagation Delay Analysis: Ripple Carry Adder vs. Carry Lookahead Adder

When cascading $n$ 1-bit Full Adders to form an $n$-bit parallel adder:

### 1. Ripple Carry Adder (RCA)
Carries ripple sequentially from LSB to MSB stage by stage.
- **Worst-case Propagation Delay**:
  $$ \boxed{t_{\text{RCA}} = n \cdot t_{\text{carry}} + t_{\text{sum}}} = O(n) $$
  Where $t_{\text{carry}}$ is the delay of a single FA carry generation stage.

---

### 2. Carry Lookahead Adder (CLA)
To eliminate sequential carry propagation delay, CLA generates all carry signals simultaneously in parallel using two auxiliary terms:
- **Carry Generate ($G_i$)**: $G_i = A_i B_i$ (generates carry regardless of input carry).
- **Carry Propagate ($P_i$)**: $P_i = A_i \oplus B_i$ (propagates input carry $C_i$).

Carry equations:
$$ C_1 = G_0 + P_0 C_0 $$
$$ C_2 = G_1 + P_1 G_0 + P_1 P_0 C_0 $$
$$ C_3 = G_2 + P_2 G_1 + P_2 P_1 G_0 + P_2 P_1 P_0 C_0 $$

- **Propagation Delay**: All carries $C_1, C_2, \dots, C_n$ are generated in **2 gate delays** ($2 t_g$) regardless of word length $n$!
- **Trade-off**: Requires $O(n^2)$ hardware complexity / gate fan-in as $n$ grows.

---

# 2. Multiplexers (MUX - Data Selectors)

A **Multiplexer (MUX)** is a combinational circuit that routes one of several data inputs ($2^n$) to a single output line based on $n$ select lines.

---

## 2.1 Internal Logic & Expressions

### 2:1 Multiplexer
- **Inputs**: $I_0, I_1$; **Select**: $S_0$.
- **Boolean Expression**:
  $$ \boxed{Y = \bar{S}_0 I_0 + S_0 I_1} $$

![Placeholder: 2 to 1 MUX Circuit Diagram](imgs/mux-2to1-circuit.png)
> **Student Image Note**: Place an image named `mux-2to1-circuit.png` in the `imgs/` directory.
> *Search description*: "2 to 1 Multiplexer logic circuit diagram with select line S0 inputs I0 I1 and output Y".

### 4:1 Multiplexer
- **Inputs**: $I_0, I_1, I_2, I_3$; **Selects**: $S_1, S_0$.
- **Boolean Expression**:
  $$ \boxed{Y = \bar{S}_1 \bar{S}_0 I_0 + \bar{S}_1 S_0 I_1 + S_1 \bar{S}_0 I_2 + S_1 S_0 I_3} $$

---

## 2.2 Universal Function Implementation using MUX

A Multiplexer is a **universal logic element**. Any arbitrary $N$-variable Boolean function $F(X_1, X_2, \dots, X_N)$ can be implemented using a MUX without any external logic gates!

### Method 1: Using $2^{N-1} : 1$ MUX (Standard Efficient Method)
1. Connect $N-1$ variables to the **Select Lines** ($S_{N-2} \dots S_0$).
2. The remaining $1$ variable ($V$) is connected to the MUX **Data Inputs** ($I_k$) in one of 4 possible forms: **$0, 1, V$, or $\bar{V}$**.

> [!TIP]
> **GATE Shortcut Method**:
> Build a implementation table with 2 rows ($V=0$ in row 1, $V=1$ in row 2) and $2^{N-1}$ columns corresponding to minterms:
> - If neither minterm in a column is in $F \implies I_k = 0$.
> - If both minterms in a column are in $F \implies I_k = 1$.
> - If only top row minterm ($V=0$) is in $F \implies I_k = \bar{V}$.
> - If only bottom row minterm ($V=1$) is in $F \implies I_k = V$.

---

## 2.3 Implementing Basic Gates using 2:1 MUX

A single 2:1 MUX ($Y = \bar{S}_0 I_0 + S_0 I_1$) can realize basic gates by configuring inputs:

| Target Gate | Expression | Select Line ($S_0$) | Input $I_0$ | Input $I_1$ | 2:1 MUX Count |
| :---: | :---: | :---: | :---: | :---: | :---: |
| **NOT** | $\bar{A}$ | $A$ | $1$ | $0$ | **1** |
| **AND** | $AB$ | $A$ | $0$ | $B$ | **1** |
| **OR** | $A+B$ | $A$ | $B$ | $1$ | **1** |
| **NAND** | $\overline{AB}$ | $A$ | $1$ | $\bar{B}$ | **2** |
| **NOR** | $\overline{A+B}$ | $A$ | $\bar{B}$ | $0$ | **2** |
| **XOR** | $A \oplus B$ | $A$ | $B$ | $\bar{B}$ | **2** |
| **XNOR** | $A \odot B$ | $A$ | $\bar{B}$ | $B$ | **2** |

---

# 3. Decoders & Demultiplexers (DEMUX)

## 3.1 Decoders ($N \to 2^N$)

A **Decoder** converts an $N$-bit binary code into at most $2^N$ unique output lines. Exactly **one** output line is active ($1$ for active-high, $0$ for active-low) for any given input combination.

### 2-to-4 Active-High Decoder with Enable ($E$)
- **Outputs**: $Y_0 = E \bar{A} \bar{B}, \ Y_1 = E \bar{A} B, \ Y_2 = E A \bar{B}, \ Y_3 = E A B$.

---

## 3.2 Function Realization using Decoders

Since an $N \to 2^N$ decoder generates all $2^N$ minterms of $N$ variables:
1. **Active-High Decoder**: Connect desired minterm outputs to an **OR gate** $\implies F = \sum m(\dots)$.
2. **Active-Low Decoder**: Connect desired minterm outputs to a **NAND gate** $\implies F = \sum m(\dots)$.

---

## 3.3 Demultiplexers ($1 \to 2^N$)

A **Demultiplexer (DEMUX)** takes $1$ input line $D_{in}$ and routes it to $1$ of $2^N$ output lines based on $N$ select lines.
- **Equivalence**: A Decoder with an Enable pin ($E$) behaves identically to a Demultiplexer where $E = D_{in}$!

---

# 4. Encoders & Priority Encoders

## 4.1 Binary Encoder ($2^N \to N$)

An **Encoder** performs the inverse operation of a decoder. It accepts $2^N$ input lines and outputs an $N$-bit binary code.
- **Limitation**: Standard encoders fail if more than one input line is active simultaneously, or if all inputs are zero.

---

## 4.2 Priority Encoder

A **Priority Encoder** resolves input conflicts by assigning strict priority to input lines (typically higher index = higher priority).

### 4-to-2 Priority Encoder Truth Table ($D_3$ highest priority, $D_0$ lowest)

| $D_3$ | $D_2$ | $D_1$ | $D_0$ | Output $Y_1$ | Output $Y_0$ | Valid Flag ($V$) |
| :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| 0 | 0 | 0 | 0 | X | X | **0** |
| 0 | 0 | 0 | 1 | 0 | 0 | **1** |
| 0 | 0 | 1 | X | 0 | 1 | **1** |
| 0 | 1 | X | X | 1 | 0 | **1** |
| 1 | X | X | X | 1 | 1 | **1** |

- **Boolean Expressions**:
  $$ \boxed{Y_1 = D_3 + D_2} $$
  $$ \boxed{Y_0 = D_3 + \bar{D}_2 D_1} $$
  $$ \boxed{V = D_3 + D_2 + D_1 + D_0} $$

---

# 5. Magnitude Comparators

A **Magnitude Comparator** compares two $n$-bit numbers $A = a_{n-1}\dots a_0$ and $B = b_{n-1}\dots b_0$ and outputs three binary signals: $A > B$, $A = B$, and $A < B$.

### 1-Bit Comparator
- **$A = B$**: $x_0 = A \odot B = AB + \bar{A}\bar{B}$
- **$A > B$**: $A\bar{B}$
- **$A < B$**: $\bar{A}B$

### 2-Bit Comparator ($A_1 A_0$ vs $B_1 B_0$)
- **Equality Condition ($A = B$)**:
  $$ \boxed{(A = B) = (A_1 \odot B_1) \cdot (A_0 \odot B_0)} $$
- **Greater Than ($A > B$)**:
  $$ \boxed{(A > B) = A_1 \bar{B}_1 + (A_1 \odot B_1) A_0 \bar{B}_0} $$

---

# 6. Modular Expansion & Cascading Formulas (Building $Y$ from $X$)

In GATE exams, questions frequently ask for the **minimum number of smaller modules ($X$) required to build a larger target module ($Y$)**. Use these exact formulas:

---

## 6.1 MUX Tree Expansion Formula

To build a **$2^n : 1$ MUX** using smaller **$2^m : 1$ MUXes** ($n > m$):

$$ \boxed{\text{Total } 2^m:1 \text{ MUXes Required} = \frac{2^n - 1}{2^m - 1}} $$

### Stage-by-Stage Calculation Algorithm:
1. Stage 1 MUX count $= \frac{2^n}{2^m}$.
2. Stage 2 MUX count $= \frac{\text{Stage 1 count}}{2^m}$.
3. Repeat division until the result is $1$.
4. **Sum the counts across all stages**.

#### Example 1: How many 2:1 MUXes ($m=1$) are needed to build a 64:1 MUX ($n=6$)?
$$ \text{Total MUXes} = \frac{2^6 - 1}{2^1 - 1} = \frac{64 - 1}{1} = 63 $$

#### Example 2: How many 4:1 MUXes ($m=2$) are needed to build a 64:1 MUX ($n=6$)?
$$ \text{Total MUXes} = \frac{2^6 - 1}{2^2 - 1} = \frac{63}{3} = 21 $$
- *Stage breakdown*: Stage 1 $= 64/4 = 16$; Stage 2 $= 16/4 = 4$; Stage 3 $= 4/4 = 1$. Total $= 16 + 4 + 1 = 21$.

---

## 6.2 Decoder Tree Expansion Formula

To build an **$n \to 2^n$ Decoder** using smaller **$m \to 2^m$ Decoders** with enable pins ($n > m$):

### For 2-Stage Expansion:
- **First Stage (Outputs)**: $2^{n-m}$ decoders of size $m \to 2^m$.
- **Second Stage (Enable Control)**: $1$ decoder of size $(n-m) \to 2^{n-m}$.
- **Total Decoders**:
  $$ \boxed{\text{Total } m \to 2^m \text{ Decoders} = 2^{n-m} + 1} \quad (\text{if } n-m = m) $$

#### Example: How many 2-to-4 decoders ($m=2$) are needed to build a 4-to-16 decoder ($n=4$)?
- First stage: $2^{4-2} = 4$ decoders (handling inputs $A_1 A_0$).
- Control stage: $1$ decoder (handling inputs $A_3 A_2$ to enable one of the 4 decoders).
- Total $= 4 + 1 = \mathbf{5}$ decoders.

---

## 6.3 Master Gate-Count & Module Reference Matrix

This matrix provides the **minimum gate count** to implement standard combinational circuits:

| Target Circuit | Min NAND Gates | Min NOR Gates | Min 2:1 MUXes | Minimal Building Block Equivalent |
| :--- | :---: | :---: | :---: | :--- |
| **Half Adder (HA)** | **5** | **5** | **2** | 1 XOR + 1 AND |
| **Full Adder (FA)** | **9** | **9** | **7** | **2 HA + 1 OR** |
| **Half Subtractor (HS)** | **5** | **5** | **2** | 1 XOR + 1 AND ($\bar{A}B$) |
| **Full Subtractor (FS)** | **9** | **9** | **7** | **2 HS + 1 OR** |
| **2:4 Decoder** | **4** | **4** | **3** | 4 AND + 2 NOT |
| **4:1 MUX** | **7** | **7** | **3** | 3 (2:1 MUXes) |
| **8:1 MUX** | **15** | **15** | **7** | 7 (2:1 MUXes) |

---

# 7. GATE PYQ-Style Solved Questions

^q1
<h6 class="question">Q1) How many 4:1 multiplexers are required to construct a 256:1 multiplexer?</h6>

<u>Sol</u>$^n$ -
Target MUX size: $2^n = 256 \implies n = 8$.
Available MUX size: $2^m = 4 \implies m = 2$.

Using the MUX Tree Expansion Formula:
$$ \text{Total MUXes} = \frac{2^n - 1}{2^m - 1} = \frac{256 - 1}{4 - 1} = \frac{255}{3} = 85 $$

Verification by stages:
- Stage 1: $\frac{256}{4} = 64$ MUXes.
- Stage 2: $\frac{64}{4} = 16$ MUXes.
- Stage 3: $\frac{16}{4} = 4$ MUXes.
- Stage 4: $\frac{4}{4} = 1$ MUX.
- Total $= 64 + 16 + 4 + 1 = 85$.

$$ \boxed{\text{Answer} = 85} $$

---

^q2
<h6 class="question">Q2) A 4-bit Ripple Carry Adder (RCA) is constructed using 4 Full Adders. Each Full Adder has a sum propagation delay of 20 ns and a carry propagation delay of 15 ns. What is the total time required to obtain the final sum and carry out?</h6>

<u>Sol</u>$^n$ -
Let $t_s = 20\text{ ns}$ (sum delay) and $t_c = 15\text{ ns}$ (carry delay).

For an $n$-bit Ripple Carry Adder:
- The carry must propagate through all $n-1$ initial stages: $(n-1) \times t_c = (4-1) \times 15 = 45\text{ ns}$.
- At the $n$-th (final) stage, both final sum $S_3$ and final carry $C_4$ are evaluated:
  - Final Carry $C_4$ delay $= 45 + 15 = 60\text{ ns}$.
  - Final Sum $S_3$ delay $= 45 + t_s = 45 + 20 = 65\text{ ns}$.

Total time to obtain all valid outputs is bounded by the max delay:
$$ t_{\text{total}} = \max(60, 65) = 65\text{ ns} $$

$$ \boxed{t_{\text{total}} = 65\text{ ns}} $$

---

^q3
<h6 class="question">Q3) Implement the Boolean function F(A, B, C) = \sum m(1, 3, 4, 6) using an 8:1 MUX and a 4:1 MUX.</h6>

<u>Sol</u>$^n$ -
1. **Using 8:1 MUX**:
   - Connect $A, B, C$ to select lines $S_2, S_1, S_0$.
   - Data inputs $I_1 = I_3 = I_4 = I_6 = 1$, and $I_0 = I_2 = I_5 = I_7 = 0$.

2. **Using 4:1 MUX**:
   - Connect $A, B$ to select lines $S_1, S_0$.
   - Construct implementation table for remaining variable $C$:

| $AB$ Select | Minterms ($C=0, C=1$) | Mux Input $I_k$ |
| :---: | :---: | :---: |
| **00** | $m_0(0), m_1(1)$ | $C$ |
| **01** | $m_2(0), m_3(1)$ | $C$ |
| **10** | $m_4(1), m_5(0)$ | $\bar{C}$ |
| **11** | $m_6(1), m_7(0)$ | $\bar{C}$ |

   - MUX Data Inputs: $I_0 = C, \ I_1 = C, \ I_2 = \bar{C}, \ I_3 = \bar{C}$.

$$ \boxed{\text{Inputs for 4:1 MUX: } I_0=C, I_1=C, I_2=\bar{C}, I_3=\bar{C}} $$
