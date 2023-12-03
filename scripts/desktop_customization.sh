#!/usr/bin/env bash


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

    # Setting font by default
    #setting_fonts

    # Setting Cursor by default
    #setting_cursor

    # Setting Icons by default
    #setting_icons



}

# <<<----------------->>> Download functions <<<----------------->>>

# Function to execute the script
function download_font() {
    # found lastest URL:
    echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} Getting the last version of nerd-fonts." | tee -a $log_path
    html_url=$(get_lastest_url "ryanoasis/nerd-fonts")
    echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} found lastest version: $html_url" | tee -a $log_path
    # Download Hack Nerd Font Mono
    if [ ! -f "./tmp/Hack.zip" ]; then
    echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} Downloading Hack Nerd Font Mono." | tee -a $log_path
    curl -L --output "./tmp/Hack.zip" $html_url/Hack.zip
    # Waiting until all files are downloaded
    wait -n
    fi
    # Download FiraCode
    if [ ! -f "./tmp/FiraCode.zip" ]; then
    echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} Downloading FiraCode." | tee -a $log_path
    curl -L --output "./tmp/FiraCode.zip" $html_url/FiraCode.zip
    # Waiting until all files are downloaded
    wait -n
    fi

}

function download_cursor() {
    # found lastest URL:
    echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} Getting the last version of BreezeX_Cursor." | tee -a $log_path
    html_url=$(get_lastest_url "ful1e5/BreezeX_Cursor")
    echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} found lastest version: $html_url" | tee -a $log_path
    # Download Capitaine Cursors
    if [ ! -f "./tmp/BreezeX-Dark.tar.gz" ]; then
    echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} Downloading BreezeX_Cursor." | tee -a $log_path
    curl -L --output "./tmp/BreezeX-Dark.tar.gz" $html_url/BreezeX-Dark.tar.gz
    echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} BreezeX_Cursor Downloaded." | tee -a $log_path
    # Waiting until all files are downloaded
    wait -n
    fi
}

function download_icons() {
    # found lastest URL:
    echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} Getting the last version of Tela-icon-theme." | tee -a $log_path
    # replace the string "/releases/download/" by "/archive/refs/tags/"
    html_url=$(get_lastest_url "vinceliuice/Tela-icon-theme" | sed 's|/releases/download/|/archive/refs/tags/|')
    echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} found lastest version: $html_url" | tee -a $log_path
    # Download Tela-icon-theme
    if [ ! -f "./tmp/Tela-icons.tar.gz" ]; then
    echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} Downloading Tela-icons." | tee -a $log_path
    curl -L --output "./tmp/Tela-icons.tar.gz" $html_url.tar.gz
    echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} Tela-icons Downloaded." | tee -a $log_path
    # Waiting until all files are downloaded
    wait -n
    fi
}

function download_rofi() {
    # Download rofi
    html_url="https://github.com/Sheldonimo/fresh-rofi-theme/archive/refs/heads/master.zip"
    if [ ! -f "./tmp/fresh-rofi-theme.zip" ]; then
    echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} Downloading fresh-rofi-theme." | tee -a $log_path
    curl -L --output "./tmp/fresh-rofi-theme.zip" $html_url
    echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} fresh-rofi-theme Downloaded." | tee -a $log_path
    # Waiting until all files are downloaded
    wait -n
    fi
}

# Arguments: 1=name_github_user/name_repo (e.i ryanoasis/nerd-fonts)
function get_lastest_url() {
        # URL de la API para el último release del repositorio
        #Example: "https://api.github.com/repos/ryanoasis/nerd-fonts/releases/latest"
        api_url="https://api.github.com/repos/$1/releases/latest"
        # Realizar la solicitud y extraer solo la primera coincidencia de "html_url"
        html_url=$(curl -s $api_url | grep -m 1 '"html_url":' | awk -F '"' '{print $4}' | sed 's|/tag/|/download/|')
        # el curl -s es para que no muestre el progreso de la descarga
        # el grep -m 1 es para que solo muestre la primera coincidencia
        # el awk -F '"' '{print $4}' es para que solo muestre la cuarta columna y usa como separador " (la comilla doble)
        # el sed 's|/tag/|/download/|' es para reemplazar la cadena "/tag/" por "/download/"
        # URL de descarga del archivo
        echo $html_url
}

# <<<----------------->>> Unpackage functions <<<----------------->>>

function Unpackage_font() {
    # Unpackage Hack Nerd Font Mono
    if [ ! -d "./tmp/Hack" ]; then
    # Create a new folder to unpack the zip file
    mkdir -p "./tmp/Hack"
    echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} Unpackaging Hack Nerd Font Mono." | tee -a $log_path
    unzip "./tmp/Hack.zip" -d "./tmp/Hack/"
    echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} Hack Nerd Font Mono Unpackaged." | tee -a $log_path
    # Delete zip file
    rm -f "./tmp/Hack.zip"
    fi
    # Unpackage FiraCode
    if [ ! -d "./tmp/FiraCode" ]; then
    # Create a new folder to unpack the zip file
    mkdir -p "./tmp/FiraCode"
    echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} Unpackaging FiraCode." | tee -a $log_path
    unzip "./tmp/FiraCode.zip" -d "./tmp/FiraCode/"
    echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} FiraCode Unpackaged." | tee -a $log_path
    # Delete zip file
    rm -f "./tmp/FiraCode.zip"
    fi
}

function Unpackage_cursor() {
    # Unpackage BreezeX_Cursor
    if [ ! -d "./tmp/BreezeX-Dark" ]; then
    echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} Unpackaging BreezeX_Cursor." | tee -a $log_path
    tar -xzf "./tmp/BreezeX-Dark.tar.gz" -C "./tmp/"
    echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} BreezeX_Cursor Unpackaged." | tee -a $log_path
    # Delete tar.gz file
    rm -f "./tmp/BreezeX-Dark.tar.gz"
    fi
}

function Unpackage_icons() {
    # Unpackage Tela-icons
    if [ ! -d "./tmp/Tela-icon-theme" ]; then
    echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} Unpackaging Tela-icons." | tee -a $log_path
    tar -xzf "./tmp/Tela-icons.tar.gz" -C "./tmp/"
    # identify the name of the folder that begin with "Tela" and doesn't have any dot "." and rename it to "Tela-icons"
    folder_icons=$(ls ./tmp/ | grep -i "^Tela[^.]*$")
    echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} rename folder_icons: $folder_icons -> Tela-icons" | tee -a $log_path
    mv "./tmp/$folder_icons" "./tmp/Tela-icons"
    echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} Tela-icons Unpackaged." | tee -a $log_path
    # Delete tar.gz file
    rm -f "./tmp/Tela-icons.tar.gz"
    fi
}

function Unpackage_rofi() {
    # Unpackage rofi
    if [ ! -d "./tmp/fresh-rofi-theme-master" ]; then
    echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} Unpackaging fresh-rofi-theme." | tee -a $log_path
    unzip "./tmp/fresh-rofi-theme.zip" -d "./tmp/"
    # Change name fresh-rofi-theme-master -> fresh-rofi-theme
    mv "./tmp/fresh-rofi-theme-master" "./tmp/fresh-rofi-theme"
    echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} fresh-rofi-theme Unpackaged." | tee -a $log_path
    echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} Folder Renamed fresh-rofi-theme-master -> fresh-rofi-theme." | tee -a $log_path
    # Delete zip file
    rm -f "./tmp/fresh-rofi-theme.zip"
    fi
}

# <<<----------------->>> Installation functions <<<----------------->>>

function install_font() {

    # Define the root font directory
    root_font="/usr/share/fonts/truetype"

    echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} Installing fonts." | tee -a $log_path

    # Ensure the font directory exists
    [ ! -d "$root_font/Hack" ] && sudo mkdir -p "$root_font/Hack"
    [ ! -d "$root_font/FiraCode" ] && sudo mkdir -p "$root_font/FiraCode"

    # List of fonts to be installed
    # "HackNerdFontMono-Regular.ttf" is a monospaced font with icons
    # "HackNerdFont-Regular.ttf" is a slightly larger version of the previous font
    # "FiraCodeNerdFont-Regular.ttf" is a monospaced font with ligatures and icons
    # "FiraCodeNerdFont-Retina.ttf" is a slightly larger version of the previous font
    fonts=("Hack/HackNerdFontMono-Regular.ttf" "Hack/HackNerdFont-Regular.ttf" "FiraCode/FiraCodeNerdFont-Regular.ttf" "FiraCode/FiraCodeNerdFont-Retina.ttf" "FiraCode/FiraCodeNerdFontMono-Regular.ttf" "FiraCode/FiraCodeNerdFontMono-Retina.ttf")

    # Copy each font if it's not already in the target directory
    for font in "${fonts[@]}"; do
        if [ ! -f "$root_font/$font" ]; then
            echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} Installing $(echo $font | cut -d'/' -f2)." | tee -a $log_path
            type=$(echo $font | cut -d'/' -f1)
            sudo cp "./tmp/$font" "$root_font/$type/"
        fi
    done

    echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} Hack Nerd font Installed." | tee -a $log_path
    echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} FiraCode Installed." | tee -a $log_path
}

function install_cursor() {

    # Define the root cursor directory
    root_cursor="/usr/share/icons"
    echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} Installing BreezeX_Cursor." | tee -a $log_path
    # Ensure the cursor directory exists
    [ ! -d "$root_cursor/BreezeX-Dark" ] && sudo mkdir -p "$root_cursor/BreezeX-Dark"

    # Copy each cursor if it's not already in the target directory
    if [ ! -d "$root_cursor/BreezeX-Dark" ]; then
        echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} Installing BreezeX_Cursor." | tee -a $log_path
        sudo cp -r "./tmp/BreezeX-Dark" "$root_cursor/"
    fi

    echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} BreezeX_Cursor Installed." | tee -a $log_path

}

function install_icons() {

    echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} Installing Tela-icons." | tee -a $log_path
    # Install green icons
    sudo ./tmp/Tela-icons/install.sh green
    echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} Tela-icons Installed." | tee -a $log_path

}

function install_rofi() {

    echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} Installing rofi." | tee -a $log_path
    # Install rofi
    ./tmp/fresh-rofi-theme/install.sh
    echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} rofi Installed." | tee -a $log_path

}

# <<<----------------->>> Setting functions <<<----------------->>>

function setting_fonts() {

    echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} Setting fonts." | tee -a $log_path
    # Setting font by default
    # with the help of `dconf watch /` we can see the changes the next configuration.
    # to see types dconf-editor in the terminal
    # installing roboto fonts
    sudo apt install -y fonts-roboto fonts-roboto-unhinted

    gsettings set org.cinnamon.desktop.interface font-name 'Roboto 10'
    gsettings set org.nemo.desktop font 'Roboto 10'
    gsettings set org.gnome.desktop.interface document-font-name 'Roboto 10'
    gsettings set org.cinnamon.desktop.wm.preferences titlebar-font 'Roboto Bold 10'
    gsettings set org.gnome.desktop.interface monospace-font-name 'Hack Nerd Font Mono Regular 10'
    gsettings set org.x.viewer.plugins.pythonconsole use-system-font false
    gsettings set org.x.viewer.plugins.pythonconsole font 'Hack Nerd Font Mono Regular 10'

    # changing setting scale
    gsettings set org.cinnamon.desktop.interface text-scaling-factor 1.2

    # changing font setting text scale

    echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} Fonts setted." | tee -a $log_path

}

function setting_cursor() {

    echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} Setting Cursor." | tee -a $log_path
    # Setting Cursor by default
    gsettings set org.cinnamon.desktop.interface cursor-theme 'BreezeX-Dark'
    gsettings set org.cinnamon.desktop.interface cursor-size 35
    echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} Cursor setted." | tee -a $log_path

}

function setting_icons() {

    echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} Setting Icons." | tee -a $log_path
    # Setting Icons by default
    gsettings set org.cinnamon.desktop.interface icon-theme 'Tela-green-dark'
    echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} Icons setted." | tee -a $log_path

}

# <<<----------------->>> Main <<<----------------->>>
main

echo "Log path is $log_path"
echo "PWD: $PWD"
