#!/bin/bash -x

echo "Greetings $USER 🦋"

echo "This script allows you to do multiple shell tasks in one! 
Press 'j' to make jps from tifs in tiff-process folder 
Press 't' to autocrop tifs in tiff-process folder
Press 'c' to autocrop jpgs in jpg-process folder
Press 'm' to add 40px margin to fullsize jpgs
Press 'r' to resize jpgs and make mids in cropped folder
Press 'q' to quit"

while [[ ! $REPLY =~ ^[Qq]$ ]]; do
    read -p "Please make a selection: " -n 1 -r
    echo    # move to a new line

    case $REPLY in
        [Jj])
            # Make tiff-process folder if it does not already exist
            mkdir -p ~/Desktop/helpers/tiff-process

            # Update total files count 
            files=~/Desktop/helpers/tiff-process/*.tif
            total_files=$(ls -1 ~/Desktop/helpers/tiff-process/*.tif 2>/dev/null | wc -l)
            current_file=0 

            # Convert TIFFs to JPGs
            for file in ~/Desktop/helpers/tiff-process/*.tif; do
                printf "\r🔁🔁 Converting %d of %d TIFFs to JPGs\033[K" "$((++current_file))" "$total_files"
                convert "$file" -flatten "${file%.tif}.jpg" 2>/dev/null
                [[ $? -ne 0 ]] && printf "\n❗❗Error converting $file\n"
            done

            # Move JPGs to jpg-process folder if any were created
            if [[ -n $(ls ~/Desktop/helpers/tiff-process/*.jpg 2>/dev/null) ]]; then
                mkdir -p ~/Desktop/helpers/jpg-process && mv ~/Desktop/helpers/tiff-process/*.jpg ~/Desktop/helpers/jpg-process/
                echo    
                echo ⭐ Jpgs created, see jpg-process folder.
            else
                echo ❌ No JPGs were created.
            fi
            ;;

            [Tt])
            mkdir -p ~/Desktop/helpers/tiff-cropped && cp -R ~/Desktop/helpers/tiff-process/*.tif ~/Desktop/helpers/tiff-cropped/
            echo 📁 Files copied and moved to tiff-cropped folder. 
            echo 📄✂️ Now on to cropping! hold please 👼
            
            # Update total files count 
            files=~/Desktop/helpers/tiff-cropped/*.tif
            total_files=$(ls -1 ~/Desktop/helpers/tiff-cropped/*.tif 2>/dev/null | wc -l)
            current_file=0

            for file in ~/Desktop/helpers/tiff-cropped/*.tif; do
                printf "\r🔁🔁 Cropping %d of %d tiffs\033[K" "$((++current_file))" "$total_files"

                # Create a temp working copy
                tmpfile="/tmp/__cleaned_$(basename "$file")"
                
                # Clean the background:
                # 1. Normalize slight background tones
                # 2. Use morphology to close gaps
                # 3. Convert back to solid white

                convert "$file" \
                    -fuzz 8% -fill white -draw "color 0,0 floodfill" \  # flood fill from top-left to get rid of faint gray
                    -morphology Close Disk:2 \                           # closes small gaps and specks
                    -flatten "$tmpfile"

                # Now apply your original crop operation on the cleaned temp image
                mogrify -bordercolor white -fuzz 3% -trim +repage -border 8x8 "$tmpfile" 2>/dev/null

                # Overwrite the original with the cleaned & cropped version
                mv "$tmpfile" "$file"
                
                [[ $? -ne 0 ]] && printf "\n❗❗Error processing $file\n"
            done

            echo
            echo 🪴 Cropping complete! 
            echo
            ;;
        
        
        [Cc])
            # Rename extensions to .jpg and move files to cropped folder
            for file in ~/Desktop/helpers/jpg-process/*; do
                mv "$file" "${file/.jpeg/.jpg}" 2>/dev/null
            done
            echo 🦩 Extensions renamed to .jpg.
            mkdir -p ~/Desktop/helpers/cropped && cp -R ~/Desktop/helpers/jpg-process/*.jpg ~/Desktop/helpers/cropped/
            echo 📁 Files copied and moved to cropped folder. 
            echo 🪨🔨 Now on to cropping! hold please ☺ 
            
            # Update total files count 
            files=~/Desktop/helpers/cropped/*.jpg
            total_files=$(ls -1 ~/Desktop/helpers/cropped/*.jpg 2>/dev/null | wc -l)
            current_file=0

            for file in ~/Desktop/helpers/cropped/*.jpg; do
                printf "\r🔁🔁 Cropping %d of %d jpgs\033[K" "$((++current_file))" "$total_files"
                mogrify -bordercolor white -fuzz 3% -trim +repage -border 8x8 "$file" 2>/dev/null
                [[ $? -ne 0 ]] && printf "\n❗❗Error cropping $file\n"
            done 
            echo
            echo 🌻 Cropping complete! 
            echo
            ;;
        [Mm])
            # Add 40px margin to all cropped jpgs 
            mkdir -p ~/Desktop/helpers/cropped-margin && cp -R ~/Desktop/helpers/cropped/*.jpg ~/Desktop/helpers/cropped-margin/
            echo 🪟🔖 Now to add 40px margin, hold please 🌅 

            # Update total files count 
            files=~/Desktop/helpers/cropped-margin/*.jpg
            total_files=$(ls -1 ~/Desktop/helpers/cropped-margin/*.jpg 2>/dev/null | wc -l)
            current_file=0

            for file in ~/Desktop/helpers/cropped-margin/*.jpg; do
                printf "\r🔁🔁 Adjusting %d of %d jpgs\033[K" "$((++current_file))" "$total_files"
                convert "$file" -bordercolor white -border 40x40 "$file" 2>/dev/null
                [[ $? -ne 0 ]] && printf "\n❗❗Error adjusting margins on $file\n"
            done        
            echo -e "\n🌲 Image now include 40px margin. See cropped-margins folder for files\n"  
            ;;
        
        [Rr])
            # Resize and make mids
            mkdir -p ~/Desktop/helpers/oa && cp -R ~/Desktop/helpers/cropped/*.jpg ~/Desktop/helpers/oa/
            echo 🪚🪵 Now on to downsizing, hold please 🐗

            # Update total files count 
            files=~/Desktop/helpers/oa/*.jpg
            total_files=$(ls -1 ~/Desktop/helpers/oa/*.jpg 2>/dev/null | wc -l)
            current_file=0

            for file in ~/Desktop/helpers/oa/*.jpg; do
                printf "\r🔁🔁 Resizing %d of %d jpgs\033[K" "$((++current_file))" "$total_files"
                cp -n "${file}" "${file%.*}_mid.jpg"
                mogrify -resize 800x800\> "${file%.*}_mid.jpg" 2>/dev/null
                mogrify -resize 3000x3000\> "$file" 2>/dev/null
                [[ $? -ne 0 ]] && printf "\n❗❗Error resizing $file\n"
            done        
            echo
            echo 🌲 All images resized at 3000px and 800px mids created. See oa folder for files 
            echo 
            ;;
        [Qq])
            echo 🦩 Quitting now 
            ;;
        *)
            echo -e "Invalid selection. 
            \nPress 'j' to make jps from tifs in tiff-process folder 
            \nPress 't' to autocrop tifs in tiff-process folder
            \nPress 'c' to autocrop jps in jpg-process folder
            \n Press 'm' to add 40px margin to fullsize jpgs
            \nPress 'r' to resize jpgs and make mids in cropped folder
            \nPress 'q' to quit"
            ;;
    esac
done