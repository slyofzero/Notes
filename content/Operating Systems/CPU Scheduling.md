The function of the [[Process Management#^0ee500|Short-Term Scheduler]] is to select a process to dispatch to the CPU. In doing so, the scheduler needs to -
- Minimize Wait time and Turn-around time
- Maximize CPU utilization
- Be fair such that all processes are selected over time
# Scheduling Times
1. Arrival Time (AT) - Time at which process arrives.
2. Burst/Service Time (BT) - Amount of time a process runs on the CPU.
3. Completion Time (CT) - Time at which the process completes.
4. Turn-around Time (TAT) - The amount of time the process spends from arrival to completion. 

$$
\begin{aligned}
\text{TAT} &= \text{CT} - \text{AT} \\[8pt]
\text{TAT} &= \text{WT} + \text{BT} \\[8pt]
\end{aligned}
$$

5. Waiting Time (WT) - Amount of time the process spends in Ready state.

$$
\text{WT} = \text{TAT} - \text{BT}
$$

6. Response Time (RT) - The amount of time from arrival till the first execution.
7. Scheduling Length (L) - $\operatorname{Max}(\text{CT}_i) - \operatorname{Min}(\text{AT}_i)$
8. Throughput - Number of processes executed per unit time (Scheduling Length).

$$
\text{Throughput} = \frac{\text{No. of processes}}{\text{Scheduling Length}}
$$
# Scheduling Algorithms
CPU Scheduling Algorithms are of two types -
- Preemptive
- Non-preemptive
## First Come First Serve (FCFS)
**Scheduling Criteria -** 
- Whichever process has a smaller arrival time gets scheduled first.
- If multiple processes have the same AT, then their PID is used as tie-breaker.

**Type of Algorithm -** Non-preemptive
### Convoy Effect
Only FCFS suffers from the **Convoy Effect**, meaning that if a process with a high Burst Time is sent to the CPU for execution, other processes that later will also get delayed regardless of their Burst Time.
## Shortest Job First (SJF)
**Scheduling Criteria -** 
- Whichever process has a smaller burst time gets scheduled first.
- If multiple processes have the same BT, then we use FCFS as tie-breaker – Meaning that we AT and then PID to schedule jobs.
