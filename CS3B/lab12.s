/* -- Lab10.s -- */
@ Purpose:  Intended to familiarize with instructions that affect
@			on the CPSR register

		.data

szX:		.skip	12
szPrompt:	.asciz	"Enter X value: "

szY:		.skip	12
szPrompt2:	.asciz	"Enter Y value: "

iX:		.word	0
iY:		.word	0

szEqual:	.asciz	" == "
szGreater:	.asciz	" > "
szLessThan:	.asciz	" < "

chLF:		.byte	0x0a

		.text
		.global _start		@Starting address to linker

_start:
	/****************************  GET A INFO ****************************/
	
	ldr	r0, =szPrompt	@ Load into r0 address of szPrompt
	bl	putstring	@ Print Prompt 

	ldr	r0, =szX	@ Load into r0 address of szX
	mov	r1, #13		@ The largest number that can be read 12(+1)

	bl	getstring	@ Read stdin (up to r1 bytes) and store in R0
	bl	ascint32	@ Convert the string into a int

	ldr	r1, =iX		@ r1 points to address iX
	str	r0, [r1]	@ [r1] iX = r0
	
	/****************************  GET B INFO ****************************/
	
	ldr	r0, =szPrompt2	@ Load into r0 address of szPrompt2
	bl	putstring	@ Print Prompt

	ldr	r0, =szY	@ Load into r0 address of szY
	mov	r1, #13	

	bl	getstring	@ Read stdin (up to r1 bytes) and store in R0
	bl	ascint32	@ Convert the string into a int

	ldr	r2, =iY		@ r2 points to address iY
	str	r0, [r2]	@ [r2] iY = r0
	
	/****************************  COMPARE ****************************/

	ldr	r0, =chLF	@ End Line
	bl	putch
	
	ldr	r0, =szX	@ Load iX String
	bl	putstring	@ Print iX
	
	ldr	r0, =iX		@ Load into r0 address of iX
	ldr	r0, [r0]	@ r0 = *r0
	ldr	r1, =iY		@ Load into r1 address of iY
	ldr	r1, [r1]	@ r1 = *r1

	cmp	r0, r1
	beq	equal		@ If x == y jump to equal
	bgt	greaterThan	@ If x > Y jump to greaterThan
	
	@ LessThan
	ldr	r0, =szLessThan	@ Load into r0 address szLessThan
	bl	putstring		@ Print Prompt
	
	b finish		@ Jump to finish
	
equal:
	ldr	r0, =szEqual	@ Load into r0 address szEqual
	bl	putstring		@ Print Prompt
	b	finish		@ Jump to finish
	
greaterThan:
	ldr	r0, =szGreater	@ Load into r0 address szGreater
	bl	putstring		@ Print Prompt
	b	finish		@ Jump to finish
	
finish:
	ldr	r0, =szY	@ Load iY String
	bl	putstring	@ Print iY
	
	ldr	r0, =chLF	@ End Line
	bl	putch
	ldr	r0, =chLF	@ End Line
	bl	putch
	
	mov r0, #0		@ Set program Exit status to 0
	mov r7, #1		@ Serivce command of 1 ro terminate
	svc 0			@ Perform Service Call to Linux
	.end
