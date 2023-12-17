#!/usr/bin/env bash
# by: Sheldonimo

function main() {

    echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} running." | tee -a $log_path
    echo "Install Desktop Customization..."

    # <<--->> Download all files <<--->>

    # Download fonts
    download_font

    # Download Cursor
    download_cursor

    # Download Icons
    download_icons

    # Download rofi
    download_rofi

    # <<--->> Unpackage all files <<--->>

    # Unpackage fonts
    Unpackage_font

    # Unpackage Cursor
    Unpackage_cursor

    # Unpackage Icons
    Unpackage_icons

    # Unpackage rofi
    Unpackage_rofi

    # <<--->> Installation all files <<--->>

    # Install fonts
    install_font

    # Install Cursor
    install_cursor

    # Install Icons
    install_icons

    # Install rofi
    install_rofi

    # <<--->> Setting configuration in desktop <<--->>



}

# <<<----------------->>> Download functions <<<----------------->>>


function download_font() {
    dato=$1
    echo "$dato-2"
}

# <<<----------------->>> Unpackage functions <<<----------------->>>


# <<<----------------->>> Installation functions <<<----------------->>>


# <<<----------------->>> Setting functions <<<----------------->>>


# <<<----------------->>> Main <<<----------------->>>
main

# <<<----------------->>> End <<<----------------->>>
echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} Thank you for customizing your desktop. =D " | tee -a $log_path