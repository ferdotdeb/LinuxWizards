#!/bin/bash

source ./common_functions.sh  # Ensure this path is correct

# Global variables
git_username=""
git_email=""
ssh_password=""

# Git exists?

test_git() {
    if command_exists git; then
        print_success "Git is already installed"
        echo "Git version:"
        git --version
        return 0
    else
        print_warning "Git no está instalado. Intentando instalar..."
        sudo apt update
        sudo apt install git -y
        
        # Verificar si la instalación fue exitosa
        if command_exists git; then
            print_success "Git se ha instalado correctamente"
            echo "Git version:"
            git --version
            return 0
        else
            print_error "No se pudo instalar Git. Por favor, instálelo manualmente e inténtelo de nuevo."
            return 1
        fi
    fi
}

# Obtaining user info

validate_email() {
    local email=$1
    local regex="^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$"
    if [[ $email =~ $regex ]]; then
        return 0
    else
        return 1
    fi
}

collect_user_info() {
    echo "Please enter your personal information for Git configuration"
    
    # Get Git username
    echo -n "Enter your full name for Git installation: "
    read git_username
    while [ -z "$git_username" ]; do
        print_error "The name cannot be empty"
        echo -n "Enter your full name for Git installation: "
        read git_username
    done
    
    # Get Git email with validation
    echo -n "Enter your email for Git installation: "
    read git_email
    while ! validate_email "$git_email"; do
        print_error "Please enter a valid email address"
        echo -n "Enter your email for Git installation: "
        read git_email
    done
    
    # Get SSH password
    echo -n "Enter your password for SSH key generation: "
    read -s ssh_password # Flag -s for silent input
    echo # New line after silent input
    
    while [ -z "$ssh_password" ]; do
        print_error "Password cannot be empty"
        echo -n "Enter your password for SSH key generation: "
        read -s ssh_password
        echo
    done

    print_success "Git user information collected successfully!"
    return 0
}

# Git global configs

set_git_global_configs() {
    git config --global init.defaultBranch main
    git config --global user.name "$git_username"
    git config --global user.email "$git_email"
    git config --global pull.rebase false
    git config --global push.autoSetupRemote true

    echo "Name: $git_username"
    echo "Email: $git_email"
    echo "Default branch:"
    print_success "main"
    print_success "Pull strategy: merge (no rebase)"
    print_success "Push auto-setup: enabled"

    print_success "Git global configurations set successfully!"
    return 0
}

# Creating SSH Keys

create_ssh_key() {
    echo "Setting up SSH key..."

    # Creating SSH key
    ssh-keygen -t ed25519 -C "$git_email" -f ~/.ssh/id_ed25519 -N "$ssh_password" -q
    print_success "SSH key created successfully!"
    
    # Set proper permissions for SSH keys
    chmod 600 ~/.ssh/id_ed25519
    chmod 644 ~/.ssh/id_ed25519.pub
    print_success "SSH key permissions set successfully!"

    echo "Starting SSH agent..."
    eval "$(ssh-agent -s)"
    print_success "SSH agent started successfully!"

    print_warning "In 10 seconds you will need to enter your SSH key passphrase"
    sleep 10
    echo "Please enter your SSH key passphrase (if any):"

    ssh-add ~/.ssh/id_ed25519

    print_success "SSH key added to the SSH agent successfully!"

    echo "Saving your public key to public_key.txt..."
    cat ~/.ssh/id_ed25519.pub > public_key.txt

    echo "Your SSH public key (add this to GitHub/GitLab):"
    cat ~/.ssh/id_ed25519.pub

    print_success "SSH key created and added to the SSH agent successfully!"
    return 0
}

# Main execution
main() {
    if ! test_git; then
        print_error "No se puede continuar sin Git. El programa se cerrará."
        exit 1
    fi
    
    collect_user_info
    set_git_global_configs
    create_ssh_key
    return 0
}

# Run main if script is executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main
fi
