;----------------------
; Name: Sharon Lee
; Email: slee900@ucr.edu
;
; Lab: Lab 1, Ex 0
; Section: 021
; TA: Sanchit Goel, Westin Montano, Nick Santini
;----------------------

.ORIG x3000

LEA R0, MSG_TO_PRINT
PUTS
HALT

MSG_TO_PRINT .STRINGZ "Hello world!!!/n"

.END