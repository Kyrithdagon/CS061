
.orig x3000
; Initialize the stack. Don't worry about what that means for now.
ld r6, top_stack_addr ; DO NOT MODIFY, AND DON'T USE R6, OTHER THAN FOR BACKUP/RESTORE

; your code goes here
lea r0, prompt ; initializer
puts

and r5, r5, #0 ; for counting inputs
ld r1, access_array ; prep

ld r2, sub_get_string_3200 ; obtain string
jsrr r2

ld r2, sub_is_palindrome_3400 ; check if string is a palindrome
jsrr r2

ld r0, newline ; start/print newline
    out
lea r0, new_sentence ; begins the sentence
    puts
ld r0, access_array ; prints out the present input
    puts

add r4, r4, #0 ; if 1 it will go to true, otherwise it keeps running down
BRp is_palin

not_palin
    lea r0, false_statement ; print false
    puts
    br end_of_statement
    
is_palin
    lea r0, true_statement ; print true
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
    
and r5, r5, #0

loop_till_enter
    getc
    out
    add r3, r0, r2 ; detects when 10 - 10 = 0 to end loop
    brz end_loop_till_enter
    str r0, r1, #0 ; otherwise store input into address space
    add r1, r1, #1 ; move one forward
    add r5, r5, #1 ; count 1
    brnp loop_till_enter
end_loop_till_enter

ldr r2, r6, #0
add r6, r6, #1
ldr r1, r6, #0 ; restore r
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

and r2, r2, #0
add r2, r1, r5 ; load the address + the total count to access the end
add r2, r2, #-1 ; start to increment backwards/to compare with begining

check_if_palin
    ldr r0, r1, #0 ; load r1 into r0
    ldr r3, r2, #0 ; load r2 into r3
        not r3, r3
        add r3, r3, #1 ; take complement
    add r0, r0, r3 ; compare r0 with r3
    BRnp if_false ; goes to false when no zero is detected
    
    add r1, r1, #1    ; count forward
    add r2, r2, #-1   ; count backward
    add r5, r5, #-2   ; get rid of two counts since r1 + r2 = 2
    brp check_if_palin ; depends on r5 and coutinues till zero
end_check_if_palin

if_true
    and r4, r4, #0 ; ensure it's zero
    add r4, r4, #1 ; return 1
    br end_all_cases
if_false
    and r4, r4, #0 ; ensure and return zero 
    br end_all_cases
end_all_cases

ldr r2, r6, #0
add r6, r6, #1
ldr r1, r6, #0
add r6, r6, #1
ldr r7, r6, #0
add r6, r6, #1

ret

.end
;==========================================================================
.orig x4000

array .blkw #100

.end
