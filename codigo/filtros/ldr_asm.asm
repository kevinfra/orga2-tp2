
global ldr_asm

section .data
%define max 4876875
%define tam1pixel 4
%define tam2pixel 8

section .text
;void ldr_asm    (
	;unsigned char *src,  rdi
	;unsigned char *dst,	rsi
	;int cols,						rdx
	;int filas,						rcx
	;int src_row_size,		r8
	;int dst_row_size,		r9
	;int alpha)						[rbp + 16]

ldr_asm:
	push rbp
	mov rbp, rsp
	push r12 ; el iterador de columnas
	push r13
	push r14
	push r15
	push rbx ; el iterador de filas
;stackframe

xor rbx, rbx
xor r12,r12

.forFilas:
	cmp rbx, rcx
	je .fin

	.forCols:
		cmp r12, rdx
		jge .avanzarFila

	cmp rbx,2 ;me fijo si son las primeras dos filas
	jl .parteDeArribaQueNoCambia
	push rcx
	sub rcx,2
	cmp rbx,rcx ;me fijo si son las ultimas dos filas
	pop rcx
	jge .parteDeAbajoQueNoCambia
	cmp r12,2 ; me fijo si son las primeras dos columnas
	jl .parteDeIzquierdaQueNoCambia
	push rdx
	sub rdx,2
	cmp r12,rdx ;me fijo si son las dos ultimas dos columnas
	pop rdx
	jge .parteDeDerechaQueNoCambia

	.ParteAdentro:
	xor r13, r13 ; en r13 tenemos el indice de desplazamiento de los vecinos
	sub r13,r8
	sub r13,r8
	sub r13,tam2pixel
	push rcx
	mov rcx,5
	.looperParalelo:
	movdqu xmm0,[rdi + r13]
	; aca hacemos la magia

	add r13,r8
	loop .looperParalelo
	pop rcx

	xor r13,r13
	sub r13,r8
	sub r13,r8
	add r13,tam1pixel
	push rcx
	mov rcx,5
	.looperIndividual:
	movdqu xmm1,[rdi + r13]
	add r13,r8
	loop .looperIndividual
	pop rcx

	inc r12 ;avanzo al proximo pixel
	inc rdi ;avanzo al proximo pixel en source
	inc rsi ;avanzo al proximo pixel en destino
	jmp .forCols

	.avanzarFila:
	xor r12, r12
	add rbx, 1
	jmp .forFilas

	.parteDeArribaQueNoCambia:

	.parteDeAbajoQueNoCambia:

	.parteDeIzquierdaQueNoCambia:

	.parteDeDerechaQueNoCambia:

	.fin:





  ret
