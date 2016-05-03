#!/bin/bash

LC_NUMERIC="en_US.UTF-8"

radios="1 2 3 4 "$(seq 3 5 40)
sigma_fijo=5

sigmas=".5 1 1.5 "$(seq 3 3 48)" 50"
r_fijo=10

repeticiones=1
implementaciones="asm c"

verbose=false
while getopts 'n:vhcs:r:' opt; do
  case $opt in
    n) repeticiones=$OPTARG ;;
    v) verbose=true ;;
    h) echo ""
       echo "    Experimento 2. Se aplica el filtro ldr a una imagen fija, variando"
       echo "    primero el parámetro radio y luego el parámetro sigma, y midiendo el"
       echo "    tiempo de cada ejecución."
       echo ""
       echo "    Opciones disponibles:"
       echo "        -c        Elimina los archivos generados por el experimento."
       echo "        -h        Imprime este texto de ayuda."
       echo "        -n <núm>  Determina la cantidad de veces que se realizará el expe-"
       echo "                    rimento (1 por defecto)."
       echo "        -v        Muestra más información por pantalla."
       echo "        -s        Determina el valor del parámetro sigma (5 por defecto)."
       echo "        -r        Determina el valor del parámetro radio (10 por defecto)."
       echo ""
       exit 0 ;;
    c) if [ -d $(dirname $0)/exp2 ]; then rm $(dirname $0)/exp2 -R; fi
       exit 0 ;;
    s) sigma_fijo=$OPTARG ;;
  esac
done

echo "Compilando..."
make -s -C $(dirname $0)/..
if [ $? -ne 0 ]; then
    echo "ERROR: Error de compilación."
    exit 1
fi

echo "Generando datos de entrada..."
mkdir -p $(dirname $0)/exp2/in
convert $(dirname $0)/../img/bastachicos1.bmp -scale 600x600 $(dirname $0)/exp2/in/bastachicos1-600.bmp
if [ $? -ne 0 ]; then
    echo "ERROR: Error generando datos de entrada."
    exit 1
fi

# Parte A (según radio)

echo "Corriendo etapa A (radio variable)..."

for imp in $implementaciones; do
    mkdir -p $(dirname $0)/exp2/a/out/ldr-$imp
    echo "   Implementación: $imp   Imagen: bastachicos1   Sigma: $sigma_fijo"
    printf "%d\n" $repeticiones >> $(dirname $0)/exp2/a-data-ldr-$imp.txt
    for r in $radios; do
        printf "%d" "$r" >> $(dirname $0)/exp2/a-data-ldr-$imp.txt
        if [ "$verbose" = true ]; then
            echo "  Corriendo instancia r = $r"
        fi
        for k in $(seq $repeticiones); do
            $(dirname $0)/../build/tp2 ldr -i $imp -o $(dirname $0)/exp2/a/out/ldr-$imp $(dirname $0)/exp2/in/bastachicos1-600.bmp $sigma_fijo $r |
                sed -e '/insumidos totales/!d' -e 's/.*: //' |
                while IFS= read -r line; do
                    if [ "$verbose" = true ]; then
                        printf "    Radio: %8s.    Tiempo insumido: %12s\n" "$r" "$line"
                    fi
                    printf " %d" "$line" >> $(dirname $0)/exp2/a-data-ldr-$imp.txt
                done
            n1=$($(dirname $0)/../build/tp2 ldr -i $imp -n $(dirname $0)/exp2/in/bastachicos1-600.bmp)
            n2=$(echo $n1 | sed -e "s/.bmp$/.$sigma_fijo.$r.bmp/")
            # mv $(dirname $0)/exp2/a/out/ldr-$imp/$n1 $(dirname $0)/exp2/a/out/ldr-$imp/$n2
            rm $(dirname $0)/exp2/a/out/ldr-$imp/$n1
        done
        printf "\n" >> $(dirname $0)/exp2/a-data-ldr-$imp.txt
    done
done

# Parte B (según sigma)

echo "Corriendo etapa B (sigma variable)..."

for imp in $implementaciones; do
    mkdir -p $(dirname $0)/exp2/b/out/ldr-$imp
    echo "   Implementación: $imp   Imagen: bastachicos1   Radio: $r_fijo"
    printf "%d\n" $repeticiones >> $(dirname $0)/exp2/b-data-ldr-$imp.txt
    for s in $sigmas; do
        printf "%.2g" "$s" >> $(dirname $0)/exp2/b-data-ldr-$imp.txt
        if [ "$verbose" = true ]; then
            echo "  Corriendo instancia sigma = $s"
        fi
        for k in $(seq $repeticiones); do
            $(dirname $0)/../build/tp2 ldr -i $imp -o $(dirname $0)/exp2/b/out/ldr-$imp $(dirname $0)/exp2/in/bastachicos1-600.bmp $s $r_fijo |
                sed -e '/insumidos totales/!d' -e 's/.*: //' |
                while IFS= read -r line; do
                    if [ "$verbose" = true ]; then
                        printf "    Sigma: %8s.    Tiempo insumido: %12s\n" "$s" "$line"
                    fi
                    printf " %d" "$line" >> $(dirname $0)/exp2/b-data-ldr-$imp.txt
                done
            n1=$($(dirname $0)/../build/tp2 ldr -i $imp -n $(dirname $0)/exp2/in/bastachicos1-600.bmp)
            n2=$(echo $n1 | sed -e "s/.bmp$/.$s.$r_fijo.bmp/")
            # mv $(dirname $0)/exp2/b/out/ldr-$imp/$n1 $(dirname $0)/exp2/b/out/ldr-$imp/$n2
            rm $(dirname $0)/exp2/b/out/ldr-$imp/$n1
        done
        printf "\n" >> $(dirname $0)/exp2/b-data-ldr-$imp.txt
    done
done
