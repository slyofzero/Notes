# Multithreading
**Process** - an independent program in execution with its own memory space.
**Thread** - a lightweight unit of execution that lives _inside_ a process, sharing its memory.

Creating a replica of a program, each time its needed, will flood the memory easily. Given that a single process is made up of multiple components, a few of those components can be shared between multiple processes while the rest can be independent to each unit of execution. This is the idea of **threading**.

A process owns: code + data + heap + stack. Threads inside it each get their **own stack**, but share everything else.

| Shared among Threads | Unique for each Thread |
| :------------------- | :--------------------- |
| Code Section         | Thread ID              |
| Data Section         | Register Set           |
| OS Resources         | Stack                  |
| Open Files & Signals | Program Counter        |
| Heap                 |                        |
Advantages of multithreading -
- Better responsiveness
- Faster Context Switch
- Resource Sharing
- Economical
- Communication
- Utilization of Multiprocessor Architecture
## Types of threads
There are two types of threads - 
- **User threads -** threads that are made and managed by the process itself without the involvement of the OS.
- **Kernel threads -** threads that are managed by the OS directly.

| User threads                                                                                      | Kernel threads                                                                    |
| ------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------- |
| Created without kernel intervention                                                               | Kernel itself is multithreaded                                                    |
| Very fast context switch                                                                          | Slow context switch                                                               |
| If one thread is blocked, the OS blocks the entire process because it isn't aware of user threads | If one thread is blocked, only that thread is blocked and not the entire process. |
| Generic and can run on any OS                                                                     | Specific to the OS                                                                |
| Faster to create and manage                                                                       | Slower to create and manage                                                       |

