@*****************************************************************************
@Name:      Andres Quintana
@Program:   lab21.s
@Class:     CS 3B
@Purpose:
@     Read the string within the text file "input.txt"
@	
@rwx rwx rwx
@--- 010 000
@*****************************************************************************
	.equ	W,	0101
	.equ	R,	00
	.equ	_W_, 0600
	
	.data
	strBuffer:	.skip	512
	strInput:	.asciz	"input.txt"
	cCR:		.byte	10
	iArray:		.word	0, 0, 0, 0, 0
	
	.text
	.global _start		@Starting address to linker
	
_start:
	mov	r7, #5			@ SVC Code of opemimg the file
	ldr	r0, =strInput		@ Name of the file to open
	mov	r1, #R			@ Open for reading
	mov	r2, #_W_		@ Set permission to W for user only
	svc	0			@ Create the file
	mov	r3, r0			@ Save File Handler to r3
	
	mov	r7, #3			@ SVC Code for reading to the file
	ldr	r1, =strBuffer		@ Address of the string (char*)
	mov	r2, #1			@ Number of bytes to attempt to read
	
	mov	r4, #0			@ Null char
	mov	r6, #0			@ Counter to reset Buffer
	ldr	r8, =iArray
	
top:
	mov	r0, r3			@ Move the file handle back into r0
	svc	0			@ Do the deed 1 byte at a time
	cmp	r0, #0			@ If empty, Jump
	beq	bot
	
	add	r6, #1			@ Counter++
	ldrb	r5, [r1]		@ Load Input Char
	cmp	r5, #10			@ Compare to "\n"
	bne	skip

	strb	r4, [r1]		@ strBuffer last char == null

	ldr	r0, =strBuffer	
	bl	ascint32		@ Convert to integer
	str	r0, [r8]		@ Save into Array
	
	add	r8, #4			@ Go to next spot on the Array
	sub	r1, r6			@ Reset Buffer
	mov	r6, #0			@ Reset Counter
	
skip:
	add	r1, #1			@ Go to next space
	b	top
	
bot:
	mov	r7, #6			@ SVC Code of closing the file
	svc	0			@ Create the file
	
	mov	r0, #0			@ Set program Exit Status Code to 0
	mov	r7, #1			@ Service command code of 1 to terminate pgm.
	svc	0
	.end
