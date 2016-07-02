
global ldr_asm

section .data
%define tam1pixel 4
%define tam2pixel 8
%define tam4pixel 16
max: dd 4876875, 4876875, 4876875, 0
borrarA: dw 0xffff, 0xffff, 0xffff, 0, 0xffff, 0xffff, 0xffff, 0
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
movdqu xmm15, [borrarA]
pxor xmm14, xmm14
mov r14d, [rbp + 16]
pinsrd xmm14, r14d, 00000000b ;alpha en la dword mas baja de xmm14
movdqu xmm0, [max]
cvtdq2ps xmm13, xmm0 ;dejamos max en xmm13

xor rbx, rbx
xor r12,r12

.forFilas:
	cmp rbx, rcx
	je .fin

	.forCols:
		cmp r12, rdx
		jge .avanzarFila

		cmp rbx,2 ;me fijo si son las primeras dos filas
		jl .parteDeArribaYAbajoQueNoCambia
		push rcx
		sub rcx,2
		cmp rbx,rcx ;me fijo si son las ultimas dos filas
		pop rcx
		jge .parteDeArribaYAbajoQueNoCambia
		cmp r12,2 ; me fijo si son las primeras dos columnas
		jl .parteDeIzquierdaYDerechaQueNoCambia
		push rdx
		sub rdx,2
		cmp r12,rdx ;me fijo si son las dos ultimas dos columnas
		pop rdx
		jge .parteDeIzquierdaYDerechaQueNoCambia

		.ParteAdentro:
		xor r13, r13 ; en r13 tenemos el indice de desplazamiento de los vecinos
		sub r13,r8
		sub r13,r8
		sub r13,tam2pixel
		push rcx
		mov rcx,4
		movdqu xmm2,[rdi + r13]
		movdqu xmm3,xmm2
		pxor xmm4,xmm4
		punpckhbw xmm2,xmm4
		punpcklbw xmm3,xmm4
		paddw xmm2,xmm3 ; en xmm2 vamos a tener las sumas parciales de 4 pixeles, separadas por qwords y en cada word un canal
		add r13,r8

		.looperParalelo:
		movdqu xmm0,[rdi + r13]
		movdqu xmm1, xmm0
		punpcklbw xmm0, xmm4 ; xmm0 = | 0 |p2a| 0 |p2r| 0 |p3g| 0 |p2b| 0 |p3a| 0 |p3r...
		punpckhbw xmm1, xmm4
		paddw xmm0,xmm1
		paddw xmm2,xmm0 ; aca vamos sumando todos los cancales de los pixeles
		add r13,r8
		loop .looperParalelo
		pop rcx

		pand xmm2,xmm15 ; limpiamos el a

		phaddw xmm2,xmm2
		phaddw xmm2,xmm2
		phaddw xmm2,xmm2 ;sumamos todos los 4 pixeles y nos queda en cada word la suma de todos los canales


		xor r13,r13
		sub r13,r8
		sub r13,r8
		add r13,tam1pixel
		push rcx
		mov rcx,4


		movdqu xmm3, [rdi + r13]
		punpcklbw xmm3,xmm4
		add r13,r8

		.looperIndividual:
		movdqu xmm0,[rdi + r13]
		punpcklbw xmm0,xmm4
		paddw xmm3,xmm0

		add r13,r8
		loop .looperIndividual
		pop rcx

		pand xmm3,xmm15 ; sacamos el a

		phaddw xmm3,xmm3
		phaddw xmm3,xmm3

		paddw xmm2,xmm3 ; aca tenemos en la mas baja word la suma de todos los canales de los 25 pixeles

		punpcklwd xmm2,xmm4
		pmulld xmm2, xmm14 ;tenemos en xmm2 en la qword baja sumaRGB*alpha
		movdqu xmm1, xmm2
		movdqu xmm3, xmm2
		shufps xmm1, xmm2, 11001100b
		shufps xmm1, xmm3, 11001000b ; xmm1 = |basura|suma|suma|suma|
		movdqu xmm2, [rdi]
		punpcklbw xmm2, xmm4
		punpcklwd xmm2, xmm4 ;tenemos ARGB en dword en xmm2
		pmulld xmm1, xmm2
		pxor xmm3, xmm3
		cvtdq2ps xmm3, xmm1
		divps xmm3, xmm13
		cvtps2dq xmm1, xmm3
		paddd xmm1, xmm2
		pextrd eax, xmm2, 00000011b ; extraemos el A del pixel en vista
		pinsrd xmm1, eax, 00000011b ;insertamos el A en el dword mas alto de xmm1
		packusdw xmm1, xmm4
		packuswb xmm1, xmm4
		pextrd eax, xmm1, 00000000b
		mov [rsi], eax

		inc r12 ;avanzo al proximo pixel
		add rdi, tam1pixel ;avanzo al proximo pixel en source
		add rsi, tam1pixel ;avanzo al proximo pixel en destino
		jmp .forCols

	.avanzarFila:
	xor r12, r12
	add rbx, 1
	jmp .forFilas

	.parteDeArribaYAbajoQueNoCambia:

	movdqu xmm1,[rdi] ; me copio a xmm1 4 pixeles
	movdqu [rsi],xmm1
	add rdi,tam4pixel
	add rsi,tam4pixel
	add r12,4
	jmp .forCols



	.parteDeIzquierdaYDerechaQueNoCambia:
	mov r14,[rdi]
	mov [rsi],r14
	add rdi,tam2pixel
	add rsi,tam2pixel
	add r12,2
	jmp .forCols



	.fin:
	pop rbx
	pop r15
	pop r14
	pop r13
	pop r12
	pop rbp






  ret
