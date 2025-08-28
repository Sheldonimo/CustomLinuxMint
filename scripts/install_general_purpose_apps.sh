#!/usr/bin/env bash
# by: Sheldonimo
# Updated for Linux Mint 22.1 (Ubuntu 24.04 Noble)

# Define the file with the list of apps to install
INSTALL_LIST="install_list.csv"
# Ubuntu codename
ubuntu_codename=$(grep UBUNTU_CODENAME /etc/os-release | cut -d '=' -f2)

function main() {
    echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} running." | tee -a $log_path
    echo "Installing General purpose apps for Linux Mint 22.1..."

    # Validate if the install_list.csv exists
    if [ ! -f "$INSTALL_LIST" ]; then
        echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} The file $INSTALL_LIST does not exist." | tee -a $log_path
        exit 1
    fi

    # Install pipx first for Python packages
    install_pipx

    # <<--->> Download all files <<--->>

    # Download Logseq
    download_logseq

    # <<--->> Installation all files <<--->>

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

    # Install ytfzf and dependencies
    install_ytfzf

    # Install signal
    install_signal

    # Install blanket
    install_blanket

    # Install miktex
    install_miktex

    # <<--->> Setting configuration in desktop <<--->>

    # Setting vscode
    setting_vscode

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

    # Setting miktex
    setting_miktex
}

# <<<----------------->>> Helper Functions <<<----------------->>>

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

# Better function to get exact asset URL using jq
function get_github_asset_url() {
    local repo="$1"
    local pattern="$2"
    local api_url="https://api.github.com/repos/$repo/releases/latest"
    
    local asset_url=$(curl -fsSL "$api_url" | \
        jq -r ".assets[] | select(.name|test(\"$pattern\")) | .browser_download_url" | \
        head -n1)
    
    if [ -z "$asset_url" ]; then
        echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} No asset found matching pattern: $pattern" | tee -a $log_path
        return 1
    fi
    
    echo "$asset_url"
}

# Function to check if a custom command exists
function exist_shortcut() {
    # Arguments: $1 = name of the custom command, $2 = binding of the custom command
    # 1=rofi , 2=['<Alt>d']
    local name="$1"
    local binding="$2"
    local path_key="/org/cinnamon/desktop/keybindings/custom-keybindings"
    
    # Read the list of custom commands
    local custom_list=$(dconf read /org/cinnamon/desktop/keybindings/custom-list 2>/dev/null || echo "[]")
    
    # Extract the custom command names
    local custom_names=$(echo "$custom_list" | grep -o "custom[0-9]*" || true)
    
    # Check each custom command
    local flag=false
    for item in $custom_names; do
        local dconf_name=$(dconf read "$path_key/$item/name" 2>/dev/null || true)
        local dconf_shortcut=$(dconf read "$path_key/$item/binding" 2>/dev/null || true)
        if [ "$dconf_name" == "$name" ] && [ "$dconf_shortcut" == "$binding" ]; then
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
    local numbers=$(echo "$input_list" | grep -o -E 'custom[0-9]+' | tr -dc '0-9\n' || true)
    
    # Find the maximum index
    for number in $numbers; do
        if (( number > max_index )); then
            max_index=$number
        fi
    done
    
    echo $max_index
}

# Improved function to add a shortcut without overwriting
function add_shortcut() {
    # input example: shortcuts, commands, names
    # Example arguments: 1=['<Alt><Shift>a'], 2='gnome-screenshot -ac', 3='screenshot area'

    local binding="$1"
    local command="$2"
    local name="$3"
    local path_key="/org/cinnamon/desktop/keybindings/custom-keybindings"
    
    # Read current custom list
    local custom_list=$(dconf read /org/cinnamon/desktop/keybindings/custom-list 2>/dev/null || echo "[]")
    
    # Get next index
    local max_custom=$(get_max_custom_index "$custom_list")
    local index=$((max_custom + 1))
    
    # Write the shortcut
    dconf write "$path_key/custom$index/binding" "$binding"
    dconf write "$path_key/custom$index/command" "$command"
    dconf write "$path_key/custom$index/name" "$name"
    
    # Update custom-list by appending the new item
    if [ "$custom_list" == "[]" ]; then
        dconf write /org/cinnamon/desktop/keybindings/custom-list "['custom$index']"
    else
        # Remove closing bracket, add new item, and close
        local updated_list=$(echo "$custom_list" | sed "s/]$/, 'custom$index']/")
        dconf write /org/cinnamon/desktop/keybindings/custom-list "$updated_list"
    fi
    
    echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} Added shortcut: $name" | tee -a $log_path
}

# <<<----------------->>> Download functions <<<----------------->>>

function download_logseq() {
    if grep -iq '^x|logseq' "$INSTALL_LIST" && ! command -v logseq &> /dev/null; then
        echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} Downloading logseq." | tee -a $log_path
        
        # Use better method to get exact AppImage URL
        local asset_url
        if command -v jq &> /dev/null; then
            asset_url=$(get_github_asset_url "logseq/logseq" "Logseq-linux-x64.*AppImage$" || true)
        fi
        
        # Fallback to old method if jq not available
        if [ -z "$asset_url" ]; then
            local html_url=$(get_lastest_url "logseq/logseq")
            local version=$(echo "$html_url" | awk -F'/download/' '{print $2}')
            asset_url="$html_url/Logseq-linux-x64-$version.AppImage"
            
            # Update version in desktop file
            if [ -f "./resources/logseq.desktop" ]; then
                sed -i "s/^Version=.*$/Version=$version/" "./resources/logseq.desktop"
            fi
        fi
        
        # Download the AppImage
        if [ ! -f "./tmp/Logseq-linux-x64.AppImage" ] && [ -n "$asset_url" ]; then
            echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} Downloading from: $asset_url" | tee -a $log_path
            wget -q --show-progress -O "./tmp/Logseq-linux-x64.AppImage" "$asset_url"
            chmod +x "./tmp/Logseq-linux-x64.AppImage"
            echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} Logseq Downloaded." | tee -a $log_path
        fi
        
        # Download the icon
        local icon_url="https://raw.githubusercontent.com/logseq/logseq/master/resources/icons/logseq.png"
        if [ ! -f "./tmp/logseq-icon.png" ]; then
            echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} Downloading logseq icon." | tee -a $log_path
            wget -q --show-progress -O "./tmp/logseq-icon.png" "$icon_url"
            echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} logseq icon Downloaded." | tee -a $log_path
        fi
    fi
}

# <<<----------------->>> Installation functions <<<----------------->>>

function install_pipx() {
    if ! command -v pipx &> /dev/null; then
        echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} Installing pipx for Python package management." | tee -a $log_path
        sudo apt update
        sudo apt install -y pipx
        
        # Add pipx to PATH for current session
        # add for bash
        SHELL=/bin/bash pipx ensurepath
        # add for zsh
        SHELL=/bin/zsh  pipx ensurepath

        export PATH="$HOME/.local/bin:$PATH"
        hash -r
        
        echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} pipx installed." | tee -a $log_path
    else
        # Ensure PATH is set for current session even if pipx already installed
        export PATH="$HOME/.local/bin:$PATH"
        hash -r
    fi
}

function install_imagemagick() {
    if ! command -v convert &> /dev/null; then
        echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} Installing imagemagick." | tee -a $log_path
        sudo apt install -y imagemagick
        echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} imagemagick Installed." | tee -a $log_path
    fi
}

function install_vscode() {
    if grep -iq '^x|vscode' "$INSTALL_LIST" && ! command -v code &> /dev/null; then
        echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} Installing vscode." | tee -a $log_path
        
        # Remove any existing repository
        sudo rm -f /etc/apt/sources.list.d/vscode.list
        sudo rm -f /etc/apt/keyrings/packages.microsoft.gpg
        
        # Add vscode's official GPG key
        curl -fsSL https://packages.microsoft.com/keys/microsoft.asc | \
            sudo gpg --dearmor -o /etc/apt/keyrings/packages.microsoft.gpg
        sudo chmod 644 /etc/apt/keyrings/packages.microsoft.gpg
        
        # Add the repository
        echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" | \
            sudo tee /etc/apt/sources.list.d/vscode.list >/dev/null
        
        # Install vscode
        sudo apt-get update
        sudo apt install -y code
        echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} vscode installed." | tee -a $log_path
    fi
}

function install_copyq() {
    if grep -iq '^x|copyq' "$INSTALL_LIST" && ! command -v copyq &> /dev/null; then
        echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} Installing copyq." | tee -a $log_path
        
        # Add the CopyQ PPA
        sudo add-apt-repository -y ppa:hluk/copyq
        
        # Add architecture amd64
        sudo sed -i "s/^deb \[/deb [arch=amd64 /" "/etc/apt/sources.list.d/hluk-copyq-$ubuntu_codename.list"
        
        # Update and install
        sudo apt update
        sudo apt install -y copyq
        
        echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} copyq installed." | tee -a $log_path
    fi
}

function install_flameshot() {
    if grep -iq '^x|flameshot' "$INSTALL_LIST" && ! command -v flameshot &> /dev/null; then
        echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} Installing flameshot." | tee -a $log_path
        # Install flameshot
        sudo apt-get install -y flameshot
        echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} flameshot installed." | tee -a $log_path
    fi
}

function install_tldr() {
    if grep -iq '^x|tldr' "$INSTALL_LIST" && ! command -v tldr &> /dev/null; then
        echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} Installing tldr using pipx." | tee -a $log_path
        # Install tldr using pipx instead of pip to avoid externally-managed-environment error
        pipx install tldr
        echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} tldr installed." | tee -a $log_path
    fi
}

function install_obs_studio() {
    if grep -iq '^x|obs-studio' "$INSTALL_LIST" && ! command -v obs &> /dev/null; then
        echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} Installing obs-studio." | tee -a $log_path
        
        # For Ubuntu 24.04/Noble, the PPA is not available
        # We'll use Flatpak instead, which is officially recommended
        
        # Check if Flatpak is installed
        if ! command -v flatpak &> /dev/null; then
            echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} Installing Flatpak first." | tee -a $log_path
            sudo apt install -y flatpak
        fi
        
        # Add Flathub repository if not already added
        sudo flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
        
        # Install OBS Studio from Flathub
        echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} Installing OBS Studio via Flatpak." | tee -a $log_path
        sudo flatpak install -y flathub com.obsproject.Studio
        
        # Create wrapper script if not exists
        if [ ! -f "/usr/local/bin/obs" ]; then
            echo '#!/bin/bash' | sudo tee /usr/local/bin/obs > /dev/null
            echo 'flatpak run com.obsproject.Studio "$@"' | sudo tee -a /usr/local/bin/obs > /dev/null
            sudo chmod +x /usr/local/bin/obs
        fi
        
        echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} obs-studio installed via Flatpak." | tee -a $log_path
    fi
}

function install_libreoffice() {
    if grep -iq '^x|libreoffice' "$INSTALL_LIST" && ! command -v libreoffice &> /dev/null; then
        echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} Installing libreoffice." | tee -a $log_path
        
        # Add PPA
        sudo add-apt-repository -y ppa:libreoffice/ppa
        wait -n  # Wait for the process to complete
        # Inform about updating keys due to deprecation of apt-key
        echo "Updating keys as apt-key is deprecated"
        
        # Use modern keyring method instead of apt-key
        # Get the key fingerprint from the PPA
        local key_id=$(sudo apt-key list 2>/dev/null | grep -B 1 -i "LibreOffice Packaging" | awk 'NR==1{print $9$10}' || true)
        
        if [ -n "$key_id" ]; then
            # Export and convert key for new APT keyring system
            sudo apt-key export "$key_id" | sudo gpg --dearmor -o /usr/share/keyrings/libreoffice.gpg
            
            # Add repository with new keyring
            echo "deb [arch=amd64 signed-by=/usr/share/keyrings/libreoffice.gpg] http://ppa.launchpad.net/libreoffice/ppa/ubuntu $ubuntu_codename main" | \
                sudo tee /etc/apt/sources.list.d/libreoffice-ppa.list >/dev/null
            
            # Remove old key
            sudo apt-key del "$key_id" || true
        fi
        
        # Update and install
        sudo apt update
        sudo apt install -y libreoffice
        
        echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} libreoffice installed." | tee -a $log_path
    fi
}

function install_tesseract_ocr() {
    if grep -iq '^x|tesseract' "$INSTALL_LIST" && ! command -v tesseract &> /dev/null; then
        echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} Installing tesseract-ocr." | tee -a $log_path
        
        # Add PPA repository
        sudo add-apt-repository -y ppa:alex-p/tesseract-ocr-devel
        
        # Update and install
        sudo apt update
        # Install tesseract-ocr
        sudo apt install -y tesseract-ocr tesseract-ocr-eng tesseract-ocr-spa tesseract-ocr-osd xclip
        
        # tesseract-ocr is for the ocr
        # tesseract-ocr-eng is for the english language
        # tesseract-ocr-spa is for the spanish language
        # xclip is for copy the text to the clipboard
        echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} tesseract-ocr installed." | tee -a $log_path
    fi
}

function install_ytfzf() {
    if grep -iq '^x|ytfzf' "$INSTALL_LIST" && ! command -v ytfzf &> /dev/null; then
        echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} Installing ytfzf." | tee -a $log_path
        
        # Install dependencies
        sudo apt install -y mpv jq fzf
        
        # Install yt-dlp using pipx if not already installed
        if ! command -v yt-dlp &> /dev/null; then
            pipx install yt-dlp
        fi
        
        # Install ueberzugcpp
        UBUNTU_CODE=$(inxi -Sx | awk -F'Ubuntu ' '/base:/ {print $2}'| cut -d' ' -f1)  
        # inxi -Sx: Runs 'inxi' to display system info with extra details.
        # | (pipe): Passes output of the previous command to the next.
        # awk -F'Ubuntu ': Uses 'awk' with field separator set to 'Ubuntu '.
        #   '/base:/ {print $2}': In 'awk', searches lines containing 'base:' and prints the second field.
        # | (pipe): Again, passes output to the next command.
        # cut -d'  ' -f1: Uses 'cut' with delimiter as two spaces, extracts the first field.
        
        echo "deb [arch=amd64] http://download.opensuse.org/repositories/home:/justkidding/xUbuntu_${UBUNTU_CODE}/Release.key" | \
            gpg --dearmor | sudo tee /etc/apt/keyrings/ueberzugpp.gpg > /dev/null
        
        echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/ueberzugpp.gpg] http://download.opensuse.org/repositories/home:/justkidding/xUbuntu_${UBUNTU_CODE}/ /" | \
            sudo tee /etc/apt/sources.list.d/ueberzugpp.list
        
        sudo apt update
        sudo apt install -y ueberzugpp
        
        # Install ytfzf
        if [ ! -d "./tmp/ytfzf" ]; then
            git clone --depth 1 https://github.com/pystardust/ytfzf ./tmp/ytfzf
        fi
        
        (cd ./tmp/ytfzf && sudo make install doc)
        
        echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} ytfzf installed." | tee -a $log_path
    fi
}

function install_signal() {
    if grep -iq '^x|signal' "$INSTALL_LIST" && ! command -v signal-desktop &> /dev/null; then
        echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} Installing signal." | tee -a $log_path
        
        # Install official public software signing key
        wget -q --show-progress -O- https://updates.signal.org/desktop/apt/keys.asc | \
            gpg --dearmor | sudo tee /usr/share/keyrings/signal-desktop-keyring.gpg > /dev/null
        
        # Add repository
        echo 'deb [arch=amd64 signed-by=/usr/share/keyrings/signal-desktop-keyring.gpg] https://updates.signal.org/desktop/apt xenial main' | \
            sudo tee /etc/apt/sources.list.d/signal-xenial.list
        
        # Update and install
        sudo apt update && sudo apt install -y signal-desktop
        
        echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} signal installed." | tee -a $log_path
    fi
}

function install_blanket() {
    if grep -iq '^x|blanket' "$INSTALL_LIST" && ! command -v blanket &> /dev/null; then
        echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} Installing blanket using Flatpak." | tee -a $log_path
        
        # Check if Flatpak is installed
        if ! command -v flatpak &> /dev/null; then
            echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} Installing Flatpak first." | tee -a $log_path
            sudo apt install -y flatpak
        fi
        
        # Add Flathub repository
        sudo flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
        
        # Install Blanket
        echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} Installing Blanket via Flatpak." | tee -a $log_path
        sudo flatpak install -y flathub com.rafaelmardojai.Blanket
        
        # Create wrapper script if not exists
        if [ ! -f "/usr/local/bin/blanket" ]; then
            echo '#!/bin/bash' | sudo tee /usr/local/bin/blanket > /dev/null
            echo 'flatpak run com.rafaelmardojai.Blanket "$@"' | sudo tee -a /usr/local/bin/blanket > /dev/null
            sudo chmod +x /usr/local/bin/blanket
        fi
        
        echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} blanket installed via Flatpak." | tee -a $log_path
    fi
}

function install_miktex() {
    if grep -iq '^x|miktex' "$INSTALL_LIST" && ! command -v miktexsetup &> /dev/null; then
        echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} Installing miktex." | tee -a $log_path
        
        # Remove old repository if exists
        sudo rm -f /etc/apt/sources.list.d/miktex.list
        sudo rm -f /usr/share/keyrings/miktex-keyring.gpg
        
        # Add repository
        curl -fsSL https://miktex.org/download/key | \
            gpg --dearmor | sudo tee /usr/share/keyrings/miktex-keyring.gpg >/dev/null
        
        echo "deb [arch=amd64 signed-by=/usr/share/keyrings/miktex-keyring.gpg] https://miktex.org/download/ubuntu $ubuntu_codename universe" | \
            sudo tee /etc/apt/sources.list.d/miktex.list
        
        # Update and install
        sudo apt-get update
        # Install miktex
        sudo apt-get install -y miktex
        
        # Finish installation
        sudo miktexsetup --shared=yes finish
        sudo initexmf --admin --set-config-value [MPM]AutoInstall=1
        
        echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} miktex installed." | tee -a $log_path
    fi
}

# <<<----------------->>> Setting functions <<<----------------->>>

function setting_vscode() {
    if grep -iq '^x|vscode' "$INSTALL_LIST" && command -v code &> /dev/null; then
        echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} Setting vscode." | tee -a $log_path
        
        # Create config directory if not exists
        mkdir -p "$HOME/.config/Code/User"
        
        # Create initial settings.json if not exists
        if [ ! -f "$HOME/.config/Code/User/settings.json" ]; then
            echo '{}' > "$HOME/.config/Code/User/settings.json"
        fi
        
        # Check if jq is available for better JSON handling
        if command -v jq &> /dev/null; then
            # Create comprehensive settings
            local tmp=$(mktemp)
            cat > "$tmp" << 'EOF'
{
  "editor.bracketPairColorization.independentColorPoolPerBracketType": true,
  "security.workspace.trust.untrustedFiles": "newWindow",
  "telemetry.telemetryLevel": "off",
  "editor.fontFamily": "'FiraCode Nerd Font', 'Hack Nerd Font Mono', 'monospace', monospace",
  "editor.fontLigatures": true,
  "diffEditor.maxComputationTime": 0,
  "[python]": {"editor.formatOnType": true},
  "files.associations": {"*.md": "markdown"},
  "cSpell.userWords": ["Sheldonimo"],
  "cSpell.enableFiletypes": ["tex","markdown"],
  "gitlens.telemetry.enabled": false,
  "latex-workshop.latex.autoBuild.run": "onSave",
  "latex-workshop.latex.autoBuild.interval": 1000,
  "latex-workshop.latex.autoClean.run": "onBuilt",
  "latex-workshop.view.pdf.viewer": "tab",
  "latex-workshop.showContextMenu": true,
  "workbench.editorAssociations": {
    "*.pdf": "latex-workshop-pdf-hook"
  }
}
EOF
            
            # Merge settings
            if jq empty "$tmp" >/dev/null 2>&1; then
                jq -s '.[0] * .[1]' "$HOME/.config/Code/User/settings.json" "$tmp" > "$tmp.merged" && \
                    mv "$tmp.merged" "$HOME/.config/Code/User/settings.json"
                echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} VS Code settings merged successfully." | tee -a $log_path
            else
                echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} Error: Invalid JSON in VS Code config" | tee -a $log_path
            fi
            rm -f "$tmp" "$tmp.merged"
        else
            # Fallback to Python script if available
            if [ -f "./resources/add_json_setting.py" ]; then
                # Add settings one by one using Python script
                # Add bracket Pair Colorization
                python3 ./resources/add_json_setting.py "$HOME/.config/Code/User/settings.json" '{"editor.bracketPairColorization.independentColorPoolPerBracketType": true}'
                # Opens untrusted files in restricted window.
                python3 ./resources/add_json_setting.py "$HOME/.config/Code/User/settings.json" '{"security.workspace.trust.untrustedFiles": "newWindow"}'
                # Disable telemetry
                python3 ./resources/add_json_setting.py "$HOME/.config/Code/User/settings.json" '{"telemetry.telemetryLevel": "off"}'
                # Add fonts to vscode
                python3 ./resources/add_json_setting.py "$HOME/.config/Code/User/settings.json" "{\"editor.fontFamily\": \"'FiraCode Nerd Font', 'Hack Nerd Font Mono', 'monospace', monospace\"}"
                # Add ligatures to vscode
                python3 ./resources/add_json_setting.py "$HOME/.config/Code/User/settings.json" '{"editor.fontLigatures": true}'
                # Set unlimited time for diff editor computations.
                python3 ./resources/add_json_setting.py "$HOME/.config/Code/User/settings.json" '{"diffEditor.maxComputationTime": 0}'
                # Applies the following settings only to Python files and Auto-formats code on typing in Python files.
                python3 ./resources/add_json_setting.py "$HOME/.config/Code/User/settings.json" '{"[python]": {"editor.formatOnType": true}}'
                # Associates *.md files with Markdown format.
                python3 ./resources/add_json_setting.py "$HOME/.config/Code/User/settings.json" '"files.associations": {"*.md": "markdown"}'
                #* Using vscode extension called "Code spell Checker"
                # Custom word list for the spell checker and add the word "Sheldonimo" to the spell checker dictionary.
                python3 ./resources/add_json_setting.py "$HOME/.config/Code/User/settings.json" '{"cSpell.userWords": ["Sheldonimo"]}'
                # Defines file types for spell checking.
                python3 ./resources/add_json_setting.py "$HOME/.config/Code/User/settings.json" '{"cSpell.enableFiletypes": ["tex","markdown"]}'
                #* Using vscode extension called "Gitlens"
                # Disable telemetry in gitlens
                python3 ./resources/add_json_setting.py "$HOME/.config/Code/User/settings.json" '{"gitlens.telemetry.enabled": false}'

            else
                echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} Warning: jq not available and Python script not found" | tee -a $log_path
            fi
        fi
        
        echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} Setting vscode completed." | tee -a $log_path
    fi
}

function setting_tesseract_ocr() {
    if grep -iq '^x|tesseract' "$INSTALL_LIST" && command -v tesseract &> /dev/null; then
        # Create .local/bin if it doesn't exist
        mkdir -p $HOME/.local/bin
        
        # Create OCR script if not exists
        if [ ! -f "$HOME/.local/bin/ocr_flameshot" ]; then
            cat > "$HOME/.local/bin/ocr_flameshot" << 'EOF'
#!/usr/bin/env bash
# by: Sheldonimo
flameshot gui --raw | tesseract stdin stdout -l eng+spa --psm 6 | xclip -in -selection clipboard
EOF
            chmod +x "$HOME/.local/bin/ocr_flameshot"
        fi
        
        # Add shortcut if not exists
        local res=$(exist_shortcut "'ocr_flameshot'" "['<Alt><Shift>z']")

        if [ "$res" == "false" ]; then

            echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} Setting tesseract-ocr shortcut." | tee -a $log_path

            local binding="['<Alt><Shift>z']"
            local command="'$HOME/.local/bin/ocr_flameshot'"
            # Commands:
            # - flameshot gui --raw | tesseract stdin stdout -l eng+spa --psm 6 | xclip -in -selection clipboard
            # - gnome-screenshot -ac && xclip -selection clipboard -t image/png -o | tesseract stdin stdout -l eng+spa --psm 6 | xclip -in -selection clipboard
            local name="'ocr_flameshot'"

            add_shortcut "$binding" "$command" "$name"

            echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} tesseract-ocr is set up." | tee -a $log_path
        fi
    fi
}

function setting_flameshot() {
    if grep -iq '^x|flameshot' "$INSTALL_LIST" && command -v flameshot &> /dev/null; then
        local res=$(exist_shortcut "'flameshot'" "['<Alt><Shift>q']")
        
        if [ "$res" == "false" ]; then
            echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} Setting flameshot shortcut." | tee -a $log_path
            
            local binding="['<Alt><Shift>q']"
            local command="'flameshot gui'"
            local name="'flameshot'"

            add_shortcut "$binding" "$command" "$name"
            echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} flameshot is set up." | tee -a $log_path
        fi
    fi
}

function setting_logseq() {
    if grep -iq '^x|logseq' "$INSTALL_LIST" && ! command -v logseq &> /dev/null; then
        echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} Setting logseq." | tee -a $log_path
        
        # Create directories
        mkdir -p $HOME/.local/share/applications
        mkdir -p $HOME/.local/share/logseq
        mkdir -p $HOME/.local/bin
        
        # Copy AppImage
        cp ./tmp/Logseq-linux-x64.AppImage $HOME/.local/share/logseq/Logseq-linux-x64.AppImage
        chmod +x $HOME/.local/share/logseq/Logseq-linux-x64.AppImage
        
        # Install imagemagick if needed
        install_imagemagick
        
        # Create icons
        if [ -f "./tmp/logseq-icon.png" ]; then
            local sizes=(16 24 32 48 64 128 512)
            for size in "${sizes[@]}"; do
                mkdir -p "$HOME/.local/share/icons/hicolor/${size}x${size}/apps"
                convert "./tmp/logseq-icon.png" -resize "${size}x${size}" \
                    "$HOME/.local/share/icons/hicolor/${size}x${size}/apps/logseq-icon.png"
            done
        fi
        
        # Create launcher script
        if [ -f "./resources/logseq" ]; then
            cp ./resources/logseq $HOME/.local/bin/logseq
            chmod +x $HOME/.local/bin/logseq
        else
            # Create simple launcher if resource not available
            cat > "$HOME/.local/bin/logseq" << 'EOF'
#!/bin/bash
exec "$HOME/.local/share/logseq/Logseq-linux-x64.AppImage" "$@"
EOF
            chmod +x "$HOME/.local/bin/logseq"
        fi
        
        # Create desktop file
        if [ -f "./resources/logseq.desktop" ]; then
            sed "s|~|$HOME|g" "./resources/logseq.desktop" > "$HOME/.local/share/applications/logseq.desktop"
        fi
        
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
            
            # Update config.edn
            if [ ! -f "$HOME/.logseq/config/config.edn" ]; then
                echo "{:custom-css-url \"@import url('assets://$HOME/.logseq/config/sheldonimo-theme.css');\"}" > \
                    $HOME/.logseq/config/config.edn
            fi
        fi
        
        echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} logseq is set up." | tee -a $log_path
    fi
}

function setting_copyq() {
    if grep -iq '^x|copyq' "$INSTALL_LIST" && command -v copyq &> /dev/null; then
        local res=$(exist_shortcut "'copyq'" "['<Super>v']")
        
        if grep -iq '^x|copyq' "$INSTALL_LIST" && [ $res == "false" ]; then
        
            echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} Setting copyq in shortcuts." | tee -a $log_path

            local binding="['<Super>v']"
            local command="'copyq show'"
            local name="'copyq'"
                
            add_shortcut "$binding" "$command" "$name"

            mkdir -p $HOME/.config/autostart
            if [ -f "./resources/copyq.desktop" ]; then
                cp ./resources/copyq.desktop $HOME/.config/autostart/copyq.desktop
            fi
            
            echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} copyq is set up." | tee -a $log_path
       
        fi
    fi
}

function setting_ytfzf() {
    if grep -iq '^x|ytfzf' "$INSTALL_LIST" && command -v ytfzf &> /dev/null; then
        echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} Setting ytfzf." | tee -a $log_path
        
        local installed=""
        
        # Check zshrc
        if [ -f "$HOME/.zshrc" ] && ! grep -iq '^# <<<--------->>> ytfzf' $HOME/.zshrc; then
            installed="${installed} $HOME/.zshrc"
        fi
        
        # Check bashrc
        if ! grep -iq '^# <<<--------->>> ytfzf' $HOME/.bashrc; then
            installed="${installed} $HOME/.bashrc"
        fi
        
        # Add aliases
        if [ -n "$installed" ]; then
            # Setting ytfzf in $HOME/.zshrc and $HOME/.bashrc
            for file in $installed; do
                cat >> "$file" << 'EOF'

# <<<--------->>> ytfzf <<<--------->>>

# Show thumbnails
alias yt="ytfzf -t"
# Play only the audio and reopen the menu when the video stops playing
alias ytm="ytfzf -lm"
EOF
            done
        fi
        
        # Create config
        mkdir -p $HOME/.config/ytfzf
        
        cat > "$HOME/.config/ytfzf/conf.sh" << 'EOF'
YTFZF_HIST=1                                        # Enables search history in Ytfzf
YTFZF_LOOP=0                                        # Disables looping of videos in Ytfzf
video_pref="bestvideo[height<=?720][fps<=?30]"      # Sets video preference to max 720p resolution and 30 FPS. Another e.i [height<=?1080]
audio_pref='bestaudio/audio'                        # Sets audio preference to best available quality
YTFZF_ENABLE_FZF_DEFAULT_OPTS=1                     # Enables default FZF (Fuzzy Finder) options in Ytfzf
FZF_PLAYER="mpv"                                    # Sets MPV as the default player for Ytfzf
YTFZF_EXTMENU='rofi -dmenu -fuzzy -width 1500'      # Sets Rofi with specific options as external menu for Ytfzf
YTFZF_EXTMENU_LEN=220                               # Specifies the length of the external menu in Ytfzf
invidious_instance="https://vid.puffyan.us"         # Sets a specific Invidious instance for Ytfzf
EOF
        
        echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} ytfzf is set up." | tee -a $log_path
    fi
}

function setting_miktex(){
    if grep -iq '^x|miktex' "$INSTALL_LIST" && command -v code &> /dev/null; then
        echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} Setting miktex." | tee -a $log_path
        # Crear un archivo temporal
        tmpfile=$(mktemp)

        # Escribir el JSON en el archivo temporal
        cat > $tmpfile << EOF
{
    "latex-workshop.latex.autoBuild.run": "onSave",
    "latex-workshop.latex.autoBuild.interval": 1000,
    "latex-workshop.latex.recipes": [
      {
          "name": "xelatex -> biber -> xelatex*2",
          "tools": [
              "xelatex",
              "biber",
              "xelatex",
              "xelatex"
          ]
      }  
  ],
  "latex-workshop.latex.tools": [
      {
          "name": "pdflatex",
          "command": "pdflatex",
          "args": [
              "-synctex=1",
              "-interaction=nonstopmode",
              "-file-line-error",
              "%DOC%"
          ]
      },
      {
          "name": "bibtex",
          "command": "bibtex",
          "args": [
              "%DOCFILE%"
          ]
      },
      {
          "name": "biber",
          "command": "biber",
          "args": [
              "%DOCFILE%"
          ]
      },
      {
          "name": "xelatex",
          "command": "xelatex",
          "args": [
              "-synctex=1",
              "-interaction=nonstopmode",
              "-file-line-error",
              "%DOC%"
          ]
      }
  
  ]
    ,"latex-workshop.latex.autoClean.run": "onBuilt",
    "latex-workshop.latex.clean.fileTypes": [
    "*.aux",
    "*.bbl",
    "*.blg",
    "*.idx",
    "*.ind",
    "*.lof",
    "*.lot",
    "*.out",
    "*.toc",
    "*.acn",
    "*.acr",
    "*.alg",
    "*.glg",
    "*.glo",
    "*.gls",
    "*.ist",
    "*.fls",
    "*.log",
    "*.fdb_latexmk",
    "*.synctex.gz",
    "*.bcf",
    "*.run.xml"
    ], 
      "latex-workshop.view.pdf.viewer": "tab",
    
    "latex-workshop.showContextMenu": true,
    "workbench.editorAssociations": {
      "*.pdf": "latex-workshop-pdf-hook"
    }
}
EOF

        # Ejecutar el script de Python con el contenido del archivo temporal
        python3 ./resources/add_json_setting.py "$HOME/.config/Code/User/settings.json" "$(cat $tmpfile)"

        # Eliminar el archivo temporal
        rm $tmpfile
        
        echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} miktex is set up." | tee -a $log_path
    fi
}

# <<<----------------->>> Main <<<----------------->>>
main

# <<<----------------->>> End <<<----------------->>>
echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} General purpose apps installation completed successfully! =D " | tee -a $log_path