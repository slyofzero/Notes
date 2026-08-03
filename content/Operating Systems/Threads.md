>[!SUMMARY] Table of Contents
>- [[Threads#Overview & Core Definitions|Overview & Core Definitions]]
>	- [[Threads#Process vs Thread|Process vs Thread]]
>	- [[Threads#Memory Sharing Example|Memory Sharing Example]]
>- [[Threads#Thread Memory Layout & Resource Sharing|Thread Memory Layout & Resource Sharing]]
>- [[Threads#Types of Threads: ULT vs KLT|Types of Threads: ULT vs KLT]]
>- [[Threads#Multithreading Mapping Models|Multithreading Mapping Models]]
>	- [[Threads#1. Many-to-One Model|1. Many-to-One Model]]
>	- [[Threads#2. One-to-One Model|2. One-to-One Model]]
>	- [[Threads#3. Many-to-Many Model|3. Many-to-Many Model]]
>- [[Threads#Thread Lifecycle & Cancellation|Thread Lifecycle & Cancellation]]
>- [[Threads#GATE Practice Questions|GATE Practice Questions]]

A **thread** is the smallest dispatchable unit of execution inside an operating system process. Multithreading allows a single program to execute multiple execution streams concurrently within a shared address space.

# Overview & Core Definitions

A **thread** (often called a **lightweight process (LWP)**) is an execution stream within a process. Multiple threads can exist within a single process, all sharing the process's address space, code, data, heap, and open OS resources.

## Process vs Thread

- **Process**: A heavy, independent execution environment with its own isolated address space, PCB, and system resources.
- **Thread**: A light execution stream inside a process. Threads of the same process share memory but maintain their own execution state (Register Set, Program Counter, and Stack).

## Memory Sharing Example

Consider a memory address `0xffe84264`:
- **Two distinct processes** examining `0xffe84264` will access **different physical memory contents** because each process has its own isolated virtual address space.
- **Two threads of the same process** examining `0xffe84264` will access the **exact same memory contents** because they share a single address space.

---

# Thread Memory Layout & Resource Sharing

Each process owns the Code, Data, Heap, and File Descriptors. Threads running inside that process share all of these global components, but each thread receives its own private stack and register context to maintain independent execution flows.

| Shared Among Threads (Process Level)    | Unique to Each Thread (Thread Level)                  |
| :-------------------------------------- | :---------------------------------------------------- |
| Code Section (Program instructions) | Thread ID (TID)                                   |
| Data Section (`.data` and `.bss`)   | Program Counter (PC)                              |
| Heap (Dynamic memory allocation)    | Register Set (GPRs, SP, FPRs)                     |
| OS Resources & Open Files           | Private Stack (Local variables, return addresses) |
| Global Variables & Signals          | Signal Mask & Thread Priority                     |

---

# Types of Threads: ULT vs KLT

Threads can be managed either at the user application level or directly by the operating system kernel.

| Feature | User-Level Threads (ULT) | Kernel-Level Threads (KLT) |
| :--- | :--- | :--- |
| **Management** | Created & managed by user-space thread libraries (e.g., POSIX `pthread`, Java threads) without kernel knowledge. | Created & managed directly by the Operating System Kernel. |
| **Kernel Awareness** | Kernel is unaware of ULTs; views the entire process as a single unit of execution. | Kernel is fully aware of each thread individually. |
| **Context Switch Speed** | Very fast (no kernel trap or mode bit switch required). | Slower (requires kernel trap and user-to-kernel mode switch). |
| **Blocking System Calls** | **If one ULT makes a blocking system call, the kernel blocks the entire process.** | If one KLT blocks, the kernel can schedule another KLT from the same process to run. |
| **Multiprocessor Utilization** | Cannot take advantage of multiple CPU cores concurrently (process runs on 1 core). | Can schedule individual threads of a process onto multiple CPU cores simultaneously. |
| **Portability** | Highly portable; runs on any OS supporting the thread library. | OS-dependent; relies on specific OS kernel thread implementation. |

---

# Multithreading Mapping Models

Multithreading models define how **User-Level Threads (ULT)** are mapped to **Kernel-Level Threads (KLT)**.

## 1. Many-to-One Model
- **Concept**: Maps multiple User-Level Threads to a single Kernel-Level Thread.
- **Thread Management**: Done entirely in user space.
- **Pros**: Very fast thread creation and context switching.
- **Cons**: 
  - Entire process blocks if one thread makes a blocking system call.
  - Cannot run threads in parallel on multiprocessor systems.

## 2. One-to-One Model
- **Concept**: Maps each User-Level Thread to its own dedicated Kernel-Level Thread.
- **Pros**: 
  - High concurrency; if one thread blocks, others continue executing.
  - Full utilization of multiprocessor/multicore systems.
- **Cons**: Creating a user thread requires creating a corresponding kernel thread, creating kernel resource overhead (most modern OS like Linux and Windows use this model with limits).

## 3. Many-to-Many Model
- **Concept**: Multiplexes $M$ User-Level Threads onto $N$ Kernel-Level Threads, where $M \ge N$.
- **Pros**: Combines the best of both worlds — high concurrency with bounded kernel overhead.
- **Cons**: Complex to implement in OS thread schedulers.

---

# Thread Lifecycle & Cancellation

## Thread Cancellation
Thread cancellation involves terminating a thread before it has completed its execution (e.g., stopping a web crawler thread once the target page is found).

1. **Asynchronous Cancellation**: One thread immediately terminates the target thread.
   - *Risk*: If the target thread is holding a shared resource/lock, resources may not be freed properly.
2. **Deferred Cancellation**: The target thread periodically checks a cancellation flag and terminates itself cleanly at designated **cancellation points**.

---

# GATE Practice Questions

<h6 class="question">Q1) Which of the following components is NOT shared among threads of the same process?</h6>

(A) Code Segment  
(B) File Descriptors  
(C) Program Counter  
(D) Heap Memory  

<u>Sol</u>$^n$ - **(C) Program Counter**  
Each thread must maintain its own execution pointer (Program Counter) and register set to execute independently. Code, File Descriptors, and Heap are shared across all threads of the same process.

---

<h6 class="question">Q2) A multithreaded application uses User-Level Threads (ULT). If one thread executes a blocking read() system call, what happens to the remaining threads of that process?</h6>

<u>Sol</u>$^n$ - Because the kernel is unaware of User-Level Threads, it sees only the single parent process. When one ULT makes a blocking system call, the kernel puts the entire process into the **Blocked/Waiting** state, preventing all other user threads of that process from executing until the I/O completes.
