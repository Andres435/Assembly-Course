@******************************************************************
@ Program: insertLast.s 
@ Purpose: Create an external function to insert node first.
@
@ R0: Contains the address of the head of the linked list.
@ R1: Contains the address of the tail of the linked list.
@ R2: Contains the pointer to the data to put in node.
@ LR: Contains the link address.
@
@ Returned register contents:
@ R0: contains the address of the head of the linked list.
@ R1: contains the address of the tail of the linked list.
@ All registers preserved except R0.
@******************************************************************
	.data
newNode:	.word 0

	.text                                @ the text directive
	
	.global lastInsert                  @ provides a starting address for the linker
	
lastInsert:
	push	{r4-r8, r10, r11}            @ pushes registers to stack to preserve them
	push    {lr}                         @ pushes lr and sp to stack to preserve them
	
	/* Create newNode = newNode<Type> */
	push	{r0-r3}                      @ push r1 to r3 to preserve from malloc
	mov	r1, #0                           @ clear r1
	mov	r2, #0                           @ clear r2
	
	mov	r0, #8                           @ need 8 bytes for new node
	                                     @ first 4 point to *ptrStr
										 @ last 4 point to *next
	bl	malloc                           @ request memory allocation
	
	mov	r4, r0                           @ move the address of newly allocated mem to r4
	pop	{r0-r3}                          @ pop r1 to r3 off stack for later use
	
	ldr	r5, =newNode                     @ load into r5 address of newNode
	str	r4, [r5]                         @ store the address that points to newNode in r5
	ldr	r5, [r5]                         @ r5 = *newNode
	str	r2, [r5]                         @ newNode->ptrStr = r2
	
	
	mov	r4, #0                           @ r4 = NULL
	str	r4, [r5, #4]                     @ newNode->next = NULL
	
	/* If(head==nullptr) both head and tail = newNode */
	ldr	r10, [r0]                        @ dereference head variable
	cmp r10, #0                           @ compare r0 to null 
	bne	step2                            @ branch to step2 if head==nullptr
	str r5, [r0]                         @ stores the address of newNode to head
	str	r5, [r1]                         @ stores the address of newNode to tail
	b	exit                             @ branch to exit
	
step2:
	/* If linked list is not empty, insert newNode after last */
	ldr	r7, [r1]                         @ dereference tail
	add	r7, #4                           @ add 4 to the tail so equals tail->next
	str	r5, [r7]                         @ stores newNode address to tail->next
	str	r5, [r1]                         @ stores the address of newNode to tail
	
exit:	
	
	pop	{lr}                             @ pops lr and sp from the stack
	pop	{r4-r8, r10, r11}                @ pops registers from the stack
	
	bx	lr                               @ branch back to function call
	.end

	
	
	
