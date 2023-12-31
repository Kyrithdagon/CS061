
;------------------------------------------
;           BUILD TABLE HERE
;------------------------------------------
; REG VALUES       R0 R1 R2 R3 R4 R5 R6 R7
;------------------------------------------
; Pre-Loop         0  6  12 0  0  0  0  0
; Iteration 01     0  5  12 12 0  0  0  0
; Iteration 02     0  4  12 24 0  0  0  0
; Iteration 03     0  3  12 36 0  0  0  0
; Iteration 04     0  2  12 48 0  0  0  0
; Iteration 05     0  1  12 60 0  0  0  0
; Iteration 06     0  0  12 72 0  0  0  0
; End of program   0  x3007  12 72 0  0  0  0
;------------------------------------------


.ORIG x3000			; Program begins here
;-------------
;Instructions: CODE GOES HERE
;-------------

LD R1, DEC_6
LD R2, DEC_12
AND R3, R3, #0

DO_WHILE
    ADD R3, R3, R2
    ADD R1, R1, #-1
    BRp DO_WHILE
END_DO_WHILE

HALT
;---------------	
;Data (.FILL, .STRINGZ, .BLKW)
;---------------

DEC_6 .FILL #6
DEC_12 .FILL #12

;---------------	
;END of PROGRAM
;---------------	
.END

