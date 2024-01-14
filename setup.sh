#!/usr/bin/env bash
# by: Sheldonimo

# global variable
export log_path=$PWD/installation_log_$(date +%Y-%m-%d_%H-%M-%S).log

function main() {
    #download scripts and create folder
    begin

    #print banner
    banner

    #read inputs
    read_input
    # $? is limited between 0 and 255, so we can use it to return the user's choice
    let answer=$?

    case "$answer" in

    1)  
        # Require sudo access
        sudo -v
        #echo "run Install All Customizations..."
        echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} Installation All Customizations." | tee -a $log_path
        ask_to_run_script "desktop_customization.sh" "false"
        install_pip_and_git
        ask_to_run_script "install_general_purpose_apps.sh" "false"
        ask_to_run_script "install_developer_apps.sh" "false"
        ;;
    2)  
        # Require sudo access
        sudo -v
        #echo "run Install Desktop Customization..."
        echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} Installation Desktop Customization." | tee -a $log_path
        ask_to_run_script "desktop_customization.sh" "false"
        install_pip_and_git
        ;;
    3)  
        # Require sudo access
        sudo -v
        #echo "run Install Developer Apps..."
        echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} Installation Developer Apps." | tee -a $log_path
        install_pip_and_git
        ask_to_run_script "install_developer_apps.sh" "false"
        ;;
    4)  
        # Require sudo access
        sudo -v
        #echo "run Install General Purpose Apps..."
        echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} Installation General Purpose Apps." | tee -a $log_path
        install_pip_and_git
        ask_to_run_script "install_general_purpose_apps.sh" "false"
        ;;
    5)  
        # Require sudo access
        sudo -v
        #echo "Multi-Selection setup..."
        echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} Installation Custom Selection setup." | tee -a $log_path
        install_pip_and_git
        ask_to_run_script "desktop_customization.sh" "true"
        ask_to_run_script "install_developer_apps.sh" "true"
        ask_to_run_script "install_general_purpose_apps.sh" "true"
        ;;
    6)  
        #echo "exit setup..."
        echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} Exit setup." | tee -a $log_path
        exitScript
        ;;
    esac
}

begin() {
    touch $log_path
    echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} running." | tee -a $log_path
}

# Function to execute the script
# Arguments: 1=script_name
run_script() {
    local script_name=$1
    local root=./scripts
    local script_path="$root/$script_name"
    wait_second 2
    if [ -f "$script_path" ]; then
        echo "$script_path Found..."
        chmod +x "$script_path"
    else
        error "$script_name not Found..."    
    fi
    # Validate if $script_path is equal to desktop_customization.sh
    if [ "$script_name" == "desktop_customization.sh" ]; then
        # Function to execute the script
        iconColorBanner
        #read inputs
        read_input_color
        let choose=$?
        iconColor=$(change_iconColor $choose)
        # run script
        bash "$script_path" "$iconColor"
    else       
        bash "$script_path"
    fi
    unset script_path
}

function iconColorBanner() {
    local iconColorBanner_path="$PWD/images/iconColorBanner"
    if [ -f $iconColorBanner_path ];then 
        clear && echo ""
        cat $iconColorBanner_path
        echo ""
    else
        error "iconColorBanner not Found..."
    fi
    unset iconColorBanner_path
}

function read_input_color() {
    while true ;do
        read -p "[choose an option]$ " choose
        choose=${choose:-0} # default value is 0
        if [[ "$choose" =~ ^([0-9]|1[0-4])$ ]];then
            break
        fi
        warning "choose a number between 0 to 14"
    done

    return $choose
}

function change_iconColor(){    
    local iconColor=""
    case $1 in
        0) iconColor="green" ;;
        1) iconColor="yellow" ;;
        2) iconColor="blue" ;;
        3) iconColor="red" ;;
        4) iconColor="purple" ;;
        5) iconColor="grey" ;;
        6) iconColor="dracula" ;;
        7) iconColor="black" ;;
        8) iconColor="brown" ;;
        9) iconColor="orange" ;;
        10) iconColor="pink" ;;
        11) iconColor="standard" ;;
        12) iconColor="manjaro" ;;
        13) iconColor="ubuntu" ;;
        14) iconColor="nord" ;;
        *) iconColor="unknown" ;;  # this should never happen
    esac
    echo $iconColor
    unset iconColor
}

function wait_second() {
    for (( i=0 ; i<$1 ; i++ ));do
        echo -n "."
        sleep 1
    done
    echo ""
}

function read_input() {
    while true ;do
        read -p "[choose an option]$ " choose
        if [[ "$choose" =~ (^[1-6]$) ]];then
            break
        fi
        warning "choose a number between 1 to 6"
    done

    return $choose
}

function exitScript() {
    echo "Good Bye :)"
}

function banner() {
    # print banner
    # How can I make a banner?
    # cat iconColorBanner.txt | lolcat -p 3 -F 0.12 -S 0 --force > iconColorBanner
    local banner_path="$PWD/images/banner"
    if [ -f $banner_path ];then 
        clear && echo ""
        cat $banner_path
        echo ""
    else
        error "banner not Found..."
    fi
    unset banner_path
}

# Function to prompt the user and execute a script
# Arguments: 1=script_name(script.sh), 2=ask_confirmation(true/false)
function ask_to_run_script() {
    local script_name=$1
    local ask_confirmation=$2

    if [[ $ask_confirmation == "true" ]]; then
        read -p "Do you want to execute the script $script_name? (Y/n): " choice
        # Default to 'yes' if the input is empty, 'y', or 'Y'
        if [[ -z $choice || $choice == "y" || $choice == "Y" ]]; then
            run_script "$script_name"
        else
            echo "Skipping $script_name."
        fi
    else
        run_script "$script_name"
    fi
}

function install_pip_and_git() {
    # Check if Python3 pip and Git are installed
    pip_installed=$(command -v pip3 &> /dev/null && echo "yes" || echo "no")
    git_installed=$(command -v git &> /dev/null && echo "yes" || echo "no")

    if [ "$pip_installed" = "yes" ] && [ "$git_installed" = "yes" ]; then
        echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} pip3 and git are already installed." | tee -a $log_path
        echo "Both pip3 and Git are already installed."
    elif [ "$pip_installed" = "yes" ] && [ "$git_installed" = "no" ]; then
        echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} Installing git." | tee -a $log_path
        sudo apt-get update
        sudo apt-get install -y git
    elif [ "$pip_installed" = "no" ] && [ "$git_installed" = "yes" ]; then
        echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} Installing pip3." | tee -a $log_path
        sudo apt-get update
        sudo apt-get install -y python3-pip
    else
        echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} Installing pip3 and git." | tee -a $log_path
        sudo apt-get update
        sudo apt-get install -y python3-pip git
    fi

    # check if exit the folder tmp and create it if not exist.
    if [ ! -d "./tmp" ]; then
        mkdir ./tmp
        echo "$(date +%Y-%m-%d_%H:%M:%S) : ${0##*/} tmp folder created." | tee -a $log_path
    fi
}

function error() {
    echo -e "\033[1;31merror:\e[0m $@"
    exit 1
}

function warning() {
    echo -e "\033[1;33mWarning:\e[0m $@"
}

main