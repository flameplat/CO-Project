org 100h

.data
MixMatrix db 0x02, 0x03, 0x01, 0x01
          db 0x01, 0x02, 0x03, 0x01
          db 0x01, 0x01, 0x02, 0x03
          db 0x03, 0x01, 0x01, 0x02

ResultMatrix db 16 dup(0)


    ; Macros
    GetResByte Macro di, bx, count, SI
        LOCAL LOOP1, multiplyOne, res, multiplyTwo
                push cx              
                push di
                mov cx,count
LOOP1:          cmp [bx], 1
                je multiplyOne
                mov ax,  [di]
                and ax, 0xFF
                SAL ax, 1
                TEST [di], 0x80
                jbe multiplyTwo
                xor ax,00011011b ;this value calculated by book cryptography and network
                and ax, 0xFF
multiplyTwo:    cmp [bx], 2
                je res 
                push ax
multiplyOne:    mov ax, [di]
                and ax, 0xFF
                cmp [bx],1
                je res
                pop dx
                xor ax, dx
res:            push ax
                inc bx
                add di, 4
                loop LOOP1
                xor dx, dx
                pop ax
                xor dx, ax
                pop ax
                xor dx, ax
                pop ax
                xor dx, ax
                pop ax
                xor dx, ax
                mov [si], dl
                pop di
                pop cx
    EndM

    getResColumn Macro di, bx, SI
        LOCAL LOOP2
                push cx
                push SI
                push bx
                MOV  cx,4
         LOOP2:
                GetResByte di, bx, 4, si
                add si,4
                
                loop LOOP2
                pop bx 
                pop SI
                pop cx
 
    EndM
    placeTextCol Macro di,si
             
                mov ah, [si]
                mov [di], ah
                mov ah,[si+4]
                mov [di+4], ah
                mov ah, [si+8]
                mov [di+8], ah
                mov ah, [si+12]
                mov [di+12], ah
    EndM 
    makeMixColumn Macro PlainText
                push cx
                mov bx, offset MixMatrix
                mov si, offset ResultMatrix
                mov cx, 4
                  
LOOP3:          getResColumn di, bx, si
                placeTextCol di, si
                inc di
                inc si 
                loop LOOP3
                pop cx  
    EndM