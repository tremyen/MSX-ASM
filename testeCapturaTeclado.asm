romSize:        equ 8192        ; o tamanho que a ROM deve ter
romArea:        equ 0x4000      ; minha ROM comeca aqui
ramArea:        equ 0xe000      ; inicio da area de variaveis
posX:           equ 0xe001      ; posicao x
posY:           equ 0xe003      ; posicao y
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
            ld a, 64
            ld (posX), a
            ld a, 96
            ld (posY), a
            call printPositions

loopUntilSpace:
            call CHGET
            cp 97             ;esquerda
            call z, moveLeft
            cp 100            ;direita
            call z, moveRight
            cp 119            ;cima
            call z, moveUp
            cp 115            ;baixo
            call z, moveDown

            cp 32             ;espaco
            jp z, EndProgram
            call printPositions
            jr loopUntilSpace

moveLeft:                       ; diminuir em um pos x
            ld a,(posX)
            cp 1
            ret z
            dec a
            ld (posX), a
ret

moveRight:                       ; aumentar em um pos x
            ld a,(posX)
            cp 255
            ret z
            inc a
            ld (posX), a
ret

moveUp:                        ; aumentar em um pos y
            ld a,(posY)
            cp 198
            ret z
            inc a
            ld (posY), a
ret

moveDown:                       ; diminuir em um pos y
            ld a,(posY)
            cp 1
            ret z
            dec a
            ld (posY), a
ret

printPositions:
            push af
              ld hl, MessageX
              call writeString
              ld a,(posX)
              call CHPUT
            pop af
            call newLine
            call newLine
            push af
              ld hl, MessageY
              call writeString
              ld a,(posY)
              call CHPUT
            pop af
            call newLine
ret

MessageX: db "x=>", 255
MessageY: db "y=>", 255

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

EndProgram:
romPad:
            ds romSize-(romPad-romArea),0
            end
