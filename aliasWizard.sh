#!/bin/bash

source ./common_functions.sh  # Ensure this path is correct

welcome() {
    echo "                                                                                    ";
    echo " █████╗ ██╗     ██╗ █████╗ ███████╗    ██╗    ██╗██╗███████╗ █████╗ ██████╗ ██████╗ ";
    echo "██╔══██╗██║     ██║██╔══██╗██╔════╝    ██║    ██║██║╚══███╔╝██╔══██╗██╔══██╗██╔══██╗";
    echo "███████║██║     ██║███████║███████╗    ██║ █╗ ██║██║  ███╔╝ ███████║██████╔╝██║  ██║";
    echo "██╔══██║██║     ██║██╔══██║╚════██║    ██║███╗██║██║ ███╔╝  ██╔══██║██╔══██╗██║  ██║";
    echo "██║  ██║███████╗██║██║  ██║███████║    ╚███╔███╔╝██║███████╗██║  ██║██║  ██║██████╔╝";
    echo "╚═╝  ╚═╝╚══════╝╚═╝╚═╝  ╚═╝╚══════╝     ╚══╝╚══╝ ╚═╝╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝╚═════╝ ";
    echo "                                                                                    ";
    sleep 5
}

# Function to detect the shell and define the configuration file
detect_alias_file() {
    echo "Current shell: $SHELL"
    echo "Searching for .bash_aliases file..."
    sleep 2
    
    ALIAS_FILE="$HOME/.bash_aliases"

    if [ -f "$ALIAS_FILE" ]; then
        print_success "$ALIAS_FILE exists"
    else
        print_error "$ALIAS_FILE not found. Creating the file..."
        touch "$ALIAS_FILE"
        print_success "File $ALIAS_FILE created."
    fi

    sleep 2
    return 0
}

setup_aliases() {
    echo "Applying alias to .bash_aliases file..."
    echo "You can see the list of all aliases documented in the README file"
    
    # List of aliases to add
    aliases=(
        "# Navigation"
        "alias sls='ls -lavh'"
        "alias ll='ls -la'"
        "alias la='ls -A'"
        "alias l='ls -CF'"
        "alias ..='cd ..'"
        "alias ...='cd ../..'"
        "alias ....='cd ../../..'"
        "alias ch='cd ~'"
        "# APT shortcuts"
        "alias upg='sudo apt update && sudo apt upgrade -y'"
        "alias aptin='sudo apt install'"
        "alias aptrm='sudo apt remove'"
        "alias autorm='sudo apt autoremove'"
        "alias aptacl='sudo apt autoclean'"
        "alias aptcl='sudo apt clean'"
        "# System shortcuts"
        "alias cls='clear'"
        "alias python='python3'"
        "alias ff='fastfetch'"
        "alias shutdown='systemctl poweroff'"
        "alias reboot='systemctl reboot'"
        "alias srm='sudo rm -rf'"
        "alias rm='rm -iv --preserve-root'"
        "alias cp='cp -iv'"
        "alias mv='mv -iv'"
        "alias ln='ln -iv'"
        "alias srczsh='source ~/.zshrc'"
        "alias srcbash='source ~/.bashrc'"
        "alias c='code .'"
        "# Docker shortcuts"
        "alias dc='docker'"
        "alias dcu='docker compose up -d'"
        "alias dci='docker images'"
        "alias dcps='docker ps'"
        "alias dcrm='docker rm'"
        "alias dcrmi='docker rmi'"
        "# Kubernetes shortcuts"
        "alias kc='kubectl'"
        "alias mc='minikube'"
        "alias kcgp='kubectl get pods'"
        "alias kcgpw='kubectl get pods -o wide'"
        "# Git shortcuts"
        "alias gs='git status'"
        "alias ga='git add'"
        "alias gc='git commit -m'"
        "alias gp='git push'"
        "alias gpl='git pull'"
        "alias gsw='git switch'"
        "alias glg='git log'"
        "alias gb='git branch'"
        "alias gbd='git branch -d'"
        "alias gba='git branch -a'"
        "alias gmg='git merge'"
        "alias gco='git checkout'"
        "alias gcl='git clone'"
        "alias gdf='git diff'"
        "alias gst='git stash'"
        "alias grs='git reset --soft'"
        "alias grh='git reset --hard'"
        "alias gitrepair='sudo chown -R \"$(whoami)\":\"$(id -gn)\" .git'"
        "# Miscellaneous"
        "alias h='history'"
        "alias rootrc='code .bashrc --no-sandbox --user-data-dir'"
    )
    
    # Add each alias to the detected config file if it does not already exist
    for alias_line in "${aliases[@]}"; do
        if [[ -n "$alias_line" ]] && ! grep -qF "$alias_line" "$ALIAS_FILE"; then
            echo "$alias_line" >> "$ALIAS_FILE"
        fi
    done

    return 0
}

finish_setup() {
    print_success "Aliases configured successfully!"
    echo "Reloading $ALIAS_FILE to activate aliases..."
    source "$ALIAS_FILE"  # Reload the detected config file to activate aliases immediately
    print_success "Aliases activated successfully!"
    echo "Setup complete! Please restart your terminal"
    return 0
}

# Main function to organize the script flow
main() {
    welcome
    detect_alias_file
    setup_aliases
    finish_setup
    return 0
}

# Call the main function if the script is executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main
fi