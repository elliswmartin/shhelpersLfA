# shhelpersLfA
 Small bash tasks around Letterform Archive.

# How It Works

This script uses bash to execute various image processing tasks using command line user input to customize each task. 

After run, the script continues to prompt the user until "q" character is pressed: 

    $ while [[ ! $REPLY =~ ^[Qq]$ ]] 

Each letter corresponds to a different process that is further documented below: 

* `j`: **Make Jpgs** 
    * Tifs in crop folder are turned into jpgs.
* `c`: **Autocrop** 
    * Jpgs in crop folder are copied to qc folder and then background is cropped out
* `m`: **Margins**
    * Add 40 px margins around the outside of cropped fullsize jpgs.  
* `r`: **Resize & Mids** 
    * Jpgs in qc folder resized to 3000px on longest side, 800px mid copies created, and files moved to processed folder.   
* `q`: **Quit** 
    * Breaks while loop and quits the script

For example, if `j` is pressed: 

```
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
```

## Make Jpgs

This script utilizes ImageMagick's mogrify command to create jpg copies of tif files. 

    $ mogrify -flatten -format jpg *.tif

## Autocrop

This script also uses mogrify to crop a jpg file and overwrite it. Since the masked background can be visually distinguished from the object, this became the way to custom crop each image based on color difference rather than size.

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

    for file in ~/Desktop/helpers/jpg-process/*
        do
    mv "$file" "${file/.jpeg/.jpg}"
    done

## Margins
Create margins around cropped images for better edge visibility and increase usefulness in other Archive domains such as Publishing. 

## Resize & Mids

This script also uses bash to prepare jpg files for the Online Archive. To do this, it performs a few tasks:

1. Resize existing jpgs to 3000 pixels on the longest side. 

       $ mogrify -resize 3000x3000\> *.jpg  
   
2. Copy files and append '_mid' to the end of existing filename before file extension.  

       for f in *[0-9].jpg  
          do 
            cp -n "${f}" "${f%.*}_mid.jpg"
       done

3. Resize new mid files to 800 pixels on the longest side. 

       mogrify -resize 800x800\> *_mid.jpg

4. Moves files to the `oa` folder when editing complete. 

# Usage (Mac Only)

## Script Setup

* Copy repository to local machine using Terminal.

       $ cd /PATH/TO/WHERE/YOU/STORE/SCRIPTS

       $ git clone https://github.com/elliswmartin/shhelpersLfA/

* OR, if repository was previously downloaded, navigate to repo folder and pull updated repo using Terminal.  

       $ cd /PATH/TO/THIS/REPO 
    
       $ git pull

## Folder Structure

This script ships assuming the following folder structure. You are welcome to modify this for your needs within the `helpersLfA.sh` script. 

        ├── Desktop
        │   ├── helpers
        │   │   ├── tiff-process        # Queue tiff files for processing here
        │   │   ├── jpg-process         # Queue jpg files for processing here
        │   │   ├── cropped             # Cropped jpgs routed here 
        │   │   ├── oa                  # 3000px jpgs plus mids routed here (oa = Online Archive)  

## Prepare Files

### Make Jpgs

Add TIFF files that you would like to copy to jpgs into `~/Desktop/tiff-process` folder. 

### Autocrop

Add JPG files that you would like to be cropped into the `~/Desktop/jpg-process` folder. If you do not have a `cropped` folder, one will be created automatically during processing. 

### Resize & Mids

Add cropped JPG files that you would like to resize and create mids (copies resized to 800px) into `~/Desktop/cropped` folder. If you do not have a `oa` folder, one will be created automatically during processing. 

## Run Script

1. Open Terminal and run `helpersLfA.sh`: 

        $ sh /PATH/TO/SCRIPT/helpersLfA.sh 

2. When prompted, enter a character in Terminal based on the process you would first like to run:

* `j`: **Make Jpgs** 
* `c`: **Autocrop** 
* `r`: **Resize & Mids**
* `q`: **Quit** 

3. Continue to select a process until you would like to quit.  
    
# Background 
I developed these scripts while working at Letterform Archive in San Francisco, CA to assist with automating small tasks and streamline existing workflows. 
