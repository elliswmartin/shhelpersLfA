#!/bin/bash -x

echo greetings "$USER" 🦋 

echo "This script allows you to do multiple shell tasks in one! 
 Press 'j' to make jps from tifs in crop folder 
 Press 'c' to autocrop jps in crop folder
 Press 'r' to resize jpgs and make mids in qc folder
 Press 'q' to quit"

while [[ ! $REPLY =~ ^[Qq]$ ]] 
do

# # store count for later conditional testing
# COUNT=$(ls /Users/$USER/Desktop/helpers/process/*.jpg 2>/dev/null| wc -l) 

read -p "Please make a selection: " -n 1 -r
echo    # (optional) move to a new line

# make jpgs
if [[ $REPLY =~ ^[Jj]$ ]]
then
    # make tiff-process folder if does not already exist
    mkdir -p ~/Desktop/helpers/tiff-process
    cd ~/Desktop/helpers/tiff-process/

    echo 🪄creating jpgs, hold please 🚀

    # create flattened jpgs from tiffs
    mogrify -flatten -format jpg *.tif

    # copy files from source to destination, make jpg-process folder if it doesn't exist
    mkdir -p ~/Desktop/helpers/jpg-process && mv ~/Desktop/helpers/tiff-process/*.jpg ~/Desktop/helpers/jpg-process/

    echo ⭐jpgs created, see jpg-process folder. 

# autocrop
elif [[ $REPLY =~ ^[Cc]$ ]]
then
    # change any ".jpeg" file extensions to ".jpg"
    for file in ~/Desktop/helpers/jpg-process/*
    do
    mv "$file" "${file/.jpeg/.jpg}"
    done

    echo 🦩 extensions renamed to .jpg.
    cd ~/Desktop/helpers/

    # copy files from source to destination, make processed folder if it doesn't exist
    mkdir -p ~/Desktop/helpers/processed && cp -R ~/Desktop/helpers/jpg-process/*.jpg ~/Desktop/helpers/processed/


    echo 📁 files copied and moved to destination folder. 
    echo 🪨🔨 now on to cropping! hold please ☺ 

    cd ~/Desktop/helpers/processed

    # trim images using ImageMagick
    mogrify -bordercolor white -fuzz 3% -trim +repage *.jpg

    echo 🌻 cropping complete! 
    cd ~/Desktop/helpers

# resize and make mids
elif [[ $REPLY =~ ^[Rr]$ ]]
then
    # store count for later conditional testing
    COUNT=$(ls /Users/$USER/Desktop/helpers/processed/*.jpg 2>/dev/null| wc -l) 

    # check to make sure processed folder exists
    if [[ ! -d "/Users/$USER/Desktop/helpers/processed" ]] && echo "🎱 directory /Desktop/helpers/processed/ does not exist."
        then 
        break
    # check to make sure processed folder contains jpg files
    elif [[ $COUNT -eq 0 ]] && echo "🪞 processed folder does not contain jpgs."
        then
        break 
    # process if 2 conditionals above are met    
    else
        # copy files from source to destination, make oa folder if it doesn't exist
        mkdir -p ~/Desktop/helpers/oa && cp -R ~/Desktop/helpers/processed/*.jpg ~/Desktop/helpers/oa/
        echo 🪚🪵 now on to downsizing, hold please 🐗

        cd ~/Desktop/helpers/oa

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

        echo "🌊 processing complete! see oa folder for files"
    fi
elif [[ $REPLY =~ ^[Qq]$ ]]
then
    echo 🦩 quitting now 
else
    echo "Invalid selection. 
     Press 'j' to make jps from tifs in crop folder 
     Press 'c' to autocrop jps in crop folder
     Press 'r' to resize jpgs and make mids in qc folder
     Press 'q' to quit"

fi
done # close while loop