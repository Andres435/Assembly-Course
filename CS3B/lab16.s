@*****************************************************************************
@Name:      Andres Quintana
@Program:   lab16.s
@Class:     CS 3B
@Purpose:
@     Get User Input and divide
@*****************************************************************************
	
	.data
	strName:	.asciz	"Name:	 Andres Quintana"
	strClass:	.asciz	"Class:	 CS 3B"
	strLab:		.asciz	"Lab:	 Lab16"
	strDate:	.asciz	"Date:	 03/19/2021"
	
	strPrompt:	.asciz	"Enter X: "
	strPrompt2:	.asciz	"Enter Y: "
	strA:		.skip	4
	strB:		.skip	4
	
	strEqual:	.asciz	" = "
	strDivide:	.asciz	" / "
	strNotDiv:	.asciz	"You cannot divide by 0"

	iA:			.word	0	@ Int A
	iB:			.word	0	@ Int B

	chLF:		.byte	0x0a
	
	.text
	.global _start		@Starting address to linker
	.extern	IDIV

_start:
	/****************************  Print Info ****************************/
	
	ldr	r0, =chLF	@ End Line
	bl	putch
	
	ldr 	r0, =strName	@ Load szName
	bl 	putstring	@ Print name
	ldr	r0, =chLF	@ End Line
	bl	putch
	ldr	r0, =strClass	@ Load szClass
	bl 	putstring	@ Print Class
	ldr	r0, =chLF	@ End Line
	bl	putch
	ldr	r0, =strLab	@ Load szLab
	bl 	putstring	@ Print Lab
	ldr	r0, =chLF	@ End Line
	bl	putch
	ldr	r0, =strDate	@ Load szDate
	bl 	putstring	@ Print Date

	ldr	r0, =chLF	@ End Line
	bl	putch
	
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
	
	/****************************  GET Y INFO ****************************/
		
	ldr	r0, =strPrompt2	@ Load into r0 address of szPrompt
	bl	putstring	@ Print Prompt 

	ldr	r0, =strB	@ Load into r0 address of szB
	mov	r1, #13		@ The largest number that can be read 12(+1)

	bl	getstring	@ Read stdin (up to r1 bytes) and store in R0
	bl	ascint32	@ Convert the string into a int

	ldr	r1, =iB		@ r1 points to address iB
	str	r0, [r1]	@ [r1] iB = r0
	
	/*****************************  PRINT DIV ****************************/
	
	ldr	r0, =strA	@ Load X 
	bl	putstring	@ Print X
	ldr	r0, =strDivide	@ Load Divide symbol
	bl	putstring	@ Print " \ "
	ldr	r0, =strB	@ Load Y
	bl	putstring	@ Print Y
	ldr	r0, =strEqual	@ Load Equals symbol 
	bl	putstring	@ Print " = "
	
	ldr	r0, =iA		@ Load into r0 address of iA
	ldr	r0, [r0]	@ r0 = *r0
	ldr	r1, =iB		@ Load into r1 address of iB
	ldr	r1, [r1]	@ r1 = *r1
	
	cmp	r1, #0		@ Check if Divisor = 0
	beq	zeroDivision	@ If so Jump to zeroDivision
	
	bl	_main		@ Call IDIV.s
	
	ldr	r1, =strA	@ Load into r1 address of szA
	bl	intasc32	@ Convert iResult into a string
	ldr	r0, =strA	@ Load into r0 address of szA
	bl	putstring	@ Print result	

	ldr	r0, =chLF	@ End Line
	bl	putch
	b	end

zeroDivision:
	ldr	r0, =strNotDiv	@ Load into r0 address of strNotDiv
	bl	putstring	@ Print Prompt
	ldr	r0, =chLF	@ End Line
	bl	putch

end:
	mov r0, #0
	mov r7, #1
	svc 0
	.end
