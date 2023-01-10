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

### Usage

1. This script ships assuming the following folder structure. You are welcome to modify this for your needs within the /rename.sh script.

        ├── Desktop
        │   ├── OA_process

2. Copy files that you would like to resize and create mids (copies resized to 800px). 

3. Open Terminal and run `rename.sh`. 
      
        $ sh /PATH/TO/SCRIPT/rename.sh 

## Background 
I developed these scripts while working at Letterform Archive in San Francisco, CA to assist with automating small tasks. 
