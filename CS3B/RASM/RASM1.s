/* -- RASM1.s -- */
@ Purpose: Program which will perform X = (A + B) - (C + D) calculations
@	   after user inputting 4 variables, then prints it.

		.data

szA:		.skip	12				@ String A
szPrompt:	.asciz	"Enter a whole number: "
szB:		.skip	12				@ String B
szPrompt2:	.asciz	"Enter a whole number: "
szC:		.skip	12				@ String C
szPrompt3:	.asciz	"Enter a whole number: " 
szD:		.skip	12				@ String D
szPrompt4:	.asciz	"Enter a whole number: "

iA:		.word	0	@ Int A
iB:		.word	0	@ Int B
iC:		.word	0	@ Int C
iD:		.word	0	@ Int D
iSum:		.word	0	@ will store Int A + B
iSub:		.word	0	@ will store Int C + D
iResult:	.word	0	@ will store Int Result

szName:		.asciz	"Name:	 Andres Quintana"
szClass:	.asciz	"Class:	 CS 3B"
szLab:		.asciz	"Lab:	 RASM1"
szDate:		.asciz	"Date:	 02/13/2021"

szAdrA:		.asciz	"        "	@ Address of int A
szAdrB:		.asciz	"        "	@ Address of int B
szAdrC:		.asciz	"        "	@ Address of int C
szAdrD:		.asciz	"        "	@ Address of int D

szLftPar:	.asciz	"("		@ Math  string Equations
szRgtPar:	.asciz	")"
szAdd:		.asciz	" + "
szSub:		.asciz	" - "
szEq:		.asciz	" = "

szAddress:	.asciz	"The addresses of the 4 ints: "
szAdrSpace:	.asciz	"   "

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
	
	ldr	r0, = iA	@ r0 = address of iA
	ldr	r1, =szAdrA	@ Load into r1 address of szAdrX
	mov	r2, #8		@ Number of nimble to display
	bl	hexToChar	@ Convert the hex to string

	/****************************  GET B INFO ****************************/

	ldr	r0, =szPrompt2	@ Load into r0 address of szPrompt2
	bl	putstring	@ Print Prompt

	ldr	r0, =szB	@ Load into r0 address of szB
	mov	r1, #13		@ The largest number that can be read 12(+1)

	bl	getstring	@ Read stdin (up to r1 bytes) and store in R0
	bl	ascint32	@ Convert the string into a int

	ldr	r1, =iB		@ r1 points to address iY
	str	r0, [r1]	@ [r1] iB = r0	

	ldr	r0, =iB		@ r0 = address of iB
	ldr	r1, =szAdrB	@ Load into r1 address of szAdrB
	bl	hexToChar	@ Convert the hex to string

	/****************************  GET C INFO ****************************/

	ldr	r0, =szPrompt3	@ Load into r0 address of szPrompt3
	bl	putstring	@ Print Prompt

	ldr	r0, =szC	@ Load into r0 address of szC
	mov	r1, #13		@ The largest number that can be read 12(+1)

	bl	getstring	@ Read stdin (up to r1 bytes) and store in R0
	bl	ascint32	@ Convert the string into a int

	ldr	r1, =iC		@ r1 points to address iC
	str	r0, [r1]	@ [r1] iC = r0	

	ldr	r0, =iC		@ r0 = address of iC
	ldr	r1, =szAdrC	@ Load into r1 address of szAdrC
	bl	hexToChar	@ Convert the hex to string
	
	/****************************  GET D INFO ****************************/

	ldr	r0, =szPrompt4	@ Load into r0 address of szPrompt4
	bl	putstring	@ Print Prompt

	ldr	r0, =szD	@ Load into r0 address of szD
	mov	r1, #13		@ The largest number that can be read 12(+1)

	bl	getstring	@ Read stdin (up to r1 bytes) and store in R0
	bl	ascint32	@ Convert the string into a int

	ldr	r1, =iD		@ r1 points to address iD
	str	r0, [r1]	@ [r1] iD = r0	

	ldr	r0, =iD		@ r0 = address of iD
	ldr	r1, =szAdrD 	@ Load into r1 address of szAdrD
	bl	hexToChar	@ Convert the hex to string

	/*************************** PRINT RESULT ****************************/
	
	ldr	r0, =chLF	@ End Line
	bl	putch
	
	/************Print Formula *************/
	ldr	r0, =szLftPar	@ Load Left Parentesis 
	bl	putstring	@ Print " ( "
	ldr	r0, =szA    	@ Load iA String
	bl	putstring	@ Print first variable (iA)
	ldr	r0, =szAdd	@ Load Add symbol
	bl	putstring	@ Print " + "
	ldr	r0, =szB	@ Load iB String
	bl	putstring	@ Print first variable (iB)
	ldr	r0, =szRgtPar	@ Load Right Parentesis 
	bl	putstring	@ Print " ) "
	
	ldr	r0, =szSub	@ Load substraction symbol
	bl 	putstring	@ Print " - "
	
	ldr	r0, =szLftPar	@ Load Left Parentesis 
	bl	putstring	@ Print " ( "
	ldr	r0, =szC    	@ Load iC String
	bl	putstring	@ Print first variable (iC)
	ldr	r0, =szAdd	@ Load Add symbol
	bl	putstring	@ Print " + "
	ldr	r0, =szD	@ Load iD String
	bl	putstring	@ Print first variable (iD)
	ldr	r0, =szRgtPar	@ Load Right Parentesis 
	bl	putstring	@ Print " ) "
	
	ldr	r0, =szEq	@ Load Equals symbol
	bl	putstring	@ Print " = "
	
	/************Calculate Result *************/
	ldr	r3, =iA		@ Load into r3 address of iA
	ldr	r3, [r3]	@ r3 = *r3
	ldr	r4, =iB		@ Load into r4 address of iB
	ldr	r4, [r4]	@ r4 = *r4
	ldr	r5, =iC		@ Load into r5 address of iC
	ldr	r5, [r5]	@ r5 = *r5
	ldr	r6, =iD		@ Load into r6 address of iD
	ldr	r6, [r6]	@ r6 = *r6

	ldr	r1, =iSum	@ Load into r0 address of iSum
	add	r1, r3, r4	@ iSum = iA + iB 
	ldr	r2, =iSub	@ Load into r0 address of iSub
	add	r2, r5, r6	@ iSub = iC + iD
	ldr	r0, =iResult	@ Load into r0 address of iResult
	sub	r0, r1, r2	@ iResult = iSum - iSub

	ldr	r1, =szA	@ Load into r1 address of szA
	bl	intasc32	@ Convert iResult into a string
	ldr	r0, =szA	@ Load into r0 address of szA
	bl	putstring	@ Print result	

	ldr	r0, =chLF	@ End Line
	bl	putch
	ldr	r0, =chLF	@ End Line
	bl	putch

	/*************************** PRINT ADDRESS **************************/
	ldr	r0, =szAddress	@ Load into r0 address of szAddress
	bl	putstring	@ Print Prompt
	ldr	r0, =chLF	@ End Line
	bl	putch
	
	ldr	r0, =szAdrA	@ Load iA address string
	bl	putstring	@ Print iA address string
	ldr	r0, =szAdrSpace	@ Load inro r0 address of szAdrSpace
	bl	putstring	@ Print space in between the address
	
	ldr	r0, =szAdrB	@ Load iB address string
	bl	putstring	@ Print iA address string
	ldr	r0, =szAdrSpace	@ Load inro r0 address of szAdrSpace
	bl	putstring	@ Print space in between the address
	
	ldr	r0, =szAdrC	@ Load iC address string
	bl	putstring	@ Print iA address string
	ldr	r0, =szAdrSpace	@ Load inro r0 address of szAdrSpace
	bl	putstring	@ Print space in between the address
	
	ldr	r0, =szAdrD	@ Load iD address string
	bl	putstring	@ Print iA address string
	ldr	r0, = chLF	@ End Line
	bl	putch
	ldr	r0, = chLF
	bl	putch

	mov r0, #0		@ Set program Exit status to 0
	mov r7, #1		@ Serivce command of 1 ro terminate
	svc 0			@ Perform Service Call to Linux
	.end
