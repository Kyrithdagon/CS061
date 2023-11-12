;=================================================
; Name: Sharon Lee
; Email: slee900@ucr.edu
; 
; Lab: lab 3, ex 3
; Lab section: 021
; TA: Westin Montano, Nick Santini
; 
;=================================================

.ORIG X3000

LEA R0, LABEL
PUTS 

LEA R1, ARRAY
LD R2, DEC_10

DO_WHILE_LOOP
    GETC
    STR R0, R1, #0
    ADD R1, R1, #1
    OUT
    ADD R2, R2, #-1
    BRp DO_WHILE_LOOP
END_DO_WHILE_LOOP

LEA R1, ARRAY
LD R2, DEC_10

DO_WHILE_LOOP_2
    LDR R0, R1, #0
    OUT
    LEA R0, NEWLINE
    PUTS
    ADD R1, R1, #1
    ADD R2, R2, #-1
    BRp DO_WHILE_LOOP_2
END_DO_WHILE_LOOP_2

HALT

LABEL .STRINGZ "Enter 10 characters: "
ARRAY .BLKW #10
DEC_10 .FILL #10
NEWLINE .FILL x0A

.END