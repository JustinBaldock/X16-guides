; Using Visual Studio Code (VCS)
; VSC extensions
; ca65 Macro Assembler Language Support 

; Requires cc65
; 

.org $080D

; our strings to print to screen
MESSAGE_LOOP_SETUP: .asciiz "loop setup."
MESSAGE_LOOPING     .asciiz "looping..."
MESSAGE_LOOP_END    .asciiz "loop finished."



main:

@loopStart:
ldx #0 ; set loop counter to zero
@looping
inx ; increase counter
