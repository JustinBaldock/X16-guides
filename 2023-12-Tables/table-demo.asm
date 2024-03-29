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


sine:   .byte 128,176,217,245,255,254,245,217,175,128,77,36,8,0,8,36,78
;screenX:.byte 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17


; ----------
; start program
; ----------
start:
    ; setup variables
    ldx #0
    stx SINE_POINT
    ; switch to graphic screen mode, set size to zero, which is full screen 
    ;stz KERNAL_R0_L
    ;stz KERNAL_R0_H
    ;stz KERNAL_R1_L
    ;stz KERNAL_R1_H
    ;stz KERNAL_R2_L
    ;stz KERNAL_R2_H
    ;stz KERNAL_R3_L
    ;stz KERNAL_R3_H
    ;jsr KERNEL_GRAPH_INIT
    ;jsr KERNAL_GRAPH_SET_WINDOW
    ;jsr KERNAL_GRAPH_CLEAR
    ; set the graphic pen color
    ;lda #3
    ;jsr KERNAL_GRAPH_SET_COLORS

    ; clear the screen
    lda #CTRL_CLR
    jsr KERNAL_CHROUT

    jmp main


; ----------
; main
; ----------
main:
    ; this is the main game loop
    ; 
@gameLoop:  
	; wait until 1/60 second has passed since last time
    jsr waitTimerInterrupt

    ; do our code
    jsr printSine

    ; jump back to start of main loop
    jmp @gameLoop

@end:
    ; do some end game things
    ; exit the game
    rts


; ----------
; function - lookup table sine wave
; ----------
printSine:
    ldy SINE_POINT ; get the current table pointer into y
    sty SCREEN_X ; set the current pointer value to be screen x
    ldx sine,y  ; get the current sine value from the lookup table
    txa ; move x to a
    lsr ; logical shift right
    lsr
    lsr
    sta SCREEN_Y
    
    ; draw a 'line' dot
    ;sty KERNAL_R0 ; x   
    ;sta KERNAL_R1 ; y
    ;sty KERNAL_R2 ; same x so its a dot
    ;sta KERNAL_R3 ; same y so its a dot
    ;jsr KERNAL_GRAPH_DRAW_LINE
    ldx SCREEN_Y
    ldy SCREEN_X
    jsr KERNAL_PLOT
    lda #CHAR_ZERO
    jsr KERNAL_CHROUT
    ; increase the pointer
    inc SINE_POINT
    lda SINE_POINT
    cmp #17
    bcc @pointerOk
    lda #0
    sta SINE_POINT
@pointerOk:

    rts




; ----------
; function - wait for timer interrupt
; ----------
; This function uses the variable GAME_TIMER
; The variable GAME_TIMER should be initialized during program start
; Using the function KERNAL_RDTIM and saving reg A into GAME_TIMER
waitTimerInterrupt:
@start:
    ; none
@loop:
    jsr KERNAL_RDTIM
    cmp GAME_TIMER ; Compare current jiffy in A to previous jiffy in GAME_TIMER
    beq @loop ; If not different then loop
@end:
    sta GAME_TIMER ; update our timing variable
    rts