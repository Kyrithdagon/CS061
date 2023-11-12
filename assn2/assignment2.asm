
.ORIG x3000			; Program begins here
;-------------
;Instructions
;-------------

;----------------------------------------------
;output prompt
;----------------------------------------------	
LEA R0, intro			; get starting address of prompt string
PUTS			    	; Invokes BIOS routine to output string

;-------------------------------
;INSERT YOUR CODE here
;--------------------------------

GETC
OUT

AND R1, R1, x0
ADD R1, R0, #0

LD R0, newline
OUT

GETC
OUT

AND R2, R2, x0
ADD R2, R0, #0

LD R0, newline
OUT

AND R0, R0, x0
ADD R0, R1, #0

OUT

LEA R0, noperative
PUTS

AND R0, R0, x0
ADD R0, R2, #0

OUT

LEA R0, equal
PUTS

ADD R1, R1, #-12
ADD R1, R1, #-12
ADD R1, R1, #-12
ADD R1, R1, #-12

ADD R2, R2, #-12
ADD R2, R2, #-12
ADD R2, R2, #-12
ADD R2, R2, #-12

AND R3, R3, x0
NOT R2, R2
ADD R2, R2, #1
ADD R3, R1, R2

BRzp PRINT

LEA R0, negative
PUTS
NOT R3, R3
ADD R3, R3, #1

PRINT

ADD R0, R3, x0
ADD R0, R0, #12
ADD R0, R0, #12
ADD R0, R0, #12
ADD R0, R0, #12
OUT

LD R0, newline
OUT

HALT				; Stop execution of program
;------	
;Data
;------
; String to prompt user. Note: already includes terminating newline!
intro 	.STRINGZ	"ENTER two numbers (i.e '0'....'9')\n" 		; prompt string - use with LEA, followed by PUTS.
newline .FILL x0A	; newline character - use with LD followed by OUT
noperative .STRINGZ " - "
equal .STRINGZ " = "
negative .STRINGZ "-"

;---------------	
;END of PROGRAM
;---------------	
.END

