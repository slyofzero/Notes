>[!SUMMARY] Table of Contents
>- [[Process Management#Operating System|Operating System]]
>- [[Process Management#Types of OS|Types of OS]]
>	- [[Process Management#Uni-Programming OS|Uni-Programming OS]]
>	- [[Process Management#Multi-Programming OS|Multi-Programming OS]]
>	- [[Process Management#Multitasking OS|Multitasking OS]]
>	- [[Process Management#Multiuser OS|Multiuser OS]]
>	- [[Process Management#Multiprocessing OS|Multiprocessing OS]]
>	- [[Process Management#Realtime OS|Realtime OS]]
>	- [[Process Management#Embedding System|Embedding System]]
>	- [[Process Management#Handheld OS|Handheld OS]]
>- [[Process Management#System Call|System Call]]
>- [[Process Management#Dual Mode of Operation|Dual Mode of Operation]]
>- [[Process Management#Parts of OS|Parts of OS]]
>- [[Process Management#Program vs Processes|Program vs Processes]]
>	- [[Process Management#Program|Program]]
>	- [[Process Management#Process|Process]]
>		- [[Process Management#Process Definition|Process Definition]]
>		- [[Process Management#Process Representation|Process Representation]]
>		- [[Process Management#Process Operations|Process Operations]]
>		- [[Process Management#Process Attributes|Process Attributes]]
>			- [[Process Management#Context Switching|Context Switching]]
>			- [[Process Management#Process States|Process States]]
>			- [[Process Management#Scheduling Queues and Scheduler|Scheduling Queues and Scheduler]]
>				- [[Process Management#Degree of Multi-Programming for Schedulers|Degree of Multi-Programming for Schedulers]]
# Operating System
An **operating system (OS)** is system software that manages computer hardware and software resources, acting as an intermediary between users and the computer.

**Core functions:**
- **Process management** – runs and schedules programs
- **Memory management** – allocates RAM to applications
- **File system management** – organizes data on storage devices
- **Device management** – communicates with hardware via drivers
- **Security & access control** – manages user permissions
# Types of OS
The different types of OS are -
1. Uni-programming OS
2. Multi-programming OS
3. Multitasking OS (Time Sharing)
4. Multiprocessing OS
5. Multiuser OS
6. Real Time OS
7. Embedded OS
8. Handheld Device OS
## Uni-Programming OS
An OS which allows only one program to be present in the main memory at a time.
## Multi-Programming OS
An OS which allows multiple programs to be present in the main memory at a time. The number of programs allowed in the memory memory at a time is called the **degree of multi-programming**.

Types of multi-programming OS -
1. Non-preemptive - If a program runs on the CPU, then it can leave the CPU only when it wants. The OS can't kick the program out of the CPU.
2. Preemptive - If a program runs on the CPU, the OS can kick it out of the CPU to allow some other program to run.
## Multitasking OS
An extension of Multi-programming OS in which processes are executed in a round-robin manner.
## Multiuser OS
It is used on a Computer System which can be used by multiple users concurrently.
## Multiprocessing OS
Used on computers with multiple processors (CPUs).

Types of multiprocessing OS -
1. Tightly Coupled - All processes use the same main memory.
2. Loosely Coupled - All processes have their own dedicated main memory.
## Realtime OS
Works on real time data and event. Each process has a deadline. How this process deadline is managed depends on what type of Realtime OS the system has -

1. Soft - Processes don't need to adhere to the deadlines strictly.
2. Hard - Processes need to adhere to the deadlines strictly.
## Embedding System
A miniature OS that is used on devices that are not your multi-purpose customers, eg - ACs, Fridges, Cars, Washing Machines, etc.
## Handheld OS
OS used on hand-held devices like mobiles phones, tablets, hand-held consoles like Nintendo Switch, etc.
# System Call
A system call is a method for programs to interact with the Operating System.
- Programs by default aren't provided permissions to interact with the hardware directly.  They instead rely on System Calls for this interaction.
- Such operations are usually "privileged operations" that only the Operating system can execute.
# Dual Mode of Operation
Operating systems need to protect themselves and system resources from faulty or malicious user programs. To achieve this, modern CPUs support **dual mode operation** — the hardware can run in one of two modes -
1. **User Mode** - Programs run with restricted privileges and cannot access the hardware directly.
2. **Kernel Mode** - The OS kernel runs here with full access to all hardware and instructions.

The **mode bit** is used to keep track of this mode. It is a  single bit in the CPU's status register (e.g., the [[Instructions and Addressing Modes|PSW — Program Status Word]]) which indicates the current mode.
- 1 means User Mode
- 0 means Kernel Mode

![[Pasted image 20260415142527.png]]
# Parts of OS
1. Kernel - The core of the OS. Runs in kernel mode and manages everything — CPU, memory, devices, and processes. All other parts depend on it.
2. Shell - The interface for users to interact with the OS — either a **CLI** (bash, cmd) or a **GUI** (Windows, macOS desktop).
# Program vs Processes
## Program
- A **static** set of instructions stored on disk (an executable file like `.exe` or `.out`)
- Just a **passive** entity — it does nothing on its own
- Exists in **secondary storage**
- One copy exists on disk
## Process
- A **program in execution** — an active, running instance
- Has its own **memory space, CPU state, and resources**
- Exists in **RAM**
- One program can spawn **multiple processes** (e.g., opening Chrome twice = 2 processes)

Types of processes -
1. CPU Bound - Process is intensive in terms of CPU operations
2. IO Bound - Process is intensive in terms of IO operations

A Process can be thought of as a data structure with four components to it -
1. Definition
2. Representation/Implementation
3. Operations
4. Attributes
### Process Definition
The program or the set of instructions for that process are its definition
### Process Representation
Each process is stored in memory in four sections -
1. Code (text) section - Contains the program instructions. 
2. Data section - Stores all global, static variables.
3. Heap - Allows for dynamic memory allocation during runtime.
4. Stack - Keeps activation records of the program which stores all local variables, function parameters, return address, etc.

![[Pasted image 20260415151613.png]]

The code section and data section are of fixed size, while the heap and stack are of dynamic size.
- The additional space between the stack and the heap represents the extra memory both have access to.
- There exists a logical divider which signifies which portion is the heap and which portion is the stack, so neither can grow indefinitely.
- If either the stack or heap grow to such sizes that they intrude into each other's area, that's an **overflow**. Either a **stack overflow or heap overflow**.
### Process Operations
Actions performed by the OS to manage processes.

**Main operations:**
- **Create:** New process is created (e.g., `fork`, `exec`)
- **Terminate:** Process finishes or is killed
- **Suspend:** Temporarily paused
- **Resume:** Continued after suspension
- **Block/Wait:** Waiting for I/O or event
- **Wakeup:** Moves from waiting → ready
- **Context Switch:** CPU switches between processes

**Purpose:**
- Control execution and resource usage of processes
### Process Attributes
The **PCB** (**Process Control Block** also known as **process descriptor**) is used to store the various attributes corresponding to any OS process. 
- The OS keeps the PCB for every process with it for process management + context switching.
- OS saves/restores process state using PCB.
- The content of the PCB of a process goes into the CPU registers to run that process.

Some attributes stored in the PCB are -
1. PID (Process ID) - Unique identifier for each process.
2. PC (Program Counter) - Address of next instruction to execute.
3. GPR (General Purpose Register) - CPU register values saved/restored during context switch.
4. List of Devices - Devices allocated
5. Type - Process category
6. Size - Memory required by the process
7. Memory Limits - Boundaries of address space
8. Priority - Scheduling importance
9. State - Current status (new, ready, running, waiting, terminated)
10. List of Files - Open files and file descriptors associated with the process
#### Context Switching
The values stored inside the PCB are referred too as the **context of that process**.
- The method of bringing the context of a process to the CPU and switching it with the existing context is called as **context switching**.
#### Process States
The current activity the process is performing.

![[Pasted image 20260415162301.png]]

The states of a process are -
1. **New** - All installed processes. (Not in memory yet)
2. **Ready** - All processes which are waiting to run on CPU. (Brought to memory)
3. **Running** - All processes running in the CPU.
4. **Blocked** - All processes which are waiting for an I/O or event.
5. **Terminated** - A completed process (Removed from memory)

When dealing with multiple processes in Multiprogramming or Multitasking OS we need to schedule the processes to run one after another.
- The scheduler is a component of the OS that selects which process to run on the CPU.
- The dispatcher is a component of the OS which performs context-switching (brings and kicks processes from the CPU).

State transitions - 
1. **New** - Only Ready.
2. **Ready** - A scheduler will run this process, thus making its state as Running.
3. **Running** - By itself it can only go to Terminated or Waiting. 
	- If the OS is preemptive, then due to preemption it can go to Ready as well.
4. **Waiting** - Only upon receiving an I/O or event will it move back to Ready.
5. **Terminated** - None
#### Scheduling Queues and Scheduler
Scheduling Queues keep processes in certain states -
1. Job Queue - All processes which are in new state are kept here
2. Ready Queue - All processes which are in ready state
3. Device Queue - All processes which are kept in waiting state

Schedulers -
1. Long-Term Scheduler (Job Scheduler) - Brings a process from new state to ready state
2. Short-Term Scheduler (CPU Scheduler) - Selects one of the ready processes to run on CPU ^0ee500
3. Mid-Term Scheduler (Medium Term) - Responsible for freeing up space in your memory to allow for new processes, in cases where the memory is fully utilized.
	- The PCB for this process stays in the memory with the OS, just the process itself is removed from the memory and sent to the secondary memory. This functionality is called **swapping out**.
	- Once the main memory again has enough space, the swapped out process is brought back from the secondary memory to the main memory. This functionality is called **swapping in**.
	- Only processes in Ready or Blocked state are swapped out.

Updated process state transition diagram -

![[Pasted image 20260421144616.png]]

New states -
- Suspended Ready - Processes in Ready state that are swapped out enter this state.
- Suspended Block - Processes in Waiting/Blocked state that are swapped out enter this state.
##### Degree of Multi-Programming for Schedulers
1. **Long-Term Schedulers** - Because it brings processes to the memory, it increases the degree of multi-programming.
2. **Short-Term Schedulers** - It doesn't bring or remove processes from the memory, thus it doesn't affect the degree of multi-programming.
3. **Mid-Term Scheduler (Medium Term)** - Because it both removes and brings processes to the memory, it can increase and decrease the degree of multi-programming.