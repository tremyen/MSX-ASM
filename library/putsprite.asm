; -===============================-
;  Put Sprite Z80 asm
; -===============================-
;  Chamada:
;   B — a camada do sprite;
;   HL — a coordenada X do sprite;
;   A — a coordenada Y do sprite;
;   D — a cor do sprite e
;   E — o padrão do sprite.
; -===============================-

putSprite:
            proc
            local FIX_Y
            local SPR_MOD
            local putSpriteSetEclock
            local putSpriteNoEclock
            local putSpriteLayerLoop
            local putSpriteToVram

;           FIX_Y Corrige a posição vertical do sprite
;           0 => não mexe na 'coordenada Y'
;           1 => decrementa em 1 a 'coordenada Y'
FIX_Y:      equ 0

;           SPR_MOD Ajusta as dimensões do sprite
;           0 = 256 sprites em 8×8
;           1 =  64 sprites em 16×16
SPR_MOD:    equ 1

            ld c,a                      ; armazeno o valor de A em C
            ld a,0x0f                   ; somente 15 cores, não se esqueça.
            and d                       ; apago os 4 bits mais significativos
            ld d,a                      ; e armazeno o resultado
            bit 7,h                     ; o 7º bit de H é 0 (HL é negativo?)
            jr z,putSpriteNoEclock      ; se HL<0 pulo o bit de 'Early Clock'

putSpriteSetEclock:
            ld a,128
            or d
            ld d,a                      ; ligo o bit de  'Early Clock'
            ld a,32
            add a,l
            ld l,a                      ; aumenta a 'coordenada X' em mais 32

putSpriteNoEclock:
            if SPR_MOD=1
                sla e                   ; multiplica o número da camada por 4 em
                sla e                   ; caso de sprites de 16×16
            endif
            push de                     ; armazeno DE (Cor+Padrão) na pilha

            if FIX_Y=1
                dec c                   ; faz a correção da 'coodenada Y'
            endif

            ld h,l                      ; armazeno 'coordenada X' em H
            ld l,c                      ; armazena 'coordenada Y' em L
            push hl                     ; armazeno HL (YX) na pilha
            ld h,0x1b                   ; Só 0x1b em H e não 0x1b00 em HL!
            xor a

putSpriteLayerLoop:
            add a,4                     ; A=A+4
            djnz putSpriteLayerLoop
            ld l,a                      ; são apenas 128 bytes,
            ld b,2                      ; repito o laço 2 vezes

putSpriteToVram:
            pop de                      ; pego os valores na pilha
            ld a,e                      ; posição Y ou padrão do sprite
            call WRTVRM
            inc hl
            ld a,d                      ; posição X ou cor do sprite
            call WRTVRM
            inc hl
            djnz putSpriteToVram
            ret
            endp
