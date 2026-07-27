section .note.GNU-stack noalloc noexec nowrite progbits


section .data
section .bss
section .text
; Para copilar en Win 11 utiliza el gion bajo.
; Para linux utiliza sin guion bajo.

global sumaLista
;global _sumaLista
sumaLista:
;_sumaLista:
  push  EBP
  mov   ebp, esp
  push  EBX
  push  EDI
  push  ESI
  mov   esi, [ebp+8]
  mov   ecx, [ebp+12]
  mov   eax, 0
  mov   edi, 0
  .continue:
    add eax, [esi+edi*4]
    inc edi
  loop .continue
  pop ESI
  pop EDI
  pop EBX
  mov esp, ebp
  pop EBP
ret
