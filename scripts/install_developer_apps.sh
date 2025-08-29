#!/usr/bin/env bash
# by: Sheldonimo
# Updated for Linux Mint 22.1 (Ubuntu 24.04 Noble)

function main() {
    # Set error handling
    set -euo pipefail
    IFS=$'\n\t'

    echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} running." | tee -a $log_path
    echo "Installing Developer apps for Linux Mint 22.1..."

    # # <<--->> Download all files <<--->>

    # Download powerlevel10k
    download_powerlevel10k

    # Download plugins zsh
    download_plugins_zsh

    # Download bat
    download_bat

    # Download Alacritty
    download_alacritty

    # Download ExifTool
    download_exiftool

    # Download PDFjam
    download_pdfjam

    # # <<--->> Installation all files <<--->>

    # Install build dependencies once
    install_build_dependencies

    # Install pipx
    install_pipx

    # Install Rust via rustup
    install_rust_via_rustup

    # Configure PATH for cargo
    setting_cargo_path

    # Install zsh
    install_zsh

    # Install plugins zsh
    install_plugins_zsh

    # Install fastfetch and htop and btop
    install_fastfetch_and_htop_and_btop

    # Install eza
    install_eza

    # Install bat
    install_bat

    # Install imagemagick
    install_imagemagick

    # Install alacritty
    install_alacritty

    # Install ranger
    install_ranger

    # Install poetry
    install_poetry

    # Install pyenv
    install_pyenv

    # Install Node
    install_node

    # Install Docker
    install_docker

    # Install ExifTool
    install_exiftool

    # Install PDFjam
    install_pdfjam

    # Install yt2text
    install_yt2text

    # <<--->> Setting configuration in desktop <<--->>

    # Setting zsh
    setting_zsh_theme

    # Setting plugins zsh
    setting_plugins_zsh

    # Settings git tree visualizations
    setting_git_tree_visualizations

    # Settings eza
    setting_eza

    # Settings alacritty
    setting_alacritty

    # Settings poetry
    setting_poetry

    # Settings pyenv
    setting_pyenv

    # Settings ranger
    setting_ranger

    # Change default shell to zsh
    change_default_shell
}

# <<<----------------->>> Helper functions <<<----------------->>>

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

# Install build dependencies once at the beginning
function install_build_dependencies() {
    echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} Installing build dependencies." | tee -a $log_path

    # Base dependencies to compile and install from source code.
    # Each package is preceded by a comment indicating WHICH PROJECT/FUNCTION of the script uses it.
    sudo apt update
    local pkgs=(
        build-essential    # Needed by Alacritty, pyenv, ExifTool → basic compilers and 'make'
        cmake              # Needed by Alacritty → C/C++ build system
        pkg-config         # Needed by Alacritty, pyenv → tool to detect system libraries

        libfreetype6-dev   # Needed by Alacritty → font rendering library
        libfontconfig1-dev # Needed by Alacritty → font discovery/management library
        libxcb-xfixes0-dev # Needed by Alacritty (X11) → X11 Xfixes extension
        libxkbcommon-dev   # Needed by Alacritty (X11) → keyboard handling library

        python3            # Needed by ranger, helper scripts → Python interpreter
        python3-dev        # Needed by pyenv → Python headers for building extensions
        python3-pip        # Needed by ranger, pipx → Python package manager
        python3-setuptools # Needed by Python packaging → packaging tools for Python

        scdoc              # Needed by Alacritty → man page generator
        curl               # Needed by Rust, Node, Docker installs → HTTP downloader
        wget               # Needed by download_bat, other scripts → file downloader
        git                # Needed by Alacritty, zsh plugins, ExifTool → repository cloning
        make               # Needed by pyenv, ExifTool → classic build tool

        libssl-dev         # Needed by pyenv → SSL support library for Python
        zlib1g-dev         # Needed by pyenv → zlib compression support
        libbz2-dev         # Needed by pyenv → bzip2 compression support
        libreadline-dev    # Needed by pyenv → readline support for Python REPL
        libncurses5-dev    # Needed by pyenv → ncurses text UI support
        libncursesw5-dev   # Needed by pyenv → wide-char ncurses support
        libffi-dev         # Needed by pyenv → FFI support for ctypes/cffi
        liblzma-dev        # Needed by pyenv → lzma/xz compression support
        libsqlite3-dev     # Needed by pyenv → sqlite3 database support
        tk-dev             # Needed by pyenv → Tkinter GUI support

        ca-certificates    # Needed by Rust, Node, Docker installs → system TLS certificates
        gnupg              # Needed by Node, Docker installs → GPG for repository keys

        perl               # Needed by ExifTool → Perl interpreter
        libperl-dev        # Needed by ExifTool → Perl development headers

        texlive-latex-base  # Needed by PDFjam → basic LaTeX packages
        texlive-latex-extra # Needed by PDFjam → extra LaTeX packages
    )

    sudo apt install -y "${pkgs[@]}"

    echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} Build dependencies installed." | tee -a $log_path
}

# <<<----------------->>> Download functions <<<----------------->>>

function download_powerlevel10k() {
    if [ ! -d "$HOME/.config/powerlevel10k" ]; then
        echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} Downloading powerlevel10k." | tee -a $log_path
        git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$HOME/.config/powerlevel10k"
        echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} powerlevel10k Downloaded." | tee -a $log_path
    else
        echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} Updating powerlevel10k." | tee -a $log_path
        git -C "$HOME/.config/powerlevel10k" pull --ff-only
    fi
}

function download_plugins_zsh() {
    echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} Downloading plugins zsh." | tee -a $log_path
    
    # Download zsh-syntax-highlighting
    if [ ! -d "./tmp/zsh-syntax-highlighting" ]; then
        git clone --depth 1 https://github.com/zsh-users/zsh-syntax-highlighting.git ./tmp/zsh-syntax-highlighting
    fi

    # Create directories for other plugins
    sudo mkdir -p /usr/local/share/zsh-autosuggestions/
    sudo mkdir -p /usr/local/share/zsh-sudo/
    
    # Download plugins if not exists
    if [ ! -f "/usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ]; then
        sudo wget -q --show-progress -O /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh \
            https://raw.githubusercontent.com/zsh-users/zsh-autosuggestions/master/zsh-autosuggestions.zsh
    fi
    
    if [ ! -f "/usr/local/share/zsh-sudo/sudo.plugin.zsh" ]; then
        sudo wget -q --show-progress -O /usr/local/share/zsh-sudo/sudo.plugin.zsh \
            https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/plugins/sudo/sudo.plugin.zsh
    fi
    
    echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} plugins zsh Downloaded." | tee -a $log_path
}

function download_bat() {
    echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} Checking bat." | tee -a $log_path
    
    local html_url=$(get_lastest_url "sharkdp/bat")
    local version=$(echo "$html_url" | awk -F'/download/v' '{print $2}')
    local file_name="bat_${version}_amd64.deb"
    local file_path="./tmp/bat_${version}_amd64.deb"
    
    echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} Latest bat version: $version" | tee -a $log_path
    
    # Download bat if this version doesn't exist
    if [ ! -f "$file_path" ]; then
        echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} Downloading bat $version." | tee -a $log_path
        wget -q --show-progress -O "$file_path" "$html_url/$file_name"
        echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} bat Downloaded." | tee -a $log_path
    else
        echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} bat $version already downloaded." | tee -a $log_path
    fi
}

function download_alacritty() {
    if [ ! -d "./tmp/Alacritty" ]; then
        echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} Downloading Alacritty." | tee -a $log_path
        git clone --depth 1 https://github.com/alacritty/alacritty.git ./tmp/Alacritty
        
        # Checkout latest stable tag
        cd ./tmp/Alacritty
        git fetch --tags --quiet
        latest_tag=$(git describe --tags "$(git rev-list --tags --max-count=1)" 2>/dev/null)
        git checkout "$latest_tag"
        cd - > /dev/null
        
        echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} Alacritty Downloaded (version $latest_tag)." | tee -a $log_path
    fi
}

function download_exiftool() {
    if [ ! -d "./tmp/exiftool" ]; then
        echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} Downloading ExifTool." | tee -a $log_path
        git clone --depth 1 https://github.com/exiftool/exiftool.git ./tmp/exiftool
        
        # Checkout latest stable tag
        cd ./tmp/exiftool
        git fetch --tags --quiet
        latest_tag=$(git describe --tags "$(git rev-list --tags --max-count=1)" 2>/dev/null)
        git checkout "$latest_tag"
        cd - > /dev/null
        
        echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} ExifTool Downloaded (version $latest_tag)." | tee -a $log_path
    fi
}

function download_pdfjam() {
    if [ ! -d "./tmp/pdfjam" ]; then
        echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} Downloading PDFjam." | tee -a $log_path
        git clone --depth 1 https://github.com/pdfjam/pdfjam.git ./tmp/pdfjam
        
        # Checkout latest stable tag if available
        cd ./tmp/pdfjam
        git fetch --tags --quiet
        latest_tag=$(git describe --tags "$(git rev-list --tags --max-count=1)" 2>/dev/null)
        if [ "$latest_tag" != "main" ]; then
            git checkout "$latest_tag"
        fi
        cd - > /dev/null
        
        echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} PDFjam Downloaded (version $latest_tag)." | tee -a $log_path
    fi
}

# <<<----------------->>> Installation functions <<<----------------->>>

function install_rust_via_rustup() {
    # Instalar Rust usando rustup en lugar de apt para obtener la versión más reciente
    if ! command -v rustc &> /dev/null || [ ! -f "$HOME/.cargo/env" ]; then
        echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} Installing Rust via rustup." | tee -a $log_path
        
        # Remove any old version installed with apt
        if dpkg -l | grep -q "^ii.*cargo"; then
            echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} Removing old cargo from apt." | tee -a $log_path
            sudo apt remove -y cargo rustc || true
            sudo apt autoremove -y
        fi
        
        # Install Rust using rustup
        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
        
        # Load cargo environment
        source "$HOME/.cargo/env"
        
        # Update to latest stable
        rustup update stable
        rustup default stable
        
        echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} Rust installed via rustup." | tee -a $log_path
    else
        # Update if already installed
        source "$HOME/.cargo/env"
        rustup update stable
        echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} Rust is already installed, updated to latest." | tee -a $log_path
    fi
}

function install_zsh() {
    if ! command -v zsh &> /dev/null; then
        echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} Installing zsh." | tee -a $log_path
        # Install zsh
        sudo apt install -y zsh
        echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} zsh Installed." | tee -a $log_path
    fi
}

function install_plugins_zsh() {
    # Check against the correct path
    if [ ! -f "/usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]; then
        echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} Installing plugins zsh." | tee -a $log_path
        
        if [ -d "./tmp/zsh-syntax-highlighting" ]; then
            local begin_path=$(pwd)
            cd ./tmp/zsh-syntax-highlighting
            sudo make install
            cd "$begin_path"
            echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} plugins zsh Installed." | tee -a $log_path
        fi
    fi
}

function install_fastfetch_and_htop_and_btop() {
    local packages_to_install=()
    local need_update=false
    
    # Check and prepare fastfetch
    if ! command -v fastfetch &> /dev/null; then
        echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} Checking fastfetch PPA." | tee -a $log_path
        
        if ! grep -q "zhangsongcui3371/fastfetch" /etc/apt/sources.list /etc/apt/sources.list.d/* 2>/dev/null; then
            echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} Adding fastfetch PPA." | tee -a $log_path
            sudo add-apt-repository -y ppa:zhangsongcui3371/fastfetch
            need_update=true
        fi
    fi
    
    # Update if needed
    if [ "$need_update" = true ]; then
        sudo apt update
    fi
    
    # Install each package separately to avoid complete failure
    if ! command -v fastfetch &> /dev/null; then
        if sudo apt install -y fastfetch 2>/dev/null; then
            echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} fastfetch installed successfully." | tee -a $log_path
        else
            echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} WARNING: fastfetch not available in repositories." | tee -a $log_path
        fi
    fi
    
    if ! command -v htop &> /dev/null; then
        if sudo apt install -y htop; then
            echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} htop installed successfully." | tee -a $log_path
        else
            echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} ERROR: Failed to install htop." | tee -a $log_path
        fi
    fi
    
    if ! command -v btop &> /dev/null; then
        if sudo apt install -y btop; then
            echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} btop installed successfully." | tee -a $log_path
        else
            echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} ERROR: Failed to install btop." | tee -a $log_path
        fi
    fi
}

function install_eza() {
    if ! command -v eza &> /dev/null; then
        echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} Installing eza." | tee -a $log_path
        sudo add-apt-repository universe -y
        sudo apt update
        sudo apt install -y eza
        echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} eza Installed." | tee -a $log_path
    fi
}

function install_bat() {
    if ! command -v bat &> /dev/null; then
        echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} Installing bat." | tee -a $log_path
        
        # Find the latest downloaded version
        local bat_deb=$(ls -t ./tmp/bat_*.deb 2>/dev/null | head -1)
        
        if [ -f "$bat_deb" ]; then
            if sudo dpkg -i "$bat_deb"; then
                echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} bat Installed." | tee -a $log_path
            else
                # Try to fix dependencies if dpkg failed
                echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} Fixing dependencies..." | tee -a $log_path
                if sudo apt-get install -f -y; then
                    echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} bat Installed after fixing dependencies." | tee -a $log_path
                else
                    echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} ERROR: Failed to install bat." | tee -a $log_path
                    return 1
                fi
            fi
        else
            echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} ERROR: bat .deb file not found." | tee -a $log_path
            return 1
        fi
    else
        echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} bat is already installed." | tee -a $log_path
    fi
}

function install_imagemagick() {
    # Validate if imagemagick is not installed
    if ! command -v convert &> /dev/null; then
        echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} Installing imagemagick." | tee -a $log_path
        # Install imagemagick
        sudo apt install -y imagemagick
        echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} imagemagick Installed." | tee -a $log_path
    fi
}

function install_alacritty() {
    # Validate if Alacritty is not installed
    if ! command -v alacritty &> /dev/null; then
        echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} Compiling and Installing Alacritty from source." | tee -a $log_path
        
        # Ensure Rust is installed and updated
        install_rust_via_rustup
        
        # Load cargo environment
        source "$HOME/.cargo/env"
        
        # Verify Rust version
        local rust_version=$(rustc --version | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' | head -1)
        local rust_major=$(echo $rust_version | cut -d. -f1)
        local rust_minor=$(echo $rust_version | cut -d. -f2)
        
        if [ "$rust_major" -eq 1 ] && [ "$rust_minor" -lt 85 ]; then
            echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} WARNING: Rust 1.85+ recommended. Installing from apt instead." | tee -a $log_path
            sudo apt install -y alacritty
            return
        fi
        
        local begin_path=$(pwd)
        cd ./tmp/Alacritty
        
        # Clean any previous build
        cargo clean
        
        # Build with X11 support
        echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} Building Alacritty..." | tee -a $log_path
        cargo build --release --no-default-features --features=x11
        
        # Verify that the binary was built successfully
        if [ ! -f "target/release/alacritty" ]; then
            echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} ERROR: Failed to build Alacritty" | tee -a $log_path
            cd "$begin_path"
            return 1
        fi
        
        # Optimize binary size
        strip -s target/release/alacritty
        
        # Install Alacritty
        sudo cp target/release/alacritty /usr/local/bin
        sudo cp extra/logo/alacritty-term.svg /usr/share/pixmaps/Alacritty.svg
        sudo desktop-file-install extra/linux/Alacritty.desktop
        sudo update-desktop-database
        
        # Install documentation if scdoc is available
        if command -v scdoc &> /dev/null; then
            sudo mkdir -p /usr/local/share/man/man1
            sudo mkdir -p /usr/local/share/man/man5
            scdoc < extra/man/alacritty.1.scd | gzip -c | sudo tee /usr/local/share/man/man1/alacritty.1.gz > /dev/null
            scdoc < extra/man/alacritty-msg.1.scd | gzip -c | sudo tee /usr/local/share/man/man1/alacritty-msg.1.gz > /dev/null
            scdoc < extra/man/alacritty.5.scd | gzip -c | sudo tee /usr/local/share/man/man5/alacritty.5.gz > /dev/null
            scdoc < extra/man/alacritty-bindings.5.scd | gzip -c | sudo tee /usr/local/share/man/man5/alacritty-bindings.5.gz > /dev/null
        fi
        
        cd "$begin_path"
        echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} Alacritty installed from source." | tee -a $log_path
    fi
}

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

function install_ranger() {
    if ! command -v ranger &> /dev/null; then
        echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} Installing Ranger." | tee -a $log_path
        pipx install ranger-fm
        echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} Ranger installed via pipx." | tee -a $log_path
    fi
}

function install_poetry() {
    # validate if poetry is not installed
    if ! command -v poetry &> /dev/null; then
        echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} Installing Poetry." | tee -a $log_path
        # Install poetry
        curl -sSL https://install.python-poetry.org | python3 -
        echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} Poetry Installed." | tee -a $log_path
    fi
}

function install_pyenv() {
    # validate if pyenv is not installed
    if ! command -v pyenv &> /dev/null; then
        echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} Installing pyenv." | tee -a $log_path
        # Install pyenv
        curl https://pyenv.run | bash
        echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} pyenv Installed." | tee -a $log_path
    fi
}

function install_node() {
    # validate if node is not installed
    if ! command -v node &> /dev/null; then
        echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} Installing Node." | tee -a $log_path
        # Install Node
        # Getting the latest LTS version of Node
        NODE_MAJOR=$(curl -s https://deb.nodesource.com/ | grep "Install Node.js" | sed 's/.*Install Node.js \([0-9]*\).*/\1/')
        # Validate if NODE_MAJOR is a number
        if [[ $NODE_MAJOR =~ ^[0-9]{2}$ ]]; then
            sudo apt-get update && sudo apt-get install -y ca-certificates curl gnupg
            
            # Download and add NodeSource GPG key
            curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg
            
            echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_$NODE_MAJOR.x nodistro main" | \
                sudo tee /etc/apt/sources.list.d/nodesource.list > /dev/null
            
            # Update and install Node.js
            sudo apt-get update
            sudo apt-get install nodejs -y
        fi
        echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} Node Installed." | tee -a $log_path
    fi
}

function install_docker() {
    if ! command -v docker &> /dev/null; then
        echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} Installing Docker." | tee -a $log_path
        # Install Docker - Updated for Ubuntu 24.04 Noble

        # Remove any existing Docker repositories
        sudo rm -f /etc/apt/sources.list.d/docker.list
        sudo rm -f /etc/apt/keyrings/docker.gpg
        sudo rm -f /etc/apt/keyrings/docker.asc
        
        # Add Docker's official GPG key
        sudo apt-get update
        sudo apt-get install -y ca-certificates curl gnupg
        sudo install -m 0755 -d /etc/apt/keyrings
        curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
        sudo chmod a+r /etc/apt/keyrings/docker.gpg

        # Add the repository to Apt sources
        echo \
        "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
        $(. /etc/os-release && echo "$UBUNTU_CODENAME") stable" | \
        sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
        
        sudo apt-get update

        # Install Docker Engine
        sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

        # Add current user to docker group
        sudo usermod -aG docker $USER
        
        echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} Docker Installed." | tee -a $log_path
        echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} NOTE: Log out and back in for docker group changes to take effect." | tee -a $log_path
    
    else
        # Also check if user is in docker group even if docker is installed
        if ! groups $USER | grep -q docker; then
            echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} Adding $USER to docker group." | tee -a $log_path
            sudo usermod -aG docker $USER
            echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} NOTE: Log out and back in for docker group changes to take effect." | tee -a $log_path
        fi

    fi
}

function install_exiftool() {
    # Validate if ExifTool is not installed
    if ! command -v exiftool &> /dev/null; then
        echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} Compiling and Installing ExifTool from source." | tee -a $log_path
        
        local begin_path=$(pwd)
        cd ./tmp/exiftool
        
        # Build ExifTool using Perl's standard build process
        echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} Building ExifTool..." | tee -a $log_path
        
        # Generate Makefile
        perl Makefile.PL
        
        # Compile
        make
        
        # Test the build (optional but recommended)
        echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} Testing ExifTool build..." | tee -a $log_path
        make test
        
        # Install ExifTool
        echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} Installing ExifTool..." | tee -a $log_path
        sudo make install
        
        cd "$begin_path"
        echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} ExifTool installed from source." | tee -a $log_path
        
        # Verify installation
        local exiftool_version=$(exiftool -ver 2>/dev/null || echo "Error getting version")
        echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} ExifTool version: $exiftool_version" | tee -a $log_path
    fi
}

function install_pdfjam() {
    # Validate if PDFjam is not installed
    if ! command -v pdfjam &> /dev/null; then
        echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} Installing PDFjam from source." | tee -a $log_path
        
        local begin_path=$(pwd)
        cd ./tmp/pdfjam
        
        # PDFjam uses a simple installation process
        echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} Installing PDFjam..." | tee -a $log_path
        
        # Make scripts executable
        chmod +x ./pdfjam
        
        # Copy binaries to system path
        sudo cp ./pdfjam /usr/local/bin/
        
        # Copy man pages if they exist
        if [ -d "man1" ]; then
            sudo mkdir -p /usr/local/share/man/man1
            sudo cp doc/pdfjam.1 /usr/local/share/man/man1/
            sudo gzip /usr/local/share/man/man1/pdfjam.1 2>/dev/null || true
        fi
        
        cd "$begin_path"
        echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} PDFjam installed from source." | tee -a $log_path
        
        # Verify installation
        if command -v pdfjam &> /dev/null; then
            local pdfjam_version=$(pdfjam --version 2>/dev/null | head -1 || echo "PDFjam installed successfully")
            echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} PDFjam: $pdfjam_version" | tee -a $log_path
        else
            echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} WARNING: PDFjam installation may have failed." | tee -a $log_path
        fi
    fi
}

function install_yt2text() {
    # Solo instalar si no existe ya en el PATH
    if ! command -v yt2text &> /dev/null; then
        echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} Installing yt2text." | tee -a $log_path

        local begin_path=$(pwd)
        local src_dir="./resources"

        if [ ! -d "$src_dir" ]; then
            echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} WARNING: $src_dir not found. Skipping yt2text." | tee -a $log_path
            return 0
        fi

        cd "$src_dir"

        # Asegurar permisos de ejecución
        if [ -f "yt2text" ]; then
            chmod +x yt2text
            # Instalar binario/script en /usr/local/bin
            sudo install -m 0755 yt2text /usr/local/bin/yt2text
        else
            echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} WARNING: yt2text script not found in $src_dir." | tee -a $log_path
        fi

        # Instalar página de manual si existe
        if ls yt2text.1 >/dev/null 2>&1; then
            sudo mkdir -p /usr/local/share/man/man1
            sudo cp ./yt2text.1 /usr/local/share/man/man1/
            # Comprimir si no está comprimido; ignorar errores si ya está .gz
            if [ -f "/usr/local/share/man/man1/yt2text.1" ]; then
                sudo gzip -f /usr/local/share/man/man1/yt2text.1 2>/dev/null || true
            fi
            # Actualizar base de datos de man si está disponible
            if command -v mandb >/dev/null 2>&1; then
                sudo mandb -q || true
            fi
        fi

        cd "$begin_path"
        echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} yt2text installed." | tee -a $log_path

        # Verificar instalación
        if command -v yt2text &> /dev/null; then
            local yt2_version=$(yt2text -h 2>/dev/null | head -1 || echo "yt2text installed successfully")
            echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} yt2text: $yt2_version" | tee -a $log_path
        else
            echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} WARNING: yt2text installation may have failed." | tee -a $log_path
        fi
    fi
}


# <<<----------------->>> Setting functions <<<----------------->>>

function setting_cargo_path() {
    # Function to configure the PATH of cargo in .zshrc and .bashrc
    echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} Setting Cargo PATH." | tee -a $log_path
    
    # For .zshrc
    if [ -f "$HOME/.zshrc" ] && ! grep -q 'source "$HOME/.cargo/env"' "$HOME/.zshrc"; then
        echo "" >> "$HOME/.zshrc"
        echo "# <<<--------->>> Rust/Cargo PATH <<<--------->>>" >> "$HOME/.zshrc"
        echo 'source "$HOME/.cargo/env"' >> "$HOME/.zshrc"
    fi
    
    # For .bashrc
    if ! grep -q 'source "$HOME/.cargo/env"' "$HOME/.bashrc"; then
        echo "" >> "$HOME/.bashrc"
        echo "# <<<--------->>> Rust/Cargo PATH <<<--------->>>" >> "$HOME/.bashrc"
        echo 'source "$HOME/.cargo/env"' >> "$HOME/.bashrc"
    fi
    
    echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} Cargo PATH configured." | tee -a $log_path
}

function setting_zsh_theme() {
    if [ ! -f $HOME/.zshrc ] || [ ! -f $HOME/.p10k.zsh ]; then
        echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} Setting zsh theme." | tee -a $log_path
        
        if [ ! -f "$HOME/.zshrc" ]; then
            cp ./resources/.zshrc $HOME/.zshrc
        fi
        
        if [ ! -f "$HOME/.p10k.zsh" ]; then
            cp ./resources/.p10k.zsh $HOME/.p10k.zsh
        fi
        
        echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} zsh theme is set up." | tee -a $log_path
    fi
}

function setting_plugins_zsh() {
    if [ -f "$HOME/.zshrc" ] && ! grep -iq '^# <<<--------->>> Plugins' $HOME/.zshrc; then
        echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} Setting plugins zsh." | tee -a $log_path
        echo "" >> $HOME/.zshrc
        echo "# <<<--------->>> Plugins <<<--------->>>" >> $HOME/.zshrc
        echo "source /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh" >> $HOME/.zshrc
        echo "source /usr/local/share/zsh-sudo/sudo.plugin.zsh" >> $HOME/.zshrc
        # zsh-syntax-highlighting should be loaded last
        echo "source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >> $HOME/.zshrc
        echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} plugins zsh is set up." | tee -a $log_path
    fi 
}

function setting_git_tree_visualizations() {
    # Dónde agregar los aliases de visualización de git tree
    local -a targets=()
    local marker='^# <<<--------->>> Git tree Visualizations'
    
    # Revisa .zshrc y .bashrc: si no existe o no tiene el marcador, añadir
    for f in "$HOME/.zshrc" "$HOME/.bashrc"; do
        if ! grep -iq "$marker" "$f" 2>/dev/null; then
            targets+=("$f")
        fi
    done

    if ((${#targets[@]} > 0)); then
        echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} Setting git tree visualizations." | tee -a "$log_path"
        for file in "${targets[@]}"; do
            # Asegura que el directorio exista y el archivo también
            mkdir -p "$(dirname "$file")"
            touch "$file"
            cat >> "$file" << 'EOF'

# <<<--------->>> Git tree Visualizations <<<--------->>>
# ways to visualize the git log more graphically
alias lg="lg1"
alias lg1="lg1-specific --all"
alias lg2="lg2-specific --all"
alias lg3="lg3-specific --all"
alias lg1-specific="git log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(auto)%d%C(reset)'"
alias lg2-specific="git log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold cyan)%aD%C(reset) %C(bold green)(%ar)%C(reset)%C(auto)%d%C(reset)%n''%C(white)%s%C(reset) %C(dim white)- %an%C(reset)'"
alias lg3-specific="git log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold cyan)%aD%C(reset) %C(bold green)(%ar)%C(reset) %C(bold cyan)(committed: %cD)%C(reset) %C(auto)%d%C(reset)%n''%C(white)%s%C(reset)%n''%C(dim white)- %an <%ae> %C(reset) %C(dim white)(committer: %cn <%ce>)%C(reset)'"
EOF
        done
        echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} git tree visualizations is set up." | tee -a "$log_path"
    fi
}


function setting_eza() {
    echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} Setting eza." | tee -a $log_path
    # Setting eza
    # to $HOME/.zshrc
    if [ -f "$HOME/.zshrc" ] && ! grep -iq '^# <<<--------->>> eza' $HOME/.zshrc; then
        cat >> $HOME/.zshrc << 'EOF'

# <<<--------->>> eza <<<--------->>>
alias ll="eza -alh"
alias la="eza -a"
alias l="eza -l"
alias ls="eza"
EOF
    fi
    
    if ! grep -iq '^# <<<--------->>> eza' $HOME/.bashrc; then
        cat >> $HOME/.bashrc << 'EOF'

# <<<--------->>> eza <<<--------->>>
alias ll="eza -alh"
alias la="eza -a"
alias l="eza -l"
alias ls="eza"
EOF
    fi
    
    echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} eza is set up." | tee -a $log_path
}

function setting_alacritty() {
    if command -v alacritty &> /dev/null; then
        echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} Setting alacritty." | tee -a $log_path
        # <<----------->> Setting alacritty <<----------->>
        # Copy format alacritty
        mkdir -p $HOME/.config/alacritty
        
        if [ -f "./resources/alacritty.yml" ]; then
            cp ./resources/alacritty.yml $HOME/.config/alacritty/alacritty.yml
        fi
        
        if [ -f "./resources/alacritty.toml" ]; then
            cp ./resources/alacritty.toml $HOME/.config/alacritty/alacritty.toml
        fi
        
        # Set alacritty as default terminal
        dconf write /org/cinnamon/desktop/applications/terminal/exec "'alacritty'"
        
        # Migrate alacritty settings
        alacritty migrate || true
        
        echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} alacritty is set up." | tee -a $log_path
    fi
}

function setting_poetry() {
    if command -v poetry &> /dev/null || [ -f "$HOME/.local/bin/poetry" ]; then
        echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} Setting poetry." | tee -a $log_path
        # Setting poetry
        # to $HOME/.zshrc
        if [ -f "$HOME/.zshrc" ] && ! grep -iq '^# <<<--------->>> Poetry' $HOME/.zshrc; then
            cat >> $HOME/.zshrc << 'EOF'

# <<<--------->>> Poetry <<<--------->>>
export PATH="$HOME/.local/bin:$PATH"
EOF
        fi
        
        if ! grep -iq '^# <<<--------->>> Poetry' $HOME/.bashrc; then
            cat >> $HOME/.bashrc << 'EOF'

# <<<--------->>> Poetry <<<--------->>>
export PATH="$HOME/.local/bin:$PATH"
EOF
        fi
        
        echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} poetry is set up." | tee -a $log_path
    fi
}

function setting_pyenv() {
    if [ -d "$HOME/.pyenv" ]; then
        echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} Setting pyenv." | tee -a "$log_path"

        local -a targets=()
        local marker='^# <<<--------->>> Pyenv'

        for f in "$HOME/.zshrc" "$HOME/.bashrc"; do
            if ! grep -iq "$marker" "$f" 2>/dev/null; then
                targets+=("$f")
            fi
        done

        if ((${#targets[@]} > 0)); then
            for file in "${targets[@]}"; do
                mkdir -p "$(dirname "$file")"
                touch "$file"
                cat >> "$file" << 'EOF'

# <<<--------->>> Pyenv <<<--------->>>

# Add Pyenv root path
export PYENV_ROOT="$HOME/.pyenv"

# Update PATH for Pyenv
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"

# Initialize Pyenv and Pyenv-Virtualenv
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"
EOF
            done
        fi

        echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} pyenv is set up." | tee -a "$log_path"
    fi
}


function setting_ranger() {
    if command -v ranger &> /dev/null; then
        echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} Setting ranger." | tee -a "$log_path"

        local -a targets=()
        local marker='^# <<<--------->>> ranger'

        for f in "$HOME/.zshrc" "$HOME/.bashrc"; do
            if ! grep -iq "$marker" "$f" 2>/dev/null; then
                targets+=("$f")
            fi
        done

        if ((${#targets[@]} > 0)); then
            for file in "${targets[@]}"; do
                mkdir -p "$(dirname "$file")"
                touch "$file"
                cat >> "$file" << 'EOF'

# <<<--------->>> ranger <<<--------->>>

# Function to change directory with ranger
ranger-cd() {
    local tmp="$(mktemp)"
    ranger --choosedir="$tmp" "${@:-$PWD}"
    if [ -f "$tmp" ] && [ -s "$tmp" ]; then
        cd "$(cat "$tmp")"
    fi
    rm -f "$tmp"
}

alias r="ranger-cd"

export EDITOR="nano"
export VISUAL="nano"
EOF
            done
        fi

        echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} ranger is set up." | tee -a "$log_path"
    fi
}


function change_default_shell() {
    if command -v zsh &> /dev/null; then
        local current_shell=$(echo $SHELL)
        local zsh_path=$(command -v zsh)
        
        if [ "$current_shell" != "$zsh_path" ]; then
            echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} Changing default shell to zsh." | tee -a $log_path
            echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} NOTE: You may need to enter your password." | tee -a $log_path
            chsh -s "$zsh_path" || true
            echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} Default shell changed to zsh. Please log out and back in." | tee -a $log_path
        fi
    fi
}

# <<<----------------->>> Main <<<----------------->>>
main

# <<<----------------->>> End <<<----------------->>>
echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} Developer apps installation completed successfully! =D " | tee -a $log_path