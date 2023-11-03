/* -- Lab7.s -- */
@ Purpose: Setting up the stages for RAM-1

	.data

szX:	.asciz "10"
iX:	.word 0

szY:	.asciz "15"
iY:	.word 0

iSum:	.word 0

	.text

	.global _start		@ Provide starting address to linker

_start:

	ldr	r0, =szX 	@ load into R0 address szX
	bl	ascint32	@ cal ascin32 to convert szX to an 32 bit integer
	ldr	r1, =iX		@ r1 points to iX
	str	r0, [r1]	@ *r1 = r0
	ldr	r1, [r1]

	ldr	r0, =szY	@ load into R0 address szY
	bl	ascint32	@ call ascint32 to convert szY to an 32 bit integer
	ldr	r2, =iY		@ r2 points to iY
	str	r0, [r2]	@ *r2 = r0 
	ldr	r2, [r2]

	ldr	r3, =iSum	@ load into r4 address iSum
	add	r3, r1, r2	@ add iX and iY to iSum

	mov	r0, #0		@ Set program Exit status to 0
	mov	r7, #1		@Service comand code of 1 to terminate

	svc	0		@Perform Service Call to Linux
	.end 	
