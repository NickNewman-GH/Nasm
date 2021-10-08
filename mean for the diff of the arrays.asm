%macro print 2
    push_all
    mov edx, %1
    mov ecx, %2
    mov ebx, 1
    mov eax, 4
    int 0x80
    pop_all
%endmacro

%macro push_all 0
    push eax
    push ebx
    push ecx
    push edx
%endmacro

%macro pop_all 0
    pop edx
    pop ecx
    pop ebx
    pop eax
%endmacro

%macro print_digit_in_eax 0
    push_all
    mov ecx, 10
    mov bx, 0

%%_loop_extracting_digits:
    mov edx, 0
    div ecx
    push dx
    inc bx
    cmp eax, 0
    jnz %%_loop_extracting_digits

%%_loop_print_digits:
    pop ax
    add ax, '0'
    mov [result], ax
    print 1, result
    dec bx
    cmp bx, 0
    jnz %%_loop_print_digits
    pop_all
%endmacro

%macro end 0
    mov ebx, 0
    mov eax, 1
    int 0x80
%endmacro

section .text
    global _start

_start:
    mov ebx, 0

_sum_x:
    add al, [x + ebx]
    inc ebx
    cmp ebx, len_x
    jne _sum_x
    
    ;finding average value of x
    push eax
    mov eax, len_x
    mov ebx, 4
    div ebx
    mov ebx, eax
    pop eax
    div ebx
    
    ;saving avg of x
    push eax
    
    ;declaration of starting values
    mov ebx, 0
    mov eax, 0
    
_sum_y:
    add al, [y + ebx]
    inc ebx
    cmp ebx, len_y
    jne _sum_y
    
    ;finding average value of y
    push eax
    mov eax, len_x
    mov ebx, 4
    div ebx
    mov ebx, eax
    pop eax
    div ebx
    
    ;subtraction of avgs
    pop ebx
    sub eax, ebx
    
    ;output
    print_digit_in_eax
    end

section .data

    x dd 5, 3, 2, 6, 1, 7, 4
    len_x equ $-x   
    y dd 0, 10, 1, 9, 2, 8, 5
    len_y equ $-y
    
section .bss
    result resb 1