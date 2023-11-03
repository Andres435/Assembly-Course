@******************************************************************
@ Purpose: To edit the string content of a node given its index
@          within the linked list.
@
@ R0: Contains the head pointer.
@ R1: Contains the index of the node to edit.
@ R2: Contains the new string.
@
@ Returned register contents:
@ All registers preserved.
@******************************************************************

	.data

ndPtr:	.word 0                       @ pointer to node

	.text                             @ the text directive
	
	.global editNode               @ provides a starting address for the linker
	
editNode:
	/* Push registers to preserve contents */
	push	{r4-r8, r10, r11}         @ push registers to stack to preserve them
	push	{lr}                      @ push lr to stack to preserve

	ldr	r4, =ndPtr                    @ load into r4 the address of ndPtr
	ldr	r5, [r0]                      @ load into r5 the address of head node r5=head
	str	r5, [r4]                      @ store the head node in ndPtr so ndPtr = head  r4=head
	ldr	r4, [r4]                      @ load into r4 the address ndPtr points to (head) r4=ndPtr
	mov	r6, r1                        @ move index to r6
	mov r8, r2                        @ move the new string to r8 to preserve from free
	
	push	{r0-r2}                   @ push args to stack to preserve them
	

loop:
	/* Loop through linked list until at node to edit */
	cmp	r6, #0                        @ see if at node to edit
	beq	edit                          @ branch to exit if node equals null
	ldr	r4, [r4, #4]                  @ load into r4 the value of r4 offset by 4
	sub	r6, r6, #1                    @ subtracts counter by one
	b	loop                          @ branch back to loop
	
edit:
	/* Frees the old string in node then places new one */
	ldr	r0, [r4]                      @ load into r7 the string pointer
	bl	free                          @ frees the string memory
	str r8, [r4]                      @ store the new string at string pointer
	
exit:
	/* exit the program */

	pop	{r0-r2}                       @ pop r0-r2 off the stack
	pop	{lr}                          @ pop lr off the stack
	pop	{r4-r8, r10, r11}             @ pop registers off the stack
	bx	lr                            @ return to function call
	.end

	
	
	
