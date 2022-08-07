#!/bin/bash
# This shell script is for download on your device (linux mint with cinnamon)

sudo echo "Inicio de proceso de personalizacion de linux mint"

# sudo apt install grub2-theme-mint-2k # hace que la interfaz del grub sea más grande

# Actualizando el repositorio del apt

sudo apt update && sudo apt upgrade -y

root=/home/$USER
src=$root/Downloads
if [ ! -d "$src" ]; then
    src=$root/Descargas
fi

cd $src
src_config=$src/config_styles
echo $src
if [ ! -d "$src_config" ]; then
    mkdir config_styles
fi
cd $src_config

touch $src_config/${0##*/}.log
echo "$(date +%Y-%m-%d_%H:%M) : ${0##*/} $1 running." | tee $src_config/${0##*/}.log

# Descargas
# Descarga Mint Galaxy

echo "Downloading: Mint Galaxy animated galaxy for Linux Mint 19.2"
echo "Source: https://www.gnome-look.org/p/1294920"

if [ ! -d "$src_config/mint-galaxy" ]; then
    echo "Mint Galaxy : Se descarga el archivo de mint-galaxy" | tee -a $src_config/${0##*/}.log
    curl -L --output "$src_config/mint-galaxy.zip" https://github.com/Sheldonimo/CustomLinuxMint/raw/master/config_styles/mint-galaxy.zip

    # Esperando hasta que se descarguen todos los archivos
    wait -n

fi

# Descarga iconos

echo "Downloading: Tela-icon-theme green"
echo "Source: https://www.pling.com/p/1279924/"

if [ ! -d "$src_config/Tela-green" ]; then
    echo "Tela-green : Se descarga el paquete iconos" | tee -a $src_config/${0##*/}.log
    curl -L --output "$src_config/Tela-green.tar.xz" https://github.com/Sheldonimo/CustomLinuxMint/raw/master/config_styles/Tela-green.tar.xz

    # Esperando hasta que se descarguen todos los archivos
    wait -n

fi

# Descarga Cursor

echo "Downloading: BreezeX Dark Cursor Black"
echo "Source: https://www.cinnamon-look.org/p/1538515/"

if [ ! -d "$src_config/BreezeX-Dark" ]; then
    echo "Tela-green : Se descarga el paquete iconos" | tee -a $src_config/${0##*/}.log
    curl -L --output "$src_config/BreezeX-Dark.tar.gz" https://github.com/Sheldonimo/CustomLinuxMint/raw/master/config_styles/BreezeX-Dark.tar.gz

    # Esperando hasta que se descarguen todos los archivos
    wait -n
fi

# Descargar el font

if [ ! -d "$src_config/Hack" ]; then

  curl -L --output "$src_config/Hack.zip" https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/Hack.zip
  # Esperando hasta que se descarguen todos los archivos
  wait -n

fi

## backlog: Revisar la descarga se
# Descomprimir

echo "Descomprimiendo archivos"

# Descomprimiendo mint-galaxy

if [ -f "$src_config/mint-galaxy.zip" ]; then

    unzip -qq mint-galaxy.zip
    rm ./mint-galaxy.zip

fi

# Descomprimiendo Cursor
if [ -f "$src_config/BreezeX-Dark.tar.gz" ]; then

    tar -xzf BreezeX-Dark.tar.gz
    rm ./BreezeX-Dark.tar.gz

fi
# Descomprimiendo iconos
if [ -f "$src_config/Tela-green.tar.xz" ]; then

    tar -xJf Tela-green.tar.xz
    rm ./Tela-green.tar.xz

fi

# Descomprimiendo Hack nerd Font

if [ -f "$src_config/Hack.zip" ]; then

    echo "Descomprimiendo Hack nerd Font"

    unzip -qq Hack.zip -d Hack/
    rm ./Hack.zip

fi

## Moviendo imagen de linux mint para el logo del menu

echo "Moviendo la imagen del logo de menú del linux mint"

if [ ! -f "$root/.config-desktop/logo.png" ]; then

  mkdir $root/.config-desktop
  #chmod 777 $root/.config-desktop
  cp ./mint-galaxy/logo.png $root/.config-desktop/linux-mint-galaxy-logo.png

fi
## Moviendo los iconos de Tela a la carpeta de /usr/share/icons

echo "Moviendo los iconos a /usr/share/icons"

[ ! -d "/usr/share/icons/Tela-green" ] &&  sudo mv ./Tela-green /usr/share/icons/
[ ! -d "/usr/share/icons/Tela-green-dark" ] &&  sudo mv ./Tela-green-dark /usr/share/icons/

## Moviendo los iconos del mouse a la carpeta de /usr/share/icons

echo "Moviendo los iconos de mouse a /usr/share/icons"

[ ! -d "/usr/share/icons/BreezeX-Dark" ] && sudo mv ./BreezeX-Dark /usr/share/icons/

## Moviendo el nuevo mono font

echo "Moviendo el Hack Nerd Font a /usr/share/fonts"

[ ! -d "/usr/share/fonts/truetype/Hack" ] && sudo mkdir -p /usr/share/fonts/truetype/Hack
[ ! -f "/usr/share/fonts/truetype/Hack/Hack Regular Nerd Font Complete Mono.ttf" ] && sudo mv "./Hack/Hack Regular Nerd Font Complete Mono.ttf" /usr/share/fonts/truetype/Hack/

## Seleccionando el tipo de iconos 

echo "Seteando los nuevos iconos en el sistema actual"

# configuraciones_manuales https://gist.github.com/FZX/ab53cb635f16be3b9aa26385495c4115
## backlog: Existe un lagg mientras se copian los archivos al destino entonces las configuraciones presentes no se aplican correctamente
gsettings set org.cinnamon.desktop.interface icon-theme 'Tela-green-dark'
gsettings set org.cinnamon.theme name 'Mint-Y-Dark'
gsettings set org.cinnamon.desktop.interface gtk-theme 'Mint-Y-Dark'
gsettings set org.cinnamon.desktop.wm.preferences theme 'Mint-Y'

# configurando el cursor

gsettings set org.cinnamon.desktop.interface cursor-theme 'BreezeX-Dark'

# setting desktop background

release=$(lsb_release -r | awk '{print $2}')

if [ $release = "20.3" ]; then

  gsettings set org.gnome.desktop.background picture-uri 'file:///usr/share/backgrounds/linuxmint-una/aburden_frozen_winter_ball.jpg'

elif [ $release = "21" ]; then

  gsettings set org.gnome.desktop.background picture-uri 'file:///usr/share/backgrounds/linuxmint-vanessa/aburden_frozen.jpg'
else

  echo "No se pudo definir un fondo de pantalla para el sistema"

fi

# Habilitar applets
echo "Se se habilitar los applets y se posicionan en el panel"

gsettings set org.cinnamon enabled-applets "['panel1:center:0:menu@cinnamon.org:0', 'panel1:right:13:show-desktop@cinnamon.org:1', 'panel1:center:1:grouped-window-list@cinnamon.org:2', 'panel1:right:1:systray@cinnamon.org:3', 'panel1:right:2:xapp-status@cinnamon.org:4', 'panel1:right:12:notifications@cinnamon.org:5', 'panel1:right:4:printers@cinnamon.org:6', 'panel1:right:5:removable-drives@cinnamon.org:7', 'panel1:right:6:keyboard@cinnamon.org:8', 'panel1:right:7:favorites@cinnamon.org:9', 'panel1:right:8:network@cinnamon.org:10', 'panel1:right:9:sound@cinnamon.org:11', 'panel1:right:10:power@cinnamon.org:12', 'panel1:right:11:calendar@cinnamon.org:13', 'panel1:left:0:workspace-switcher@cinnamon.org:14']"

# Configuracion del panel

gsettings set org.cinnamon panels-enabled "['1:0:bottom']"
gsettings set org.cinnamon panels-height "['1:46', '2:40']"
gsettings set org.cinnamon panel-zone-icon-sizes '[{"panelId":1,"left":0,"center":0,"right":24}]'
gsettings set org.cinnamon panel-zone-symbolic-icon-sizes '[{"panelId": 1, "left": 32, "center": 32, "right": 16}]'

# Configurar fonts

sudo apt install -y fonts-roboto fonts-roboto-unhinted

gsettings set org.cinnamon.desktop.interface font-name 'Roboto 10'
gsettings set org.nemo.desktop font 'Roboto 10'
gsettings set org.gnome.desktop.interface document-font-name 'Roboto 10'
gsettings set org.cinnamon.desktop.wm.preferences titlebar-font 'Roboto Bold 11'
gsettings set org.gnome.desktop.interface monospace-font-name 'Hack Nerd Font Mono Regular 12'
gsettings set org.x.viewer.plugins.pythonconsole use-system-font false
gsettings set org.x.viewer.plugins.pythonconsole font 'Hack Nerd Font Mono Regular 9'

# Cambiando el Icono del Menu

if [ -f "/home/$USER/.cinnamon/configs/menu@cinnamon.org/0.json" ] ; then
    echo "LOGO : Update hamonikr default logo setting" | tee -a $HOME/.hamonikr/${0##*/}.log
    sed -i 's/"value": "linuxmint-logo-ring-symbolic"/"value": "\/home\/'$USER'\/.config-desktop\/linux-mint-galaxy-logo.png"/g' /home/$USER/.cinnamon/configs/menu@cinnamon.org/0.json
fi

# fuente: https://github.com/hamonikr/hamonikr-system-settings/blob/2aeb797152c9a2ad9120955a1a6ff894dac4f6c7/etc/skel/.hamonikr/default_dconf

echo "Se comienza a configurar los shortcuts"

srcd=$root/Documents
if [ ! -d "$srcd" ]; then
    srcd=$root/Documentos
fi

comando=("'$srcd/Logseq/Logseq-linux-x64.AppImage'" "'gnome-screenshot -ac'" "'gnome-screenshot -c -d 1'" "'rofi -show-icons -show drun'" "'copyq show'")
nombre=("'Logseq'" "'screenshot area'" "'screenshot'" "'rofi'" "'copyq'")
shortcut=("['<Alt>Return']" "['<Alt><Shift>a']" "['<Alt><Shift>s']" "['<Alt>d']" "['<Super>v']")

ruta="/org/cinnamon/desktop/keybindings/custom-keybindings"

# Se define la cantidad shortcuts que serán actualizados

echo "iniciando loop de configuración"

echo "Definiendo los shortcuts con dconf"
dconf write /org/cinnamon/desktop/keybindings/custom-list "['custom0','custom1','custom2','custom3','custom4']"

for i in ${!comando[@]};
do
    dconf write $ruta/custom$i/command "${comando[$i]}"
    dconf write $ruta/custom$i/name "${nombre[$i]}"
    dconf write $ruta/custom$i/binding "${shortcut[$i]}"
done

echo "Definiendo los shortcuts con gsettings"

gsettings set org.cinnamon.desktop.keybindings custom-list "['custom0','custom1','custom2','custom3','custom4']"

for i in ${!comando[@]};
do
    gsettings set org.cinnamon.desktop.keybindings.custom-keybinding:$ruta/custom$i/ binding "${shortcut[$i]}"
    gsettings set org.cinnamon.desktop.keybindings.custom-keybinding:$ruta/custom$i/ command "${comando[$i]}"
    gsettings set org.cinnamon.desktop.keybindings.custom-keybinding:$ruta/custom$i/ name "${nombre[$i]}"
done


## Configurar la paleta de colores y shortcuts de la terminal

# source: https://askubuntu.com/questions/774394/wheres-the-gnome-terminal-config-file-located

cd $src_config

if [ ! -f "$src_config/gterminal.sh" ]; then

  # source: https://github.com/danieldkato/gnome-terminal_themes

  curl -L --output "$src_config/gterminal.sh" https://github.com/Sheldonimo/CustomLinuxMint/raw/master/gterminal.sh

  # Esperando hasta que se descarguen todos los archivos
  wait -n 

  bash $src_config/gterminal.sh

fi

echo "Descargando htop y neofetch"

sudo apt-get install -y neofetch htop

#########################################################


echo "Descargando los complementos de poetry"

sudo apt-get install -y python3-distutils python3-apt git

# instalar poetry

echo "Instalando poetry"


if [ ! -d "$root/.poetry" ]; then

  curl -sSL https://raw.githubusercontent.com/python-poetry/poetry/master/get-poetry.py | python3 -

  # Esperando hasta que se descarguen todos los archivos
  wait -n

fi
# se descarga el paquete de exa
echo "Source: https://the.exa.website/#installation"
echo "Download: exa A modern replacement for ls"

cd $src_config

# verify is exist a file exa before installing

if [ ! -f "/usr/bin/exa" ]; then

  sudo apt install -y exa

fi

# se añade PATH 

echo "Añadiendo poetry a la ruta"

# verifica si ya se ha escrito en bashrc, las variables de entorno y si no se ha escrito se escribe

if ! grep -q "# añade poetry al bash" "$root/.bashrc"; then

  cd $root
  echo '' >> .bashrc
  echo '# añade poetry al bash' >> .bashrc
  echo '' >> .bashrc
  echo 'export PATH=$HOME/.local/bin:$PATH' >> .bashrc
  echo 'export PATH=$HOME/.poetry/bin:$PATH' >> .bashrc

fi

cd $src_config

## Instalación de bat
cd $src_config

echo "Instalando bat"
echo "Fuente: https://github.com/sharkdp/bat/releases"

if ! command -v bat &> /dev/null; then

  curl -L --output "bat_0.21.0_amd64.deb" https://github.com/sharkdp/bat/releases/download/v0.21.0/bat_0.21.0_amd64.deb
  # Esperando hasta que se descarguen todos los archivos
  wait -n 

  sudo dpkg -i bat_0.21.0_amd64.deb

fi


### Instalando pyenv
echo "Instalando: Pyenv"

# dependencias de pyenv
echo "Descargando las dependencias de Pyenv"

sudo apt-get install -y make build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev


# copiar el repositorio del proyecto
echo "Clonando el proyecto de Pyenv"

if [ ! -d "$root/.pyenv" ]; then

  git clone https://github.com/pyenv/pyenv.git $root/.pyenv

  wait -n

fi
# Esperando hasta que se descarguen todos los archivos

if [ ! -d "$root/.pyenv/plugins/pyenv-virtualenv" ]; then

  git clone https://github.com/pyenv/pyenv-virtualenv.git $root/.pyenv/plugins/pyenv-virtualenv

  wait -n

fi
# Se añade el inicializados para usar pyenv en terminal

echo "Añadiendo configuraciones a .bashrc para arrancar con Pyenv"

# verifica si ya se ha escrito en bashrc, las variables de entorno y si no se ha escrito se escribe

if ! grep -q "# Se añade el inicializados para usar pyenv en terminal" "$root/.bashrc"; then

  cd $root
  echo '' >> .bashrc
  echo '# Se añade el inicializados para usar pyenv en terminal' >> .bashrc
  echo '' >> .bashrc
  echo 'export PATH=$HOME/.pyenv/bin:$PATH' >> .bashrc
  echo 'eval "$(pyenv init --path)"' >> .bashrc
  echo 'eval "$(pyenv virtualenv-init -)"' >> .bashrc
  echo '' >> .bashrc

fi

# Instalación de zoom 
echo "Descargando: Zoom"

sudo apt install -y libgl1-mesa-glx libegl1-mesa libxcb-xtest0 ibus

cd $src_config

# Verifica si existe un programa determinado en el sistema antes de instalarlo

if ! command -v zoom &> /dev/null; then

  curl -L --output "zoom_amd64.deb" https://zoom.us/client/latest/zoom_amd64.deb 

  # Esperando hasta que se descarguen todos los archivos
  wait -n 

  echo "Instalando Zoom"

  sudo dpkg -i zoom_amd64.deb

fi

# instalación de brave
echo "Instalando: Brave"

if ! command -v brave-browser &> /dev/null; then

  echo "Instalando las dependencias de brave"
  sudo apt install -y apt-transport-https curl

  echo "Instalando las llaves para descargar el programa mediante apt"
  sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg

  # Esperando hasta que se descarguen todos los archivos
  wait -n

  echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg arch=amd64] https://brave-browser-apt-release.s3.brave.com/ stable main"|sudo tee /etc/apt/sources.list.d/brave-browser-release.list

  sudo apt update

  echo "Instalando brave-browser"

  sudo apt install -y brave-browser

fi

# instalación de anydesk
echo "Descargando: Anydesk"
echo "Source: https://computingforgeeks.com/how-to-install-anydesk-on-ubuntu/"

# wget -qO - https://keys.anydesk.com/repos/DEB-GPG-KEY | sudo apt-key add -

# echo "deb http://deb.anydesk.com/ all main" | sudo tee /etc/apt/sources.list.d/anydesk-stable.list

# sudo apt update
# sudo apt install -y anydesk

sudo apt install -y libgtkglext1 libminizip1 libpangox-1.0-0

cd $src_config

if ! command -v anydesk &> /dev/null; then

  curl -L --output "anydesk_6.1.1-1_amd64.deb" https://download.anydesk.com/linux/anydesk_6.1.1-1_amd64.deb

  # Esperando hasta que se descarguen todos los archivos
  wait -n 

  echo "Instalando anydesk"

  sudo dpkg -i anydesk_6.1.1-1_amd64.deb

fi

echo "Instalando Anydesk"

## instalación de programas complementarios

# instalacion de logseq
echo "Descargando: Logseq"



if [ ! -f "$srcd/Logseq/Logseq-linux-x64.AppImage" ]; then

  curl -L --output "Logseq-linux-x64-0.7.9.AppImage" https://github.com/logseq/logseq/releases/download/0.7.9/Logseq-linux-x64-0.7.9.AppImage

  # Esperando hasta que se descarguen todos los archivos
  wait -n

  echo "Modificando los permisos de ejecución de Logseq"

  sudo chmod a+x Logseq-linux-x64-0.7.9.AppImage

  echo "Creando la carpeta de notas para Logseq"

  mkdir -p $srcd/Logseq/Notebook

  echo "Moviendo el archivo de ejecución de logseq a la ruta definida"

  mv Logseq-linux-x64-0.7.9.AppImage $srcd/Logseq/Logseq-linux-x64.AppImage

fi

## Se instalan los complementos muy utiles

echo "Instalando ytfzf (youtube desde linea de comandos)"
echo "Source: https://github.com/lilberick/Tips-Gnu-Linux/tree/master/ytfzf"
echo "descargando complementos"

sudo apt install -y jq mpv youtube-dl fzf
pip3 install ueberzug

if ! command -v ytfzf &> /dev/null; then

  curl -sL "https://raw.githubusercontent.com/pystardust/ytfzf/master/ytfzf" | sudo tee /usr/bin/ytfzf >/dev/null && sudo chmod 755 /usr/bin/ytfzf

  # Esperando hasta que se descarguen todos los archivos
  wait -n
  mkdir $root/.config/ytfzf
  touch $root/.config/ytfzf/conf.sh

  # escribiendo las configuraciones en ytfzf
  echo 'YTFZF_HIST=0					# habilitar history' >> $root/.config/ytfzf/conf.sh
  echo "YTFZF_EXTMENU='rofi -dmenu -fuzzy -width 1500'	# external menu" >> $root/.config/ytfzf/conf.sh
  echo 'YTFZF_EXTMENU_LEN=220				# ajustar el ancho de menu' >> $root/.config/ytfzf/conf.sh
  echo 'YTFZF_PREF="22"					# resolution a 720p' >> $root/.config/ytfzf/conf.sh
  
fi

echo "Descargando los parquetes copyq y flameshot"

if ! command -v copyq &> /dev/null; then

  sudo add-apt-repository ppa:hluk/copyq
  sudo apt-get update

fi

# sudo apt install imagemagick (deprecado?)

  sudo apt-get install -y copyq flameshot rofi

# Actualizando la versión de libreoffice a la ultima

echo "Actualizando el libreoffice"

sudo add-apt-repository ppa:libreoffice/ppa

sudo apt-get update

sudo apt-get -y upgrade

## Finalización del proceso automatico

echo "Enlaces de los procesos pendientes"
echo "VSCODE"
echo "https://code.visualstudio.com/"

# echo curl -L --output "vscode.deb" https://az764295.vo.msecnd.net/stable/dfd34e8260c270da74b5c2d86d61aee4b6d56977/code_1.66.2-1649664567_amd64.deb

