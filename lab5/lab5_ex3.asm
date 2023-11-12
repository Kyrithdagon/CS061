;=================================================
; Name: Sharon Lee
; Email: slee900@ucr.edu
; 
; Lab: lab 5, ex 3
; Lab section: 021
; TA: Westin Montano, Nick Santini
; 
;=================================================
.orig x3000
; Initialize the stack. Don't worry about what that means for now.
ld r6, top_stack_addr ; DO NOT MODIFY, AND DON'T USE R6, OTHER THAN FOR BACKUP/RESTORE

; your code goes here
lea r0, prompt ; initializer
puts

ld r1, access_array ; prep

ld r2, sub_get_string_3200 ; obtain string
jsrr r2

ld r2, sub_is_palindrome_3400 ; check if string is a palindrome
jsrr r2

ld r0, newline ; start/print newline
    out
lea r0, new_sentence ; begins the sentence
    puts
ld r0, access_array ;  prints out the present input
    puts

add r4, r4, #0 ; if 1 it will go to true, otherwise it keeps running down to false
BRp is_palin

not_palin
    lea r0, false_statement ; prints out the false statement
    puts
    br end_of_statement
    
is_palin
    lea r0, true_statement ; prints out the true statement
    puts
end_of_statement

halt

; your local data goes here
sub_get_string_3200 .fill x3200
sub_is_palindrome_3400 .fill x3400
prompt .stringz "Input a string. To terminate, press ENTER: "
newline .fill x0A
new_sentence .STRINGZ "The string \""
true_statement .STRINGZ "\" IS a palindrome"
false_statement .STRINGZ "\" IS NOT a palindrome"
access_array .fill x4000

top_stack_addr .fill xFE00 ; DO NOT MODIFY THIS LINE OF CODE

.end

; your subroutines go below here
;------------------------------------------------------------------------
; Subroutine: SUB_GET_STRING_3200
; Parameter (R1): The starting address of the character array
; Postcondition: The subroutine has prompted the user to input a string,
;	terminated by the [ENTER] key (the "sentinel"), and has stored 
;	the received characters in an array of characters starting at (R1).
;	the array is NULL-terminated; the sentinel character is NOT stored.
; Return Value (R5): The number of non-sentinel chars read from the user.
;	R1 contains the starting address of the array unchanged.
;-------------------------------------------------------------------------
.orig x3200

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

.end
;-------------------------------------------------------------------------
; Subroutine: SUB_IS_PALINDROME_3400
; Parameter (R1): The starting address of a null-terminated string
; Parameter (R5): The number of characters in the array.
; Postcondition: The subroutine has determined whether the string at (R1)
;		 is a palindrome or not, and returned a flag to that effect.
; Return Value: R4 {1 if the string is a palindrome, 0 otherwise}
;-------------------------------------------------------------------------
.orig x3400

add r6, r6, #-1 
str r7, r6, #0  ; r6 = xFE00 and is used as back up for other registers as needed
add r6, r6, #-1
str r1, r6, #0
add r6, r6, #-1
str r2, r6, #0
add r6, r6, #-1
str r3, r6, #0

ld r3, sub_to_upper_3600 ; call to the subroutine to change the string into uppercase
jsrr r3

and r2, r2, #0
add r2, r1, r5 ; load the address + the total count to access the end
add r2, r2, #-1 ; start to increment backwards/to compare with begining

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

ldr r3, r6, #0
add r6, r6, #1
ldr r2, r6, #0
add r6, r6, #1
ldr r1, r6, #0
add r6, r6, #1
ldr r7, r6, #0
add r6, r6, #1

ret

sub_to_upper_3600 .fill x3600

.end
;-------------------------------------------------------------------------
; Subroutine: SUB_TO_UPPER_3600
; Parameter (R1): Starting address of a null-terminated string
; Postcondition: The subroutine has converted the string to upper-case
;     in-place i.e. the upper-case string has replaced the original string
; No return value, no output, but R1 still contains the array address, unchanged
;-------------------------------------------------------------------------
.orig x3600

add r6, r6, #-1
str r7, r6, #0
add r6, r6, #-1
str r1, r6, #0
add r6, r6, #-1
str r5, r6, #0

ld r3, mask ; AND a bit mask that changes the 6th binary digit? to turn lowercase into upper

change_to_upper
    ldr r0, r1, #0 ; load value in r1 into r0
    and r0, r0, r3 ; uses the bit mask to AND/change a lowercase letter into uppercase (uppercase wont be affected)
    str r0, r1, #0 ; regardless of any changes, stores the different letter back into the r1 
    add r1, r1, #1 ; increment
    add r5, r5, #-1 ; de-count to end loop
    brp change_to_upper
end_change_to_upper

ldr r5, r6, #0
add r6, r6, #1
ldr r1, r6, #0
add r6, r6, #1
ldr r7, r6, #0
add r6, r6, #1

ret

mask .fill b11011111

.end
;==========================================================================
.orig x4000

array .blkw #100

.end