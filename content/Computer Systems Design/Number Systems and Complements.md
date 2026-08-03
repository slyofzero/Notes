>[!SUMMARY] Table of Contents
>- [[Number Systems and Complements#Overview|Overview]]
>- [[Number Systems and Complements#1. Number Systems & Radix Complements|1. Number Systems & Radix Complements]]
>	- [[Number Systems and Complements#1.1 Positional Number Systems|1.1 Positional Number Systems]]
>	- [[Number Systems and Complements#1.2 Radix ($r$) and Diminished Radix ($r-1$) Complements|1.2 Radix ($r$) and Diminished Radix ($r-1$) Complements]]
>- [[Number Systems and Complements#2. Signed Binary Representations|2. Signed Binary Representations]]
>	- [[Number Systems and Complements#2.1 Signed Magnitude Representation|2.1 Signed Magnitude Representation]]
>	- [[Number Systems and Complements#2.2 1's Complement Representation & Its Limitations|2.2 1's Complement Representation & Its Limitations]]
>	- [[Number Systems and Complements#2.3 2's Complement Representation (Deep Intuition)|2.3 2's Complement Representation (Deep Intuition)]]
>- [[Number Systems and Complements#3. Comparison & Range Matrix|3. Comparison & Range Matrix]]
>- [[Number Systems and Complements#4. 2's Complement Arithmetic, Sign Extension & Overflow|4. 2's Complement Arithmetic, Sign Extension & Overflow]]
>	- [[Number Systems and Complements#4.1 Sign Extension Rule|4.1 Sign Extension Rule]]
>	- [[Number Systems and Complements#4.2 Addition and Subtraction|4.2 Addition and Subtraction]]
>	- [[Number Systems and Complements#4.3 Overflow Detection ($C_{in} \oplus C_{out}$)|4.3 Overflow Detection ($C_{in} \oplus C_{out}$)]]
>- [[Number Systems and Complements#5. IEEE 754 Floating-Point Standard|5. IEEE 754 Floating-Point Standard]]
>	- [[Number Systems and Complements#5.1 Format Breakdown (Single & Double Precision)|5.1 Format Breakdown (Single & Double Precision)]]
>	- [[Number Systems and Complements#5.2 Normalized Numbers & Hidden Bit|5.2 Normalized Numbers & Hidden Bit]]
>	- [[Number Systems and Complements#5.3 Special Values & Denormalized Numbers|5.3 Special Values & Denormalized Numbers]]
>- [[Number Systems and Complements#6. GATE PYQ-Style Solved Questions|6. GATE PYQ-Style Solved Questions]]

At the lowest abstraction level, computer hardware consists of electronic circuits operating on binary digits (bits). To perform mathematical computations, digital systems must encode both non-negative integers and negative quantities, as well as real numbers with fractional components.

In this note, we develop a deep conceptual foundation for positional number systems, radix complements, 1's and 2's complement representations, signed arithmetic, hardware overflow detection, and the IEEE 754 floating-point standard.

---

# 1. Number Systems & Radix Complements

## 1.1 Positional Number Systems

In a positional number system of base (or **radix**) $r$, a number $N = (a_{n-1} a_{n-2} \dots a_0 . a_{-1} a_{-2} \dots a_{-m})_r$ represents the magnitude:
$$ N = \sum_{i=-m}^{n-1} a_i \cdot r^i $$
Common bases used in computer computer design are Binary ($r=2$), Octal ($r=8$), Decimal ($r=10$), and Hexadecimal ($r=16$).

---

## 1.2 Radix ($r$) and Diminished Radix ($r-1$) Complements

Complements simplify subtraction by converting subtractive logic into additive logic. For an $n$-digit integer $N$ in base $r$:

1. **Diminished Radix Complement ($r-1$ Complement)**:
   $$ \boxed{(r-1)\text{'s Complement} = (r^n - 1) - N} $$
   - For Binary ($r=2$): **1's Complement** $= (2^n - 1) - N$. In binary, subtracting a digit from $1$ ($1-0=1, 1-1=0$) is equivalent to a **bitwise NOT** operation.

2. **Radix Complement ($r$ Complement)**:
   $$ \boxed{r\text{'s Complement} = r^n - N = \left[(r^n - 1) - N\right] + 1} $$
   - For Binary ($r=2$): **2's Complement** $= 1\text{'s Complement} + 1$.

---

# 2. Signed Binary Representations

To represent negative numbers in binary using $n$ bits, the Most Significant Bit (**MSB**) is reserved as the **Sign Bit** ($0 \implies \text{Positive}$, $1 \implies \text{Negative}$).

---

## 2.1 Signed Magnitude Representation

In $n$-bit Sign-Magnitude:
- **MSB ($a_{n-1}$)**: Represents sign ($0$ for $+$, $1$ for $-$).
- **Remaining $n-1$ bits**: Represent absolute magnitude.

### Drawbacks:
1. **Dual Zero Representation**: $+0 = 0000\dots0_2$ and $-0 = 1000\dots0_2$. This wastes a bit pattern and requires double testing for zero in ALU logic.
2. **Complex Subtraction Hardware**: Adding $+A$ and $-B$ requires separate magnitude comparators and subtractor hardware.

---

## 2.2 1's Complement Representation & Its Limitations

In $n$-bit 1's complement, a negative number $-N$ is formed by bitwise inverting all bits of $+N$.

### The Dual Zero Problem
Like Sign-Magnitude, 1's complement suffers from **two representations of zero**:
$$ +0 = 0000\dots0_2 \quad \text{and} \quad -0 = 1111\dots1_2 $$

### End-Around Carry Requirement
When adding two 1's complement numbers, if an output carry is generated from the MSB, it must be added back into the Least Significant Bit (**LSB**) (called **end-around carry**). This introduces an extra clock cycle/delay in arithmetic circuits.

---

## 2.3 2's Complement Representation (Deep Intuition)

The **2's complement** representation is the universal standard in all modern processors (x86, ARM, RISC-V).

### How to Calculate 2's Complement
To find $-N$ in 2's complement:
1. Invert all bits of $N$ ($1 \to 0, 0 \to 1$).
2. Add $1$ to the LSB.
   $$\boxed{-N_{\text{2's}} = \bar{N} + 1}$$

> [!TIP]
> **Shortcut for GATE**: Scan the binary number from right to left (LSB to MSB). Keep all bits unchanged up to and including the first `1`. Invert every bit after that first `1`!
> - Example for $-6_{10}$ in 4 bits: $+6 = 0110_2$.
> - Scanning from right: `0` (keep), `1` (first 1, keep), `1` (invert to 0), `0` (invert to 1) $\implies 1010_2$.

---

### The Modular Clock Wheel Intuition (Modulo $2^n$)

Why does 2's complement work so perfectly without needing separate subtractor circuits?

Think of an $n$-bit register as a **modular clock wheel** with $2^n$ positions (ranging from $0$ to $2^n - 1$).

![Placeholder: Modular Number Wheel for 4-bit 2's Complement](imgs/twos-complement-wheel.png)
> **Student Image Note**: Place an image named `twos-complement-wheel.png` in the `imgs/` directory.
> *Search description*: "4 bit 2s complement number wheel diagram showing signed values from +7 down to -8 and binary patterns 0000 to 1111 arranged in a circle".

In a 4-bit register ($2^4 = 16$ states):
- If you start at $0000_2$ ($0$) and move **counter-clockwise** by 1 step, you land on $1111_2$ ($15_{10}$).
- In signed arithmetic, moving 1 step backward from $0$ should equal **$-1$**.
- Therefore, $1111_2$ naturally represents **$-1$**!
- Moving counter-clockwise by 2 steps lands on $1110_2 = -2_{10}$.
- Moving counter-clockwise by 6 steps lands on $1010_2 = -6_{10}$.

Because arithmetic wraps around modulo $2^n$:
$$ A - B \equiv A + (2^n - B) \pmod{2^n} $$
Adding the 2's complement of $B$ ($2^n - B$) is mathematically identical to subtracting $B$! The ALU can use a standard adder circuit for both addition and subtraction without needing a subtractor!

---

### Key Advantages of 2's Complement:
1. **Single Unique Zero**:
   - $+0 = 0000_2$.
   - $-0 = \text{2's complement of } 0000_2 = (\bar{0000}) + 1 = 1111 + 1 = (1)0000_2 \implies 0000_2$.
   - Zero has only **one representation** ($0000\dots0$), eliminating ambiguity!
2. **Extra Negative Value**:
   - Because $-0$ is eliminated, the bit pattern $1000\dots0_2$ becomes available to represent an extra negative number: **$-2^{n-1}$**.
3. **No End-Around Carry**: Any carry out from the MSB during addition is simply ignored!

---

# 3. Comparison & Range Matrix

For an $n$-bit register, the range of representable numbers across formats is:

| Representation | Negative Range | Positive Range | Total Distinct Values | Representation of Zero |
| :--- | :---: | :---: | :---: | :---: |
| **Unsigned** | N/A | $0 \le N \le 2^n - 1$ | $2^n$ | Single ($0000\dots0$) |
| **Sign-Magnitude** | $-(2^{n-1} - 1) \le N \le -0$ | $+0 \le N \le 2^{n-1} - 1$ | $2^n - 1$ | Dual ($+0$ and $-0$) |
| **1's Complement** | $-(2^{n-1} - 1) \le N \le -0$ | $+0 \le N \le 2^{n-1} - 1$ | $2^n - 1$ | Dual ($+0$ and $-0$) |
| **2's Complement** | $\mathbf{-2^{n-1} \le N \le -1}$ | $\mathbf{0 \le N \le 2^{n-1} - 1}$ | $\mathbf{2^n}$ | **Single ($0000\dots0$)** |

### Summary Range Table for Common Bit Widths:

| Bit Width ($n$) | Sign-Magnitude & 1's Complement Range | 2's Complement Range |
| :---: | :---: | :---: |
| **4 bits** | $[-7, +7]$ | $[-8, +7]$ |
| **8 bits** | $[-127, +127]$ | $[-128, +127]$ |
| **16 bits** | $[-32767, +32767]$ | $[-32768, +32767]$ |
| **32 bits** | [$-2^{31}+1, 2^{31}-1$] | [$-2^{31}, 2^{31}-1$] |

---

# 4. 2's Complement Arithmetic, Sign Extension & Overflow

## 4.1 Sign Extension Rule

To convert an $m$-bit signed 2's complement number into an $n$-bit number ($n > m$) without changing its value:
- **Rule**: Replicate the **MSB (sign bit)** of the $m$-bit number into all extended bit positions on the left.

### Examples:
- Extend $+5_{10} = 0101_2$ (4-bit) to 8-bit:
  - MSB is `0` $\implies$ Extend `0`s $\implies \mathbf{0000}0101_2 = +5_{10}$.
- Extend $-5_{10} = 1011_2$ (4-bit) to 8-bit:
  - MSB is `1` $\implies$ Extend `1`s $\implies \mathbf{1111}1011_2 = -5_{10}$.

---

## 4.2 Addition and Subtraction

To subtract $A - B$:
1. Compute the 2's complement of $B \implies (-B)$.
2. Perform binary addition $A + (-B)$.
3. Ignore any final carry out of the MSB.

---

## 4.3 Overflow Detection ($C_{in} \oplus C_{out}$)

An **overflow** occurs when the result of an arithmetic operation exceeds the representable range of the $n$-bit signed container.

> [!WARNING]
> Overflow can **only** occur when:
> 1. Adding two positive numbers yields a negative result ($(+) + (+) = (-)$).
> 2. Adding two negative numbers yields a positive result ($(-) + (-) = (+)$).
> *Adding a positive and negative number can NEVER produce an overflow!*

### Hardware Overflow Condition
Let $C_{in}$ be the carry going **into** the MSB position, and $C_{out}$ be the carry coming **out of** the MSB position. Overflow flag $V$ is given by:
$$ \boxed{V = C_{in} \oplus C_{out}} $$

- If $V = 1 \implies \text{Overflow has occurred}$ (Result is incorrect).
- If $V = 0 \implies \text{No overflow}$ (Result is correct).

---

# 5. IEEE 754 Floating-Point Standard

Real numbers with fractional parts are represented using the **IEEE 754 Floating-Point Standard**.

$$ \boxed{V = (-1)^S \times (1.M)_2 \times 2^{E - \text{Bias}}} $$

---

## 5.1 Format Breakdown (Single & Double Precision)

| Parameter | Single Precision (32-bit) | Double Precision (64-bit) |
| :--- | :---: | :---: |
| **Sign Bit ($S$)** | 1 bit (Bit 31) | 1 bit (Bit 63) |
| **Exponent Bits ($E$)** | 8 bits (Bits 30–23) | 11 bits (Bits 62–52) |
| **Mantissa/Fraction ($M$)** | 23 bits (Bits 22–0) | 52 bits (Bits 51–0) |
| **Exponent Bias ($B$)** | **127** ($2^{8-1} - 1$) | **1023** ($2^{11-1} - 1$) |
| **Bias Formula** | $2^{k-1} - 1$ | $2^{k-1} - 1$ |

---

## 5.2 Normalized Numbers & Hidden Bit

For a **normalized number**, the exponent field $E$ is neither all 0s nor all 1s ($0 < E < 2^k - 1$).

- **Hidden 1 Rule**: In binary scientific notation, every non-zero normalized number starts with a leading `1.` before the binary point (e.g., $1.1011_2 \times 2^e$). Since this `1.` is always present, IEEE 754 **omits** it from storage to save 1 bit of precision!
- The 23 mantissa bits store only the fractional part $M$ after the radix point.

### Example Conversion: Convert $-0.75_{10}$ to Single-Precision IEEE 754
1. **Sign bit**: Negative $\implies S = 1$.
2. **Binary magnitude**: $0.75_{10} = 0.11_2 = 1.1_2 \times 2^{-1}$.
3. **Mantissa ($M$)**: $1.1_2 \implies M = 10000000000000000000000_2$ (pad to 23 bits).
4. **Biased Exponent ($E$)**:
   $$ E = \text{Actual Exponent} + \text{Bias} = -1 + 127 = 126_{10} = 01111110_2 $$
5. **32-bit representation**:
   $$ \underbrace{1}_{S} \ \underbrace{01111110}_{E} \ \underbrace{10000000000000000000000}_{M} = \text{BF400000}_{16} $$

---

## 5.3 Special Values & Denormalized Numbers

The exponent values $E = 0$ and $E = E_{\max} = 2^k - 1$ (255 for Single, 2047 for Double) are reserved for special cases:

| Exponent Field ($E$) | Mantissa Field ($M$) | Value Represented | Description |
| :---: | :---: | :---: | :--- |
| **$0$** | **$0$** | **$\pm 0$** | Signed Zero (determined by Sign bit $S$) |
| **$0$** | **$\neq 0$** | **$(-1)^S \times 0.M \times 2^{1 - \text{Bias}}$** | **Denormalized (Subnormal) Numbers** (No hidden 1) |
| **$1 \le E \le 254$** | Any | **$(-1)^S \times 1.M \times 2^{E - 127}$** | **Normalized Numbers** |
| **$255$** | **$0$** | **$\pm \infty$** | Overflow / Infinity |
| **$255$** | **$\neq 0$** | **$\text{NaN}$** | Not a Number (e.g., $0/0$, $\sqrt{-1}$) |

> [!NOTE]
> Denormalized numbers allow **gradual underflow** for values very close to zero by removing the implicit leading $1$.

---

# 6. GATE PYQ-Style Solved Questions

^q1
<h6 class="question">Q1) What is the decimal value represented by the 8-bit 2's complement binary pattern 10110100?</h6>

<u>Sol</u>$^n$ -
1. Examine MSB: MSB = `1`, so the number is **negative**.
2. To find its magnitude, take 2's complement of `10110100`:
   - Bitwise NOT: `01001011`
   - Add 1: `01001011 + 1 = 01001100`
3. Convert `01001100_2` to decimal:
   $$ 2^6 + 2^3 + 2^2 = 64 + 8 + 4 = 76 $$
4. Include negative sign: $-76$.

$$ \boxed{\text{Value} = -76_{10}} $$

---

^q2
<h6 class="question">Q2) Two 4-bit signed 2's complement numbers A = 1001 and B = 1011 are added. Determine the result and check if an overflow occurred.</h6>

<u>Sol</u>$^n$ -
1. Input values:
   - $A = 1001_2 \implies -7_{10}$
   - $B = 1011_2 \implies -5_{10}$
2. Perform binary addition:
   $$
   \begin{array}{r@{\quad}l}
   1001 \\
   +\ 1011 \\
   \hline
   (1)0100
   \end{array}
   $$
3. Truncating to 4 bits: Result = $0100_2 = +4_{10}$.
4. Check Overflow:
   - Adding two negative numbers ($A < 0, B < 0$) produced a positive result ($+4 > 0$)!
   - Bitwise carry check: Carry into MSB $C_{in} = 1$, Carry out of MSB $C_{out} = 1$? Let's trace:
     - Bit 0: $1+1 = 0$, carry = $1$
     - Bit 1: $0+1+1 = 0$, carry = $1$
     - Bit 2: $0+0+1 = 1$, carry = $0 \implies C_{in} = 0$
     - Bit 3 (MSB): $1+1+0 = 0$, carry out $C_{out} = 1$
   - $V = C_{in} \oplus C_{out} = 0 \oplus 1 = 1 \implies \text{Overflow = TRUE}$.

$$ \boxed{\text{Result} = 0100_2 (+4), \text{Overflow} = 1\ (\text{True})}$$

---

^q3
<h6 class="question">Q3) A single-precision IEEE 754 floating-point variable has the hex representation 0x41400000. Determine its decimal value.</h6>

<u>Sol</u>$^n$ -
1. Convert Hex to 32-bit Binary:
   $$ \text{0x41400000} = 0100 \ 0001 \ 0100 \ 0000 \ 0000 \ 0000 \ 0000 \ 0000_2 $$
2. Parse Fields:
   - **Sign ($S$)**: Bit 31 = `0` $\implies$ Positive ($+$).
   - **Exponent ($E$)**: Bits 30–23 = $10000010_2 = 130_{10}$.
   - **Mantissa ($M$)**: Bits 22–0 = $10000000000000000000000_2 \implies 0.1_2 = 0.5$.
3. Compute Actual Exponent:
   $$ e = E - \text{Bias} = 130 - 127 = 3 $$
4. Compute Value:
   $$ V = (+1) \times (1.M)_2 \times 2^e = 1.1_2 \times 2^3 = 1.5 \times 8 = 12 $$

$$ \boxed{\text{Decimal Value} = 12} $$
