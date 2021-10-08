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
    fild dword [number]
    fsqrt
    fistp dword [result]
    mov eax, [result]

    print_digit_in_eax
    end
    
section .data
    number dd 315844
    
section .bss
    result resb 1