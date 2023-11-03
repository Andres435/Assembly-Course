@*****************************************************************************
@Name:      Andres Quintana
@Program:   EXAM2.s
@Class:     CS 3B
@Lab:       RASM2
@Date:      April 21, 2021 at 3:30 PM
@Purpose:
@     
@*****************************************************************************
		.equ	W,	0101
		.equ	R,	00
		.equ	_W_,	0600	

		.data
		strBuffer:	.skip	20
		strInput:	.asciz	"input.txt"
		strOutput:	.asciz	"output.txt"

		ptr1Str:	.word	0
		ptr2Str:	.word	0

		chLF:		.byte	0x0a

		.text
		.global _start		@Starting address to linker

_start:
	mov	r9, #0
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

	cmp	r9, #0
	bne	secondString

	mov	r9, #1

	ldr	r8, =ptr1Str
	ldr	r0, =strBuffer
	bl	_copy
	str	r0, [r8]
	
	ldr	r1, =strBuffer		@ Address of the string (char*)
	mov	r6, #0			@ Reset Counter
	b	skip
	
secondString:
	ldr	r9, =ptr2Str
	ldr	r0, =strBuffer
	bl	_copy
	str	r0, [r9]
	
	ldr	r1, =strBuffer		@ Address of the string (char*)
	mov	r6, #0			@ Reset Counter
	b bot
	
skip:
	add	r1, #1			@ Go to next space
	b	top
	
bot:
	ldr	r0, =ptr1Str	@ Load new string into r6
	ldr	r0, [r0]	@ r0 = *r6
	bl	putstring
	ldr	r0, =ptr2Str		@ Print String
	ldr	r0, [r0]	@ r0 = *r6
	bl	putstring

	ldr	r0, =ptr1Str	@ Load new string into r6
	bl	toUpperCase
	bl	putstring

	ldr	r0, =ptr2Str	@ Load new string into r6
	bl	toUpperCase
	bl	putstring

	mov	r7, #6			@ SVC Code of closing the file
	svc	0			@ Create the file
	
	mov	r7, #5			@ SVC Code of opemimg the file
	ldr	r0, =strOutput		@ Name of the file to open
	mov	r1, #W			@ Open for writing
	mov	r2, #_W_		@ Set permission to W for user only
	svc	0			@ Create the file
	push	{r0}			@ Save File Handler
	
	mov	r7, #4			@ SVC Code for writing to the file
	ldr	r1, =ptr1Str		@ Address of the string (char*)
	mov	r0, r1
	mov	r6, r1
	bl	_length			@ Get string length
	mov	r1, r6
	mov	r2, r0

	pop	{r0}			@ Realease File Handler
	svc	0
	
	mov	r7, #6			@ SVC Code of closing the file
	svc	0			@ Create the file

end:
	mov r0, #0		@ Set program Exit status to 0
	mov r7, #1		@ Serivce command of 1 ro terminate
	svc 0			@ Perform Service Call to Linux
	.end
