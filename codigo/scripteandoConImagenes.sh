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

if [[ $filtros = "ldr" || $filtros == "all" ]]; then
	rm ldrblanca
	rm ldrnegra
	rm ldrroja
	rm ldrmulti
	rm ldrverde
	rm ldrazul
	echo "corriendo filtro ldr asm para una imagen complentamente negra"
	./build/tp2 ldr -i asm ./img/blanca.bmp 100000 -t 250 >>ldrblanca

	echo "corriendo filtro ldr asm para una imagen copmletamente blanca"
	./build/tp2 ldr -i asm ./img/negra.bmp 100000 -t 250 >>ldrnegra

	echo "corriendo filtro ldr asm para una imagen completamente roja"
	./build/tp2 ldr -i asm ./img/roja.bmp 100000 -t 250 >>ldrroja

	echo "corriendo filtro ldr asm para una imagen multicolor"
	./build/tp2 ldr -i asm ./img/colores.bmp 100000 -t 250 >>ldrmulti

	echo "corriendo filtro ldr asm para una imagen verde"
        ./build/tp2 ldr -i asm ./img/verde.bmp 100000 -t 250 >>ldrverde

	echo "corriendo filtro ldr asm para una imagen azul"
        ./build/tp2 ldr -i asm ./img/azul.bmp 100000 -t 250 >>ldrazul


fi

rm blanca.*
rm negra.*
rm roja.*
rm colores.*
rm verde.*
rm azul.*


if [[ $filtros = "none" ]]; then
	rm ldrc
	rm ldrasm
	rm ldrbn
	rm ldrmulti
	make clean
fi

	 	# done

	  #python GraficarBarras.py Sepia
