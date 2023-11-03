/* -- Lab5.s -- */
@Purpose: Using macros, write an assembly program that prints
@	  two strings with a carrige return.

	.data

szMsg1:	.asciz	"The sun did not shine"
szMsg2:	.asciz	"It was too wet to play"
chCr:	.byte	10

	.text

	.global _start		@Provide program starting address to linker

_start:

	ldr r0, =szMsg1		@load into r0 address of szMsg
	bl putstring		@display string to terminal

	ldr r0, =szMsg2		@load into r0 address of szMsg2
	bl putstring		@display string to terminal

	ldr r0, =chCr		@load into r0 address of chCr
	bl putch		@display char to terminal

	mov r0, #0		@Set program exit status code to 0
	mov r7, #1		@Service command code of 1 to terminate

	svc	0		@Perform service call to Linux
	.end
