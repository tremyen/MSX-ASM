CHGCLR:     equ 0x0062
CHPUT:      equ 0x00a2
ERAFNK:     equ 0x00cc
INIT32:     equ 0x006f
FILVRM:     equ 0x0056
WRTVDP:     equ 0x0047
WRTVRM:     equ 0x004d
BAKCLR:     equ 0xf3ea
BDRCLR:     equ 0xf3eb
FORCLR:     equ 0xf3e9
LINL32:     equ 0xF3AF
RG1SAV:     equ 0xf3e0

macro	____put_sprite,Sprite_Layer,Sprite_Pos_X,Sprite_Pos_Y,Sprite_Color,Sprite_Pattern
            ld b,Sprite_Layer
            ld hl,Sprite_Pos_X
            ld a,Sprite_Pos_Y
            ld d,Sprite_Color
            ld e,Sprite_Pattern
            call putSprite
            endm

romSize:    equ 8192                    ; O tamanho da ROM (8192 ou 16384)
romArea:    equ 0x4000                  ; Endereço inicial da ROM (0x4000 ou 0x8000)
ramArea:    equ 0xe000                  ; Início da RAM (0xc000 ou 0xe000)

            org romArea

            db "AB"                     ; ID
            dw startProgram             ; INIT
            dw 0x0000                   ; STATEMENT
            dw 0x0000                   ; DEVICE
            dw 0x0000                   ; TEXT
            ds 6,0                      ; RESERVED

startProgram:
            proc

            call ERAFNK                 ; => KEY OFF

            ld hl,LINL32
            ld (hl),32                  ; => WIDTH 32 -- ou quase :-)

            call INIT32                 ; => SCREEN 1

            ld a,15                     ; BRANCO (15)
            ld (FORCLR),a               ; cor da frente em branco
            ld a,4                      ; AZUL (4)
            ld (BAKCLR),a               ; cor de fundo
            xor a                       ; TRANSPARENTE (0)
            ld (BDRCLR),a               ; cor da borda
            call CHGCLR                 ; => COLOR 15,4,0

            ld a,(RG1SAV)               ; leio o valor do registro 1
            and 0xec
            or 2                        ; e ajusto os sprites em 32x32
            ld b,a                      ; B=A
            ld c,1                      ; registrador 1
            call WRTVDP                 ; altero o valor do registro 1

            ; Preencher a Tabela de imagens dos Sprite
            ; Block transfer to VRAM from memory
            ;-===========================================-
            ; BC - blocklength
            ; DE - Start address of VRAM
            ; HL - start address (entre 14336 e 16385)
            ; Ou seja, dependendo do tamanho utilizado
            ; você pode ter 256 ou 64 sprites
            ;-===========================================-
            ld bc,257
            ld de,14336
            ld hl,sprite
            call LDIRVM

sprites:
            ld b,3
            ld hl,120
            ld a,72
            ld d,1
            ld e,0
            call putSprite

            ld b,3
            ld hl,120
            ld a,72
            ld d,1
            ld e,1
            call putSprite


loop:
            jr loop                     ; trava a execução neste ponto
            endp

sprite:
            ; Nave - Cada Bloco tem 32 bytes
            ; color 11 - 0
            DB 00000000b
            DB 00000000b
            DB 00000001b
            DB 00000001b
            DB 00000011b
            DB 00010110b
            DB 00011100b
            DB 00011101b
            DB 00111111b
            DB 01111110b
            DB 11111100b
            DB 00011100b
            DB 00001100b
            DB 00001100b
            DB 00000000b
            DB 00000000b
            DB 00000000b
            DB 00000000b
            DB 10000000b
            DB 10000000b
            DB 11000000b
            DB 01101000b
            DB 00111000b
            DB 10111000b
            DB 11111100b
            DB 01111110b
            DB 00111111b
            DB 00111100b
            DB 00110000b
            DB 00110000b
            DB 00000000b
            DB 00000000b
            ; color 1 - 1
            DB 00000000b
            DB 00000011b
            DB 00000010b
            DB 00000110b
            DB 00111100b
            DB 00101001b
            DB 00100011b
            DB 01100010b
            DB 11000000b
            DB 10000001b
            DB 00000011b
            DB 11100011b
            DB 00110011b
            DB 00010010b
            DB 00011110b
            DB 00000000b
            DB 00000000b
            DB 11000000b
            DB 01000000b
            DB 01100000b
            DB 00111100b
            DB 10010100b
            DB 11000100b
            DB 01000110b
            DB 00000011b
            DB 10000001b
            DB 11000000b
            DB 11000011b
            DB 11001110b
            DB 01001000b
            DB 01111000b
            DB 00000000b
            ; Cidade
            ; color 1 - 2
            DB 00000000b
            DB 00000000b
            DB 00000100b
            DB 00001000b
            DB 00010000b
            DB 00111000b
            DB 01111100b
            DB 00000000b
            DB 00010000b
            DB 00000000b
            DB 00000000b
            DB 00000000b
            DB 00000001b
            DB 00000001b
            DB 01111111b
            DB 11111111b
            DB 00000000b
            DB 00000000b
            DB 00000010b
            DB 00000100b
            DB 00001000b
            DB 00011100b
            DB 00111110b
            DB 00000000b
            DB 00001000b
            DB 00000000b
            DB 00000000b
            DB 00000000b
            DB 10000000b
            DB 10000000b
            DB 11111110b
            DB 11111111b
            ; color 6 - 3
            DB 00000000b
            DB 00000000b
            DB 00000000b
            DB 00000000b
            DB 00000000b
            DB 00000000b
            DB 00000000b
            DB 00000000b
            DB 00101000b
            DB 00111000b
            DB 00111000b
            DB 00111000b
            DB 00111000b
            DB 00111000b
            DB 00000000b
            DB 00000000b
            DB 00000000b
            DB 00000000b
            DB 00000000b
            DB 00000000b
            DB 00000000b
            DB 00000000b
            DB 00000000b
            DB 00000000b
            DB 00010100b
            DB 00011100b
            DB 00011100b
            DB 00011100b
            DB 00011100b
            DB 00011100b
            DB 00000000b
            DB 00000000b
            ; color 8 - 129
            DB 00000000b
            DB 00000000b
            DB 00000000b
            DB 00000000b
            DB 00000000b
            DB 00000000b
            DB 00000000b
            DB 00000000b
            DB 00000001b
            DB 00000011b
            DB 00000011b
            DB 00000011b
            DB 00000010b
            DB 00000010b
            DB 00000000b
            DB 00000000b
            DB 00000000b
            DB 00000000b
            DB 00000000b
            DB 00000000b
            DB 00000000b
            DB 00000000b
            DB 00000000b
            DB 00000000b
            DB 10000000b
            DB 11000000b
            DB 11000000b
            DB 11000000b
            DB 01000000b
            DB 01000000b
            DB 00000000b
            DB 00000000b
            ; color 9 - 161
            DB 00000000b
            DB 00000000b
            DB 00000000b
            DB 00000000b
            DB 00000000b
            DB 00000000b
            DB 00000000b
            DB 01111100b
            DB 01000100b
            DB 01000100b
            DB 01000100b
            DB 01000100b
            DB 01000100b
            DB 01000100b
            DB 00000000b
            DB 00000000b
            DB 00000000b
            DB 00000000b
            DB 00000000b
            DB 00000000b
            DB 00000000b
            DB 00000000b
            DB 00000000b
            DB 00111110b
            DB 00100010b
            DB 00100010b
            DB 00100010b
            DB 00100010b
            DB 00100010b
            DB 00100010b
            DB 00000000b
            DB 00000000b
            ; nave alienigena
            ; color 1 - 193
            DB 11100011b
            DB 10110010b
            DB 11011010b
            DB 01101110b
            DB 00100100b
            DB 00010001b
            DB 00010001b
            DB 00010000b
            DB 00010001b
            DB 00011001b
            DB 00001100b
            DB 00000110b
            DB 00000011b
            DB 00000000b
            DB 00000000b
            DB 00000000b
            DB 10001110b
            DB 10011010b
            DB 10110110b
            DB 11101100b
            DB 01001000b
            DB 00011000b
            DB 00010000b
            DB 00010000b
            DB 00010000b
            DB 00110000b
            DB 01100000b
            DB 11000000b
            DB 10000000b
            DB 00000000b
            DB 00000000b
            DB 00000000b
            ; color 3 - 225
            DB 00000000b
            DB 01000001b
            DB 00100001b
            DB 00010001b
            DB 00011011b
            DB 00001110b
            DB 00001000b
            DB 00001000b
            DB 00001000b
            DB 00000110b
            DB 00000011b
            DB 00000001b
            DB 00000000b
            DB 00000000b
            DB 00000000b
            DB 00000000b
            DB 00000000b
            DB 00000100b
            DB 00001000b
            DB 00010000b
            DB 10110000b
            DB 11100000b
            DB 00100000b
            DB 00100000b
            DB 00100000b
            DB 11000000b
            DB 10000000b
            DB 00000000b
            DB 00000000b
            DB 00000000b
            DB 00000000b
            DB 00000000b
            ; color 6 - 257
            DB 00000000b
            DB 00000000b
            DB 00000000b
            DB 00000000b
            DB 00000000b
            DB 00000000b
            DB 00000110b
            DB 00000111b
            DB 00000110b
            DB 00000000b
            DB 00000000b
            DB 00000000b
            DB 00000000b
            DB 00000000b
            DB 00000000b
            DB 00000000b
            DB 00000000b
            DB 00000000b
            DB 00000000b
            DB 00000000b
            DB 00000000b
            DB 00000000b
            DB 11000000b
            DB 11000000b
            DB 11000000b
            DB 00000000b
            DB 00000000b
            DB 00000000b
            DB 00000000b
            DB 00000000b
            DB 00000000b
            DB 00000000b

romPad:
            ds romSize-(romPad-romArea),0
            end
