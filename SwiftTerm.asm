
* = $c000 ; Program starts at 49152

; Kernel Routines

chrout = $ffd2 ; Kernel routine - Prints a char in A
getin  = $ffe4 ; Kernel routine - Reads a char from keyboard and puts it in A

; Include Libraries

incasm "Utils.asm"

; Constants

SL_Base = $DE00           ; Swiftlink Base Register address
SL_Status = SL_Base +1    ; Swiftlink Status Register address
SL_Command = SL_Base + 2  ; Swiftlink Commmand Register address
SL_Control = SL_Base + 3  ; Swiftlink Control Register address 

; Program starts here

init
        PRINT_STRING start    ; Use Macro in "Utils.asm" to print a string

        lda #$0B              ; No Interrupts, No Parity
        sta SL_Command

        lda #$1F              ; 38400 baud, 1 stop bit, data lenght 8, baud rate generator
        sta SL_Control          


receive
        lda SL_Status   ; put Swiftlink Status register in A
        and #%00001000  ; look at 3rd bit in SL_Status (A)
        beq readKey     ; go to key reading if 3rd bit is clear 
        lda SL_Base     ; if 3rd bit is set put SL_Base into A
        jsr chrout      ; show key on the screen
        
readKey
        lda #$ff        ; reset A content(Z=1)
        jsr getin       ; read key
        beq receive     ; if no key pressed go back to receiving
        cmp #$03        ; check for STOP key
        beq exit        ; exit if pressed
        pha             ; save char (A) to stack

transmit
        lda SL_Status   ; put Swiftlink Status register in A
        and #%00010000  ; look at 4th bit in SL_Status (A)
        beq receive     ; go back to start if 4th bit is clear      
        pla             ; get back char (A) from stack
        sta SL_Base     ; trasmit char

        jmp receive     ; back to start

exit
        rts             ; back to BASIC

; Strings

start   text "starting..."
        byte 13, 00

; Watch Swiftlink Register in Debugger

watch SL_Base
watch SL_Command
watch SL_Control
watch SL_Status
