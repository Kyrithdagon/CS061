;=================================================
; Name: Sharon Lee
; Email: slee900@ucr.edu
; 
; Lab: lab 6, ex 3
; Lab section: 021
; TA: Westin Montano, Nick Santini
; 
;=================================================
.ORIG x3000

LD R6, BACKUP

LD R3, STACK_BASE
LD R4, STACK_MAX
LD R5, STACK_TOS

;======================================
;GET NUMBERS AND STORE IN STACK
LEA R0, PROMPT
PUTS

GETC
OUT
ADD R0, R0, #-16
ADD R0, R0, #-16
ADD R0, R0, #-16
ADD R1, R0, #0

LD R2, SUB_STACK_PUSH_3200 ; CALL FOR 1ST INTEGER
JSRR R2

LD R0, NEWLINE
OUT

LEA R0, PROMPT2
PUTS

GETC
OUT

ADD R0, R0, #-16
ADD R0, R0, #-16
ADD R0, R0, #-16
ADD R1, R0, #0

LD R2, SUB_STACK_PUSH_3200 ; CALLS FOR 2ND INTEGER
JSRR R2

LD R0, NEWLINE
OUT
;======================================
;GET OPERAND
LEA R0, GET_OPERAND
PUTS

LD R0, NEWLINE
OUT
;======================================
;ADD THE TOP TWO NUMBERS OF A STACKS
LD R1, SUB_RPN_ADDITION_3600
JSRR R1

HALT

BACKUP .FILL xFE00
PROMPT .STRINGZ "Type a single digit numeric character: "
PROMPT2 .STRINGZ "Type another single digit numeric character: "
GET_OPERAND .STRINGZ "Type of operand: + "
STACK_BASE .FILL xA000
STACK_MAX .FILL xA005
STACK_TOS .FILL xA000
SUB_STACK_PUSH_3200 .FILL x3200
SUB_STACK_POP_3400 .FILL x3400
SUB_RPN_ADDITION_3600 .FILL x3600
NEWLINE .FILL x0A
PLUS .FILL #-43

.END
;------------------------------------------------------------------------------------------
; Subroutine: SUB_STACK_PUSH_3200
; Parameter (R1): The value to push onto the stack
; Parameter (R3): BASE: A pointer to the base (one less than the lowest available address) of the stack
; Parameter (R4): MAX: The "highest" available address in the stack
; Parameter (R5): TOS (Top of Stack): A pointer to the current top of the stack
; Postcondition: The subroutine has pushed (R1) onto the stack (i.e to address TOS+1). 
;		    If the stack was already full (TOS = MAX), the subroutine has printed an
;		    overflow error message and terminated.
; Return Value: R5 ← updated TOS
;------------------------------------------------------------------------------------------
.ORIG x3200

ADD R6, R6, #-1
STR R7, R6, #0 ; BACK UP R7
ADD R6, R6, #-1
STR R1, R6, #0
ADD R6, R6, #-1
STR R2, R6, #0
ADD R6, R6, #-1
STR R3, R6, #0

LD R2, ENTER
    NOT R2, R2
    ADD R2, R2, #1
    
; LD R7, ASCII_TO_DEC

PUSH_INTO_STACK
    ; ADD R1, R0, #0
    ; ADD R1, R1, R7 ; TURN ASCII VALUE INTO A NUMBER
    
    ADD R3, R0, R2 ; EXITS WHEN 10 "ENTER" IS TYPED IN
    BRz END_OVERFLOW_DETECTED
    
    AND R3, R3, #0
    ADD R3, R4, #0
        NOT R3, R3
        ADD R3, R3, #1
    ADD R3, R5, R3
    BRzp OVERFLOW_DETECTED
    
    STR R1, R5, #1 ; STORE INPUT RECEIVED FROM R0 INTO R5
    ADD R5, R5, #1 ; OTHERWISE INCREMENT THE ADDRESS VALUE OF R5 BY 1
    BR END_OVERFLOW_DETECTED
END_PUSH_INTO_STACK

OVERFLOW_DETECTED
    LEA R0, NEWLINE1
    PUTS
    LEA R0, OVERFLOW_ERROR
    PUTS
END_OVERFLOW_DETECTED

LDR R3, R6, #0
ADD R6, R6, #1
LDR R2, R6, #0
ADD R6, R6, #1
LDR R1, R6, #0
ADD R6, R6, #1
LDR R7, R6, #0
ADD R6, R6, #1

RET

OVERFLOW_ERROR .STRINGZ "Overflow has occured."
ENTER .FILL #10
NEWLINE1 .FILL x0A
; ASCII_TO_DEC .FILL #-48

.END
;------------------------------------------------------------------------------------------
; Subroutine: SUB_STACK_POP
; Parameter (R3): BASE: A pointer to the base (one less than the lowest available address) of the stack
; Parameter (R4): MAX: The "highest" available address in the stack
; Parameter (R5): TOS (Top of Stack): A pointer to the current top of the stack
; Postcondition: The subroutine has popped MEM[TOS] off of the stack and copied it to R0.
;		    If the stack was already empty (TOS = BASE), the subroutine has printed
;                an underflow error message and terminated.
; Return Values: R0 ← value popped off the stack
;		   R5 ← updated TOS
;------------------------------------------------------------------------------------------
.ORIG x3400

ADD R6, R6, #-1
STR R7, R6, #0 ; BACK UP R7
ADD R6, R6, #-1
STR R2, R6, #0

POP_OFF_STACK
    AND R2, R2, #0 ; REINITIALIZE
    ADD R2, R3, #0 ; PUT R3 INTO R2 TO MANIPULATE
        NOT R2, R2
        ADD R2, R2, #1 ; TAKE COMPLEMENT OF BASE HEIGHT
    ADD R2, R5, R2
    BRnz UNDERFLOW_DETECTED ; IF EQUAL ZERO OR NEG, UNDERFLOW OCCURS
    
    LDR R0, R5, #0 ; "REMOVE" INPUT RECEIVED FROM R5 INTO R0
    ADD R5, R5, #-1 ; OTHERWISE DECREMENT THE ADDRESS VALUE OF R5 BY -1
    BR END_UNDERFLOW_DETECTED
END_POP_OFF_STACK

UNDERFLOW_DETECTED
    LEA R0, UNDERFLOW_ERROR
    PUTS
END_UNDERFLOW_DETECTED

LDR R2, R6, #0
ADD R6, R6, #1
LDR R7, R6, #0
ADD R6, R6, #1

RET

UNDERFLOW_ERROR .STRINGZ "Underflow has occured."

.END
;------------------------------------------------------------------------------------------
; Subroutine: SUB_RPN_ADDITION_3600
; Parameter (R3): BASE: A pointer to the base (one less than the lowest available address) of the stack
; Parameter (R4): MAX: The "highest" available address in the stack
; Parameter (R5): TOS (Top of Stack): A pointer to the current top of the stack
; Postcondition: The subroutine has popped off the top two values of the stack,
;		    added them together, and pushed the resulting value back
;		    onto the stack.
; Return Value: R5 ← updated TOS address
;------------------------------------------------------------------------------------------
.ORIG x3600

ADD R6, R6, #-1
STR R7, R6, #0 
ADD R6, R6, #-1
STR R1, R6, #0
ADD R6, R6, #-1
STR R2, R6, #0
ADD R6, R6, #-1
STR R3, R6, #0

LD R3, POP_1
JSRR R3

ADD R1, R0, #0 ; PUT VALUE OF R0 INTO R2

LD R3, POP_2
JSRR R3

ADD R1, R0, R1

LD R3, PUSH
JSRR R3

LD R3, POP_3
JSRR R3

LD R3, SUB_PRINT_DIGIT_3800
JSRR R3

LDR R3, R6, #0
ADD R6, R6, #1
LDR R2, R6, #0
ADD R6, R6, #1
LDR R1, R6, #0
ADD R6, R6, #1
LDR R7, R6, #0
ADD R6, R6, #1

RET

POP_1 .FILL x3400
POP_2 .FILL x3400
POP_3 .FILL x3400
PUSH .FILL x3200
SUB_PRINT_DIGIT_3800 .FILL x3800

.END
;=========================================
; ;SUB_PRINT_DIGIT
.ORIG x3800

ADD R6, R6, #-1
STR R7, R6, #0 
ADD R6, R6, #-1
STR R3, R6, #0
ADD R6, R6, #-1
STR R2, R6, #0

; LD R3, POP_RESULT
; JSRR R3

LD R2, DEC_TO_ASCII

ADD R0, R0, R2
OUT

LDR R2, R6, #0
ADD R6, R6, #1
LDR R3, R6, #0
ADD R6, R6, #1
LDR R7, R6, #0
ADD R6, R6, #1

RET

; POP_RESULT .FILL x3400
DEC_TO_ASCII .FILL #48

.END
