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
	.equ	_W_,	0600
	
	.data
	strMsg:		.skip	512
	strInput:	.asciz	"input.txt"
	cCR:		.byte	10
	
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
	ldr	r1, =strMsg		@ Address of the string (char*)
	mov	r2, #1			@ Number of bytes to attempt to read
	
	
top:
	mov	r0, r3			@ Move the file handle back into r0
	svc	0			@ Do the deed 1 byte at a time
	cmp	r0, #0			@ If Empty, Jump
	beq	bot
	add	r1, #1			@ Go to next Char
	b	top
	
bot:
	ldr	r0, =strMsg		@ Print String
	bl	putstring
	ldr	r0, =cCR		@ Print End Line
	bl	putch
		
	mov	r7, #6			@ SVC Code of closing the file
	svc	0			@ Create the file
	
	mov	r0, #0			@ Set program Exit Status Code to 0
	mov	r7, #1			@ Service command code of 1 to terminate pgm.
	svc	0
	.end
