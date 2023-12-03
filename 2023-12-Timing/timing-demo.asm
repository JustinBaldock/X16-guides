; Using Visual Studio Code (VCS)
; VSC extensions
; ca65 Macro Assembler Language Support 

; Requires cc65
; 


.org $080D


.segment "STARTUP"
.segment "INIT"
.segment "ONCE"
.segment "CODE"


jmp start


.include "kernal.inc"
.include "variables.inc"
.include "petsciiCodes.inc"


; ----------
; start program
; ----------
start:
    jsr initVariables
    jmp main


; ----------
; initialize zero page variables for game
; ----------
; uses = A
; ----------
initVariables:
    ; re-start the clock
    jsr KERNAL_SETTIM
    ; set my variables to zero
    lda #0 ;
    sta GAME_TIMER ;
    ; return
    rts


; ----------
; main
; ----------
main:
    ; this is the main game loop
    ; 
@gameLoop:  
	; wait until 1/60 second has passed since last time
    jsr waitTimerInterrupt
    ; once it returns we do our logic

    ; print a message to screen
    jsr testMessage
    ; jump back to start of main loop
    jmp @gameLoop

@end:
    ; do some end game things
    rts


; ----------
; display test message
; ----------
testMessage:
@start:
    ; clear screen and set text to white
    ;lda #CLR
    ;jsr KERNAL_CHROUT
    lda #WHITE
    jsr KERNAL_CHROUT
    ; print text message
@loopStart:
    ldx #0
@loopDisplayMessage:
    lda TEST_MESSAGE_1,x
    beq @loopEnd
    jsr KERNAL_CHROUT
    inx
    bra @loopDisplayMessage
@loopEnd:
    ; print out the game_timer has hex
    jsr printGameTimer
    lda #RETURN
    jsr KERNAL_CHROUT
    ldx #0
    rts


; ----------
; function - print game_timer as hex
; ----------
printGameTimer:
    lda GAME_TIMER
    lsr A ; left shift to get just the high four bits
    lsr A
    lsr A
    lsr A
    jsr @hexDigit ; process the first digit
    lda GAME_TIMER
    and #$0F ; extract the low four bits
    jsr @hexDigit ; process the second digit
    rts
@hexDigit:
    cmp #$0A ; is digit alphabetic?
    bcc @skip ; if 0-9 then skip
    adc #$06 ; otherwise add seven 
@skip:
    adc #$30 ; convert to petscii
    jsr KERNAL_CHROUT ; print it out
    rts

; ----------
; function - wait for timer interrupt
; ----------
waitTimerInterrupt:
@start:
    jsr KERNAL_RDTIM ; Call kernal function to get time
    sta GAME_TIMER
@loop:
    jsr KERNAL_RDTIM
    cmp GAME_TIMER ; Compare current jiffy in Y to previous jiffy in GAME_TIMER
    beq @loop ; If not different then loop
@end:
    rts

