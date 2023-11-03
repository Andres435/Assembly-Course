@*****************************************************************************
@Name:      Andres Quintana
@Program:   lab17.s
@Class:     CS 3B
@Purpose:
@     Get User Input and use recursion to find factorial of the input
@*****************************************************************************
	
	.data	
	strPrompt:	.asciz	"Enter factorial: "
	strResult:	.asciz	"Factorial of "
	strResult2:	.asciz	"! is "
	strA:		.skip	12

	iA:			.word	0	@ Int A

	chLF:		.byte	0x0a
	
	.text
	.global _start		@Starting address to linker
	.extern	fact(n)

_start:
	/****************************  GET X INFO ****************************/
	
	ldr	r0, =chLF	@ End Line
	bl	putch
	
	ldr	r0, =strPrompt	@ Load into r0 address of szPrompt
	bl	putstring	@ Print Prompt 

	ldr	r0, =strA	@ Load into r0 address of szA
	mov	r1, #13		@ The largest number that can be read 12(+1)

	bl	getstring	@ Read stdin (up to r1 bytes) and store in R0
	bl	ascint32	@ Convert the string into a int

	ldr	r1, =iA		@ r1 points to address iA
	str	r0, [r1]	@ [r1] iA = r0
	
	/*****************************  FACTORIAL ****************************/
	
	ldr	r0, =strResult	@ Load strResult into r0
	bl	putstring	@ Print strResult
	ldr	r0, =strA	@ Load X
	bl	putstring	@ Print X
	ldr	r0, =strResult2 @ Load strResult2 into r0
	bl	putstring	@ Print strResult

	ldr	r0, =iA		@ Load iA into r0
	ldr	r0, [r0]	@ r0 = *r0
	
	bl	_fact		@ Call fact.s
	
	ldr	r1, =strA	@ Load into r1 address of szA
	bl	intasc32	@ Convert iResult into a string
	ldr	r0, =strA	@ Load into r0 address of szA
	bl	putstring	@ Print result	

	ldr	r0, =chLF	@ End Line
	bl	putch
	b	end

end:
	mov r0, #0
	mov r7, #1
	svc 0
	.end
