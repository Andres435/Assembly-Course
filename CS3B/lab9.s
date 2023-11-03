/* -- Lab9.s -- */
@ Purpose: Enter two integers and compare them 
@		to see which on is bigger

		.data

szA:		.skip	12
szPrompt:	.asciz	"Enter first value: "

szB:		.skip	12
szPrompt2:	.asciz	"Enter second value: "

iA:		.word	0
iB:		.word	0

		.text
		.global _start		@Starting address to linker

_start:
	/****************************  GET A INFO ****************************/
	
	ldr	r0, =szPrompt	@ Load into r0 address of szPrompt
	bl	putstring	@ Print Prompt 

	ldr	r0, =szA	@ Load into r0 address of szA
	mov	r1, #13		@ The largest number that can be read 12(+1)

	bl	getstring	@ Read stdin (up to r1 bytes) and store in R0
	bl	ascint32	@ Convert the string into a int

	ldr	r1, =iA		@ r1 points to address iA
	str	r0, [r1]	@ [r1] iA = r0
	
	/****************************  GET B INFO ****************************/
	
	ldr	r0, =szPrompt2	@ Load into r0 address of szPrompt2
	bl	putstring	@ Print Prompt

	ldr	r0, =szB	@ Load into r0 address of szB
	mov	r1, #13	

	bl	getstring	@ Read stdin (up to r1 bytes) and store in R0
	bl	ascint32	@ Convert the string into a int

	ldr	r2, =iB		@ r2 points to address iB
	str	r0, [r2]	@ [r2] iB = r0
	
	/****************************  COMPARE ****************************/

	ldr	r1, =iA		@ Load into r1 address of iA
	ldr	r1, [r1]	@ r1 = *r1
	ldr	r2, =iB		@ Load into r2 address of iA
	ldr	r2, [r2]	@ r2 = *r2

	cmp	r2, r1		@ Compare iB and iA
	bgt	iBBigger	@ If iA greater than iB jump to iABigger
	
	ldr r0, =iA		@ Load iA into r0
	ldr	r0, [r0]	@ r0 = *r0
	b	finish		@ Jump to finish
	
iBBigger:

	ldr	r0, =iB		@ Load iB into r0
	ldr	r0, [r0]	@ r0 = *r0
	b	finish		@ Jump to finish
	
finish:

	mov r0, #0		@ Set program Exit status to 0
	mov r7, #1		@ Serivce command of 1 ro terminate
	svc 0			@ Perform Service Call to Linux
	.end
