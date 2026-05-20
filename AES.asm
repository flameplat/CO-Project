
org  100h	; set lo

INCLUDE "AddRoundKey.asm"
INCLUDE "MixColumns.asm"
INCLUDE "SubBytes.asm"
INCLUDE "ShiftRow.asm"
INCLUDE "I-O.asm"
 .data
inputArray db 32 dup(?)    ; Reserve space for an array of 32 bytes
State db 'Please Enter the data you want to encrypt! $'
Key db 'Now, Enter the Cipher key that will encrypt the data! $'
prompt db 'Enter 32 alphanumeric characters: $'
invalidMsg db 'Invalid character. Please enter alphanumeric characters only.$'
encryptedMsg db 'The encrypted Message is:'

newline db 13, 10, '$'     ; Carriage return and line feed for new line

cipher_key  db 16 dup(?)

    
PlainText db 16 dup(?)  

pos_key dw 0
counter dw 9
    
    
    

.code

            MOV AX, @data
            MOV ds, ax      
            lea dx, State
            mov ah, 09h
            int 21h
            lea dx, newline
            mov ah, 09h
            int 21h
            lea di, PlainText
            call writeData 
            lea dx, Key
            mov ah, 09h
            int 21h
            lea dx, newline
            mov ah, 09h
            int 21h
            lea di, cipher_key
            call writeData
            lea si, PlainText
            lea di, keySchedule
            
            makeAddRoundKey si 
            
makeTran:
            lea si, PlainText
            makeSubBytes si
            lea si, PlainText
            makeShiftRows si
            lea di, PlainText
            makeMixColumn di 
            lea si, PlainText
            makeAddRoundKey si
            dec counter
            mov cx, counter
            cmp cx, 0
            ja makeTran 
            lea si, PlainText
            makeSubBytes si
            lea si, PlainText
            makeShiftRows si 
            lea si, PlainText
            makeAddRoundKey si
            lea dx,encryptedMsg
            mov ah, 09h
            int 21h
            lea si, PlainText
            
            call PrintKey
            
            


mov ah,0x4c
int 0x21


END start   
    





