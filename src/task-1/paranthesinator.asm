; Interpret as 32 bits code
[bits 32]

%include "../include/io.mac"

section .text
; int check_parantheses(char *str)
global check_parantheses
check_parantheses:
    push    ebp
    mov     ebp, esp

    ; esi points to the input string
    mov     esi, [ebp+8]

loop:
    ; load the current character
    mov     al, [esi]
    ; check if it is the null terminator
    cmp     al, 0
    je      good

    ; check if it is an open parenthesis
    cmp     al, '('
    je      push_paren
    cmp     al, '['
    je      push_paren
    cmp     al, '{'
    je      push_paren

    ; check if it is a close parenthesis
    cmp     al, ')'
    je      pop_round
    cmp     al, ']'
    je      pop_square
    cmp     al, '}'
    je      pop_curly

next:
    inc     esi
    jmp     loop

; push the open parenthesis on the stack
push_paren:
    push    eax
    jmp     next

pop_round:
    pop edx
    cmp dl, '('
    jne wrong
    jmp next

pop_square:
    pop edx
    cmp dl, '['
    jne wrong
    jmp next

pop_curly:
    pop edx
    cmp dl, '{'
    jne wrong
    jmp next

wrong:
    ; if we reach this point, the parenthesis are not balanced
    mov eax, 1
    jmp end

good:
    ; check if the stack is empty
    cmp esp, ebp
    jne wrong
    ; if not, the parenthesis are not balanced
    mov eax, 0

end:
    leave
    ret
