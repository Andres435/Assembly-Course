/******************************************
 * lab2.s
 * 
 * My name is ARM Assembly
 * Andres Quintana
 * 01/26/2012
 * 
 * This is a simple program that prints my
 * name in ARM Assembly using linux system
 * call.
 * 
 * It should be assembled and linked in the
 * cmd as follows:
 * 
 * as -o -g lab2.o lab2.s
 * ld -o lab2 lab2.o
 *******************************************/

	.data
msg:	.ascii "Andres Quintana\n"
len:	.word  16

	.text
	.globl _start
_start:
	@write( int fd, const void *buf, size_t count )
	mov	R0, #1		@fd -> stdout
	ldr	R1, =msg	@buf -> msg
	ldr	R2, =len	@R2 -> len
	ldr	R2, [R2]	@Dereference R2 
	mov	R7, #4		@4 is the open syscall for ARM linux  

	svc	0		@ Perform Service Call to Linux

	mov	R0, #0		@ Standard Exit Sequence
	mov	R7, #1		@ Exit
	svc	0
	.end

