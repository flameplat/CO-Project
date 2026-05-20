
writeData proc
        ; Display the prompt message 
        push di
        lea dx, prompt
        mov ah, 09h
        int 21h
        lea dx, newline
        mov ah, 09h
        int 21h
        ; Read 32 characters from the keyboard and store them in the inputArray
        lea di, inputArray
        mov cx, 4               ; Number of characters to read
read_loop:
        ; Read a character
        push cx
        mov cx, 4
row_loop: 
        push cx
        mov cx, 2
cell_loop:
        mov ah, 01h              ; Function 01h - read a character from stdin
        int 21h
        ; Validate the character
        cmp al, '0'
        jl invalid_char          ; If less than '0', invalid
        cmp al, '9'
        jle valid_char           ; If between '0' and '9', valid
        cmp al, 'A'
        jl invalid_char          ; If less than 'A', invalid
        cmp al, 'Z'
        jle valid_char           ; If between 'A' and 'Z', valid
    
invalid_char:
        ; Display invalid character message and prompt again
        lea dx, newline
        mov ah, 09h
        int 21h
        lea dx, invalidMsg
        mov ah, 09h
        int 21h
        lea dx, newline
        mov ah, 09h
        int 21h
        lea dx, prompt
        mov ah, 09h
        int 21h
        jmp cell_loop            ; Retry input
        
valid_char:
        ; Store the character in the inputArray
        stosb 
                           ; Store AL at address ES:DI and increment DI
        loop cell_loop 
        pop cx          ; Repeat until CX is 0  
        ;space  
        loop row_loop 
        pop cx
        loop read_loop
        ; Process the inputArray and create outputArray with spaces
        lea si, inputArray 
        pop  di
        mov cx, 16               ; Number of pairs to process               ; Number of pairs to process
    
process_loop:
        ; Copy two characters
        lodsb                    ; Load byte from DS:SI into AL and increment SI
        call ReadUpperNibble
        lodsb                    ; Load byte from DS:SI into AL and increment SI
        call ReadLowerNibble
        OR al,ah
        stosb                    ; Store AL at ES:DI and increment DI
        loop process_loop        ; Repeat until CX is 0
    
        ; Display the newline
        lea dx, newline
        mov ah, 09h
        int 21h
        writeData endp


; Subroutine to process the hexadecimal byte in AL
ReadLowerNibble proc

    ; Convert upper nibble to hex
    mov bl, al         ; Copy AL to BL           
    call NibbleToHex ; Convert nibble to ASCII
    ret
ReadLowerNibble endp
; Subroutine to process the hexadecimal byte in AL
ReadUpperNibble proc

    ; Convert upper nibble to hex
    mov bl, al         ; Copy AL to BL           
    call NibbleToHex ; Convert nibble to ASCII
    SHL al,4
    mov ah, al
    ret
ReadUpperNibble endp

; Subroutine to convert a nibble (lower 4 bits) in BL to an ASCII character in AL
NibbleToHex proc
    cmp bl, 39h          ; Compare nibble with 9
    jbe Digit          ; Jump if nibble is 0-9
    sub bl, 7          ; Adjust for hexadecimal letters (A-F)
Digit:
    sub bl, '0'        ; Convert nibble to ASCII ('0'-'9' or 'A'-'F')
    mov al, bl         ; Move result to AL 
    ret
NibbleToHex endp  
  

;procedure for PrintRoundkeys
PrintKey proc
    mov bl, 0
    mov dl, 0
    mov cx, 16
    .print:
        xor ax, ax
        mov al, [si]
        call WriteHex ; Assuming WriteHex handles printing in AL
        ; BIOS interrupt for printing character in AL
        inc si
        inc bl
        inc dl
        cmp bl, 44
        jne .printSpace ; Print Space
        ; Print newline character
        
        jmp .done1
    .printSpace:
        cmp dl, 4
        je .newLine
        mov al, ' '
        mov ah, 0x0E
        int 0x10
        jmp .done1
    .newLine:
        mov ah, 0x0E
        mov bh, 0x00
        mov al, 0x0D    ; Carriage return
        int 0x10
        mov al, 0x0A     ; Line feed
        int 0x10
        mov dl, 0
    .done1:
    loop .print
    ret
PrintKey endp                         


; Subroutine to print the hexadecimal byte in AL
WriteHex proc
                
    push bx     ; Save BX register
    push ax            ; Save AX register

    ; Convert upper nibble to ASCII
    mov bl, al         ; Copy AL to BL
    shr bl, 4          ; Shift right to get the upper nibble           
    call NibbleToAscii ; Convert nibble to ASCII
    mov ah, 0x0E       ; BIOS teletype output function
    int 0x10           ; Call BIOS to print character in AL

    ; Convert lower nibble to ASCII
    pop ax
    mov bl, al         ; Copy AL to BL
    and bl, 0x0F       ; Mask to get the lower nibble
    push ax       
    call NibbleToAscii ; Convert nibble to ASCII
    mov ah, 0x0E       ; BIOS teletype output function
    int 0x10           ; Call BIOS to print character in AL

    pop ax             ; Restore AX register
    pop bx             ; Restore BX register
    ret
WriteHex endp

; Subroutine to convert a nibble (lower 4 bits) in BL to an ASCII character in AL
NibbleToAscii proc
    cmp bl, 9          ; Compare nibble with 9
    jbe Digit2          ; Jump if nibble is 0-9
    add bl, 7          ; Adjust for hexadecimal letters (A-F)
Digit2:
    add bl, '0'        ; Convert nibble to ASCII ('0'-'9' or 'A'-'F')
    mov al, bl         ; Move result to AL 
    ret
NibbleToAscii endp