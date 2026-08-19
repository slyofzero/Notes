>[!SUMMARY] Table of Contents
>- [[Sequential Circuits#Overview|Overview]]
>- [[Sequential Circuits#1. Foundations of Sequential Circuits|1. Foundations of Sequential Circuits]]
>	- [[Sequential Circuits#1.1 Combinational vs. Sequential Logic|1.1 Combinational vs. Sequential Logic]]
>	- [[Sequential Circuits#1.2 Level Triggering vs. Edge Triggering|1.2 Level Triggering vs. Edge Triggering]]
>	- [[Sequential Circuits#1.3 Latches vs. Flip-Flops|1.3 Latches vs. Flip-Flops]]
>	- [[Sequential Circuits#1.4 The Clock Signal & Duty Cycle|1.4 The Clock Signal & Duty Cycle]]
>	- [[Sequential Circuits#1.5 Triggering Classification: Latches vs. Flip-Flops|1.5 Triggering Classification: Latches vs. Flip-Flops]]
>- [[Sequential Circuits#2. SR Latches (Set-Reset)|2. SR Latches (Set-Reset)]]
>	- [[Sequential Circuits#2.1 SR NOR Latch (Active-High)|2.1 SR NOR Latch (Active-High)]]
>	- [[Sequential Circuits#2.2 SR NAND Latch (Active-Low)|2.2 SR NAND Latch (Active-Low)]]
>	- [[Sequential Circuits#2.3 Gated SR Latch (with Enable Pin)|2.3 Gated SR Latch (with Enable Pin)]]
>	- [[Sequential Circuits#2.4 Characteristic Equation & Excitation Table|2.4 Characteristic Equation & Excitation Table]]
>- [[Sequential Circuits#3. D Latches (Data / Delay)|3. D Latches (Data / Delay)]]
>	- [[Sequential Circuits#3.1 Basic D Latch Concept|3.1 Basic D Latch Concept]]
>	- [[Sequential Circuits#3.2 Gated D Latch (Transparent Latch)|3.2 Gated D Latch (Transparent Latch)]]
>	- [[Sequential Circuits#3.3 Characteristic Equation & Excitation Table|3.3 Characteristic Equation & Excitation Table]]
>	- [[Sequential Circuits#3.4 Level Transparency & Timing Parameters|3.4 Level Transparency & Timing Parameters]]
>- [[Sequential Circuits#4. Edge-Triggered D Flip-Flops|4. Edge-Triggered D Flip-Flops]]
>	- [[Sequential Circuits#4.1 Concept & Difference from D Latch|4.1 Concept & Difference from D Latch]]
>	- [[Sequential Circuits#4.2 Truth Table & Symbol|4.2 Truth Table & Symbol]]
>	- [[Sequential Circuits#4.3 Characteristic Equation & Excitation Table|4.3 Characteristic Equation & Excitation Table]]
>- [[Sequential Circuits#5. T Flip-Flops (Toggle)|5. T Flip-Flops (Toggle)]]
>	- [[Sequential Circuits#5.1 Concept & Circuit Realization|5.1 Concept & Circuit Realization]]
>	- [[Sequential Circuits#5.2 Truth Table & State Analysis|5.2 Truth Table & State Analysis]]
>	- [[Sequential Circuits#5.3 Characteristic Equation & Excitation Table|5.3 Characteristic Equation & Excitation Table]]
>	- [[Sequential Circuits#5.4 Frequency Division Property ($f_{out} = f_{in} / 2$)|5.4 Frequency Division Property ($f_{out} = f_{in} / 2$)]]
>- [[Sequential Circuits#6. JK Flip-Flops & Race-Around Condition|6. JK Flip-Flops & Race-Around Condition]]
>	- [[Sequential Circuits#6.1 Motivation & Circuit Logic|6.1 Motivation & Circuit Logic]]
>	- [[Sequential Circuits#6.2 Truth Table & State Analysis|6.2 Truth Table & State Analysis]]
>	- [[Sequential Circuits#6.3 Characteristic Equation & Excitation Table|6.3 Characteristic Equation & Excitation Table]]
>	- [[Sequential Circuits#6.4 The Race-Around Condition|6.4 The Race-Around Condition]]
>- [[Sequential Circuits#7. Master-Slave Flip-Flops|7. Master-Slave Flip-Flops]]
>	- [[Sequential Circuits#7.1 Master-Slave Operating Principle|7.1 Master-Slave Operating Principle]]
>	- [[Sequential Circuits#7.2 Master-Slave D Flip-Flop|7.2 Master-Slave D Flip-Flop]]
>	- [[Sequential Circuits#7.3 Master-Slave JK Flip-Flop|7.3 Master-Slave JK Flip-Flop]]
>- [[Sequential Circuits#8. Roadmap & Future Expansion (Registers & Counters)|8. Roadmap & Future Expansion (Registers & Counters)]]
>- [[Sequential Circuits#9. GATE PYQ-Style Solved Questions|9. GATE PYQ-Style Solved Questions]]

Unlike memoryless combinational circuits whose outputs depend solely on present inputs, **sequential circuits** contain **memory elements** (such as latches or flip-flops) and feedback paths. Their present output depends on both **present inputs** and the **present state** (past history) stored in memory.

$$ \text{Sequential Output } Y(t) = f(\text{Present Inputs } X(t), \text{ Present State } Q(t)) $$

In this note, we cover the foundational principles of sequential logic, level vs. edge triggering, and a comprehensive analysis of **SR NOR**, **SR NAND**, and **D Latches**.

---

# 1. Foundations of Sequential Circuits

---

## 1.1 Combinational vs. Sequential Logic

| Property | Combinational Circuits | Sequential Circuits |
| :--- | :--- | :--- |
| **Output Dependency** | Present inputs only | Present inputs + Present state ($Q$) |
| **Memory Element** | Not required | Required (Latches / Flip-Flops) |
| **Feedback Path** | No feedback loop | Mandatory feedback loop |
| **Clock Signal** | Not required | Clock used in synchronous circuits |
| **Examples** | Adders, MUX, Decoders | Latches, Flip-Flops, Counters, Registers |

---

## 1.2 Level Triggering vs. Edge Triggering

Control signals (clock or enable $E$) dictate when a memory element updates its state:

1. **Level Triggered (Latches)**:
   - The circuit responds and changes state continuously as long as the control signal $E$ is held at a specific voltage **level** (High level $= 1$ or Low level $= 0$).
   - **Transparent Mode**: While $E=1$, any change at the data inputs immediately propagates to the output.

2. **Edge Triggered (Flip-Flops)**:
   - The circuit responds and samples inputs **only during the transition (edge)** of the clock pulse:
     - **Positive / Rising Edge ($\uparrow$)**: Transition from $0 \to 1$.
     - **Negative / Falling Edge ($\downarrow$)**: Transition from $1 \to 0$.
   - Inputs are ignored during the rest of the clock cycle when the clock is steady high or low.

---

## 1.3 Latches vs. Flip-Flops

- **Latch**: A **level-sensitive** bistable memory element without a clock or operated via a level enable.
- **Flip-Flop**: An **edge-sensitive** bistable memory element (typically constructed by cascading two latches in a Master-Slave configuration).

---

## 1.4 The Clock Signal & Duty Cycle

A **clock signal ($\text{CLK}$)** is a continuous, periodic square-wave voltage signal generated by an oscillator (e.g., a quartz crystal). It serves as the central **metronome** of synchronous digital systems, coordinating when data transfers and state updates occur across millions of flip-flops.

![[Pasted image 20260802194827.png]]

### Fundamental Parameters for GATE:
1. **Clock Period ($T$)**: The time taken to complete one full cycle ($\text{HIGH} + \text{LOW}$):   $$ \boxed{T = t_{\text{high}} + t_{\text{low}}} $$
2. **Clock Frequency ($f$)**: The number of clock cycles per second:
   $$ \boxed{f = \frac{1}{T}} \quad (\text{measured in Hz, MHz, or GHz}) $$
3. **Duty Cycle**: The percentage of total clock period $T$ during which the clock signal is **HIGH** ($1$):
   $$ \boxed{\text{Duty Cycle} = \frac{t_{\text{high}}}{T} \times 100\%} $$
   - **Symmetrical Clock**: A clock with a **50% duty cycle** ($t_{\text{high}} = t_{\text{low}} = T/2$).
   - Example: A 100 MHz clock ($T = 10\text{ ns}$) with a 50% duty cycle has $t_{\text{high}} = 5\text{ ns}$ and $t_{\text{low}} = 5\text{ ns}$.

4. **Clock Triggering Regions (Level vs. Edge)**:
   Every clock period contains two **voltage levels** and two **transition edges**:
   - **HIGH Level ($t_{\text{high}}$)**: Signal remains at logic $1$. Level-triggered active-high latches remain transparent during this entire duration.
   - **LOW Level ($t_{\text{low}}$)**: Signal remains at logic $0$.
   - **Rising Edge ($\uparrow$)**: The instantaneous low-to-high transition ($0 \to 1$). Positive edge-triggered flip-flops sample data at this exact instant.
   - **Falling Edge ($\downarrow$)**: The instantaneous high-to-low transition ($1 \to 0$). Negative edge-triggered flip-flops sample data at this exact instant.

---

## 1.5 Triggering Classification: Latches vs. Flip-Flops (Core GATE Rule)

Understanding how triggering mechanisms are visually represented in circuit schematics is essential for solving GATE block diagram questions:

> [!IMPORTANT]
> - **LATCHES use LEVEL TRIGGERING**: A latch is enabled and transparent for the entire **duration** (voltage level) that the clock or enable signal is held at logic $1$ (or logic $0$).
> - **FLIP-FLOPS use EDGE TRIGGERING**: A flip-flop is non-transparent and samples inputs **only at the split-second transition edge** (rising $\uparrow$ or falling $\downarrow$) of the clock pulse.

---

### How Schematic Symbols Represent Triggering Modes

In digital schematics, two distinct visual notation rules dictate how clock pins are drawn:

1. **Presence of Dynamic Indicator ($\Delta$)**:
   - **No Triangle**: Represents a **Level-Triggered Latch**.
   - **Triangle ($\Delta$) inside the block**: Represents an **Edge-Triggered Flip-Flop** (the triangle is called the *Dynamic Indicator*).

2. **Presence of Inversion Bubble ($\circ$)**:
   - **No Bubble**: Active on **Positive / High** signal ($CLK=1$ or Rising Edge $\uparrow$).
   - **Bubble ($\circ$) outside the block**: Active on **Negative / Low** signal ($CLK=0$ or Falling Edge $\downarrow$).

---

### The 4 Clock Input Symbol Configurations

![[Pasted image 20260804225832.png|534]]

```
  1. Positive Level Latch      2. Negative Level Latch
     +--------------+             +--------------+
     |            Q |             |            Q |
CLK -|              |       CLK -o|              |
     |            Q'|             |            Q'|
     +--------------+             +--------------+
  (Active while CLK = 1)       (Active while CLK = 0)


  3. Positive Edge Flip-Flop   4. Negative Edge Flip-Flop
     +--------------+             +--------------+
     |            Q |             |            Q |
CLK ->|             |       CLK -o>|             |
     |            Q'|             |            Q'|
     +--------------+             +--------------+
  (Samples on 0 -> 1 Edge)     (Samples on 1 -> 0 Edge)
```

---

### Summary Triggering & Symbol Matrix for GATE:

| Memory Element Type | Triggering Mechanism | Active Sampling Condition | Clock Pin Schematic Symbol |
| :--- | :---: | :---: | :---: |
| **Positive (High) Level Latch** | **Level-Triggered** | $CLK = 1$ (High Voltage) | Plain pin labeled $CLK$ (No $\Delta$, No $\circ$) |
| **Negative (Low) Level Latch** | **Level-Triggered** | $CLK = 0$ (Low Voltage) | Bubble ($\circ$) on $CLK$ pin (No $\Delta$) |
| **Positive Edge-Triggered Flip-Flop** | **Edge-Triggered** | **Rising Edge ($\uparrow$)** ($0 \to 1$) | Dynamic Triangle ($\Delta$) inside $CLK$ pin |
| **Negative Edge-Triggered Flip-Flop** | **Edge-Triggered** | **Falling Edge ($\downarrow$)** ($1 \to 0$) | Bubble + Triangle ($\circ \Delta$) on $CLK$ pin |

---

# 2. SR Latches (Set-Reset)

An **SR Latch** is the fundamental 1-bit memory element. It has two inputs: **Set ($S$)** and **Reset ($R$)**, and two complementary outputs: $Q$ (normal output) and $\bar{Q}$ (inverted output).

---

## 2.1 SR NOR Latch (Active-High)

An active-high SR Latch is constructed using two cross-coupled **NOR gates**.

### Circuit Schematic

![[Pasted image 20260802181154.png]]

### Truth Table (Active-High SR NOR Latch)

| $S$ | $R$ | Next State ($Q_{next}$) | $\bar{Q}_{next}$ | State Description |
| :---: | :---: | :---: | :---: | :---: |
| 0 | 0 | $Q$ | $\bar{Q}$ | **No Change / Memory (Hold)** |
| 0 | 1 | 0 | 1 | **Reset State** ($Q \to 0$) |
| 1 | 0 | 1 | 0 | **Set State** ($Q \to 1$) |
| 1 | 1 | 0 | 0 | **Forbidden / Invalid State** ($Q = \bar{Q} = 0$) |

### Detailed Operation Analysis:
1. **$S=0, R=0$ (Hold)**: NOR gate output with one 0 input equals the complement of the other input. The feedback retains the previously stored bit $Q$.
2. **$S=0, R=1$ (Reset)**: $R=1$ forces top NOR gate output $Q = 0$. Then $S=0, Q=0$ forces bottom NOR gate output $\bar{Q} = 1$.
3. **$S=1, R=0$ (Set)**: $S=1$ forces bottom NOR gate output $\bar{Q} = 0$. Then $R=0, \bar{Q}=0$ forces top NOR gate output $Q = 1$.
4. **$S=1, R=1$ (Forbidden / Invalid)**: Both $S=1$ and $R=1$ force $Q = 0$ and $\bar{Q} = 0$. This violates the fundamental output rule ($Q = \overline{\bar{Q}}$). Furthermore, if $S$ and $R$ transition simultaneously back to $0$, the final state is unpredictable (race condition).

---

## 2.2 SR NAND Latch (Active-Low)

An active-low SR Latch is constructed using two cross-coupled **NAND gates**. The inputs are active-low, denoted as $\bar{S}$ and $\bar{R}$ (or $S'$ and $R'$).
### Circuit Schematic

![[Pasted image 20260802181949.png|500]]


### Truth Table (Active-Low SR NAND Latch)

| $\bar{S}$ | $\bar{R}$ | Next State ($Q_{next}$) | $\bar{Q}_{next}$ | State Description |
| :---: | :---: | :---: | :---: | :---: |
| 0 | 0 | 1 | 1 | **Forbidden / Invalid State** ($Q = \bar{Q} = 1$) |
| 0 | 1 | 1 | 0 | **Set State** ($Q \to 1$) |
| 1 | 0 | 0 | 1 | **Reset State** ($Q \to 0$) |
| 1 | 1 | $Q$ | $\bar{Q}$ | **No Change / Memory (Hold)** |

> [!IMPORTANT]
> Compare NOR vs NAND SR Latches carefully!
> - For **NOR Latch**: Active-High ($S=1$ sets, $R=1$ resets, $S=R=0$ holds, $S=R=1$ forbidden).
> - For **NAND Latch**: Active-Low ($\bar{S}=0$ sets, $\bar{R}=0$ resets, $\bar{S}=\bar{R}=1$ holds, $\bar{S}=\bar{R}=0$ forbidden).

---

## 2.3 Gated SR Latch (with Enable Pin)

To control when the SR Latch responds to inputs, two steering NAND gates and an **Enable ($E$)** pin are added to an active-low NAND latch.

![[Pasted image 20260802181813.png|525]]

### Functioning:
- When **$E = 0$**: Steering NAND gate outputs are forced to $1, 1$. The internal NAND latch sees $\bar{S}=1, \bar{R}=1 \implies$ **Hold State** (inputs $S$ and $R$ are ignored).
- When **$E = 1$**: Steering NAND gates invert $S$ and $R$ ($\bar{S} = \overline{S \cdot 1} = \bar{S}$), converting the circuit into an **Active-High Gated SR Latch**:

| $E$ | $S$ | $R$ | $Q_{next}$ | State Description |
| :---: | :---: | :---: | :---: | :---: |
| 0 | X | X | $Q$ | Disabled (Hold) |
| 1 | 0 | 0 | $Q$ | Hold |
| 1 | 0 | 1 | 0 | Reset |
| 1 | 1 | 0 | 1 | Set |
| 1 | 1 | 1 | Invalid | Forbidden ($S=R=1$) |

---

## 2.4 Characteristic Equation & Excitation Table

### 1. Characteristic Equation
Using a K-Map derived from the truth table (with $S \cdot R = 0$ as a constraint condition):

$$ \boxed{Q_{next} = S + \bar{R}Q} \quad \text{subject to constraint: } \boxed{S \cdot R = 0} $$

---

### 2. Excitation Table
The **excitation table** specifies the required inputs ($S, R$) needed to cause a desired state transition from present state $Q$ to next state $Q_{next}$:

| Present State ($Q$) | Next State ($Q_{next}$) | Required $S$ | Required $R$ | Notes / Explanation |
| :---: | :---: | :---: | :---: | :--- |
| 0 | 0 | **0** | **X** | Can be Hold ($0,0$) or Reset ($0,1$) $\implies S=0, R=\text{Don't Care}$ |
| 0 | 1 | **1** | **0** | Must Set ($S=1, R=0$) |
| 1 | 0 | **0** | **1** | Must Reset ($S=0, R=1$) |
| 1 | 1 | **X** | **0** | Can be Hold ($0,0$) or Set ($1,0$) $\implies S=\text{Don't Care}, R=0$ |

---

# 3. D Latches (Data / Delay)

A **D Latch** (where **D** stands for **Data** or **Delay**) is designed to overcome the major disadvantage of an SR Latch: the **invalid/forbidden state** ($S=1, R=1$).

---

## 3.1 Basic D Latch Concept

In an SR Latch, the forbidden state occurs when both $S$ and $R$ are simultaneously $1$. To prevent this:
- We use a single input line **$D$**.
- We connect $D$ directly to the Set input ($S = D$) and its inverse $\bar{D}$ via a NOT gate to the Reset input ($R = \bar{D}$).

$$ S = D \quad \text{and} \quad R = \bar{D} $$

Since $S$ and $R$ are always exact complements, the condition $S = 1, R = 1$ is **physically impossible**.

---

## 3.2 Gated D Latch (Transparent Latch)

A **Gated D Latch** adds an **Enable ($E$)** signal to control when input $D$ is allowed to affect output $Q$.

### Circuit Schematic

![[Pasted image 20260802194457.png]]

### Truth Table (Gated D Latch)

| Enable ($E$) | Data ($D$) | Next State ($Q_{next}$) | $\bar{Q}_{next}$ |              State Description               |
| :----------: | :--------: | :---------------------: | :--------------: | :------------------------------------------: |
|    **0**     |   **X**    |           $Q$           |    $\bar{Q}$     | **Disabled / Hold** (Remembers previous bit) |
|    **1**     |   **0**    |          **0**          |      **1**       |            **Reset** ($Q \to 0$)             |
|    **1**     |   **1**    |          **1**          |      **0**       |             **Set** ($Q \to 1$)              |

### Key Intuition:
- When **$E = 0$**: The internal latch inputs are forced to $1, 1$ (Hold mode). Data input $D$ is completely blocked.
- When **$E = 1$**: Output $Q_{next}$ follows input $D$ directly ($Q_{next} = D$). This is why it is called a **Transparent Latch**!

---

## 3.3 Characteristic Equation & Excitation Table

### 1. Characteristic Equation
From the truth table of the Gated D Latch:

$$ \boxed{Q_{next} = E \cdot D + \bar{E} \cdot Q} $$

When enabled ($E = 1$):
$$ \boxed{Q_{next} = D} $$

---

### 2. Excitation Table (for $E=1$)
The excitation table shows the input $D$ required to achieve a desired transition ($Q \to Q_{next}$):

| Present State ($Q$) | Next State ($Q_{next}$) | Required $D$ |
| :---: | :---: | :---: |
| 0 | 0 | **0** |
| 0 | 1 | **1** |
| 1 | 0 | **0** |
| 1 | 1 | **1** |

> [!TIP]
> Notice how clean the D Latch excitation table is: Required $D$ simply equals the desired next state $Q_{next}$!

---

## 3.4 Level Transparency & Timing Parameters

### 1. Level Transparency Issue
While $E = 1$, the D Latch remains transparent. If input $D$ experiences noise, glitches, or multiple state transitions while $E=1$, all those changes will propagate immediately to output $Q$.

### 2. Timing Parameters (GATE Favorites)
To guarantee reliable state storage, input $D$ must satisfy two timing constraints relative to the falling edge of Enable ($E: 1 \to 0$):

- **Setup Time ($t_{\text{setup}}$)**: The minimum time duration that input $D$ must remain stable **before** Enable $E$ transitions from $1$ to $0$.
- **Hold Time ($t_{\text{hold}}$)**: The minimum time duration that input $D$ must remain stable **after** Enable $E$ transitions from $1$ to $0$.

> [!WARNING]
> Violating $t_{\text{setup}}$ or $t_{\text{hold}}$ causes **Metastability**—the latch output $Q$ enters an undefined intermediate voltage level between $0$ and $1$ for an unpredictable duration!

---

# 4. Edge-Triggered D Flip-Flops

---

## 4.1 Concept & Difference from D Latch

While a **D Latch** is level-sensitive and transparent whenever $E=1$, an **Edge-Triggered D Flip-Flop** (Data / Delay Flip-Flop) samples the data input $D$ **only at a split-second clock edge** ($\uparrow$ rising edge or $\downarrow$ falling edge). 

- During the steady HIGH or LOW clock phase, the D Flip-Flop is completely **non-transparent** and ignores any variations at input $D$.
- Physical Construction: Built either using Master-Slave D latches or 6-NAND gate edge-detector circuits.

### Circuit Symbol

![[Pasted image 20260802224220.png]]

---

## 4.2 Truth Table & Symbol

### Positive (Rising) Edge-Triggered D Flip-Flop

| Clock ($CLK$) | Data ($D$) | Next State ($Q_{next}$) | $\bar{Q}_{next}$ | State Description |
| :---: | :---: | :---: | :---: | :---: |
| 0 | X | $Q$ | $\bar{Q}$ | **Hold** (Clock steady LOW) |
| 1 | X | $Q$ | $\bar{Q}$ | **Hold** (Clock steady HIGH) |
| $\downarrow$ | X | $Q$ | $\bar{Q}$ | **Hold** (Falling edge ignored) |
| **$\uparrow$** | **0** | **0** | **1** | **Reset** ($Q \to 0$) |
| **$\uparrow$** | **1** | **1** | **0** | **Set** ($Q \to 1$) |

---

## 4.3 Characteristic Equation & Excitation Table

### 1. Characteristic Equation
For an edge-triggered D Flip-Flop at the sampling edge:

$$ \boxed{Q_{next} = D} $$

---

### 2. Excitation Table
The excitation table specifies the required $D$ input at the clock edge to achieve a desired transition ($Q \to Q_{next}$):

| Present State ($Q$) | Next State ($Q_{next}$) | Required $D$ |
| :---: | :---: | :---: |
| 0 | 0 | **0** |
| 0 | 1 | **1** |
| 1 | 0 | **0** |
| 1 | 1 | **1** |

---

# 5. T Flip-Flops (Toggle)

---

## 5.1 Concept & Circuit Realization

A **T Flip-Flop** (where **T** stands for **Toggle**) is a 1-input single-bit memory element designed specifically for state toggling and frequency division.

### How to Build a T Flip-Flop:
1. **From a JK Flip-Flop**: Tie inputs $J$ and $K$ together $\implies J = K = T$.

![[Pasted image 20260802224410.png | 500]]

2. **From a D Flip-Flop**: Feed back output $Q$ through an XOR gate with input $T \implies \boxed{D = T \oplus Q}$.

![[Pasted image 20260802224320.png|500]]

---

## 5.2 Truth Table & State Analysis

### Positive Edge-Triggered T Flip-Flop

| Clock ($CLK$) | Toggle ($T$) | Next State ($Q_{next}$) | $\bar{Q}_{next}$ | State Description |
| :---: | :---: | :---: | :---: | :---: |
| 0, 1 | X | $Q$ | $\bar{Q}$ | **Hold** (Clock steady) |
| **$\uparrow$** | **0** | **$Q$** | **$\bar{Q}$** | **No Change / Hold** ($Q \to Q$) |
| **$\uparrow$** | **1** | **$\bar{Q}$** | **$Q$** | **Toggle** ($Q \to \bar{Q}$) |

---

## 5.3 Characteristic Equation & Excitation Table

### 1. Characteristic Equation
From the truth table:

$$ \boxed{Q_{next} = T \oplus Q = T\bar{Q} + \bar{T}Q} $$

---

### 2. Excitation Table
The excitation table shows the input $T$ required to cause a state transition ($Q \to Q_{next}$):

| Present State ($Q$) | Next State ($Q_{next}$) | Required $T$ | Explanation |
| :---: | :---: | :---: | :--- |
| 0 | 0 | **0** | No state change $\implies T=0$ |
| 0 | 1 | **1** | State toggles $0 \to 1 \implies T=1$ |
| 1 | 0 | **1** | State toggles $1 \to 0 \implies T=1$ |
| 1 | 1 | **0** | No state change $\implies T=0$ |

> [!TIP]
> Notice that for a T Flip-Flop:
> $$ \boxed{T = Q \oplus Q_{next}} $$
> If present state $Q$ and next state $Q_{next}$ are different $\implies T=1$. If they are the same $\implies T=0$.

---

## 5.4 Frequency Division Property ($f_{out} = f_{in} / 2$)

When input $T$ is permanently tied HIGH ($T=1$), the T Flip-Flop toggles its output on **every active clock edge**.

- Two active clock edges ($2$ clock cycles) are required for output $Q$ to complete **one full $0 \to 1 \to 0$ period**.
- Therefore, the output frequency $f_{out}$ is exactly **half** of the input clock frequency $f_{in}$:

$$ \boxed{f_{out} = \frac{f_{in}}{2}} $$

> [!NOTE]
> Cascading $N$ T-flip-flops in series divides the input clock frequency by $2^N$:
> $$ f_{\text{final}} = \frac{f_{in}}{2^N} $$
> This is the fundamental operating principle behind **Asynchronous Binary Ripple Counters**!

---

# 6. JK Flip-Flops & Race-Around Condition

---

## 6.1 Motivation & Circuit Logic

In an SR Latch/Flip-Flop, the input combination $S=1, R=1$ is invalid because it forces $Q = \bar{Q} = 0$ (or $1$). 

The **JK Flip-Flop** (named after Jack Kilby) resolves this limitation by feeding back output lines $Q$ and $\bar{Q}$ into steering NAND/AND gates at the inputs:
- $J$ acts as the **Set** input ($S = J \cdot \bar{Q}$).
- $K$ acts as the **Reset** input ($R = K \cdot Q$).

### Circuit Schematic

![[Pasted image 20260802222524.png|500]]

---

## 6.2 Truth Table & State Analysis

When $J=1$ and $K=1$, the feedback forces the flip-flop to invert its current state—this is called **Toggling** ($Q_{next} = \bar{Q}$).

| $J$ | $K$ | Next State ($Q_{next}$) | $\bar{Q}_{next}$ | State Description |
| :---: | :---: | :---: | :---: | :---: |
| 0 | 0 | $Q$ | $\bar{Q}$ | **No Change / Memory (Hold)** |
| 0 | 1 | 0 | 1 | **Reset State** ($Q \to 0$) |
| 1 | 0 | 1 | 0 | **Set State** ($Q \to 1$) |
| 1 | 1 | $\bar{Q}$ | $Q$ | **Toggle State** ($Q \to \bar{Q}$) |

---

## 6.3 Characteristic Equation & Excitation Table

### 1. Characteristic Equation
Constructing a 3-variable K-Map for $Q_{next}(J, K, Q)$:

$$ \boxed{Q_{next} = J\bar{Q} + \bar{K}Q} $$

---

### 2. Excitation Table
The **excitation table** specifies the required $J, K$ inputs to achieve a desired state transition ($Q \to Q_{next}$):

| Present State ($Q$) | Next State ($Q_{next}$) | Required $J$ | Required $K$ | Explanation / Derivation |
| :---: | :---: | :---: | :---: | :--- |
| 0 | 0 | **0** | **X** | Can be Hold ($0,0$) or Reset ($0,1$) $\implies J=0, K=\text{Don't Care}$ |
| 0 | 1 | **1** | **X** | Can be Set ($1,0$) or Toggle ($1,1$) $\implies J=1, K=\text{Don't Care}$ |
| 1 | 0 | **X** | **1** | Can be Reset ($0,1$) or Toggle ($1,1$) $\implies J=\text{Don't Care}, K=1$ |
| 1 | 1 | **X** | **0** | Can be Hold ($0,0$) or Set ($1,0$) $\implies J=\text{Don't Care}, K=0$ |

> [!TIP]
> Notice the symmetry of the JK excitation table!
> - $0 \to 0: (0, \text{X})$
> - $0 \to 1: (1, \text{X})$
> - $1 \to 0: (\text{X}, 1)$
> - $1 \to 1: (\text{X}, 0)$

---

## 6.4 The Race-Around Condition

The **Race-Around Condition** is a critical flaw that occurs in **level-triggered** JK Flip-Flops (or latches).

Conditions for race condition - 
1. Level triggered JK Flip-Flops
2. i/p is $J=1$ and $K=1$
3. $t_{\text{high}} > t_{ff}$, clock pulse remains HIGH for a duration that is longer than the propagation delay

### Definition & Mechanism
When $J=1$ and $K=1$, the flip-flop is in **Toggle mode**. If the clock pulse remains **HIGH** ($CLK=1$) for a duration $t_{\text{high}}$ that is **longer than the propagation delay** of the flip-flop ($t_{ff}$):

$$ \boxed{t_{\text{high}} > t_{ff}} $$

1. At $t=0$, $Q=0$. Input $J=1, K=1$ causes $Q$ to toggle to $1$ after delay $t_{ff}$.
2. Since $CLK$ is *still* HIGH, this new output $Q=1$ feeds back to the input, causing $Q$ to toggle back to $0$ after another delay $t_{ff}$.
3. $Q$ continues toggling wildly ($0 \to 1 \to 0 \to 1 \dots$) for as long as $CLK=1$.
4. At the end of $t_{\text{high}}$, the final output state $Q$ is **unpredictable** (depends on whether the number of toggles was even or odd)!

![[Pasted image 20260802222638.png]]

### Conditions for Race-Around to Occur:
1. $J = 1$ and $K = 1$ (Toggle mode).
2. Level-triggered clock is HIGH ($CLK=1$).
3. Clock HIGH duration exceeds flip-flop propagation delay ($t_{\text{high}} > t_{ff}$).

### Remedies to Prevent Race-Around:
1. **Reduce Clock Pulse Width**: Make $t_{\text{high}} < t_{ff}$ (hard to achieve in physical ICs because $t_{ff}$ is extremely small, ~picoseconds).
2. **Use Edge Triggering**: Sample data only at the instantaneous clock edge ($\uparrow$ or $\downarrow$), so $t_{\text{high}}$ becomes effectively zero.
3. **Use Master-Slave Configuration**: Use a **Master-Slave JK Flip-Flop** (the classic hardware solution).

---

# 7. Master-Slave Flip-Flops

---

## 7.1 Master-Slave Operating Principle

A **Master-Slave Flip-Flop** cascades two level-sensitive latches in series:
1. **Master Latch**: Driven directly by the main clock signal $CLK$.
2. **Slave Latch**: Driven by the inverted clock signal $\overline{CLK}$ (or inverter output).

```
          +--------------+             +--------------+
Inputs -->| Master Latch |--> Y (Qm) ->| Slave Latch  |--> Q (Output)
          | (Active CLK) |             | (Active ~CLK)|
          +--------------+             +--------------+
                 ^                            ^
                 |                            |
       CLK ------+------------------[NOT]-----+
```

### Key Operating Property:
Since Master and Slave are driven by complementary clock signals, **both latches are NEVER active at the same time**!
- When $CLK = 1$: Master is **enabled** (samples inputs), Slave is **disabled** (locked).
- When $CLK = 0$: Master is **disabled** (locked), Slave is **enabled** (passes Master's state to output $Q$).

---

## 7.2 Master-Slave D Flip-Flop

A Master-Slave D Flip-Flop turns level-sensitive D-latches into a **Negative Edge-Triggered ($\downarrow$) D Flip-Flop**.

![[Pasted image 20260802222714.png]]

### Sequence of Events across a Clock Cycle:
1. **While $CLK = 1$**: Master latch is enabled and follows input $D$ ($Y = D$). Slave latch is disabled ($CLK=0$ for Slave), so output $Q$ remains unchanged.
2. **At Falling Edge ($CLK: 1 \to 0$)**: 
   - Master latch becomes disabled, locking the instantaneous value of $D$ present right before the falling edge into intermediate node $Y$.
   - Slave latch becomes enabled, passing node $Y$ directly to final output $Q$.
3. **While $CLK = 0$**: Master is locked, so changes at input $D$ cannot reach $Y$ or $Q$.

Thus, the output $Q$ updates **only at the falling edge ($\downarrow$) of $CLK$**:
$$ \boxed{Q_{\text{next}} = D} \quad \text{sampled at } \downarrow \text{ edge} $$

---

## 7.3 Master-Slave JK Flip-Flop

The **Master-Slave JK Flip-Flop** completely eliminates the **Race-Around Condition**.

![[Pasted image 20260802222817.png]]
### How Master-Slave Eliminates Race-Around:
- When $J=1, K=1$ and $CLK=1$:
  1. Master receives feedback from Slave output $Q$. Since Master is enabled, it toggles **once** ($Y = \bar{Q}$).
  2. Because $CLK=1$, the Slave is **disabled** ($\overline{CLK}=0$). Output $Q$ cannot change while $CLK=1$.
  3. Therefore, the feedback to the Master cannot change while $CLK=1$, preventing multiple toggles!
  4. On the falling edge ($CLK: 1 \to 0$), Master locks $Y$, and Slave passes $Y$ to final output $Q$.

The output toggles **exactly once per clock cycle**, regardless of how long $t_{\text{high}}$ lasts!

---

# 8. Roadmap & Future Expansion (Registers & Counters)

*This note will be continuously expanded as we study further topics in Sequential Circuits:*

- [ ] **Flip-Flop Conversions**: Systematic method to convert any Flip-Flop type $A$ to type $B$ using excitation tables.
- [ ] **Registers & Shift Registers**: SISO, SIPO, PISO, PIPO, Universal Shift Register, Ring Counter, Johnson Counter.
- [ ] **Synchronous & Asynchronous Counters**: Ripple counters, Modulo-$N$ counters, state transition diagrams, and lock-out condition resolution.

---

# 9. GATE PYQ-Style Solved Questions

^q1
<h6 class="question">Q1) A cross-coupled NAND latch has inputs \bar{S} = 0 and \bar{R} = 1. What are the outputs Q and \bar{Q}?</h6>

<u>Sol</u>$^n$ -
Recall the NAND SR Latch active-low input rules:
- Inputs are $\bar{S}=0$ and $\bar{R}=1$.
- Since $\bar{S} = 0$ (active low Set signal is triggered), the latch enters the **Set state**.
- Output $Q = 1$ and $\bar{Q} = 0$.

$$ \boxed{Q = 1, \bar{Q} = 0} $$

---

^q2
<h6 class="question">Q2) What happens to an active-high SR NOR latch if both inputs S = 1 and R = 1 are applied simultaneously, and then both inputs change to S = 0 and R = 0 at the exact same instant?</h6>

<u>Sol</u>$^n$ -
1. When $S=1$ and $R=1$ are applied to a NOR latch:
   - Top NOR gate: $Q = \overline{R + \bar{Q}} = \overline{1 + \bar{Q}} = 0$.
   - Bottom NOR gate: $\bar{Q} = \overline{S + Q} = \overline{1 + 0} = 0$.
   - Outputs become $Q=0$ and $\bar{Q}=0$ (violating the complementary output property).
2. When inputs simultaneously drop to $S=0, R=0$:
   - Both NOR gates see inputs $(0, 0)$ and try to output $1$ at the same time.
   - The final state depends on microscopic gate propagation delay differences. This creates an unpredictable **race condition** / metastable state.

$$ \boxed{\text{Forbidden State } (Q=\bar{Q}=0) \text{ followed by a Race Condition / Metastable State}} $$

---

^q3
<h6 class="question">Q3) A Gated D Latch has its Enable input E connected to a clock signal of frequency 1 MHz with a 50% duty cycle. If input D is held constant at 1, for how long in each clock cycle is the output Q transparent to input D?</h6>

<u>Sol</u>$^n$ -
1. Clock period $T = \frac{1}{f} = \frac{1}{1 \times 10^6\text{ Hz}} = 1 \mu\text{s} = 1000\text{ ns}$.
2. With a 50% duty cycle, the clock / Enable signal $E$ is HIGH ($E=1$) for half the period:
   $$ t_{\text{HIGH}} = 0.5 \times 1000\text{ ns} = 500\text{ ns} $$
3. Since a Gated D Latch is transparent whenever $E=1$, output $Q$ is transparent for **500 ns** in each 1000 ns clock cycle.

$$ \boxed{t_{\text{transparent}} = 500\text{ ns}} $$

---

^q4
<h6 class="question">Q4) A JK flip-flop has propagation delay t_{ff} = 10 ns. It is driven by a clock signal of frequency f = 20 MHz with a 50% duty cycle. If inputs are held at J = 1 and K = 1, will the race-around condition occur?</h6>

<u>Sol</u>$^n$ -
1. Calculate Clock Period $T$:
   $$ T = \frac{1}{f} = \frac{1}{20 \times 10^6\text{ Hz}} = 50\text{ ns} $$
2. Calculate Clock HIGH pulse width $t_{\text{high}}$ (50% duty cycle):
   $$ t_{\text{high}} = 0.5 \times 50\text{ ns} = 25\text{ ns} $$
3. Compare $t_{\text{high}}$ with propagation delay $t_{ff} = 10\text{ ns}$:
   $$ t_{\text{high}} (25\text{ ns}) > t_{ff} (10\text{ ns}) $$
4. Since $t_{\text{high}} > t_{ff}$ under $J=1, K=1$, the output will toggle $\lfloor 25/10 \rfloor = 2$ times during the single HIGH pulse $\implies$ **Race-Around Condition WILL occur**.

$$ \boxed{\text{Race-Around Condition = YES } (t_{\text{high}} = 25\text{ ns} > t_{ff} = 10\text{ ns})} $$

---

^q5
<h6 class="question">Q5) A cascade of 4 positive-edge-triggered T flip-flops, each with T = 1, is driven by a 16 MHz clock. What is the frequency of the output signal of the 4th flip-flop?</h6>

<u>Sol</u>$^n$ -
1. Recall the frequency division property of a T flip-flop with $T=1$:
   - Each T flip-flop divides input frequency by $2 \implies f_{\text{out}} = f_{\text{in}} / 2$.
2. For $N = 4$ cascaded T flip-flops:
   $$ f_{\text{final}} = \frac{f_{\text{in}}}{2^N} = \frac{16\text{ MHz}}{2^4} = \frac{16\text{ MHz}}{16} = 1\text{ MHz} $$

$$ \boxed{f_{\text{final}} = 1\text{ MHz}} $$


