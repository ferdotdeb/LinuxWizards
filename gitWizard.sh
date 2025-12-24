#!/bin/sh

. ./common_functions.sh  # Ensure this path is correct

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
}

test_git() {
    dots "Checking if Git is installed"

    if command_exists git; then
        print_success "Git is already installed"
        git_version=$(git --version 2>/dev/null | sed -n 's/.*version \([0-9][0-9.]*\).*/\1/p')
        printf '%s\n' "Git version: $git_version"
        sleep 3
        return 0
    else
        print_error "Git is not installed."
        printf '%s\n' "Please install Git manually before running this script."
        exit 1
    fi
}

# Regex for email validation function
validate_email() {
    local email="$1"
    local regex="^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$"
    # Use grep for POSIX-compliant regex matching
    if printf '%s\n' "$email" | grep -qE "$regex"; then
        return 0
    else
        print_error "Invalid email format"
        exit 1
    fi
}

# Obtaining user info
collect_user_info() {
    printf '%s\n' "Please enter your personal information for Git configuration"
    
    # Get Git username
    printf '%s' "Enter your full name for Git installation: "
    read -r git_username
    while [ -z "$git_username" ]; do
        print_error "The name cannot be empty"
        printf '%s' "Enter your full name for Git installation: "
        read -r git_username
    done
    
    # Get Git email with validation
    printf '%s' "Enter your email for Git installation: "
    read -r git_email
    while ! validate_email "$git_email"; do
        print_error "Please enter a valid email address"
        printf '%s' "Enter your email for Git installation: "
        read -r git_email
    done
    
    # Get SSH password with stty for portability
    printf '%s' "Enter your password for SSH key generation: "
    stty -echo
    read -r ssh_password
    stty echo
    printf '\n'
    
    while [ -z "$ssh_password" ]; do
        print_error "Password cannot be empty"
        printf '%s' "Enter your password for SSH key generation: "
        stty -echo
        read -r ssh_password
        stty echo
        printf '\n'
    done

    print_success "Git user information collected successfully!"
    return 0
}

# Setting git global configs
set_git_global_configs() {
    dots "Setting Git global configurations"
    git config --global init.defaultBranch main
    git config --global user.name "$git_username"
    git config --global user.email "$git_email"
    git config --global pull.rebase false
    git config --global push.autoSetupRemote true
    git config --global core.editor "nano"

    # Signing (optional, if you use SSH and Git >= 2.34)
    git config --global gpg.format ssh
    git config --global user.signingkey ~/.ssh/id_ed25519.pub
    git config --global commit.gpgsign true
    git config --global tag.gpgSign true

    printf '%s\n' "Git global configurations:"
    printf "Name: %s\n" "$git_username"
    printf "Email: %s\n" "$git_email"
    printf '%s\n' "Default branch: main"
    printf '%s\n' "Pull strategy: merge (no rebase)"
    print_success "Push auto-setup enabled"
    printf '%s\n' "Default editor: nano"
    print_success "GPG commit signing enabled with SSH key"

    print_success "Git global configurations set successfully!"
    return 0
}

# Creating SSH Keys
create_ssh_key() {
    dots "Setting up SSH key"

    # Creating SSH key
    ssh-keygen -t ed25519 -C "$git_email" -f ~/.ssh/id_ed25519 -N "$ssh_password" -q
    print_success "SSH key created successfully!"
    
    # Set proper permissions for SSH keys
    dots "Setting permissions for SSH keys"
    chmod 600 ~/.ssh/id_ed25519
    chmod 644 ~/.ssh/id_ed25519.pub
    print_success "SSH key permissions set successfully!"

    dots "Starting SSH agent"
    # Start SSH agent and source its environment
    ssh_agent_output="$(ssh-agent -s)"
    eval "$ssh_agent_output" >/dev/null 2>&1
    print_success "SSH agent started successfully!"

    print_warning "In 10 seconds you will need to enter your SSH key passphrase"
    sleep 10
    printf '%s\n' "Please enter your SSH key passphrase (if any):"

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

# Main execution
main() {
    welcome
    test_git
    collect_user_info
    set_git_global_configs
    create_ssh_key
    return 0
}

# Run main
main