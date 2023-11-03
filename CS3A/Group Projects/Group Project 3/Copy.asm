// This file uses the Hack language and fonts
// that are part of www.nand2tetris.org
// and the book "The Elements of Computing Systems"
// by Nisan and Schocken, MIT Press.
//
// coded by Andres Quintana November 2020 for CS 3A

//
// functions aq_getInput_X (where X is one of the characters 0,1
//
// Call aq_getInput_X as follows:
//     - Initialize R0...R15
//     - Get Inputs and fill R0...R15
//     - jump to ge_output_X to output the character X 
//       , where X is one of the characters 0,1

@aq_counter
M=0

// Function that Set R0...R15 to 0
(AQ_INITIALICE)
    @aq_counter
    D=M
    @15
    D=D-A // set counter = counter - 15
    @AQ_KEYBOARD
    D;JGT // If counter > 0 Jump

    @aq_counter
    D=M
    A=D
    M=0 // set R(X) = 0
    @aq_counter
    M=M+1 // counter++
@AQ_INITIALICE
0;JMP

// Function that Set R15...R0 to input values
// Counter goes from R15 to R0 and Column goes from 0 to 15
(AQ_KEYBOARD)
    @16
    D=A // Set counter = 16
    @aq_counter
    M=D
    @aq_column
    M=-1 // Initialize column = -1

    (AQ_KEYBOARD_LOOP)
        @aq_column
        M=M+1 // column++
        D=M
        @ge_currentColumn
        M=D // ge_currentColumn = column
        @AQ_RETURN
        D=A
        @ge_output_return
        M=D // pointer to AQ_RETURN

        @aq_counter
        M=M-1 // counter--
        D=M

        (AQ_PRESS_KBD) // Loop until Keyboard is pressed
            @KBD // keyboard value.
            D=M
            @aq_pressed
            M=D // set to KBD
        @AQ_PRESS_KBD
        D;JEQ

        //=======================================================
        //IS NOT SAVING THE VALUE... CHECK LATER
        @aq_counter
        D=M
        A=D // RAM[counter]
        @aq_pressed
        M=D // RAM[counter] = KBD

        //=======================================================

        //=======================================================
        // THIS PART IS WRONG SINCE FOR SOME REASON KBD ONLY 
        // GIVE A NUMBER BIGGER THAN 0 WHEN PRESSED ASK SOMEONE
        @ge_output_1
        D;JGT // If input is 1 jump

        @geoutput_0
        D;JEQ // If input is 0 jump
        //=======================================================

        (AQ_RETURN) // Return from ge_output_return

        @KBD
        D=0 // Reset KBD
        @aq_counter
        D=M
    //============================================================
    // THERE IS SOMETHING WRONG IN THE LOOP IS NOT STOPING
    @AQ_KEYBOARD_LOOP
    D;JGT // If counter > 0, Jump
    //============================================================

    @R15
    D=M
    @AQ_TWOS_COMPLEMENT
    D;JGE // If R15 = 1, Jump

@END //================TAKE END OFF WHEN INPUT IS RIGHT==========
0;JMP//===========================================================

// Function that change the binary code into its two's complement
@aq_counter
M=0 // Reset Counter

(AQ_TWOS_COMPLEMENT)
    @aq_counter
    D=M
    A=D // RAM[counter]
    D=M // Get value from RAM[counter]
    
    @IF_0
    D;JGT // If R(X) = 0, Jump
    M=0   // convert to complement 1->0
    @CONVERT
    0;JMP

    (IF_0) // Convert to complement 0->1
        M=1
        @CONVERT
        0;JMP

    (CONVERT)
        @aq_counter
        D=M
        @AQ_CARRY
        D;JEQ // If counter = 0, Jump
        @aq_carry
        D=M
        @AQ_IF_CARRY
        D;JGT // If carry = 1, Jump

        (AQ_CARRY) // This function is used to add 1 to R0
            @aq_counter
            D=M
            A=D // RAM[counter]
            D=M // Get value from RAM[counter]
            @IF_1
            D;JGT // RAM[counter] > 0, Jump
            
            (IF_1)
                M=0 // Convert to 2' complement 1->0
                @aq_carry
                M=1
        @AQ_CONTINUE
        0;JMP

        (AQ_IF_CARRY) // Function if carry = 1
            @aq_counter
            D=M
            A=D // RAM[counter]
            D=M // Get value from RAM[counter]
            @AQ_SUM
            D;JGT // If RAM[count] > 0, jump
            // Else
            M=1 // RAM[counter] = Carry
            @aq_carry
            M=0 // Carry was used 1->0
            @AQ_CONTINUE
            0;JMP

            (AQ_SUM)
                M=0 // Binary 1 + 1 = 0; then carry = 1
                @AQ_CONTINUE
                0;JMP

    (AQ_CONTINUE)

    @aq_counter
    M=M+1 // counter++
    D=M
    @15
    D=D-A // counter - 15
@AQ_TWOS_COMPLEMENT
D;JEQ // Jump if the counter substraction is 0

(END)
    @END
    0;JMP

// This file uses the Hack language and fonts
// that are part of www.nand2tetris.org
// and the book "The Elements of Computing Systems"
// by Nisan and Schocken, MIT Press.
//
// coded by George Eaton November 2020 for CS 3A

//
// functions ge_output_X (where X is one of the characters 0,1,2,3,4,5,6,7,8,9,0,- (minus),
//                        s (space bar), or g (greater than  > )
//
// Outputs character X (see above) at a specified column, where columns run from
// 0 to 31.
//
// Call ge_output_X as follows:
//     - save return address in ge_output_return
//     - save the current column (starting with 0 for the first column) in
//       variable ge_currentColumn
//     - jump to ge_output_X to output the character X in
//       column ge_currentColumn, where X is one of the
//       the characters 0,1,2,3,4,5,6,7,8,9,0,-,s, or g


// this helper function ge_continue_output outputs the character defined by
// frontRow1 through initialized below it in the functions ge_output_X
(ge_continue_output)
    //
    // ***constants***
    //
    // ge_rowOffset - number of words to move to the next row of pixels
    @32
    D=A
    @ge_rowOffset
    M=D
    // end of constants
    //

    //
    // ***key variables***
    //

    // ge_currentRow - variable holding the display memory address to be written,
    //                 which starts at the fourth row of pixels (SCREEN + 3 x rowOffset) 
    //                 offset by the current column and
    //                 increments row by row to draw the character
    //               - initialized to the beginning of the fourth row in screen memory
    //                 plus the current column
    @SCREEN
    D=A
    @ge_rowOffset
    // offset to the fourth row
    D=D+M
    D=D+M
    D=D+M
    // add the current column
    @ge_currentColumn
    D=D+M
    @ge_currentRow
    M=D
    //


    // write the first row of pixels
    // load pattern in D via A
    @fontRow1
    D=M
    // write pattern at currentLine
    @ge_currentRow
    A=M
    M=D
    //

    // update current line
    @ge_rowOffset
    D=M
    @ge_currentRow
    M=D+M
    // load pattern in D via A
    @fontRow2
    D=M
    // write pattern at currentLine
    @ge_currentRow
    A=M
    M=D
    //


    // update current line
    @ge_rowOffset
    D=M
    @ge_currentRow
    M=D+M
    // load pattern in D via A
    @fontRow3
    D=M
    // write pattern at currentLine
    @ge_currentRow
    A=M
    M=D
    //


    // update current line
    @ge_rowOffset
    D=M
    @ge_currentRow
    M=D+M
    // load pattern in D via A
    @fontRow4
    D=M
    // write pattern at currentLine
    @ge_currentRow
    A=M
    M=D
    //


    // update current line
    @ge_rowOffset
    D=M
    @ge_currentRow
    M=D+M
    // load pattern in D via A
    @fontRow5
    D=M
    // write pattern at currentLine
    @ge_currentRow
    A=M
    M=D
    //


    // update current line
    @ge_rowOffset
    D=M
    @ge_currentRow
    M=D+M
    // load pattern in D via A
    @fontRow6
    D=M
    // write pattern at currentLine
    @ge_currentRow
    A=M
    M=D
    //


    // update current line
    @ge_rowOffset
    D=M
    @ge_currentRow
    M=D+M
    // load pattern in D via A
    @fontRow7
    D=M
    // write pattern at currentLine
    @ge_currentRow
    A=M
    M=D
    //


    // update current line
    @ge_rowOffset
    D=M
    @ge_currentRow
    M=D+M
    // load pattern in D via A
    @fontRow8
    D=M
    // write pattern at currentLine
    @ge_currentRow
    A=M
    M=D
    //


    // update current line
    @ge_rowOffset
    D=M
    @ge_currentRow
    M=D+M
    // load pattern in D via A
    @fontRow9
    D=M
    // write pattern at currentLine
    @ge_currentRow
    A=M
    M=D
    //



    // return from function
    @ge_output_return
    A=M
    0;JMP



    //
    // individual function ge_output_X definitions which are 
    // just font definitions for the helper function above
    //

    //ge_output_0
    (ge_output_0)
    //do Output.create(12,30,51,51,51,51,51,30,12); // 0

    @12
    D=A
    @fontRow1
    M=D

    @30
    D=A
    @fontRow2
    M=D

    @51
    D=A
    @fontRow3
    M=D

    @51
    D=A
    @fontRow4
    M=D

    @51
    D=A
    @fontRow5
    M=D

    @51
    D=A
    @fontRow6
    M=D

    @51
    D=A
    @fontRow7
    M=D

    @30
    D=A
    @fontRow8
    M=D

    @12
    D=A
    @fontRow9
    M=D
    @ge_continue_output
    0;JMP
    // end ge_output_0

    //ge_output_1
    (ge_output_1)
    //do Output.create(12,14,15,12,12,12,12,12,63); // 1

    @12
    D=A
    @fontRow1
    M=D

    @14
    D=A
    @fontRow2
    M=D

    @15
    D=A
    @fontRow3
    M=D

    @12
    D=A
    @fontRow4
    M=D

    @12
    D=A
    @fontRow5
    M=D

    @12
    D=A
    @fontRow6
    M=D

    @12
    D=A
    @fontRow7
    M=D

    @12
    D=A
    @fontRow8
    M=D

    @63
    D=A
    @fontRow9
    M=D
    @ge_continue_output
    0;JMP
    // end ge_output_1

    //ge_output_2
    (ge_output_2)
    //do Output.create(30,51,48,24,12,6,3,51,63);   // 2

    @30
    D=A
    @fontRow1
    M=D

    @51
    D=A
    @fontRow2
    M=D

    @48
    D=A
    @fontRow3
    M=D

    @24
    D=A
    @fontRow4
    M=D

    @12
    D=A
    @fontRow5
    M=D

    @6
    D=A
    @fontRow6
    M=D

    @3
    D=A
    @fontRow7
    M=D

    @51
    D=A
    @fontRow8
    M=D

    @63
    D=A
    @fontRow9
    M=D
    @ge_continue_output
    0;JMP
    // end ge_output_2


    //ge_output_3
    (ge_output_3)
    //do Output.create(30,51,48,48,28,48,48,51,30); // 3

    @30
    D=A
    @fontRow1
    M=D

    @51
    D=A
    @fontRow2
    M=D

    @48
    D=A
    @fontRow3
    M=D

    @48
    D=A
    @fontRow4
    M=D

    @28
    D=A
    @fontRow5
    M=D

    @48
    D=A
    @fontRow6
    M=D

    @48
    D=A
    @fontRow7
    M=D

    @51
    D=A
    @fontRow8
    M=D

    @30
    D=A
    @fontRow9
    M=D
    @ge_continue_output
    0;JMP
    // end ge_output_3

    //ge_output_4
    (ge_output_4)
    //do Output.create(16,24,28,26,25,63,24,24,60); // 4

    @16
    D=A
    @fontRow1
    M=D

    @24
    D=A
    @fontRow2
    M=D

    @28
    D=A
    @fontRow3
    M=D

    @26
    D=A
    @fontRow4
    M=D

    @25
    D=A
    @fontRow5
    M=D

    @63
    D=A
    @fontRow6
    M=D

    @24
    D=A
    @fontRow7
    M=D

    @24
    D=A
    @fontRow8
    M=D

    @60
    D=A
    @fontRow9
    M=D
    @ge_continue_output
    0;JMP
    // end ge_output_4

    //ge_output_5
    (ge_output_5)
    //do Output.create(63,3,3,31,48,48,48,51,30);   // 5

    @63
    D=A
    @fontRow1
    M=D

    @3
    D=A
    @fontRow2
    M=D

    @3
    D=A
    @fontRow3
    M=D

    @31
    D=A
    @fontRow4
    M=D

    @48
    D=A
    @fontRow5
    M=D

    @48
    D=A
    @fontRow6
    M=D

    @48
    D=A
    @fontRow7
    M=D

    @51
    D=A
    @fontRow8
    M=D

    @30
    D=A
    @fontRow9
    M=D
    @ge_continue_output
    0;JMP
    // end ge_output_5

    //ge_output_6
    (ge_output_6)
    //do Output.create(28,6,3,3,31,51,51,51,30);    // 6

    @28
    D=A
    @fontRow1
    M=D

    @6
    D=A
    @fontRow2
    M=D

    @3
    D=A
    @fontRow3
    M=D

    @3
    D=A
    @fontRow4
    M=D

    @31
    D=A
    @fontRow5
    M=D

    @51
    D=A
    @fontRow6
    M=D

    @51
    D=A
    @fontRow7
    M=D

    @51
    D=A
    @fontRow8
    M=D

    @30
    D=A
    @fontRow9
    M=D
    @ge_continue_output
    0;JMP
    // end ge_output_6

    //ge_output_7
    (ge_output_7)
    //do Output.create(63,49,48,48,24,12,12,12,12); // 7

    @63
    D=A
    @fontRow1
    M=D

    @49
    D=A
    @fontRow2
    M=D

    @48
    D=A
    @fontRow3
    M=D

    @48
    D=A
    @fontRow4
    M=D

    @24
    D=A
    @fontRow5
    M=D

    @12
    D=A
    @fontRow6
    M=D

    @12
    D=A
    @fontRow7
    M=D

    @12
    D=A
    @fontRow8
    M=D

    @12
    D=A
    @fontRow9
    M=D
    @ge_continue_output
    0;JMP
    // end ge_output_7


    //ge_output_8
    (ge_output_8)
    //do Output.create(30,51,51,51,30,51,51,51,30); // 8

    @30
    D=A
    @fontRow1
    M=D

    @51
    D=A
    @fontRow2
    M=D

    @51
    D=A
    @fontRow3
    M=D

    @51
    D=A
    @fontRow4
    M=D

    @30
    D=A
    @fontRow5
    M=D

    @51
    D=A
    @fontRow6
    M=D

    @51
    D=A
    @fontRow7
    M=D

    @51
    D=A
    @fontRow8
    M=D

    @30
    D=A
    @fontRow9
    M=D
    @ge_continue_output
    0;JMP
    // end ge_output_8



    //ge_output_9
    (ge_output_9)
    //do Output.create(30,51,51,51,62,48,48,24,14); // 9

    @30
    D=A
    @fontRow1
    M=D

    @51
    D=A
    @fontRow2
    M=D

    @51
    D=A
    @fontRow3
    M=D

    @51
    D=A
    @fontRow4
    M=D

    @62
    D=A
    @fontRow5
    M=D

    @48
    D=A
    @fontRow6
    M=D

    @48
    D=A
    @fontRow7
    M=D

    @25
    D=A
    @fontRow8
    M=D

    @14
    D=A
    @fontRow9
    M=D
    @ge_continue_output
    0;JMP
    // end ge_output_9


    //ge_output_s
    (ge_output_s)
    //do Output.create(0,0,0,0,0,0,0,0,0); // space

    @0
    D=A
    @fontRow1
    M=D

    @0
    D=A
    @fontRow2
    M=D

    @0
    D=A
    @fontRow3
    M=D

    @0
    D=A
    @fontRow4
    M=D

    @0 // temporarily change to 255 so you can see it
    D=A
    @fontRow5
    M=D

    @0
    D=A
    @fontRow6
    M=D

    @0
    D=A
    @fontRow7
    M=D

    @0
    D=A
    @fontRow8
    M=D

    @0
    D=A
    @fontRow9
    M=D
    @ge_continue_output
    0;JMP
    // end ge_output_s



    //ge_output_-
    (ge_output_-)
    //do Output.create(0,0,0,0,0,63,0,0,0);         // -

    @0
    D=A
    @fontRow1
    M=D

    @0
    D=A
    @fontRow2
    M=D

    @0
    D=A
    @fontRow3
    M=D

    @0
    D=A
    @fontRow4
    M=D

    @0
    D=A
    @fontRow5
    M=D

    @63 // use 16128 to have minus to the right of the word
    D=A
    @fontRow6
    M=D

    @0
    D=A
    @fontRow7
    M=D

    @0
    D=A
    @fontRow8
    M=D

    @0
    D=A
    @fontRow9
    M=D
    @ge_continue_output
    0;JMP
    // end ge_output_-


    //ge_output_g
    (ge_output_g)
    //do Output.create(0,0,3,6,12,24,12,6,3);       // >

    @0
    D=A
    @fontRow1
    M=D

    @0
    D=A
    @fontRow2
    M=D

    @3
    D=A
    @fontRow3
    M=D

    @6
    D=A
    @fontRow4
    M=D

    @12
    D=A
    @fontRow5
    M=D

    @24
    D=A
    @fontRow6
    M=D

    @12
    D=A
    @fontRow7
    M=D

    @6
    D=A
    @fontRow8
    M=D

    @3
    D=A
    @fontRow9
    M=D
    @ge_continue_output
    0;JMP
    // end ge_output_g


    //ge_output_+
    (ge_output_+)
    //do Output.create(0,0,0,12,12,63,12,12,0);     // +

    @0
    D=A
    @fontRow1
    M=D

    @0
    D=A
    @fontRow2
    M=D

    @0
    D=A
    @fontRow3
    M=D

    @12
    D=A
    @fontRow4
    M=D

    @12
    D=A
    @fontRow5
    M=D

    @63
    D=A
    @fontRow6
    M=D

    @12
    D=A
    @fontRow7
    M=D

    @12
    D=A
    @fontRow8
    M=D

    @0
    D=A
    @fontRow9
    M=D
    @ge_continue_output
    0;JMP
    // end ge_output_+