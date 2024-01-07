#!/usr/bin/env bash
# by: Sheldonimo

function main() {

    echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} running." | tee -a $log_path
    echo "Installing Developer apps..."

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

    # Install zsh
    install_zsh

    # Install plugins zsh
    install_plugins_zsh

    # Install neofetch and htop
    install_neofetch_and_htop

    # Install exa
    install_exa

    # Install bat
    install_bat

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

    # Settings exa
    setting_exa

    # Settings alacritty
    setting_alacritty

    # Settings poetry
    setting_poetry

    # Settings pyenv
    setting_pyenv

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
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/.config/powerlevel10k
    echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} powerlevel10k Downloaded." | tee -a $log_path
}

function download_plugins_zsh() {
    echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} Downloading plugins zsh." | tee -a $log_path
    # Download plugins zsh
    # Clone repository zsh-syntax-highlighting
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ./tmp/zsh-syntax-highlighting

    # Crear directorio y descargar zsh-autosuggestions
    sudo mkdir /usr/local/share/zsh-autosuggestions/
    sudo wget -O /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh https://raw.githubusercontent.com/zsh-users/zsh-autosuggestions/master/zsh-autosuggestions.zsh

    # Crear directorio y descargar sudo plugin de Oh My Zsh
    sudo mkdir /usr/local/share/zsh-sudo/
    sudo wget -O /usr/local/share/zsh-sudo/sudo.plugin.zsh https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/plugins/sudo/sudo.plugin.zsh

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
    # Download Capitaine Cursors
    if [ ! -f "./tmp/bat_amd64.deb" ]; then
    echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} Downloading bat." | tee -a $log_path
    curl -L --output "./tmp/bat_amd64.deb" $html_url/$file_name
    echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} bat Downloaded." | tee -a $log_path
    # Waiting until all files are downloaded
    wait -n
    fi
}

function download_alacritty(){
    # Download Alacritty
    if [ ! -d "./tmp/Alacritty" ]; then
        echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} Downloading Alacritty." | tee -a $log_path
        git clone https://github.com/alacritty/alacritty.git ./tmp/Alacritty
        echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} Alacritty Downloaded." | tee -a $log_path
        # Waiting until all files are downloaded
        wait -n
    fi
}

function download_ranger(){
    # Download Ranger
    if [ ! -d "./tmp/ranger" ]; then
        echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} Downloading Ranger." | tee -a $log_path
        git clone https://github.com/ranger/ranger.git ./tmp/ranger
        echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} Ranger Downloaded." | tee -a $log_path
        # Waiting until all files are downloaded
        wait -n
    fi
}

# <<<----------------->>> Unpackage functions <<<----------------->>>


# <<<----------------->>> Installation functions <<<----------------->>>

function install_zsh(){
    if ! command -v zsh &> /dev/null; then
        echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} Installing zsh." | tee -a $log_path
        # Install green icons
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

function install_exa(){
    # Validate if exa is not installed
    if ! command -v exa &> /dev/null; then
        echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} Installing exa." | tee -a $log_path
        # Install exa
        # "Source: https://the.exa.website/#installation"
        # "Download: exa A modern replacement for ls"
        sudo apt install -y exa
        echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} exa Installed." | tee -a $log_path
    fi
}

function install_bat(){
    # Validate if bat is not installed
    if ! command -v bat &> /dev/null; then
        echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} Installing bat." | tee -a $log_path
        # Install bat
        sudo dpkg -i ./tmp/bat_amd64.deb
        echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} bat Installed." | tee -a $log_path
    fi
}

function install_alacritty(){
    # Validate if Alacritty is not installed
    if ! command -v alacritty &> /dev/null; then
        echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} Compiling and Installing Alacritty." | tee -a $log_path
        begin_path=$(pwd)
        # Downloading dependencies
        sudo apt install -y cmake pkg-config libfreetype6-dev libfontconfig1-dev libxcb-xfixes0-dev libxkbcommon-dev python3
        sudo apt install -y cargo scdoc
        # <<------>> Compile Alacritty <<------>>
        cd ./tmp/Alacritty
        # Force support for only X11 in the build
        cargo build --release --no-default-features --features=x11
        # Using strip -s to reduce the size of the binary
        strip -s target/release/alacritty
        # <<------>> Compile Alacritty <<----->>
        # Copy Alacritty binary to system's bin directory for global access
        sudo cp target/release/alacritty /usr/local/bin
        # Place Alacritty logo in system's pixmaps directory for icon usage
        sudo cp extra/logo/alacritty-term.svg /usr/share/pixmaps/Alacritty.svg
        # Install Alacritty's desktop file for integration with application menus
        sudo desktop-file-install extra/linux/Alacritty.desktop
        # Update system's application database to recognize Alacritty
        sudo update-desktop-database
        # <<------>> Installing documentation <<------>>
        sudo mkdir -p /usr/local/share/man/man1
        sudo mkdir -p /usr/local/share/man/man5
        scdoc < extra/man/alacritty.1.scd | gzip -c | sudo tee /usr/local/share/man/man1/alacritty.1.gz > /dev/null
        scdoc < extra/man/alacritty-msg.1.scd | gzip -c | sudo tee /usr/local/share/man/man1/alacritty-msg.1.gz > /dev/null
        scdoc < extra/man/alacritty.5.scd | gzip -c | sudo tee /usr/local/share/man/man5/alacritty.5.gz > /dev/null
        scdoc < extra/man/alacritty-bindings.5.scd | gzip -c | sudo tee /usr/local/share/man/man5/alacritty-bindings.5.gz > /dev/null
        # <<------>> Deleting the compilation dependencies <<------>>  
        sudo apt remove -y cargo
        sudo apt remove -y cmake libfreetype6-dev libfontconfig1-dev libxcb-xfixes0-dev libxkbcommon-dev
        sudo apt autoremove -y
        # <<------>>  back to original path <<------>> 
        cd $begin_path
        echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} Alacritty Installed." | tee -a $log_path
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
        sudo make install
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
        NODE_MAJOR=$(curl -s https://deb.nodesource.com/ | grep "NODE_MAJOR=" | sed 's/.*NODE_MAJOR=\([0-9]*\).*/\1/')
        # Validate if NODE_MAJOR is a number
        if [[ $NODE_MAJOR =~ ^[0-9]{2}$ ]]; then
            sudo apt-get update && sudo apt-get install -y ca-certificates curl gnupg
            curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg
            echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_$NODE_MAJOR.x nodistro main" | sudo tee /etc/apt/sources.list.d/nodesource.list
            sudo apt-get update
            sudo apt-get install nodejs -y
        fi
        echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} Node Installed." | tee -a $log_path

    fi
}

function install_docker(){
    if ! command -v docker &> /dev/null; then
        echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} Installing Docker." | tee -a $log_path
        # Install Docker
        # Add Docker's official GPG key:
        sudo apt-get update
        sudo apt-get install ca-certificates curl gnupg
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
        sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

        echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} Docker Installed." | tee -a $log_path
    fi
}

# <<<----------------->>> Setting functions <<<----------------->>>

function setting_zsh_theme(){
    if [ ! -f ~/.zshrc ] && [ ! -f ~/.p10k.zsh ]; then
        echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} Setting zsh theme." | tee -a $log_path
        cp ./theme/.zshrc ~/.zshrc
        cp ./theme/.p10k.zsh ~/.p10k.zsh
        echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} zsh theme Installed." | tee -a $log_path
    fi
}

function setting_plugins_zsh(){
    if ! grep -iq '^# <<<--------->>> Plugins' ~/.zshrc; then
        echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} Setting plugins zsh." | tee -a $log_path
        echo "" >> ~/.zshrc
        echo "# <<<--------->>> Plugins <<<--------->>>" >> ~/.zshrc
        echo "source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >> ~/.zshrc
        echo "source /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh" >> ~/.zshrc
        echo "source /usr/local/share/zsh-sudo/sudo.plugin.zsh" >> ~/.zshrc
        echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} plugins zsh Installed." | tee -a $log_path
    fi 
}

function setting_git_tree_visualizations(){
    # Setting variable to know where to add git tree visualizations
    installed=""
    # Validate if git tree visualizations is not installed in zsh
    if ! grep -iq '^# <<<--------->>> Git tree Visualizations' ~/.zshrc; then
        installed="${installed} ~/.zshrc"
    fi
    # Validate if git tree visualizations is not installed in bash
    if ! grep -iq '^# <<<--------->>> Git tree Visualizations' ~/.bashrc; then
        installed="${installed} ~/.bashrc"
    fi

    echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} Setting git tree visualizations to bash and zsh." | tee -a $log_path
    for file in $installed; do
        echo "" >> "$file"
        echo "# <<<--------->>> Git tree Visualizations <<<--------->>>" >> "$file"
        echo "# ways to visualize the git log more graphically"
        echo "alias lg=\"lg1\"" >> "$file"
        echo "alias lg1=\"lg1-specific --all\"" >> "$file"
        echo "alias lg2=\"lg2-specific --all\"" >> "$file"
        echo "alias lg3=\"lg3-specific --all\"" >> "$file"
        echo "alias lg1-specific=\"git log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(auto)%d%C(reset)'\"" >> "$file"
        echo "alias lg2-specific=\"git log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold cyan)%aD%C(reset) %C(bold green)(%ar)%C(reset)%C(auto)%d%C(reset)%n''%C(white)%s%C(reset) %C(dim white)- %an%C(reset)'\"" >> "$file"
        echo "alias lg3-specific=\"git log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold cyan)%aD%C(reset) %C(bold green)(%ar)%C(reset) %C(bold cyan)(committed: %cD)%C(reset) %C(auto)%d%C(reset)%n''%C(white)%s%C(reset)%n''%C(dim white)- %an <%ae> %C(reset) %C(dim white)(committer: %cn <%ce>)%C(reset)'\"" >> "$file"
    done
    echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} git tree visualizations Installed." | tee -a $log_path
}

function setting_exa(){
    echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} Setting exa." | tee -a $log_path
    # Setting exa
    # to ~/.zshrc
    if ! grep -iq '^# <<<--------->>> exa' ~/.zshrc; then
        echo "" >> ~/.zshrc
        echo "# <<<--------->>> exa <<<--------->>>" >> ~/.zshrc
        echo "alias ll=\"exa -alh\"" >> ~/.zshrc
    fi
    # to ~/.bashrc
    if ! grep -iq '^# <<<--------->>> exa' ~/.bashrc; then
        echo "" >> ~/.bashrc
        echo "# <<<--------->>> exa <<<--------->>>" >> ~/.bashrc
        echo "alias ll=\"exa -alh\"" >> ~/.bashrc
    fi
    echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} exa Installed." | tee -a $log_path
}

function setting_alacritty(){
    echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} Setting alacritty." | tee -a $log_path
    # <<----------->> Setting alacritty <<----------->>
    # Copy format alacritty
    mkdir ~/.config/alacritty
    cp ./theme/alacritty.yml ~/.config/alacritty/alacritty.yml
    cp ./theme/alacritty.toml ~/.config/alacritty/alacritty.toml
    # Setting alacritty like a default terminal
    dconf write /org/cinnamon/desktop/applications/terminal/exec "'alacritty'"
    echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} alacritty Installed." | tee -a $log_path
}

function setting_poetry(){
    echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} Setting poetry." | tee -a $log_path
    # Setting poetry
    # to ~/.zshrc
    if ! grep -iq '^# <<<--------->>> Poetry' ~/.zshrc; then
        echo "" >> ~/.zshrc
        echo "# <<<--------->>> Poetry <<<--------->>>" >> ~/.zshrc
        echo "export PATH=\"\$HOME/.local/bin:\$PATH\"" >> ~/.zshrc
    fi
    # to ~/.bashrc
    if ! grep -iq '^# <<<--------->>> Poetry' ~/.bashrc; then
        echo "" >> ~/.bashrc
        echo "# <<<--------->>> Poetry <<<--------->>>" >> ~/.bashrc
        echo "export PATH=\"\$HOME/.local/bin:\$PATH\"" >> ~/.bashrc
    fi
    echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} poetry Installed." | tee -a $log_path
}

function setting_pyenv(){
    echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} Setting pyenv." | tee -a $log_path
    # Setting pyenv
    installed=""
    # Validate if pyenv is not installed in zsh
    if ! grep -iq '^# <<<--------->>> Pyenv' ~/.zshrc; then
        installed="${installed} ~/.zshrc"
    fi
    # Validate if git tree visualizations is not installed in bash
    if ! grep -iq '^# <<<--------->>> Pyenv' ~/.bashrc; then
        installed="${installed} ~/.bashrc"
    fi

    # Setting pyenv in ~/.zshrc and ~/.bashrc
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
    
    echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} pyenv is set up." | tee -a $log_path
}

# <<<----------------->>> Main <<<----------------->>>
main

# <<<----------------->>> End <<<----------------->>>
echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} Thank you for install developer apps. =D " | tee -a $log_path