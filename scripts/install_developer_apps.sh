#!/usr/bin/env bash
# by: Sheldonimo

function main() {

    echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} running." | tee -a $log_path
    echo "Installing Developer apps..."

    # # <<--->> Download all files <<--->>

    # Download powerlevel10k
    download_powerlevel10k

    # # Download fonts
    # download_font

    # # Download Cursor
    # download_cursor

    # # Download Icons
    # download_icons

    # # Download rofi
    # download_rofi

    # # <<--->> Unpackage all files <<--->>

    # # Unpackage fonts
    # Unpackage_font

    # # Unpackage Cursor
    # Unpackage_cursor

    # # Unpackage Icons
    # Unpackage_icons

    # # Unpackage rofi
    # Unpackage_rofi

    # # <<--->> Installation all files <<--->>

    # # Install fonts
    # install_font

    # # Install Cursor
    # install_cursor

    # # Install Icons
    # install_icons

    # # Install rofi
    # install_rofi

    # Install zsh
    install_zsh

    # <<--->> Setting configuration in desktop <<--->>

    # Setting rofi
    setting_zsh_theme


}

# <<<----------------->>> Download functions <<<----------------->>>

function download_powerlevel10k() {
    echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} Downloading powerlevel10k." | tee -a $log_path
    # Download powerlevel10k
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/.config/powerlevel10k
    echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} powerlevel10k Downloaded." | tee -a $log_path
}



# function download_font() {
#     dato=$1
#     echo "$dato-2"
# }

# <<<----------------->>> Unpackage functions <<<----------------->>>


# <<<----------------->>> Installation functions <<<----------------->>>

function install_zsh(){
    echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} Installing zsh." | tee -a $log_path
    # Install green icons
    sudo apt install -y zsh
    echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} zsh Installed." | tee -a $log_path
}

# <<<----------------->>> Setting functions <<<----------------->>>

function setting_zsh_theme(){
    echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} Setting zsh theme." | tee -a $log_path
    # copy ~/.zshrc and ~/.p10k.zsh
    cp ./theme/.zshrc ~/.zshrc
    cp ./theme/.p10k.zsh ~/.p10k.zsh
    # copy theme/powerlevel10k.zsh-theme
    #cp ./theme/powerlevel10k.zsh-theme ~/.config/powerlevel10k/powerlevel10k.zsh-theme  
    echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} zsh theme Installed." | tee -a $log_path
}

# <<<----------------->>> Main <<<----------------->>>
main

# <<<----------------->>> End <<<----------------->>>
echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} Thank you for install developer apps. =D " | tee -a $log_path