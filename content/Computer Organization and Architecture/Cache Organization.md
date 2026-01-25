>[!SUMMARY] Table of Contents
>- [[Cache Organization#Locality of Reference|Locality of Reference]]
>- [[Cache Organization#Working of Cache Memory|Working of Cache Memory]]
>	- [[Cache Organization#Block|Block]]
>	- [[Cache Organization#Average Memory Access Time|Average Memory Access Time]]
>- [[Cache Organization#Types of Cache Access|Types of Cache Access]]
>	- [[Cache Organization#Simultaneous Access|Simultaneous Access]]
>	- [[Cache Organization#Hierarchical Access|Hierarchical Access]]
>	- [[Cache Organization#Memory Access Time when Locality of Reference is used|Memory Access Time when Locality of Reference is used]]
>- [[Cache Organization#Cache Write or Write Propagation|Cache Write or Write Propagation]]
>	- [[Cache Organization#Write Through|Write Through]]
>	- [[Cache Organization#Write Back|Write Back]]
>	- [[Cache Organization#Write Miss|Write Miss]]
>		- [[Cache Organization#Write Allocate|Write Allocate]]
>		- [[Cache Organization#No Write Allocate|No Write Allocate]]
>- [[Cache Organization#Questions|Questions]]
# Locality of Reference
Programs tend to access the same memory location or nearby memory locations within short intervals of time.

Types -
1. **Temporal Locality -** Recently accessed memory locations are likely to be accessed again.
2. **Spatial Locality -** Memory locations close to the recently accessed memory are likely to be accessed.
3. **Sequential Locality -** Access in strictly increasing order of address.

This phenomenon allows for caching a **block of memory** to be efficient. Currently demanded localities are kept in a smaller and faster memory called **cache**.
# Working of Cache Memory
![[Pasted image 20260125131640.png]]

Keywords -
1. Cache Hit - When demanded CPU content is present in Cache.
2. Cache Miss - When demanded CPU content is absent in Cache.
3. Hit Ratio $(H)$ - Fraction of times a Cache Hit occurs in all memory references.

$$
H = \frac{\text{No. of hits}}{\text{No. of memory references}}
$$
## Block
More specifically, a block is a fixed-size contiguous group of memory words transferred between the main memory and cache memory as a single unit.

***Example -*** Whenever a Cache Miss occurs, the CPU retrieves the content from the Main Memory itself. But because locality of reference is known, a **neighbourhood around that content** is brought to the cache to make future memory accesses **more efficient**. This neighbour is a block.
## Average Memory Access Time
Both a Cache Miss and a Cache Hit take some time for performing the content transfer. So the average memory access time is -

$$
\text{Avg. Mem. Access Time} = H*(\text{Time for cache hit}) + (1-H)*(\text{Time for cache miss})
$$

^a692b1
# Types of Cache Access
## Simultaneous Access
The memory access request is **sent to both** the cache memory as well as the main memory. Hence this is also called a **parallel access**.

![[Pasted image 20260125134951.png]]

The average memory access time is -

$$
T_{avg} = H*T_{cm} + (1-H)*T_{mm}
$$

Here $T_{cm}$ is the cache memory access time and $T_{mm}$ is the main memory access time.
## Hierarchical Access
The memory access request is sent to the main memory **only when a Cache Miss** occurs. Hence this is also called as **serial access**.

The average memory access time is -

$$
\begin{aligned}
T_{avg} &= H*T_{cm} + (1-H)*(T_{cm}+T_{mm}) \\[8pt]
&= \cancel{H*T_{cm}} + T_{cm}+T_{mm} \cancel{- H*T_{cm}} + H*T_{mm} \\[8pt]
&= T_{cm} + (1+H) * T_{mm}
\end{aligned}
$$

The additional $T_{cm}$ in the second term of the formula is called the **"cache search/lookup time"** because in the case of a cache miss the cache access is not for retrieving content from cache but to check for its existence.

Cache search time is **zero** in the case for parallel access.

In such a memory organization -
- The Cache Memory is also called as the **Top Level memory**.
- The Main Memory is also called as the **Bottom Level memory**.
<h4 class="special">When to use which formula for Avg. Memory Access time?</h4>
If a question has the words "cache memory access time" and "main memory access time" mentioned, only then move onto using the formulas for Simultaneous or Hierarchical access.
- If "Hierarchy" or "Level" is mentioned, we are dealing with Hierarchical Access.
- Else we are dealing with Simultaneous Access.

Otherwise, if the question just mentions "time for cache hit" and "time for cache miss", use the [[Cache Organization#^a692b1|generic formula]].

See [[Cache Organization#^q1|Question 1]] for a simple example.
## Memory Access Time when Locality of Reference is used
In the previous cases we were just looking at the cases where on a Cache miss we retrieve the data directly from the main memory. But on a cache miss, the block in which the data belongs to needs to be brought in the cache memory for future usage as well.

Let the block transfer time be $T_{bt}$.

Then,
1. Simultaneous Access - $T_{avg} = H*T_{cm} + (1-H)*T_{bt}$
2. Simultaneous Access - $T_{avg} = T_{cm} + (1-H)*T_{bt}$
# Cache Write or Write Propagation
Write propagation means that, if the CPU performs a write operation on some data in the cache memory, then that same data should also be updated in the main memory.

![[Pasted image 20260125163924.png|550]]
## Write Through
If the CPU performs a write operation in the cache, it performs a write operation in the main memory **simultaneously/parallelly**. The data in the cache and the main memory is updated together.

- **Pro -** No inconsistency between the content in the cache memory and content in the main memory.
- **Con -** Time consuming because write operation is performed on the main memory irrespective of hit or miss in the cache.

Because the cache and main memory are accessed simultaneously, the cache memory would use **simultaneous access**. Thus, the time required for one read and one write operation is -

$$
\begin{aligned}
T_r &= H*T_{cm} + (1-H)*T_{mm} \\[8pt]
T_{w} &= \operatorname{max}(T_{cm}, T_{mm}) = T_{mm} \\[8pt]
T_{avg} &= \text{\% of read operations} * T_r + \text{\% of write operations} * T_w  \\[8pt]
\text{Eff. Hit Ratio} &= \text{\% of hit read operations} = \text{\% of read operations} * H
\end{aligned}
$$

Out of all cases of read/write operations hitting/missing, the cache memory is sufficient by itself only when a read-hit occurs. For rest of the cases the main memory is involved too. This causes a **lower effective hit ratio** for Write Through cache when compared with Write Back cache.
## Write Back
If the CPU performs a write operation in the cache, the same content in the main memory is not updated simultaneously. Instead the content in the main memory is updated when a block is replaced in the cache memory.

- **Pro -** Time saving compared to Write-Through.
- **Con -** Inconsistency between the content in cache memory and main memory.

Any block that has been written over is called a **dirty/modified block**. For any block in the cache memory -
1. If no write was performed on that block - Directly replace the block without any write in main memory.
2. If write was performed on the block (If it's a dirty block) - Perform write back for the block.

Unlike Write Through cache, there's no requirement of Write Back caches requiring strictly Simultaneous or strictly Hierarchical access. The average memory access time is -

1. Simultaneous Access -

$$
T_{avg} = H*T_{cm} + (1-H)*(T_{bt} + \text{write back time})
$$

2. Hierarchical Access -

$$
\begin{aligned}
T_{avg} &= H*T_{cm} + (1-H)*(T_{cm} + T_{bt} + \text{write back time}) \\[8pt]
&= T_{cm} + (1-H) * (T_{bt} + \text{write back time})
\end{aligned}
$$
write back time is - 

$$
\text{write back time} = \text{fraction of dirty blocks} * T_{bt}
$$
## Write Miss
Write miss are handled in two ways, by using Write Allocate or by using No Write Allocate.
### Write Allocate
On a write miss the block is loaded into the cache and then written in the cache itself. Usually used with [[Cache Organization#Write Back|Write Back]] cache.

Write Back cache with Write Allocate -
1. Read -
	- Hit - CPU reads content from cache.
	- Miss - CPU reads content from main memory and brings the missing block to the cache memory by replacing an existing block **if needed**. If a dirty block is replaced, write-back to the main memory.
2. Write -
	- Hit - Perform write in cache.
	- Miss - Bring the missing block to the cache memory by replacing an existing block **if needed** and then perform the write operation on it in the cache. If a dirty block is replaced, write-back to the main memory.
### No Write Allocate
On a write miss the block is written in the main memory and not loaded into the cache. Used with [[Cache Organization#Write Through|Write Through]] cache.

Write Through cache with No Write Allocate -
1. Read -
	- Hit - CPU reads content from cache.
	- Miss - CPU reads content from main memory and brings the missing block to the cache memory by replacing an existing block **if needed**.
2. Write -
	- Hit - Perform write in cache and main memory simultaneously.
	- Miss - Perform write in main memory but do not bring missing block to the cache.

---
# Questions
^q1
<h6 class="question">Q1) If in a two level memory hierarchy, the top level memory access time is 8ns and the bottom level memory access time is 60ns, the hit-rate required is __ for the average access time to be 10ns. What is __?</h6>

$\underline{\text{Sol}^n} -$
Here as "memory hierarchy" and "two level" is mentioned, we are dealing with a hierarchical access cache organization. So,

$$
\begin{alignedat}{3}
&&10 &= 8 + (1-H)*60 \\[8pt]
&\Rightarrow&\,\,10&= 8 + 60 - 60H \\[8pt]
&\Rightarrow&\,\,60H&= 58 \\[8pt]
&\Rightarrow&H&= \boxed{0.967} \\[8pt]
\end{alignedat}
$$