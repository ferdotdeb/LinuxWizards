#!/bin/bash

source ./common_functions.sh  # Ensure this path is correct

# Global variables
git_repo_name=""

welcome() {
    echo "                                                                                  ";
    echo "██████╗ ███████╗██████╗  ██████╗     ██╗    ██╗██╗███████╗ █████╗ ██████╗ ██████╗ ";
    echo "██╔══██╗██╔════╝██╔══██╗██╔═══██╗    ██║    ██║██║╚══███╔╝██╔══██╗██╔══██╗██╔══██╗";
    echo "██████╔╝█████╗  ██████╔╝██║   ██║    ██║ █╗ ██║██║  ███╔╝ ███████║██████╔╝██║  ██║";
    echo "██╔══██╗██╔══╝  ██╔═══╝ ██║   ██║    ██║███╗██║██║ ███╔╝  ██╔══██║██╔══██╗██║  ██║";
    echo "██║  ██║███████╗██║     ╚██████╔╝    ╚███╔███╔╝██║███████╗██║  ██║██║  ██║██████╔╝";
    echo "╚═╝  ╚═╝╚══════╝╚═╝      ╚═════╝      ╚══╝╚══╝ ╚═╝╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝╚═════╝ ";                                                                        
    echo "                                                                                  ";
    sleep 5
}

test_git() {
    echo "Checking if Git is installed..."

    if command_exists git; then
        print_success "Git is already installed"
        echo "Git version:"
        git --version
        sleep 3
        return 0
    else
        print_warning "Git is not installed. Attempting to install..."
        sudo apt update
        sudo apt install git -y
        
        # Verify if the installation was successful
        if command_exists git; then
            print_success "Git has been installed successfully"
            echo "Git version:"
            git --version
            sleep 3
            return 0
        else
            print_error "Git could not be installed. Please install it manually and try again."
            return 1
        fi
    fi
}

# Obtaining user info
new_repo() {
    echo "Starting repository setup..."
    
    # Get Git username
    echo -n "Enter the name of the repository you want to create:"
    read git_repo_name
    while [ -z "$git_repo_name" ]; do
        print_error "The name cannot be empty"
        echo -n "Enter the name of the repository you want to create:"
        read git_repo_name
    done
    
    # Get repository location
    echo -n "Enter the location where you want to create the repository (default: current directory):"
    read repo_location
    if [ -z "$repo_location" ]; then
        repo_location="."
    fi
    
    # Verify the location exists
    if [ ! -d "$repo_location" ]; then
        print_error "The location does not exist"
        echo -n "Do you want to create it? (y/n):"
        read create_dir
        if [[ "$create_dir" == "y" || "$create_dir" == "Y" ]]; then
            mkdir -p "$repo_location"
            print_success "Location created successfully"
        else
            print_error "Cannot proceed without a valid location"
            return 1
        fi
    fi
}   

# Main execution
main() {
    welcome

    if ! test_git; then
        print_error "Cannot proceed without Git. The program will exit."
        exit 1
    fi
    
    new_repo
    return 0
}

# Run main if script is executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main
fi