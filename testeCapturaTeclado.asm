romSize:        equ 8192        ; o tamanho que a ROM deve ter
romArea:        equ 0x4000      ; minha ROM comeca aqui
ramArea:        equ 0xe000      ; inicio da area de variaveis
INITXT:         equ 0x006c      ; Inicializa modo texto
INIT32:		      equ 0x006F			; Inicializa VDP em modo texto 32x24
CHGET:		      equ 0x009F			; Obtém caractere do buffer do teclado
CHPUT:		      equ 0x00A2			; Escreve caractere na tela

org romArea
            db "AB"                     ; ID
            dw startProgram             ; INIT
            dw 0x0000                   ; STATEMENT
            dw 0x0000                   ; DEVICE
            dw 0x0000                   ; TEXT
            ds 6,0                      ; RESERVED

startProgram:
            call INIT32
            call printPositions

loopUntilSpace:
            call CHGET
            cp 97             ;esquerda
            jp z, moveLeft
            cp 32             ;espaco
            jp z, EndProgram
            call printPositions
            jr loopUntilSpace

moveLeft:                       ; diminuir em um pos x
            push af
              ld a, (posX)
              cp 1
              ret z
              dec a
              ld (posX), a
            pop af
            ret

printPositions:
            ld hl,posX
            call writeString
            call newLine
            ld hl,posY
            call writeString
            ret

writeString:
            ld a,(hl)
            cp 255
            ret z
            inc hl
            call CHPUT
            jp writeString
newLine:
            ld a,13
            call CHPUT
            ld a,10
            call CHPUT
            ret

posX:       db "128",255
posY:       db "96",255

EndProgram:
romPad:
            ds romSize-(romPad-romArea),0
            end
