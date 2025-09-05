#!/bin/bash
source ./common_functions.sh  # Ensure this path is correct

init() {
    echo "                                                                                    ";
    echo " █████╗ ██╗     ██╗ █████╗ ███████╗    ██╗    ██╗██╗███████╗ █████╗ ██████╗ ██████╗ ";
    echo "██╔══██╗██║     ██║██╔══██╗██╔════╝    ██║    ██║██║╚══███╔╝██╔══██╗██╔══██╗██╔══██╗";
    echo "███████║██║     ██║███████║███████╗    ██║ █╗ ██║██║  ███╔╝ ███████║██████╔╝██║  ██║";
    echo "██╔══██║██║     ██║██╔══██║╚════██║    ██║███╗██║██║ ███╔╝  ██╔══██║██╔══██╗██║  ██║";
    echo "██║  ██║███████╗██║██║  ██║███████║    ╚███╔███╔╝██║███████╗██║  ██║██║  ██║██████╔╝";
    echo "╚═╝  ╚═╝╚══════╝╚═╝╚═╝  ╚═╝╚══════╝     ╚══╝╚══╝ ╚═╝╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝╚═════╝ ";
    echo "                                                                                    ";
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
    
    # Add each alias to ~/.bashrc if it does not already exist
    for alias_line in "${aliases[@]}"; do
        if [[ -n "$alias_line" ]] && ! grep -qF "$alias_line" ~/.bashrc; then
            echo "$alias_line" >> ~/.bashrc
        fi
    done
    
    print_success "Aliases configured successfully!"
    return 0
}

# Main function to organize the script flow
main() {
    setup_bash_aliases
    return 0
}

# Call the main function if the script is executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main
fi