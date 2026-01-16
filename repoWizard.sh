#!/bin/bash

# Source common functions file
source ./common_functions.sh

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
        # Bash regex extraction (bashismo puro, sin sed)
        git_output=$(git --version 2>/dev/null)
        if [[ $git_output =~ version[[:space:]]([0-9][0-9.]*) ]]; then
            git_version="${BASH_REMATCH[1]}"
        fi
        printf '%s\n' "Git version: $git_version"
        return 0
    else
        print_error "Git is not installed."
        printf '%s\n' "Please install Git manually before running this script."
        exit 1
    fi
}

new_repo() {
    # 1) Ask for the target directory, default to current
    read -erp "Enter repo location, leave blank to use the actual directory: " repo_location
    repo_location=${repo_location:-.}

    # 2) Expand ~ using bash built-in
    repo_location="${repo_location/#\~/$HOME}"

    # 3) Exists but is not a directory (using bash [[ ]])
    if [[ -e "$repo_location" && ! -d "$repo_location" ]]; then
        print_error "Path exists but is not a directory: $repo_location"
        return 1
    fi

    # 4) Create if it does not exist
    if [[ ! -d "$repo_location" ]]; then
        read -erp "Directory does not exist, create it? [Y/n] " ans
        case $ans in
        [Yy]*|"")
            if ! mkdir -p -- "$repo_location"; then
                print_error "Failed to create: $repo_location"
                return 1
            fi
            print_success "Directory created in: $repo_location"
            ;;
        *)  print_error "Cannot proceed without a valid location"; exit 0 ;;
        esac
    fi

    # 5) Write permissions
    if [[ ! -w "$repo_location" ]]; then
        print_error "No write permission on: $repo_location"
        exit 0
    fi

    cd "$repo_location" || { print_error "Failed to change directory to: $repo_location"; exit 0; }
    
    return 0
}

basic_setup(){
    dots "Setting up the repository"

    git init .

    # Create .gitignore
    printf '%s\n' '.env' '.venv/' 'node_modules/' '*.log' '*.tmp' '.DS_Store' >> .gitignore
    print_success ".gitignore file created"

    # Create basic project files README.md, AGENTS.md and LICENSE and env files
    touch .env .env.example README.md AGENTS.md LICENSE
    print_success ".env and .env.example files created"
    printf '%s\n' "# New Project" >> README.md
    printf '%s\n' "No license defined for this project yet." >> LICENSE
    print_success "README.md, AGENTS.md and LICENSE files created"
    
    return 0
}

require_devcontainers(){
    read -erp "Create the files and directories to support devcontainers? [y/N] " ans
    
    case "$ans" in
        [Yy]*)
            devcontainer_setup
            ;;
        *)
            finish_setup
            ;;
    esac
}

devcontainer_setup(){
    # Create directories
    mkdir -p docker/dev docker/prod .devcontainer .vscode

    print_success "Docker and devcontainers directories created"

    # Create devcontainer files
    touch -- .devcontainer/devcontainer.json .devcontainer/compose.yaml

    print_success "Devcontainers files created"

    # Create docker files
    touch docker/dev/Dockerfile docker/dev/compose.yaml  docker/prod/Dockerfile docker/prod/compose.yaml

    print_success "Dockerfiles for prod and dev created"
    
    # Create .dockerignore
    printf '%s\n' '.git/' '.gitignore' '.gitattributes' '.devcontainer/' '.vscode/' '.venv/' 'node_modules/' '.env.example' '*.log' '*.tmp' '.DS_Store' README.md AGENTS.md LICENSE >> .dockerignore
    
    print_success ".dockerignore file created"
    
    finish_setup
}

finish_setup(){
    # Git operations
    dots "Making initial commit"
    git add .
    git commit -m "🎉 Project created!"
    printf '%s\n' "Git status:"
    git status
    git switch -c dev
    print_success "Branch 'dev' created and switched to it."
    printf '%s\n' "Repository created with repoWizard"

    return 0
}

# Main execution
main() {
    welcome
    test_git
    new_repo
    basic_setup
    require_devcontainers
    
    return 0
}

# Run main
main