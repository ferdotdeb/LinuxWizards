#!/usr/bin/env bash

# Ensure this path is correct
source ./common.sh

ALIAS_SOURCE_BLOCK='if [[ -f ~/.aliases ]]; then
    . ~/.aliases
fi'

BIN_SOURCE_BLOCK='if [[ -d "$HOME/bin" ]] && [[ ":$PATH:" != *":$HOME/bin:"* ]]; then
    export PATH="$HOME/bin:$PATH"
fi'

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
    if grep -qF "if [[ -f ~/.aliases ]]; then" "$RC_FILE" 2>/dev/null; then
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

    if [[ -f "$ALIAS_FILE" ]]; then
        print_success "$ALIAS_FILE already exists"
        dots "Updating $ALIAS_FILE"

        rm -f "$ALIAS_FILE" || {
            print_error "Failed to update existing $ALIAS_FILE"
            exit 1
        }
    else
        print_warning "$ALIAS_FILE not found."
    fi
    return 0
}

setup_aliases() {
    dots "Copying .aliases file"
    dots "You can see the list of all aliases documented in the README file"
    
    cp scripts/.aliases $HOME/.aliases || {
        print_error "Failed to copy aliases to the home directory"
        dots "Exiting"
        exit 1
    }

    return 0
}

add_bin(){
    mkdir -p ~/bin

    cp scripts/mkrun ~/bin/mkrun
    cp scripts/run ~/bin/run
    cp scripts/autocommit ~/bin/autocommit
    cp scripts/autopush ~/bin/autopush

    chmod +x ~/bin/mkrun
    chmod +x ~/bin/run
    chmod +x ~/bin/autocommit
    chmod +x ~/bin/autopush
    
    if grep -qF "if [[ -d "$HOME/bin" ]] && [[ ":$PATH:" != *":$HOME/bin:"* ]]; then" "$RC_FILE" 2>/dev/null; then
        print_success "~/bin source block already exists in $RC_FILE file"
    else
        dots "Adding ~/bin source block to $RC_FILE file"
        # Append the BIN_SOURCE_BLOCK to the RC_FILE
        printf '\n%s\n' "$BIN_SOURCE_BLOCK" >> "$RC_FILE" || {
            print_error "Failed to add ~/bin source block to $RC_FILE file"
            exit 1
        }
        print_success "~/bin source block added to $RC_FILE file successfully!"
    fi
}

finish_setup() {
    print_success "Aliases configured successfully!"
    dots "Reloading $RC_FILE to activate aliases"
    source "$RC_FILE"
    printf '%s\n' "Please restart your terminal"
    printf '%s\n' "Aliases activated successfully with aliasWizard"

    return 0
}

# Main function to organize the script flow
main() {
    welcome
    config_source
    detect_alias_file
    setup_aliases
    add_bin
    finish_setup
    
    return 0
}

# Run main
main