#!/usr/bin/env bash
# by: Sheldonimo

function main() {

    echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} running." | tee -a $log_path
    echo "Installing General purpose..."

    # # <<--->> Download all files <<--->>

    # Download powerlevel10k
    download_powerlevel10k

    # Donwload plugins zsh
    download_plugins_zsh

    # # <<--->> Unpackage all files <<--->>

    # # Unpackage fonts
    # Unpackage_font

    # # Unpackage Cursor
    # Unpackage_cursor

    # # <<--->> Installation all files <<--->>

    # Install zsh
    install_zsh

    # Install alacritty
    install_alacritty

    # <<--->> Setting configuration in desktop <<--->>

    # Setting zsh
    setting_zsh_theme

    # Setting plugins zsh
    setting_plugins_zsh

    # Settings git tree visualizations
    setting_git_tree_visualizations


}

# <<<----------------->>> Download functions <<<----------------->>>



# <<<----------------->>> Unpackage functions <<<----------------->>>


# <<<----------------->>> Installation functions <<<----------------->>>


# <<<----------------->>> Setting functions <<<----------------->>>



# <<<----------------->>> Main <<<----------------->>>
main

# <<<----------------->>> End <<<----------------->>>
echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} Thank you for install developer apps. =D " | tee -a $log_path