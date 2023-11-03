@*****************************************************************************
@Name:      Andres Quintana
@Program:   RASM2.s
@Class:     CS 3B
@Lab:       RASM2
@Date:      March 15, 2021 at 3:30 PM
@Purpose:
@     Input numeric information from the keyboard, perform addition, subtraction, 
@     multiplication, and division. Check for overflow upon all operations. 
@*****************************************************************************
	
		.data

strA:		.skip	512				@ String A
strPrompt:	.asciz	"Enter a first number:	"
strB:		.skip	512				@ String B
strPrompt2:	.asciz	"Enter a second number:	"

iA:		.word	0	@ Int A
iB:		.word	0	@ Int B
iQuatient:	.word	0	@ will store Int Result
iRemainder:	.word	0	@ will store Int Result

strName:	.asciz	"	Name:	 Andres Quintana"
strClass:	.asciz	"	Class:	 CS 3B"
strLab:		.asciz	"	Lab:	 RASM2"
strDate:	.asciz	"	Date:	 03/15/2021"

strSum:		.asciz	"The Sum is "
strSub:		.asciz	"The Difference is "
strMult:	.asciz	"The Product is "
strQuot:	.asciz	"The Quotient is "
strRem:		.asciz	"The Remainder is "

strNotDiv:	.asciz	"You cannot divide by 0. Thus, there is NO quotient or remainder  "
strInvalid:	.asciz	"INVALID NUMERIC STRING. RE-ENTER VALUE "
strOverflow:	.asciz	"OVERFLOW OCCURRED. RE-ENTER VALUE "
strSumOvFl:	.asciz	"OVERFLOW OCCURRED WHEN ADDING "
strSubOvFl:	.asciz	"OVERFLOW OCCURRED WHEN SUBSTRACTING "
strMultOvFl:	.asciz	"OVERFLOW OCCURRED WHEN MULTIPLYING "
strEnd:		.asciz	" Thanks for using my program!! Good Day! "

chLF:		.byte	0x0a

		.text
		.global _start		@Starting address to linker

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
	ldr	r0, =chLF	@ End Line
	bl	putch
		
	/****************************  GET A INFO ****************************/
	
inputLoop:
	ldr	r0, =chLF	@ End Line
	bl	putch

	ldr	r0, =strPrompt	@ Load into r0 address of strPrompt
	bl	putstring	@ Print Prompt 

	ldr	r0, =strA	@ Load into r0 address of strA
	mov	r1, #512	@ The largest number that can be read 12
	
	bl	getstring	@ Read stdin (up to r1 bytes) and store in R0
	
	ldr	r5, [r0]
	cmp	r5, #0x00	@ Compare string to 0
	beq	endloop		@ If Null jump to end
	
	bl	ascint32	@ Convert the string into a int
	bcs	check_input	@ If input invalid Jump
	b	storeA		@ if not jump to storeA
	
check_input:
	ldr	r0, =strInvalid	@ Load into r0 address of strInvalid
	bl	putstring	@ Print Prompt	
	b	inputLoop	@ Run loop again
	
check_overflow:
	ldr	r0, =strOverflow	@ Load into r0 address of strOverflow
	bl	putstring	@ Print Prompt
	b	inputLoop	@ Run loop again

storeA:
	ldr	r1, =iA		@ r1 points to address iY
	bvs	check_overflow	@ Check if input overflow
	
	str	r0, [r1]	@ [r1] iA = r0
	b	getB
	
	/****************************  GET B INFO ****************************/
	
inputLoop2:
	ldr	r0, =chLF	@ End Line
	bl	putch
	
getB:
	ldr	r0, =strPrompt2	@ Load into r0 address of strPrompt2
	bl	putstring	@ Print Prompt

	ldr	r0, =strB	@ Load into r0 address of strB
	mov	r1, #512	@ The largest number that can be read 12

	bl	getstring	@ Read stdin (up to r1 bytes) and store in R0
	
	ldr	r5, [r0]
	cmp	r5, #0x00	@ Compare string to 0
	beq	endloop		@ If Null jump to end
	
	bl	ascint32	@ Convert the string into a int
	bcs	check_input2	@ If input invalid Jump
	b	storeB		@ if not jump to storeA
	
check_input2:
	ldr	r0, =strInvalid	@ Load into r0 address of strInvalid
	bl	putstring	@ Print Prompt	
	b	inputLoop2	@ Run loop again
	
check_overflow2:
	ldr	r0, =strOverflow	@ Load into r0 address of strOverflow
	bl	putstring	@ Print Prompt
	b	inputLoop2	@ Run loop again

storeB:
	ldr	r1, =iB		@ r1 points to address iY
	bvs	check_overflow2	@ Check if input overflow

	str	r0, [r1]	@ [r1] iB = r0
	b	getValues
	
	/****************************  LOAD VALUE INFO ************************/

getValues:
	ldr	r0, =chLF	@ End Line
	bl	putch
	
	ldr	r3, =iA		@ Load into r3 address of iA
	ldr	r3, [r3]	@ r3 = *r3
	ldr	r4, =iB		@ Load into r4 address of iB
	ldr	r4, [r4]	@ r4 = *r4
	
	/****************************  GET SUM INFO ***************************/
	
	adds	r0, r3, r4	@  iX + iY (without carry)
	bvs	overflowSum	@ Check if value overflows
	
	ldr	r0, =strSum	@ Load into r0 address of strSum
	bl	putstring	@ Print Prompt
	
	add	r0, r3, r4	@  iX + iY
	
	ldr	r1, =strA	@ Load into r1 address of strA
	bl	intasc32	@ Convert iResult into a string
	ldr	r0, =strA	@ Load into r0 address of strA
	bl	putstring	@ Print result
	
	b	sumEnd
	
overflowSum:
	ldr	r0, =strSumOvFl	@ Load into r0 address of strSumOvFl
	bl	putstring	@ Print Prompt
	b	sumEnd
	
sumEnd:
	ldr	r0, = chLF	@ End Line
	bl	putch
	
	/****************************  GET SUB INFO ***************************/
	
	sbcs	r0, r3, r4	@ iX - iY (without carry)
	bvs	overflowSub	@ Check if value overflows
	
	ldr	r0, =strSub	@ Load into r0 address of strSub
	bl	putstring	@ Print Prompt
	
	sub	r0, r3, r4	@ iX - iY
	
	ldr	r1, =strA	@ Load into r1 address of strA
	bl	intasc32	@ Convert iResult into a string
	ldr	r0, =strA	@ Load into r0 address of strA
	bl	putstring	@ Print result
	
	b	subEnd
	
overflowSub:
	ldr	r0, =strSubOvFl	@ Load into r0 address of strSubOvFl
	bl	putstring	@ Print Prompt
	b	subEnd
	
subEnd:	
	ldr	r0, = chLF	@ End Line
	bl	putch
	
	/****************************  GET MULT INFO **************************/
	
	muls	r0, r3, r4	@ iX * iY (Without carry)
	cmp	r3, #0
	bgt	positive
	blt	negative
	
	/********************  Overflow Check *******************/
	
positive:
	cmp	r4, #0
	bgt	mulPos		@ If r3 & r4 are positive Mult must be positive
	blt	mulNeg		@ If r3(+) & r4(-) Mult must be negative

negative:
	cmp	r4, #0
	blt	mulPos		@ If r3 & r4 are negative Mult must be positive
	bgt	mulNeg		@ If r3(-) & r4(+) Mult must be negative
	
mulPos:
	cmp	r0, #0
	blt	overflowMul	@ If Mult is Negative, Overflow
	b	multPrint	@ If Mult is Negative, Jump to print

mulNeg:
	cmp	r0, #0
	bgt	overflowMul	@ If Mult is Positive, Overflow
	b	multPrint	@ If Mult is Negative, Jump to print
	
overflowMul:
	ldr	r0, =strMultOvFl	@ Load into r0 address of strMultOvFl
	bl	putstring	@ Print Prompt
	b	mulEnd
	
	/**********************  Print Mult *********************/
	
multPrint:
	ldr	r0, =strMult	@ Load into r0 address of strMult
	bl	putstring	@ Print Prompt
	
	mul	r0, r3, r4	@ iX * iY
	
	ldr	r1, =strA	@ Load into r1 address of strA
	bl	intasc32	@ Convert iResult into a string
	ldr	r0, =strA	@ Load into r0 address of strA
	bl	putstring	@ Print result
	
mulEnd:	
	ldr	r0, = chLF	@ End Line
	bl	putch
	
	/****************************  GET DIV INFO ***************************/
	
	/********************  Div Calculation *******************/
	
	cmp	r4, #0		@ Check if Divisor = 0
	beq	zeroDivision	@ If so Jump to zeroDivision
	b	div
	
zeroDivision:
	ldr	r0, =strNotDiv	@ Load into r0 address of strNotDiv
	bl	putstring	@ Print Prompt
	b	restartloop
	
div:
	sdiv	r6, r3, r4	@ Quotient(r6) = Divindend(r3) / Divisor (r4)
	mul	r5, r4, r6	@ r5 = Divisor (r4) * Quotient(r6)
	sub	r7, r3, r5	@ Remainder(r7) = Divindend(r3) - r5
	
	ldr	r0, =iQuatient	@ Load into r0 address of iQuatient
	str	r6, [r0]	@ [r0] iQuatient = r6
	
	ldr	r0, =iRemainder	@ Load into r0 address of iRemainder
	str	r7, [r0]	@ [r0] iRemainder = r7
	
	/********************  Print Quotient *******************/
	
	ldr	r0, =strQuot	@ Load into r0 address of strQuot
	bl	putstring	@ Print Prompt
	
	ldr	r0, =iQuatient
	ldr	r0, [r0]
	
	ldr	r1, =strA	@ Load into r1 address of strA
	bl	intasc32	@ Convert iResult into a string
	ldr	r0, =strA	@ Load into r0 address of strA
	bl	putstring	@ Print result
	
	ldr	r0, = chLF	@ End Line
	bl	putch
	
	/*******************  Print Remainder *******************/
	
	ldr	r0, =strRem	@ Load into r0 address of strRem
	bl	putstring	@ Print Prompt
	
	ldr	r0, =iRemainder
	ldr	r0, [r0]
	
	ldr	r1, =strA	@ Load into r1 address of strA
	bl	intasc32	@ Convert iResult into a string
	ldr	r0, =strA	@ Load into r0 address of strA
	bl	putstring	@ Print result
	
	ldr	r0, = chLF	@ End Line
	bl	putch
	
	/****************************  RESTART LOOP ***************************/

restartloop:
	ldr	r0, =chLF	@ End Line
	bl	putch
	b  	inputLoop	@ Return to startLoop
	
	/*******************************   END  *******************************/
	
endloop:
	ldr	r0, = chLF	@ End Line
	bl	putch
	
	ldr	r0, =strEnd	@ Load into r0 address of strEnd
	bl	putstring	@ Print Prompt
	
	ldr	r0, = chLF	@ End Line
	bl	putch
	ldr	r0, = chLF	@ End Line
	bl	putch
	
	mov	r0, #0		@ Set program Exit status to 0
	mov 	r7, #1		@ Serivce command of 1 ro terminate
	svc	0		@ Perform Service Call to Linux
	.end
