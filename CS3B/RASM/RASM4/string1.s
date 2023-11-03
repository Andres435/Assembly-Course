@*****************************************************************************
@Name: 		Andres Quintana
@Program:	string1.s
@Class:		CS 3B
@Purpose:	Store the followinr string methods:
@
@	+String_length(string1:String):int
@	+String_equals(string1:String,string2:String):boolean(byte)
@	+String_equalsIgnoreCase(string1:String,string2:String):boolean(byte)
@	+String_copy(lpStringToCopy:dword):dword
@	+String_substring_1(string1:String,beginIndex:int,endIndex:int):String
@	+String_substring_2(string1:String,beginIndex:int):String
@	+String_charAt(string1:String,position:int):char (byte) 
@	+String_startsWith_1(string1:String,strPrefix:String, pos:int):boolean
@	+String_startsWith_2(string1:String, strPrefix:String):boolean 
@	+String_endsWith(string1:String, suffix:String):boolean
@
@*****************************************************************************

@*****************************************************************************
@Name:      Andres Quintana
@Program:   string_length.s
@Class:     CS 3B
@Purpose:
@	This method accepts the address of a string and counts the characters 
@	in the string, excluding the NULL character and returns that value 
@	as an int (word) in the R0 register.  
@	 
@	+String_length(string1:String):int
@*****************************************************************************	

	.text
	.align	2
	.global _length		@Starting address to linker

_length:                            
	stmfd   sp!, {lr}       @ Push lr
	mov     r1, #0		@ counter = 0
	bl      count
	ldmfd   sp!, {lr}	@ Pop lr
	bx      lr		@ Return

count:
	stmfd   sp!, {lr}	@ Push lr
	ldrb    r2, [r0]
	cmp     r2, #0		@ If r2 = 0, Return Length
	moveq	r0, r1		@ r0 = r1 (Length)
	bxeq	lr		@ return

	add     r1, r1, #1	@ counter++
	add     r0, r0, #1	@ go to next char
	bl      count		@ go back to count

	ldmfd   sp!, {lr}	@ Pop lr
	bx      lr		@ return

@*****************************************************************************
@Name:      Andres Quintana
@Program:   string_CharAt.s
@Class:     CS 3B
@Purpose:
@	This method returns the character in the indicated position. 
@	If the request is impossible to fulfill, the method returns 0 
@
@	r0: String	r1:	int
@	 
@	+String_charAt(string1:String,position:int):char (byte) 
@*****************************************************************************	
	
		.text
		.global _charAt	@Starting address to linker

_charAt:
	mov	r5, r1		@ r5 = counter

charAt:
	cmp	r5, #0		@ If counter = 0, End
	beq	endCharAt
	
	ldrb	r6, [r0]	@ load into r4 character of the string
	add	r0, #1		@ Go to next char
	sub	r5, r5, #1	@ counter--
	
	cmp	r6, #0		@ If char == null, End
	beq	end
	b	charAt		@ Else, loop back 

endCharAt:
	mov	r0, r6
	bx      lr		@ return

@*****************************************************************************
@Name:      Andres Quintana
@Program:   string_copy.s
@Class:     CS 3B
@Purpose:
@	This method accepts a string to copy, allocates dynamically enough storage
@	to hold a copy of the new characters, copies the characters and returns 
@	the address of that newly created string.
@	 
@	+String_copy(lpStringToCopy:dword):dword
@*****************************************************************************	
		.data
		ptrStr:	.word	0
	
		.text
		.global _copy	@Starting address to linker

_copy:
	stmfd   sp!, {lr}       @ Push lr
	mov	r5, r0		@ Temporarly store string in r5
	bl	_length		@ Get size
	add	r0, #1      @ To account for the null char
	bl	malloc		@ memory allocation 
	
	ldr	r6, =ptrStr	@ Pointer to the new String
	str	r0, [r6]	@ *r0 = r6
	ldr	r6, [r6]	@ r6 = *r6
	
copy:
	ldrb	r4, [r5]	@ load into r4 character of the string
	add	r5, #1		@ Go to next char

	strb	r4, [r6]	@ store char into new string
	add	r6, #1		@ move to next space
	
	cmp 	r4, #0		@ If char = null, Jump to bottom
	beq	endCopy		@ Else, loop
	b	copy
	
endCopy:
	ldmfd   sp!, {lr}	@ Pop lr
	ldr	r6, =ptrStr	@ Load new string into r6
	ldr	r0, [r6]	@ r0 = *r6
	bx      lr		@ return

@*****************************************************************************
@Name:      Andres Quintana
@Program:   string_equals.s
@Class:     CS 3B
@Purpose:
@	This method makes an exact comparison of individual characters in two 
@	strings. If any character in the string in a positionis different than 
@	the character in the same position in the other string, the method 
@	returns “false” (0  in the R0 register). If the length of the two strings
@	is different, the method also returns “false”. 
@	 
@	+String_equals(string1:String,string2:String):boolean   (byte)
@*****************************************************************************	
		.data
		booleanEquals:	.byte	1
	
		.text
		.global _equals	@Starting address to linker

_equals:
	ldr	r7, =booleanEquals	@ Initialize boolean to true
	mov	r8, #1	
	str	r8, [r7]

	ldrb	r5, [r0]	@ load into r5 character of the string
	add	r0, #1		@ Go to next char

	ldrb	r6, [r1]	@ store char of the string
	add	r1, #1		@ move to next space
	
	cmp	r5, #0		@ If char == null, End
	beq	stringEnd

	cmp	r5, r6		@ If both char are the same, Loop
	beq	_equals		@ Else, Jump to notEqual
	b	notEquals

stringEnd:
	cmp	r6, #0		@ If char to compare is null, End
	beq	endEquals	@ Else, Jump to notEquals
	
notEquals:
	ldr	r6, =booleanEquals	@ Make boolean == false
	mov	r0, #0
	str	r0, [r6]
	
endEquals:
	ldr	r0, =booleanEquals	@ Store boolean into r0
	ldr	r0, [r0]	@ r0 = *r0
	bx      lr		@ return

@*****************************************************************************
@Name:      Andres Quintana
@Program:   string_equalsIgnoreCase.s
@Class:     CS 3B
@Purpose:
@	This method makes a comparison of individual characters in two strings 
@	ignoring case. If any character in the string in a position is different 
@	than the character in the same position in the other string, the method 
@	returns “false” (0  in the R0 register). If the length of the two strings 
@	is different, the method also returns “false”.
@	 
@	+String_equalsIgnoreCase(string1:String,string2:String):boolean   (byte)
@*****************************************************************************	

		.data
		booleanIgnoreCase:	.byte	1

		.text
		.global _equalsIgnoreCase	@Starting address to linker

_equalsIgnoreCase:
	ldr	r7, =booleanIgnoreCase	@ Initialize boolean to true
	mov	r8, #1	
	str	r8, [r7]

	ldrb	r5, [r0]	@ load into r5 character of the string
	add	r0, #1		@ Go to next char

	ldrb	r6, [r1]	@ store char of the string
	add	r1, #1		@ move to next space
	
	cmp	r5, #0		@ If char == null, End
	beq	ignoreCaseEnd

	cmp	r5, #0x61	@ Compare if Char is lowercase
	subge	r5, r5, #0x20	@ If so char - 20H
	
	cmp	r6, #0x61	@ Compare if Char is lowercase
	subge	r6, r6, #0x20	@ If so char - 20H
	
	cmp	r5, r6		@ If both char are the same, Loop
	beq	_equalsIgnoreCase	@ Else, Jump to notEqualsIgnoreCase
	b	notEqualsIgnoreCase

ignoreCaseEnd:
	cmp	r6, #0		@ If char to compare is null, End
	beq	endIgnoreCase	@ Else, Jump to notEqualsIgnore

notEqualsIgnoreCase:
	ldr	r6, =booleanIgnoreCase	@ Make boolean == false
	mov	r0, #0
	str	r0, [r6]
	
endIgnoreCase:
	ldr	r0, =booleanIgnoreCase	@ Store boolean into r0
	ldr	r0, [r0]	@ r0 = *r0
	bx      lr		@ return

@*****************************************************************************
@Name:      Andres Quintana
@Program:   string_startsWith_1.s
@Class:     CS 3B
@Purpose:
@	 It checks whether the substring (starting from the specified offset index)
@	 exists within string1. For example testing the string “George Washington” 
@	 for the prefix “Wash” starting in position 7 would return “true” (1) 
@	 otherwise, it would return false (0) would have is having the specified 
@	 prefix or not.
@	 
@	 +String_startsWith_1(string1:String,strPrefix:String, pos:int):boolean
@*****************************************************************************	
		.data
		booleanStarts1:	.byte	1
		
		.text
		.global _startsWith_1	@Starting address to linker

_startsWith_1:
	ldr	r9, =booleanStarts1	@ Initialize boolean to true
	mov	r8, #1	
	str	r8, [r9]

	mov	r5, r2		@ Make counter = offset index

	add	r0, r5		@ move to next char
	ldrb	r6, [r0]	@ load into r6 character of the string
	ldrb	r7, [r1]	@ load char of the prefix

	cmp	r6, r7		@ If both char are the same, Loop
	beq	startsWith1	@ Else, Jump to notEqualsStarts1
	b	notEqualsStarts1
		
startsWith1:	
	ldrb	r6, [r0]	@ load into r6 character of the string
	add	r0, #1		@ move to next char

	ldrb	r7, [r1]	@ load char of the string
	add	r1, #1		@ move to next chat
	
	cmp	r6, #0		@ If char == null, End
	beq	endStartsWith1

	cmp	r6, r7		@ If both char are the same, Loop
	beq	startsWith1	@ Else, Jump to notEqualsStarts1
	b	notEqualsStarts1

startsWith1End:
	cmp	r7, #0		@ If char to compare is null, End
	beq	endStartsWith1	@ Else, Jump to notEqualsStarts1

notEqualsStarts1:
	ldr	r6, =booleanStarts1	@ Make boolean == false
	mov	r0, #0
	str	r0, [r6]

endStartsWith1:
	ldr	r0, =booleanStarts1	@ Store boolean into r0
	ldr	r0, [r0]	@ r0 = *r0
	bx      lr		@ return

@*****************************************************************************
@Name:      Andres Quintana
@Program:   string_startsWith_2.s
@Class:     CS 3B
@Purpose:
@	 It tests whether string1 begins with the specified prefix. 
@	 If yes then it returns true else false.
@	 
@	 +String_startsWith_2(string1:String, strPrefix:String):boolean
@*****************************************************************************	
		.data
		booleanStarts2:	.byte	1
		
		.text
		.global _startsWith_2	@Starting address to linker

_startsWith_2:
	ldr	r9, =booleanStarts2	@ Initialize boolean to true
	mov	r8, #1	
	str	r8, [r9]
	
	ldrb	r6, [r0]	@ load into r6 character of the string
	add	r0, #1		@ move to next char

	ldrb	r7, [r1]	@ load char of the string
	add	r1, #1		@ move to next chat
	
	cmp	r7, #0		@ If char == null, End
	beq	endStartsWith2

	cmp	r6, r7		@ If both char are the same, Loop
	beq	_startsWith_2	@ Else, Jump to notEqualsStarts2
	b	notEqualsStarts2

startsWith2End:
	cmp	r6, #0		@ If char to compare is null, End
	beq	endStartsWith2	@ Else, Jump to notEqualsStarts2


notEqualsStarts2:
	ldr	r6, =booleanStarts2	@ Make boolean == false
	mov	r0, #0
	str	r0, [r6]
	
endStartsWith2:
	ldr	r0, =booleanStarts2	@ Store boolean into r0
	ldr	r0, [r0]	@ r0 = *r0
	bx      lr		@ return

@*****************************************************************************
@Name:      Andres Quintana
@Program:   string_endsWith.s
@Class:     CS 3B
@Purpose:
@	 Checks whether the string ends with the specified suffix.
@	 
@	 +String_endsWith(string1:String, suffix:String):boolean
@*****************************************************************************	
		.data
		booleanEndsWith:	.byte	1
		
		.text
		.global _endsWith	@Starting address to linker

_endsWith:
	stmfd   sp!, {lr}	@ Push lr
	ldr	r9, =booleanEndsWith	@ Initialize boolean to true
	mov	r8, #1
	str	r8, [r9]

	mov	r5, r0		@ Temporarly store string in r5
	mov	r6, r1		@ temporarly store suffix in r6

	bl	_length		@ Get string size
	mov	r9, r0		@ store length of string
	
	mov	r0, r6
	bl	_length		@ Get suffix size
	mov 	r10, r0		@ store length of the suffix
	
	cmp	r9, r10		@ Check if suffix < string
	blt	notEqualsEndsWith	@ Else, Jump to notEqualEndsWith
	
	mov	r0, r5		@ return string to r0
	mov	r1, r6		@ return suffix to r1
	sub	r2, r9, r10	@ Get loop starting index

	bl	_startsWith_1	@ Call startWith_1 to get boolean

	ldr	r8, =booleanEndsWith	@ Load boolean
	str	r0, [r8]	@ store result from startWith into boolean
	b	end
	
notEqualsEndsWith:
	ldr	r6, =booleanEndsWith	@ Make boolean == false
	mov	r0, #0
	str	r0, [r6]
	
end:
	ldmfd   sp!, {lr}	@ Pop lr
	ldr	r0, =booleanEndsWith	@ Store boolean into r0
	ldr	r0, [r0]	@ r0 = *r0
	bx      lr		@ return

@*****************************************************************************
@Name:      Andres Quintana
@Program:   string_substring_1.s
@Class:     CS 3B
@Purpose:
@	 This method creates a new string consisting of characters from a substring 
@	 of the passed string starting with beginIndex and ending with endIndex
@	 
@	 +String_substring_1(string1:String,beginIndex:int,endIndex:int):String
@*****************************************************************************	

		.text
		.global _substring_1		@Starting address to linker

_substring_1:
	stmfd   sp!, {lr}       @ Push lr
	mov	r5, r0		@ Temporarly store string in r5
	mov	r9, r1		@ Temporary store index in r9
	sub	r8, r2, r1	@ EndIndex - BeginIndex = space needed
	mov	r0, r8
	bl malloc		@ allocate memory size
	
	ldr	r6, =ptrStr	@ Load into r6 Pointer to the new String
	str	r0, [r6]	@ *r0 = r6
	ldr	r6, [r6]	@ r6 = *r6
	
	add	r5, r9		@ move to next char
	ldrb	r4, [r5]	@ load into r4 character of the string
	
substring1:
	ldrb	r4, [r5]	@ load into r4 character of the string
	add	r5, #1		@ Go to next char

	strb	r4, [r6]	@ store char into new string
	add	r6, #1		@ move to next space
	
	sub	r8, #1		@ counter--
	cmp	r8, #0		@ If space = 0, end
	beq	endSubstring1	@ Else, loop
	b	substring1
		
endSubstring1:
	ldmfd   sp!, {lr}	@ Pop lr
	ldr	r6, =ptrStr	@ Load new string into r6
	ldr	r0, [r6]	@ r0 = *r6
	bx      lr		@ return

@*****************************************************************************
@Name:      Andres Quintana
@Program:   string_substring_2.s
@Class:     CS 3B
@Purpose:
@	 This method creates a new string consisting of characters from a substring 
@	 of the passed string starting with beginIndex to the end of the original 
@	 string.1
@	 
@	 +String_substring_2(string1:String,beginIndex:int):String
@*****************************************************************************	

		.text
		.global _substring_2		@Starting address to linker

_substring_2:
	stmfd   sp!, {lr}       @ Push lr
	mov	r5, r0
	mov	r9, r1
	mov	r0, #32		@ Get memory size
	bl 	malloc		@ allocate memory size
	
	ldr	r6, =ptrStr	@ Load into r6 Pointer to the new String
	str	r0, [r6]	@ *r0 = r6
	ldr	r6, [r6]	@ r6 = *r6
	
	add	r5, r9		@ move to next char
	ldrb	r4, [r5]	@ load into r4 character of the string
	
substring2:
	ldrb	r4, [r5]	@ load into r4 character of the string
	add	r5, #1		@ Go to next char

	strb	r4, [r6]	@ store char into new string
	add	r6, #1		@ move to next space
	
	cmp	r4, #0		@ char != null, loop
	bne	substring2	@ Else, End
	b	endSubstring2
	
endSubstring2:
	ldmfd   sp!, {lr}	@ Pop lr
	ldr	r6, =ptrStr	@ Load new string into r6
	ldr	r0, [r6]	@ r0 = *r6
	bx      lr		@ return
