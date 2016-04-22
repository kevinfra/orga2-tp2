#!/bin/bash
if [[ $# -ne 2 ]]; then
    echo "Usage: $0 src.ext dst.bmp";
    echo "Converts the src image to an rgba 8b uncompressed bmp"
    exit 1;
fi

# Resize the image's width to the nearest multiple of 8
width="$(identify -format '%w' "$1")"
newWidth="$(expr $width - $width % 8)"

convert "$1" -resize ${newWidth}x -colorspace rgb -type TrueColor \
   -channel rgb -depth 8 -alpha on -compress none "BMP3:$2"

