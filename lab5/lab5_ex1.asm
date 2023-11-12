
.orig x3000
; Initialize the stack. Don't worry about what that means for now.
ld r6, top_stack_addr ; DO NOT MODIFY, AND DON'T USE R6, OTHER THAN FOR BACKUP/RESTORE

; your code goes here
ld r1, access_array

lea r0, prompt
puts

and r5, r5, #0

ld r5, sub_get_string_3200
jsrr r5

halt

; your local data goes here
sub_get_string_3200 .fill x3200
access_array .fill x4000
prompt .stringz "Input a string. To terminate, press ENTER: "

top_stack_addr .fill xFE00 ; DO NOT MODIFY THIS LINE OF CODE

.end

; your subroutines go below here
;------------------------------------------------------------------------
; Subroutine: SUB_GET_STRING
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
    str r0, r1, #0 ; otherwise store input from r0 to r1
    add r1, r1, #1 ; increment by 1
    add r5, r5, #1 ; count
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
;===============================================================
.orig x4000

array .blkw #100

.end
