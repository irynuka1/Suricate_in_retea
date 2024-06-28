; Interpret as 64 bits code
[bits 64]

section .text
global map
global reduce

map:
    push    rbp
    mov     rbp, rsp

    ; loop counter
    mov     rbx, 0

map_loop:
    ; check if we're done
    cmp     rbx, rdx
    je      end_map

    ; save the destination pointer
    push    rdi
    ; get the current element
    mov     rdi, [rsi + rbx * 8]
    call    rcx
    pop     rdi

    ; store the result in the destination vector
    mov     [rdi + rbx * 8], rax

    inc     rbx
    jmp     map_loop

end_map:
    leave
    ret

; int reduce(int *dst, int *src, int n, int acc_init, int(*f)(int, int));
; int f(int acc, int curr_elem);
reduce:
    ; look at these fancy registers
    push    rbp
    mov     rbp, rsp

    ; loop counter
    xor     rbx, rbx

reduce_loop:
    ; check if we're done
    cmp     rbx, rdx
    je      end_reduce

    ; save the values of the registers
    push    rdi
    push    rsi
    push    rdx
    ; get the accumulator
    mov     rdi, rcx
    ; get the current element
    mov     rsi, [rsi + rbx * 8]
    call    r8
    pop     rdx
    pop     rsi
    pop     rdi

    ; store the result in the accumulator
    mov     rcx, rax

    inc     rbx
    jmp     reduce_loop

end_reduce:
    ; return the accumulator
    mov     rdi, rcx
    leave
    ret

