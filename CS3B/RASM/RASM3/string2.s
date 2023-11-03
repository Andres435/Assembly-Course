@*****************************************************************************
@Name: 		Cole Espinola
@Program:	string2.s
@Class:		CS 3B
@Purpose:	Store the following string methods:
@
@	+String_length(string1:String):int
@	+String_indexOf1(string1:String,ch:char):int
@	+String_indexOf2(string1:String,ch:char,fromIndex:int):int
@	+String_indexOf3(string1:String,str:String):int
@	+String_lastIndexOf1(string1:String,ch:char):int
@	+String_lastIndexOf2(string1:String,ch:char,fromIndex:int):int
@	+String_lastIndexOf3(string1:String,str:String):int
@	+String_concat(string1:String,str:String):int
@	+String_replace(string1:String,oldChar:char,newChar:char):String
@   +String_toLowerCase(string1:String):String
@	+String_toUpperCase(string1:String):String
@
@*****************************************************************************

@*****************************************************************************
@ Program: length
@ Purpose: Run a function that accepts the address of a string counting characters in 
@          the string excluding the null character and returns that value as an int
@          in the R0 register
@
@ R0: Contains the address of the string.
@ LR: Contains the link address.
@
@ Returned register contents:
@ R0: Contains the number of characters in the string.
@ All registers perserved except R0.
@*****************************************************************************

	.text
	.global String_length                    @ provides a starting address for the linker
	
String_length:
	/* Push registers to stack */
	push	{r4-r8, r10, r11}       @ push registers to stack to perserve them
	
	mov	r4, #0                      @ counter variable
length_loop:
	/* length_loops through the bytes of string counting */
	ldrb	r5, [r0, r4]            @ load into r5 the byte at r0 offset by r4.
	cmp	r5, #0                      @ compare the byte values of r5 and null
	beq	length_exit                        @ if char at r5 equals null branch to length_exit
	
	add	r4, #1                      @ add 1 to r4
	b	length_loop                        @ branch back to the start of the length_loop
	
length_exit:
	mov r0, r4                      @ move the contents of r4 to r0
	pop	{r4-r8, r10, r11}           @ pop perserved registers off the stack
	
	bx	lr                          @ return to the function call of program

@*****************************************************************************
@ Program: indexOf1
@ Purpose: Run a function that returns the index of the first occurrence of 
@          the specified character ch in the string.
@
@ R0: Contains the address of the string.
@ R1: Contains the ascii char in hex.
@ LR: Contains the link address.
@
@ Returned register contents:
@ R0: Contains index of the first occurrence of the specified character.
@ All registers perserved except R0.
@*****************************************************************************
	
	.global indexOf_1                    @ provides a starting address for the linker
	
indexOf_1:
	/* Push registers to stack and load ch */
	push	{r4-r8, r10, r11}       @ push registers to stack to perserve them
	
	mov	r4, #0                      @ counter variable
	mov r6, #-1                     @ sets r6 equal to -1
iO1_loop:
	/* iO1_loops through the bytes of string for character */
	ldrb	r5, [r0, r4]            @ load into r5 the byte at r0 offset by r4.
	cmp	r5, r1                      @ compare the byte values of r5 and r1
	moveq	r6, r4                  @ move value of r4 to r6 if eq passed
	beq	iO1_exit                    @ if char at r5 equals char at r1 branch to iO1_exit
	cmp r5, #0                      @ compare r5 to null
	beq	iO1_exit                    @ branch to iO1_exit if r5 equals null char
	
	add	r4, #1                      @ add 1 to r4
	b	iO1_loop                    @ branch back to the start of the iO1_loop
	
iO1_exit:
	mov r6, r4                      @ move contents of r4 to r6
	mov r0, r6                      @ move the contents of r6 to r0

	pop	{r4-r8, r10, r11}           @ pop perserved registers off the stack
	
	bx	lr                          @ return to the function call of program
	

@*****************************************************************************
@ Purpose: Run a function that returns the index of the first occurrence of 
@          the specified character ch in the string, starting from the specified
@          index of the string.
@
@ R0: Contains the address of the string.
@ R1: Contains the ascii char in hex.
@ R2: Contains the index search starts at.
@ LR: Contains the link address.
@
@ Returned register contents:
@ R0: Contains index of the first occurrence of the specified character or -1
@     if no such index exists.
@ All registers perserved except R0.
@*****************************************************************************
	
	.global indexOf_2                    @ provides a starting address for the linker
	
indexOf_2:
	/* Push registers to stack and load ch */
	push	{r4-r8, r10, r11}       @ push registers to stack to perserve them
	
	mov	r4, r2                      @ counter variable that starts from specified index
	mov r6, #-1                     @ sets r6 to -1
iO2_loop:
	/* iO2_loops through the bytes of string for character */
	ldrb	r5, [r0, r4]            @ load into r5 the byte at r0 offset by the starting index in r4.
	cmp	r5, r1                      @ compare the byte values of r5 and r1
	moveq	r6, r4
	beq	iO2_exit                    @ if char at r5 equals char at r1 branch to iO2_exit
	cmp r5, #0                      @ if char at r5 equals null branch to iO2_exit
	beq	iO2_exit                    @ if char at r5 equals null branch to exit.
	
	add	r4, #1                      @ add 1 to r4
	b	iO2_loop                    @ branch back to the start of the iO2_loop
	
iO2_exit:
	mov r0, r6                      @ move the contents of r6 to r0

	pop	{r4-r8, r10, r11}           @ pop perserved registers off the stack
	
	bx	lr                          @ return to the function call of program

@*****************************************************************************
@ Purpose: Run a function that returns the index of the first occurrence of 
@          the specified substring in the string.
@
@ R0: Contains the address of the string.
@ R1: Contains the address of the substring in hex.
@ LR: Contains the link address.
@
@ Returned register contents:
@ R0: Contains index of the first occurrence of the specified character.
@ All registers perserved except R0.
@*****************************************************************************
	
	.global indexOf_3                    @ provides a starting address for the linker
	
indexOf_3:
	/* Push registers to stack and load ch */
	push	{r4-r8, r10, r11}       @ push registers to stack to perserve them
	push	{lr}                    @ push lr to perserve return address
	
	mov	r4, #0                      @ counter variable
	mov r7, #1                      @ counter variable for inner loop
	mov r6, #-1                     @ sets r6 equal to -1
	
iO3_loop1:
	/* loops through the bytes of string for character */
	ldrb	r5, [r0, r4]            @ load into r5 the byte at r0 offset by r4.
	cmp	r5, #0                      @ compare r5 to null
	beq	iO3_exit                    @ if char at r5 equals null then 
	ldrb	r10, [r1]               @ load into r10 the byte at r1
	cmp	r5, r10                     @ compare the byte values of r5 and r10
	bleq	iO3_preLoop2            @ if char at r5 equals char at r6 go to iO3_preLoop2

iO3_reset:
	/* resets counters and increments outer loop */
	mov r7, #1                      @ reset inner loop counter
	mov	r8, #0                      @ reset another inner loop counter
	add	r4, #1                      @ add 1 to outer loop counter
	
	b	iO3_loop1                   @ branch back to the start of the loop
	
iO3_preLoop2:
	/* Prep for iO3_loop2 */
	add	r8, r4, r7                  @ offset for original string 
	b	iO3_loop2                   @ branch to iO3_loop2 
	
iO3_loop2:
	/* loop through comparing substring and original string */
	ldrb	r10, [r1, r7]           @ load into r10 the byte at r1 offset by r7
	cmp	r10, #0                     @ compare r10 to null
	beq	iO3_setIndex                    @ branch to set index if r10 is null
	ldrb	r5,	[r0, r8]            @ load into r5 the byte at r0 offset by r8
	cmp	r5, #0                      @ compare r5 to null
	beq	iO3_reset                   @ branch back to iO3_loop1
	cmp	r5, r10                     @ compare chars at r5 and r10
	bne	iO3_reset                   @ branch back to  iO3_loop1
	
	add	r7, #1                      @ add 1 to r7
	add	r8, #1                      @ add 1 to r8
	b	iO3_loop2                   @ branch back to iO3_loop2 if r10 and r5 not null and equal
	
iO3_setIndex:
	/* Set the r6 equal to index that substring appeared at */
	mov r6, r4                      @ sets index equal to beginning index of substring
	b	iO3_exit                    @ branch to the iO3_exit
	
	
iO3_exit:
	mov r0, r6                      @ move the contents of r6 to r0

	pop {lr}                        @ pop lr register off of the stack
	pop	{r4-r8, r10, r11}           @ pop perserved registers off the stack
	
	bx	lr                          @ return to the function call of program

@*****************************************************************************
@ Purpose: Run a function that returns the index of the last occurrence of 
@          the specified character ch in the string.
@
@ R0: Contains the address of the string.
@ R1: Contains the ascii char in hex.
@ LR: Contains the link address.
@
@ Returned register contents:
@ R0: Contains index of the last occurrence of the specified character or
@     -1 if no such index exists.
@ All registers perserved except R0.
@*****************************************************************************
	
	.global lastIndexOf_1                    @ provides a starting address for the linker
	
lastIndexOf_1:
	/* Push registers to stack and load ch */
	push	{r4-r8, r10, r11}       @ push registers to stack to perserve them
	push	{lr}                    @ push lr to perserve return address
	
	mov	r4, #0                      @ counter variable
	mov r6, #-1                     @ set r6 to -1
lIO1_loop:
	/* Loops through the bytes of string for character */
	ldrb	r5, [r0, r4]            @ load into r5 the byte at r0 offset by r4.
	cmp	r5, #0                      @ compare byte value at r5 to null
	beq	lIO1_exit                   @ if char at r5 equals null branch to lIO1_exit
	cmp	r5, r1                      @ compare the byte values of r5 and r1
	moveq	r6, r4                  @ sets r6 equal to index of char
	
	add	r4, #1                      @ add 1 to r4
	b	lIO1_loop                   @ branch back to the start of the lIO1_loop
	
lIO1_exit:
	mov r0, r6                      @ move the contents of r6 to r0

	pop	{lr}                        @ pop lr register off of the stack
	pop	{r4-r8, r10, r11}           @ pop perserved registers off the stack
	
	bx	lr                          @ return to the function call of program

@*****************************************************************************
@ Purpose: Run a function that returns the index of the last occurrence of 
@          the specified character ch in the string.
@
@ R0: Contains the address of the string.
@ R1: Contains the ascii char in hex.
@ R2: Contains the index the search starts from.
@ LR: Contains the link address.
@
@ Returned register contents:
@ R0: Contains index of the last occurrence of the specified character.
@ All registers perserved except R0.
@*****************************************************************************
	
	.global lastIndexOf_2                    @ provides a starting address for the linker
	
lastIndexOf_2:
	/* Push registers to stack and load ch */
	push	{r4-r8, r10, r11}       @ push registers to stack to perserve them
	push	{lr}                    @ push lr to perserve return address
	
	mov	r4, r2                      @ counter variable
	mov	r6, #-1                     @ sets r6 to -1
lIO2_loop:
	/* Loops through the bytes of string for character */
	ldrb	r5, [r0, r4]            @ load into r5 the byte at r0 offset by r4.
	cmp	r5, #0                      @ compare byte value at r5 to null
	beq	lIO2_exit                        @ if char at r5 equals null branch to lIO2_exit
	cmp	r5, r1                      @ compare the byte values of r5 and r1
	moveq	r6, r4                  @ set r6 equal to char at r4 if  r5 and r1 equal
	
	add	r4, #1                      @ add 1 to r4
	b	lIO2_loop                   @ branch back to the start of the lIO2_loop
	
lIO2_exit:
	mov r0, r6                      @ move the contents of r6 to r0

	pop	{lr}                        @ pop lr register off of the stack
	pop	{r4-r8, r10, r11}           @ pop perserved registers off the stack
	
	bx	lr                          @ return to the function call of program


@*****************************************************************************
@ Purpose: Run a function that returns the index of the last occurrence of 
@          the specified substring in the string.
@
@ R0: Contains the address of the string.
@ R1: Contains the address of the substring in hex.
@ LR: Contains the link address.
@
@ Returned register contents:
@ R0: Contains index of the last occurrence of the specified substring.
@ All registers perserved except R0.
@*****************************************************************************
	
	.global lastIndexOf_3                    @ provides a starting address for the linker
	
lastIndexOf_3:
	/* Push registers to stack and load ch */
	push	{r4-r8, r10, r11}       @ push registers to stack to perserve them
	push	{lr}                    @ push lr to perserve return address
	
	mov	r4, #0                      @ counter variable
	mov r7, #1                      @ counter variable for inner loop
	mov r6, #-1                     @ sets r6 equal to -1
	
lIO3_loop1:
	/* loops through the bytes of string for character */
	ldrb	r5, [r0, r4]            @ load into r5 the byte at r0 offset by r4.
	cmp	r5, #0                      @ compare r5 to null
	beq	lIO3_exit                   @ if char at r5 equals null then 
	ldrb	r10, [r1]               @ load into r10 the byte at r1
	cmp	r5, r10                     @ compare the byte values of r5 and r10
	bleq	lIO3_preLoop2           @ if char at r5 equals char at r6 go to lIO3_preLoop2

lIO3_reset:
	/* resets inner loop counters increments outer loop */
	mov r7, #1                      @ reset inner loop counter
	mov	r8, #0                      @ reset another inner loop counter
	add	r4, #1                      @ add 1 to outer loop counter
	
	b	lIO3_loop1                  @ branch back to the start of the loop
	
lIO3_preLoop2:
	/* Prep for lIO3_loop2 */
	add	r8, r4, r7                  @ offset for original string 
	b	lIO3_loop2                  @ branch to lIO3_loop2 
	
lIO3_loop2:
	/* loop through comparing substring and original string */
	ldrb	r10, [r1, r7]           @ load into r10 the byte at r1 offset by r7
	cmp	r10, #0                     @ compare r10 to null
	moveq	r6, r4                  @ set r6 equal to the index the substring appeared at
	ldrb	r5,	[r0, r8]            @ load into r5 the byte at r0 offset by r8
	cmp	r5, #0                      @ compare r5 to null
	beq	lIO3_reset                  @ branch back to lIO3_loop1
	cmp	r5, r10                     @ compare chars at r5 and r10
	bne	lIO3_reset                  @ branch back to  lIO3_loop1
	
	add	r7, #1                      @ add 1 to r7
	add	r8, #1                      @ add 1 to r8
	b	lIO3_loop2                  @ branch back to lIO3_loop2 if r10 and r5 not null and equal
	
	
lIO3_exit:
	mov r0, r6                      @ move the contents of r6 to r0

	pop {lr}                        @ pop lr register off of the stack
	pop	{r4-r8, r10, r11}           @ pop perserved registers off the stack
	
	bx	lr                          @ return to the function call of program

@*****************************************************************************
@ Purpose: Run a function that concatentates a string to another string.
@
@ R0: Contains the address of the original string.
@ R1: Contains the address of the string to concatenate to first string.
@ LR: Contains the link address.
@
@ Returned register contents:
@ R0: Contains the pointer of newly created string.
@ All registers perserved except R0.
@*****************************************************************************
	
	.global concat                    @ provides a starting address for the linker
	
concat:
	/* Push registers to stack and load ch */
	push	{r4-r8, r10, r11}       @ push registers to stack to perserve them
	push	{lr}                    @ push lr to perserve return address
	
	mov	r4, r0                      @ moves r0 the address of the original string to r4 temp
	mov r5, r1                      @ moves r1 to r5 temp
	bl	String_length               @ calls length function to count num of chars in original
	add	r0, #1                      @ add 1 to r0 to include null char in length
	mov	r7, r0                      @ place the num of char in original in r7 temporarily
	
	mov r0, r5                      @ moves second string to r0
	bl	String_length               @ calls length function returning length of string in r0
	add	r0, r7                      @ adds the num of original chars with concat chars to assign that many bytes w malloc
	bl	malloc                      @ if MM can satisfy request then, then r0 contains address
	                                @ of newly allocated memory
	
	mov	r1, r5                      @ place concat string back in r1
	mov r6, r0                      @ moves r0 address of the heap memory to r6
	mov	r10, #0                     @ clear r10
	mov r0, r4                      @ moves the address of the original string back to r0
	
concat_loop1:
	/* loop through original string until null then loop through concat */
	ldrb	r8, [r0, r10]           @ load into r8 the byte at r0 offset by r10
	cmp	r8, #0                      @ cmp r8 to the null char
	moveq	r11, r10                @ set r11 equal to r10 for 2nd loop
	moveq	r10, #0                 @ clear r10 for 2nd loop
	beq	concat_loop2                @ if r0 equals the null char branch to concat_loop2
	strb	r8, [r6, r10]           @ store into the memory address at r6 offset by r10 the byte at r8
	add	r10, #1                     @ add 1 to r10 
	b	concat_loop1                @ branch back to beginning of concat_loop1
	
concat_loop2:
	/* loop through concat string until null adding that to new string */
	ldrb	r8, [r1, r10]           @ load into r8 the byte at r1 offset by r11
	cmp r8, #0                      @ cmp r8 to the null char
	beq	concat_exit                 @ if r8 equals the null char branch to concat_exit
	strb	r8, [r6, r11]           @ store into the memory address at r6 offset by r10 the byte at r8
	add r11, #1                     @ add 1 to r11
	add r10, #1                     @ add 1 to r10
	b	concat_loop2                @ branch back to beginning of concat_loop2
	
concat_exit:
	mov r0, r6                      @ move the contents of r6 to r0

	pop	{lr}                        @ pop lr register off of the stack
	pop	{r4-r8, r10, r11}           @ pop perserved registers off the stack
	
	bx	lr                          @ return to the function call of program

@*****************************************************************************
@ Purpose: Run a function that replaces all specified chars in a string
@          with another specified char.
@
@ R0: Contains the address of the original string.
@ R1: Contains the char to be replaced.
@ R2: Contains the char that will replace.
@ LR: Contains the link address.
@
@ Returned register contents:
@ R0: Contains pointer to new string.
@ All registers perserved except R0.
@*****************************************************************************
	
	.global replace                    @ provides a starting address for the linker
	
replace:
	/* Push registers to stack and load ch */
	push	{r4-r8, r10, r11}       @ push registers to stack to perserve them
	push	{lr}                    @ push lr to perserve return address
	mov	r10, #0                     @ clear r10
	
	mov	r4, r0                      @ moves r0 the address of the original string to r4 temp
	mov r5, r1                      @ moves the char in r1 to r5 temporarily
	mov r11, r2                     @ moves teh char in r11 to r2 temp
	bl	String_length               @ calls length function to count num of chars in original
	add	r0, #1                      @ add 1 to r0 to include null char in length
	bl	malloc                      @ allocates r0 num of bytes
	
	mov r6, r0                      @ moves r0 address of the heap memory to r6
	mov r0, r4                      @ moves the address of the original string back to r0
	mov	r1, r5                      @ moves the char in r5 back to r1
	mov	r2, r11                     @ moves the char in r11 back to r2
	
replace_loop1:
	/* loop through original string until null goes through loop fully if not char to be replaced */
	ldrb	r7, [r0, r10]           @ load into r8 the byte at r0 offset by r10
	cmp	r7, #0                      @ cmp r7 to the null char
	beq	replace_exit                        @ if the char in r7 equals null branch to replace_exit
	cmp	r7, r1                      @ cmp char in r7 to char in r1
	beq	replace_loop2                       @ if r0 equals the null char branch to replace_loop2
	strb	r7, [r6, r10]           @ store the byte in r7 into r6 offset by r10
	add r10, #1                     @ adds 1 to r10
	b	replace_loop1                       @ branches back to replace_loop1
	
replace_loop2:
	/* Replaces specified char */
	strb	r2, [r6, r10]           @ store into the memory address at r6 offset by r10 the byte at r2
	add	r10, #1                     @ adds 1 t0 r10
	b	replace_loop1                       @ branch back to replace_loop1
	
replace_exit:
	mov r0, r6                      @ move the contents of r6 to r0

	pop	{lr}                        @ pop lr register off of the stack
	pop	{r4-r8, r10, r11}           @ pop perserved registers off the stack
	
	bx	lr                          @ return to the function call of program

@*****************************************************************************
@ Purpose: Run a function that makes all the characters of a string lower case.
@
@ R0: Contains the address of the original string.
@ LR: Contains the link address.
@
@ Returned register contents:
@ R0: Contains pointer to new lower case string.
@ All registers perserved except R0.
@*****************************************************************************
	
	.global toLowerCase                    @ provides a starting address for the linker
	
toLowerCase:
	/* Push registers to stack and load ch */
	push	{r4-r8, r10, r11}       @ push registers to stack to perserve them
	push	{lr}                    @ push lr to perserve return address
	
	mov	r4, r0                      @ moves r0 the address of the original string to r4 temp
	ldr	r0, [r0]                    @ load into r0 deref value
	bl	String_length               @ calls length function to count num of chars in original
	add	r0, #1                      @ add 1 to r0 to include null char in length
	bl	malloc                      @ allocates r0 num of bytes
	
	mov r6, r0                      @ moves r0 address of the heap memory to r6
	mov r0, r4                      @ moves the address of the original string back to r0
	ldr r4, [r0]                    @ load into r4 the string value of r0
	mov	r10, #0                     @ clear register r10
	
lower_loop1:
	/* loop through original string until null*/
	ldrb	r8, [r4, r10]           @ load into r8 the byte at r4 offset by r10
	cmp	r8, #0                      @ cmp r8 to the null char
	beq	lower_exit                  @ if r0 equals the null char branch to loop2
	cmp	r8, #90                     @ cmp r8 to decimal value of ascii Z
	ble lower_isAlph1               @ branch to isChar1 if ascii value <= 90
	strb	r8, [r6, r10]           @ store into the memory address at r6 offset by r10 the byte at r8
	add	r10, #1                     @ adds 1 to r10
	b	lower_loop1                 @ branch to lower_loop1

lower_isAlph1:
	/* Check to see if ascii decimal value is >= 65 */
	cmp	r8, #65                     @ cmp r8 to decimal value of A
	bge	lower_isAlph2               @ branch to lower_isAlph2 if r8 >= 65
	strb	r8, [r6, r10]           @ store into the memory address at r6 offset by r10 the byte at r8
	add	r10, #1                     @ add 1 to r10
	b	lower_loop1                 @ branch back to lower_loop1 if not uppercase letter
	
lower_isAlph2:
	/* Adds 32 to decimal ascii value to turn into lowercase */
	add	r8, r8, #32                 @ adds 32 to uppercase case decimal value
	strb	r8, [r6, r10]           @ store into the memory address at r6 offset by r10 the byte at r8
	add	r10, #1                     @ add 1 to r10
	b	lower_loop1                 @ branch back to lower_loop1 if not uppercase letter
	
lower_exit:
	mov r0, r6                      @ move the contents of r6 to r0

	pop	{lr}                        @ pop lr register off of the stack
	pop	{r4-r8, r10, r11}           @ pop perserved registers off the stack
	
	bx	lr                          @ return to the function call of program

@*****************************************************************************
@ Purpose: Run a function that makes all the characters of a string upper case.
@
@ R0: Contains the address of the original string.
@ LR: Contains the link address.
@
@ Returned register contents:
@ R0: Pointer to new upper case string.
@ All registers perserved except R0.
@*****************************************************************************


	
	.global toUpperCase                    @ provides a starting address for the linker
	
toUpperCase:
	/* Push registers to stack and load ch */
	push	{r4-r8, r10, r11}       @ push registers to stack to perserve them
	push	{lr}                    @ push lr to perserve return address
	
	mov	r4, r0                      @ moves r0 the address of the original string to r4 temp
	ldr r0, [r0]                    @ load into r0 the deref value
	bl	String_length               @ calls length function to count num of chars in original
	add	r0, #1                      @ add 1 to r0 to include null char in length
	bl	malloc                      @ allocates r0 num of bytes
	
	mov r6, r0                      @ moves r0 address of the heap memory to r6
	mov r0, r4                      @ moves the address of the original string back to r0
	ldr r4, [r0]                    @ load into r4 the deref value of r0
	mov	r10, #0                     @ clear register r10
	
upperCase_loop1:
	/* loop through original string until null*/
	ldrb	r8, [r4, r10]           @ load into r8 the byte at r0 offset by r10
	cmp	r8, #0                      @ cmp r8 to the null char
	beq	upperCase_exit              @ if r0 equals the null char branch to upperCase_loop2
	cmp	r8, #122                    @ cmp r8 to decimal value of ascii z
	ble upper_isAlph1               @ branch to upper_isAlph1 if ascii value <= 122
	strb	r8, [r6, r10]           @ store into the memory address at r6 offset by r10 the byte at r8
	add	r10, #1                     @ adds 1 to r10
	b	upperCase_loop1             @ branch to upperCase_loop1

upper_isAlph1:
	/* Check to see if ascii decimal value is >= 97 */
	cmp	r8, #97                     @ cmp r8 to decimal value of a
	bge	upper_isAlph2               @ branch to upper_isAlph2 if r8 >= 97
	strb	r8, [r6, r10]           @ store into the memory address at r6 offset by r10 the byte at r8
	add	r10, #1                     @ add 1 to r10
	b	upperCase_loop1             @ branch back to upperCase_loop1 if not uppercase letter
	
upper_isAlph2:
	/* Subtracts 32 to decimal ascii value to turn into upper case */
	sub	r8, r8, #32                 @ subtracts 32 to uppercase case decimal value
	strb	r8, [r6, r10]           @ store into the memory address at r6 offset by r10 the byte at r8
	add	r10, #1                     @ add 1 to r10
	b	upperCase_loop1             @ branch back to upperCase_loop1 if not uppercase letter
	
upperCase_exit:
	mov r0, r6                      @ move the contents of r6 to r0

	pop	{lr}                        @ pop lr register off of the stack
	pop	{r4-r8, r10, r11}           @ pop perserved registers off the stack
	
	bx	lr                          @ return to the function call of program

	
	
	
