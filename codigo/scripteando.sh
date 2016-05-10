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
    	echo "corriendo filtro sepia asm para una matriz de $i x $i"
		printf '%i   ' $(($i*$i)) >> sepiasm
		./build/tp2 sepia -i asm ./img/bastachicos.${i}x${i}.bmp -t 100 >>sepiasm
	done

	for (( i = 128; i < 1700; i=i+128 )); do
    	echo "corriendo filtro sepia c para una matriz de $i x $i"
		printf '%i   ' $(($i*$i)) >> sepiac
		./build/tp2 sepia -i c ./img/bastachicos.${i}x${i}.bmp -t 100 >>sepiac
	done
fi

if [[ $filtros = "ldr" || $filtros == "all" ]]; then
	rm ldrasm
	rm ldrc
	for (( i = 128; i < 1700; i=i+128 )); do
    	echo "corriendo filtro ldr asm para una matriz de $i x $i"
		printf '%i   ' $(($i*$i)) >> ldrasm
	 	./build/tp2 ldr -i asm ./img/bastachicos.${i}x${i}.bmp 100 -t 100 >>ldrasm
	done

	for (( i = 128; i < 1700; i=i+128 )); do
    	echo "corriendo filtro ldr c para una matriz de $i x $i"
		printf '%i   ' $(($i*$i)) >> ldrc
		./build/tp2 ldr -i c ./img/bastachicos.${i}x${i}.bmp 100 -t 100 >>ldrc
	done
fi

if [[ $filtros = "cropflip" || $filtros == "all" ]]; then
	rm cropasm
	rm cropc
	echo $t
	for (( i = 128; i < 1700; i=i+128 )); do
    	echo "corriendo filtro cropflip asm para una matriz de $i x $i"
		printf '%i   ' $(($i*$i)) >> cropasm
		t=$i-128
		./build/tp2 cropflip -i asm ./img/bastachicos.${i}x${i}.bmp 128 128 $t $t -t 100 >>cropasm
	done

	for (( i = 128; i < 1700; i=i+128 )); do
    	echo "corriendo filtro cropflip c para una matriz de $i x $i"
		printf '%i   ' $(($i*$i)) >> cropc
		t=$i-128
		./build/tp2 ldr -i c ./img/bastachicos.${i}x${i}.bmp 128 128 $t $t -t 100 >>cropc
	done
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
