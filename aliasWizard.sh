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

setup_bash_aliases() {
    echo "Setting up bash aliases..."
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
        ""
        "# APT shortcuts"
        "alias upg='sudo apt update && sudo apt upgrade -y'"
        "alias aptin='sudo apt install'"
        "alias aptrm='sudo apt remove'"
        "alias autorm='sudo apt autoremove'"
        "alias aptacl='sudo apt autoclean'"
        "alias aptcl='sudo apt clean'"
        ""
        "# System shortcuts"
        "alias cls='clear'"
        "alias python='python3'"
        "alias shutdown='systemctl poweroff'"
        "alias reboot='systemctl reboot'"
        ""
        "# Docker shortcuts"
        "alias dc='docker'"
        "alias dcu='docker-compose up -d'"
        "alias dci='docker images'"
        "alias dcps='docker ps'"
        ""
        "# Kubernetes shortcuts"
        "alias kc='kubectl'"
        "alias mc='minikube'"
        "alias kcg='kubectl get pods'"
        ""
        "# Git shortcuts"
        "alias gs='git status'"
        "alias ga='git add'"
        "alias gc='git commit -m'"
        "alias gp='git push'"
        "alias gpl='git pull'"
        "alias gsw='git switch'"
        "alias glg='git log'"
        "alias gb='git branch'"
        "alias gmg='git merge'"
    )
    
    # Add each alias to ~/.bashrc if it does not already exist
    for alias_line in "${aliases[@]}"; do
        if [[ -n "$alias_line" ]] && ! grep -qF "$alias_line" ~/.bashrc; then
            echo "$alias_line" >> ~/.bashrc
        fi
    done
    
    print_success "Aliases configured successfully!"
    echo "Reloading .bashrc file to activate aliases..."
    source ~/.bashrc  # Reload ~/.bashrc to activate aliases immediately
    print_success "Aliases activated successfully!"
    return 0
}

# Main function to organize the script flow
main() {
    welcome
    setup_bash_aliases
    return 0
}

# Call the main function if the script is executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main
fi