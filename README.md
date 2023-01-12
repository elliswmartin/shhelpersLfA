# shhelpersLfA
 Small bash tasks around Letterform Archive.

# How It Works

This script uses bash to ___________ command line user input to customize each script execution. 

The script continues to prompt the user until "q" character is pressed: 

    $ while [[ ! $REPLY =~ ^[Qq]$ ]] 

Each letter corresponds to a different process, of which the code is copied exactly from the 2 scripts above and [autocrop](https://github.com/elliswmartin/autocropLfA/blob/85c9591d4c998e8d62e71494234da52d38808b6a/autocrop.sh): 

* `j`: Tifs in `crop` folder are turned into jpgs.
* `c`: Jpgs in `crop` folder are copied to qc and then the background is cropped out. 
* `r`: Jpgs in `qc` folder are resized to 3000px on longest side, and mid files are created (800px copies of orig files)    
* `q`: Quits the script. 

For example, if 'j' is pressed: 

```
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
```

## Make Jpgs

This script utilizes ImageMagick's mogrify command to create jpg copies of tif files. 

    $ mogrify -flatten -format jpg *.tif


## Autocrop

This script uses ImageMagick mogrify program to crop a jpg file and overwrite it. Since the masked background can be visually distinguished from the object, this became the way to custom crop each image based on color difference rather than size.

    $ mogrify -bordercolor white -fuzz 3% -trim +repage *.jpg

Various aspects of the code will be highlighted below.

`-bordercolor white:` Sets the border color to be trimmed to white.

`-fuzz 3%:` Adjusts what is considered white based on a percentage.

`-trim:` Crop function.

`+repage:` Resets the image virtual canvas to the actual image.

`*.jpg:` Sets the file format as jpg

`-resize 3000x3000\>:` Resizes image to 3000 pixels on longest size, does not change aspect ratio, does not upscale. 

Additional mogrify arguments to consider: 

`-deskew 10%:` Deskews the image.

`-type TrueColor:` Forces image to be saved as a full color RGB.

`-strip:` Removes xmp file in instances where thumbnail is not adjusting to cropped image.  


Depending on which program is used to convert from tiff to jpg, some produce a file extension of '.jpg' and others '.jpeg'. The for loop below changes all .jpeg extensions to .jpg so they can be ingested into LfA's [Online Archive](oa.letterformarchive.org). 

    for file in ~/Desktop/crop/*
        do
    mv "$file" "${file/.jpeg/.jpg}"
    done

Prompts the user to perform quality control, and asks if they'd like to downscale to 3000 pixels on the longest size of the image. Adapted from [Dennis Williamson](https://stackoverflow.com/questions/19306771/how-can-i-get-the-current-users-username-in-bash)'s SE code snippet. 

    read -p "❗pausing for QC, would you like to resize to 3000px?" -n 1 -r
    echo    # (optional) move to a new line
    if [[ ! $REPLY =~ ^[Nn]$ ]]
    then
        echo 🪚🪵 now on to downsizing, hold please 🛸
        mogrify -resize 3000x3000\> *.jpg 
        echo 🌱 all images resized. 
    fi

## Resize & Mids

This script uses bash to prepare jpg files for the Online Archive. To do this, it performs a few tasks:

1. Resize existing jpgs to 3000 pixels on the longest side. 

       $ mogrify -resize 3000x3000\> *.jpg  
   
2. Copy files and append '_mid' to the end of existing filename before file extension.  

       for f in *[0-9].jpg  
          do 
            cp -n "${f}" "${f%.*}_mid.jpg"
       done

3. Resize new mid files to 800 pixels on the longest side. 

       mogrify -resize 800x800\> *_mid.jpg

4. Moves files to the `processed` folder when editing complete. 

# Usage (Mac Only)

## Script Setup

* Copy repository to local machine using Terminal.

       $ cd /PATH/TO/WHERE/YOU/STORE/SCRIPTS

       $ git clone https://github.com/elliswmartin/shhelpersLfA/

* OR, navigate to repository folder and pull updated repo using Terminal.  

       $ cd /PATH/TO/THIS/REPO 
    
       $ git pull

## Folder Structure

This script ships assuming the following folder structure. You are welcome to modify this for your needs within the `helpersLfA.sh` script. 

        ├── Desktop
        │   ├── crop
        │   ├── qc
        │   ├── processed

## Prepare Files

### Make Jpgs

Copy tif files that you would like to copy to jpgs into ~/Desktop/processed folder. 

### Autocrop

Add your images to be processed into the "/Desktop/crop" folder. If you do not have a qc folder, one will be created automatically during processing. 

### Resize & Mids

Copy files that you would like to resize and create mids (copies resized to 800px) into ~/Desktop/OA_process folder. 

### Run Script

1. Open Terminal and run `helpersLfA.sh`: 

        $ sh /PATH/TO/SCRIPT/helpersLfA.sh 

2. When prompted, enter a character in Terminal based on the process you would first like to run (see below for more details on the selections).  

3. Continue to select a process until you would like to quit.  
    
# Background 
I developed these scripts while working at Letterform Archive in San Francisco, CA to assist with automating small tasks and streamline existing workflows. 
