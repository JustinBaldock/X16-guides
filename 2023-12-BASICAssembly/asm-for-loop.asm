; Using Visual Studio Code (VCS)
; VSC extensions
; ca65 Macro Assembler Language Support 

; Requires cc65
; 

.org $080D

jmp main

; our strings to print to screen
MESSAGE_LOOP_SETUP: .asciiz "loop setup."
MESSAGE_LOOPING:    .asciiz "looping..."
MESSAGE_LOOP_END:   .asciiz "loop finished."

; include our code libraries
.include "kernal.inc"
.include "function-lib.asm"

main:

@loopStart:
    ldx #0 ; set loop counter to zero
    ; set which text message we want to print
    lda #<MESSAGE_LOOP_SETUP
    sta KERNAL_R4_L
    lda #>MESSAGE_LOOP_SETUP
    sta KERNAL_R4_H
    ; print to screen
    jsr printString
@looping:
    ; perform our loop code
    lda #<MESSAGE_LOOPING
    sta KERNAL_R4_L
    lda #>MESSAGE_LOOPING
    sta KERNAL_R4_H
    ; print to screen
    jsr printString

    inx ; increase counter
    cpx #$ff ; check if counter has reached 255
    bcc @looping
@loopEnd:
    ; loop has ended
    lda #<MESSAGE_LOOP_END
    sta KERNAL_R4_L
    lda #>MESSAGE_LOOP_END
    sta KERNAL_R4_H
    ; print to screen
    jsr printString
    rts