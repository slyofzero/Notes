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
Locality of reference is a phenomenon when programs tend to access the same memory location or nearby memory locations within short intervals of time.

Types -
1. **Temporal Locality -** Recently accessed memory locations are likely to be accessed again.
2. **Spatial Locality -** Memory locations close to the recently accessed memory are likely to be accessed.
3. **Sequential Locality -** Access in strictly increasing order of address.

This phenomenon allows for caching a **block of memory** to be efficient. Currently demanded localities are kept in a smaller and faster memory called **cache**.
# Working of Cache Memory
**Caching** is temporarily storing copies of certain content of the main memory for a ease of access. 

The memory used for caching is called a **cache memory**. Cache memory has a faster access time than main memory but is typically smaller in size. On-chip Cache memories are in the CPU itself.

When the CPU accesses -
- On-chip Cache memory it doesn't require system buses. The cache can be accessed similar to registers.
- Main memory it needs system buses.

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
The memory read operation is **performed on both** the cache memory as well as the main memory. Hence this is also called a **parallel access**.

![[Pasted image 20260125134951.png]]

The average memory access time is -

$$
T_{avg} = H*T_{cm} + (1-H)*T_{mm}
$$

Here $T_{cm}$ is the cache memory access time and $T_{mm}$ is the main memory access time.
## Hierarchical Access
The memory read operation is performed to the main memory **only when a Cache Miss** occurs. Hence this is also called as **serial access**.

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

See [[Cache Organization#^1007d7|Question 1]] for a simple example.
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
# Cache Mapping
A cache line is the **smallest data unit** that is transferred between the cache and the main memory. In simpler words, a block in the cache memory is called a cache line.

Cache mapping is the rule/mechanism that dictates which **cache line** would hold which main memory block.
## Direct Mapping
In direct mapping, **each main-memory block is mapped to exactly one fixed cache line/index**.

One index in direct mapping is one cache block. The below formula is applicable for [[Cache Organization#Set Associative Mapping|Set Associative Mapping]] and [[Cache Organization#Fully Associative Mapping|Fully Associative Mapping]] as well, it's just that the number of indices for those mappings are different.

$$
\begin{aligned}
\text{m.m. block no.} &= \left\lfloor\frac{\text{m.m. address.}}{\text{No. of indices}} \right\rfloor\\[8pt]
\text{c.m. block no.} &= (\text{m.m. block no.}) \,\,\% \,\,(\text{No. of indices}) \\[8pt]
\end{aligned}
$$

Suppose if the cache memory has 10 blocks and the second block is holding the main memory block 52. If we lookup block 92 in the cache, it will be checked in the second block of the cache memory. Because the second block is already holding block 52, looking up block 92 in cache should be a cache miss. But how can we differentiate between the content in the cache block and the block being requested?
### Tag
A tag is a part of the memory address and helps in identifying whether the requested block is present in its respective cache line or not.
### Index
The cache block no. is also known as index in direct mapping.
### Memory address layout
The tag and cache memory block no. make up the main memory block no.

$$
\begin{aligned}
\text{m.m. block no.} &= \boxed{\strut \text{Tag}}\boxed{\strut \text{c.m. block no.}} \\[8pt]
\text{block 92} &= \underbrace{\boxed{\strut \,\,\,9\,\,\\\,}}_{\text{Tag}} \underbrace{\boxed{\strut \,\,\,2\,\,\,}}_\text{c.m.} \\
\end{aligned}
$$

But a memory address is byte/word addressable not block addressable. A block will be made up of some bytes/words, thus the memory address will be of layout -

$$
\begin{aligned}
\text{memory address} &= \boxed{\strut \text{m.m. block no.}}\boxed{\strut \text{byte offset}} \\[8pt]
&= \boxed{\strut \text{Tag}}\boxed{\strut \text{c.m. block no.}}\boxed{\strut \text{byte offset}} \\[8pt]
\end{aligned}
$$

- No. of bits for byte no./byte offset - $\operatorname{log}_2(\text{block size})$
- No. of bits for main memory block no. - $\operatorname{log}_2(\text{blocks in m.m.})$
- No. of bits for cache memory block no./index - $\operatorname{log}_2(\text{blocks in c.m.})$
- No. of tag bits - $(\text{No. of bits for m.m. block no.} - \text{No. of bits for c.m. block no.})$

See [[Cache Organization#^cba289|Question 3]] for an example.

Suppose the cache memory size $= 2^i$ and main memory size $= 2^m$, but the byte offset is unknown. Assume byte offset to be $2^x$. The index bits would be $\operatorname{log}_2\left(\frac{2^i}{2^x}\right)=i-x$. The tag bits would be -

$$
\begin{aligned}
\text{tag bits} &= m - ((i-x) + x) \\[8pt]
&= m-i \\[8pt]
&= \operatorname{log}_2(\text{m.m. size}) - \operatorname{log}_2(\text{c.m. size})
\end{aligned}
$$

So we can say,

$$
\begin{aligned}
\text{memory address} &= \boxed{\strut \text{Tag}}\boxed{\strut \text{cache line bits}} \\[8pt]
\text{c.m. address bits} &= \text{c.m. block no. bits} + \text{byte offset}
\end{aligned}
$$

### Cache Controller
The cache controller is a device which acts as the control logic for all cache related operations. The cache controller maintains a tag directory/metadata which holds all the tag bits and status bits.

$$
\text{Tag directory size} = (\text{Tag bits + Status bits}) * \text{No. of blocks in c.m.}
$$

^c1c03b

Unlike the tag bits, the valid/invalid bit and dirty bit are not stored in the main memory address. Instead they are kept separately in the tag directory.

The tag directory size **doesn't** depend upon the type of cache mapping used.
#### Tag bits
The bits required to denote a [[Cache Organization#Tag|block tag]].
#### Valid/Invalid Bit
Whenever we start our computer, the cache is initialized with garbage values. It is possible that when we lookup a memory address in the cache, the tag of this memory address matches the garbage value in the tag bit and invalid content is sent to the CPU. To avoid this we use valid/invalid bits.
- 0 means invalid
- 1 means valid

How it works -
- When the cache is initialized, all valid/invalid bits for each cache line are initialized with 0 signifying that all tag bits are garbage values. 
- When a cache line is filled with a block from the main memory, this bit is set to 1 to signify that going forward the cache line would contain valid content.
#### Dirty bit
In [[Cache Organization#Write Back|write back]] cache when a dirty/modified block is replaced from the cache, the content in the block needs to be written to the main memory. To keep track of modifications in a cache block, we use dirty bits.
- 0 means the cache block has not been modified.
- 1 means the cache block has been modified and upon replacement should be written to the main memory.
## Set Associative Mapping
In set associative mapping, **each index corresponds to a set containing multiple cache lines**, and a memory block can be placed in **any line within its indexed set**.

$$
\text{no. of sets in k-way set associativity} = \frac{\text{no. of c.m. blocks}}{k}
$$

From here, using the no. of indices we can calculate the number of bits required for indices consequently calculate the tag bits and tag directory size. The memory address layout now looks like -

$$
\begin{aligned}
\text{memory address} &= \boxed{\strut \text{m.m. block no.}}\boxed{\strut \text{byte offset}} \\[8pt]
&= \boxed{\strut \text{Tag}}\boxed{\strut \text{set offset}}\boxed{\strut \text{byte offset}} \\[8pt]
\end{aligned}
$$

No matter which type of mapping or associativity we use, each block in the cache memory would still require a tag. Thus the formula for the tag directory size stays the same as the one mentioned [[Cache Organization#^c1c03b|under Direct Mapping]].

However, the tag bits required for an associative mapping will increase which will consequently increase the size of the tag directory.

By each time increasing the associativity by a factor of 2, we increase the tag bits by 1 and decrease the index bits by 1. Thus if the set associativity is $k$, the index bits are decreased by $\operatorname{log}_2k$. In direct mapping memory address size = Tag Bits + Cache line bits, but in $k$-way set associative mapping, 

$$
\begin{aligned}
\text{memory address} &= \boxed{\strut \text{Tag}}\boxed{\strut \operatorname{log}_2(\text{cache size}) - \operatorname{log}_2k} \\[8pt]
\end{aligned}
$$

### How it's implemented

![[Pasted image 20260126223006.png|550]]

Assume that we are dealing with a 2-way set associative cache. In such a cache, for each set there would exist two tags for each block in a set. These tags are **parallelly** compared with the tag of the memory address being requested. If any of the tag matches, we have a cache hit else a cache miss.

The higher the associativity, more such tags need to be compared in parallel and thus increasing the complexity and expense.
## Fully Associative Mapping
In fully associative mapping, **any main-memory block can be placed in any cache line**. There's no fixed mapping between memory blocks and cache lines.

In a fully associative cache, the index has zero bits. The memory address layout looks like -

$$
\begin{aligned}
\text{memory address} &= \boxed{\strut \text{m.m. block no.}}\boxed{\strut \text{byte offset}} \\[8pt]
&= \boxed{\strut \text{Tag bits}}\boxed{\strut \text{byte offset}} \\[8pt]
\end{aligned}
$$

The formula for the tag directory size stays the same as the one mentioned [[Cache Organization#^c1c03b|under Direct Mapping]]. Here the tag bits = m.m. block no. so the same formula can be re-written as,

$$
\text{Tag directory size} = (\text{m.m block no. bits + Status bits}) * \text{No. of blocks in c.m.}
$$

---
# Questions
<h6 class="question">Q1) If in a two level memory hierarchy, the top level memory access time is 8ns and the bottom level memory access time is 60ns, the hit-rate required is __ for the average access time to be 10ns. What is __?</h6>

$\underline{\text{Sol}^n} -$
Here as "memory hierarchy" and "two level" is mentioned, we are dealing with a hierarchical access cache organization. So, ^1007d7

$$
\begin{alignedat}{3}
&&10 &= 8 + (1-H)*60 \\[8pt]
&\Rightarrow&\,\,10&= 8 + 60 - 60H \\[8pt]
&\Rightarrow&\,\,60H&= 58 \\[8pt]
&\Rightarrow&H&= \boxed{0.967} \\[8pt]
\end{alignedat}
$$
---
<h6 class="question">Q2) What is the size of data sent from the CPU to main memory when:</h6>
1. For write hit, a write through cache is used
2. For write miss, a write through cache is used
3. For write hit, a write back cache is used
4. For write miss, a write back cache is used

$\underline{\text{Sol}^n} -$
For any write operation, the CPU sends **1 data item** of 1 byte or 1 word to the cache/main memory depending upon what type of cache is used.

1. Write hit in Write Through - **1 data item**, because in Write Through cache both cache and main memory is written simultaneously regardless of hit or miss.
2. Write miss in Write Through - **1 data item**, same reasoning as above.
3. Write hit in Write Back - **No data item**, because the write operation is performed in the cache memory and not the main memory.
4. Write miss in Write Back - 
	1. If using **write allocate** - **No data item**, because the missing block is brought from the main memory to the cache memory and then the write operation is performed on the cache memory.
	2. If using no-write allocate - **1 data item,** because the write operation is performed directly on the main memory without bring the block to cache.

---
<h6 class="question">Q3) If the main memory is of size 1MB with a block size of 16 bytes, and the cache memory is of size 64KB, how many bits are required for the Tag, cache block no., and byte no.?</h6>

$\underline{\text{Sol}^n} -$ ^cba289
- Here the memory is of $2^{20}$ bytes. Thus the memory address is made up of **20 bits**.
- A block is of 16 bytes, thus **4 bits** is required for byte no.
- The number of blocks in the main memory is $\frac{2^{20}}{2^4}=2^{16}$. Thus **16 bits** are required for the main memory block no.
- The main memory block no. is made up of Tag and cache memory block no. The number of blocks in cache memory is $\frac{2^{16}}{2^4}=2^{12}$. Thus **12 bits** is required for cache memory block number.
- The remaining **4 bits** of the main memory block no. are for the block tag.

Thus the layout is -

$$
\underbrace{\boxed{\strut \,\,\text{4 bits}\,\,}}_{\text{Tag bits}} \underbrace{\boxed{\strut \,\,\text{12 bits}\,\,}}_\text{c.m. block no.} \underbrace{\boxed{\strut \,\,\text{4 bits}\,\,}}_\text{byte no.}
$$