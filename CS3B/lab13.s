@*****************************************************************************
@Name:      Andres Quintana
@Program:   Lab13.s
@Class:     CS 3B
@Date:      March 15, 2021 at 3:30 PM
@Purpose:
@     Pogram that take input into an array of 10 then sum the the array. 
@*****************************************************************************

	.data

strPrompt:	.asciz	"Enter a whole number: "
strPrompt2:	.asciz	"The Sum of the Array is "
strA:		.skip	2

iA:			.word	0	@ Int A
iSum:		.word	0	@ Sum of the Array

iSrcArray:	.word	0, 0, 0, 0, 0, 0, 0, 0, 0, 0 @ Array[10]

chLF:		.byte	0x0a

	.text
	.global _start

_start: 
	mov r8, #0
	ldr r3, =iSrcArray
	
startloop:	
	/****************************  GET INPUT ****************************/
	
	ldr	r0, =strPrompt	@ Load into r0 address of szPrompt
	bl	putstring	@ Print Prompt 

	ldr	r0, =strA	@ Load into r0 address of szA
	mov	r1, #13		@ The largest number that can be read 12(+1)

	bl	getstring	@ Read stdin (up to r1 bytes) and store in R0
	bl	ascint32	@ Convert the string into a int

	ldr	r1, =iA		@ r1 points to address iA
	str	r0, [r1]	@ [r1] iA = r0
	
	/***************************  STORE ARRAY ***************************/
	
	/****************** LOAD INTO ARRAY ******************/

	ldr r2, [r1]
	str r2, [r3]
	
	add r8, #1		@ counter++
	add r3, #4 
	
	cmp r8, #9		@ If counter > 10, Jump
	bgt sumArray
	b   startloop
	
	/********************* SUM ARRAY *********************/
sumArray:
	ldr	r0, =chLF	@ End Line
	bl	putch
	
	mov r8, #0
	ldr	r3, =iSrcArray
	
	ldr	r4, =iSum
	ldr	r4, [r4]
	
startloop2:
	cmp r8, #9		@ r8 is the counter (r8 = 0)
	bgt print
	
	ldr	r2, [r3]
	add	r4, r2
	
	add r8, #1		@ counter++
	add r3, #4 
	b   startloop2
	
	/********************* PRINT SUM *********************/
print:
	ldr	r0, =chLF	@ End Line
	bl	putch
	
	ldr	r0, =strPrompt2	@ Load into r0 address of szPrompt2
	bl	putstring	@ Print Prompt
	
	mov	r0, r4
	
	ldr	r1, =strA	@ Load into r1 address of strA
	bl	intasc32	@ Convert iResult into a string
	ldr	r0, =strA	@ Load into r0 address of strA
	bl	putstring	@ Print result
	
	ldr	r0, =chLF	@ End Line
	bl	putch
	
	/******************** PRINT ARRAY ********************/
	
	mov r8, #0
	ldr	r3, =iSrcArray

startloop3:
	ldr	r0, =chLF	@ End Line
	bl	putch

	cmp r8, #9		@ r8 is the counter (r8 = 0)
	bgt endloop
	
	ldr r0, [r3]
	
	ldr	r1, =strA	@ Load into r1 address of strA
	bl	intasc32	@ Convert iResult into a string
	ldr	r0, =strA	@ Load into r0 address of strA
	bl	putstring	@ Print result
	
	add r8, #1		@ counter++
	add r3, #4 
	b   startloop3

endloop:
	ldr	r0, =chLF	@ End Line
	bl	putch

	mov r0, #0
	mov r7, #1
	svc 0
	.end
