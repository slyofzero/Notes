>[!SUMMARY] Table of Contents
>- [[CPU Scheduling#Dispatcher vs Scheduler|Dispatcher vs Scheduler]]
>- [[CPU Scheduling#Workload Model and Assumptions|Workload Model and Assumptions]]
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

# Dispatcher vs Scheduler
CPU Virtualization has two components:
- **Dispatcher (Mechanism)**: The low-level machinery that actually performs the context switch. It saves/restores registers, switches kernel stacks, and jumps to the next process.
- **Scheduler (Policy)**: The high-level algorithm/logic that decides WHICH ready process should get the CPU next.

Notice how the scheduler makes the decision; the dispatcher executes it.

# Workload Model and Assumptions
Before diving into algorithms, let's define our scheduling vocabulary:
- **Workload**: A set of job descriptions, each with an arrival time and run time.
- **Job**: The execution of an entire process (or the current CPU burst of a process that alternates between CPU and I/O, moving between ready and blocked queues).
- **Scheduler**: Logic that decides which ready job to run.
- **Metric**: Measurement of the quality of a schedule.

**Scheduling Objectives (The Fundamental Tension):**
Performance-oriented:
- Minimize turnaround time (don't want to wait long for a job to complete)
- Minimize response time (schedule interactive jobs promptly so users see output quickly)
- Maximize throughput (many jobs completed per unit time)
- Maximize resource utilization (keep expensive devices busy)
- Minimize overhead (reduce number of context switches)

Fairness-oriented:
- All jobs get the same amount of CPU over some time interval

> [!NOTE]
> There is a fundamental tension between performance and fairness.

**Simplifying Workload Assumptions:**
To study scheduling algorithms systematically, we start with 5 simplifying assumptions and progressively relax them:
1. Each job runs for the same amount of time.
2. All jobs arrive at the same time.
3. Once started, each job runs to completion (non-preemptive).
4. All jobs only use the CPU (no I/O).
5. The run-time of each job is known.

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
- **Preemptive**: The OS can interrupt and take the CPU away from a currently running process. This fundamentally requires hardware support (timer interrupts, dual mode operation, automatic register saving, and memory protection) — see [[Process Management#Hardware Support Required for Preemption and LDE|Hardware Support for Preemption]].
- **Non-preemptive**: A process keeps the CPU until it voluntarily terminates or blocks on I/O/events.
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
- Minimum average WT and TAT among **non-preemptive** scheduling algorithms. For the case where all jobs arrive simultaneously (Assumption 2), SJF is **provably optimal** for minimizing average turnaround time. The intuition is: moving a shorter job ahead of a longer job improves the short job's turnaround time MORE than it harms the long job's turnaround time.
- Better throughput in continuous execution.

Disadvantages -
- No option of preemption.
- No practical implementation because Burst Time is not known in advance.
- Longer processes can suffer from starvation.
- **Fails with staggered arrivals:** When relaxing Assumption 2 (jobs arrive at different times), SJF fails because a long job that arrived first will run to completion before short jobs that arrive slightly later — the "stuck behind a tractor again" problem.
## Shortest Remaining Time First (SRTF)
Also known as **STCF (Shortest Time-to-Completion First)** — at any point in time, always run the job that will complete the quickest. This requires relaxing Assumption 3 (allowing preemption).

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
- Better interactiveness. FIFO, SJF, and STCF can all have poor response time — because jobs must wait behind other jobs before getting their first CPU slice. RR solves this by alternating ready processes every fixed-length time slice, giving short jobs a chance to run and finish quickly even when run-times are unknown. If we don't know the run-time of each job, RR gives short jobs a chance to run and finish quickly — this observation becomes important for MLFQ.
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

![[Pasted image 20260818100823.png|489]]
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