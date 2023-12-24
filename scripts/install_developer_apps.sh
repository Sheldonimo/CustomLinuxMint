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

    # # <<--->> Unpackage all files <<--->>

    # # Unpackage fonts
    # Unpackage_font

    # # Unpackage Cursor
    # Unpackage_cursor

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
    git clone git@github.com:zsh-users/zsh-syntax-highlighting.git ./tmp/zsh-syntax-highlighting

    # Crear directorio y descargar zsh-autosuggestions
    sudo mkdir /usr/local/share/zsh-autosuggestions/
    sudo wget -O /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh https://raw.githubusercontent.com/zsh-users/zsh-autosuggestions/master/zsh-autosuggestions.zsh

    # Crear directorio y descargar sudo plugin de Oh My Zsh
    sudo mkdir /usr/share/zsh-sudo/
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

# <<<----------------->>> Unpackage functions <<<----------------->>>


# <<<----------------->>> Installation functions <<<----------------->>>

function install_zsh(){
    echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} Installing zsh." | tee -a $log_path
    # Install green icons
    sudo apt install -y zsh
    echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} zsh Installed." | tee -a $log_path
}

function install_plugins_zsh(){
    echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} Installing plugins zsh." | tee -a $log_path
    begin_path=$(pwd)
    # Install plugins zsh
    # Install zsh-syntax-highlighting
    cd ./tmp/zsh-syntax-highlighting
    sudo make install
    # back to original path
    cd $begin_path
    echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} plugins zsh Installed." | tee -a $log_path

}

function install_neofetch_and_htop(){
    echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} Installing neofetch and htop." | tee -a $log_path
    # Install neofetch and htop
    sudo apt install -y neofetch htop
    echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} neofetch and htop Installed." | tee -a $log_path
}

function install_exa(){
    echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} Installing exa." | tee -a $log_path
    # Install exa
    # "Source: https://the.exa.website/#installation"
    # "Download: exa A modern replacement for ls"
    sudo apt install -y exa
    echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} exa Installed." | tee -a $log_path
}

function install_bat(){
    echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} Installing bat." | tee -a $log_path
    # Install bat
    sudo dpkg -i ./tmp/bat_amd64.deb
    echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} bat Installed." | tee -a $log_path
}

function install_alacritty(){
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
}



# <<<----------------->>> Setting functions <<<----------------->>>

function setting_zsh_theme(){
    echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} Setting zsh theme." | tee -a $log_path
    cp ./theme/.zshrc ~/.zshrc
    cp ./theme/.p10k.zsh ~/.p10k.zsh
    echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} zsh theme Installed." | tee -a $log_path
}

function setting_plugins_zsh(){
    echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} Setting plugins zsh." | tee -a $log_path
    echo "" >> ~/.zshrc
    echo "# <<<--------->>> Plugins <<<--------->>>" >> ~/.zshrc
    echo "source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >> ~/.zshrc
    echo "source /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh" >> ~/.zshrc
    echo "source /usr/local/share/zsh-sudo/sudo.plugin.zsh" >> ~/.zshrc
    echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} plugins zsh Installed." | tee -a $log_path
}

function setting_git_tree_visualizations(){
    echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} Setting git tree visualizations to bash and zsh." | tee -a $log_path
    for file in ~/.zshrc ~/.bashrc; do
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
    echo "" >> ~/.zshrc
    echo "alias ll=\"exa -alh\"" >> ~/.zshrc
    echo "" >> ~/.bashrc
    echo "alias ll=\"exa -alh\"" >> ~/.bashrc
    echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} exa Installed." | tee -a $log_path
}

function setting_zsh_theme(){
    echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} Setting zsh theme." | tee -a $log_path
    cp ./theme/.zshrc ~/.zshrc
    cp ./theme/.p10k.zsh ~/.p10k.zsh
    echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} zsh theme Installed." | tee -a $log_path
}

function setting_plugins_zsh(){
    echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} Setting plugins zsh." | tee -a $log_path
    echo "" >> ~/.zshrc
    echo "# <<<--------->>> Plugins <<<--------->>>" >> ~/.zshrc
    echo "source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >> ~/.zshrc
    echo "source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh" >> ~/.zshrc
    echo "source /usr/share/zsh-sudo/sudo.plugin.zsh" >> ~/.zshrc
    echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} plugins zsh Installed." | tee -a $log_path
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

# <<<----------------->>> Main <<<----------------->>>
main

# <<<----------------->>> End <<<----------------->>>
echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} Thank you for install developer apps. =D " | tee -a $log_path