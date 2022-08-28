#!/bin/bash
# This shell script is for download on your device (linux mint with cinnamon)


if ! grep "# Se añade el inicializados para usar pyenv en terminal" ./archivo.txt ; then

  echo '' >> archivo.txt
  echo '# Se añade el inicializados para usar pyenv en terminal' >> archivo.txt
  echo '' >> archivo.txt
  echo 'export PATH=$HOME/.pyenv/bin:$PATH' >> archivo.txt
  echo 'eval "$(pyenv init --path)"' >> archivo.txt
  echo 'eval "$(pyenv virtualenv-init -)"' >> archivo.txt
  echo '' >> archivo.txt

fi

echo "fin del programa"
