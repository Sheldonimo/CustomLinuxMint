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

    # Install obs-studio
    install_obs_studio

    # Install libreoffice
    install_libreoffice

    # Install tesseract-ocr
    install_tesseract_ocr

    # <<--->> Setting configuration in desktop <<--->>

    # Setting logseq
    setting_logseq

    # Setting plugins zsh
    #setting_plugins_zsh

    # Settings git tree visualizations
    #setting_git_tree_visualizations


}

# <<<----------------->>> Download functions <<<----------------->>>

function download_logseq() {
    if grep -iq '^x|logseq' "$INSTALL_LIST"; then
        echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} Downloading logseq." | tee -a $log_path
        # Download logseq
        # Get the latest release from github
        html_url=$(get_lastest_url "logseq/logseq")

        # Get the version from the url
        version=$(echo "$html_url" | awk -F'/download/' '{print $2}')

        # Get the file name from the url
        file_name="Logseq-linux-x64-$version.AppImage"

        echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} found lastest version: $html_url" | tee -a $log_path

        # Download the file
        if [ ! -f "./tmp/Logseq-linux-x64.AppImage" ]; then
            echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} Downloading Logseq." | tee -a $log_path
            curl -L --output "./tmp/Logseq-linux-x64.AppImage" $html_url/$file_name
            echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} Logseq Downloaded." | tee -a $log_path
            # Waiting until all files are downloaded
            wait -n
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

function install_vscode() {
    if grep -iq '^x|vscode' "$INSTALL_LIST" && ! command -v code &> /dev/null; then
        echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} Installing vscode." | tee -a $log_path
        # Install vscode
        # Add vscode's official GPG key:
        curl -fsSL https://packages.microsoft.com/keys/microsoft.asc | sudo gpg --dearmor -o /etc/apt/keyrings/packages.microsoft.gpg
        sudo chmod 644 /etc/apt/keyrings/packages.microsoft.gpg
        # Add the repository to Apt sources:
        echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" | sudo tee /etc/apt/sources.list.d/vscode.list >/dev/null
        # Install Docker Engine:
        sudo apt-get update
        sudo apt-get install code -y
        echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} vscode installed." | tee -a $log_path
    fi
}

function install_copyq() {
    if grep -iq '^x|copyq' "$INSTALL_LIST" && ! command -v copyq &> /dev/null; then
        echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} Installing copyq." | tee -a $log_path
        # Install copyq
        # Add the CopyQ PPA (Personal Package Archive) to the system
        sudo add-apt-repository -y ppa:hluk/copyq
        wait -n  # Wait for the process to complete
        # Inform about updating keys due to deprecation of apt-key
        echo "Updating keys as apt-key is deprecated"
        # Extract the key associated with Lukas Holecek
        key=$(sudo apt-key list 2>/dev/null | grep -B 1 -i "Lukas Holecek" | awk 'NR==1{print $9$10}')
        # Export the key and convert it for the new APT keyring system
        sudo apt-key export $key | sudo gpg --dearmour -o /usr/share/keyrings/copyq.gpg
        # Inform about updating the key in the repositories
        # Add the repository with the new keyring path
        echo "deb [arch=amd64 signed-by=/usr/share/keyrings/copyq.gpg] http://ppa.launchpad.net/hluk/copyq/ubuntu $ubuntu_codename main" | sudo tee /etc/apt/sources.list.d/hluk-copyq.list >/dev/null
        # Removing the key from the deprecated path
        sudo apt-key del $key
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

function install_obs_studio() {
    if grep -iq '^x|obs-studio' "$INSTALL_LIST" && ! command -v obs &> /dev/null; then
        echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} Installing obs-studio." | tee -a $log_path
        # Install dependencies
        sudo apt install ffmpeg -y
        # Install obs-studio
        sudo add-apt-repository -y ppa:obsproject/obs-studio
        wait -n  # Wait for the process to complete
        # Inform about updating keys due to deprecation of apt-key
        echo "Updating keys as apt-key is deprecated"
        # Extract the key associated with obsproject
        key=$(sudo apt-key list 2>/dev/null | grep -B 1 -i "obsproject" | awk 'NR==1{print $9$10}')
        # Export the key and convert it for the new APT keyring system
        sudo apt-key export $key | sudo gpg --dearmour -o /usr/share/keyrings/obs-studio.gpg
        # Inform about updating the key in the repositories
        # Add the repository with the new keyring path
        echo "deb [arch=amd64 signed-by=/usr/share/keyrings/obs-studio.gpg] http://ppa.launchpad.net/obsproject/obs-studio/ubuntu $ubuntu_codename main" | sudo tee /etc/apt/sources.list.d/obsproject-obs-studio.list >/dev/null
        # Removing the key from the deprecated path
        sudo apt-key del $key
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
    if grep -iq '^x|tesseract-ocr' "$INSTALL_LIST" && ! command -v tesseract &> /dev/null; then
        echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} Installing tesseract-ocr." | tee -a $log_path
        # Add ppa repository
        sudo add-apt-repository -y ppa:alex-p/tesseract-ocr-devel
        wait -n  # Wait for the process to complete
        # Update the repositories
        sudo apt update
        # Install tesseract-ocr
        sudo apt install tesseract-ocr tesseract-ocr-eng tesseract-ocr-spa tesseract-ocr-osd -y
        echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} tesseract-ocr installed." | tee -a $log_path
    fi
}

# <<<----------------->>> Setting functions <<<----------------->>>

function setting_tesseract_ocr(){
    if grep -iq '^x|tesseract-ocr' "$INSTALL_LIST"; then

        # flameshot gui --raw | tesseract stdin stdout -l eng+spa --psm 6 | xclip -in -selection clipboard
        # gnome-screenshot -ac && xclip -selection clipboard -t image/png -o | tesseract stdin stdout -l eng+spa --psm 6 | xclip -in -selection clipboard

        echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} tesseract-ocr setted." | tee -a $log_path
    fi
}

function setting_logseq() {
    if grep -iq '^x|logseq' "$INSTALL_LIST"; then
        echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} Setting logseq." | tee -a $log_path
        # Setting logseq
        # Create the folder
        mkdir -p ~/.local/share/applications
        # Copy the file
        cp ./tmp/Logseq-linux-x64.AppImage ~/.local/share/applications/Logseq-linux-x64.AppImage
        # Create the file
        touch ~/.local/share/applications/Logseq.desktop
        # Add the content
        echo "[Desktop Entry]" >> ~/.local/share/applications/Logseq.desktop
        echo "Name=Logseq" >> ~/.local/share/applications/Logseq.desktop
        echo "Exec=~/.local/share/applications/Logseq-linux-x64.AppImage" >> ~/.local/share/applications/Logseq.desktop
        echo "Icon=" >> ~/.local/share/applications/Logseq.desktop
        echo "Type=Application" >> ~/.local/share/applications/Logseq.desktop
        echo "Categories=Development;" >> ~/.local/share/applications/Logseq.desktop
        echo "Terminal=false" >> ~/.local/share/applications/Logseq.desktop
        echo "StartupWMClass=Logseq" >> ~/.local/share/applications/Logseq.desktop
        echo "Comment=Logseq" >> ~/.local/share/applications/Logseq.desktop
        echo "MimeType=application/x-executable;" >> ~/.local/share/applications/Logseq.desktop
        echo "Keywords=Logseq;" >> ~/.local/share/applications/Logseq.desktop
        echo "Actions=" >> ~/.local/share/applications/Logseq.desktop
        echo "X-Desktop-File-Install-Version=0.26" >> ~/.local/share/applications/Logseq.desktop
        echo "X-AppImage-Version=0.0.1" >> ~/.local/share/applications/Logseq.desktop
        echo "X-AppImage-BuildId=0.0.1" >> ~/.local/share/applications/Logseq.desktop
        echo "X-AppImage-Comment=Generated by appimagetool" >> ~/.local/share/applications/Logseq.desktop
        echo "X-AppImage-Arch=x86_64" >> ~/.local/share/applications/Logseq.desktop
        echo "X-AppImage-Name=Logseq" >> ~/.local/share/applications/Logseq.desktop
        echo "X-AppImage-Type=appimage" >> ~/.local/share/applications/Logseq.desktop

        echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} logseq setted." | tee -a $log_path
    fi
}

# <<<----------------->>> Main <<<----------------->>>
main

# <<<----------------->>> End <<<----------------->>>
echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} Thank you for install developer apps. =D " | tee -a $log_path