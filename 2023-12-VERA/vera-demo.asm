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
    ; setup vera for loading Sprite
    stz VERA_CTRL
    lda #%00010000 
    ;ora #<SPRITE_GRAPHICS
    sta VERA_ADDR_H ; set address increment to 1 byte and bank 0
    lda #<SPRITE_GRAPHICS
    sta VERA_ADDR_M
    lda #>SPRITE_GRAPHICS
    sta VERA_ADDR_L
    ; load sprite
    ; Prepare for data copy from RAM to VRAM
    lda #<data                          
    sta REGISTER_COPY
    lda #>data
    sta REGISTER_COPY+1
    ; start = copy 32 x 256 bytes to VRAM
    ldx #32
    ldy #0
@copyLoop:
    lda (REGISTER_COPY),y
    sta VERA_DATA0                      
    iny 
    bne @copyLoop
    inc REGISTER_COPY+1
    dex
    bne @copyLoop
    ; end = copy 32 x 256 bytes to VRAM

    ; turn Sprite on
    lda $9F29
    ora #%01000000
    sta $9F29
    ; Set vera address for update Sprite 1 definition
    lda #%00010001                            
    sta VERA_ADDR_H ; address increment 1, vram address bank 1
    lda #>SPRITE1
    sta VERA_ADDR_M
    lda #<SPRITE1
    sta VERA_ADDR_L
    ; Configure 8 bytes of Sprite definition
    ;lda #%01111101 
    stz VERA_DATA0 ; set source bits 12-5 to zero for $4000                     
    lda #%10000010 
    sta VERA_DATA0 ; set mode to 8 bpp, and source bits 16-13 for $4000
    stz VERA_DATA0 ; zero x
    stz VERA_DATA0 ; zero x
    stz VERA_DATA0 ; zero y
    stz VERA_DATA0 ; zero y
    lda #%00001100 
    sta VERA_DATA0 ; collisoin, z-depth, v/h flip
    lda #%10100000
    sta VERA_DATA0 ; sprite heigh=32, width=32, palette offset

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
    jsr bounceSprite

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


; ----------
; function - bounceSprite
; ----------  
bounceSprite:
    ; update x
    lda sprite1PosX
    clc
    adc sprite1DeltaX
    sta sprite1PosX
    lda sprite1PosX+1
    adc sprite1DeltaX+1
    sta sprite1PosX+1
    ; update y
    lda sprite1PosY
    clc
    adc sprite1DeltaY
    sta sprite1PosY
    lda sprite1PosY+1
    adc sprite1DeltaY+1
    sta sprite1PosY+1
    ; check right bounds
@checkRight:
    lda sprite1PosX+1
    cmp #$01
    bne @checkLeft
    lda sprite1PosX
    cmp #$1F
    bne @checkLeft
    ; hit the right edge, change delta x = -1
    lda #255
    sta sprite1DeltaX
    sta sprite1DeltaX+1
    jmp @checkBottom
@checkLeft:
    lda sprite1PosX+1
    bne @checkBottom
    lda sprite1PosX
    bne @checkBottom
    ; hit the left edge, change delta x <= +1
    lda #1
    sta sprite1DeltaX
    stz sprite1DeltaX+1
@checkBottom:
    lda sprite1PosY+1
    cmp #$00
    bne @checkTop
    lda sprite1PosY
    cmp #$cf
    bne @checkTop
    ; hit bottom edge, delta y <= -1
    lda #255
    sta sprite1DeltaY
    sta sprite1DeltaY+1
    jmp @updateSprite
@checkTop:
    lda sprite1PosY+1
    bne @updateSprite
    lda sprite1PosY
    bne @updateSprite
    ; hit top edge, delta y <= +1
    lda #1
    sta sprite1DeltaY
    stz sprite1DeltaY+1

@updateSprite:
    ; setup vera to update sprite1
    stz VERA_CTRL
    lda #$11
    sta VERA_ADDR_H
    lda #$FC
    sta VERA_ADDR_M
    lda #$0A
    sta VERA_ADDR_L ; want to edit 3rd byte of first sprite
    ; 
    lda sprite1PosX
    sta VERA_DATA0
    lda sprite1PosX+1
    sta VERA_DATA0
    lda sprite1PosY
    sta VERA_DATA0
    lda sprite1PosY+1
    sta VERA_DATA0
    ; sprites should be handled
    rts

