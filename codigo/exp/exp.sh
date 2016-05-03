#!/bin/bash

repeticiones=1
verbose=""
ejecutar=true
clean=false
experimentos="1 2 3 4"
while getopts 'cCe:ghn:rv' opt; do
  case $opt in
  	c) clean=true ;;
    e) experimentos=$(echo $OPTARG | sed s/,/\\n/g) ;;
    C) for i in $experimentos; do
           if [ -d $(dirname $0)/exp$i ]; then rm $(dirname $0)/exp$i -R; fi
       done
       exit 0 ;;
	  g) ejecutar=false ;;
    h) echo ""
       echo "    Ejecuta todos los experimentos y realiza los gráficos correspondientes."
       echo ""
       echo "    Opciones disponibles:"
       echo "        -c        Ejecuta los experimentos, eliminando los archivos interme-"
       echo "                    dios generados."
       echo "        -C        Elimina los archivos intermedios generados por todos los"
       echo "                    experimentos."
       echo "        -e        Lista, separada por comas, de los números de experimentos a"
       echo "                    ejecutar. Disponibles: 1, 2, 3 y 4. Por defecto se ejecutan"
       echo "                    todos."
       echo "        -g        Genera los gráficos a partir de la información existente,"
       echo "                    sin ejecutar los experimentos."
       echo "        -h        Imprime este texto de ayuda."
       echo "        -n <núm>  Determina la cantidad de veces que se repetirá cada experi-"
       echo "                    mento (1 por defecto)."
       echo "        -r        Elimina todos los resultados y gráficos obtenidos."
       echo "        -v        Muestra más información por pantalla."
       echo ""
       exit 0 ;;
    n) repeticiones=$OPTARG ;;
    r) if [ -d $(dirname $0)/graficos ]; then rm $(dirname $0)/graficos -R; fi
       if [ -d $(dirname $0)/resultados ]; then rm $(dirname $0)/resultados -R; fi
       exit 0 ;;
    v) verbose="-v" ;;
  esac
done

for i in $(seq 3); do
	if [[ $experimentos =~ ${i} ]] ; then
		if [ "$ejecutar" = true ]; then
			$(dirname $0)/exp${i}.sh -n $repeticiones $verbose
		fi
		octave -q $(dirname $0)/exp${i}.m
		if [ "$clean" = true ]; then
			$(dirname $0)/exp${i}.sh -c
		fi
	fi
done
