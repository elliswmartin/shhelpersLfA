#!/bin/bash -x

# add to folder where you want to resize to 3000 px on the longest edge.
# then run script in terminal

# TODO ask user input -- do you want to resize or make jpgs? 
# TODO -- put into 2 separate functions


echo 🪚🪵 now on to downsizing, hold please 🛸

# resize to 3000 pixels on the longest side, does not upscale. 
mogrify -resize 3000x3000\> *.jpg 
echo 🌱 all images resized. 



echo 🪄creating jpgs, hold please 🚀

# create flatten jpgs from tiffs
mogrify -flatten -format jpg *.tif

echo ⭐jpgs created, processing complete. 