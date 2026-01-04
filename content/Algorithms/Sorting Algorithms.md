>[!SUMMARY] Table of Contents
>- [[Sorting Algorithms#Summary|Summary]]
>- [[Sorting Algorithms#Sorting Algorithms|Sorting Algorithms]]
>	- [[Sorting Algorithms#Types of Sorting Algorithms|Types of Sorting Algorithms]]
>	- [[Sorting Algorithms#Other classifications|Other classifications]]
>		- [[Sorting Algorithms#In-place Sorting Algorithm|In-place Sorting Algorithm]]
>		- [[Sorting Algorithms#Stable Sorting Algorithm|Stable Sorting Algorithm]]
>		- [[Sorting Algorithms#Inversion in an Array|Inversion in an Array]]
>- [[Sorting Algorithms#Bubble Sort|Bubble Sort]]
>	- [[Sorting Algorithms#Algo1|Algo1]]
>	- [[Sorting Algorithms#Algo2|Algo2]]
>	- [[Sorting Algorithms#Algo3 (default)|Algo3 (default)]]
>	- [[Sorting Algorithms#Properties|Properties]]
>- [[Sorting Algorithms#Selection Sort|Selection Sort]]
>	- [[Sorting Algorithms#Pseudocode and TC|Pseudocode and TC]]
>	- [[Sorting Algorithms#Properties|Properties]]
>- [[Sorting Algorithms#Insertion Sort|Insertion Sort]]
>	- [[Sorting Algorithms#Pseudocode and TC|Pseudocode and TC]]
>	- [[Sorting Algorithms#Properties|Properties]]
>- [[Sorting Algorithms#Radix Sort|Radix Sort]]
>	- [[Sorting Algorithms#Properties|Properties]]
>- [[Sorting Algorithms#Questions|Questions]]

**Definition -** Arrangement/Ordering of items in a sequence based upon some condition is *Sorting*.
# Summary
|                     Algorithm                     |      Best Case TC       | Worst Case TC |                   Special TC                    | In-place | Stable |                SC                |
| :-----------------------------------------------: | :---------------------: | :-----------: | :---------------------------------------------: | :------: | :----: | :------------------------------: |
|           [[#Bubble Sort\|Bubble Sort]]           |       $\Omega(n)$       |   $O(n^2)$    |                        -                        |    ✅     |   ✅    |              $O(1)$              |
|        [[#Selection Sort\|Selection Sort]]        |     $$\Omega(n^2)$$     |  $$O(n^2)$$   | Better worst case no. of swaps than Bubble Sort |  $$✅$$   | $$❌$$  |             $$O(1)$$             |
|        [[#Insertion Sort\|Insertion Sort]]        |      $$\Omega(n)$$      |  $$O(n^2)$$   |           $O(n+d)$ <br>if pre-sorted            |  $$✅$$   | $$✅$$  |             $$O(1)$$             |
|          <br>[[#Radix Sort\|Radix Sort]]          |          <br>-          |     <br>-     |       $\Theta(n*d)$<br>input-independent        |  $$❌$$   | $$✅$$  |             $$O(n)$$             |
| <br>[[Divide And Conquer#Merge Sort\|Merge Sort]] |          <br>-          |     <br>-     |   $\Theta(n\,log_2\,n)$<br>input-independent    |  $$❌$$   | $$✅$$  | $O(n)$<br>Aux mem + Recur. stack |
|   [[Divide And Conquer#Quick Sort\|Quick Sort]]   | $$\Omega(n\,log_2\,n)$$ |  $$O(n^2)$$   |              Worst case for sorted              |  $$❌$$   | $$❌$$  |             $$O(n)$$             |
# Sorting Algorithms
1. Bubble Sort
2. Selection Sort
3. Insertion Sort
4. [[Divide And Conquer#Merge Sort|Merge Sort]]
5. [[Divide And Conquer#Quick Sort|Quick Sort]]
6. Heap Sort
7. Radix Sort
## Types of Sorting Algorithms
1. Comparison Based - When an element is compared with other elements of the given data to achieve sorting.
2. Non-Comparison Based - When sorting is achieved without any comparison between the elements.
## Other classifications
1. Iterative vs Recursive
2. Inplace vs Not-inplace
3. Internal (Only Main memory usage) vs External (Main + Secondary memory)
4. Stable vs Unstable
### In-place Sorting Algorithm
Auxiliary memory is the memory space required by a program. Auxiliary memory requirement - 
1. At most $O(1)$ (excluding recursion stack)
2. Recursion stack at most $O(log\,n)$
### Stable Sorting Algorithm
If $A[i] = A[j]$ (not necessarily equal, just have the same priority of ordering) and in the given input $A[i]$ occurs before $A[j]$, then if in the sorting output too $A[i]$ occurs before $A[j]$ we say that the algorithm in stable.
### Inversion in an Array
If $A[i] > A[j]$ but $i < j$, then $(i,j)$ is an **inversion pair**.

The time complexity of any Comparison based Sorting Algorithm depends upon two things-
1. The number of comparisons.
2. The number of inversions (Number of swaps).
# Bubble Sort
Bubble sort works in "passes". If checks for each index whether the current element and the element after are forming an inversion pair. If an inversion pair is formed then we swap the elements, else we skip.

![[Pasted image 20251229192942.png]]

## Algo1

```c
1. BubbleSort1(A,n) {
2.   for (pass=1; pass<=n-1; pass++) {
3. 		for (j=1; j<=n-1; j++) {
4. 			if (A[j] > A[j+1]) {
5. 				swap(A[j], A[j+1])
6. 			}
7. 		}
8. 	 }
9. }
```

|                                  | No. of Comparisons |                No. of Swaps                 |
| :------------------------------: | :----------------: | :-----------------------------------------: |
|  Best Case<br>(Ascending Order)  |    $$(n-1)^2$$     |                    $$0$$                    |
| Worst Case<br>(Descending Order) |    $$(n-1)^2$$     | $$(n-1)+(n-2)+\dots+1 =  \frac{n(n-1)}{2}$$ |
## Algo2
As any $k^{th}$ pass would already fix $k$ large elements at their correct positions, we don't need to run each pass $n-1$ times.

```c
1. BubbleSort1(A,n) {
2.   for (pass=1; pass<=n-1; pass++) {
3. 		for (j=1; j<=n-pass; j++) {
4. 			if (A[j] > A[j+1]) {
5. 				swap(A[j], A[j+1])
6. 			}
7. 		}
8. 	 }
9. }
```

|                                  |  No. of Comparisons  |     No. of Swaps     |   Complexity    |
| :------------------------------: | :------------------: | :------------------: | :-------------: |
|  Best Case<br>(Ascending Order)  | $$\frac{n(n-1)}{2}$$ |        $$0$$         | $$\Omega(n^2)$$ |
| Worst Case<br>(Descending Order) | $$\frac{n(n-1)}{2}$$ | $$\frac{n(n-1)}{2}$$ |   $$O(n^2)$$    |
|             Overall              |                      |                      |  $\Theta(n^2)$  |
## Algo3 (default)
When number of swaps in the current arrangement is $0$, we can say that the array has been sorted and avoid unnecessary further passes.

```c
BubbleSort1(A,n) {
	for (pass=1; pass<=n-1; pass++) {
		flag=0
  		for (j=1; j<=n-pass; j++) {
 			if (A[j] > A[j+1]) {
 				swap(A[j], A[j+1])
				flag=1
 			}
 		}
   
	   if (flag==1) {break}
	}
}
```

|                                  |  No. of Comparisons  |     No. of Swaps     |  Complexity   |
| :------------------------------: | :------------------: | :------------------: | :-----------: |
|  Best Case<br>(Ascending Order)  |       $$n-1$$        |        $$0$$         | $$\Omega(n)$$ |
| Worst Case<br>(Descending Order) | $$\frac{n(n-1)}{2}$$ | $$\frac{n(n-1)}{2}$$ |  $$O(n^2)$$   |
## Properties
1. Is In-place, $SC = O(1)$.
2. Is Stable.
3. No. of swaps = No. of inversions.
4. Requires no swaps in best case scenario and $O(n^2)$ swaps in worst case scenario.
5. **Guarantee -** After some $k^{th}$ pass the $k$ largest elements are at their correct positions at the end of the array.
6. The maximum number of passes required - $(n-1)$.
# Selection Sort
1. In the $i^{th}$ pass, find the index with the $i^{th}$ smallest element.
2. Swap the element at the $i^{th}$ index with the $i^{th}$ smallest element.
3. Repeat until array is sorted

![[Pasted image 20251229193800.png|450]]
## Pseudocode and TC

```c
SelectionSort(A, n) {
	for (pass=1; pass<=n-1; pass++) {
		min=pass
		for (j=pass+1; j<=n; j++) {
			if A[j] < A[min] {
				min=j
			}
		}
		
		if min != pass {
            swap(A[pass], A[min])
        }
	}
}
```

|                                  |  No. of Comparisons  | No. of Swaps |   Complexity    |
| :------------------------------: | :------------------: | :----------: | :-------------: |
|  Best Case<br>(Ascending Order)  | $$\frac{n(n-1)}{2}$$ |    $$0$$     | $$\Omega(n^2)$$ |
| Worst Case<br>(Descending Order) | $$\frac{n(n-1)}{2}$$ |   $$n-1$$    |   $$O(n^2)$$    |
|             Overall              |                      |              |  $\Theta(n^2)$  |
Even though the overall best case time complexity is worse than Bubble sort, even under worst case the algorithm only takes $O(n)$ time complexity for the swaps.
## Properties
1. Is Unstable.
2. Is In-place, $SC = O(1)$..
3. Always takes $n-1$ passes.
4. Each pass does exactly $1$ swap.
# Insertion Sort
1. Pick elements from left to right one by one as `key` elements.
2. If the `key` element is less than the element at the `key-1` index, swap them.
3. Keep swapping until there are no more elements to the left of `key` or the element at `key-1` is greater than `key` element.

![[Pasted image 20251228164306.png|600]]
## Pseudocode and TC

```c
InsertionSort(A, n) {
	for (i=2; i<=n; i++) {
		key=A[i]
		j=i-1
		
		while (j > 0 and A[j]>key) {
			A[j+1]=A[j]
			j--
		}
		
		if (i != j+1) {
			A[j+1]=key
		}
	}
}
```

|                                  |  No. of Comparisons  |     No. of Swaps     |  Complexity   |
| :------------------------------: | :------------------: | :------------------: | :-----------: |
|  Best Case<br>(Ascending Order)  |       $$n-1$$        |        $$0$$         | $$\Omega(n)$$ |
| Worst Case<br>(Descending Order) | $$\frac{n(n-1)}{2}$$ | $$\frac{n(n-1)}{2}$$ |  $$O(n^2)$$   |
## Properties
1. Is In-place, $SC = O(1)$.
2. Is Stable.
3. Always takes $n-1$ passes.
4. No. of swaps = No. of inversions.
5. If the input list is already pre-sorted, then it takes time of $O(n+d)$ where -
	$n$ = no. of elements
	$d$ = no. of inversions
	Check [[##^q2|Question 2]] for this.
# Radix Sort
Radix means the base of the number system.
1. Bin the numbers based on their **unit’s digit** using a key-value structure with keys `0–9`, inserting elements for each key in **FIFO order**.    
2. Collect the numbers by reading the bins from key `0` to `9`, preserving order.    
3. Repeat the above steps for the **tens digit**, then the **hundreds digit**, and so on.    
4. Continue for **k passes**, where `k` is the number of digits in the maximum element.    
5. The final array obtained is **sorted**.

![[Pasted image 20251228172632.png]]

## Properties
1. Not In-place, requires external data structure with $SC = O(n)$.
2. Is Stable.
3. $TC = O(d * (n+b)) \approx O(n*d)$.
	$b =$ base of given input.
	$d =$ no. of digits in the maximum element of the array.
	$n =$ no. of elements in the array.
# Questions
<h6 class="question">Q1)</h6>

![[Pasted image 20251228175940.png]]

<strong><u>Sol</u></strong>$^n$ - 
The time complexity of Radix Sort is $O(n*d)$ where $d$ is the number of digits in the maximum element of the array.

The maximum element of the array is $n^k$ and the number of digits in it are $log_{10}\,n^k + 1 = O(k*log_{10}\,n)$. So $TC = O(n*k*log_{10}\,n) = O(n*k*log_{10}\,n)$ as $k$ is some constant which wouldn't affect the time complexity of the algorithm.

---
^q2
<h6 class="question">Q2)</h6>

![[Pasted image 20251228203412.png]]

<strong><u>Sol</u></strong>$^n$ - 
The time complexity of Insertion sort for pre-sorted inputs is $O(n+d)$ where $d$ is the number of inversions. Here the permutations can have at most $n$ inversions so the time complexity is $O(n+n)=O(n)$.