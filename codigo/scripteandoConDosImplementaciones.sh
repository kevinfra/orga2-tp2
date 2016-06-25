imp_sepia="asm c"
imp_ldr="asm c"
imp_cropflip="asm c"
filtros="all"


while getopts 'chf:' opt; do
	case $opt in
		c) filtros="none" ;;
		h)	echo ""
			echo "    Script para generar info de test cases. Se calcula la cantidad de ciclos de"
			echo "    reloj cada 100 ejecuciones por imagen, con hasta 13 imagenes."
			echo ""
			echo "    Opciones disponibles:"
			echo "        -h        Imprime este texto de ayuda."
			echo "        -f <ldr|sepia|cropflip|all>    Filtro a ejecutar (todas por defecto)."
			echo "        -c 				Limpia todo."
			echo ""
			exit 0 ;;
		f) filtros=$OPTARG ;;
	esac
done


make clean
make
if [[ $filtros = "sepia" || $filtros == "all" ]]; then
	rm sepiac
	rm sepiasm
	for (( i = 128; i < 1700; i=i+128 )); do
    	echo "corriendo filtro sepia asm v1 para una matriz de $i x $i"
		printf '%i   ' $(($i*$i)) >> sepiasm
		./build/tp2 sepia -i asm ./img/bastachicos.${i}x${i}.bmp -t 100 >>sepiasm
	done

	mv filtros/sepia_asm.asm filtros/sepia_asmV1.asm
	mv filtros/sepia_asmV2.asm filtros/sepia_asm.asm

	make clean
	make

	for (( i = 128; i < 1700; i=i+128 )); do
    	echo "corriendo filtro sepia asm v2 para una matriz de $i x $i"
		printf '%i   ' $(($i*$i)) >> sepiac
		./build/tp2 sepia -i asm ./img/bastachicos.${i}x${i}.bmp -t 100 >>sepiac
	done

	mv filtros/sepia_asm.asm filtros/sepia_asmV2.asm
	mv filtros/sepia_asmV1.asm filtros/sepia_asm.asm

fi

if [[ $filtros = "ldr" || $filtros == "all" ]]; then
	rm ldrasm
	rm ldrc
	for (( i = 128; i < 1700; i=i+128 )); do
    	echo "corriendo filtro ldr asm V1 para una matriz de $i x $i"
		printf '%i   ' $(($i*$i)) >> ldrasm
	 	./build/tp2 ldr -i asm ./img/bastachicos.${i}x${i}.bmp 100 -t 100 >>ldrasm
	done

	mv filtros/ldr_asm.asm filtros/ldr_asmV1.asm
	mv filtros/ldr_asmV2.asm filtros/ldr_asm.asm

	make clean
	make

	for (( i = 128; i < 1700; i=i+128 )); do
    	echo "corriendo filtro ldr asm V2 para una matriz de $i x $i"
		printf '%i   ' $(($i*$i)) >> ldrc
		./build/tp2 ldr -i asm ./img/bastachicos.${i}x${i}.bmp 100 -t 100 >>ldrc
	done

	mv filtros/ldr_asm.asm filtros/ldr_asmV2.asm
	mv filtros/ldr_asmV1.asm filtros/ldr_asm.asm

fi

if [[ $filtros = "cropflip" || $filtros == "all" ]]; then
	rm cropasm
	rm cropc
	echo $t
	for (( i = 128; i < 1700; i=i+128 )); do
    	echo "corriendo filtro cropflip c V1 para una matriz de $i x $i"
		printf '%i   ' $(($i*$i)) >> cropasm
		t=$i-128
		./build/tp2 cropflip -i c ./img/bastachicos.${i}x${i}.bmp 128 128 $t $t -t 100 >>cropasm
	done

	mv filtros/cropflip_c.c filtros/cropflip_cV1.c
	mv filtros/cropflip_cV2.c filtros/cropflip_c.c

	make clean
	make

	for (( i = 128; i < 1700; i=i+128 )); do
     	echo "corriendo filtro cropflip c V2 para una matriz de $i x $i"
	 	printf '%i   ' $(($i*$i)) >> cropc
	 	t=$i-128
	 	./build/tp2 cropflip -i c ./img/bastachicos.${i}x${i}.bmp 128 128 $t $t -t 100 >>cropc
	done

	mv filtros/cropflip_c.c filtros/cropflip_cV2.c
	mv filtros/cropflip_cV1.c filtros/cropflip_c.c

fi
rm bastachicos.*
if [[ $filtros = "none" ]]; then
	rm sepiac
	rm sepiasm
	rm ldrc
	rm ldrasm
	rm cropc
	rm cropasm
	make clean
fi

	 	# done

	  #python GraficarBarras.py Sepia
