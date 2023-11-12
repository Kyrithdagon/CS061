; Name & Email must be EXACTLY as in Gradescope roster!
; Name: Sharon Lee
; Email: slee900@ucr.edu
; 
; Assignment name: Assignment 5
; Lab section: 021
; TA: Westin Montano, Nick Santini
; 
; I hereby certify that I have not received assistance on this assignment,
; or used code, from ANY outside source other than the instruction team
; (apart from what was provided in the starter file).
;
;=================================================================================
; PUT ALL YOUR CODE AFTER THE main LABEL
;=================================================================================

;---------------------------------------------------------------------------------
;  Initialize program by setting stack pointer and calling main subroutine
;---------------------------------------------------------------------------------
.ORIG x3000

; initialize the stack
ld r6, stack_addr

; call main subroutine
lea r5, main
jsrr r5

;---------------------------------------------------------------------------------
; Main Subroutine
;---------------------------------------------------------------------------------
main
; get a string from the user
; * put your code here
lea r0, user_prompt
puts

ld r1, user_string

ld r2, get_user_string_addr ; obtain string
jsrr r2

; find size of input string
; * put your code here

; call palindrome method
; * put your code here
ld r2, palindrome_addr ; check if string is a palindrome
jsrr r2

; determine of stirng is a palindrome
; * put your code here
add r4, r4, #0 ; if 1 it will go to true, otherwise it keeps running down to false
BRp is_palin

not_palin
    lea r0, result_string ; prints out the false statement
    puts
    lea r0, not_string
    puts
    lea r0, final_string
    puts
    br end_of_statement
    
is_palin
    lea r0, result_string; prints out the true statement
    puts
    lea r0, final_string
    puts
end_of_statement

; print the result to the screen
; * put your code here

; decide whether or not to print "not"
; * put your code here


HALT

;---------------------------------------------------------------------------------
; Required labels/addresses
;---------------------------------------------------------------------------------

; Stack address ** DO NOT CHANGE **
stack_addr           .FILL    xFE00

; Addresses of subroutines, other than main
get_user_string_addr .FILL    x3200
strlen_addr          .FILL    x3300
palindrome_addr      .FILL	  x3400
newline .fill x0A

; Reserve memory for strings in the progrtam
user_prompt          .STRINGZ "Enter a string: "
result_string        .STRINGZ "The string is "
not_string           .STRINGZ "not "
final_string         .STRINGZ	"a palindrome\n"

; Reserve memory for user input string
;user_string          .BLKW	  100
user_string          .fill x4000

.END

;---------------------------------------------------------------------------------
; get_user_string: requests user to input a string
;
; parameter (R1): gets the starting address of character array
; postcondition: user is to input a string and the [ENTER] key terminates the program
;
; return value (R5): it will be the number/length of the string
;---------------------------------------------------------------------------------
.ORIG x3200
get_user_string
; Backup all used registers, R7 first, using proper stack discipline

add r6, r6, #-1
str r7, r6, #0 ; r7 backed up into r6
add r6, r6, #-1
str r1, r6, #0 ; r  is modified
add r6, r6, #-1
str r2, r6, #0

ld r2, enter
    not r2, r2 ; take complement
    add r2, r2, #1 ; turn 10 negative
    
and r5, r5, #0 ; counter

loop_till_enter
    getc
    out
    add r3, r0, r2 ; detects when 10 - 10 = 0 to end loop
    brz end_loop_till_enter
    str r0, r1, #0 ; otherwise store the input into address space
    add r1, r1, #1 ; move one forward
    add r5, r5, #1 ; count 1
    brnp loop_till_enter
end_loop_till_enter

ldr r2, r6, #0
add r6, r6, #1
ldr r1, r6, #0 ; restore r1
add r6, r6, #1
ldr r7, r6, #0 ; restore r7
add r6, r6, #1

ret

enter .fill #10

; Resture all used registers, R7 last, using proper stack discipline
.END

;---------------------------------------------------------------------------------
; strlen - did not use
;---------------------------------------------------------------------------------
.ORIG x3300
strlen
; Backup all used registers, R7 first, using proper stack discipline

; Resture all used registers, R7 last, using proper stack discipline
.END

;---------------------------------------------------------------------------------
; palindrome: checks is string is a palindrome
;
; parameter (R1): the beginning of the string
; parameter (R5): the number of characters in array
;
; return value: r4 (1 being palindrome, 0 being not)
;---------------------------------------------------------------------------------
.ORIG x3400
and r2, r2, #0
add r2, r1, r5 ; load the address + the total count to access the end
add r2, r2, #-1 ; start to increment backwards/to compare with begining

palindrome ; Hint, do not change this label and use for recursive calls
; Backup all used registers, R7 first, using proper stack discipline
add r6, r6, #-1 
str r7, r6, #0  
add r6, r6, #-1
str r1, r6, #0
add r6, r6, #-1
str r2, r6, #0
add r6, r6, #-1
str r3, r6, #0
add r6, r6, #-1
str r5, r6, #0

add r5, r5, #-1
brz base
jsr palindrome

check_if_palin
    ldr r0, r1, #0 ; load first" chara into r0 to make comparison easier
    ldr r3, r2, #0 ; load the last" chara into r3 to take complement and compare with r0
        not r3, r3
        add r3, r3, #1 ; take complement of the other end
    add r0, r0, r3 ; compare both together
    BRnp if_false ; goes to false when no zero is detected

    add r1, r1, #1    ; r1 counts forward
    add r2, r2, #-1   ; r2 counts backward
    add r5, r5, #-2   ; get rid of two counts since r1 + r2 = 2
    brp check_if_palin ; depends on r5 and coutinues until zero
end_check_if_palin

if_true
    and r4, r4, #0 ; ensure it's zero
    add r4, r4, #1 ; return 1
    br end_all_cases
if_false
    and r4, r4, #0 ; ensure and return zero
    br end_all_cases
end_all_cases
br restore 

base
AND R4, R4, #0
ADD R4, R4, #1

restore
ldr r5, r6, #0
add r6, r6, #1
ldr r3, r6, #0
add r6, r6, #1
ldr r2, r6, #0
add r6, r6, #1
ldr r1, r6, #0
add r6, r6, #1
ldr r7, r6, #0
add r6, r6, #1

ret

; Resture all used registers, R7 last, using proper stack discipline
.END

;========================================================================

.orig x4000

array .blkw #100

.end