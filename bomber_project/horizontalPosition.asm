    processor 6502

    include "vcs.h"
    include "macro.h"
    
    seg.u Variables 
    org $80
P0XPos byte  ;Sprite X coordinate

    seg Code 
    org $F000

Reset:
    CLEAN_START ;marco to clena memory and TIA

    ldx #$00    ;black background color
    stx COLUBK

    lda #50
    sta P0XPos ;initializa player X coordinate

StartFrame: 
    lda #2
    sta VBLANK ;turn VBLANK on  
    sta VSYNC  ;turn VSYNC on

    REPEAT 3 
        sta WSYNC 
    REPEND
    lda #0
    sta VSYNC

    lda P0XPos
    and #$7F
    
    sec

    sta WSYNC
    sta HMCLR

DivideLoop:
    sbc #15
    bcs DivideLoop

    eor #7
    asl
    asl
    asl
    asl
    sta HMP0
    sta RESP0
    sta WSYNC
    sta HMOVE


    REPEAT 35
        sta WSYNC
    REPEND

    lda #0
    sta VBLANK

    REPEAT 60
        sta WSYNC
    REPEND

    ldy 8
DrawBitMap:
    lda P0Bitmap,Y
    sta GRP0

    lda P0Color,Y
    sta COLUP0

    sta WSYNC 

    dey
    bne DrawBitMap

    lda #0
    sta GRP0

    REPEAT 124
        sta WSYNC
    REPEND

Overscan:
    lda #2
    sta VBLANK

    REPEAT 30
        sta WSYNC
    REPEND

    inc P0XPos

    jmp StartFrame

P0Bitmap:
    byte #%00000000
    byte #%00010000
    byte #%00001000
    byte #%00011100
    byte #%00110110
    byte #%00101110
    byte #%00101110
    byte #%00111110
    byte #%00011100

P0Color:
    byte #$00
    byte #$02
    byte #$02
    byte #$52
    byte #$52
    byte #$52
    byte #$52
    byte #$52
    byte #$52

    org $FFFC
    word Reset
    word Reset
