#!/usr/bin/env bash

WIZARD_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source ./src/common.sh
source ./src/repo/welcome.sh
source ./src/repo/devcontainer.sh
source ./src/repo/agents.sh

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

    cp "$WIZARD_DIR/src/templates/.gitignore" .gitignore

    # Create basic directories
    mkdir -p .vscode .github .github/ISSUE_TEMPLATE

    # Create basic project files
    touch -- .env .env.example .github/dependabot.yml .github/PULL_REQUEST_TEMPLATE.md
    cp "$WIZARD_DIR/src/templates/README.md" README.md
    cp "$WIZARD_DIR/src/templates/CONTRIBUTING.md" CONTRIBUTING.md
    cp "$WIZARD_DIR/src/templates/LICENSE" LICENSE

    # Summary of created files
    printf '%s\n' "Basic project files created:"
    print_success ".gitignore file created"
    print_success ".vscode directory created"
    print_success ".env and .env.example files created"
    print_success "README.md, CONTRIBUTING.md and LICENSE files created"
    printf '%s\n' "Basic GitHub support added "
    print_success ".github directory created with pull request templates subdirectory and dependabot support"
    
    return 0
}

use_container() {
    while :; do
    read -erp "Create the files and directories to support devcontainers? [Y/n] " ans

        case "$ans" in
            [Yy]*|"")
                devcontainer_setup
                return 0
                ;;
            [Nn]*)
                return 0
            ;;
            *)
                print_error "Invalid input, choose between y or n"
                ;;
        esac
    done

    return 0
}

use_agents() {
    while :; do
        read -erp "Create the files and directories to support AI Agents? [Y/n] " ans

        case "$ans" in
            [Yy]*|"")
                agents_setup
                return 0
                ;;
            [Nn]*)
                return 0
            ;;
            *)
                print_error "Invalid input, choose between y or n"
                ;;
        esac
    done

    return 0
}

finish_setup() {
    dots "Making initial commit"
    git add .
    git commit -m "🎉 Project created!"
    printf '%s\n' "Git status:"
    git status
    git switch -c dev
    print_success "Branch 'dev' created and switched to it"
    printf '%s\n' "Repository created with repoWizard"

    return 0
}

# Main execution
main() {
    welcome
    git_test
    new_repo
    basic_setup
    use_container
    use_agents
    finish_setup
    return 0
}

# Run main
main