@*****************************************************************************
@Name:      Andres Quintana
@Program:   fact(n).s
@Class:     CS 3B
@Purpose:
@     external function called fact(n) Used to solve factorials
@	  Using recursion
@*****************************************************************************	

	.text
	.global _fact		@Starting address to linker

_fact:
	stmfd	sp!, {r7,lr}	@ Push lr

    	cmp	r0, #1
    	bge	math		@ If r0 > 1, Jump to Recursion Statement	

	mov	r0, #1
	ldmfd	sp!, {r7, pc}	@ Pop lr
	
math:
	mov	r7, r0		@ r7 = r0
	sub	r0, r0, #1	@ r0--
	bl	_fact		@ Call Recursion

	mul	r0, r7

	ldmfd	sp!, {r7, pc}	@ Pop lr
	bx	lr		@ Return
