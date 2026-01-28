#!/usr/bin/env bash

# Ensure this path is correct
source ./common.sh

root_test(){
    if [ "$EUID" -ne 0 ]; then 
        printf '%s\n' "If you're NOT sudo/root user, you couldn't run this script properly."
        printf '%s\n' "Run usermod -aG sudo $ USER to add your user to sudoers group."
        dots "Rerunning script with sudo privileges"
        sudo "$0" "$@"
        exit $?
    fi
}

welcome() {
    printf "${BLUE}                                                                                              ${RESET}\n";
    printf "${BLUE}██████╗ ███████╗██████╗ ██╗ █████╗ ███╗   ██╗    ██╗    ██╗██╗███████╗ █████╗ ██████╗ ██████╗ ${RESET}\n";
    printf "${BLUE}██╔══██╗██╔════╝██╔══██╗██║██╔══██╗████╗  ██║    ██║    ██║██║╚══███╔╝██╔══██╗██╔══██╗██╔══██╗${RESET}\n";
    printf "${BLUE}██║  ██║█████╗  ██████╔╝██║███████║██╔██╗ ██║    ██║ █╗ ██║██║  ███╔╝ ███████║██████╔╝██║  ██║${RESET}\n";
    printf "${BLUE}██║  ██║██╔══╝  ██╔══██╗██║██╔══██║██║╚██╗██║    ██║███╗██║██║ ███╔╝  ██╔══██║██╔══██╗██║  ██║${RESET}\n";
    printf "${BLUE}██████╔╝███████╗██████╔╝██║██║  ██║██║ ╚████║    ╚███╔███╔╝██║███████╗██║  ██║██║  ██║██████╔╝${RESET}\n";
    printf "${BLUE}╚═════╝ ╚══════╝╚═════╝ ╚═╝╚═╝  ╚═╝╚═╝  ╚═══╝     ╚══╝╚══╝ ╚═╝╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝╚═════╝ ${RESET}\n";
    printf "${BLUE}                                                                                              ${RESET}\n";

    printf '%s\n' "This script will perform basic fixes and configurations that must be executed strictly in the terminal"
    print_warning "These configurations are recommended for Debian 13"

    sleep 5

    return 0
}

set_timezone(){
    dots "Setting timezone to America/Mexico_City"
    sudo timedatectl set-timezone America/Mexico_City
    sudo timedatectl set-local-rtc 0 --adjust-system-clock
    sudo timedatectl set-ntp true
    print_success "Timezone set to America/Mexico_City"
    printf "Your current time is: %s\n" "$(timedatectl | grep 'Local time' | xargs)"

    return 0
}

removing_libreoffice(){
    dots "Removing apt LibreOffice version (Is outdated most of the times)"

    sudo apt purge --autoremove 'libreoffice*'
    sudo apt purge --autoremove 'libreoffice*' 'uno*' 'ure*'
    sudo apt remove libreoffice-common libreoffice-core libreoffice-gnome libreoffice-gtk3 libreoffice-help-common libreoffice-help-en-us libreoffice-style-colibre libreoffice-style-elementary
    sudo apt autoremove --purge
    sudo apt clean
    dpkg -l | awk '/^rc/ && $2 ~ /libreoffice|uno|ure/ {print $2}' | xargs -r sudo dpkg -P

    dots "Removing old LibreOffice user configuration files"
    rm -rf ~/.config/libreoffice ~/.cache/libreoffice ~/.local/share/libreoffice

    print_success "Old LibreOffice removed from the system"
    print_warning "If you need LibreOffice, consider installing from Flathub repository for a more updated version"

    return 0
}

setting_vim(){
    dots "Setting numbers to vim display"
    printf '%s\n' "set nu" > ~/.vimrc
    print_success "Vim configured to show line numbers"

    return 0
}

activate_bluetooth(){
    dots "Installing Realtek firmware and Blueman for Bluetooth support"
    sudo apt install firmware-realtek && sudo apt install blueman
    print_success "Bluetooth support activated"

    return 0
}

main() {
    root_test
    welcome
    set_timezone
    removing_libreoffice
    setting_vim
    activate_bluetooth
    print_success "Configuration completed!"
    printf '%s\n' "Debian basic configuration by softwareWizard.sh"
    
    return 0
}

# Run main
main