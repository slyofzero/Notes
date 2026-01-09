>[!SUMMARY] Table of Contents
>- [[Hash Table#Collision Resolution|Collision Resolution]]
>	- [[Hash Table#1. Open Hashing|1. Open Hashing]]
>	- [[Hash Table#2. Closed Hashing|2. Closed Hashing]]
>		- [[Hash Table#a. Linear Probing|a. Linear Probing]]
>		- [[Hash Table#b. Quadratic Probing|b. Quadratic Probing]]
>		- [[Hash Table#c. Double Hashing|c. Double Hashing]]
>- [[Hash Table#Summary|Summary]]

Hash table is a linear data structure which is used to create mapping between the value and the key using a hash function.

Example of a hash function -
$$h(k) = k\ mod\ n$$
# Collision Resolution
If keys of two values yield the same output for the hash function, a <strong><u>collision</u></strong> occurs.
## 1. Open Hashing
If multiple elements point to the same key then we connect them to a linked list.

---
Example -
![[open-hashing.png|400]]

Here we have $8$ cells in our hash table and try to insert values – $18, 26$.

---
* Best case time complexity - $O(1)$
* Worst case time complexity - $O(n)$
## 2. Closed Hashing
All elements inserted are stored inside the hash table itself, without the use of any external data structure.
### a. Linear Probing
If any index already has a value in it (collision occurs at the index), move to the next index and check if it's free. Keep doing this until an empty index is found.

In linear probing our hash function is usually -

$$
h(k,i) = (h(k) + i) \ mod \ n
$$

* Initially $i = 0$
* Upon collision $i = i+1$
---
**Example -**

To insert - $8, 57, 16$
![[imgs/linear-probing.png|400]]

---
Drawback of Linear Probing -
1. <u>Primary Clustering</u> - Keys that hash to **different initial indices** end up following the same probe sequence.
	
	Here -
	1. 57 had an initial hash of 1
	2. 16 had an initial hash of 2
	Yet both end up sharing the same probe sequence and be part of a cluster.
### b. Quadratic Probing
To avoid Primary Clustering we can update the hash function to be -

$$
h(k,i) = (h(k) + i^2) \ mod \ n
$$

Drawback of Quadratic Probing -
1. <u>Secondary Clustering</u> - Keys that hash to **same initial indices** end up following the same probe sequence.
	
	Clusters formed using this will be smaller than primary clusters.
### c. Double Hashing
In order to tackle Primary and Secondary clustering, we use two hash functions -

$$
h(k,i) = (h_1(k) + i * h_2(k)) \ \ mod \ \ n
$$
# Summary
1. Hash tables are made to decrease the time complexity required in searching for an element.
2. This is done by using hash functions.
3. Open hashing creates linked lists at each index of the hash table.
4. Linear probing causes **Primary Clustering**.
5. Quadratic probing causes **Secondary Clustering**.
6. Double hashing **solves both** Primary and Secondary Clustering.





