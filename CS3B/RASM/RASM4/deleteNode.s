@******************************************************************
@ Purpose: To delete the string content and the node at a given index.
@
@ R0: Contains the head pointer.
@ R1: Contains the tail pointer.
@ R1: Contains the index of the node to delete.
@
@ Returned register contents:
@ All registers preserved.
@******************************************************************

	.data

ndPtr:	.word 0                       @ pointer to node
prevNode:	.word                     @ pointer to the prevNode
	.text                             @ the text directive
	
	.global deleteNode                @ provides a starting address for the linker
	
deleteNode:
	/* Push registers to preserve contents */
	push	{r4-r8, r10, r11}         @ push registers to stack to preserve them
	push	{lr}                      @ push lr to stack to preserve

	ldr	r4, =ndPtr                    @ load into r4 the address of ndPtr
	ldr	r5, [r0]                      @ load into r5 the address of head node r5=head
	str	r5, [r4]                      @ store the head node in ndPtr so ndPtr = head  r4=head
	ldr	r4, [r4]                      @ load into r4 the address ndPtr points to (head) r4=*head
	
	ldr	r10, [r1]                     @ load into r10 = *tail
	mov	r11,  r1                      @ load into r11 = tail
	mov	r5, r0                        @ move the address of head variable to r5
	
	mov	r6, r2                        @ move index to r6
	push	{r0-r2}                   @ push args to stack to preserve them
	
	cmp	r6, #0                        @ check if node to delete is head
	beq	deleteHead                    @ jump to delete head if index is 0
	mov	r8, #0                        @ clear r8

loop:
	/* Loop through linked list until at node to delete */
	cmp	r6, #0                        @ see if at node to edit
	beq	delete                        @ branch to delete if counter reaches 0
	mov	r8, r4                        @ move r4 to r10 to keep track of previous node
	ldr	r4, [r4, #4]                  @ load into r4 the value of r4 offset by 4
	sub	r6, r6, #1                    @ subtracts counter by one
	b	loop                          @ branch back to loop
	
deleteHead:
	/* Free the content of node, then move head to next node, then free node */
	cmp r4, r10                       @ see if the tail == head
	beq	deleteHeadTail                @ delete head and tail if they are same
	ldr	r0, [r4]                      @ r0 = *head->str
	bl	free                          @ frees the string 
	mov r0, r4                        @ move node in r4 *head to r0
	ldr r7, [r4, #4]                  @ r7 = *head->next
	str	r7, [r5]                      @ head = head->next
	bl	free                          @ frees the node
	mov	r4, #0                        @ null deleted ptr
	mov	r0, #0                        @ clear r0
	b	exit                          @ branch to the exit
	
deleteHeadTail:
	/* The case of if linked list has only one node making head == tail */
	ldr	r0, [r4]                      @ r0 = *head->str
	bl	free                          @ frees the string 
	mov r0, r4                        @ move node in r4 *head to r0
	ldr r7, [r4, #4]                  @ r7 = *head->next
	str	r7, [r5]                      @ head = head->next
	bl	free                          @ free the node
	mov	r4, #0                        @ null deleted pointer
	mov r0, #0                        @ nulling deleted pointer
	str r4, [r11]                     @ make tail = nullptr
	b	exit                          @ branch to exit
	
delete:
	/* Deletes node in r4 */
	ldr r7, [r4, #4]                  @ r7 = *curr->next
	cmp	r7, #0                        @ check to see if on last node
	beq	deleteLast                    @ if on *curr->next == nullptr jump to delete last
	ldr	r0, [r4]                      @ r0 = *curr->str
	bl	free                          @ frees the string
	str	r7, [r8, #4]                  @ Set prev->next = curr->next
	mov r0, r4                        @ move node in r4 *head to r0
	bl	free                          @ frees the node
	mov	r4, #0                        @ null deleted ptr
	mov	r0, #0                        @ clear r0
	b	exit
	
	
deleteLast:
	/* Case if node is last in list */
	ldr	r0, [r4]                      @ r0 = *curr->str
	bl	free                          @ frees the string
	mov r0, r4                        @ move node in r4 *head to r0
	bl	free                          @ frees the node
	mov	r4, #0                        @ null deleted ptr
	mov r0, #0                        @ clear r0
	str	r8, [r11]                     @ set tail = prev
	str	r0, [r8, #4]                  @ set prev->next = nullptr
	
exit:
	/* exit the program */

	pop	{r0-r2}                       @ pop r0-r2 off the stack
	pop	{lr}                          @ pop lr off the stack
	pop	{r4-r8, r10, r11}             @ pop registers off the stack
	bx	lr                            @ return to function call
	.end

	
	
	
