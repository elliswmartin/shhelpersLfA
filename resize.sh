#!/bin/bash -x

cd ~/Desktop/OA_process
echo 🪚🪵 now on to downsizing, hold please 🐗

# resize to 3000 pixels on longest side, does not upscale. 
mogrify -resize 3000x3000\> *.jpg 

echo 🌲 all images resized at 3000px. 

# copy files, add '_mid' to filename and resize to 800 px on longest side.
for f in *[0-9].jpg  # only process non-mid files
    do 
        cp -n "${f}" "${f%.*}_mid.jpg"
done

echo 🌾 files duplicated, now downsizing to mids. 

mogrify -resize 800x800\> *_mid.jpg
echo 🌱 800px mids created. 

# make processed folder if it doesn't already exist
cd ~/Desktop/
mkdir -p "processed" 

cd ~/Desktop/OA_process
mv * ~/Desktop/processed/

echo "🌊 processing complete! see processed folder for files"