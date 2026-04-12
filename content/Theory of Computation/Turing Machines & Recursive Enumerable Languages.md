# Turing Machines
A Turing machine has -
1. Infinite length tape
2. Turnaround capability
3. Read-Write capability

 Mathematically, a pushdown automata is a septuple $(Q, \Sigma, q_0, F, B, \Gamma, \delta)$, where -
1. $Q$ : Finite set of all states
2. $\Sigma$ : Input alphabet
3. $q_0$ : Starting state of the machine
4. $F$ : Set of all final/accepting states, $F \subseteq Q$
5. $B$: Blank Symbol
6. $\Gamma$ : Tape alphabet
7. $\delta$ : Transition Function $Q \times \Gamma \rightarrow Q \times \Gamma \times \{L,R\}$, where $L,R$ means the moving direction (left or right)
## Type of Turing Machines
### Language Recognizer
- By reading the input string, the Turing Machine may or may not halt.
- By reading $X$ if the Turing Machine halts in a final state then $X$ is accepted.
- By reading $X$ if the Turing Machine halts in a non-final state then $X$ is rejected.
- By reading $X$ if the Turing Machine halts enters into an infinite loop then can't say about the input.
### Halting Turing Machine
Will always halt. 
- If it halts in a final state then the language is accepted.
- If it halts in a non-final state then the language is rejected.

The languages accepted by this fall under the **"Turing decidable languages"** class. 
### Turing Machine (Non-halting)
Can loop forever for strings that are not part of the language. Such languages are called as **Turing recognizable languages** or **Type-0 languages**.

No Turing machine exists for Non-Recursive Enumerable Language.