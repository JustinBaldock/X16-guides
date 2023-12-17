; Starting to create a little library of helper functions
; 2023-12-18

printString:
; print string to screen
; register y is trashed
; uses kernal R4 = address of string to print
; uses kernal chrout 
@start:
    ldy #$00
@loop:
    lda (KERNAL_R4),y ; absolute indirect addressing using ()
    beq @loopEnd
    jsr KERNAL_CHROUT
    iny
    bne @loop
@loopEnd:
    rts
