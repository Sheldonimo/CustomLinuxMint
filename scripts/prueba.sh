#!/usr/bin/env bash

    # fonts=("Hack/HackNerdFontMono-Regular.ttf" "Hack/HackNerdFont-Regular.ttf" "FiraCode/FiraCodeNerdFont-Regular.ttf" "FiraCode/FiraCodeNerdFont-Retina.ttf" "FiraCode/FiraCodeNerdFontMono-Regular.ttf" "FiraCode/FiraCodeNerdFontMono-Retina.ttf")

    # # Copy each font if it's not already in the target directory
    # for font in "${fonts[@]}"; do
    #     if [ ! -f "$root_font/$font" ]; then
    #         sudo cp "./tmp/$font" "$root_font/Hack/"
    #     fi
    # done

# Defining variables
root=/home/$USER

sudo apt update

echo $root

