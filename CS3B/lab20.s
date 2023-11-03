@*****************************************************************************
@Name:      Andres Quintana
@Program:   lab20.s
@Class:     CS 3B
@Purpose:
@     Write the string "cat in the hat" to a text file "output.txt"
@	
@rwx rwx rwx
@--- 010 000
@*****************************************************************************
	.equ	W,	0101
	.equ	_W_,	0600
	
	.data
	strMsg:		.asciz	"Cat in the hat"
	strOutput:	.asciz	"output.txt"
	
	.text
	.global _start		@Starting address to linker
	
_start:
	mov	r7, #5			@ SVC Code of opemimg the file
	ldr	r0, =strOutput		@ Name of the file to open
	mov	r1, #W			@ Open for writing
	mov	r2, #_W_		@ Set permission to W for user only
	svc	0			@ Create the file
	push	{r0}			@ Save File Handler
	
	mov	r7, #4			@ SVC Code for writing to the file
	ldr	r1, =strMsg		@ Address of the string (char*)
	mov	r0, r1
	mov	r6, r1
	bl	_length			@ Get string length
	mov	r1, r6
	mov	r2, r0
	pop	{r0}			@ Realease File Handler
	svc	0
	
	mov	r7, #6			@ SVC Code of closing the file
	svc	0			@ Create the file
	
	mov	r0, #0			@ Set program Exit Status Code to 0
	mov	r7, #1			@ Service command code of 1 to terminate pgm.
	svc	0
	.end
