# shhelpersLfA
 Small bash tasks around Letterform Archive.

# rename.sh

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

4. Moves files to the `processed` folder when editing complete. 

### Usage (Mac Only)

1. This script ships assuming the following folder structure. You are welcome to modify this for your needs within the /rename.sh script.

        ├── Desktop
        │   ├── OA_process
        │   ├── processed

2. Copy files that you would like to resize and create mids (copies resized to 800px) into ~/Desktop/OA_process folder. 

3. Open Terminal and run `rename.sh`. 
      
        $ sh /PATH/TO/SCRIPT/rename.sh 
        
# makeJpg.sh

### How It Works 

Utilize ImageMagick's mogrify command to create jpg copies of tif files. 

    $ mogrify -flatten -format jpg *.tif

### Usage (Mac Only)
1. This script ships assuming the following folder structure. You are welcome to modify this for your needs within the `makeJpg.sh` script. 

        ├── Desktop
        │   ├── crop

2. Copy tif files that you would like to copy to jpgs into ~/Desktop/processed folder. 

3. Open Terminal and run `makeJpg.sh`: 

        $ sh /PATH/TO/SCRIPT/makeJpg.sh 

# helpersLfA.sh

### How It Works



### Usage (Mac Only) 

1. This script ships assuming the following folder structure. You are welcome to modify this for your needs within the `makeJpg.sh` script. 

        ├── Desktop
        │   ├── crop
        │   ├── qc
        │   ├── OA_process
        │   ├── processed

2. Copy files into corresponding folder for whichever process that you would like to run (see usage notes above for each script). 

3. Open Terminal and run `helpersLfA.sh`: 

        $ sh /PATH/TO/SCRIPT/helpersLfA.sh 

4. When prompted, enter a character in Terminal based on the process you would first like to run (see below for more details on the selections).  

5. Continue to select a process until you would like to quit. 

### How It Works
A combination of all of the scripts above with command line user input to customize each script execution. 

The script continues to prompt the user until "q" character is pressed: 

    $ while [[ ! $REPLY =~ ^[Qq]$ ]] 

Each letter corresponds to a different process, of which the code is copied exactly from the 2 scripts above and [autocrop](https://github.com/elliswmartin/autocropLfA/blob/85c9591d4c998e8d62e71494234da52d38808b6a/autocrop.sh): 

* `j`: Tifs in `crop` folder are turned into jpgs.
* `a`: Jpgs in `crop` folder are copied to qc and then the background is cropped out. 
* `r`: Jpgs in `OA_process` folder are resized to 3000px on longest side, and mid files are created (800px copies of orig files)    
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
    
# Background 
I developed these scripts while working at Letterform Archive in San Francisco, CA to assist with automating small tasks and streamline existing workflows. 
