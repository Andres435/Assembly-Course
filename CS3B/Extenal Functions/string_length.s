@*****************************************************************************
@Name:      Andres Quintana
@Program:   fact(n).s
@Class:     CS 3B
@Purpose:
@ Subroutine String_Length accepts the address of a string and counts 
@	 the characters in the string, excluding the NULL character and 
@	 returns that value as an int (word) in the R0 register. will read 
@	 a string of characters terminated by a null
@
@    R0: Points to first byte of string to count
@    LR: Contains the return address

@ Returned register contents:
@    R0: Number of characters in the string (does not include null).
@ All registers are preserved as per AAPCS
@*****************************************************************************	

	.text
	.align	2
	.global _length		@Starting address to linker

_length:                            
	stmfd   sp!, {lr}       @ Push lr
	mov     r1, #0		@ counter = 0
	bl      count
	ldmfd   sp!, {lr}	@ Pop lr
	bx      lr		@ Return

count:
	stmfd   sp!, {lr}	@ Push lr
	ldrb    r2, [r0]
	cmp     r2, #0		@ If r2 = 0, Return Length
	moveq	r0, r1		@ r0 = r1 (Length)
	bxeq	lr		@ return

	add     r1, r1, #1	@ counter++
	add     r0, r0, #1	@ go to next char
	bl      count		@ go back to count

	ldmfd   sp!, {lr}	@ Pop lr
	bx      lr		@ return
