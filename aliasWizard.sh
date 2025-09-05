#!/bin/bash
source ./common_functions.sh  # Ensure this path is correct

setup_bash_aliases() {
    echo "Setting up bash aliases..."
    echo "You can see the list of all aliases documented in the README file"
    
    # Lista de aliases a añadir
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
        "# System"
        "alias upg='sudo apt update && sudo apt upgrade -y'"
        "alias aptin='sudo apt install'"
        "alias aptrm='sudo apt remove'"
        "alias autorm='sudo apt autoremove'"
        "alias cls='clear'"
        "alias python='python3'"
        "alias shutdown='systemctl poweroff'"
        "alias reboot='systemctl reboot'"
        ""
        "# Git shortcuts"
        "alias gs='git status'"
        "alias ga='git add'"
        "alias gc='git commit -m'"
        "alias gp='git push'"
        "alias gpl='git pull'"
        "alias gsw='git switch'"
        "alias glg='git log'"
    )
    
    # Añadir cada alias a ~/.bashrc si no existe
    for alias_line in "${aliases[@]}"; do
        if [[ -n "$alias_line" ]] && ! grep -qF "$alias_line" ~/.bashrc; then
            echo "$alias_line" >> ~/.bashrc
        fi
    done
    
    print_success "Aliases configured successfully!"
    return 0
}

# Función main para organizar el flujo del script
main() {
    setup_bash_aliases
    return 0
}

# Llamar a la función main si el script se ejecuta directamente
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main
fi