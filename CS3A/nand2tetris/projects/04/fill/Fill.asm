// This file is part of www.nand2tetris.org
// and the book "The Elements of Computing Systems"
// by Nisan and Schocken, MIT Press.
// File name: projects/04/Fill.asm

// Runs an infinite loop that listens to the keyboard input.
// When a key is pressed (any key), the program blackens the screen,
// i.e. writes "black" in every pixel;
// the screen should remain fully black as long as the key is pressed. 
// When no key is pressed, the program clears the screen, i.e. writes
// "white" in every pixel;
// the screen should remain fully clear as long as no key is pressed.

// KEYBOARD > 0? FILL : CLEAR
(LOOP)
    @KBD // keyboard value.
    D=M

    @ON // If key > 0, Jump to ON.
    D;JGT

    @OFF // Else, Jump to OFF
    0;JMP

(ON) // FILL
    @R0 // RAM[0] = -1 (1111 1111 1111 1111)
    M=-1

    @DRAW // Jump to DRAW
    0;JMP

(OFF) // CLEAR
    @R0 // RAM[0] = 0
    M=0

    @DRAW // Jump to DRAW
    0;JMP


(DRAW)
    @8191 // count = 8192
    D=A
    @count
    M=D

    // Set Screen
    (SET)
        @count // Calculate position.
        D=M
        @position
        M=D
        @SCREEN
        D=A
        @position
        M=M+D

        @R0 // Draw value at current position.
        D=M
        @position
        A=M
        M=D

        @count // count = count - 1
        D=M-1
        M=D

        @SET // If count >= 0, Jump to SET
        D;JGE

    @LOOP // Infinite Loop
    0;JMP