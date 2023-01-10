# shhelpersLfA
 Small bash tasks around Letterform Archive.

## rename.sh

### How It Works
This script uses bash to prepare jpg image files for the Online Archive. To do this, it performs a few tasks: 

1. Resize existing jpgs to 3000 pixels on the longest side. 

       $ mogrify -resize 3000x3000\> *.jpg  
   
2. Copy files and append '_mid' to the end of existing filename before file extension.  

       for f in *[0-9].jpg  
          do 
            cp -n "${f}" "${f%.*}_mid.jpg"
       done

3. Resize new mid files to 800 pixels on the longest side. 

       mogrify -resize 800x800\> *_mid.jpg

### Usage (Mac Only)

1. This script ships assuming the following folder structure. You are welcome to modify this for your needs within the /rename.sh script.

        ├── Desktop
        │   ├── OA_process

2. Copy files that you would like to resize and create mids (copies resized to 800px) into ~/Desktop/OA_process folder. 

3. Open Terminal and run `rename.sh`. 
      
        $ sh /PATH/TO/SCRIPT/rename.sh 
        
## makeJpg.sh

### How It Works 

Utilize ImageMagick's mogrify command to create jpg copies of tif files. 

    $ mogrify -flatten -format jpg *.tif

### Usage (Mac Only)
1. This script ships assuming the following folder structure. You are welcome to modify this for your needs within the /makeJpg.sh script. 

        ├── Desktop
        │   ├── crop

2. Copy tif files that you would like to copy to jpgs into ~/Desktop/processed folder. 

3. (optional) Run [autocrop.sh](https://github.com/elliswmartin/autocropLfA/blob/85c9591d4c998e8d62e71494234da52d38808b6a/autocrop.sh) for the next stage of processing.  

## shhelpers.sh

### How It Works
A combination of all of the scripts above with command line user input to customize each script execution. 

## Background 
I developed these scripts while working at Letterform Archive in San Francisco, CA to assist with automating small tasks. 
