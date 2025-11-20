#!/bin/sh

# Source common functions
. ./common_functions.sh

welcome() {
    printf '%s\n' "                                                                                    "
    printf '%s\n' " █████╗ ██╗     ██╗ █████╗ ███████╗    ██╗    ██╗██╗███████╗ █████╗ ██████╗ ██████╗ "
    printf '%s\n' "██╔══██╗██║     ██║██╔══██╗██╔════╝    ██║    ██║██║╚══███╔╝██╔══██╗██╔══██╗██╔══██╗"
    printf '%s\n' "███████║██║     ██║███████║███████╗    ██║ █╗ ██║██║  ███╔╝ ███████║██████╔╝██║  ██║"
    printf '%s\n' "██╔══██║██║     ██║██╔══██║╚════██║    ██║███╗██║██║ ███╔╝  ██╔══██║██╔══██╗██║  ██║"
    printf '%s\n' "██║  ██║███████╗██║██║  ██║███████║    ╚███╔███╔╝██║███████╗██║  ██║██║  ██║██████╔╝"
    printf '%s\n' "╚═╝  ╚═╝╚══════╝╚═╝╚═╝  ╚═╝╚══════╝     ╚══╝╚══╝ ╚═╝╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝╚═════╝ "
    printf '%s\n' "                                                                                    "
    sleep 5
}

# Function to detect the shell and define the configuration file
detect_alias_file() {
    printf '%s\n' "Current shell: $SHELL"
    dots "Searching for .bash_aliases file"
    
    ALIAS_FILE="$HOME/.bash_aliases"

    if [ -f "$ALIAS_FILE" ]; then
        print_success "$ALIAS_FILE exists"
    else
        print_error "$ALIAS_FILE not found."
        dots "Creating $ALIAS_FILE file"
        touch "$ALIAS_FILE" || { printf '%s\n' "Failed to create $ALIAS_FILE" && exit 1; }
        print_success "File $ALIAS_FILE created."
    fi
    return 0
}

setup_aliases() {
    dots "Applying alias to .bash_aliases file"
    printf '%s\n' "You can see the list of all aliases documented in the README file"
    
    # Add each alias to the detected config file if it does not already exist
    # Using a here-document for better portability
    while IFS= read -r alias_line; do
        if [ -n "$alias_line" ] && ! grep -qF "$alias_line" "$ALIAS_FILE" 2>/dev/null; then
            printf '%s\n' "$alias_line" >> "$ALIAS_FILE"
        fi
    done << 'EOF'
# Navigation
alias sls='ls -lavh'
alias ll='ls -la'
alias la='ls -A'
alias l='ls -CF'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias ch='cd ~'
# APT shortcuts
alias upg='sudo apt update && sudo apt upgrade -y'
alias install='sudo apt install'
alias remove='sudo apt remove'
alias autoremove='sudo apt autoremove'
alias autoclean='sudo apt autoclean'
alias aptclean='sudo apt clean'
# System shortcuts
alias cls='clear'
alias python='python3'
alias ff='fastfetch'
alias shutdown='systemctl poweroff'
alias reboot='systemctl reboot'
alias srm='sudo rm -rf'
alias rm='rm -iv --preserve-root'
alias cp='cp -iv'
alias mv='mv -iv'
alias ln='ln -iv'
alias srczsh='source ~/.zshrc'
alias srcbash='source ~/.bashrc'
alias c='code .'
# Docker shortcuts
alias dc='docker'
alias dcu='docker compose up -d'
alias dci='docker images'
alias dcps='docker ps'
alias dcrm='docker rm'
alias dcrmi='docker rmi'
alias dockerclean='docker system prune -a --volumes'
# Kubernetes shortcuts
alias kc='kubectl'
alias mc='minikube'
alias kcgp='kubectl get pods'
alias kcgpw='kubectl get pods -o wide'
# Git shortcuts
alias gi='git init .'
alias ga='git add'
alias gc='git commit -m'
alias gp='git push'
alias autocommit='read -p "Commit message: " msg && git add . && git commit -m "$msg"'
alias autopush='read -p "Commit message: " msg && git add . && git commit -m "$msg" && git push'
alias gpl='git pull'
alias gsw='git switch'
alias gsc='git switch -c'
alias glg='git log'
alias gitgraph='git log --oneline --graph --decorate --all'
alias gitlast='git log -1 HEAD'
alias gs='git status'
alias gss='git status -sb'
alias gb='git branch'
alias gbd='git branch -d'
alias gba='git branch -a'
alias gmg='git merge'
alias gco='git checkout'
alias gcl='git clone'
alias gdf='git diff'
alias gst='git stash'
alias grs='git reset --soft'
alias grh='git reset --hard'
alias gitundo='git reset --soft HEAD~1'
alias gitunstage='git reset HEAD --'
alias gitrepair='sudo chown -R "$(whoami)":"$(id -gn)" .git'
alias gitclean='git fetch origin --prune'
# Miscellaneous
alias h='history'
alias rootrc='code .bashrc --no-sandbox --user-data-dir'
alias rootaliases='code .bash_aliases --no-sandbox --user-data-dir'
EOF

    return 0
}

finish_setup() {
    print_success "Aliases configured successfully!"
    dots "Reloading $ALIAS_FILE to activate aliases"
    . "$ALIAS_FILE"
    print_success "Aliases activated successfully!"
    printf '%s\n' "Please restart your terminal"
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

# Run main
main