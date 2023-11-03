/* -- lab8.s -- */
@ Purpose: Pogram that will copy an array to another array. 

	.data

iSrcArray:	.word 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15
iDestArray:	.skip 64

		.text
		.global _start

_start: 
	mov r0, #0
	ldr r1, =iSrcArray
	ldr r3, =iDestArray
	startloop:

	cmp r0, #16
	bgt endloop

	ldr r2, [r1]

	str r2, [r3]
	add r0, #1

	add r1, #4
	add r3, #4 
	b   startloop

	endloop:
	mov r0, #0
	mov r7, #7
	svc 0
	.end
