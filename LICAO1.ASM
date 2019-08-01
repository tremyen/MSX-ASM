; ========================================================
; PRIMEIRO EXEMPLO
; MATEMATICA BASICA
; ========================================================
romSize:        equ 8192        ; o tamanho que a ROM deve ter
romArea:        equ 0x4000      ; minha ROM comeca aqui
ramArea:        equ 0xe000      ; inicio da area de variaveis
CHPUT:		      equ 0x00A2			; Escreve caractere na tela
INITXT:		      equ 0x006C			; Inicializa VDP em modo texto 40x24
INIT32:		      equ 0x006F	    ; Inicializa VDP em modo texto 32x24

ORG romArea

  db "AB"                     ; ID
  dw startProgram             ; INIT
  dw 0x0000                   ; STATEMENT
  dw 0x0000                   ; DEVICE
  dw 0x0000                   ; TEXT
  ds 6,0                      ; RESERVED

startProgram:
  CALL INIT32
  LD A,2 	             ; (A) REGISTRADOR USADO PARA MATEMATICA
  INC A 	             ; SOMA 1 = A=3
  LD B,30
  ADD A,B	             ; A =3+30
  LD (ramArea), A
  LD L,(ramArea)
  XOR H
  CALL PrintString	    ; SHOW STRING TO SCREEN
  CALL NewLine		      ; PULA LINHA
  RET

PrintString:  ; printa uma string terminada em 255
		ld a,(HL)
		cp 255
		ret z
		inc hl
		call CHPUT
jr PrintString

NewLine:      ; pular linha
		ld a,13
		call CHPUT
		ld a,10
		jp CHPUT
ret

romPad:
  ds romSize-(romPad-romArea),0
  end
