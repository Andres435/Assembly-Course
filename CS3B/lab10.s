/* -- Lab10.s -- */
@ Purpose:  Intended to familiarize with instructions that affect
@			on the CPSR register

		.data

iX:		.word	0xDEADBEEF
iY:		.word	0xCAFEBABE

		.text
		.global _start		@Starting address to linker

_start:

	ldr	r6, =iX		@ Load into r6 address of iX
	ldr	r6, [r6]	@ r6 = *r6
	ldr	r7, =iY		@ Load into r7 address of iY
	ldr	r7, [r7]	@ r7 = *r7

	add	r0, r6, r7	@ Add
	adc	r1, r6, r7	@ Add with carry
	sub	r2, r6, r7	@ Sub
	sbc	r3, r6, r7	@ Sub with carry
	rsb	r4, r6, r7	@ Reverse Sub
	rsc	r5, r6, r7	@ Reverse Sub with carry

	mov r0, #0		@ Set program Exit status to 0
	mov r7, #1		@ Serivce command of 1 ro terminate
	svc 0			@ Perform Service Call to Linux
	.end
