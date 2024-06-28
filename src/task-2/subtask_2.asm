; subtask 2 - bsearch

section .data
    ; this will be used to store the number of elements
    no_elements dd 0

section .text
    global binary_search

binary_search:
    ;; Create the new stack frame
    enter   0, 0

    ;; ecx contains the buff and edx contains the needle
    push    ebx
    push    edi
    push    esi

    ; eax - start index
    mov     eax, [ebp + 8]
    ; ebx - end index
    mov     ebx, [ebp + 12]

    mov     [no_elements], ebx
    sub     [no_elements], eax
    ; check if there is at least one element
    jl      not_found

    ; get the middle index
    mov     edi, [no_elements]
    ; edi = (end - start) / 2
    shr     edi, 1
    add     edi, eax

    ; get the middle element
    mov     esi, [ecx + edi * 4]
    cmp     esi, edx
    je      found
    jg      left
    jl      right

; search in the left half
left:
    ; get within the left half
    dec     edi
    ; recall the function
    push    ecx
    push    edx
    push    edi
    push    eax
    call    binary_search

    ; clean the stack
    add     esp, 16
    jmp     end

; search in the right half
right:
    ; get within the right half
    inc     edi
    ; recall the function
    push    ecx
    push    edx
    push    ebx
    push    edi
    call    binary_search

    ; clean the stack
    add     esp, 16
    jmp     end

found:
    ; if found return the index
    mov     eax, edi
    jmp     end

not_found:
    ; if not found return -1
    mov     eax, -1
    jmp     end

end:
    ; Pop used registers
    pop     esi
    pop     edi
    pop     ebx

    leave
    ret
