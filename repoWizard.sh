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
        print_error "Git is not installed."
        printf '%s\n' "Please install Git manually before running this script."
        
        exit 1
    fi

    return 0
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
    printf '%s\n' '.env' '.venv/' 'node_modules/' '*.log' '*.tmp' '.DS_Store' 'CLAUDE.local.md' >> .gitignore

    # Create basic directories
    mkdir -p .vscode .github .github/{workflows,ISSUE_TEMPLATE}

    # Create basic project files
    touch -- .env .env.example README.md CONTRIBUTING.md LICENSE .github/workflows/sample-workflow.yml .github/dependabot.yml .github/PULL_REQUEST_TEMPLATE.md
    printf '%s\n' "# New Project" >> README.md
    printf '%s\n' "# How to contribute?" >> CONTRIBUTING.md
    printf '%s\n' "No license defined for this project yet." >> LICENSE

    # Summary of created files
    printf '%s\n' "Basic project files created:"
    print_success ".gitignore file created"
    print_success ".vscode directory created"
    print_success ".env and .env.example files created"
    print_success "README.md, CONTRIBUTING.md and LICENSE files created"
    printf '%s\n' "Basic GitHub support added "
    print_success ".github directory created with workflows and templates subdirectories, plus dependabot support"

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
                print_success "Dockerfiles for production and development environments created"
                
                # Create .dockerignore
                printf '%s\n' '.git/' '.gitignore' '.gitattributes' '.devcontainer/' '.vscode/' '.venv/' '.github/' '.claude/' '.cursor/' '.agent/' '.opencode/' 'node_modules/' '.env.example' '*.log' '*.tmp' '.DS_Store' '.mcp.json' 'opencode.json' '.cursorindexingignore' 'README.md' 'AGENTS.md' 'CLAUDE.md' 'GEMINI.md' 'CONTRIBUTING.md' 'LICENSE' >> .dockerignore
                print_success ".dockerignore file created"
                
                print_success "Devcontainer support added to the repository"
                
                agents_support
                
                return 0
                ;;
            [Nn]*)
                agents_support 
                
                return 0
                ;;
            *)
                print_error "Invalid input, choose between y or n"
                ;;
        esac
    done
}

agents_support() {
    while :; do
        read -erp "Create the files and directories to support AI Agents? [Y/n] " ans

        case "$ans" in
            [Yy]*|"")
                agents_setup
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

agents_setup() {
    printf '%s\n' "# AGENTS.md" >> AGENTS.md
    
    while :; do
        printf '%s\n' "What agent do you want to support? "
        read -erp "Type 1 for Claude, 2 for GitHub Copilot, 3 for Antigravity, 4 for Cursor, 5 for OpenCode " ans

        case "$ans" in
            1)
                mkdir -p .claude/{agents,commands,skills/skill-example,rules}
                touch -- CLAUDE.local.md .mcp.json
                touch -- .claude/rules/coding-style.md
                ln -s AGENTS.md CLAUDE.md
                printf '%s\n' "# CODING STYLE.md" >> .claude/rules/coding-style.md

                print_success "AGENTS.md created and linked to CLAUDE.md"
                print_success ".claude directory created, including CLAUDE.local.md and agents, commands, skills and rules subdirectories"
                print_success "Now this repository has Claude agent support"

                finish_setup
                
                return 0
                ;;
            2)
                mkdir -p .github/{agents,instructions,prompts,skills/SKILL-EXAMPLE}
                touch -- .github/agents/agent-example.agent.md .github/instructions/instruction-example.instructions.md
                touch -- .github/prompts/prompt-example.prompt.md .github/skills/SKILL-EXAMPLE/SKILL.md
                touch -- .github/copilot-instructions.md
                print_success "AGENTS.md and copilot-instructions.md files created"
                print_success ".github directory created, including agents, instructions, prompt and skills directories"
                print_success "Now this repository has GitHub Copilot agent support"
                
                finish_setup
                
                return 0
                ;;
            3)
                mkdir -p .agent/rules .agent/workflows .agent/skills/skill-example 
                touch -- .agent/rules/rules.md .agent/workflows/sample-workflow.md .agent/skills/skill-example/SKILL.md
                ln -s AGENTS.md GEMINI.md

                print_success "AGENTS.md created and linked to GEMINI.md"
                print_success ".agent directory created with rules, workflows and skills subdirectories"
                print_success "Now this repository has Google Antigravity agent support"
                finish_setup
                
                return 0
                ;;
            4)
                mkdir -p .cursor/rules
                touch -- .cursor/rules/coding-style.mdc .mcp.json .cursorindexingignore
                print_success "AGENTS.md created"
                print_success ".cursor directory created, including rules subdirectory"
                print_success "Now this repository has Cursor agent support"

                finish_setup
                
                return 0
                ;;
            5)
                mkdir -p .opencode/{agents,skill/skill-example,commands,plugins}
                touch -- .opencode/agents/agent-example.md .opencode/skills/skill-example/SKILL.md .opencode/commands/command-example.md opencode.json
                print_success "AGENTS.md created"
                printf '%s\n' "OpenCode recommends to add rules for the agent in the AGENTS.md file"
                print_success ".opencode directory created, including agents, skills, commands and plugins directories"
                print_success "Now this repository has OpenCode agent support"
                
                finish_setup
                
                return 0
                ;;  
            *)
                print_error "Invalid input, choose between agents setup options"
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
    
    return 0
}

# Run main
main