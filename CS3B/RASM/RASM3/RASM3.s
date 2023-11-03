@*****************************************************************************
@Name:      Andres Quintana
@Program:   RASM3.s
@Class:     CS 3B
@Lab:       RASM2
@Date:      April 1, 2021 at 3:30 PM
@Purpose:
@     Testing of the Assembly string classes
@*****************************************************************************
	
		.data

		strA:		.skip	512				@ String A
		strPrompt:	.asciz	"Enter a first string:	"
		strB:		.skip	512				@ String B
		strPrompt2:	.asciz	"Enter a second string:	"
		strC:		.skip	512				@ String C
		strPrompt3:	.asciz	"Enter a third string:	"
		strResult:	.skip	512

		ptrStr:		.word	0
		strTrue:	.asciz	"True"
		strFalse:	.asciz	"False"
		strPrefix:	.asciz	"hat."
		strPrefix2:	.asciz	"Cat"
		strPrefix3:	.asciz	"in the hat."

		strName:	.asciz	"	Name:	 Andres Quintana"
		strName2:	.asciz	"	Name:	 Cole Espinola"
		strClass:	.asciz	"	Class:	 CS 3B"
		strLab:		.asciz	"	Lab:	 RASM2"
		strDate:	.asciz	"	Date:	 04/1/2021"

		strEnd:		.asciz	" Thanks for using the program!! Good Day! "

		chLF:		.byte	0x0a

		.text
		.global _start		@Starting address to linker

_start:
	/*************************  Print Group Info **************************/
	
	ldr	r0, =chLF	@ End Line
	bl	putch
	
	ldr 	r0, =strName	@ Load szName
	bl 	putstring	@ Print name
	ldr	r0, =chLF	@ End Line
	bl	putch
	ldr 	r0, =strName2	@ Load szName2
	bl 	putstring	@ Print name
	ldr	r0, =chLF	@ End Line
	bl	putch
	ldr	r0, =strClass	@ Load szClass
	bl 	putstring	@ Print Class
	ldr	r0, =chLF	@ End Line
	bl	putch
	ldr	r0, =strLab	@ Load szLab
	bl 	putstring	@ Print Lab
	ldr	r0, =chLF	@ End Line
	bl	putch
	ldr	r0, =strDate	@ Load szDate
	bl 	putstring	@ Print Date

	ldr	r0, =chLF	@ End Line
	bl	putch
	ldr	r0, =chLF	@ End Line
	bl	putch
		
	/****************************  GET STRINGS ****************************/
	
	/*******************  STRING A  *********************/
	ldr	r0, =strPrompt	@ Load into r0 address of szPrompt
	bl	putstring	@ Print Prompt 

	ldr	r0, =strA	@ Load into r0 address of szA
	mov	r1, #512	@ The largest number that can be read 12(+1)

	bl	getstring	@ Read stdin (up to r1 bytes) and store in R0
	
	/*******************  STRING B  *********************/
	ldr	r0, =strPrompt2	@ Load into r0 address of szPrompt2
	bl	putstring	@ Print Prompt 

	ldr	r0, =strB	@ Load into r0 address of szB
	mov	r1, #512	@ The largest number that can be read 12(+1)

	bl	getstring	@ Read stdin (up to r1 bytes) and store in R0

	/*******************  STRING C  *********************/
	ldr	r0, =strPrompt3	@ Load into r0 address of szPrompt2
	bl	putstring	@ Print Prompt 

	ldr	r0, =strC	@ Load into r0 address of szB
	mov	r1, #512	@ The largest number that can be read 12(+1)

	bl	getstring	@ Read stdin (up to r1 bytes) and store in R0

	/**************************  STRING FUNCTIONS *************************/
	

	/****************  STRING LENGTH ****************/

	ldr	r0, = chLF	@ End Line
	bl	putch
	
	ldr	r0, =strA
	bl	_length		@ Get s1 length
	ldr	r1, =strResult	@ Load into r1 address of Result
	bl	intasc32	@ Convert iResult into a string
	ldr	r0, =strResult	@ Load into r0 address of Result
	bl	putstring	@ Print result

	ldr	r0, = chLF	@ End Line
	bl	putch

	ldr	r0, =strB
	bl	_length		@ Get s2 length
	ldr	r1, =strResult	@ Load into r1 address of Result
	bl	intasc32	@ Convert iResult into a string
	ldr	r0, =strResult	@ Load into r0 address of Result
	bl	putstring	@ Print result

	ldr	r0, = chLF	@ End Line
	bl	putch

	ldr	r0, =strC
	bl	_length		@ Get s3 length
	ldr	r1, =strResult	@ Load into r1 address of Result
	bl	intasc32	@ Convert iResult into a string
	ldr	r0, =strResult	@ Load into r0 address of Result
	bl	putstring	@ Print result

	/****************  STRING EQUALS ****************/
	
	ldr	r0, = chLF	@ End Line
	bl	putch

	ldr	r0, =strA	@ Load s1
	ldr	r1, =strC	@ Load s3
	bl	_equals		@ Check if Equals (s1, s3)
	cmp	r0, #0		@ Print Boolean Result
	ldreq	r0, =strFalse
	ldrne	r0, =strTrue
	bl	putstring

	ldr	r0, = chLF	@ End Line
	bl	putch

	ldr	r0, =strA	@ Load s1
	ldr	r1, =strA	@ Load s1
	bl	_equals		@ Check if Equals (s1, s1)
	cmp	r0, #0		@ Print Boolean Result
	ldreq	r0, =strFalse
	ldrne	r0, =strTrue
	bl	putstring

	/**************  EQUALS IGNORE CASE *************/

	ldr	r0, = chLF	@ End Line
	bl	putch

	ldr	r0, =strA	@ Load s1
	ldr	r1, =strC	@ Load s3
	bl	_equalsIgnoreCase	@ Compare Ignoring the case
	cmp	r0, #0		@ Print Boolean Result
	ldreq	r0, =strFalse
	ldrne	r0, =strTrue
	bl	putstring

	ldr	r0, = chLF	@ End Line
	bl	putch

	ldr	r0, =strA	@ Load s1
	ldr	r1, =strB	@ Load s2
	bl	_equalsIgnoreCase		@ Compare Ignoring the case
	cmp	r0, #0		@ Print Boolean Result
	ldreq	r0, =strFalse
	ldrne	r0, =strTrue
	bl	putstring

	/*****************  STRING COPY *****************/

	ldr	r0, = chLF	@ End Line
	bl	putch
	ldr	r0, =strA	@ Load s1
	bl	_copy		@ Copy s1 into s4
	bl	putstring	@ Print s4
	
	ldr	r0, = chLF	@ End Line
	bl	putch
	ldr	r0, =strA	@ Print s1
	bl	putstring

	/**************  SUBSTRING_1 *************/

	ldr	r0, = chLF	@ End Line
	bl	putch

	ldr	r0, =strC	@ Load s3
	mov	r1, #4		@ Get index
	mov	r2, #14		@ Get EndIndex
	bl	_substring_1	@ Get substring
	bl	putstring	@ Print substring

	/**************  SUBSTRING_2 *************/

	ldr	r0, = chLF	@ End Line
	bl	putch

	ldr	r0, =strC	@ load s3
	mov	r1, #7		@ Get Index
	bl	_substring_2	@ Get substring
	bl	putstring	@ Print substring

	/***************  STRING CHAR_AT ***************/

	ldr	r0, = chLF	@ End Line
	bl	putch

	ldr	r0, =strB	@ Load s2
	mov	r1, #4		@ Get Index
	bl	_charAt		@ Get char at Index

	@ CharAt does what it need to do, but I Can't make it 
	@ to print the char when the char return to RASM3

	bl	putch		@ Print char

	/**************  STARTS_WITH_1 *************/

	ldr	r0, = chLF	@ End Line
	bl	putch

	ldr	r0, =strA	@ Load s1
	ldr	r1, =strPrefix	@ Load Prefix
	mov	r2, #11		@ Load Index
	bl	_startsWith_1	@ Get Boolean Result
	
	cmp	r0, #0		@ Print Boolean Result
	ldreq	r0, =strFalse
	ldrne	r0, =strTrue
	bl	putstring

	/**************  STARTS_WITH_2 *************/

	ldr	r0, = chLF	@ End Line
	bl	putch

	ldr	r0, =strA	@ Load s1
	ldr	r1, =strPrefix2	@ Load Prefix
	bl	_startsWith_2	@ Get Boolean Result
	
	cmp	r0, #0		@ Print Boolean Result
	ldreq	r0, =strFalse
	ldrne	r0, =strTrue
	bl	putstring

	/**************  ENDS_WITH *************/

	ldr	r0, = chLF	@ End Line
	bl	putch

	ldr	r0, =strA	@ Load s1
	ldr	r1, =strPrefix3	@ Load Prefix
	bl	_endsWith	@ Get Boolean Result
	
	cmp	r0, #0		@ Print Boolean Result
	ldreq	r0, =strFalse
	ldrne	r0, =strTrue
	bl	putstring

	/*******************************   END  *******************************/
	
end:
	ldr	r0, = chLF	@ End Line
	bl	putch
	ldr	r0, = chLF	@ End Line
	bl	putch
	
	ldr	r0, =strEnd	@ Load into r0 address of strEnd
	bl	putstring	@ Print Prompt
	
	ldr	r0, = chLF	@ End Line
	bl	putch
	ldr	r0, = chLF	@ End Line
	bl	putch
	
	mov	r0, #0		@ Set program Exit status to 0
	mov 	r7, #1		@ Serivce command of 1 ro terminate
	svc	0		@ Perform Service Call to Linux
	.end
