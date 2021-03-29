start:
jmp  main
times   0x30 - ($-$$)    db  2 ;useless data that can be modified by the bios
;on my machine, bytes 0x1C, 0x1D, 0x1E, 0x1F, and 0x24 are set to 0; i figured it out with this program
main:
;setup memory adresses
mov ax, 0x07c0
mov ds, ax
mov es, ax
mov ss, ax
mov sp, 0x7c00



; disable blinking
mov ax, 0x1003
mov bx, 0
int 10h

;start colored text mode
mov ax, 3
int 0x10
mov ax, 0x0500
int 0x10

mov si,start
xor bx,bx
mov ah, 0x0e
memdump_loop:
    lodsb
    call printhex
    ;put spaces between values
    mov al,' '
    int 0x10
    test si, 0x00FF
    je memdump_end
    test si, 0x000F
    jne memdump_loop
memdump_newline:
    ;next line
    mov al,10
    int 0x10
    mov al,13
    int 0x10
    jmp memdump_loop
memdump_end:
mov ah, 0
int 0x16
cmp al, 'w'
    jne noup
    mov ax,si
    sub ax,0x0200
    mov si,ax
noup:
mov ah, 0x0e
jmp memdump_newline

printhex:;print al as hexadecimal
    push ax
    push bx
    push cx
    xor bx,bx

    mov ah, 0x0e

    mov cl,al
    and al, 0xF0
    shr al, 4
    call dectoHex
    int 0x10

    mov al,cl
    and al, 0x0F
    call dectoHex
    int 0x10

    pop cx
    pop bx
    pop ax
    ret
dectoHex:
    cmp al,0x0a
    jns dectoHex_ch
    add al,0x30
    ret
    dectoHex_ch:
    add al,0x37
    ret


times   510 - ($-$$)    db  0
db  0x55,   0xaa