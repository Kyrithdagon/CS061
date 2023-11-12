;=================================================
; Name: Sharon Lee
; Email: slee900@ucr.edu
; 
; Lab: lab 4, ex 4
; Lab section: 021
; TA: Westin Montano, Nick Santini
; 
;=================================================

.ORIG x3000

AND R0, R0, #0

LD R1, SUB_FILL_ARRAY_3200
LD R2, DEC_9 ; COUNTER
JSRR R1

LD R1, SUB_CONVERT_ARRAY_3400
LD R2, DEC_9 ; COUNTER
    ADD R2, R2, #1
LD R3, DEC_48 ; ASCII 0
JSRR R1

LD R1, SUB_PRINT_ARRAY_3600
LD R2, DEC_9 ; COUNTER
    ADD R2, R2, #1
JSRR R1

LD R1, SUB_PRETTY_PRINT_ARRAY_3800
JSRR R1

HALT

SUB_FILL_ARRAY_3200 .FILL x3200
SUB_CONVERT_ARRAY_3400 .FILL x3400
SUB_PRINT_ARRAY_3600 .FILL x3600
SUB_PRETTY_PRINT_ARRAY_3800 .FILL x3800
DEC_9 .FILL #9
DEC_48 .FILL #48

.END
;------------------------------------------------------------------------
; Subroutine: SUB_FILL_ARRAY
; Parameter (R1): The starting address of the array. This should be unchanged at the end of the subroutine!
; Postcondition: The array has values from 0 through 9.
; Return Value (None)
;-------------------------------------------------------------------------
.ORIG x3200

LD R1, ARRAY_3200

FILL_ARRAY_LOOP
    ADD R0, R0, #1
    ADD R1, R1, #1
    STR R0, R1, #0
    ADD R2, R2, #-1
    BRp FILL_ARRAY_LOOP
END_FILL_ARRAY_LOOP

RET

ARRAY_3200 .FILL x4000

.END
;------------------------------------------------------------------------
; Subroutine: SUB_CONVERT_ARRAY
; Parameter (R1): The starting address of the array. This should be unchanged at the end of the subroutine!
; Postcondition: Each element (number) in the array should be represented as a character. E.g. 0 -> ‘0’
; Return Value (None)
;-------------------------------------------------------------------------
.ORIG x3400

LD R1, ARRAY_3400

CONVERT_ARRAY_LOOP
    LDR R0, R1, #0
    ADD R0, R0, R3
    STR R0, R1, #0
    ADD R1, R1, #1
    ADD R2, R2, #-1
    BRp CONVERT_ARRAY_LOOP
END_CONVERT_ARRAY_LOOP

RET

ARRAY_3400 .FILL x4000

.END
;------------------------------------------------------------------------
; Subroutine: SUB_PRINT_ARRAY
; Parameter (R1): The starting address of the array. This should be unchanged at the end of the subroutine!
; Postcondition: Each element (character) in the array is printed out to the console.
; Return Value (None)
;-------------------------------------------------------------------------
.ORIG x3600 

LD R1, ARRAY_3600

PRINT_ARRAY_LOOP
    LDR R0, R1, #0
    OUT
    ADD R1, R1, #1
    ADD R2, R2, #-1
    BRp PRINT_ARRAY_LOOP
END_PRINT_ARRAY_LOOP

RET

ARRAY_3600 .FILL x4000

.END
;------------------------------------------------------------------------
; Subroutine: SUB_PRETTY_PRINT_ARRAY
; Parameter (R1): The starting address of the array. This should be unchanged at the end of the subroutine!
; Postcondition: Prints out “=====” (5 equal signs), prints out the array, and after prints out “=====” again.
; Return Value (None)
;-------------------------------------------------------------------------
.ORIG x3800
; ST R7, BACKUP_R7
LD R1, ARRAY_3800

LEA R0, EQUALS
PUTS

LD R3, ARRAY1_3600
LD R2, DEC1_9
    ADD R2, R2, #1
JSRR R3

; LD R7, BACKUP_R7
LEA R0, EQUALS
PUTS

RET

ARRAY_3800 .FILL x4000
EQUALS .STRINGZ "====="
DEC1_9 .FILL #9
ARRAY1_3600 .FILL x3600
; BACKUP_R7 .BLKW #1

.END

;============================================

.ORIG x4000

ARRAY_RESERVE .BLKW #10

.END