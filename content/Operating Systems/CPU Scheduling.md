>[!SUMMARY] Table of Contents
>- [[CPU Scheduling#Scheduling Times|Scheduling Times]]
>- [[CPU Scheduling#Scheduling Algorithms|Scheduling Algorithms]]
>	- [[CPU Scheduling#First Come First Serve (FCFS)|First Come First Serve (FCFS)]]
>		- [[CPU Scheduling#Convoy Effect|Convoy Effect]]
>	- [[CPU Scheduling#Shortest Job First (SJF)|Shortest Job First (SJF)]]
>	- [[CPU Scheduling#Shortest Remaining Time First (SRTF)|Shortest Remaining Time First (SRTF)]]
>	- [[CPU Scheduling#Longest Job First (LJF) and Longest Remaining Time First (LRTF)|Longest Job First (LJF) and Longest Remaining Time First (LRTF)]]
>	- [[CPU Scheduling#Highest Response Ratio Next|Highest Response Ratio Next]]
>	- [[CPU Scheduling#Priority Based Algorithm|Priority Based Algorithm]]
>		- [[CPU Scheduling#Aging|Aging]]
>	- [[CPU Scheduling#Round Robin (RR)|Round Robin (RR)]]
>	- [[CPU Scheduling#Multilevel Queue Scheduling (MLQ)|Multilevel Queue Scheduling (MLQ)]]
>	- [[CPU Scheduling#Multilevel Feedback Queue Scheduling (MFLQ)|Multilevel Feedback Queue Scheduling (MFLQ)]]
>- [[CPU Scheduling#CPU Utilization|CPU Utilization]]
>	- [[CPU Scheduling#Without IO Operations|Without IO Operations]]
>	- [[CPU Scheduling#With IO Operations|With IO Operations]]
>- [[Threads|Threads (Multithreading)]]
>- [[CPU Scheduling#System Call|System Call]]
>	- [[CPU Scheduling#Fork system call|Fork system call]]
>	- [[CPU Scheduling#Wait |Wait ]]

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

$$
\text{RT} = \text{Time at first execution of process} - \text{AT}
$$

	- For non-preemptive algorithms, $\text{RT} = \text{WT}$.

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

Advantages -
- Easy to implement.
- No complex logic.
- No starvation (process waiting for CPU for indefinite time).

Disadvantages -
- No option of preemption.
- Convoy Effect.
### Convoy Effect
Only FCFS suffers from the **Convoy Effect**, meaning that if a process with a high Burst Time is sent to the CPU for execution, other processes that later will also get delayed regardless of their Burst Time.
## Shortest Job First (SJF)
**Scheduling Criteria -** 
- Whichever process has a smaller burst time gets scheduled first.
- If multiple processes have the same BT, then we use FCFS as tie-breaker – Meaning that we check AT and then PID to schedule jobs.

**Type of Algorithm -** Non-preemptive

Advantages -
- Minimum average WT and TAT among **non-preemptive** scheduling algorithms.
- Better throughput in continuous execution.

Disadvantages -
- No option of preemption.
- No practical implementation because Burst Time is not known in advance.
- Longer processes can suffer from starvation.
## Shortest Remaining Time First (SRTF)
**Scheduling Criteria -** 
- Whichever process has a smaller burst time gets scheduled first.
- If a new process arrives with a smaller burst time than the current process, the current process is preempted and the new process is executed. In the future, the old process only needs to run for BT-time it ran for.
- If multiple processes have the same BT, then we use FCFS as tie-breaker – Meaning that we check AT and then PID to schedule jobs.

**Type of Algorithm -** Preemptive

Advantages -
- Minimum average WT and TAT among **all** scheduling algorithms.
- Better throughput in continuous execution.

Disadvantages -
- No practical implementation because Burst Time is not known in advance.
- Longer processes can suffer from starvation.
## Longest Job First (LJF) and Longest Remaining Time First (LRTF)
Similar to SJF and SRTF, just that the processes with longest burst times are scheduled first.

Advantages -
- None

Disadvantages -
- No option of preemption. (Only for LJF)
- Suffers from Convoy Effect.
- No practical implementation because Burst Time is not known in advance.
- Longer processes can suffer from starvation.
## Highest Response Ratio Next
Not only favors short jobs but also decreases the waiting time of longer jobs.

**Scheduling Criteria -**
- Response Ratio is $\frac{W + S}{S} = 1 + \frac{W}{S}$ where $W$ is the waiting time and $S$ is the service/burst time.
- We pick the process with the highest response ratio.
- If multiple processes have the same response ratio, FCFS (Arrival Time) is used as the tie-breaker.

**Type of Algorithm -** Non-preemptive

Advantages -
- No starvation (as waiting time $W$ increases, response ratio increases, preventing starvation of long jobs).
- No Convoy Effect.

Disadvantages -
- No practical implementation because Burst Time is not known in advance.
## Priority Based Algorithm
**Scheduling Criteria -**
- Process with a higher priority is scheduled first.

**Type of Algorithm -** Can be both preemptive or non-preemptive

Advantages -
- Better response for real time situations.

Disadvantages -
- Low priority processes may suffer from starvation.
### Aging
In case of priority based algorithms, the priority can be made dynamic as well. In such cases we can introduce **aging**.

**Aging -** If a process waits for a predefined amount of time, then its priority is increased by 1. After waiting for a long amount of time the process gets executed due to a high priority.
## Round Robin (RR)
**Scheduling Criteria -**
- Arrival time + Quantum (Q)/Time slice
- Tie-breaker is again FCFS

**Important things -**
- Quantum/Time slice is the amount of time which a process runs for on the CPU.
- Even if there's one process left on the ready queue with BT > Q, we need to split it by Q width on the Gantt chart to show the context switch.
	- In the below image you can see how P2 needs to be written twice at the end because its remaining BT was 4 which is > than Q = 3.

![[Pasted image 20260522185647.png]]

**Type of Algorithm -** Preemptive

Choosing the Quantum Value is tricky.
- If Q is too large then RR will act as FCFS instead.
- If Q is too small then there will be too much context switching which would cause low interactivity.

Advantages -
- All processes are executed one by one, thus no starvation.
- Better interactiveness.
- Burst time is not required to be known in advance, thus practical.

Disadvantages -
- Average WT and TAT are larger.
- Can degrade to FCFS.
## Multilevel Queue Scheduling (MLQ)
**Scheduling Criteria -**
- Fixed priority preemptive scheduling method.
	- Every queue gets a fixed priority and processes from highest priority queue are executed first. When all processes of this queue are executed, only then the next queue's processes are executed.
	- Arrival of a process in a higher priority queue preempts the process from a lower priority queue.
- Time slicing -
	- In cases where there are too many processes on both the high and low priority queues, the process execution time is sliced such that some percentage is dedicated to the higher priority queue and the rest for the lower priority queue.
	- Eg - The time slice of 1ms is splits such that 
		- For the first 40% of the time, processes in Q1 are executed.
		- For the next 35% of the time, processes in Q2 are executed.
		- For the next 25% of the time, processes in Q3 are executed.

**Type of Algorithm -** Preemptive

![[Pasted image 20260525114024.png]]

This is an example of an MLQ where Q1 works in a round robin manner while Q2 uses FCFS.

Disadvantages -
1. Some processes may starve.
2. Inflexible in nature, meaning that processes cannot be switched between queues.
## Multilevel Feedback Queue Scheduling (MFLQ)
Extension of MLQ which allows processes to be switched between queues -
- Processes can be upgraded to a higher priority queue.
- Processes can also be degraded to a lower priority queue.
# CPU Utilization
## Without IO Operations
In case where processes are running on the CPU and none of them enter a blocked state waiting for an IO operation, we can calculate the CPU utilization by using the Gantt Chart for the processes.

$$
\text{Utilization} = \frac{\text{Total time CPU was utilized}}{\text{Total execution time}}
$$

## With IO Operations
In the case of IO operations, we'd know the probability with which a process enters the blocked state. Given $n$ processes where the probability of a process entering a blocked state is $p$, the probability of all $n$ processes entering the blocked state would be $p^n$. Thus the CPU utilization can be calculated by doing -

# Multithreading
> See the dedicated **[[Threads]]** note for comprehensive coverage on thread memory layout, ULT vs. KLT, multithreading mapping models (Many-to-One, One-to-One, Many-to-Many), and GATE practice questions.

# System Call
Programmatic way in which a computer program requests a service from the kernel.

![[Pasted image 20260526215718.png]]
## Fork system call
It creates a new process (child) that is an exact copy of the calling process (parent). It's the primary way to create processes in Unix/Linux.

With respect to calling `fork` in C -
- The child process' execution starts from the call of `fork`.
- The `fork` function returns the PID of the child process to the parent process and returns 0 to the child process it created.
- If `fork` is called $n$ time, then $2^n-1$ child processes will be created.
## Wait 
Causes the parent process to block until one of its child processes terminates. Used to reap children and collect their exit status.