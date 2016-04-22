#!/bin/bash
if [[ $# -ne 1 ]]; then
    echo "Usage: $0 img.bmp";
    echo "Checks if the image is an rgba 8b uncompressed bmp"
    exit 1;
fi

FILE="$(file "$1")"
CHAN="$(identify -format '%[channels]' "$1")"
DEPTH="$(identify -format '%[depth]' "$1")"
WIDTH="$(identify -format '%w' "$1")"

if [[ ! $FILE =~ "PC bitmap" ]]; then
    echo "Invalid format"
    echo $FILE
    exit 2;
fi
if [[ ! $CHAN == "srgb" ]]; then
    echo "Invalid channels: $CHAN"
    exit 3;
fi
if [[ ! $DEPTH == "8" ]]; then
    echo "Invalid depth: ${DEPTH}b"
    exit 4;
fi
if [[ ! $(expr $WIDTH % 8) == "0" ]]; then
    echo "Invalid width (${WIDTH}px). It must be a multiple of 8"
    exit 5;
fi

echo "Valid file"

