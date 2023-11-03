@*****************************************************************************
@Name:      Andres Quintana
@Program:   IDIV.s
@Class:     CS 3B
@Purpose:
@     external function called IDIV that is x and y such that f(x,y) = x/y. 
@	  Pass x in R0, y in R1. return the result in R0.
@*****************************************************************************
	.data
	iCount:	.word	0	

	.text
	.global _main		@Starting address to linker

_main:
	ldr	r2, =iCount	@ r2 points to iCount
	ldr	r2, [r2]

	mov	r5, #1		@ Default X Sign
	mov	r6, #1		@ Default Y Sign

checkSign:
	cmp	r0, #0		@ Check if Dividend is Negative
	blt	signX		@ If so Jump to sign
	cmp	r1, #0		@ Check if Divisor is Negative
	blt	signY		@ If so Jump to sign
	b	defaultDiv	@ Else, Jump to Division

signX:
	mov	r5, #-1		@ Dividend Sign is negative
	muls	r0, r5		@ Make negative a positive sign
	b	checkSign	@ Go to check Divisor

signY:
	mov	r6, #-1		@ Divisor Sign is negative
	muls	r1, r6		@ Make negative a positive sign
	b	defaultDiv
	
defaultDiv:
	cmp	r0, r1		@ If Dividend < Divisor, Jump to End
	blt	resultSign			
	
	sub	r0, r0, r1	@ Dividend - Divisor
	add	r2, r2, #1	@ Counter++
	b	defaultDiv

resultSign:
	muls	r7, r5, r6	@ Get Sign
	muls	r0, r2, r7	@ Put sign into Result
	bx	lr
