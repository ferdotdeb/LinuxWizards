#!/bin/bash

source ./common_functions.sh # Ensure this path is correct

root_test(){
    if [ "${EUID:-$(id -u)}" -eq 0 ] || id -nG "$USER" | grep -Eqw '(sudo|wheel)'; then
        return 0
    else
        echo "You're NOT sudo/root user, run su, then run usermod -aG sudo 'username'"; exit 1
    fi
}

welcome() {
    printf '%s\n' "                                                                                              ";
    printf '%s\n' "██████╗ ███████╗██████╗ ██╗ █████╗ ███╗   ██╗    ██╗    ██╗██╗███████╗ █████╗ ██████╗ ██████╗ ";
    printf '%s\n' "██╔══██╗██╔════╝██╔══██╗██║██╔══██╗████╗  ██║    ██║    ██║██║╚══███╔╝██╔══██╗██╔══██╗██╔══██╗";
    printf '%s\n' "██║  ██║█████╗  ██████╔╝██║███████║██╔██╗ ██║    ██║ █╗ ██║██║  ███╔╝ ███████║██████╔╝██║  ██║";
    printf '%s\n' "██║  ██║██╔══╝  ██╔══██╗██║██╔══██║██║╚██╗██║    ██║███╗██║██║ ███╔╝  ██╔══██║██╔══██╗██║  ██║";
    printf '%s\n' "██████╔╝███████╗██████╔╝██║██║  ██║██║ ╚████║    ╚███╔███╔╝██║███████╗██║  ██║██║  ██║██████╔╝";
    printf '%s\n' "╚═════╝ ╚══════╝╚═════╝ ╚═╝╚═╝  ╚═╝╚═╝  ╚═══╝     ╚══╝╚══╝ ╚═╝╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝╚═════╝ ";
    printf '%s\n' "                                                                                              ";

    printf '%s\n' "This script will perform basic fixes and configurations that must be executed strictly in the terminal."
    print_warning "These configurations are recommended for Debian 13."

    sleep 5
}

set_timezone(){
    dots "Setting timezone to America/Mexico_City"
    sudo timedatectl set-timezone America/Mexico_City
    sudo timedatectl set-local-rtc 0 --adjust-system-clock
    sudo timedatectl set-ntp true
    print_success "Timezone set to America/Mexico_City"
    printf "Your current time is: %s\n" "$(timedatectl | grep 'Local time' | xargs)"
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

    print_warning "If you need LibreOffice, consider installing from Flathub repository for a more updated version."
}

setting_vim(){
    dots "Setting numbers to vim display"
    echo "set nu" > ~/.vimrc
}

activate_bluetooth(){
    dots "Installing Realtek firmware and Blueman for Bluetooth support"
    sudo apt install firmware-realtek && sudo apt install blueman
}

main() {
    root_test
    welcome
    set_timezone
    removing_libreoffice
    setting_vim
    activate_bluetooth
}

# Run main
main