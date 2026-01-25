Content V/S Data - 
1. Data - What the programs ultimately wants to use.
2. Content - Any value stored in the memory.
# Associative Memory
Associative memory retrieves data **by content instead of by address**. Hence it is also known as **content addressable memory**.

 Unlike an addressable memory where the CPU supplies an address, in associative memory the CPU supplies a **search key**. Each cell in this memory holds -
1. **Key/Tag -** What CPU knows
2. **Value -** What CPU wants

How it works -
1. CPU sends a search key.
2. The search key is matched with the keys of all cells **simultaneously in parallel**.
3. The cell with the matching search key is identified.
4. The **associated value** of this cell is sent back to the CPU.
5. If multiple cells match with the search key, the associated value for both is sent.

This memory is extremely fast, much faster than SRAM, but because the hardware requires the ability to compare keys of all cells in the memory simultaneously it is also very expensive.

Uses -
1. Caching
2. TLB (Translation Lookaside Buffer) in OS