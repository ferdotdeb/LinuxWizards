#!/usr/bin/env bash

# Ensure this path is correct
source ./common.sh

# Regex for email validation function
validate_email() {
    local email="$1"
    local regex="^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$"
    
    if [[ $email =~ $regex ]]; then
        return 0
    else
        print_error "Invalid email format"
        return 0
    fi
}

# Global variables
git_username=""
git_email=""
ssh_password=""

welcome() {
    printf "${ORANGE}                                                                      ${RESET}\n";
    printf "${ORANGE} ██████╗ ██╗████████╗    ██╗    ██╗██╗███████╗ █████╗ ██████╗ ██████╗ ${RESET}\n";
    printf "${ORANGE}██╔════╝ ██║╚══██╔══╝    ██║    ██║██║╚══███╔╝██╔══██╗██╔══██╗██╔══██╗${RESET}\n";
    printf "${ORANGE}██║  ███╗██║   ██║       ██║ █╗ ██║██║  ███╔╝ ███████║██████╔╝██║  ██║${RESET}\n";
    printf "${ORANGE}██║   ██║██║   ██║       ██║███╗██║██║ ███╔╝  ██╔══██║██╔══██╗██║  ██║${RESET}\n";
    printf "${ORANGE}╚██████╔╝██║   ██║       ╚███╔███╔╝██║███████╗██║  ██║██║  ██║██████╔╝${RESET}\n";
    printf "${ORANGE} ╚═════╝ ╚═╝   ╚═╝        ╚══╝╚══╝ ╚═╝╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝╚═════╝ ${RESET}\n";
    printf "${ORANGE}                                                                      ${RESET}\n";
    sleep 5

    return 0
}

git_test() {
    dots "Checking if git is installed"

    if command_exists git; then
        print_success "Git is already installed"
        git_version=$(git --version)
        printf '%s\n' "$git_version installed"
        return 0
    else
        print_error "Git is not installed"
        printf '%s\n' "Please install Git manually before running this script"
        exit 1
    fi
}

git_username () {
    read -erp "Enter your username for git: " git_username

    while [[ -z "$git_username" ]]; do
        print_error "The name cannot be empty"
        read -erp "Enter your username for git: " git_username
    done

    return 0
}

git_email() {
    read -erp "Enter the email address for your git user: " git_email
    
    while ! validate_email "$git_email"; do
        print_error "Please enter a valid email address"
        read -erp "Enter the email address for your git user: " git_email
    done

    return 0
}

ssh_password() {
    printf '%s' "Create a password for your SSH key generation"

    read -erp ssh_password

    while [[ -z "$ssh_password" ]]; do
        print_error "Password cannot be empty"
        printf '%s' "Enter your password for SSH key generation: "
        read -erp ssh_password
    done

    return 0
}

create_ssh_key() {
    dots "Setting up SSH key"

    # Creating SSH key
    ssh-keygen -t ed25519 -C "$git_email" -f ~/.ssh/id_ed25519 -N "$ssh_password" -q
    print_success "SSH key created successfully!"

    cd ~/.ssh
    
    # Set proper permissions for SSH keys
    dots "Setting permissions for SSH keys"
    chmod 600 ~/.ssh/id_ed25519
    chmod 644 ~/.ssh/id_ed25519.pub
    print_success "SSH key permissions set successfully!"

    # Start SSH agent and source its environment
    dots "Starting SSH agent"
    eval "$(ssh-agent -s)"
    print_success "SSH agent started successfully!"

    print_warning "In 5 seconds you will need to enter your SSH key passphrase"
    sleep 5
    read -erp "Please enter your SSH key passphrase: "

    dots "Adding SSH key to the SSH agent"
    ssh-add ~/.ssh/id_ed25519
    print_success "SSH key added to the SSH agent successfully!"

    dots "Saving your public key to public_key.txt file"
    cat ~/.ssh/id_ed25519.pub > public_key.txt

    printf '%s\n' "This is your SSH public key (add this to GitHub/GitLab):"
    cat ~/.ssh/id_ed25519.pub

    print_success "SSH key created and added to the SSH agent successfully!"

    return 0
}

git_configs() {
    dots "Setting Git global configurations"
    
    git config --global init.defaultBranch main
    git config --global user.name "$git_username"
    git config --global user.email "$git_email"
    git config --global pull.rebase false
    git config --global push.autoSetupRemote true
    git config --global core.editor "nano"
    
    if [ -f ~/.ssh/id_ed25519.pub ]; then
        git config --global gpg.format ssh
        git config --global user.signingkey "$(realpath ~/.ssh/id_ed25519.pub)"
        git config --global commit.gpgsign true
        git config --global tag.gpgSign true
    else
        print_warning "No SSH key found, skipping commit signing"
    fi

    git config --global pull.ff only
    git config --global merge.conflictStyle zdiff3
    git config --global diff.colorMoved default

    return 0
}

finish_setup () {
    printf '%s\n' "Git global configurations:"
    printf "Name: %s\n" "$git_username"
    printf "Email: %s\n" "$git_email"
    printf '%s\n' "Default branch: main"
    printf '%s\n' "Pull strategy: merge (no rebase)"
    printf '%s\n' "Push autoSetupRemote enabled (No origin branch required)"
    printf '%s\n' "Default editor: nano"

    if [ -f ~/.ssh/id_ed25519.pub ]; then
    print_success "GPG commit signing enabled with SSH key"
    else
        print_error "Commit signing NOT enabled"
    fi    

    print_success "Git configured successfully!"
    printf '%s\n' "Git configuration by GitWizard"
    
    return 0
}
 
main() {
    welcome
    git_test
    git_username
    git_email
    ssh_password
    create_ssh_key
    git_configs
    finish_setup

    return 0
}

# Run main
main