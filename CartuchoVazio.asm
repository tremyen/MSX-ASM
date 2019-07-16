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
            ret
            endp
romPad:
            ds romSize-(romPad-romArea),0
            end
