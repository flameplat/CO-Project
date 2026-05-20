.model small
.stack 100h






    makeShiftRows macro PlainText
    mov si,  PlainText  ; Move to the second row
    add si, 4
    ; Second Row (c2 c3 c0 c1) - Circular left shift by 8 bits (1 byte)
    mov al, [si]           ; Load the first byte of the row into AL
    mov ah, [si + 1]       ; Load the second byte of the row into AH
    mov bl, [si + 2]       ; Load the third byte of the row into BL
    mov bh, [si + 3]       ; Load the fourth byte of the row into BH

    mov [si], ah           ; Move the second byte to the first byte position
    mov [si + 1], bl       ; Move the third byte to the second byte position
    mov [si + 2], bh       ; Move the fourth byte to the third byte position
    mov [si + 3], al       ; Move the first byte to the fourth byte position

    add si, 4              ; Move to the third row

    ; Third Row (d3 d0 d1 d2) - Circular left shift by 16 bits (2 bytes)
    mov al, [si]           ; Load the first byte of the row into AL
    mov ah, [si + 1]       ; Load the second byte of the row into AH
    mov bl, [si + 2]       ; Load the third byte of the row into BL
    mov bh, [si + 3]       ; Load the fourth byte of the row into BH

    mov [si], bl           ; Move the third byte to the first byte position
    mov [si + 1], bh       ; Move the fourth byte to the second byte position
    mov [si + 2], al       ; Move the first byte to the third byte position
    mov [si + 3], ah       ; Move the second byte to the fourth byte position

    add si, 4              ; Move to the fourth row

    ; Fourth Row (a2 a3 a0 a1) - Circular left shift by 24 bits (3 bytes)
    mov al, [si]           ; Load the first byte of the row into AL
    mov ah, [si + 1]       ; Load the second byte of the row into AH
    mov bl, [si + 2]       ; Load the third byte of the row into BL
    mov bh, [si + 3]       ; Load the fourth byte of the row into BH

    mov [si], bh           ; Move the fourth byte to the first byte position
    mov [si + 1], al       ; Move the first byte to the second byte position
    mov [si + 2], ah       ; Move the second byte to the third byte position
    mov [si + 3], bl       ; Move the third byte to the fourth byte position
    endm