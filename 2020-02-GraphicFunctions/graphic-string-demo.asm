; Graphic Function demo
;-----------------------------------------------------------------------------
; Assembly demo of graph_put_char using cc65 compiler tools and Visual Studio Code
; For use with r36 of the X16 emulator.
; by JustinBaldock 2020-02-01
; 

;-----------------------------------------------------------------------------
; assembler directives
.debuginfo on
.listbytes unlimited

;-----------------------------------------------------------------------------
.segment  "ZEROPAGE"
; here is where you put any zero page variables.
; These are all items located in the $0000-$00ff memory space
; On the X-16 Users c can use $0000-$007F. Kernal and Basic zero page is $0080-$00FF

pointerToString	    = $22
pointerToStringLow  = $22
pointerToStringHigh = $23

;-----------------------------------------------------------------------------
.segment "STARTUP" ; This segment contains the startup code which initializes the C software stack and the libraries
.include "kernal.inc"

;-----------------------------------------------------------------------------
.segment "ONCE"

;-----------------------------------------------------------------------------
.segment "INIT" ; The INIT segment is used for initialization code that may be reused once execution reaches main

;-----------------------------------------------------------------------------
.segment "DATA"
; here is where you put raw data / binary / sprites / text blobs / etc
; variables

; strings
textString1: .asciiz "this is string 1"
textString2: .asciiz "this is string 2"
textString3: .asciiz "this is string 3"

;-----------------------------------------------------------------------------
.segment "CODE"

jmp main

.proc main
    ; set the screen mode using a kernal function
    lda #SCREEN_MODE_320x200x256C
    jsr SCREEN_SET_MODE
    ; set the graphic window size
    ; set r0(start-x) and r1(start-y) to zero
    stz r0L ; STore Zero in to location
    stz r0H
    stz r1L
    stz r1H
    ; set r2 (width)
    lda #<319
    sta r2L
    lda #>319
    sta r2H
    ; set r3 (height)
    lda #<199
    sta r3L
    lda #>199
    sta r3H
    ; use the kernal function 
    jsr GRAPH_SET_WINDOW
    ; set the graphic colours 
    lda #COLOUR_RED
    ldx #COLOUR_PURPLE
    ldy #COLOUR_BLUE
    ; use the kernal function
	jsr GRAPH_SET_COLORS
@drawString1:
    ; set start x/y position of text
    lda #7 ; 8 pixels for both x and y, remember we count from 0, 0-7
    sta r0L ; STore Accumulator to location
    sta r1L
    stz r1H ; STore Zero in to location
    stz r2H
    ; point to the string
    lda #<textString1 ; get the low address byte from memory 
    sta pointerToStringLow ; 
    lda #>textString1 ; get the high address byte from memory
    sta pointerToStringHigh
    ; now call my function to display string
    jsr write_text
@drawString2:
    ; set x/y position of text
    lda #23
    sta r0L ; STore Accumulator to location
    sta r1L
    stz r1H ; STore Zero in to location
    stz r2H
    ; point to the string
    lda #<textString2
    sta pointerToStringLow
    lda #>textString2
    sta pointerToStringHigh
    ; now call my function to display string
    jsr write_text
@drawString3:
    ; set x/y position of text
    lda #47
    sta r0L ; STore Accumulator to location
    sta r1L
    stz r1H ; STore Zero in to location
    stz r2H
    ; point to the string
    lda #<textString3
    sta pointerToStringLow
    lda #>textString3
    sta pointerToStringHigh
    ; now call my function to display string
    jsr write_text
@loop:
    jmp @loop
.endproc

.proc write_text
    ; requires r0 and r1 set for x and y
    ; requires pointer be set to point to string to write to graphics
    ; will preserve .y
    phy ; PusH Y on to stack
    ; set counter
    ldy #0
    sty r11
@loop:
    ldy r11 
    lda (pointerToString),y ; go to pointed to memory address and read offset .y in to .a
    beq @end ; Branch if EQual, if zero flag is set then branch to @end
    jsr GRAPH_PUT_CHAR ; looks just graph_put_char stomps on y
    ; load the .y counter, increase it and store it
    ldy r11
    iny
    sty r11
    jmp @loop
@end:
    ply ; PuLl Y back off stack
    rts ; ReTurn from Subroutine
.endproc