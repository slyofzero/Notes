# Basic EE Background
## Hierarchy of Electronic Components
1. The final computer
2. **PCB (Printed Circuit Board)**, each PCB is made up of 8-16 ICs
3. **IC (Integrated Circuit)** or a chip/microchip, each IC is made up of 8-10 Modules
4. **Module**, each Module is made up of 1K-10K Cells
5. **Cell**, each Cell is made up of 2-16 Gates
6. **Gates**, each Gate is made up of 2-8 transistors
7. **Transistors**

![[Pasted image 20260613180529.png|550]]

## VLSI
Building a complex computer system requires managing BILLIONS of transistors. The process of creating ICs by combining millions and billions of transistors onto a single chip is called as **Very Large Scale Integration** or **VLSI**.
## How Transistors hold information
For storing information digitally, we can't rely on analogue signals we receive from the real world. These signals have no "bound" or "precision" which causes the measurements to be affected by noise, thus leading to the stored information being noisy. This makes it hard to properly quantify whether two pieces of information are truly different or not. Additionally, the analogue signals can be as high or low as possible further making the comparison between two stored values difficult.

**For example -**
Consider pixel values being stored as voltages. One pixel might hold the value 0.69879V and correspond to a grayish color while another pixel might hold the value 0.697364V and correspond to the same shade as the previous pixel. Due to a lack of "precision" the measurement of these information values both hold different information despite representing the same shade of gray. This difference in voltage value can be attributed to various causes that can simply be termed as **noise**.

To tackle this issue, the analogue signals are discretized to digital signals with a pre-determined precision, set calculably to avoid the affect of noise. This is done in two ways -
1. Setting a voltage threshold $V_T$. All voltage values below $V_T$ cause the transistor to hold the state 0 and all voltage values above $V_T$ cause it to hold the state 1.
2. Setting a **forbidden zone** using voltage thresholds $V_L$ and $V_H$.
	- Transistor holds 0 if voltage $\le V_T$
	- Transistor holds 1 if voltage $\ge V_T$
	- If $V_T \le V \le V_H$, the transistor is in the **forbidden zone** — behavior is undefined and unpredictable. This region is deliberately avoided in circuit design.