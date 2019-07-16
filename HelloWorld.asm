romSize:    equ 8192                    ; o tamanho que a ROM deve ter
romArea:    equ 0x4000                  ; minha ROM comeca aqui
ramArea:    equ 0xe000                  ; inicio da area de variaveis

INITXT:     equ 0x006c
CHPUT:      equ 0x00a2

            org romArea

            db "AB"                     ; ID
            dw startProgram             ; INIT
            dw 0x0000                   ; STATEMENT
            dw 0x0000                   ; DEVICE
            dw 0x0000                   ; TEXT
            ds 6,0                      ; RESERVED

startProgram:
            proc
            call INITXT
            ld b,71
writeMore:
            ld hl,helloWorld
getChar:
            ld a,(hl)
            cp 0
            jr z,writeLoop
            call CHPUT
            inc hl
            jr getChar
writeLoop:
            djnz writeMore
loop:
            jr loop
            endp

helloWorld:
            db "Hello World!",0

romPad:
            ds romSize-(romPad-romArea),0
            end
