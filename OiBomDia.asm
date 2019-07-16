romSize:    equ 8192                    ; o tamanho que a ROM deve ter
romArea:    equ 0x4000                  ; minha ROM começa aqui
ramArea:    equ 0xe000                  ; inicio da área de variáveis

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
            call INITXT                ; Entra em 40x24
            ld b,20                     ; número de repetições do texto
            ld c,2                     ; divisor para op dividir
writeMore:
            ld hl, Oi                   ; aponta para a string
            call print                  ; imprime a string
            ld hl, BomDia
            call print                  ; imprime a string
            djnz writeMore              ; B=B-1, se B>0 vai para 'writeMore'
loop:
            jr loop
            endp
print:
            proc
            ld a,(hl)                   ; coloca em A o endereço indicado em HL
            cp 0                        ; compara com 0
            ret z                       ; se é zero, fim da string
            call CHPUT                  ; chama CHPUT
            inc hl                      ; HL=HL+1
            jr print                    ; vai para print
            endp

Oi:
            db "Oi! ",0

BomDia:
            db "Bom dia! ",0

romPad:
            ds romSize-(romPad-romArea),0
            end
