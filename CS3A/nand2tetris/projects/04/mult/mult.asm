// This file is part of www.nand2tetris.org
// and the book "The Elements of Computing Systems"
// by Nisan and Schocken, MIT Press.
// File name: projects/04/Mult.asm

// Multiplies R0 and R1 and stores the result in R2.
// (R0, R1, R2 refer to RAM[0], RAM[1], and RAM[2], respectively.)

@R2 // R2 = 0
M=0

// If R0 > 0, Jump to LOOP
@R0
D=M
@LOOP
D;JGT

// else, Jump to END.
@END
0;JMP

// Adds R1 to R2 and removes 1 from R0. 
// If R0 is more than 0 we step again.
(LOOP)
    @R2 // R2 = RAM[2].
    D=M

    @R1
    D=D+M // R2 = R2 + R1

    @R2
    M=D // RAM[2] = R2

    @R0
    D=M-1 // R0 = RAM[0] - 1
    M=D

    // If R0 > 0 Jump to LOOP.
    @LOOP
    D;JGT

(END)
    @END
    0;JMP