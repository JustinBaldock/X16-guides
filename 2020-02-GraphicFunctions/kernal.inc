; registers used by the kernal. these are all zero page
; https://github.com/commanderx16/x16-rom/blob/master/regs.inc
r0	    = $02
r0L	    = $02
r0H	    = $03
r1	    = $04
r1L	    = $04
r1H	    = $05
r2	    = $06
r2L	    = $06
r2H	    = $07
r3	    = $08
r3L	    = $08
r3H	    = $09
r4	    = $0a
r4L	    = $0a
r4H	    = $0b
r5	    = $0c
r5L	    = $0c
r5H	    = $0d
r6	    = $0e
r6L	    = $0e
r6H	    = $0f
r7	    = $10
r7L	    = $10
r7H	    = $11
r8	    = $12
r8L	    = $12
r8H	    = $13
r9	    = $14
r9L	    = $14
r9H	    = $15
r10	    = $16
r10L	= $16
r10H	= $17
r11	    = $18
r11L	= $18
r11H	= $19
r12	    = $1a
r12L	= $1a
r12H	= $1b
r13	    = $1c
r13L	= $1c
r13H	= $1d
r14	    = $1e
r14L	= $1e
r14H	= $1f
r15	    = $20
r15L	= $20
r15H	= $21

; API
;https://github.com/commanderx16/x16-docs/blob/master/Commander%20X16%20Programmer's%20Reference%20Guide.md#commodore-64-api-compatibility
;C64 - Channel I/O 
BSOUT = $FFD2 ; write character
BASIN = $FFCF ; get character
CHKOUT = $FFC9 ; Define file as default output, set channel for character output
CHKIN = $FFC6; set channel for character input
CHROUT = $FFD2 ; Write byte to default output.
;C64 - Other
GETIN = $FFE4 ; get character from keyboard

;CX16
;https://github.com/commanderx16/x16-docs/blob/master/Commander%20X16%20Programmer's%20Reference%20Guide.md#mouse-1
MOUSE_CONFIG = $FF68 ; configure mouse pointer function/appearance aka sprite 0
MOUSE_GET = $FF6B 

; joystick
; https://github.com/commanderx16/x16-docs/blob/master/Commander%20X16%20Programmer's%20Reference%20Guide.md#joystick
JOYSTICK_SCAN = $FF53
JOYSTICK_GET = $FF56

; sprites
; https://github.com/commanderx16/x16-docs/blob/master/Commander%20X16%20Programmer's%20Reference%20Guide.md#sprites
SPRITE_SET_IMAGE = $FEF0 ; a = sprite number, x = width, y = height ...
SPRITE_SET_POSITION = $FEF3

; framebuffer
; https://github.com/commanderx16/x16-docs/blob/master/Commander%20X16%20Programmer's%20Reference%20Guide.md#framebuffer
FB_INIT = $FEF6 ; enable graphics mode
FB_GET_INFO = $FEF9
FB_FILL_PIXELS = $FF17
FB_CURSOR_POSITION = $FEFF

; https://github.com/commanderx16/x16-docs/blob/master/Commander%20X16%20Programmer's%20Reference%20Guide.md#function-name-monitor
MONITOR = $FF44

; https://github.com/commanderx16/x16-docs/blob/master/Commander%20X16%20Programmer's%20Reference%20Guide.md#function-name-screen_set_mode
SCREEN_SET_MODE = $FF5F ; set mode in A register

SCREEN_MODE_40X30 = $00
SCREEN_MODE_80X60 = $02
SCREEN_MODE_320x200x256C = $80

; graphics
; https://github.com/commanderx16/x16-docs/blob/master/Commander%20X16%20Programmer's%20Reference%20Guide.md#graphics
GRAPH_INIT = $FF20
GRAPH_CLEAR = $FF23
GRAPH_SET_WINDOW = $FF26 ; word x:r0, word y:r1, word width:r2, word heigh:r3
GRAPH_SET_COLORS = $FF29 ; set the stroke, fill and background color. byte stroke:.a, byte fill:.x, byte background:.y
GRAPH_DRAW_LINE = $FF2C
GRAPH_DRAW_RECT = $FF2F ; draw rect using stroke color. word x1:r0, word y1:r1, word x2:r2, word y2:r3
GRAPH_MOVE_RECT = $FF23
GRAPH_DRAW_OVAL = $FF53
GRAPH_DRAW_IMAGE = $FF38
GRAPH_SET_FONT = $FF3B
GRAPH_GET_CHAR_SIZE = $FF3E
GRAPH_PUT_CHAR = $FF41


; standard colours
; https://www.c64-wiki.com/wiki/Color
COLOUR_BLACK = $00
COLOUR_WHITE = $01
COLOUR_RED = $02
COLOUR_CYAN = $03
COLOUR_PURPLE = $04
COLOUR_GREEN = $05
COLOUR_BLUE = $06
COLOUR_YELLOW = $07
COLOUR_ORANGE = $08
COLOUR_BROWN = $09
COLOUR_RED_LIGHT = $0a
COLOUR_GREY_DARK = $0b
COLOUR_GREY = $0c
COLOUR_GREEN_LIGHT = $0d
COLOUR_BLUE_LIGHT = $0E
COLOUR_GREY_LIGHT = $0F