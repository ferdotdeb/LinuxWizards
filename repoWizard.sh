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
    mkdir -p .vscode .github .github/ISSUE_TEMPLATE

    # Create basic project files
    touch -- .env .env.example README.md CONTRIBUTING.md LICENSE .github/dependabot.yml .github/PULL_REQUEST_TEMPLATE.md
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
    print_success ".github directory created with pull request templates subdirectory and dependabot support"

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
    mkdir -p .agents/{rules,skills,agents,commands,workflows,plugins,instructions,prompts}
    
    while :; do
        printf '%s\n' "What agent do you want to support? "
        read -erp "Type 1 for Claude Code, 2 for GitHub Copilot, 3 for Google Antigravity, 4 for Cursor, 5 for OpenCode: " ans

        case "$ans" in
            1)
                mkdir -p .claude
                touch -- CLAUDE.local.md
                ln -s AGENTS.md CLAUDE.md
                ln -s ../.agents/rules .claude/rules
                ln -s ../.agents/skills .claude/skills
                ln -s ../.agents/agents .claude/agents
                ln -s ../.agents/commands .claude/commands
                ln -s ../.agents/workflows .claude/workflows
                
                print_success "AGENTS.md created and linked to CLAUDE.md"
                print_success ".claude directory created, including CLAUDE.local.md, rules, skills, agents, commands and workflows subdirectories symlinked from .agents"
                print_success "Now this repository has Claude agent support"

                finish_setup
                
                return 0
                ;;
            2)
                ln -s ../.agents/rules .github/rules
                ln -s ../.agents/skills .github/skills
                ln -s ../.agents/agents .github/agents
                ln -s ../.agents/commands .github/commands
                ln -s ../.agents/workflows .github/workflows
                ln -s ../.agents/plugins .github/plugins
                ln -s ../.agents/instructions .github/instructions
                ln -s ../.agents/prompts .github/prompts

                ln -s AGENTS.md .github/copilot-instructions.md

                print_success "AGENTS.md created and linked to copilot-instructions.md"
                print_success ".github directory created, including rules, skills, agents, commands, workflows, plugins, instructions and prompts directories symlinked from .agents"
                print_success "Now this repository has GitHub Copilot agent support"
                
                finish_setup
                
                return 0
                ;;
            3)
                mkdir -p .agent
                ln -s ../.agents/rules .agent/rules
                ln -s ../.agents/skills .agent/skills
                ln -s ../.agents/agents .agent/agents
                ln -s ../.agents/commands .agent/commands
                ln -s ../.agents/workflows .agent/workflows

                ln -s AGENTS.md GEMINI.md

                print_success "AGENTS.md created and linked to GEMINI.md"
                print_success ".agent directory created with rules, skills, agents, commands and workflows subdirectories symlinked from .agents"
                print_success "Now this repository has Google Antigravity agent support"
                finish_setup
                
                return 0
                ;;
            4)
                mkdir -p .cursor
                mkdir -p .cursor/rules
                touch -- .cursorignore
                touch -- .cursorindexingignore
                
                cat > .cursor/rules/mdtomdc.sh << 'SCRIPT'
#!/bin/bash
REPO_ROOT="$(cd "$(dirname "$0")/../.." && pwd)"

for f in "$REPO_ROOT"/.agents/rules/*.md; do
    [ -e "$f" ] || continue
    base=$(basename "$f" .md)
    ln -sfn "../../.agents/rules/${base}.md" "$REPO_ROOT/.cursor/rules/${base}.mdc"
done
SCRIPT
                chmod +x .cursor/rules/mdtomdc.sh
                
                ln -s ../.agents/skills .cursor/skills
                ln -s ../.agents/agents .cursor/agents
                ln -s ../.agents/commands .cursor/commands
                ln -s ../.agents/workflows .cursor/workflows
                
                print_success "AGENTS.md created"
                print_success ".cursorignore and .cursorindexingignore files created"
                print_warning "You need to run the mdtomdc.sh script to create the symlinks for the rules from .agents/rules directory to .cursor/rules directory with .mdc extension"
                print_success ".cursor directory created, including skills, agents, commands and workflows subdirectories symlinked from .agents"
                print_success "Now this repository has Cursor agent support"

                finish_setup
                
                return 0
                ;;
            5)
                mkdir -p .opencode
                touch -- .opencode/opencode.json
                ln -s ../.agents/rules .opencode/rules
                ln -s ../.agents/skills .opencode/skills
                ln -s ../.agents/agents .opencode/agents
                ln -s ../.agents/commands .opencode/commands

                print_success "AGENTS.md created"
                print_success ".opencode.json file created in .opencode directory for MCP support"
                print_success ".opencode directory created, including rules, skills, agents and commands subdirectories symlinked from .agents"
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