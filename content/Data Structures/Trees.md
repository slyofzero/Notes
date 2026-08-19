>[!SUMMARY] Table of Contents
>- [[Trees#Binary Tree|Binary Tree]]
>- [[Trees#Properties of binary trees|Properties of binary trees]]
>	- [[Trees#Number of Binary Trees Possible|Number of Binary Trees Possible]]
>- [[Trees#Tree Traversal|Tree Traversal]]
>	- [[Trees#Breadth First Traversal|Breadth First Traversal]]
>	- [[Trees#Depth First Traversal|Depth First Traversal]]
>		- [[Trees#Pre-Order Traversal|Pre-Order Traversal]]
>		- [[Trees#In-Order Traversal|In-Order Traversal]]
>		- [[Trees#Post-Order Traversal|Post-Order Traversal]]
>- [[Trees#Binary Search Tree|Binary Search Tree]]
>	- [[Trees#Deletion of a node in a B.S.T|Deletion of a node in a B.S.T]]
>		- [[Trees#Deleting a leaf node|Deleting a leaf node]]
>		- [[Trees#Deleting an internal node with one child|Deleting an internal node with one child]]
>		- [[Trees#Deleting an internal node with two children|Deleting an internal node with two children]]
>- [[Trees#Array representation of Binary Tree|Array representation of Binary Tree]]
>- [[Trees#Binary Heap|Binary Heap]]
>	- [[Trees#Insertion in a Binary Heap|Insertion in a Binary Heap]]
>	- [[Trees#Deletion in a Binary Heap|Deletion in a Binary Heap]]
>	- [[Trees#Number of distinct Binary Heaps possible|Number of distinct Binary Heaps possible]]
>- [[Trees#AVL Tree|AVL Tree]]
>	- [[Trees#Balancing a B.S.T|Balancing a B.S.T]]
>		- [[Trees#LL Rotation|LL Rotation]]
>		- [[Trees#RR Rotation|RR Rotation]]
>		- [[Trees#LR Rotation|LR Rotation]]
>		- [[Trees#RL Rotation|RL Rotation]]
>- [[Trees#Red-Black Tree|Red-Black Tree]]
>	- [[Trees#Properties of a Red-Black Tree|Properties of a Red-Black Tree]]
>	- [[Trees#Black-Height|Black-Height]]
>	- [[Trees#Insertion in a Red-Black Tree|Insertion in a Red-Black Tree]]
>	- [[Trees#Deletion in a Red-Black Tree|Deletion in a Red-Black Tree]]
>	- [[Trees#AVL Tree vs Red-Black Tree|AVL Tree vs Red-Black Tree]]

A tree is a non-linear data structure in which elements are stored as nodes and connected in a hierarchical manner.

Some important terminologies for a tree are -
1. **Nodes -** Elements in a tree.
2. **Edges -** Connections between nodes.
3. **Root Node -** The topmost node in the tree.
4. **Left/Terminal/External Node -** The bottom most nodes in the tree with no children.
5. **Internal Node -** Any node in the tree which has at least one child.
6. **Sibling Nodes -** Nodes with a common parent.
7. **Degree of a node** - The number of children of that node.
8. **Degree of the tree** - The maximum degree of all nodes in the tree.
9. **Level** - The distance of the node from the root node (**convention dependent**, most books have root node as level 0 but some as level 1).
10. **Depth** - The number of edges from the root to that node (**convention independent**, root node is always at depth 0).
11. **Height** - The length of longest path from the node to a leaf node. ^height
12. **Height of the tree** - The maximum height of all nodes in the tree.
# Binary Tree
A tree with each node having a degree $\le$ 2.

Types of Binary trees -
1. **Full Binary Tree** - Every node must have a degree of either 0 or 2.
2. **Complete Binary Tree** - All levels **except the last level** of the tree must be completely filled (each level except the last has $2^n$ nodes) and nodes are filled from top to bottom and **left to right**.
3. **Perfect Binary Tree** - **Every level** of the tree must be completely filled (each level has $2^n$ nodes).
4. **Skewed Binary Tree** - All nodes except leaf nodes **must have a degree of 1** and all children **must be** the left child or the right child.
5. **Degenerate Binary Tree** - All nodes except leaf nodes **must have a degree of 1** and but children can **either be** a left child or a right child.

![[Pasted image 20260113110236.png]]
# Properties of binary trees
1. Number of edges in a binary tree - $n-1$ ($n$ is the number of nodes).
2. Number of external nodes in an F.B.T - $i+1$ ($i$ is the number of internal nodes).
3. Similarly, total number of nodes in an F.B.T or P.B.T - $2*i+1$ ($i$ is the number of internal nodes).
4. In a binary tree, if there are $l$ leaf nodes then the number of nodes with degree $2$ are - $l-1$.
5. A binary tree of height $H$ can be made using -
    1. Minimum no. of nodes - $H+1$
    2. Maximum no. of nodes - $2^{H+1}-1$
6. Using the above property, we can say that with $n$ nodes we can have -
    1. Minimum height - $log_2(N+1)-1$
    2. Maximum height - $N-1$
## Number of Binary Trees Possible
1. The number of unlabeled binary trees that can be formed using $n$ nodes is the [[Counting#Catalan's Numbers|Catalan's Numbers]] formula - $\frac{^{2n}C_n}{n+1}$.
2. The number of labeled binary trees that can be formed using $n$ nodes is - $n! * \frac{^{2n}C_n}{n+1}$.
# Tree Traversal
## Breadth First Traversal
Also known as **Level Order Traversal**. Each level of a tree is covered before moving to the next level.

![[Pasted image 20260113113628.png]]
## Depth First Traversal
### Pre-Order Traversal
The tree is traversed depth wise manner from left to right. Only when a leaf node is reached, we backtrack to the parent and start exploring the other children. 

- If the node is an internal node, only note it down if it is visited the first time during depth first traversal, else ignore. 
- If the node if a leaf node, note it down regardless of how many times it has been visited.

![[Pasted image 20260113113700.png]]
### In-Order Traversal
The tree is again traversed in a depth wise manner from left to right. But a node is traversed only after its left subtree is traversed.

- If the node is an internal node, only note it down if it is visited the second time during depth first traversal, else ignore. 
- If the node if a leaf node, note it down regardless of how many times it has been visited.

![[Pasted image 20260113113802.png]]
### Post-Order Traversal
The tree is again traversed in a depth wise manner from left to right. But a node is traversed only after its left subtree and right subtree are traversed.

 - If the node is an internal node, only note it down if it is visited the third time during depth first traversal, else ignore. 
- If the node if a leaf node, note it down regardless of how many times it has been visited.

![[Pasted image 20260113114733.png]]

# Binary Search Tree
A tree in which the left subtree nodes $\lt$ parent node $\lt$ right subtree nodes.
- The **in-order traversal** of a B.S.T will always give the values of the B.S.T in ascending order.
- For inserting an element to a non-perfect B.S.T of $n$ nodes -
    - Best Case Time Complexity - $O(1)$ (When the tree is **empty** or insertion happens **at the root**)
    - Worst Case Time Complexity - $O(n)$ (When the BST is **completely skewed**)
## Time Complexities
1. Time Complexity of merging two BSTs is $\Theta(n+m)$.
2. Using Build Heap, can be converted into a [[Trees#Binary Heap|Heap]] in $\Theta(n)$.
## Deletion of a node in a B.S.T
There are three cases possible for this
### Deleting a leaf node
If the node to delete is a leaf node, just identify the parent of that node using tree traversal and remove the pointer to the leaf from the parent.
### Deleting an internal node with one child
If the node to delete is an internal node with only one child, first identify the parent of that node using tree traversal. In the parent, replace the pointer to the internal node with the pointer to the internal node's left/right child.
### Deleting an internal node with two children
If the node $n$ to delete is an internal node with two children then -
- Swap the node with its in-order successor (default)
- Swap the node with its in-order predecessor

Steps -
1. Identify the in-order predecessor/successor to that node by first listing all nodes in an in-order manner. Let this node be some $m$.
2. Swap the internal node with $m$.
3. Delete $m$. If $m$ is a leaf node or an internal node with one child, the deletion is straight forward. If $m$ is also an internal node with two children, execute Step 1 but this time w.r.t $m$. If the B.S.T is a finite B.S.T, one such swapping will eventually result in a predecessor/successor which is either a leaf or only has one child.
# Array representation of Binary Tree
The convention for an array representation of a Binary Tree is to add elements of an array in a breadth-first manner. 

The below tree can be represented as -
```python
tree = [60, 50, 70, 10, 100, 90, None, 1, 2, None, None, None, None]
```

![[Pasted image 20260113201650.png|350]]

`None` is used to represent the lack of a child node in the leaf level for certain internal nodes.

Properties -
1. Left child of any node at index $i$ is at – $2i+1$
2. Right child of any node at index $i$ is at – $2i+2$
3. Left children are at odd indices.
4. Right children are at even indices.
# Binary Heap
A Binary Heap is what powers a [[Queues#Priority Queue|Priority Queue]]. A Binary Tree is a Binary Heap if -
1. **Shape Property -** The tree should be a complete Binary Tree. ^heap-shape-prop
2. **Ordering Property -** All parent nodes in the tree should either be greater than all of its children or smaller than all of its children.
    1. If parent $\ge$ all children $\rightarrow$ Max Heap
    2. If parent $\le$ all children $\rightarrow$ Min Heap

![[Pasted image 20260113172752.png]]

In the above image -
1. 1 is a Max Heap because it satisfied both the Shape and Ordering Property of a heap.
2. 2 is a Min Heap because it satisfied both the Shape and Ordering Property of a heap.
3. 3 is not a heap because it fails the Ordering Property of a Max heap because 61 $\le$ 67.
4. 4 is not a heap because it fails the Shape Property of a heap because 4 is not a Complete Binary Tree as 25 is on the right of 20 even though 20 has no left child. In a Complete Binary Tree the nodes need to be entered from a top-down and left-right manner.

[[Sorting Algorithms#^heap-sort|Heap Sort]] is a side effect of the Ordering Property of the heap data-structure.
## Time Complexities
1. In worst case, Heap building requires $\Theta(n\,log\,n)$ time.
2. If given a sorted array of elements, using the **Build Heap** method a new heap can be made in $\Theta(n)$ time.
3. Time Complexity of merging two heaps is $\Theta(n+m)$.
## Insertion in a Binary Heap
To insert a new item in the Binary Heap, a node node needs to be added to the Heap Tree -
1. Identify where the new node goes such that the **Shape Property** of the Heap is maintained. Insert the new element as a leaf node to this tree.
2. **Heapify -** Now to satisfy the Ordering Property of the Heap, check whether the new node and its parent follow the Ordering Property. If they don't then keep swapping the node with its parent until the Ordering Property is satisfied.

![[Pasted image 20260113184625.png]]

A Binary Heap can be constructed from scratch by just following these insertion rules. Worst case time complexity is $O(log\,n)$.
## Deletion in a Binary Heap
Deletion in a Binary Heap is always done on a priority basis, meaning that in a Max Heap the current maximum element is deleted while in a Min Heap the current minimum element is deleted.
1. Swap the root node with the last leaf node in the heap and delete the leaf node.
2. As now a leaf node is at the root of the heap, call heapify from the root to satisfy the Heap Invariant.
	1. During this heapify a case can occur where the root fails the Heap Invariant with both its children. In such a case pick the child that has a higher priority than the other and swap it with the root.
	2. If the root fails the Heap Invariant with only one of the children, swap the root and the child.

Worst case complexity - $O(log\,n)$
## Number of distinct Binary Heaps possible
The number of distinct Binary Heaps possible for $n$ elements is -

$$
T(n) = \binom{n-1}{L}*T(L)*T(n-1-L)
$$

Reasoning - 
- In a Min/Max heap only one element can go to the root. Rest $n-1$ elements must be chosen such that they satisfy the [[Trees#^heap-shape-prop|Shape Property]] of a Binary Heap. 
- Let $L$ be the number of elements chosen from $n$ elements to be in the **left subtree** of the root and let $R$ be the number of elements chosen to be in the **right subtree** of the root. 
- **Only one combination** of variables $L$ and $R$ can satisfy this Shape Property while also satisfying the constraint that $L+R=n-1$.
# AVL Tree
A height balanced [[Trees#Binary Search Tree|B.S.T]] is called an AVL Tree.
- A tree is said to be height balanced if the balancing factor for each node is in the range of $\{-1,0,1\}$.
- **Balancing Factor** = [[Trees#^height|Height]] of left sub-tree - Height of right sub-tree. Balancing factor for leaf nodes is 0.
## Balancing a B.S.T
To balance a given B.S.T we can perform rotations -
1. Single Rotation -
	- LL Rotation
	- RR Rotation
2. Double Rotation -
	- LR Rotation
	- RL Rotation

**Critical Node -** Any node with a balancing factor that doesn't belong to the allowed range of $\{-1,0,1\}$.
### LL Rotation
Done when insertion of a new node happens in the left subtree of the left child of a critical node.
- Let **A** be the first critical node from the bottom.
- Let **B** be A’s left child.
- Perform a **single right rotation**:
    - B becomes the new root of this subtree.
    - A becomes the right child of B.
    - B’s right subtree becomes A’s left subtree.

![[Pasted image 20260114091559.png]]
### RR Rotation
Done when insertion of a new node happens in the right subtree of the right child of a critical node.
- Let **A** be the first critical node from the bottom.
- Let **B** be A’s right child.
- Perform a **single left rotation**:
    - B becomes the new root of this subtree.
    - A becomes the left child of B.
    - B’s left subtree becomes A’s right subtree.

![[Pasted image 20260114092422.png]]
### LR Rotation
Done when insertion of a new node happens in the right subtree of the left child of a critical node.
- Let **A** be the first critical node from the bottom.
- Let **B** be A’s left child.
- Let **C** be B's right child
- Perform a **single left rotation** on B:
    - C becomes parent of B.
    - B becomes the left child of C.
    - C’s left subtree becomes B’s right subtree.
- Perform a **single right rotation** on A:
    - C becomes the new root of this subtree.
    - A becomes the right child of C.
    - C’s right subtree becomes A’s left subtree.

![[Pasted image 20260114093752.png]]
### RL Rotation
Done when insertion of a new node happens in the left subtree of the right child of a critical node.
- Let **A** be the first critical node from the bottom.
- Let **B** be A’s right child.
- Let **C** be B's left child.
- Perform a **single right rotation** on B:
    - C becomes parent of B.
    - B becomes the right child of C.
    - C’s right subtree becomes B’s left subtree.
- Perform a **single left rotation** on A:
    - C becomes the new root of this subtree.
    - A becomes the left child of C.
    - C’s left subtree becomes A’s right subtree.

![[Pasted image 20260114100536.png]]
# Red-Black Tree
A Red-Black Tree (RBT) is a self-balancing [[Trees#Binary Search Tree|B.S.T]] where each node stores an extra bit representing its **colour** — either Red or Black. The colouring constraints ensure that the tree remains approximately balanced after every insertion and deletion, guaranteeing $O(\log\,n)$ time for search, insertion, and deletion.

Notice how [[Trees#AVL Tree|AVL Trees]] enforce strict height-balancing, while Red-Black Trees enforce a *looser* invariant through colour rules — this makes RBTs cheaper to re-balance on insertions and deletions.
## Properties of a Red-Black Tree
A valid Red-Black Tree must satisfy **all five** of the following properties at all times -
1. **Colour Property -** Every node is either **Red** or **Black**.
2. **Root Property -** The root node is always **Black**.
3. **Leaf Property -** All leaves are **NIL nodes** (external sentinel nodes) and are always **Black**.
4. **Red Property -** If a node is Red, both its children must be Black. In other words, **no two consecutive Red nodes** can appear on any path from root to leaf.
5. **Black-Height Property -** Every path from any node to its descendant NIL leaves contains the **same number of Black nodes**.

$\bigstar$ Properties 4 and 5 together are what force the tree height to stay in $O(\log\,n)$. Property 4 prevents any path from being dominated by Red nodes, and Property 5 ensures all paths have a uniform Black-node count — so no single path can be more than **twice as long** as any other.
## Black-Height
The **Black-Height** of a node $x$, denoted $bh(x)$, is the number of Black nodes on any path from $x$ (not including $x$ itself) down to a NIL leaf.

Since every such path must have the same count of Black nodes (Property 5), $bh(x)$ is well-defined.

Key results -
1. A Red-Black Tree with $n$ internal nodes has height at most -

$$
\boxed{h \leq 2\,\log_2(n+1)}
$$

2. The black-height $bh$ and the total height $h$ are related by -

$$
bh \geq \frac{h}{2}
$$

This follows directly from Property 4 — on any root-to-leaf path, at most half the nodes can be Red (since no two consecutive Red nodes are allowed), so at least half must be Black.

3. A Red-Black Tree with black-height $bh$ has at least $2^{bh} - 1$ internal nodes. The minimum case occurs when every internal node is Black (i.e. a perfect binary tree of all-Black nodes).

## Insertion in a Red-Black Tree
Insertion follows two stages — standard B.S.T insertion followed by fix-up to restore the Red-Black properties.

**Step 1 -** Insert the new node just like in a standard B.S.T. Colour the newly inserted node **Red**.

**Step 2 -** Fix violations. The only property that can be violated after inserting a Red node is Property 4 (if the parent is also Red). The fix-up depends on the colour of the **uncle** (the sibling of the parent).

Let the newly inserted node be $z$, its parent be $p$, grandparent be $g$, and uncle be $u$.

### Case 1 — Uncle is Red (Recolouring)
- Recolour the parent $p$ and uncle $u$ to **Black**.
- Recolour the grandparent $g$ to **Red**.
- Move $z$ up to $g$ and repeat the fix-up from $g$ (the grandparent may now violate Property 4 with *its* parent).

$\bigstar$ This case only recolours — no rotations needed.

### Case 2 — Uncle is Black (Rotations + Recolouring)
This case mirrors the [[Trees#Balancing a B.S.T|AVL rotation cases]]. The exact rotation depends on the configuration of $z$, $p$, and $g$ -

| Configuration | Rotation Required |
| :---: | :---: |
| $z$ is **left** child of $p$, $p$ is **left** child of $g$ | **LL** — Single right rotation on $g$ |
| $z$ is **right** child of $p$, $p$ is **right** child of $g$ | **RR** — Single left rotation on $g$ |
| $z$ is **right** child of $p$, $p$ is **left** child of $g$ | **LR** — Left rotation on $p$, then right rotation on $g$ |
| $z$ is **left** child of $p$, $p$ is **right** child of $g$ | **RL** — Right rotation on $p$, then left rotation on $g$ |

After the rotation(s), recolour appropriately so that the new subtree root is **Black** and its children are **Red**.

![[Pasted image 20260819093013.png]]

### Case 3 — $z$ is the Root
After any recolouring propagation reaches the root, simply recolour the root to **Black** (Property 2). This is the only operation that increases the black-height of the entire tree by 1.

## Deletion in a Red-Black Tree
Deletion is more involved than insertion because removing a **Black** node can violate the Black-Height Property (Property 5).

**Step 1 -** Perform standard B.S.T deletion. Let the node actually removed (or replaced) be $y$, and the node that takes its place be $x$.

**Step 2 -** If $y$ was **Red**, no property is violated — done. If $y$ was **Black**, the path through $x$ now has one fewer Black node, creating a "double-black" problem at $x$. Fix-up cases depend on the colour of $x$'s **sibling** $s$ -

| Case | Condition | Action |
| :---: | :--- | :--- |
| 1 | Sibling $s$ is **Red** | Recolour $s$ to Black and parent to Red, then rotate parent towards $x$. This converts to Case 2, 3, or 4. |
| 2 | Sibling $s$ is **Black**, both of $s$'s children are **Black** | Recolour $s$ to Red and move the "double-black" up to the parent. Repeat fix-up from the parent. |
| 3 | Sibling $s$ is **Black**, $s$'s child **closer** to $x$ is **Red**, **farther** child is **Black** | Recolour $s$'s closer child to Black and $s$ to Red, then rotate $s$ away from $x$. This converts to Case 4. |
| 4 | Sibling $s$ is **Black**, $s$'s child **farther** from $x$ is **Red** | Recolour $s$ with parent's colour, parent to Black, farther child to Black, then rotate parent towards $x$. **Terminates.** |

$\bigstar$ Case 4 is the **terminal case** — once you reach it, a single rotation and recolouring fixes the tree completely.

![[Pasted image 20260819093040.png|518]]

## Time Complexities

| Operation | Time Complexity |
| :---: | :---: |
| Search | $O(\log\,n)$ |
| Insertion | $O(\log\,n)$ |
| Deletion | $O(\log\,n)$ |
| Space | $O(n)$ |

- Insertion requires **at most 2 rotations** (the rest is recolouring, which propagates up at most $O(\log\,n)$ levels).
- Deletion requires **at most 3 rotations**.
## AVL Tree vs Red-Black Tree

| Criteria | [[Trees#AVL Tree\|AVL Tree]] | Red-Black Tree |
| :--- | :---: | :---: |
| Balancing | Strictly height-balanced ($\vert BF \vert \leq 1$) | Colour-based, loosely balanced |
| Height bound | $\leq 1.44\,\log_2(n+2)$ | $\leq 2\,\log_2(n+1)$ |
| Search | Slightly **faster** (shorter height) | Slightly **slower** |
| Insertion | **Slower** (up to $O(\log\,n)$ rotations) | **Faster** (at most 2 rotations) |
| Deletion | **Slower** (up to $O(\log\,n)$ rotations) | **Faster** (at most 3 rotations) |
| Extra storage per node | Balance factor (integer) | 1 bit (colour) |
| Best use case | Read-heavy workloads | Write-heavy workloads (used in `std::map`, Linux CFS scheduler, Java `TreeMap`) |

---

<h6 class="question">Q1) What is the maximum number of Red nodes in a Red-Black Tree of height $h$?</h6>

<u>Sol</u>$^1$ - In a Red-Black Tree, no two consecutive Red nodes can exist on any path (Property 4). So on any root-to-leaf path of length $h$, at most $\lfloor h/2 \rfloor$ nodes can be Red (alternating Red-Black starting from the root's child, since the root is always Black).

The maximum number of Red nodes across the entire tree occurs when the tree is a **complete binary tree** with alternating Black and Red levels (root is Black at level 0, all level-1 nodes are Red, all level-2 nodes are Black, and so on). In this configuration, every even-depth level is Black and every odd-depth level is Red.

Thus the maximum number of Red nodes = total nodes at all odd-depth levels = $\boxed{\frac{n-1}{2}}$ for a tree with $n$ internal nodes (where $n = 2^{h+1} - 1$ in the best case).