@*****************************************************************************
@Name:      Andres Quintana
@Program:   lab19.s
@Class:     CS 3B
@Purpose:
@     Demonstrate the ability to modify immutable strings.
@*****************************************************************************
	
	.data
	strX:	.asciz	"Cat "
	strY:	.asciz	"in the hat"
	ptrStr:	.word	0

	chLF:		.byte	0x0a
	
	.text
	.global _start		@Starting address to linker

_start:
	mov	r0, #32		@ memory allocation size
	bl	malloc
	
	ldr	r2, =ptrStr	@ Pointer to the new String
	str	r0, [r2]	@ *r0 = r2
	
	ldr	r2, [r2]	@ r2 = *r2
	mov	r3, #0		@ r3 = null character
	ldr	r1, =strX	@ load into r1 first string
	
top:
	ldrb	r4, [r1]	@ load into r4 character of the string
	add	r1, #1		@ Go to next char

	strb	r4, [r2]	@ store char into new string
	add	r2, #1		@ move to next space
	
	cmp	r3, r4		@ If char = null, Jump to bottom
	beq	bottom
	b	top
	
bottom:
	ldr	r0, =ptrStr	@ Load ptrStr first string into r0
	ldr	r0, [r0]	@ r0 = *r0
	bl	putstring	@ Print first string

	ldr	r0, =chLF	@ End Line
	bl	putch

	sub	r2, #1		@ take out the null of the first string
	ldr	r1, =strY	@ load into r1 second string

secondLoop:
	ldrb	r4, [r1]	@ load into r4 character of the string
	add	r1, #1		@ Go to next char

	strb	r4, [r2]	@ store char into new string
	add	r2, #1		@ move to next space

	cmp	r3, r4		@ If char = null, Jump to end
	beq	end	
	b	secondLoop	@ Else, loop back

end:
	ldr	r2, =ptrStr	@ Load new string into r2
	ldr	r0, [r2]	@ r0 = *r2
	bl	putstring	@ Print new string
	
	ldr	r0, =chLF	@ End Line
	bl	putch
	
	ldr	r0, =ptrStr	@ Free memory
	ldr	r0, [r0]
	bl	free
	
	mov r0, #0
	mov r7, #1
	svc 0
	.end
