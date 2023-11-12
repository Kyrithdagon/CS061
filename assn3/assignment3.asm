
.ORIG x3000			; Program begins here
;-------------
;Instructions
;-------------
LD R6, VALUE_PTR		; R6 <-- pointer to value to be displayed as binary
LDR R1, R6, #0			; R1 <-- value to be displayed as binary 

;-------------------------------
;INSERT CODE STARTING FROM HERE
;--------------------------------
LD R2, COUNTFOUR
LD R3, SIXTEENBIT
    
PRINT_LOOP
    ADD R2, R2, #0
    BRp CONDITIONAL_NUM
    LEA R0, MAKE_SPACE
    PUTS
    LD R2, COUNTFOUR
    ADD R3, R3, #0
    BR BOTTOM

    CONDITIONAL_NUM
        ADD R1, R1, #0
        BRp POSITIVE
        BRn NEGATIVE
    END_CONDITIONAL_NUM    
        
    POSITIVE
        LEA R0, ZERO
        PUTS
        BR SKIP_TO_LOWER
    END_POSITIVE
        
    NEGATIVE
        LEA R0, ONE
        PUTS
        BR SKIP_TO_LOWER
    END_NEGATIVE

    SKIP_TO_LOWER
        ADD R1, R1, R1
        ADD R2, R2, #-1
        ADD R3, R3, #-1
        BR BOTTOM
    END_SKIP_TO_LOWER
    
    BOTTOM
    BRp PRINT_LOOP
    END_BOTTOM

END_PRINT_LOOP

LD R0, NEWLINE
OUT

HALT
;---------------	
;Data
;---------------
VALUE_PTR	.FILL xCA01	    ; The address where value to be displayed is stored
COUNTFOUR .FILL #4
SIXTEENBIT .FILL #16
ZERO .STRINGZ "0"
ONE .STRINGZ "1"
MAKE_SPACE .STRINGZ " "
NEWLINE .FILL x0A

.END
;====================================================
.ORIG xCA01	                ; Remote data

VALUE .FILL xABCD			; <----!!!NUMBER TO BE DISPLAYED AS BINARY!!! Note: label is redundant.
;---------------	
;END of PROGRAM
;---------------	
.END
