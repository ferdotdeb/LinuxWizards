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
detect_shell() {
    echo "Detecting shell..."
    sleep 2
    echo "Current shell: $SHELL"
    sleep 2

    if [[ "$SHELL" == */bash ]]; then
        config_file="$HOME/.bashrc"
    elif [[ "$SHELL" == */zsh ]]; then
        config_file="$HOME/.zshrc"
    else
        print_error "Unsupported shell. Only Bash or Zsh is supported."
        return 1
    fi

    echo "Detected shell configuration file: $config_file"
    sleep 2

    return 0
}

setup_aliases() {
    echo "Setting up aliases..."
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
        "# Docker shortcuts"
        "alias dc='docker'"
        "alias dcu='docker-compose up -d'"
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
        "# Miscellaneous"
        "alias h='history'"
    )
    
    # Add each alias to the detected config file if it does not already exist
    for alias_line in "${aliases[@]}"; do
        if [[ -n "$alias_line" ]] && ! grep -qF "$alias_line" "$config_file"; then
            echo "$alias_line" >> "$config_file"
        fi
    done
    
    print_success "Aliases configured successfully!"
    echo "Reloading $config_file to activate aliases..."
    source "$config_file"  # Reload the detected config file to activate aliases immediately
    print_success "Aliases activated successfully!"
    return 0
}

# Main function to organize the script flow
main() {
    welcome
    detect_shell || return 1
    setup_aliases
    return 0
}

# Call the main function if the script is executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main
fi