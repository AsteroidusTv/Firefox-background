#!/bin/bash

# Find default folder in /home/<user>/snap/firefox/common/.mozilla/firefox/
default_folder=$(find /home/*/snap/firefox/common/.mozilla/firefox -maxdepth 1 -type d -name '*.default' -print -quit)
echo $default_folder
# Using Zenity to open a file chooser restricted to images
file=$(zenity --file-selection --title="Select an image" --filename="$default_folder")

# Checking if a file was selected or if the user canceled
if [ -n "$file" ]; then
    echo "You have selected the image: $file"
else
    echo "No image selected."
fi

cd "$default_folder"

touch user.js 
echo "
user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", false);
" > "./user.js"

if [ -d "chrome/img" ]; then
	echo "Folder already exists"
else
	mkdir -p chrome/img
fi

if [ chrome/img/*!=$file ]; then
	read -p "Another file is found as a wallpaper want to delete it? y/n (case sensitive)" response
	if [ "$response" == "y" ]; then
		rm chrome/img/*
		echo removed
	else
		echo Nothing done try removing the extra file if no wallpaper apperared 
	fi
fi
cp "$file" chrome/img/
cd chrome
touch userContent.css
echo "
@-moz-document url(about:home), url(about:newtab), url(about:privatebrowsing) {
.click-target-container *, .top-sites-list * {
    color: #fff !important ;
    text-shadow: 2px 2px 2px #222 !important ;
}
body::before {
    content: '' ;
    z-index: -1 ;
    position: fixed ;
    top: 0 ;
    left: 0 ;
    background: #f9a no-repeat url(./img/$(basename "$file")) center ;
    background-size: cover ;
    width: 100vw ;
    height: 100vh ;
}
} " > "./userContent.css"
