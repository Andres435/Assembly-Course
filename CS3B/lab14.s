@*****************************************************************************
@Name:      Andres Quintana
@Program:   Lab14.s
@Class:     CS 3B
@Date:      March 18, 2021 at 3:30 PM
@Purpose:
@     Pogram that uses Collatz Conjecture and Print the steps taken 
@*****************************************************************************

	.data

strPrompt:	.asciz	"Enter a whole number: "
strPrompt2:	.asciz	"The number of steps taken: "
strA:		.skip	4

iA:			.word	0	@ Int A

chLF:		.byte	0x0a

	.text
	.global _start

_start: 
	/****************************  GET A INFO ****************************/
	
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
	
	/*************************  COLLATZ CONJUCTURE ***********************/
	
	ldr	r4, =iA		@ Load into r4 address of iA
	ldr	r4, [r4]	@ r4 = *r4

	mov	r1, r4		@ Trial Number (iA)
	mov	r2, #0		@ Counter
	
loop:
	cmp	r1, #1		@ compare r1 and 1
	beq	end		@ If so Jump to End
	
	and	r3, r1, #1	@ r3 <- r1 & 1 [mask]
	cmp r3, #0		@ compare r3 and 0
	bne	odd			@ If odd Jump to Odd

even:
	mov	r1, r1, asr #1	@ r1 <- (r1 >> 1)
	b	endloop

odd:
	add	r1, r1, r1, lsl #1	@ 3n
	add	r1, r1, #1			@ 3n + 1

endloop:
	add	r2, r2, #1	@ r2 <- r2 + 1
	b	loop		@ restart loop
	
end:
	/****************************  PRINT STEPS **************************/
	ldr	r0, =chLF	@ End Line
	bl	putch
	
	ldr	r0, =strPrompt2	@ Load into r0 address of szPrompt
	bl	putstring	@ Print Prompt 

	mov	r0, r2
	
	ldr	r1, =strA	@ Load into r1 address of szA
	bl	intasc32	@ Convert iResult into a string
	ldr	r0, =strA	@ Load into r0 address of szA
	bl	putstring	@ Print result
	
	ldr	r0, =chLF	@ End Line
	bl	putch
	ldr	r0, =chLF	@ End Line
	bl	putch

	mov r0, #0
	mov r7, #1
	svc 0
	.end
