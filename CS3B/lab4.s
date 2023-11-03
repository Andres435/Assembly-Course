/* -- Lab4.s */
/* This is a comment */
@ This is also a comment
@ Purpose: Add 3 + 5 and store the result in r0

	.data

iX:	.word 3
iY:	.word 5
dZ:	.quad 6
chChar:	.byte 'B'
iA:	.word -1

/*	.balign 4 	*/
	.text

	.global _start		@ Program starting address to linker
_start:
	ldr	r0, =iX		@load into r0 address of iX
	ldr	r0, [r0]	@dereference r0 to get value

	ldr	r1, =iY		@load into r1 , iY
	ldr	r1, [r1]	@dereference r1

	add	r0, r1		@ r0 = r0 + r1

	@mov	r0, #0		@ Set program Exit Status code to 0
	mov	r7, #1		@ Service command code 1 to terminate

	svc	0		@ Perform Service call to linux
	.end  
