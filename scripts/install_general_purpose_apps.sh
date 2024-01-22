#!/usr/bin/env bash
# by: Sheldonimo

# define the file with the list of apps to install
INSTALL_LIST="install_list.csv"
# Ubuntu codename
ubuntu_codename=$(grep UBUNTU_CODENAME /etc/os-release | cut -d '=' -f2)

function main() {

    echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} running." | tee -a $log_path
    echo "Installing General purpose..."

    # <<--->> Validate if the file install_list.txt exist <<--->>
    if [ ! -f "$INSTALL_LIST" ]; then
        echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} The file $INSTALL_LIST does not exist." | tee -a $log_path
        exit 1
    fi

    # # <<--->> Download all files <<--->>

    # Download Logseq
    download_logseq

    # Donwload plugins zsh
    # download_plugins_zsh

    # # <<--->> Unpackage all files <<--->>

    # # Unpackage fonts
    # Unpackage_font

    # # Unpackage Cursor
    # Unpackage_cursor

    # # <<--->> Installation all files <<--->>

    # Install vscode
    install_vscode

    # Install copyq
    install_copyq

    # Install flameshot
    install_flameshot

    # Install tldr
    install_tldr

    # Install obs-studio
    install_obs_studio

    # Install libreoffice
    install_libreoffice

    # Install tesseract-ocr
    install_tesseract_ocr

    # Install ytfzf
    install_ytfzf

    # Install signal
    install_signal

    # <<--->> Setting configuration in desktop <<--->>

    # Setting tesseract-ocr
    setting_tesseract_ocr

    # Setting flameshot
    setting_flameshot

    # Setting logseq
    setting_logseq

    # Setting copyq
    setting_copyq

    # Setting ytfzf
    setting_ytfzf

}

# <<<----------------->>> Download functions <<<----------------->>>

function download_logseq() {
    if grep -iq '^x|logseq' "$INSTALL_LIST" && ! command -v logseq &> /dev/null; then
        echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} Downloading logseq." | tee -a $log_path
        # Download logseq
        # Get the latest release from github
        html_url=$(get_lastest_url "logseq/logseq")

        # Get the version from the url
        version=$(echo "$html_url" | awk -F'/download/' '{print $2}')

        # Update the version in the desktop file
        sed -i "s/^Version=.*$/Version=$version/" "./resources/logseq.desktop"

        # Get the file name from the url
        file_name="Logseq-linux-x64-$version.AppImage"

        echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} found lastest version: $html_url" | tee -a $log_path

        # Download the file
        if [ ! -f "./tmp/Logseq-linux-x64.AppImage" ]; then
            echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} Downloading Logseq." | tee -a $log_path
            wget -q --show-progress -O "./tmp/Logseq-linux-x64.AppImage" $html_url/$file_name
            echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} Logseq Downloaded." | tee -a $log_path
        fi

        # Download the icon
        icon_url="https://raw.githubusercontent.com/logseq/logseq/master/resources/icons/logseq.png"
        if [ ! -f "./tmp/logseq-icon.png" ]; then
            echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} Downloading logseq icon." | tee -a $log_path
            wget -q --show-progress -O "./tmp/logseq-icon.png" $icon_url
            echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} logseq icon Downloaded." | tee -a $log_path
        fi
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


# <<<----------------->>> Installation functions <<<----------------->>>

function install_imagemagick(){
    # Validate if imagemagick is not installed
    if ! command -v convert &> /dev/null; then
        echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} Installing imagemagick." | tee -a $log_path
        # Install imagemagick
        sudo apt install -y imagemagick
        echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} imagemagick Installed." | tee -a $log_path
    fi
}

# Function to check if a custom command exists
function exist_shortcut() {
    # Arguments: $1 = name of the custom command, $2 = binding of the custom command
    # 1=rofi , 2=['<Alt>d']

    # Path where the custom commands are stored in dconf
    path_key="/org/cinnamon/desktop/keybindings/custom-keybindings"

    # Read the list of custom commands
    custom_list=$(dconf read /org/cinnamon/desktop/keybindings/custom-list)

    # Extract the custom command names
    custom_names=$(echo $custom_list | grep -o "custom[0-9]*")

    # Print each custom command name
    flag=false # Flag to indicate if the custom command exists
    for name in $custom_names; do
        dconf_name=$(dconf read $path_key/$name/name)
        dconf_shortcut=$(dconf read $path_key/$name/binding)
        if [ "$dconf_name" == "$1" ] && [ "$dconf_shortcut" == "$2" ]; then
            flag=true
            break
        fi
    done
    echo $flag
}

# Function to find the maximum custom index
function get_max_custom_index() {
    # input example: "['custom5', 'custom0', 'custom1', 'custom2', 'custom3', 'custom4']"
    local input_list="$1"
    local max_index=-1

    # Extract numbers from the input list
    local numbers=$(echo "$input_list" | grep -o -E 'custom[0-9]+' | tr -dc '0-9\n')

    # Find the maximum index
    for number in $numbers; do
        if (( number > max_index )); then
            max_index=$number
        fi
    done

    # Return the result
    echo $max_index
    # output example: 5
}

# Function to add a shortcut
function add_shortcut() {
    # input example: shortcuts, commands, names
    # Example arguments: 1=['<Alt><Shift>a'], 2='gnome-screenshot -ac', 3='screenshot area'

    local binding="$1"
    local command="$2"
    local name="$3"

    local path_key="/org/cinnamon/desktop/keybindings/custom-keybindings"

    # Update the custom-list
    custom_list=$(dconf read /org/cinnamon/desktop/keybindings/custom-list)
    max_custom=$(get_max_custom_index "$custom_list")
    index=$((max_custom + 1))

    # Write the shortcut in the file dconf
    dconf write "$path_key/custom$index/binding" "$binding"
    dconf write "$path_key/custom$index/command" "$command"
    dconf write "$path_key/custom$index/name" "$name"

    # $((...)) is the arithmetic expansion in bash

    dconf write /org/cinnamon/desktop/keybindings/custom-list "['__dummy__$(printf "', 'custom%d" $(seq 0 $index))']"

}

function install_vscode() {
    if grep -iq '^x|vscode' "$INSTALL_LIST" && ! command -v code &> /dev/null; then
        echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} Installing vscode." | tee -a $log_path
        # Install vscode
        # Add vscode's official GPG key:
        curl -fsSL https://packages.microsoft.com/keys/microsoft.asc | sudo gpg --dearmor -o /etc/apt/keyrings/packages.microsoft.gpg
        sudo chmod 644 /etc/apt/keyrings/packages.microsoft.gpg
        # Add the repository to Apt sources:
        echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" | sudo tee /etc/apt/sources.list.d/vscode.list >/dev/null
        # Install vscode:
        sudo apt-get update
        sudo apt install code -y
        echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} vscode installed." | tee -a $log_path
    fi
}

function install_copyq() {
    if grep -iq '^x|copyq' "$INSTALL_LIST" && ! command -v copyq &> /dev/null; then
        echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} Installing copyq." | tee -a $log_path
        # Install copyq
        # Add the CopyQ PPA (Personal Package Archive) to the system
        sudo add-apt-repository -y ppa:hluk/copyq
        # Add architecture amd64
        sudo sed -i "s/^deb \[/deb [arch=amd64 /" "/etc/apt/sources.list.d/hluk-copyq-$ubuntu_codename.list"
        # Update the repositories
        sudo apt update
        # Install CopyQ
        sudo apt install copyq -y
        
        echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} copyq installed." | tee -a $log_path
    fi
}

function install_flameshot() {
    if grep -iq '^x|flameshot' "$INSTALL_LIST" && ! command -v flameshot &> /dev/null; then
        echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} Installing flameshot." | tee -a $log_path
        # Install flameshot
        sudo apt-get install flameshot -y
        echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} flameshot installed." | tee -a $log_path
    fi
}

function install_tldr() {
    if grep -iq '^x|tldr' "$INSTALL_LIST" && ! command -v tldr &> /dev/null; then
        echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} Installing tldr." | tee -a $log_path
        # Install flameshot
        pip3 install tldr
        echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} tldr installed." | tee -a $log_path
    fi
}

function install_obs_studio() {
    if grep -iq '^x|obs-studio' "$INSTALL_LIST" && ! command -v obs &> /dev/null; then
        echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} Installing obs-studio." | tee -a $log_path
        # Install dependencies
        sudo apt install ffmpeg -y
        # Install obs-studio
        sudo add-apt-repository -y ppa:obsproject/obs-studio
        wait -n  # Wait for the process to complete
        # Add architecture amd64
        sudo sed -i "s/^deb \[/deb [arch=amd64 /" "/etc/apt/sources.list.d/obsproject-obs-studio-$ubuntu_codename.list"
        # Update the repositories
        sudo apt update
        # Install obs-studio
        sudo apt install obs-studio -y
        echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} obs-studio installed." | tee -a $log_path
    fi
}

function install_libreoffice() {
    if grep -iq '^x|libreoffice' "$INSTALL_LIST" && ! command -v libreoffice &> /dev/null; then
        echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} Installing libreoffice." | tee -a $log_path
        # Install libreoffice
        sudo add-apt-repository -y ppa:libreoffice/ppa
        wait -n  # Wait for the process to complete
        # Inform about updating keys due to deprecation of apt-key
        echo "Updating keys as apt-key is deprecated"
        # Extract the key associated with obsproject
        key=$(sudo apt-key list 2>/dev/null | grep -B 1 -i "LibreOffice Packaging" | awk 'NR==1{print $9$10}')
        # Export the key and convert it for the new APT keyring system
        sudo apt-key export $key | sudo gpg --dearmour -o /usr/share/keyrings/libreoffice.gpg
        # Inform about updating the key in the repositories
        # Add the repository with the new keyring path
        echo "deb [arch=amd64 signed-by=/usr/share/keyrings/libreoffice.gpg] http://ppa.launchpad.net/libreoffice/ppa/ubuntu $ubuntu_codename main" | sudo tee /etc/apt/sources.list.d/libreoffice-ppa.list >/dev/null
        # Removing the key from the deprecated path
        sudo apt-key del $key
        # Update the repositories
        sudo apt update
        # Install libreoffice
        sudo apt install libreoffice -y

        echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} libreoffice installed." | tee -a $log_path
    fi
}

function install_tesseract_ocr() {
    if grep -iq '^x|tesseract' "$INSTALL_LIST" && ! command -v tesseract &> /dev/null; then
        echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} Installing tesseract-ocr." | tee -a $log_path
        # Add ppa repository
        sudo add-apt-repository -y ppa:alex-p/tesseract-ocr-devel
        wait -n  # Wait for the process to complete
        # Update the repositories
        sudo apt update
        # Install tesseract-ocr
        sudo apt install tesseract-ocr tesseract-ocr-eng tesseract-ocr-spa tesseract-ocr-osd xclip -y
        # tesseract-ocr is for the ocr
        # tesseract-ocr-eng is for the english language
        # tesseract-ocr-spa is for the spanish language
        # xclip is for copy the text to the clipboard
        echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} tesseract-ocr installed." | tee -a $log_path
    fi
}

function install_ytfzf(){
    if grep -iq '^x|ytfzf' "$INSTALL_LIST" && ! command -v ytfzf &> /dev/null; then
        echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} Installing ytfzf." | tee -a $log_path
        # install dependencies
        sudo apt install -y mpv jq fzf suckless-tools
        pip3 install yt-dlp
        # Install ueberzugcpp
        UBUNTU_CODE=$(inxi -Sx | awk -F'Ubuntu ' '/base:/ {print $2}'| cut -d' ' -f1)  
        # inxi -Sx: Runs 'inxi' to display system info with extra details.
        # | (pipe): Passes output of the previous command to the next.
        # awk -F'Ubuntu ': Uses 'awk' with field separator set to 'Ubuntu '.
        #   '/base:/ {print $2}': In 'awk', searches lines containing 'base:' and prints the second field.
        # | (pipe): Again, passes output to the next command.
        # cut -d'  ' -f1: Uses 'cut' with delimiter as two spaces, extracts the first field.
        echo "deb [arch=amd64] http://download.opensuse.org/repositories/home:/justkidding/xUbuntu_$UBUNTU_CODE/ /" | sudo tee /etc/apt/sources.list.d/ueberzugpp.list
        curl -fsSL https://download.opensuse.org/repositories/home:justkidding/xUbuntu_$UBUNTU_CODE/Release.key | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/ueberzugpp.gpg > /dev/null
        sudo apt update
        sudo apt install -y ueberzugpp
        # Install ytfzf
        git clone --depth 1 https://github.com/pystardust/ytfzf ./tmp/ytfzf
        cd ./tmp/ytfzf
        sudo make install doc
        cd -
        echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} ytfzf installed." | tee -a $log_path
    fi

}

function install_signal(){
    echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} Installing signal." | tee -a $log_path
    # NOTE: These instructions only work for 64-bit Debian-based
    # Linux distributions such as Ubuntu, Mint etc.

    # 1. Install our official public software signing key:
    wget -q --show-progress -O- https://updates.signal.org/desktop/apt/keys.asc | gpg --dearmor > signal-desktop-keyring.gpg
    cat signal-desktop-keyring.gpg | sudo tee /usr/share/keyrings/signal-desktop-keyring.gpg > /dev/null

    # 2. Add our repository to your list of repositories:
    echo 'deb [arch=amd64 signed-by=/usr/share/keyrings/signal-desktop-keyring.gpg] https://updates.signal.org/desktop/apt xenial main' |\
    sudo tee /etc/apt/sources.list.d/signal-xenial.list

    # 3. Update your package database and install Signal:
    sudo apt update && sudo apt install -y signal-desktop
    
    echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} signal installed." | tee -a $log_path
}

# <<<----------------->>> Setting functions <<<----------------->>>

function setting_tesseract_ocr() {

    # Validate if the shortcut exist
    if ! command -v ocr_flameshot &> /dev/null; then
        # Create a script to run ocr_flameshot
        echo '#!/usr/bin/env bash' >> $HOME/.local/bin/ocr_flameshot
        echo "# by: Sheldonimo" >> $HOME/.local/bin/ocr_flameshot
        echo "flameshot gui --raw | tesseract stdin stdout -l eng+spa --psm 6 | xclip -in -selection clipboard" >> $HOME/.local/bin/ocr_flameshot
        chmod +x $HOME/.local/bin/ocr_flameshot
    fi

    # Validate if the shortcut exist
    res=$(exist_shortcut "'ocr_flameshot'" "['<Alt><Shift>z']")
    # Validate if tesseract-ocr is installed
    if [ "$res" == "false" ] && grep -iq '^x|tesseract' "$INSTALL_LIST"; then
      
        echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} Setting tesseract-ocr." | tee -a $log_path

        local binding="['<Alt><Shift>z']"
        local command="'$HOME/.local/bin/ocr_flameshot'"
        # Commands:
        # - flameshot gui --raw | tesseract stdin stdout -l eng+spa --psm 6 | xclip -in -selection clipboard
        # - gnome-screenshot -ac && xclip -selection clipboard -t image/png -o | tesseract stdin stdout -l eng+spa --psm 6 | xclip -in -selection clipboard
        local name="'ocr_flameshot'"

        add_shortcut "$binding" "$command" "$name"

        echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} copyq is set up." | tee -a $log_path
        
    fi

}

function setting_flameshot() {
    # Validate if the shortcut exist
    res=$(exist_shortcut "'flameshot'" "['<Alt><Shift>z']")

    if grep -iq '^x|flameshot' "$INSTALL_LIST" && [ $res == "false" ]; then
      
        echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} Setting flameshot in shortcuts." | tee -a $log_path

        local binding="['<Alt><Shift>q']"
        local command="'flameshot gui'"
        local name="'flameshot'"

        add_shortcut "$binding" "$command" "$name"

        echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} flameshot is set up." | tee -a $log_path
        
    fi

}

function setting_logseq() {
    if grep -iq '^x|logseq' "$INSTALL_LIST" && ! command -v logseq &> /dev/null; then
        echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} Setting logseq." | tee -a $log_path
        # Setting logseq
        # Create the folder
        mkdir -p $HOME/.local/share/applications
        mkdir -p $HOME/.local/share/logseq
        # Copy the file
        cp ./tmp/Logseq-linux-x64.AppImage $HOME/.local/share/logseq/Logseq-linux-x64.AppImage
        # Give execution permissions
        chmod +x $HOME/.local/share/logseq/Logseq-linux-x64.AppImage

        # Installing imagemagick if it is not installed
        install_imagemagick

        # Create the icons
        original_image="./tmp/logseq-icon.png"
        sizes=(16 24 32 48 64 128 512)

        for size in "${sizes[@]}"; do
            # Validate if the directory exist
            if [ ! -d "$HOME/.local/share/icons/hicolor/${size}x${size}/apps" ]; then
                # Crear el directorio si no existe
                mkdir -p "$HOME/.local/share/icons/hicolor/${size}x${size}/apps"
            fi
            # Redimensionar y guardar en la ruta correspondiente
            convert "$original_image" -resize "${size}x${size}" "$HOME/.local/share/icons/hicolor/${size}x${size}/apps/logseq-icon.png"
        done

        # Create a script to run logseq and update logseq
        cp ./resources/logseq $HOME/.local/bin/logseq
        chmod +x $HOME/.local/bin/logseq
        # Create the desktop file
        # change ~ to $HOME
        sed -i "s|~|$HOME|g" "./resources/logseq.desktop"
        # Copy the file
        cp ./resources/logseq.desktop $HOME/.local/share/applications/logseq.desktop

        # Add logseq shortcut
        local binding="['<Alt>Return']"
        local command="'$HOME/.local/bin/logseq'"
        local name="'Logseq'"

        # Validate if the shortcut exist
        res=$(exist_shortcut "$name" "$binding")

        if [ $res == "false" ]; then
            echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} Setting logseq in shortcuts." | tee -a $log_path
            add_shortcut "$binding" "$command" "$name"
        fi

        # Setting logseq theme
        echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} Setting a custom theme for logseq "sheldonimo-theme"." | tee -a $log_path
        # Create the folder
        mkdir -p $HOME/.logseq/config
        # Copy the file
        cp ./resources/sheldonimo-theme.css $HOME/.logseq/config/sheldonimo-theme.css
        # modify the file edn
        echo "{:custom-css-url \"@import url('assets:///home/rex/.logseq/config/sheldonimo-theme.css');\"}" >> $HOME/.logseq/config/config.edn
        
        echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} logseq is set up." | tee -a $log_path
    fi
}

function setting_copyq(){

    # Validate if the shortcut exist
    res=$(exist_shortcut "'copyq'" "['<Super>v']")

    if grep -iq '^x|copyq' "$INSTALL_LIST" && [ $res == "false" ]; then
      
        echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} Setting copyq in shortcuts." | tee -a $log_path

        local binding="['<Super>v']"
        local command="'copyq show'"
        local name="'copyq'"

        add_shortcut "$binding" "$command" "$name"

        mkdir -p $HOME/.config/autostart
        cp ./resources/copyq.desktop $HOME/.config/autostart/copyq.desktop

        echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} copyq is set up." | tee -a $log_path
        
    fi

}

function setting_ytfzf(){    
    if grep -iq '^x|ytfzf' "$INSTALL_LIST" && command -v ytfzf &> /dev/null; then
        echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} Setting ytfzf." | tee -a $log_path
        # Setting ytfzf
        installed=""
        # Validate if ranger is not installed in zsh
        if [ -f "$HOME/.zshrc" ] && ! grep -iq '^# <<<--------->>> ytfzf' $HOME/.zshrc; then
            installed="${installed} $HOME/.zshrc"
        fi
        # Validate if git tree visualizations is not installed in bash
        if ! grep -iq '^# <<<--------->>> ytfzf' $HOME/.bashrc; then
            installed="${installed} $HOME/.bashrc"
        fi

        # Setting pyenv in $HOME/.zshrc and $HOME/.bashrc
        for file in $installed; do
            echo "" >> "$file"
            echo "# <<<--------->>> ytfzf <<<--------->>>" >> "$file"
            echo "" >> "$file"
            echo "# Show thumbnails" >> "$file"
            echo " alias yt=\"ytfzf -t\"" >> "$file"
            echo "# Play only the audio and reopen the menu when the video stops playing" >> "$file"
            echo "alias ytm=\"ytfzf -lm\"" >> "$file"
        done

        # Setting ytfzf en $HOME/.config/ytfzf/conf.sh
        # Create the folder
        mkdir -p $HOME/.config/ytfzf
        
        cat << EOF > $HOME/.config/ytfzf/conf.sh
YTFZF_HIST=1                                        # Enables search history in Ytfzf
YTFZF_LOOP=0                                        # Disables looping of videos in Ytfzf
video_pref="bestvideo[height<=?720][fps<=?30]"      # Sets video preference to max 720p resolution and 30 FPS. Another e.i [height<=?1080]
audio_pref='bestaudio/audio'                        # Sets audio preference to best available quality
YTFZF_ENABLE_FZF_DEFAULT_OPTS=1                     # Enables default FZF (Fuzzy Finder) options in Ytfzf
FZF_PLAYER="mpv"                                    # Sets MPV as the default player for Ytfzf
YTFZF_EXTMENU='rofi -dmenu -fuzzy -width 1500'      # Sets Rofi with specific options as external menu for Ytfzf
YTFZF_EXTMENU_LEN=220                               # Specifies the length of the external menu in Ytfzf
invidious_instance="https://inv.zzls.xyz"           # Sets a specific Invidious instance for Ytfzf
EOF

        echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} ytfzf is set up." | tee -a $log_path
    fi
}

# <<<----------------->>> Main <<<----------------->>>
main

# <<<----------------->>> End <<<----------------->>>
echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} Thank you for install developer apps. =D " | tee -a $log_path