>[!SUMMARY] Table of Contents
>- [[Queues#Simple Queue|Simple Queue]]
>- [[Queues#Circular Queue|Circular Queue]]
>- [[Queues#Double Ended Queue (Deque)|Double Ended Queue (Deque)]]
>	- [[Queues#Operations|Operations]]
>	- [[Queues#Pointer handling (array-based, circular)|Pointer handling (array-based, circular)]]
>	- [[Queues#Conditions|Conditions]]
>- [[Queues#Priority Queue|Priority Queue]]

A queue is a linear data structure that follows the FIFO rule of handling elements stored in it. It has a few basic operations such as ENQUEUE, DEQUEUE, and PEEK.

Enqueue means inserting the data in the queue from the **rear end**.
Dequeue means removing the data in the queue from the **front end**.

There are four types of queues -
1. Simple Queue
2. Circular Queue
3. Double Ended Queue
4. Priority Queue
# Simple Queue
Allows the basic Enqueue and Dequeue operations using pointers to keep track of "rear" and "front".

- Usually the initial values for "rear" and "front" are `rear=0; front=-1`.
- Upon `Enqueue(Q,el)` insert the element at `rear` index and increment `rear`.
- Upon `Dequeue(Q)` remove the element at `front` index and increment `front`.
- Queue is considered empty if `front >= rear`.

A problem with the simple queue is that it wastes space as most implementations only reset `rear` and `front` when the queue is fully emptied. Even if it's partially empty but `rear == maxsize - 1`, insertions won't be allowed due to reliance on the pointers for information regarding "emptiness".
# Circular Queue
To counteract the wastage of space in the Simple Queue implementation, we can use a circular queue. 

- Here we use similar Enqueue and Dequeue operations as the Simple Queue but update `rear` and `front` by doing `rear = (rear+1) % maxsize` and `front = (front+1) % maxsize`. 
- The way to check if the queue is full becomes `front == (rear+1) % maxsize`.

So now even if the queue is only partially empty, insertion of elements would still be allowed.
# Double Ended Queue (Deque)
A double ended queue (deque) is an extension of the queue data structure that allows **insertion and deletion at both ends**.

- Elements can be **inserted** at both `front` and `rear`    
- Elements can be **removed** from both `front` and `rear`    
- Can be implemented using **arrays (circular)** or **linked lists**
### Operations
- `insertFront(Q, el)` – insert element at the front
- `insertRear(Q, el)` – insert element at the rear
- `deleteFront(Q)` – remove element from the front
- `deleteRear(Q)` – remove element from the rear
### Pointer handling (array-based, circular)
- `front = (front - 1 + maxsize) % maxsize` (insert at front)
- `rear = (rear + 1) % maxsize` (insert at rear)
- `front = (front + 1) % maxsize` (delete from front)
- `rear = (rear - 1 + maxsize) % maxsize` (delete from rear)
### Conditions
- **Empty:**
    `front == −1`
    _(or `front == rear` depending on convention)_
- **Full:**    
    `(front == (rear+1) % maxsize)`
# Priority Queue
A special type of queue in which deletion of elements is based upon priority of element, not on the basis of arrival time. Implemented using a [[Trees#Binary Heap|Heap]].

Types -
1. Max Priority Queue (high to low)
2. Min Priority Queue (low to high)

Each element has two attributes `<value, priority>`.

---
Question 1 -

![[Pasted image 20251225130049.png | 600]]

