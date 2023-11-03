@*****************************************************************************
@Name:      Andres Quintana
@Program:   lab18.s
@Class:     CS 3B
@Purpose:
@     calls your String_Length() function and outputs the length 
@	  of the string passed to it using putstring().
@*****************************************************************************
	
	.data
	strPrompt:	.asciz	"Enter String: "
	strA:		.skip	32

	iA:			.word	0	@ Int length

	chLF:		.byte	0x0a
	
	.text
	.global _start		@Starting address to linker
	.extern	string_length

_start:
	/****************************  GET STRING ****************************/
	
	ldr	r0, =chLF	@ End Line
	bl	putch
	
	ldr	r0, =strPrompt	@ Load into r0 address of szPrompt
	bl	putstring	@ Print Prompt 

	ldr	r0, =strA	@ Load into r0 address of szA
	mov	r1, #32		@ The largest number that can be read 12(+1)
	
	bl	getstring	@ Read stdin (up to r1 bytes) and store in R0
	bl 	_length		@ Go to string_length()
	
	ldr	r1, =strA	@ Load into r1 address of szA
	bl	intasc32	@ Convert iResult into a string
	ldr	r0, =strA	@ Load into r0 address of szA
	bl	putstring	@ Print result

end:
	ldr	r0, =chLF	@ End Line
	bl	putch
	
	mov r0, #0
	mov r7, #1
	svc 0
	.end
