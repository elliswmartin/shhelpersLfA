#!/bin/bash -x

echo greetings "$USER" 🦋 

echo "This script allows you to do multiple shell tasks in one! 
 Press 'j' to make jps from tifs in tiff-process folder 
 Press 'c' to autocrop jps in jpg-process folder
 Press 'r' to resize jpgs and make mids in cropped folder
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
    # store count for print statement
    files=(*.tif)
    total_files=${#files[@]} 
    echo 🪄 Creating jpgs, hold please 🚀

    for file in *.tif
    do
        current_file=$((current_file + 1))
        printf "\r🔁🔁 Making %d of %d jpgs\033[K" "$current_file" "$total_files"
        # create flattened jpgs from tiffs
        mogrify -flatten -format jpg "$file" 2>/dev/null
        if [[ $? -ne 0 ]]; then
            echo "Error processing $file"
        fi
    done 
    echo
    # copy files from source to destination, make jpg-process folder if it doesn't exist
    mkdir -p ~/Desktop/helpers/jpg-process && mv ~/Desktop/helpers/tiff-process/*.jpg ~/Desktop/helpers/jpg-process/

    echo ⭐ Jpgs created, see jpg-process folder. 
    echo

# autocrop
elif [[ $REPLY =~ ^[Cc]$ ]]
then
    # change any ".jpeg" file extensions to ".jpg"
    for file in ~/Desktop/helpers/jpg-process/*
    do
        mv "$file" "${file/.jpeg/.jpg}" 2>/dev/null
    done

    echo 🦩 extensions renamed to .jpg.
    cd ~/Desktop/helpers/

    # copy files from source to destination, make processed folder if it doesn't exist
    mkdir -p ~/Desktop/helpers/cropped && cp -R ~/Desktop/helpers/jpg-process/*.jpg ~/Desktop/helpers/cropped/
    
    echo 📁 Files copied and moved to cropped folder. 
    echo 🪨🔨 Now on to cropping! hold please ☺ 

    cd ~/Desktop/helpers/cropped
    # store count for print statement
    files=(*.jpg)
    total_files=${#files[@]}
    current_file=0 
    for file in *.jpg
    do
        current_file=$((current_file + 1))
        printf "\r🔁🔁 Cropping %d of %d jpgs\033[K" "$current_file" "$total_files"
        mogrify -bordercolor white -fuzz 3% -trim +repage "$file" 2>/dev/null
        if [[ $? -ne 0 ]]; then
            echo "Error processing $file"
        fi
    done 
    echo
    echo 🌻 Cropping complete! 
    cd ~/Desktop/helpers
    echo

# resize and make mids
elif [[ $REPLY =~ ^[Rr]$ ]]
then
    cd ~/Desktop/helpers/cropped

    # store count for print statement
    files=(*.jpg)
    total_files=${#files[@]}
    current_file=0 

    # check to make sure cropped folder exists
    if [[ ! -d "/Users/$USER/Desktop/helpers/cropped" ]] && echo "🎱 directory /Desktop/helpers/cropped/ does not exist."
        then 
        break
    # check to make sure cropped folder contains jpg files
    elif [[ $total_files -eq 0 ]] && echo "🪞 cropped folder does not contain jpgs."
        then
        break 
    # process if 2 conditionals above are met    
    else
        # copy files from source to destination, make oa folder if it doesn't exist
        mkdir -p ~/Desktop/helpers/oa && cp -R ~/Desktop/helpers/cropped/*.jpg ~/Desktop/helpers/oa/
        echo 🪚🪵 Now on to downsizing, hold please 🐗

        cd ~/Desktop/helpers/oa

        for f in *.jpg  
            do 
            current_file=$((current_file + 1))
            printf "\r🔁🔁 Resizing %d of %d jpgs\033[K" "$current_file" "$total_files"
            # resize to 3000 pixels on longest side, does not upscale. 
            mogrify -resize 3000x3000\> *.jpg 2>/dev/null
            if [[ $? -ne 0 ]]; then
                echo "Error processing $file"
            fi
        done        

        echo 🌲 All images resized at 3000px. 

        # copy files, add '_mid' to filename and resize to 800 px on longest side.
        for f in *[0-9].jpg  # only process non-mid files
            do 
                cp -n "${f}" "${f%.*}_mid.jpg"
                mogrify -resize 800x800\> *_mid.jpg 2>/dev/null
        done        
        echo 🌱 800px mids created. 

        echo "🌊 processing complete! see oa folder for files"
        echo 
    fi
elif [[ $REPLY =~ ^[Qq]$ ]]
then
    echo 🦩 quitting now 
else
    echo "Invalid selection. 
        Press 'j' to make jps from tifs in tiff-process folder 
        Press 'c' to autocrop jps in jpg-process folder
        Press 'r' to resize jpgs and make mids in cropped folder
        Press 'q' to quit"

fi
done # close while loop