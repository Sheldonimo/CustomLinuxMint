#!/usr/bin/env bash
# by: Sheldonimo
# Updated for Linux Mint 22.1 (Ubuntu 24.04 Noble)

function main() {

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

    # Download ranger
    download_ranger

    # # <<--->> Unpackage all files <<--->>

    # # <<--->> Installation all files <<--->>

    # Install Rust via rustup
    install_rust_via_rustup

    # Configurar PATH de cargo
    setting_cargo_path

    # Install zsh
    install_zsh

    # Install plugins zsh
    install_plugins_zsh

    # Install neofetch and htop
    install_neofetch_and_htop

    # Install eza (now available in Ubuntu 24.04 universe)
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

}

# <<<----------------->>> Download functions <<<----------------->>>

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

function download_powerlevel10k() {
    echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} Downloading powerlevel10k." | tee -a $log_path
    # Download powerlevel10k
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git $HOME/.config/powerlevel10k
    echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} powerlevel10k Downloaded." | tee -a $log_path
}

function download_plugins_zsh() {
    echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} Downloading plugins zsh." | tee -a $log_path
    
    # Download plugins zsh
    # Clone repository zsh-syntax-highlighting
        git clone --depth 1 https://github.com/zsh-users/zsh-syntax-highlighting.git ./tmp/zsh-syntax-highlighting

    # Crear directorio y descargar zsh-autosuggestions
    sudo mkdir /usr/local/share/zsh-autosuggestions/
    sudo wget -q --show-progress -O /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh https://raw.githubusercontent.com/zsh-users/zsh-autosuggestions/master/zsh-autosuggestions.zsh

    # Crear directorio y descargar sudo plugin de Oh My Zsh
    sudo mkdir /usr/local/share/zsh-sudo/
    sudo wget -q --show-progress -O /usr/local/share/zsh-sudo/sudo.plugin.zsh https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/plugins/sudo/sudo.plugin.zsh

    # Fin de descarga de plugins zsh
    echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} plugins zsh Downloaded." | tee -a $log_path
}

function download_bat() {
    echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} Downloading bat." | tee -a $log_path
    # Download bat
    html_url=$(get_lastest_url "sharkdp/bat")
    version=$(echo "$html_url" | awk -F'/download/v' '{print $2}')
    file_name="bat_${version}_amd64.deb"
    echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} found lastest version: $html_url" | tee -a $log_path
    
    # Download bat if not exists
    if [ ! -f "./tmp/bat_amd64.deb" ]; then
        echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} Downloading bat." | tee -a $log_path
        wget -q --show-progress -O "./tmp/bat_amd64.deb" $html_url/$file_name
        echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} bat Downloaded." | tee -a $log_path
        # Waiting until all files are downloaded
        wait -n
    fi
}

function download_alacritty(){
    # Download Alacritty
    if [ ! -d "./tmp/Alacritty" ]; then
        echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} Downloading Alacritty." | tee -a $log_path
        git clone --depth 1 https://github.com/alacritty/alacritty.git ./tmp/Alacritty
        echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} Alacritty Downloaded." | tee -a $log_path
        # Waiting until all files are downloaded
        wait -n
    fi
}

function download_ranger(){
    # Download Ranger
    if [ ! -d "./tmp/ranger" ]; then
        echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} Downloading Ranger." | tee -a $log_path
        git clone --depth 1 https://github.com/ranger/ranger.git ./tmp/ranger
        echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} Ranger Downloaded." | tee -a $log_path
        # Waiting until all files are downloaded
        wait -n
    fi
}

# <<<----------------->>> Unpackage functions <<<----------------->>>


# <<<----------------->>> Installation functions <<<----------------->>>

function install_rust_via_rustup(){
    # Instalar Rust usando rustup en lugar de apt para obtener la versión más reciente
    if ! command -v rustc &> /dev/null || [ ! -f "$HOME/.cargo/env" ]; then
        echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} Installing Rust via rustup." | tee -a $log_path
        
        # Remover cualquier versión anterior instalada con apt
        if dpkg -l | grep -q "^ii.*cargo"; then
            echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} Removing old cargo from apt." | tee -a $log_path
            sudo apt remove -y cargo rustc
            sudo apt autoremove -y
        fi
        
        # Instalar curl si no está presente
        if ! command -v curl &> /dev/null; then
            sudo apt install -y curl
        fi
        
        # Instalar Rust usando rustup (versión estable más reciente)
        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
        
        # Cargar las variables de entorno de cargo
        source "$HOME/.cargo/env"
        
        # Actualizar a la versión más reciente
        rustup update stable
        rustup default stable
        
        echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} Rust installed via rustup." | tee -a $log_path
    else
        # Si ya está instalado, actualizar
        source "$HOME/.cargo/env"
        rustup update stable
        echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} Rust is already installed, updated to latest." | tee -a $log_path
    fi
}

function install_zsh(){
    if ! command -v zsh &> /dev/null; then
        echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} Installing zsh." | tee -a $log_path
        # Install zsh
        sudo apt install -y zsh
        echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} zsh Installed." | tee -a $log_path
    fi
}

function install_plugins_zsh(){
    if [ ! -f "/usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]; then
        echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} Installing plugins zsh." | tee -a $log_path
        begin_path=$(pwd)
        # Install plugins zsh
        # Install zsh-syntax-highlighting
        cd ./tmp/zsh-syntax-highlighting
        sudo make install
        # back to original path
        cd $begin_path
        echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} plugins zsh Installed." | tee -a $log_path
    fi

}

function install_neofetch_and_htop(){
    # Validate if neofetch and htop are not installed
    if ! command -v neofetch &> /dev/null && ! command -v htop &> /dev/null; then
        echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} Installing neofetch and htop." | tee -a $log_path
        # Install neofetch and htop
        sudo apt install -y neofetch htop
        echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} neofetch and htop Installed." | tee -a $log_path
    elif ! command -v neofetch &> /dev/null; then
        echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} Installing neofetch." | tee -a $log_path
        # Install neofetch
        sudo apt install -y neofetch
        echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} neofetch Installed." | tee -a $log_path
    elif ! command -v htop &> /dev/null; then
        echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} Installing htop." | tee -a $log_path
        # Install htop
        sudo apt install -y htop
        echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} htop Installed." | tee -a $log_path
    fi 
}

function install_eza(){
    # Validate if eza is not installed
    # NOTE: eza is now available in Ubuntu 24.04 universe repository!
    if ! command -v eza &> /dev/null; then
        echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} Installing eza." | tee -a $log_path
        # Enable universe repository if not enabled
        sudo add-apt-repository universe -y
        sudo apt update
        # Install eza from universe repository
        sudo apt install -y eza
        echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} eza Installed." | tee -a $log_path
    fi
}

function install_bat(){
    # Validate if bat is not installed
    if ! command -v bat &> /dev/null; then
        echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} Installing bat." | tee -a $log_path
        # Install bat
        sudo dpkg -i ./tmp/bat_amd64.deb
        # Fix any dependency issues
        sudo apt-get install -f -y
        echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} bat Installed." | tee -a $log_path
    fi
}

function install_imagemagick(){
    # Validate if imagemagick is not installed
    if ! command -v convert &> /dev/null; then
        echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} Installing imagemagick." | tee -a $log_path
        # Install imagemagick
        sudo apt install -y imagemagick
        echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} imagemagick Installed." | tee -a $log_path
    fi
}

function install_alacritty(){
    # Validate if Alacritty is not installed
    if ! command -v alacritty &> /dev/null; then
        echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} Compiling and Installing Alacritty from source." | tee -a $log_path
        
        # Primero, asegurar que tenemos Rust actualizado via rustup
        install_rust_via_rustup
        
        # Cargar el entorno de cargo
        source "$HOME/.cargo/env"
        
        # Verificar versión de Rust
        rust_version=$(rustc --version | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' | head -1)
        rust_major=$(echo $rust_version | cut -d. -f1)
        rust_minor=$(echo $rust_version | cut -d. -f2)
        
        # Verificar que tenemos al menos Rust 1.85
        if [ "$rust_major" -eq 1 ] && [ "$rust_minor" -lt 85 ]; then
            echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} ERROR: Rust 1.85+ required for Alacritty. Current: $rust_version" | tee -a $log_path
            echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} Installing Alacritty from apt instead." | tee -a $log_path
            sudo apt install -y alacritty
            return
        fi
        
        begin_path=$(pwd)
        
        # Instalar dependencias de compilación
        echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} Installing build dependencies." | tee -a $log_path
        sudo apt install -y cmake pkg-config libfreetype6-dev libfontconfig1-dev \
            libxcb-xfixes0-dev libxkbcommon-dev python3 scdoc
        
        # Compilar Alacritty
        cd ./tmp/Alacritty
        
        # Limpiar cualquier build anterior
        cargo clean
        
        # Compilar con soporte para X11
        echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} Building Alacritty..." | tee -a $log_path
        cargo build --release --no-default-features --features=x11
        
        # Verificar que el binario se compiló
        if [ ! -f "target/release/alacritty" ]; then
            echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} ERROR: Failed to build Alacritty" | tee -a $log_path
            cd $begin_path
            return 1
        fi
        
        # Reducir el tamaño del binario
        strip -s target/release/alacritty
        
        # Instalar Alacritty
        sudo cp target/release/alacritty /usr/local/bin
        sudo cp extra/logo/alacritty-term.svg /usr/share/pixmaps/Alacritty.svg
        sudo desktop-file-install extra/linux/Alacritty.desktop
        sudo update-desktop-database
        
        # Instalar documentación
        if command -v scdoc &> /dev/null; then
            sudo mkdir -p /usr/local/share/man/man1
            sudo mkdir -p /usr/local/share/man/man5
            scdoc < extra/man/alacritty.1.scd | gzip -c | sudo tee /usr/local/share/man/man1/alacritty.1.gz > /dev/null
            scdoc < extra/man/alacritty-msg.1.scd | gzip -c | sudo tee /usr/local/share/man/man1/alacritty-msg.1.gz > /dev/null
            scdoc < extra/man/alacritty.5.scd | gzip -c | sudo tee /usr/local/share/man/man5/alacritty.5.gz > /dev/null
            scdoc < extra/man/alacritty-bindings.5.scd | gzip -c | sudo tee /usr/local/share/man/man5/alacritty-bindings.5.gz > /dev/null
        fi
        
        # NO remover cargo si fue instalado via rustup
        # Solo remover las dependencias de compilación que no se necesitan
        sudo apt remove -y cmake libfreetype6-dev libfontconfig1-dev libxcb-xfixes0-dev libxkbcommon-dev
        sudo apt autoremove -y
        
        cd $begin_path
        echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} Alacritty installed from source." | tee -a $log_path
    fi
}

function install_ranger(){
    # validate if ranger is not installed
    if ! command -v ranger &> /dev/null; then
        echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} Installing Ranger." | tee -a $log_path
        begin_path=$(pwd)
        # Downloading dependencies
        sudo apt install -y python3-dev python3-pip python3-setuptools
        # <<------>> Compile Ranger <<------>>
        cd ./tmp/ranger
        pip3 install .
        # <<------>>  back to original path <<------>> 
        cd $begin_path
        echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} Ranger Installed." | tee -a $log_path
    fi
}

function install_poetry(){
    # validate if poetry is not installed
    if ! command -v poetry &> /dev/null; then
        echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} Installing Poetry." | tee -a $log_path
        # Install poetry
        curl -sSL https://install.python-poetry.org | python3 -
        echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} Poetry Installed." | tee -a $log_path
    fi
}

function install_pyenv(){
    # validate if pyenv is not installed
    if ! command -v pyenv &> /dev/null; then
        echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} Installing pyenv." | tee -a $log_path
        # Install pyenv
        curl https://pyenv.run | bash
        echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} pyenv Installed." | tee -a $log_path
    fi
}

function install_node(){
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
            
            echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_$NODE_MAJOR.x nodistro main" | sudo tee /etc/apt/sources.list.d/nodesource.list > /dev/null
            
            # Update and install Node.js
            sudo apt-get update
            sudo apt-get install nodejs -y
        fi
        echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} Node Installed." | tee -a $log_path
    fi
}

function install_docker(){
    if ! command -v docker &> /dev/null; then
        echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} Installing Docker." | tee -a $log_path
        # Install Docker - Updated for Ubuntu 24.04 Noble
        
        # Remove any existing Docker repositories
        sudo rm -f /etc/apt/sources.list.d/docker.list
        sudo rm -f /etc/apt/keyrings/docker.gpg
        sudo rm -f /etc/apt/keyrings/docker.asc
        
        # Add Docker's official GPG key:
        sudo apt-get update
        sudo apt-get install -y ca-certificates curl gnupg
        sudo install -m 0755 -d /etc/apt/keyrings
        curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
        sudo chmod a+r /etc/apt/keyrings/docker.gpg

        # Add the repository to Apt sources:
        echo \
        "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
        $(. /etc/os-release && echo "$UBUNTU_CODENAME") stable" | \
        sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
        
        sudo apt-get update

        # Install Docker Engine:
        sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

        # Add current user to docker group (optional but recommended)
        sudo usermod -aG docker $USER
        
        echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} Docker Installed." | tee -a $log_path
        echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} NOTE: Log out and back in for docker group changes to take effect." | tee -a $log_path
    fi
}

# <<<----------------->>> Setting functions <<<----------------->>>

function setting_cargo_path(){
    # Función para configurar el PATH de cargo en .zshrc y .bashrc
    echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} Setting Cargo PATH." | tee -a $log_path
    
    # Para .zshrc
    if [ -f "$HOME/.zshrc" ] && ! grep -q 'source "$HOME/.cargo/env"' "$HOME/.zshrc"; then
        echo "" >> "$HOME/.zshrc"
        echo "# <<<--------->>> Rust/Cargo PATH <<<--------->>>" >> "$HOME/.zshrc"
        echo 'source "$HOME/.cargo/env"' >> "$HOME/.zshrc"
    fi
    
    # Para .bashrc
    if ! grep -q 'source "$HOME/.cargo/env"' "$HOME/.bashrc"; then
        echo "" >> "$HOME/.bashrc"
        echo "# <<<--------->>> Rust/Cargo PATH <<<--------->>>" >> "$HOME/.bashrc"
        echo 'source "$HOME/.cargo/env"' >> "$HOME/.bashrc"
    fi
    
    echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} Cargo PATH configured." | tee -a $log_path
}

function setting_zsh_theme(){
    if [ ! -f $HOME/.zshrc ] && [ ! -f $HOME/.p10k.zsh ]; then
        echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} Setting zsh theme." | tee -a $log_path
        cp ./resources/.zshrc $HOME/.zshrc
        cp ./resources/.p10k.zsh $HOME/.p10k.zsh
        echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} zsh theme is set up." | tee -a $log_path
    fi
}

function setting_plugins_zsh(){
    if [ -f "$HOME/.zshrc" ] && ! grep -iq '^# <<<--------->>> Plugins' $HOME/.zshrc; then
        echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} Setting plugins zsh." | tee -a $log_path
        echo "" >> $HOME/.zshrc
        echo "# <<<--------->>> Plugins <<<--------->>>" >> $HOME/.zshrc
        echo "source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >> $HOME/.zshrc
        echo "source /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh" >> $HOME/.zshrc
        echo "source /usr/local/share/zsh-sudo/sudo.plugin.zsh" >> $HOME/.zshrc
        echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} plugins zsh is set up." | tee -a $log_path
    fi 
}

function setting_git_tree_visualizations(){
    # Setting variable to know where to add git tree visualizations
    installed=""
    # Validate if git tree visualizations is not installed in zsh
    if [ -f "$HOME/.zshrc" ] && ! grep -iq '^# <<<--------->>> Git tree Visualizations' $HOME/.zshrc; then
        installed="${installed} $HOME/.zshrc"
    fi
    # Validate if git tree visualizations is not installed in bash
    if ! grep -iq '^# <<<--------->>> Git tree Visualizations' $HOME/.bashrc; then
        installed="${installed} $HOME/.bashrc"
    fi

    if [ -n "$installed" ]; then
        echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} Setting git tree visualizations to bash and zsh." | tee -a $log_path
        for file in $installed; do
            echo "" >> "$file"
            echo "# <<<--------->>> Git tree Visualizations <<<--------->>>" >> "$file"
            echo "# ways to visualize the git log more graphically" >> "$file"
            echo "alias lg=\"lg1\"" >> "$file"
            echo "alias lg1=\"lg1-specific --all\"" >> "$file"
            echo "alias lg2=\"lg2-specific --all\"" >> "$file"
            echo "alias lg3=\"lg3-specific --all\"" >> "$file"
            echo "alias lg1-specific=\"git log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(auto)%d%C(reset)'\"" >> "$file"
            echo "alias lg2-specific=\"git log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold cyan)%aD%C(reset) %C(bold green)(%ar)%C(reset)%C(auto)%d%C(reset)%n''%C(white)%s%C(reset) %C(dim white)- %an%C(reset)'\"" >> "$file"
            echo "alias lg3-specific=\"git log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold cyan)%aD%C(reset) %C(bold green)(%ar)%C(reset) %C(bold cyan)(committed: %cD)%C(reset) %C(auto)%d%C(reset)%n''%C(white)%s%C(reset)%n''%C(dim white)- %an <%ae> %C(reset) %C(dim white)(committer: %cn <%ce>)%C(reset)'\"" >> "$file"
        done
        echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} git tree visualizations is set up." | tee -a $log_path
    fi
}

function setting_eza(){
    echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} Setting eza." | tee -a $log_path
    # Setting eza
    # to $HOME/.zshrc
    if [ -f "$HOME/.zshrc" ] && ! grep -iq '^# <<<--------->>> eza' $HOME/.zshrc; then
        echo "" >> $HOME/.zshrc
        echo "# <<<--------->>> eza <<<--------->>>" >> $HOME/.zshrc
        echo "alias ll=\"eza -alh\"" >> $HOME/.zshrc
        echo "alias la=\"eza -a\"" >> $HOME/.zshrc
        echo "alias l=\"eza -l\"" >> $HOME/.zshrc
        echo "alias ls=\"eza\"" >> $HOME/.zshrc
    fi
    # to $HOME/.bashrc
    if ! grep -iq '^# <<<--------->>> eza' $HOME/.bashrc; then
        echo "" >> $HOME/.bashrc
        echo "# <<<--------->>> eza <<<--------->>>" >> $HOME/.bashrc
        echo "alias ll=\"eza -alh\"" >> $HOME/.bashrc
        echo "alias la=\"eza -a\"" >> $HOME/.bashrc
        echo "alias l=\"eza -l\"" >> $HOME/.bashrc
        echo "alias ls=\"eza\"" >> $HOME/.bashrc
    fi
    echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} eza is set up." | tee -a $log_path
}

function setting_alacritty(){
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
        # Setting alacritty like a default terminal
        dconf write /org/cinnamon/desktop/applications/terminal/exec "'alacritty'"
        # Migrate alacritty settings
        alacritty migrate
        echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} alacritty is set up." | tee -a $log_path
    fi
}

function setting_poetry(){
    if command -v poetry &> /dev/null || [ -f "$HOME/.local/bin/poetry" ]; then
        echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} Setting poetry." | tee -a $log_path
        # Setting poetry
        # to $HOME/.zshrc
        if [ -f "$HOME/.zshrc" ] && ! grep -iq '^# <<<--------->>> Poetry' $HOME/.zshrc; then
            echo "" >> $HOME/.zshrc
            echo "# <<<--------->>> Poetry <<<--------->>>" >> $HOME/.zshrc
            echo "export PATH=\"\$HOME/.local/bin:\$PATH\"" >> $HOME/.zshrc
        fi
        # to $HOME/.bashrc
        if ! grep -iq '^# <<<--------->>> Poetry' $HOME/.bashrc; then
            echo "" >> $HOME/.bashrc
            echo "# <<<--------->>> Poetry <<<--------->>>" >> $HOME/.bashrc
            echo "export PATH=\"\$HOME/.local/bin:\$PATH\"" >> $HOME/.bashrc
        fi
        echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} poetry is set up." | tee -a $log_path
    fi
}

function setting_pyenv(){
    if [ -d "$HOME/.pyenv" ]; then
        echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} Setting pyenv." | tee -a $log_path
        # Setting pyenv
        installed=""
        # Validate if pyenv is not installed in zsh
        if [ -f "$HOME/.zshrc" ] && ! grep -iq '^# <<<--------->>> Pyenv' $HOME/.zshrc; then
            installed="${installed} $HOME/.zshrc"
        fi
        # Validate if git tree visualizations is not installed in bash
        if ! grep -iq '^# <<<--------->>> Pyenv' $HOME/.bashrc; then
            installed="${installed} $HOME/.bashrc"
        fi

        if [ -n "$installed" ]; then
            # Setting pyenv in $HOME/.zshrc and $HOME/.bashrc
            for file in $installed; do
                echo "" >> "$file"
                echo "# <<<--------->>> Pyenv <<<--------->>>" >> "$file"
                echo "" >> "$file"
                echo "# Add Pyenv root path" >> "$file"
                echo "export PYENV_ROOT=\"\$HOME/.pyenv\"" >> "$file"
                echo "" >> "$file"
                echo "# Update PATH for Pyenv" >> "$file"
                echo "[[ -d \$PYENV_ROOT/bin ]] && export PATH=\"\$PYENV_ROOT/bin:\$PATH\"" >> "$file"
                echo "" >> "$file"
                echo "# Initialize Pyenv and Pyenv-Virtualenv" >> "$file"
                echo "eval \"\$(pyenv init -)\"" >> "$file"
                echo "eval \"\$(pyenv virtualenv-init -)\"" >> "$file"
            done
            
            # Installing dependencies to compile python runtime
            sudo apt install -y make build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev libncurses5-dev libncursesw5-dev libffi-dev liblzma-dev libsqlite3-dev tk-dev
        fi
        
        echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} pyenv is set up." | tee -a $log_path
    fi
}

function setting_ranger(){
    if command -v ranger &> /dev/null; then
        echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} Setting ranger." | tee -a $log_path
        # Setting ranger
        installed=""
        # Validate if ranger is not installed in zsh
        if [ -f "$HOME/.zshrc" ] && ! grep -iq '^# <<<--------->>> ranger' $HOME/.zshrc; then
            installed="${installed} $HOME/.zshrc"
        fi
        # Validate if git tree visualizations is not installed in bash
        if ! grep -iq '^# <<<--------->>> ranger' $HOME/.bashrc; then
            installed="${installed} $HOME/.bashrc"
        fi

        if [ -n "$installed" ]; then
            # Setting ranger in $HOME/.zshrc and $HOME/.bashrc
            for file in $installed; do
                echo "" >> "$file"
                echo "# <<<--------->>> ranger <<<--------->>>" >> "$file"
                echo "" >> "$file"
                echo "alias ranger=\"source ranger\"" >> "$file"
                echo "" >> "$file"
                echo "export EDITOR=\"nano\"" >> "$file"
                echo "export VISUAL=\"nano\"" >> "$file"
            done
        fi
        echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} ranger is set up." | tee -a $log_path
    fi
}

# <<<----------------->>> Main <<<----------------->>>
main

# <<<----------------->>> End <<<----------------->>>
echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} Developer apps installation completed successfully! =D " | tee -a $log_path