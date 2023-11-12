;=================================================================================
;THE BINARY REPRESENTATION OF THE USER-ENTERED DECIMAL NUMBER MUST BE STORED IN R4
;=================================================================================

.ORIG x3000		
;-------------
;Instructions
;-------------
BR INTRO
ERROR
    LD R0, NEWLINE
    OUT
    LD R0, errorMessagePtr ; AUTOMATICALLY RESTARTS WHEN NEEDED
	PUTS
	
; output intro prompt
INTRO
    LD R0, introPromptPtr
    PUTS
    
; Set up flags, counters, accumulators as needed
    AND R0, R0, #0
    AND R1, R1, #0
    AND R2, R2, #0
    AND R3, R3, #0
    ADD R4, R4, #0
    AND R5, R5, #0
    AND R6, R6, #0
    LD R7, DEC_5
    
; Get first character, test for '\n', '+', '-', digit/non-digit 	
	GETC
	
	LD R6, DEC_9
	ADD R5, R0, #0
	ADD R6, R6, #12
	ADD R6, R6, #12
	ADD R6, R6, #12
	ADD R6, R6, #12
	    NOT R6, R6
	    ADD R6, R6, #1
	ADD R6, R5, R6
	BRp ERROR

	ADD R1, R0, #0
	
	ADD R1, R1, #-10
	BRz IS_NEWLINE ; IF ENTER SKIP TO NEWLINE
	
	AND R1, R1, #0
	ADD R1, R0, #0
	ADD R1, R1, #-16
	ADD R1, R1, #-16
	ADD R1, R1, #-11
	BRz IS_POSITIVE ; IF THERES STILL A POSITIVE NUM SKIP TO POSITIVE
	
	ADD R1, R1, #-2
	BRz IS_NEGATIVE ; IF THERES A NEGATIVE SIGN DETECTED SKIP TO NEGATIVE
	
	ADD R2, R0, #0
	BR CONTINUE
	
; is very first character = '\n'? if so, just quit (no message)!
    IS_NEWLINE
        BR END_OF_PROGRAM

; is it = '+'? if so, ignore it, go get digits
    IS_POSITIVE
        LEA R0, POSITIVE_SIGN
        PUTS
        
    POSITIVE_LOOP
        GETC
        OUT
        
        ; IF_SMALL_POS
        ;     ADD R5, R0, #0
	       ; ADD R6, R6, #12
    	   ; ADD R6, R6, #12
	       ; ADD R6, R6, #12
	       ; ADD R6, R6, #12
	       ;     NOT R6, R6
	       ;     ADD R6, R6, #1
    	   ; ADD R6, R5, R6
        ;     BRn ERROR
        ; END_IF_SMALL_POS
        ;==========================
        AND R1, R1, #0
        AND R2, R2, #0
        LD R1, CHECK_POS
            
        IF_POS
            ADD R2, R0, R1
            BRz ERROR
            
        AND R1, R1, #0
        AND R2, R2, #0
        LD R1, CHECK_NEG
            
        IF_NEG
            ADD R2, R0, R1
            BRz ERROR
        ;==========================
        IF_LARGE_POS
            LD R6, DEC_9
	        ADD R5, R0, #0
	        ADD R6, R6, #12
    	    ADD R6, R6, #12
	        ADD R6, R6, #12
	        ADD R6, R6, #12 ; ADD TILL 48
	            NOT R6, R6
	            ADD R6, R6, #1 ; TAKE COMPLEMENT OF 48
    	    ADD R6, R5, R6
    	    BRp ERROR
    	END_IF_LARGE_POS

        ADD R2, R0, #0
        ADD R2, R2, #-10
        BRz IS_NEWLINE

        LD R6, DEC_9
        ADD R0, R0, #-16
        ADD R0, R0, #-16
        ADD R0, R0, #-16
        ADD R5, R4, #0
        
        POS_INCREM
            ADD R4, R4, R5
            ADD R6, R6, #-1
            BRp POS_INCREM
            
        ADD R4, R4, R0
        ADD R7, R7, #-1
        BRp POSITIVE_LOOP
        
        BR END_OF_PROGRAM
        
; is it = '-'? if so, set neg flag, go get digits
    IS_NEGATIVE
        LEA R0, NEGATIVE_SIGN
        PUTS
    
    NEGATIVE_LOOP
        GETC
        OUT
        
        ; IF_SMALL_NEG
        ;     ADD R5, R0, #0
	       ; ADD R6, R6, #12
    	   ; ADD R6, R6, #12
	       ; ADD R6, R6, #12
	       ; ADD R6, R6, #12
	       ;     NOT R6, R6
	       ;     ADD R6, R6, #1
    	   ; ADD R6, R5, R6
        ;     BRn ERROR
        ; END_IF_SMALL_NEG
        ;==========================
        AND R1, R1, #0
        AND R2, R2, #0
        LD R1, CHECK_POS
            
        IF_POS_NEGATIVESECTION
            ADD R2, R0, R1
            BRz ERROR
            
        AND R1, R1, #0
        AND R2, R2, #0
        LD R1, CHECK_NEG
            
        IF_NEG_NEGATIVESECTION
            ADD R2, R0, R1
            BRz ERROR
        ;==========================
        IF_LARGE_NEG
            LD R6, DEC_9
	        ADD R5, R0, #0
	        ADD R6, R6, #12
    	    ADD R6, R6, #12
	        ADD R6, R6, #12
	        ADD R6, R6, #12
	            NOT R6, R6
	            ADD R6, R6, #1
    	    ADD R6, R5, R6
    	    BRp ERROR
        END_IF_LARGE_NEG
    	
        ADD R2, R0, #0
        ADD R2, R2, #-10
        BRz MAKE_NEGATIVE
        
        LD R6, DEC_9
        ADD R0, R0, #-16
        ADD R0, R0, #-16
        ADD R0, R0, #-16
        ADD R5, R4, #0
        
        NEG_INCREM
            ADD R4, R4, R5
            ADD R6, R6, #-1
            BRp NEG_INCREM
            
        ADD R4, R4, R0
        ADD R7, R7, #-1
        BRp NEGATIVE_LOOP
        
        MAKE_NEGATIVE
            NOT R4, R4
            ADD R4, R4, #1
        
        BR END_OF_PROGRAM

; is it < '0'? if so, it is not a digit	- o/p error message, start over
    ;IMPLEMENTED INTO POS AND NEG AND CONT
; is it > '9'? if so, it is not a digit	- o/p error message, start over
    ;IMPLEMENTED INTO POS AND NEG AND CONT
; if none of the above, first character is first numeric digit - convert it to number & store in target register!
    CONTINUE
        LEA R0, ZERO
        ADD R0, R2, #0
        OUT
        LD R6, DEC_9
        ADD R0, R0, #-16
        ADD R0, R0, #-16
        ADD R0, R0, #-16
        ADD R5, R4, #0
        
        CONT_INCREM
            ADD R4, R4, R5
            ADD R6, R6, #-1
            BRp CONT_INCREM
            
        ADD R4, R4, R0
        ADD R7, R7, #-1
        BRp CONTINUE_LOOP
    
    CONTINUE_LOOP
        GETC
        OUT
        
        ;==========================
        AND R1, R1, #0
        AND R2, R2, #0
        LD R1, CHECK_POS
            
        IF_POS_CONTSECT
            ADD R2, R0, R1
            BRz ERROR
            
        AND R1, R1, #0
        AND R2, R2, #0
        LD R1, CHECK_NEG
            
        IF_NEG_CONTSECT
            ADD R2, R0, R1
            BRz ERROR
        ;==========================

        
        LD R6, DEC_9
	    ADD R5, R0, #0
	    ADD R6, R6, #12
    	ADD R6, R6, #12
	    ADD R6, R6, #12
	    ADD R6, R6, #12
	        NOT R6, R6
	        ADD R6, R6, #1
    	ADD R6, R5, R6
    	BRp ERROR
        
        ADD R2, R0, #0
        ADD R2, R2, #-10
        BRz IS_NEWLINE
        
        LD R6, DEC_9
        ADD R0, R0, #-16
        ADD R0, R0, #-16
        ADD R0, R0, #-16
        ADD R5, R4, #0
        
        CON_INCREM
            ADD R4, R4, R5
            ADD R6, R6, #-1
            BRp CON_INCREM
            
        ADD R4, R4, R0
        ADD R7, R7, #-1
        BRp CONTINUE_LOOP
        
        BR END_OF_PROGRAM
        
; Now get remaining digits from user in a loop (max 5), testing each to see if it is a digit, and build up number in accumulator
    ;WILL BE IMPLEMENTED INTO THE POSITIVE OR NEGATIVE LOOPS CUZ IT'S EASIER

END_OF_PROGRAM
; remember to end with a newline!
	LD R0, NEWLINE
	OUT

HALT

;---------------	
; Program Data
;---------------
NEWLINE .FILL x0A
DEC_9 .FILL #9
DEC_5 .FILL #5
ZERO .FILL #0
POSITIVE_SIGN .STRINGZ "+"
NEGATIVE_SIGN .STRINGZ "-"
CHECK_POS .FILL #-43
CHECK_NEG .FILL #-45

introPromptPtr  .FILL xB000
errorMessagePtr .FILL xB200

.END

;------------
; Remote data
;------------
.ORIG xB000	 ; intro prompt
.STRINGZ	 "Input a positive or negative decimal number (max 5 digits), followed by ENTER\n"

.END					
					
.ORIG xB200	 ; error message
.STRINGZ	 "ERROR: invalid input\n"

;---------------
; END of PROGRAM
;---------------
.END

;-------------------
; PURPOSE of PROGRAM
;-------------------
; Convert a sequence of up to 5 user-entered ascii numeric digits into a 16-bit two's complement binary representation of the number.
; if the input sequence is less than 5 digits, it will be user-terminated with a newline (ENTER).
; Otherwise, the program will emit its own newline after 5 input digits.
; The program must end with a *single* newline, entered either by the user (< 5 digits), or by the program (5 digits)
; Input validation is performed on the individual characters as they are input, but not on the magnitude of the number.
