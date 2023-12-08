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

    # Setting Cursor by default
    setting_cursor

    # Setting Icons by default
    setting_icons

    # Setting Text Editor
    setting_text_editor

    # Setting Panel and applets
    setting_panel_and_applets

    # setting menu icon
    setting_menu_icon

    # Setting font by default
    setting_fonts

    # setting the color palette of the terminal
    setting_terminal_color_palette

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

function setting_cursor() {

    echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} Setting Cursor." | tee -a $log_path
    # Setting Cursor by default
    gsettings set org.cinnamon.desktop.interface cursor-theme 'breeze_cursors'
    gsettings set org.cinnamon.desktop.interface cursor-size 35
    echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} Cursor setted." | tee -a $log_path

}

function setting_icons() {

    echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} Setting Icons." | tee -a $log_path

    gsettings set org.x.apps.portal color-scheme 'prefer-dark'
    gsettings set org.cinnamon.desktop.interface gtk-theme 'Mint-Y-Dark-Aqua'
    gsettings set org.cinnamon.theme name 'Mint-Y-Dark-Aqua'

    # Setting Icons by default
    gsettings set org.cinnamon.desktop.interface icon-theme 'Tela-green-dark'
    echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} Icons setted." | tee -a $log_path

}

function setting_text_editor() {
    
        echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} Setting Text Editor." | tee -a $log_path
    
        # Setting Text Editor
        gsettings set org.x.editor.preferences.editor scheme 'cobalt'
        gsettings set org.x.editor.preferences.editor prefer-dark-theme true
        gsettings set org.x.editor.preferences.editor display-line-numbers true
        gsettings set org.x.editor.preferences.editor tabs-size 4
        gsettings set org.x.editor.preferences.editor display-right-margin true
        gsettings set org.x.editor.preferences.editor draw-whitespace true
        gsettings set org.x.editor.preferences.editor draw-whitespace-inside true
        gsettings set org.x.editor.preferences.editor draw-whitespace-leading true
        gsettings set org.x.editor.preferences.editor draw-whitespace-newline true
        gsettings set org.x.editor.preferences.editor draw-whitespace-trailing true
        gsettings set org.x.editor.preferences.editor editor-font 'FiraCode Nerd Font Mono Regular 10'

        echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} Text Editor setted." | tee -a $log_path
}

function setting_panel_and_applets() {
    
        echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} Setting applets." | tee -a $log_path
    
        # Setting applets
        gsettings set org.cinnamon enabled-applets "['panel1:center:0:menu@cinnamon.org:0', 'panel1:right:13:show-desktop@cinnamon.org:1', 'panel1:center:1:grouped-window-list@cinnamon.org:2', 'panel1:right:1:systray@cinnamon.org:3', 'panel1:right:2:xapp-status@cinnamon.org:4', 'panel1:right:12:notifications@cinnamon.org:5', 'panel1:right:4:printers@cinnamon.org:6', 'panel1:right:5:removable-drives@cinnamon.org:7', 'panel1:right:6:keyboard@cinnamon.org:8', 'panel1:right:7:favorites@cinnamon.org:9', 'panel1:right:8:network@cinnamon.org:10', 'panel1:right:9:sound@cinnamon.org:11', 'panel1:right:10:power@cinnamon.org:12', 'panel1:right:11:calendar@cinnamon.org:13', 'panel1:left:0:workspace-switcher@cinnamon.org:14']"

        echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} applets setted." | tee -a $log_path
        # Setting Panels
        echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} Setting Panels." | tee -a $log_path
        gsettings set org.cinnamon panels-enabled "['1:0:bottom']"
        gsettings set org.cinnamon panels-height "['1:46', '2:40']"
        gsettings set org.cinnamon panel-zone-icon-sizes '[{"panelId":1,"left":0,"center":0,"right":24}]'
        gsettings set org.cinnamon panel-zone-symbolic-icon-sizes '[{"panelId": 1, "left": 32, "center": 32, "right": 16}]'

        echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} Panels setted." | tee -a $log_path
        
}

function setting_menu_icon(){

    echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} Setting Menu Icon." | tee -a $log_path

    # /usr/share/icons/hicolor/scalable/apps/nombre_icon.svg
    # investigar la siguiente ruta
    # /home/$USER/.config/cinnamon/spices/menu@cinnamon.org/0.json
    # /home/$USER/.cinnamon/configs/menu@cinnamon.org/0.json
    # /home/$USER/.cinnamon/configs/menu@cinnamon.org/0.json

    icon_root="/usr/share/icons/hicolor/scalable/apps"
    # Setting Menu Icon
    if [ ! -f "$icon_root/linux-mint-galaxy-logo.png" ]; then

    #mkdir $root/.config-desktop
    #chmod 777 $root/.config-desktop
    sudo cp ./images/linux-mint-galaxy-logo.png $icon_root/linux-mint-galaxy-logo.png

    fi
    echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} Menu Icon moved to root." | tee -a $log_path
    json_root_legacy="/home/$USER/.cinnamon/configs/menu@cinnamon.org/0.json"
    json_root="/home/$USER/.config/cinnamon/spices/menu@cinnamon.org/0.json"

    icon_root_escaped=$(echo $icon_root | sed 's_/_\\/_g')
    # Cambiando el Icono del Menu
    if [ -f $json_root_legacy ] ; then
        # icon legacy: "/home/$USER/.cinnamon/configs/menu@cinnamon.org/0.json"
        echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} LOGO : Update logo menu in legacy icon root" | tee -a $log_path
        sed -i "/\"menu-icon\": {/,/\"value\":/s/\"value\": \"[^\"]*\"/\"value\": \"$icon_root_escaped\/linux-mint-galaxy-logo.png\"/" $json_root_legacy
        # updating the size of the icon 32 -> 36
        echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} LOGO : Update size icon menu in legacy icon root" | tee -a $log_path
        sed -i '/"menu-icon-size":/,/},/{s/"value": 32/"value": 36/}' $json_root_legacy
    elif [ -f $json_root ] ; then
        # icon new: "/home/$USER/.config/cinnamon/spices/menu@cinnamon.org/0.json"
        echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} LOGO : Update logo menu in new icon root" | tee -a $log_path
        sed -i "/\"menu-icon\": {/,/\"value\":/s/\"value\": \"[^\"]*\"/\"value\": \"$icon_root_escaped\/linux-mint-galaxy-logo.png\"/" $json_root
        # updating the size of the icon 32 -> 36
        echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} LOGO : Update size icon menu in new icon root" | tee -a $log_path
        sed -i '/"menu-icon-size":/,/},/{s/"value": 32/"value": 36/}' $json_root
    else
        # Don't found the file for change the icon menu
        echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} LOGO : File icon menu not found" | tee -a $log_path
    fi

    echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} Menu Icon setted." | tee -a $log_path

}

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
    gsettings set org.gnome.desktop.interface monospace-font-name 'Hack Nerd Font Mono 10'
    gsettings set org.cinnamon.desktop.wm.preferences titlebar-font 'Roboto Bold 10'
    gsettings set org.x.viewer.plugins.pythonconsole use-system-font false
    gsettings set org.x.viewer.plugins.pythonconsole font 'FiraCode Nerd Font Mono Regular 10'

    # changing setting scale
    gsettings set org.cinnamon.desktop.interface text-scaling-factor 1.2
    # changing font setting text scale
    # the sleep is for wait until the change is applied
    sleep 2

    echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} Fonts setted." | tee -a $log_path

}

function setting_terminal_color_palette() {

    echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} Setting Terminal Color Palette." | tee -a $log_path
    # setting the color palette of the terminal
    profile=$(gsettings get org.gnome.Terminal.ProfilesList default)
    profile=${profile:1:-1}
    gsettings set \
        org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:${profile}/\
        background-color "rgb(13,33,39)"
    gsettings set \
        org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:${profile}/\
        cursor-shape "underline"
    gsettings set \
        org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:${profile}/\
        font "Hack Nerd Font Mono 12"
    gsettings set \
        org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:${profile}/\
        palette "['rgb(0,0,0)', 'rgb(170,0,0)', 'rgb(0,170,0)', 'rgb(170,85,0)', 'rgb(38,139,210)', 'rgb(170,0,170)', 'rgb(0,170,170)', 'rgb(170,170,170)', 'rgb(85,85,85)', 'rgb(255,85,85)', 'rgb(85,255,85)', 'rgb(255,255,85)', 'rgb(85,85,255)', 'rgb(255,85,255)', 'rgb(85,255,255)', 'rgb(255,255,255)']"
    gsettings set \
        org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:${profile}/\
        use-system-font true
    gsettings set \
        org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:${profile}/\
        use-theme-colors false
    gsettings set \
        org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:${profile}/\
        visible-name "Sheldonimo"

    echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} Terminal Color Palette setted." | tee -a $log_path
}

# <<<----------------->>> Main <<<----------------->>>
main

# <<<----------------->>> End <<<----------------->>>
echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} Thank you for customizing your desktop. =D " | tee -a $log_path