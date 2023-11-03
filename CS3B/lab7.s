/* -- Lab7.s -- */
@ Purpose: Enter two integers and add them together to get final result
@	   Print result and their respective address

		.data

szA:		.skip	12
szPrompt:	.asciz	"Enter x: "

szB:		.skip	12
szPrompt2:	.asciz	"Enter y: "

iA:		.word	0
iB:		.word	0
iSum:		.word	0
szAdrA:		.asciz	"        "		
szAdrB:		.asciz	"        "		

szAdd:		.asciz	" + "
szEq:		.asciz	" = "
szAdrX:		.asciz	"&x = 0x"
szAdrY:		.asciz	"&y = 0x"

chLF:		.byte	0x0a

		.text
		.global _start		@Starting address to linker

_start:
	ldr	r0, =szPrompt	@ Load into r0 address of szPrompt
	bl	putstring	@ Print Prompt 

	/****************************  GET X INFO ****************************/

	ldr	r0, =szA	@ Load into r0 address of szA
	mov	r1, #13		@ The largest number that can be read 12(+1)

	bl	getstring	@ Read stdin (up to r1 bytes) and store in R0
	bl	ascint32	@ Convert the string into a int

	ldr	r1, =iA		@ r1 points to address iX
	str	r0, [r1]	@ [r1] iA = r0
	
	ldr	r0, = iA	@ r0 = address of iA
	ldr	r1, =szAdrA	@ Load into r1 address of szAdrX
	mov	r2, #8		@ Number of nimble to display
	bl	hexToChar	@ Convert the hex to string

	/****************************  GET Y INFO ****************************/

	ldr	r0, =szPrompt2	@ Load into r0 address of szPrompt2
	bl	putstring	@ Print Prompt

	ldr	r0, =szB	@ Load into r0 address of szB
	mov	r1, #13	

	bl	getstring
	bl	ascint32

	ldr	r1, =iB		@ r1 points to address iY
	str	r0, [r1]	@ [r1] iB = r0	

	ldr	r0, =iB
	ldr	r1, =szAdrB
	bl	hexToChar

	/**************************** PRINT RESULT ***************************/

	ldr	r0, =szA	@ Print math equation
	bl	putstring
	ldr	r0, =szAdd
	bl	putstring
	ldr	r0, =szB
	bl	putstring
	ldr	r0, =szEq
	bl	putstring

	ldr	r3, =iA		@iSum = iX + iY
	ldr	r3, [r3]	
	ldr	r4, =iB
	ldr	r4, [r4]
	ldr	r0, =iSum
	add	r0, r3, r4

	ldr	r1, =szA
	bl	intasc32
	ldr	r0, =szA	
	bl	putstring	@ Print result	

	ldr	r0, =chLF
	bl	putch

	/**************************** PRINT ADDRESS **************************/

	ldr	r0, =szAdrX
	bl	putstring	@ Print X Address
	ldr	r0, =szAdrA	
	bl	putstring

	ldr	r0, =chLF
	bl	putch

	ldr	r0, = szAdrY
	bl	putstring	
	ldr	r0, =szAdrB	@ Print Y Address
	bl	putstring

	ldr	r0, = chLF
	bl	putch

	mov r0, #0		@ Set program Exit status to 0
	mov r7, #1		@ Serivce command of 1 ro terminate
	svc 0			@ Perform Service Call to Linux
	.end
