; Kernal Zeropage
; The registers R0 to R4 are the 16-bit Application Binary Interface (ABI) used by the Kernal
; R0 - R5 = Arguments / Return values
; R6 - R10 = Return values
; R11 - R15 = Scratch
KERNAL_R0   = $0002
KERNAL_R0_L = $0002
KERNAL_R0_H = $0003
KERNAL_R1   = $0004
KERNAL_R1_L = $0004
KERNAL_R1_H = $0005
KERNAL_R2   = $0006
KERNAL_R2_L = $0006
KERNAL_R2_H = $0007
KERNAL_R3   = $0008
KERNAL_R3_L = $0008
KERNAL_R3_H = $0009
KERNAL_R4   = $000A
KERNAL_R4_L = $000A
KERNAL_R4_H = $000B

; Kernal Functions
KERNAL_CHROUT   = $FFD2
KERNAL_GETIN    = $FFE4
KERNAL_CLOCK_SET = $FF4D
KERNAL_CLOCK_GET = $FF50 ; https://github.com/X16Community/x16-docs/blob/master/X16%20Reference%20-%2004%20-%20KERNAL.md#function-name-clock_set_date_time
; clock_get does NOT support jiffy
KERNAL_GRAPH_CLEAR  = $FF23
KERNAL_GRAPH_DRAW_LINE  = $FF2C
KERNEL_GRAPH_INIT   = $FF20
KERNAL_GRAPH_SET_COLORS = $FF29
KERNAL_GRAPH_SET_WINDOW = $FF26
KERNAL_PLOT = $FFF0
KERNAL_SETTIM = $FFDB ; https://www.pagetable.com/c64ref/kernal/#SETTIM
KERNAL_RDTIM = $FFDE ; https://www.pagetable.com/c64ref/kernal/#RDTIM
