
global ldr_asm

section .data

section .text
;void ldr_asm    (
	;unsigned char *src,  rdi
	;unsigned char *dst,	rsi
	;int filas,						rdx
	;int cols,						rcx
	;int src_row_size,		r8
	;int dst_row_size,		r9
	;int alpha)						[rsp + 0]

ldr_asm:
	push rbp
	mov rbp, rsp
	push r12
	push r13
	push r14
	push r15
	push rbx
;stackframe
	;aca, int alpha estaria en [rsp - 48]

    ret
