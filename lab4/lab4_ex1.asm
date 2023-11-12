
.ORIG x3000

AND R0, R0, #0

LD R1, SUB_FILL_ARRAY_3200
LD R2, DEC_9 ; COUNTER
JSRR R1

HALT

SUB_FILL_ARRAY_3200 .FILL x3200
DEC_9 .FILL #9

.END
;------------------------------------------------------------------------
; Subroutine: SUB_FILL_ARRAY
; Parameter (R1): The starting address of the array. This should be unchanged at the end of the subroutine!
; Postcondition: The array has values from 0 through 9.
; Return Value (None)
;-------------------------------------------------------------------------
.ORIG x3200

LD R1, ARRAY

FILL_ARRAY_LOOP
    ADD R0, R0, #1
    ADD R1, R1, #1
    STR R0, R1, #0
    ADD R2, R2, #-1
    BRp FILL_ARRAY_LOOP
END_FILL_ARRAY_LOOP

RET

ARRAY .FILL x4000

.END

;===============================================

.ORIG x4000

ARRAY_RESERVE .BLKW #10

.END
