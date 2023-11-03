@*****************************************************************************
@Name:      Andres Quintana
@Program:   Lab12.s
@Class:     CS 3B
@Date:      March 15, 2021 at 3:30 PM
@Purpose:
@     User input their grade an programm display the corresponding letter grade
@*****************************************************************************
		
		.data

strGrade:	.skip	12				@ String Score
strPrompt:	.asciz	"Enter your score:	"

iGrade:		.word	0	@ Int Grade

strA:	.asciz	" Your latter grade is A "
strB:	.asciz	" Your latter grade is B "
strC:	.asciz	" Your latter grade is C "
strD:	.asciz	" Your latter grade is D "
strF:	.asciz	" Your latter grade is F "


strHigh:	.asciz	"Too High "
strLow:		.asciz	"Too Low "

chLF:		.byte	0x0a

		.text
		.global _start		@Starting address to linker
		
_start:
	/****************************  GET GRADE INFO ****************************/

	ldr	r0, =strPrompt	@ Load into r0 address of strPrompt
	bl	putstring	@ Print Prompt 

	ldr	r0, =strGrade	@ Load into r0 address of strGrade
	mov	r1, #12		@ The largest number that can be read 12
	
	bl	getstring	@ Read stdin (up to r1 bytes) and store in R0
	bl	ascint32	@ Convert the string into a int
	
	ldr	r1, =iGrade		@ r1 points to address iGrade
	str	r0, [r1]	@ [r1] iGrade = r0
	
	/*****************************  PRINT GRADE *****************************/
	
	/******************** LOAD SCORE *********************/
	
	ldr	r0, = chLF	@ End Line
	bl	putch
	
	ldr	r1, =iGrade		@ Load into r1 address of iGrade
	ldr	r1, [r1]	@ r1 = *r1
	
	/***************** Match Letter grade ****************/
	
	cmp	r1, #0		@ Compare Grade < 0
	blt	low
	
	cmp	r1, #60		@ Compare Grade < 60
	blt	F
	
	cmp	r1, #70		@ Compare Grade < 70
	blt	D
	
	cmp	r1, #80		@ Compare Grade < 80
	blt	C
	
	cmp	r1, #90		@ Compare Grade < 90
	blt	B
	
	cmp	r1, #100	@ Compare Grade < 100
	blt	A
	
	cmp	r1, #100	@ Compare Grade = 100
	beq	A
	
	cmp	r1, #100	@ Compare Grade < 100
	bgt	high
	
	/***************** Print letter grade ****************/
	
low:
	ldr	r0, =strLow	@ Load into r0 address of strLow
	bl	putstring	@ Print
	b	end

A:
	ldr	r0, =strA	@ Load into r0 address of strA
	bl	putstring	@ Print
	b	end

B:
	ldr	r0, =strB	@ Load into r0 address of strB
	bl	putstring	@ Print
	b	end

C:
	ldr	r0, =strC	@ Load into r0 address of strC
	bl	putstring	@ Print
	b	end

D:
	ldr	r0, =strD	@ Load into r0 address of strD
	bl	putstring	@ Print
	b	end

F:
	ldr	r0, =strF	@ Load into r0 address of strF
	bl	putstring	@ Print
	b	end
	
high:
	ldr	r0, =strHigh	@ Load into r0 address of strHigh
	bl	putstring	@ Print
	b	end
	
	
	/*********************************  END *********************************/
end:
	
	ldr	r0, = chLF	@ End Line
	bl	putch
	ldr	r0, = chLF	@ End Line
	bl	putch
	
	mov	r0, #0		@ Set program Exit status to 0
	mov 	r7, #1		@ Serivce command of 1 ro terminate
	svc	0		@ Perform Service Call to Linux
	.end
