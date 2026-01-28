#!/usr/bin/env bash

# Ensure this path is correct
source ./common.sh

welcome() {
    printf "${BLUE}                                                                                  ${RESET}\n";
    printf "${BLUE}██████╗ ███████╗██████╗  ██████╗     ██╗    ██╗██╗███████╗ █████╗ ██████╗ ██████╗ ${RESET}\n";
    printf "${BLUE}██╔══██╗██╔════╝██╔══██╗██╔═══██╗    ██║    ██║██║╚══███╔╝██╔══██╗██╔══██╗██╔══██╗${RESET}\n";
    printf "${BLUE}██████╔╝█████╗  ██████╔╝██║   ██║    ██║ █╗ ██║██║  ███╔╝ ███████║██████╔╝██║  ██║${RESET}\n";
    printf "${BLUE}██╔══██╗██╔══╝  ██╔═══╝ ██║   ██║    ██║███╗██║██║ ███╔╝  ██╔══██║██╔══██╗██║  ██║${RESET}\n";
    printf "${BLUE}██║  ██║███████╗██║     ╚██████╔╝    ╚███╔███╔╝██║███████╗██║  ██║██║  ██║██████╔╝${RESET}\n";
    printf "${BLUE}╚═╝  ╚═╝╚══════╝╚═╝      ╚═════╝      ╚══╝╚══╝ ╚═╝╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝╚═════╝ ${RESET}\n";
    printf "${BLUE}                                                                                  ${RESET}\n";
    sleep 5
}

git_test() {
    dots "Checking if git is installed"

    if command_exists git; then
        print_success "Git is already installed"
        git_version=$(git --version)
        printf '%s\n' "$git_version installed"

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

    # 3) Exists but is not a directory
    if [[ -e "$repo_location" && ! -d "$repo_location" ]]; then
        print_error "Path exists but is not a directory: $repo_location"
        return 1
    fi

    # 4) Create if it does not exist
    if [[ ! -d "$repo_location" ]]; then
        while :; do
            read -erp "Directory does not exist, create it? [Y/n] " ans
            case $ans in
                [Yy]*|"")
                    if ! mkdir -p -- "$repo_location"; then
                        print_error "Failed to create: $repo_location"
                        return 1
                    fi
                    print_success "Directory created in: $repo_location"
                    break
                    ;;
                [Nn]*)
                    print_error "Directory not created, exiting."
                    exit 0
                    ;;
                *)
                    print_error "Invalid input, choose between y or n"
                    ;;
            esac
        done
    fi

    # 5) Write permissions
    if [[ ! -w "$repo_location" ]]; then
        print_error "No write permission on: $repo_location"
        exit 0
    fi

    cd "$repo_location" || { print_error "Failed to change directory to: $repo_location"; exit 0; }
    
    return 0
}

basic_setup() {
    dots "Setting up the repository"

    git init .

    # Create .gitignore
    printf '%s\n' '.env' '.venv/' 'node_modules/' '*.log' '*.tmp' '.DS_Store' CLAUDE.local.md >> .gitignore
    print_success ".gitignore file created"

    # Create basic directories
    mkdir .vscode

    # Create basic project files
    touch -- .env .env.example README.md CONTRIBUTING.md LICENSE
    printf '%s\n' "# New Project" >> README.md
    printf '%s\n' "# How to contribute?" >> CONTRIBUTING.md
    printf '%s\n' "No license defined for this project yet." >> LICENSE
    print_success ".env and .env.example files created"
    print_success "README.md, CONTRIBUTING.md and LICENSE files created"
    print_success "Basic project files created"

    devcontainer_setup
    
    return 0
}

devcontainer_setup() {
    while :; do
        read -erp "Create the files and directories to support devcontainers? [Y/n] " ans

        case "$ans" in
            [Yy]*|"")
                # Create directories
                mkdir -p docker/dev docker/prod .devcontainer

                print_success "Docker and devcontainer directories created"

                # Create devcontainer files
                touch -- .devcontainer/{devcontainer.json,compose.yaml}

                print_success "Devcontainers files created"

                # Create docker files
                touch docker/dev/{Dockerfile,compose.yaml} docker/prod/{Dockerfile,compose.yaml}

                print_success "Dockerfiles for prod and dev created"
                
                # Create .dockerignore
                printf '%s\n' '.git/' '.gitignore' '.gitattributes' '.devcontainer/' '.vscode/' '.venv/' '.github/' '.claude/' '.cursor/' 'node_modules/' '.env.example' '*.log' '*.tmp' '.DS_Store' README.md AGENTS.md CLAUDE.md CONTRIBUTING.md LICENSE >> .dockerignore
                
                print_success ".dockerignore file created"
                print_success "Devcontainer support added to the repository"
                
                agents_setup
                
                return 0
                ;;
            [Nn]*)
                agents_setup 
                
                return 0
                ;;
            *)
                print_error "Invalid input, choose between y or n"
                ;;
        esac
    done
}

agents_setup() {
    while :; do
        read -erp "Create the files and directories to support AI Agents? [Y/n] " ans

        case "$ans" in
            [Yy]*|"")
                mkdir -p .github .claude/rules .cursor/rules
                touch -- AGENTS.md .claude/{CLAUDE.md,CLAUDE.local.md,rules/coding-style.md} .github/copilot-instructions.md
                printf '%s\n' "# AGENTS.md" >> AGENTS.md
                printf '%s\n' "# CODING STYLE.md" >> .claude/rules/coding-style.md

                print_success "AGENTS.md created"
                print_success ".claude directory created, including CLAUDE.md and rules subdirectory"
                print_success ".github directory created, including copilot-instructions.md file"
                print_success ".cursor directory created, including rules subdirectory"
                print_success "AI Agents support added to the repository"


                finish_setup
                
                return 0
                ;;
            [Nn]*)
                finish_setup

                return 0
                ;;
            *)
                print_error "Invalid input, choose between y or n"
                ;;
        esac
    done

}

finish_setup() {
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
    git_test
    new_repo
    basic_setup
    
    return 0
}

# Run main
main