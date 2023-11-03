/* -- RASM1.s -- */
@ Purpose: Program which will perform X = 2(A + 2B) calculations
@	   after user inputting 2 variables, then prints it.

		.data

szA:		.skip	12				@ String A
szPrompt:	.asciz	"Enter X: "
szB:		.skip	12				@ String B
szPrompt2:	.asciz	"Enter Y: "

iA:		.word	0	@ Int A
iB:		.word	0	@ Int B

iSum:		.word	0	@ will store Int A + B
iResult:	.word	0	@ will store Int Result

szName:		.asciz	"Name:	 Andres Quintana"
szClass:	.asciz	"Class:	 CS 3B"
szLab:		.asciz	"Lab:	 EXAM 1"
szDate:		.asciz	"Date:	 03/08/2021"

szLftPar:	.asciz	"("		@ Math  string Equations
szRgtPar:	.asciz	")"
szAdd:		.asciz	" + "
szMul:		.asciz	" * "
szTwo:		.asciz	" 2"
szEq:		.asciz	" = "

chLF:		.byte	0x0a

		.text
		.global _start		@Starting address to linker

_start:
	/****************************  Print Info ****************************/
	
	ldr	r0, =chLF	@ End Line
	bl	putch
	
	ldr 	r0, =szName	@ Load szName
	bl 	putstring	@ Print name
	ldr	r0, =chLF	@ End Line
	bl	putch
	ldr	r0, =szClass	@ Load szClass
	bl 	putstring	@ Print Class
	ldr	r0, =chLF	@ End Line
	bl	putch
	ldr	r0, =szLab	@ Load szLab
	bl 	putstring	@ Print Lab
	ldr	r0, =chLF	@ End Line
	bl	putch
	ldr	r0, =szDate	@ Load szDate
	bl 	putstring	@ Print Date

	ldr	r0, =chLF	@ End Line
	bl	putch
	ldr	r0, =chLF	@ End Line
	bl	putch
	
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
	mov	r1, #13		@ The largest number that can be read 12(+1)

	bl	getstring	@ Read stdin (up to r1 bytes) and store in R0
	bl	ascint32	@ Convert the string into a int

	ldr	r1, =iB		@ r1 points to address iY
	str	r0, [r1]	@ [r1] iB = r0	

	/*************************** PRINT RESULT ****************************/
	
	ldr	r0, =chLF	@ End Line
	bl	putch
	
	/************Print Formula *************/
	ldr	r0, =szTwo	@ Load  the string 2  into r0
	bl	putstring	@ Print " 2 "
	ldr	r0, =szLftPar	@ Load Left Parentesis 
	bl	putstring	@ Print " ( "
	ldr	r0, =szA    	@ Load iA String
	bl	putstring	@ Print first variable (iA)
	
	ldr	r0, =szAdd	@ Load Add symbol
	bl	putstring	@ Print " + "
	
	ldr	r0, =szTwo	@ Load  the string 2  into r0
	bl	putstring	@ Print " 2 "
	ldr	r0, =szMul	@ Load  the multiplier sign into r0
	bl	putstring	@ Print " * "
	ldr	r0, =szB	@ Load iB String
	bl	putstring	@ Print first variable (iB)
	ldr	r0, =szRgtPar	@ Load Right Parentesis 
	bl	putstring	@ Print " ) "
	
	ldr	r0, =szEq	@ Load Equals symbol
	bl	putstring	@ Print " = "
	
	/************Calculate Result *************/
	ldr	r3, =iA		@ Load into r3 address of iA
	ldr	r3, [r3]	@ r3 = *r3
	
	ldr	r4, =iB		@ Load into r4 address of iB
	ldr	r4, [r4]	@ r4 = *r4
	add r4, r4		@ 2 * iB

	ldr	r1, =iSum	@ Load into r0 address of iSum
	add	r1, r3, r4	@ iSum = iA + iB 
	
	ldr	r0, =iResult	@ Load into r0 address of iResult
	add	r0, r1, r1	@ iResult =  2(iA + 2(iB))

	ldr	r1, =szA	@ Load into r1 address of szA
	bl	intasc32	@ Convert iResult into a string
	ldr	r0, =szA	@ Load into r0 address of szA
	bl	putstring	@ Print result	

	ldr	r0, =chLF	@ End Line
	bl	putch
	ldr	r0, =chLF	@ End Line
	bl	putch


	mov r0, #0		@ Set program Exit status to 0
	mov r7, #1		@ Serivce command of 1 ro terminate
	svc 0			@ Perform Service Call to Linux
	.end
