#!/bin/bash 
# Przykład konwersji wyrenderowanego pliku PNG na 16-kolorowy IFF w rozdzielczości ECS
#echo $
convert $1 -resize 640x512\!  -dither FloydSteinberg -colors 8 ${2%.*}_floyd.ilbm

#Riemersma
convert $1 -resize 640x512\! -colors 16 -depth 4 -dither Riemersma ${2%.*}_rie.ilbm


#HAM 

convert "$1" -resize 320x256\! ppm:- | ppmtoilbm -ham > "${2%.*}_ham.ilbm"
