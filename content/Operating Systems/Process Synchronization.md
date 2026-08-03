>[!SUMMARY] Table of Contents
>- [[Process Synchronization#Communication b/w processes|Communication b/w processes]]
>	- [[Process Synchronization#Race Condition|Race Condition]]
>	- [[Process Synchronization#Critical Section|Critical Section]]
>		- [[Process Synchronization#Requirements for solution of the critical section problem|Requirements for solution of the critical section problem]]
>			- [[Process Synchronization#Mutual Exclusion|Mutual Exclusion]]
>			- [[Process Synchronization#Progress|Progress]]
>			- [[Process Synchronization#Bounded Waiting|Bounded Waiting]]
>		- [[Process Synchronization#2-Process Solution|2-Process Solution]]
>		- [[Process Synchronization#Peterson's Solution|Peterson's Solution]]
>- [[Process Synchronization#Synchronization Hardware|Synchronization Hardware]]

When working with communicating processes, there is a need for process synchronization to get the expected result out of them.
# Communication b/w processes
Processes are of two types -
1. Independent - Process which does not communicate with other process(s).
2. Cooperating/Communication/Coordinating

Problems caused with Synchronization -
1. Inconsistency
2. Loss of Data
3. Deadlock

The communication between processes is also called as **IPC (Inter Process Communication)**. This can be done using various methods such as -
- Pipe
- Queue
- Shared Variable
- Message Passing
## Race Condition
A race condition is an undesired scenario where processes are running concurrently while communicating together and the output of the processes depends upon the sequence in which the processes finish their execution.
- If P1 and P2 are two communicating processes, and the output of P1 and P2 differs based upon whether P1 finishes first or P2, that's a race condition.
## Critical Section
A critical section is a code segment where the shared variables can be accessed. 

More simply, not all instructions in a process communicate with another processes, only a few instructions do.
- These instructions require process synchronization and are called as the **critical section**.
- The instructions that don't require synchronization are called as the **remainder section**.
### Requirements for solution of the critical section problem
The requirements for the solution of the critical section problem are -
1. Mutual Exclusion
2. Progress
3. Bounded Waiting
#### Mutual Exclusion
If a process is executing its critical section, then the other process isn't allowed to execute its critical section. It instead waits for the first process' critical section execution to end before executing its critical section.
#### Progress
If a process wants to execute its critical section when the other process isn't executing its critical section, let it proceed.
#### Bounded Waiting
If a process is finished with executing its critical section and wishes to re-execute it while another process was in waiting, don't let it proceed. Instead let the other process execute its critical section now before allowing the first process to execute its critical section.
### 2-Process Solution
The process is split into three sections in total, the **entry section**, critical section, and **exit section**.
- We already know what the critical section is.
- The entry section implements the above three requirements for solution of the critical section problem.
- The exit section is there for announcing that the critical section's execution has completed, allowing other processes to run their critical sections.

Processes can be preempted at any point, regardless of what instruction is currently being executed. This means in the code below, if P1 and P2 are both preempted right after the `while` loop (when `lock = False`), both will proceed to their critical sections — violating Mutual Exclusion.

```c
lock = False

# P1
while(lock);   // lock is False, so P1 exits the loop — preempted here
lock = True;
// Critical section of P1
lock = False;

# P2
while(lock);   // lock is still False (P1 never set it), so P2 exits too — preempted here
lock = True;
// Critical section of P2
lock = False;
```

- Both processes passed the `while` check when `lock` was `False`, so both march into their critical sections simultaneously. This approach fails Mutual Exclusion.
- Similarly P1 would be allowed to renter the critical section even if P2 is in waiting. Thus this coded also fails Bounded Waiting as well and is therefore **not a valid solution** to the critical section problem.

Instead, a solution like the below one will fill the requirements of Mutual Exclusion and Bounded Waiting but not Progress as P2 cannot enter into critical section by itself because `turn = 0`. Even P1 wouldn't be able to enter again once its executed without the arrival of P2 in the meanwhile. In this case because there's no progress, the processes will additionally suffered from starvation of Critical Section.

```c
turn = 0

# P1
while(turn != 0);   // lock is False, so P1 exits the loop — preempted here
// Critical section of P1
turn = 1;

# P2
while(turn != 1);   // lock is still False (P1 never set it), so P2 exits too — preempted here
// Critical section of P2
turn = 0;
```
### Peterson's Solution
```c
bool flag[2] = {false, false};
int turn;

// Process P0 (i = 0, j = 1)
while (true) {
    flag[0] = true;
    turn = 1;
    while (flag[1] && turn == 1); // Busy wait
    
    // Critical Section (CS)
    
    flag[0] = false;
    
    // Remainder Section (RS)
}

// Process P1 (i = 1, j = 0)
while (true) {
    flag[1] = true;
    turn = 0;
    while (flag[0] && turn == 0); // Busy wait
    
    // Critical Section (CS)
    
    flag[1] = false;
    
    // Remainder Section (RS)
}
```

In this solution, the array `flag` tracks which process **wishes to enter** its critical section, while `turn` resolves tie-breaks and indicates **whose turn it is**.
- `flag[i]` is set to `true` by Process $i$ itself to express intention to enter CS.
- `turn = j` is set by Process $i$ to gracefully yield priority to Process $j$ if both wish to enter simultaneously.

**Property Analysis for Peterson's Solution:**
1. **Mutual Exclusion:** Guaranteed. $P_0$ and $P_1$ can only enter CS if `turn == 0` and `turn == 1` respectively, but `turn` can hold only one scalar value at any instant.
2. **Progress:** Guaranteed. If $P_1$ does not wish to enter (`flag[1] == false`), $P_0$ is never blocked.
3. **Bounded Waiting:** Guaranteed. A process exiting CS sets its `flag` to `false`, allowing the waiting process to proceed. Thus, no process waits more than 1 entry of the other process.
# Synchronization Hardware
The solutions we discussed so far were software solution to process synchronization. These can be tricky and error-prone as the processes can be preempted between any two instructions. To solve this issue we need the instructions to be atomic, and that's what synchronization hardware provides.

Hardware solves this by making read-modify-write **one uninterruptible atomic operation**.