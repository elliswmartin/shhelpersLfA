#!/bin/bash -x

echo greetings "$USER" 🦋 

COUNT=$(ls /Users/$USER/Desktop/qc/*.jpg | wc -l) # store count for later condition testing

echo "This script allows you to do multiple shell tasks in one! 
 Press 'j' for makeJpg.sh 
 Press 'c' for autocrop.sh 
 Press 'r' for resize.sh 
 Press 'q' to quit"

while [[ ! $REPLY =~ ^[Qq]$ ]] 
do

read -p "Please make a selection: " -n 1 -r
echo    # (optional) move to a new line

# make jpgs
if [[ $REPLY =~ ^[Jj]$ ]]
then
    # make crop folder if does not already exist
    cd ~/Desktop/ && mkdir -p "crop" 
    cd ~/Desktop/crop/

    echo 🪄creating jpgs, hold please 🚀

    # create flatten jpgs from tiffs
    mogrify -flatten -format jpg *.tif

    echo ⭐jpgs created, processing complete. 

# autocrop
elif [[ $REPLY =~ ^[Cc]$ ]]
then
    # change any ".jpeg" file extensions to ".jpg"
    for file in ~/Desktop/crop/*
    do
    mv "$file" "${file/.jpeg/.jpg}"
    done

    echo 🦩 extensions renamed to .jpg.
    cd ~/Desktop/

    # copy files from source to destination, make qc folder if it doesn't exist
    mkdir -p "qc" && cp -R ~/Desktop/crop/*.jpg ~/Desktop/qc/

    echo 📁 files copied and moved to destination folder. 
    echo 🪨🔨 now on to cropping! hold please ☺ 

    cd ~/Desktop/qc

    # trim images using ImageMagick
    mogrify -bordercolor white -fuzz 3% -trim +repage *.jpg

    echo 🌻 cropping complete! 
    cd ~/Desktop/

# resize and make mids
elif [[ $REPLY =~ ^[Rr]$ ]]
then
    # check to make sure qc folder exists
    if [[ ! -d "/Users/$USER/Desktop/qc" ]] && echo "🎱 directory /Desktop/qc/ does not exist."
        then 
        break
    # check to make sure qc folder contains jpg files
    elif [[ $COUNT == 0 ]] && echo "🪞 QC folder does not contain jpgs."
        then
        break 
    # prcoess if 2 conditionals above are met    
    else
        cd ~/Desktop/qc
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

        cd ~/Desktop/qc
        mv * ~/Desktop/processed/

        echo "🌊 processing complete! see processed folder for files"
    fi
elif [[ $REPLY =~ ^[Qq]$ ]]
then
    echo 🦩 quitting now 
else
    echo "Invalid selection. 
    Press 'j' for makeJpg.sh 
    Press 'c' for autocrop.sh 
    Press 'r' for resize.sh 
    Press 'q' to quit"

fi
done # close while loop