agents_setup() {
    touch AGENTS.md
    mkdir -p .agents/{rules,skills,agents,commands,workflows,plugins,instructions,prompts}
    
    while :; do
        printf '%s\n' "What agent do you want to support? "
        read -erp "Type 1 for Cursor, 2 for GitHub Copilot, 3 for OpenCode, 4 for Claude Code, 5 for Google Antigravity: " ans

        case "$ans" in
            1)
                mkdir -p .cursor
                mkdir -p .cursor/rules
                touch -- .cursorignore
                touch -- .cursorindexingignore
                
                cp "$WIZARD_DIR/src/repo/mdtomdc.sh" .cursor/rules/mdtomdc.sh
                
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
                
                return 0
                ;;
            3)
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
                
                return 0
                ;;  
            4)
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
                
                return 0
                ;;
            5)
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

                return 0
                ;;
            *)
                print_error "Invalid input, choose between agents setup options"
                ;;
        esac
    done

    return 0
}