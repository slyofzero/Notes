Linked list is a linear data structure which contains many elements/nodes and each node is connected to zero or more nodes.
# Types of Linked Lists
1. Singly Linked List
2. Double Linked List
3. Circular Singly Linked List
4. Circular Doubly Linked List
# Structure of Node
Default assumption for all Linked Lists is that the `tail` pointer is not there. Only `head` exists.
## 1. Singly Linked List
```ts
Node = {
	data: any,
	next: Node | null
}

SLL = {
	head: Node | null
	tail: Node | null // optional
}
```
## 2. Doubly Linked List
```ts
Node = {
	data: any,
	next: Node | null,
	prev: Node | null
}
```
## 3. Circular Singly Linked List
Same as SLL, just the tail node will point back to the start node.
## 4. Circular Doubly Linked List
Same as DLL, just the tail node will point back to the start node.
# Time Complexities
## 1. Non-circular lists

| Operation                   | SLL (No tail pointer) | SLL (With tail pointer) | DLL (No tail pointer) | DLL (With tail pointer) |
| :-------------------------- | :-------------------: | :---------------------: | :-------------------: | :---------------------: |
| ==Insert== at Beginning     |        $O(1)$         |         $O(1)$          |        $O(1)$         |         $O(1)$          |
| Insert at End               |        $O(n)$         |         $O(1)$          |        $O(n)$         |         $O(1)$          |
| Insert at Index             |        $O(n)$         |         $O(n)$          |        $O(n)$         |         $O(n)$          |
| ==Deletion== from Beginning |        $O(1)$         |         $O(1)$          |        $O(1)$         |         $O(1)$          |
| Deletion from End           |        $O(n)$         |         $O(n)$          |        $O(n)$         |         $O(1)$          |
| Deletion at Index           |        $O(n)$         |         $O(n)$          |        $O(n)$         |         $O(n)$          |
## 2. Circular lists
A Circular Doubly Linked List doesn't need an extra tail pointer as `self.head.prev` is the tail itself.

| Operation                   | CSLL (No tail pointer) | CSLL (With tail pointer) | CDLL (`head.prev` is the tail) |
| :-------------------------- | :--------------------: | :----------------------: | :----------------------------: |
| ==Insert== at Beginning     |         $O(n)$         |          $O(1)$          |             $O(1)$             |
| Insert at End               |         $O(n)$         |          $O(1)$          |             $O(1)$             |
| Insert at Index             |         $O(n)$         |          $O(n)$          |             $O(n)$             |
| ==Deletion== from Beginning |         $O(n)$         |          $O(1)$          |             $O(1)$             |
| Deletion from End           |         $O(n)$         |          $O(n)$          |             $O(1)$             |
| Deletion at Index           |         $O(n)$         |          $O(n)$          |             $O(n)$             |
