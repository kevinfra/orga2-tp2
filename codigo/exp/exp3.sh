#!/bin/bash

tamanos="1800 1644 1500 1344 1200 1044 900 744 600 480 300 240 180 120 96 60 48 36 24"
repeticiones=1
imp_sepia="c c2"
imp_ldr="asm asm2"
filtros="both"

verbose=false
while getopts 'n:vhcf:i:' opt; do
  case $opt in
    n) repeticiones=$OPTARG ;;
    v) verbose=true ;;
    h) echo ""
       echo "    Experimento 3. Se calcula el tiempo de ejecución para todas las implementa-"
       echo "    ciones de ambos filtros, variando el tamaño de la imagen de entrada."
       echo ""
       echo "    Opciones disponibles:"
       echo "        -c        Elimina los archivos generados por el experimento."
       echo "        -f <ldr|sepia|both>    Filtro a ejecutar (ambos por defecto)."
       echo "        -h        Imprime este texto de ayuda."
       echo "        -i        Lista de las implementaciones de los filtros que se ejecuta-"
       echo "                  rán, separadas por comas. Valores posibles: c, asm, c2, asm2."
       echo "                  Por defecto, se ejecutarán las implementacions c y c2 de sepia"
       echo "                  y asm y asm2 de ldr."
       echo "        -n <núm>  Determina la cantidad de veces que se ejecutará cada imple-"
       echo "                    mentación (1 por defecto)."
       echo "        -v        Muestra más información por pantalla."
       echo ""
       exit 0 ;;
    c) if [ -d $(dirname $0)/exp3 ]; then rm $(dirname $0)/exp3 -R; fi
       exit 0 ;;
    f) filtros=$OPTARG ;;
    i) imp_sepia=$(echo $OPTARG | sed s/,/\\n/g) ; imp_ldr=$(echo $OPTARG | sed s/,/\\n/g) ;;
  esac
done

echo "Compilando..."
make -s -C $(dirname $0)/..
if [ $? -ne 0 ]; then
    echo "ERROR: Error de compilación."
    exit 1
fi

echo "Generando datos de entrada..."
mkdir -p $(dirname $0)/exp3/in
for i in $tamanos; do
    if [ ! -f $(dirname $0)/exp3/in/bastachicos1-$i.bmp ]; then
        if [ "$verbose" = true ]; then
            echo "  Generando archivo $(dirname $0)/exp3/in/bastachicos1-$i.bmp"
        fi
        convert $(dirname $0)/../img/bastachicos1.bmp -scale ${i}x${i} $(dirname $0)/exp3/in/bastachicos1-$i.bmp
    fi
    if [ ! -f $(dirname $0)/exp3/in/bastachicos2-$i.bmp ]; then
        if [ "$verbose" = true ]; then
            echo "  Generando archivo $(dirname $0)/exp3/in/bastachicos2-$i.bmp"
        fi
        convert $(dirname $0)/../img/bastachicos2.bmp -scale ${i}x${i} $(dirname $0)/exp3/in/bastachicos2-$i.bmp
    fi
done
if [ $? -ne 0 ]; then
    echo "ERROR: Error generando datos de entrada."
    exit 1
fi

echo "Corriendo instancias del experimento..."

# sepia
if [[ $filtros = "sepia" || $filtros == "both" ]]; then
    for imp in $imp_sepia; do
        mkdir -p $(dirname $0)/exp3/out/sepia-$imp
        echo "   Filtro: sepia   Implementación: $imp   Imágenes: bastachicos1, bastachicos2"
        printf "%d\n" $repeticiones >> $(dirname $0)/exp3/data-sepia-$imp.txt
        for i in $tamanos; do
            let "j=i*2/3"
            let "t=i*j"
            if [ "$verbose" = true ]; then
                echo "  Corriendo instancia ${i}×${j}"
            fi
            printf "%d" "$t" >> $(dirname $0)/exp3/data-sepia-$imp.txt
            for k in $(seq $repeticiones); do
                $(dirname $0)/../build/tp2 sepia -i $imp -o $(dirname $0)/exp3/out/sepia-$imp $(dirname $0)/exp3/in/bastachicos1-$i.bmp $(dirname $0)/exp3/in/bastachicos2-$i.bmp |
                    sed -e '/insumidos totales/!d' -e 's/.*: //' |
                    while IFS= read -r line; do
                        if [ "$verbose" = true ]; then
                            printf "    Tamaño: %8s.    Tiempo insumido: %12s\n" "$t" "$line"
                        fi
                        printf " %d" "$line" >> $(dirname $0)/exp3/data-sepia-$imp.txt
                    done
                    nombre=$($(dirname $0)/../build/tp2 sepia -i $imp -n $(dirname $0)/exp3/in/bastachicos1-$i.bmp $(dirname $0)/exp3/in/bastachicos2-$i.bmp)
                    rm $(dirname $0)/exp3/out/sepia-$imp/$nombre
            done
            printf "\n" >> $(dirname $0)/exp3/data-sepia-$imp.txt
        done
    done
fi

# ldr
if [[ $filtros = "ldr" || $filtros == "both" ]]; then
    for imp in $imp_ldr; do
        mkdir -p $(dirname $0)/exp3/out/ldr-$imp
        echo "   Filtro: ldr   Implementación: $imp   Imagen: bastachicos1"
        printf "%d\n" $repeticiones >> $(dirname $0)/exp3/data-ldr-$imp.txt
        for i in $tamanos; do
            let "j=i*2/3"
            let "t=i*j"
            if [ "$verbose" = true ]; then
                echo "  Corriendo instancia ${i}×${j}"
            fi
            printf "%d" "$t" >> $(dirname $0)/exp3/data-ldr-$imp.txt
            for k in $(seq $repeticiones); do
                $(dirname $0)/../build/tp2 ldr -i $imp -o $(dirname $0)/exp3/out/ldr-$imp $(dirname $0)/exp3/in/bastachicos1-$i.bmp 100 |
                    sed -e '/insumidos totales/!d' -e 's/.*: //' |
                    while IFS= read -r line; do
                        if [ "$verbose" = true ]; then
                            printf "    Tamaño: %8s.    Tiempo insumido: %12s\n" "$t" "$line"
                        fi
                        printf " %d" "$line" >> $(dirname $0)/exp3/data-ldr-$imp.txt
                    done
                    nombre=$($(dirname $0)/../build/tp2 ldr -i $imp -n $(dirname $0)/exp3/in/bastachicos1-$i.bmp)
                    rm $(dirname $0)/exp3/out/ldr-$imp/$nombre
            done
            printf "\n" >> $(dirname $0)/exp3/data-ldr-$imp.txt
        done
    done
fi