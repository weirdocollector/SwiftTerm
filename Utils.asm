; String printing macro

defm    PRINT_STRING     ; Macro starts with 'defm' and ends with 'endm'

        ldx #$00
@next   lda /1,x        ; /1 refers to the first macro parameter
        beq @end        ; which is the string address
        jsr chrout      
        inx
        jmp @next      ; The '@' is used to be sure that each 
@end                   ; copy of the macro will have different labels
endm
        
