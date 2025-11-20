#!/bin/sh

# Source common functions portably
. ./common_functions.sh

welcome() {
    printf '%s\n' "                                                                                  "
    printf '%s\n' "██████╗ ███████╗██████╗  ██████╗     ██╗    ██╗██╗███████╗ █████╗ ██████╗ ██████╗ "
    printf '%s\n' "██╔══██╗██╔════╝██╔══██╗██╔═══██╗    ██║    ██║██║╚══███╔╝██╔══██╗██╔══██╗██╔══██╗"
    printf '%s\n' "██████╔╝█████╗  ██████╔╝██║   ██║    ██║ █╗ ██║██║  ███╔╝ ███████║██████╔╝██║  ██║"
    printf '%s\n' "██╔══██╗██╔══╝  ██╔═══╝ ██║   ██║    ██║███╗██║██║ ███╔╝  ██╔══██║██╔══██╗██║  ██║"
    printf '%s\n' "██║  ██║███████╗██║     ╚██████╔╝    ╚███╔███╔╝██║███████╗██║  ██║██║  ██║██████╔╝"
    printf '%s\n' "╚═╝  ╚═╝╚══════╝╚═╝      ╚═════╝      ╚══╝╚══╝ ╚═╝╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝╚═════╝ "
    printf '%s\n' "                                                                                  "
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

# Obtaining user info
new_repo() {
    # 1) Ask for the target directory, default to current
    printf '%s' "Enter repo location, leave blank to use the actual directory: "
    read -r repo_location
    repo_location=${repo_location:-.}

    # 2) Expand ~ in a portable way
    case $repo_location in
        \~/*) repo_location="$HOME/${repo_location#\~/}" ;;
        \~)   repo_location="$HOME" ;;
    esac

    # 3) Exists but is not a directory
    if [ -e "$repo_location" ] && [ ! -d "$repo_location" ]; then
        print_error "Path exists but is not a directory: $repo_location"
        return 1
    fi

    # 4) Create if it does not exist
    if [ ! -d "$repo_location" ]; then
        printf '%s' "Directory does not exist. Create it? [y/N]"
        read -r ans
        case $ans in
        [Yy]*)
            if ! mkdir -p -- "$repo_location"; then
                print_error "Failed to create: $repo_location"
                return 1
            fi
            print_success "Location created: $repo_location"
            ;;
        *)  print_error "Cannot proceed without a valid location"; exit 0 ;;
        esac
    fi

    # 5) Write permissions
    if [ ! -w "$repo_location" ]; then
        print_error "No write permission on: $repo_location"
        exit 0
    fi
    
    print_success "Using: $repo_location"

    cd "$repo_location" || { print_error "Failed to change directory to: $repo_location"; exit 0; }
}

setting_repo() {
    dots "Setting up the repository"
    git init .

    # Create directories
    mkdir -p docker/dev docker/prod .devcontainer .vscode

    # Create devcontainer files
    touch -- .devcontainer/devcontainer.json .devcontainer/docker-compose.yml

    # Create docker files
    touch docker/dev/Dockerfile docker/dev/docker-compose.yml  docker/prod/Dockerfile docker/prod/docker-compose.yml
    
    # Create project files
    touch README.md LICENSE .env .env.example .gitignore .dockerignore 
    
    # Create .gitignore
    printf '%s\n' '.env' '.venv/' 'node_modules/' '*.log' '*.tmp' '.DS_Store' >> .gitignore

    # Create .dockerignore
    printf '%s\n' '.git/' '.gitignore' '.gitattributes' '.devcontainer/' '.vscode/' '.venv/' 'node_modules/' '.env' '.env.example' '*.log' '*.tmp' '.DS_Store' README.md LICENSE >> .dockerignore
    
    # Add README and LICENSE content
    printf '%s\n' "# New Project" >> README.md
    printf '%s\n' "No license defined for this project yet." >> LICENSE
    
    # Git operations
    git add .
    git commit -m "🎉 Project created!"
    printf '%s\n' "Git status:"
    git status
    git switch -c dev
    print_success "Branch 'dev' created and switched to it."
    print_success "Repository created with repoWizard.sh"
}

# Main execution
main() {
    welcome
    test_git
    new_repo
    setting_repo
    return 0
}

# Run main
main