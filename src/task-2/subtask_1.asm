; subtask 1 - qsort

section .text
    global quick_sort
    ;; no extern functions allowed

quick_sort:
    ;; create the new stack frame
    enter   0,0

    push    ebx
    push    edx
    push    esi

    ; esi - pointer to the vector
    mov     esi, [ebp + 8]
    ; eax - start index
    mov     eax, [ebp + 12]
    ; ebx - end index
    mov     ebx, [ebp + 16]

    ; check if the start index is greater or equal to the end index
    cmp     eax, ebx
    jge     end

    mov     ecx, eax
    ; set edi to the pivot element (last element in the array)
    mov     edi, [esi + 4 * ebx]

qsort_loop:
    cmp     ecx, ebx
    jge     qsort_recall

    ; if pivot < current element, increment ecx
    cmp     edi, [esi + 4 * ecx]
    jl      increment_loop

    ; get the current element
    mov     edx, [esi + 4 * ecx]
    ; edx <-> [esi + 4 * eax]
    xchg    edx, [esi + 4 * eax]
    ; [esi + 4 * ecx] = edx
    mov     [esi + 4 * ecx], edx

    inc     eax

increment_loop:
    inc     ecx
    jmp     qsort_loop

qsort_recall:
    ; get the element at the start index
    mov     edx, [esi + 4 * eax]
    ; edx <-> [esi + 4 * ebx]
    xchg    edx, [esi + 4 * ebx]
    ; [esi + 4 * eax] = edx
    mov     [esi + 4 * eax], edx

    ; recall the function for the left part of the array
    dec     eax
    push    eax
    ; push the start index
    push    dword [ebp + 12]
    ; push the vector
    push    dword [ebp + 8]
    call    quick_sort

    ; clean the stack
    add     esp, 8
    ; restore the start index
    pop     eax

    ; recall the function for the right part of the array
    inc     eax
    ; push the end index
    push    dword [ebp + 16]
    push    eax
    ; push the vector
    push    dword [ebp + 8]
    call    quick_sort

    ; clean the stack
    add     esp, 12

end:
    pop     esi
    pop     edx
    pop     ebx

    leave
    ret
