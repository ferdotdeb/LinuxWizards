#!/bin/sh

# Source common functions
. ./common_functions.sh

welcome() {
    printf "${BLUE}                                                                                    ${RESET}\n";
    printf "${BLUE} █████╗ ██╗     ██╗ █████╗ ███████╗    ██╗    ██╗██╗███████╗ █████╗ ██████╗ ██████╗ ${RESET}\n";
    printf "${BLUE}██╔══██╗██║     ██║██╔══██╗██╔════╝    ██║    ██║██║╚══███╔╝██╔══██╗██╔══██╗██╔══██╗${RESET}\n";
    printf "${BLUE}███████║██║     ██║███████║███████╗    ██║ █╗ ██║██║  ███╔╝ ███████║██████╔╝██║  ██║${RESET}\n";
    printf "${BLUE}██╔══██║██║     ██║██╔══██║╚════██║    ██║███╗██║██║ ███╔╝  ██╔══██║██╔══██╗██║  ██║${RESET}\n";
    printf "${BLUE}██║  ██║███████╗██║██║  ██║███████║    ╚███╔███╔╝██║███████╗██║  ██║██║  ██║██████╔╝${RESET}\n";
    printf "${BLUE}╚═╝  ╚═╝╚══════╝╚═╝╚═╝  ╚═╝╚══════╝     ╚══╝╚══╝ ╚═╝╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝╚═════╝ ${RESET}\n";
    printf "${BLUE}                                                                                    ${RESET}\n";
    sleep 5
}

ALIAS_SOURCE_BLOCK='if [ -f ~/.aliases ]; then
    . ~/.aliases
fi'

config_source() {
    dots "Searching for your current shell"

    if echo "$SHELL" | grep -q "bash"; then
        print_success "bash shell detected"
        RC_FILE="$HOME/.bashrc"
    elif echo "$SHELL" | grep -q "zsh"; then
        print_success "zsh shell detected"
        RC_FILE="$HOME/.zshrc"
    else
        print_error "The $SHELL shell is unsupported"
        printf '%s\n' "This script currently supports only bash and zsh shells."
        exit 1
    fi

    # Check if the alias source block already exists in RC_FILE
    if grep -qF "if [ -f ~/.aliases ]; then" "$RC_FILE" 2>/dev/null; then
        print_success "Alias source block already exists in $RC_FILE file"
    else
        dots "Adding alias source block to $RC_FILE file"
        # Append the ALIAS_SOURCE_BLOCK to the RC_FILE
        printf '\n%s\n' "$ALIAS_SOURCE_BLOCK" >> "$RC_FILE" || {
            print_error "Failed to add alias source block to $RC_FILE file"
            exit 1
        }
        print_success "Alias source block added to $RC_FILE file successfully!"
    fi

    return 0
}

detect_alias_file() {
    ALIAS_FILE="$HOME/.aliases"

    if [ -f "$ALIAS_FILE" ]; then
        print_success "$ALIAS_FILE already exists"
    else
        print_error "$ALIAS_FILE not found."
        dots "Creating $ALIAS_FILE file"
        touch "$ALIAS_FILE" || { printf '%s\n' "Failed to create $ALIAS_FILE" && exit 1; }
        print_success "File $ALIAS_FILE created."
    fi
    return 0
}

setup_aliases() {
    dots "Applying alias to .aliases file"
    dots "You can see the list of all aliases documented in the README file"
    
    # Add each alias to the detected config file if it does not already exist
    # Using a here-document for better portability
    while IFS= read -r alias_line; do
        if [ -n "$alias_line" ] && ! grep -qF "$alias_line" "$ALIAS_FILE" 2>/dev/null; then
            printf '%s\n' "$alias_line" >> "$ALIAS_FILE"
        fi
    done << 'EOF'
# Navigation
alias ls='ls --color=auto'
alias ll='ls -la'
alias la='ls -A'
alias l='ls -CF'
alias lf='ls -alF'
alias lh='ls -laFh'
alias sls='ls -lavh'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias ch='cd ~'
alias dir='dir --color=auto'
alias vdir='vdir --color=auto'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
# APT shortcuts
alias upg='sudo apt update && sudo apt upgrade -y'
alias install='sudo apt install'
alias remove='sudo apt remove'
alias clean='sudo apt autoremove && sudo apt autoclean && sudo apt clean'
# System shortcuts
alias cls='clear'
alias python='python3'
alias ff='fastfetch'
alias shutdown='systemctl poweroff'
alias reboot='systemctl reboot'
alias rerun='sudo !!' 
alias status='sudo systemctl status'
alias start='sudo systemctl start'
alias stop='sudo systemctl stop'
alias restart='sudo systemctl restart'
alias srm='sudo rm -rf'
alias rm='rm -iv --preserve-root'
alias cp='cp -iv'
alias mv='mv -iv'
alias ln='ln -iv'
alias srczsh='source ~/.zshrc'
alias srcbash='source ~/.bashrc'
alias c='code .'
alias code='code .'
alias cursor='cursor .'
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
alias rootzrc='code .zshrc --no-sandbox --user-data-dir'
alias rootaliases='code .aliases --no-sandbox --user-data-dir'
# Execute files more easily
run() {
  if [ "$#" -eq 0 ]; then
    printf '%s\n' "You must provide at least one argument."
    printf '%s\n' "Example: run fileToExecute.sh"
    return 1
  fi

  case $1 in
    *[!/]*)
      # Don't contain "/", use ./fileToExecute.sh
      cmd=./$1
      ;;
    *)
      # Already contains "/", use as is (./fileToExecute.sh, dir/fileToExecute.sh, /path/fileToExecute.sh)
      cmd=$1
      ;;
  esac

  shift
  "$cmd" "$@"
}
# Make files executable more easily
mkrun() {
    if [ "$#" -eq 0 ]; then
        printf '%s\n' "You must provide at least one argument."
        printf '%s\n' "Example: mkrun script.sh"
        return 1
    fi

    for f in "$@"; do
        case $f in
            */*)
                # Ya trae ruta: ./script.sh, scripts/a.sh, /ruta/b.sh
                target=$f
                ;;
            *)
                # Solo nombre → asumimos ./nombre
                target=./$f
                ;;
        esac
        chmod +x "$target"
    done
} # End of alias definitions
EOF

    return 0
}

finish_setup() {
    print_success "Aliases configured successfully!"
    dots "Reloading $ALIAS_FILE to activate aliases"
    . "$ALIAS_FILE"
    print_success "Aliases activated successfully with aliasWizard"
    printf '%s\n' "Please restart your terminal"
    return 0
}

# Main function to organize the script flow
main() {
    welcome
    config_source
    detect_alias_file
    setup_aliases
    finish_setup
    return 0
}

# Run main
main