# Customization Linux mint

Este es un script que personaliza el escritorio de linux mint cinnamon edition.
y tambien descarga algunos archivos de manera automática como:

It's a bash script that customize the desktop in cinnamon of linux mint.
also download some apps like:

* Brave
* bat
* exa
* ytfzf
* pyenv
* poetry
* flamshot
* copyq
* obsstudio

## Update theme linux

To launch the customization it is only necessary to download the config_styles.sh file and execute the following command:

    curl https://raw.githubusercontent.com/Sheldonimo/CustomLinuxMint/master/config_styles.sh -o - | bash


#### Powerlevel10k configuration

The "Hack Nerd Font Regular 10" is enabled in your terminal.
Here are my choices and remarks for `p10k configure`:

- The rotated square should look like a diamond.
- The lock should look like a lock.
- The upwards arrow shouldn't look properly.
- The upwards arrow should look properly like an upwards arrow.
- The downwards arrow is pointing at 1.
- If icons don't overlap, choose "yes", otherwise choose "no".
- Choose "Classic" as prompt style;
- Choose "unicode" as character set;
- Choose "Light" as Prompt Color; 
- Choose "No" to not display current time;
- Choose "Angle" separator as prompt separator;
- Choose "blurred" as prompt head style;
- Choose "Round" as prompt tail;
- Choose "two lines" as prompt height;
- Choose "disconnected" as prompt connection;
- Choose "No frame" as prompt frame;
- Choose "Compact" as prompt Spacing;
- Choose "many icons" as icons display style;
- Choose "concise" as prompt flow;
- Enable transient prompt. Choose "Yes";
- Choose "Quiet" as instant prompt mode;
- Finally apply changes to ~/.zshrc. Choose "Yes";

Note : the configuration can be even more customized while using `POWERLEVEL9K_` variables in your `.zshrc` file. Thoses are fully compatible with Powerlevel10k.

# Sources
- https://gitlab.com/sakura-lain/my-zsh-config