section .data

%define tam4Pixels 16
%define tamx [rbp + 16]
%define tamy [rbp + 24]
%define offsetx [rbp + 32]
%define offsety [rbp + 40]

section .text
global cropflip_asm
;void cropflip_asm(unsigned char *src,			rdi
;                  unsigned char *dst,			rsi
;		           int cols, int filas,			rdx, rcx
;                  int src_row_size,			r8
;                  int dst_row_size,			r9
;                  int tamx, int tamy,			rbp+28, rpb+24
;                  int offsetx, int offsety);	rbp+20, rbp+16

cropflip_asm:
	push rbp
	mov rbp, rsp
	push rbx
	push r12
	push r13
	push r14

	xor edx, edx
	mov edx, offsety ;edx = tamy
	add edx, tamy ;edx += offsety
	sub edx, 1 ; queda edx = tamy+offsety-1
	
	xor rcx, rcx
	mov rcx, 4
	.avanzarOffsetX:
	add rdi, offsetx ; src += offsetx
	loop .avanzarOffsetX
	
	;ahora tengo que avanzar en Y:
	.avanzarOffsetY:
	cmp edx, 0
	je .finAvanzar
	add rdi, r8
	dec edx
	jmp .avanzarOffsetY	

	;tengo rdi apuntando a donde tengo que empezar a copiar.
	;;hasta aca tengo rdi apuntando al comienzo de la matriz a cropflipear
	.finAvanzar:
	xor rcx, rcx
	xor rdx, rdx
	xor rbx, rbx
	xor r13, r13
		
	
  .forTamy:
	cmp edx, tamy ;for edx = 0; edx < tamy; do:
	je .fin
  .forTamx:
	cmp ecx, tamx ;for ecx=0; ecx < tamx; do:
	je .avanzarRdx
	movdqu xmm0, [rdi]
	movdqu [rsi], xmm0
	add ecx, 4
	add rsi, tam4Pixels ;avanzo 4 bytes al siguiente pixel por 4 pixels
	add rdi, tam4Pixels ;avanzo 4 bytes al siguiente pixel POR 4 PIXELS
	jmp .forTamx
	
  .avanzarRdx:
  	xor ecx, ecx
	add edx, 1
	sub rdi, r8 ;avanzo hasta la ultima posicion de la fila siguiente
	.volverAOffsetX:
	xor r12, r12
	mov r12d, tamx ;aqui, deberia ser |rdi| = tamx (en posicion)
;	sub r12d, offsetx
	sub rdi, r12 ;asi que con restar offsetx, volveria a la ubicacion
	sub rdi, r12
	sub rdi, r12
	sub rdi, r12
	
	jmp .forTamy
	
  .fin:
  	pop r14
	pop r13
	pop r12
	pop rbx
	pop rbp
	ret
