; Using Visual Studio Code (VCS)
; VSC extensions
; ca65 Macro Assembler Language Support 

; Requires cc65
; 


.org $080D

; specific VRAM Locations
SPRITE_GRAPHICS = $4000
SPRITE1         = $FC08

.segment "STARTUP"
.segment "INIT"
.segment "ONCE"
.segment "CODE"


jmp start


.include "kernal.inc"
.include "variables.inc"
.include "petsciiCodes.inc"
.include "vera.inc"


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
    ; set start background color to 0
    lda #0
    sta GAME_BACKGROUND
    ; re-start the clock
    jsr KERNAL_SETTIM
    ; setup our timing
    jsr KERNAL_RDTIM ; Call kernal function to get time
    sta GAME_TIMER ; store in our variable
    ; clear screen and set text to white
    lda #CTRL_CLR
    jsr KERNAL_CHROUT
    lda #COLOUR_WHITE
    jsr KERNAL_CHROUT
    ; load sprite
    ; Define Sprite
    stz VERA_CTRL
    lda #$10
    sta VERA_ADDRx_H
    lda #$40
    sta VERA_ADDRx_M
    stz VERA_ADDRx_L 
    ldy #0
readSprite:
    lda data,Y
    sta VERA_DATA0
    iny 
    bne readSprite
    ; Initiate Sprite
    lda $9F29
    ora #%01000000
    sta $9F29

    lda #$11
    sta VERA_ADDRx_H
    lda #$FC
    sta VERA_ADDRx_M
    stz VERA_ADDRx_L

    stz VERA_DATA0
    lda #$82
    sta VERA_DATA0
    stz VERA_DATA0
    stz VERA_DATA0
    stz VERA_DATA0
    stz VERA_DATA0
    lda #%00001100
    sta VERA_DATA0
    lda #%01010000
    sta VERA_DATA0

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

    ; move sprite

    ; jump back to start of main loop
    jmp @gameLoop

@end:
    ; do some end game things
    ; exit the game
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


; ----------
; function - setupVera
; ----------
; simple test function
setupVera:
    ; turn on sprites
    lda VERA_DC_VIDEO ; get the current video settings
    ora #MASK_VERA_SPRITE ; mask the value
    sta VERA_DC_VIDEO ; set vera with sprite on
    ; set our layer, 
    stz VERA_CTRL