# AGENTS.md

This file provides guidance to AI agents (including Claude Code) when working with code in this repository.

## Repository Overview

LinuxWizards is a collection of bash scripts that automate Linux environment setup for developers. All scripts are designed to be POSIX-compliant where possible, with some bash-specific features for enhanced functionality.

## Architecture

### Core Pattern: Common Functions + Specialized Scripts

All wizard scripts follow this structure:

1. **Source common functions**: `source ./common_functions.sh` at the top
2. **Define welcome banner**: ASCII art banner with colored output
3. **Implement specialized functions**: Feature-specific logic
4. **Main execution**: `main()` function that orchestrates the workflow
5. **Run main**: Call `main` at the end

### common_functions.sh - Shared Utilities

The foundation that all scripts depend on. Provides:

- **Color management**: Rainbow colors (RB_*) and standard colors with NO_COLOR support
- **Print helpers**: `print_success()`, `print_error()`, `print_warning()`
- **Utility functions**:
  - `command_exists()` - Check if a command is available
  - `dots()` - Visual loading indicator with customizable count/delay
  - `print_message()` - Core colored message printer
- **Terminal sanity**: TTY detection and stty configuration for proper input handling

Scripts must check for TTY before using interactive features (colors, delays).

### Script Responsibilities

**softwareWizard.sh**: Installs APT packages and third-party apps (Chrome, VS Code). Requires sudo/root privileges.

**gitWizard.sh**: Configures Git globals and generates ED25519 SSH keys with GPG signing. Validates email format with regex.

**aliasWizard.sh**: Sets up shell aliases by:
- Detecting bash/zsh from $SHELL
- Creating/updating ~/.aliases
- Injecting source block into RC file
- Using heredoc to define aliases (prevents duplication with grep -qF)

**repoWizard.sh**: Initializes Git repositories with:
- Standard files: README.md, AGENTS.md, LICENSE, .env, .env.example
- Optional devcontainer setup (Docker, .devcontainer, .vscode)
- Two-branch strategy: initial commit on main, then switch to dev
- Uses `git init .` and commits with emoji: "🎉 Project created!"

## Running Scripts

All scripts must be:
1. Made executable: `chmod +x scriptName.sh`
2. Run from the repository root: `./scriptName.sh`
3. Have access to `common_functions.sh` in the same directory

**Important**: Scripts source common_functions.sh with relative path `./common_functions.sh`, so they must be executed from the directory containing both files.

## Code Style

- Use `printf` instead of `echo` for consistent output
- Quote variables: `"$variable"` not `$variable`
- Use bash built-ins over external commands where possible
- Color escapes: `printf '%b%s%b\n' "$color" "$message" "$NC"`
- Regex matching: Use bash `[[ $var =~ regex ]]` pattern
- Input reading: `read -erp "prompt: " variable` (with readline editing)
- Password input: `stty -echo; read -r password; stty echo`

## User Interaction Patterns

- Validate required inputs in loops until correct
- Use `[Yy]*|""` pattern to make "Yes" the default on confirmations
- Display success/error messages after each operation
- Show version info after detecting installed software
- Use 5-second sleep after welcome banners for readability

## Git Standards in This Repo

- Default branch: main
- Emoji commits are used (see repoWizard.sh commit messages)
- GPG signing: Configured to use SSH keys (gpg.format = ssh)
- Auto-setup remote on push: `push.autoSetupRemote = true`

## File Creation Standards

When creating repos with repoWizard.sh:
- AGENTS.md is the standard (not CLAUDE.md)
- Initial .gitignore includes: .env, .venv/, node_modules/, *.log, *.tmp, .DS_Store
- Initial .dockerignore includes: .git/, .devcontainer/, .vscode/, README.md, AGENTS.md, LICENSE
- devcontainer structure: docker/dev/, docker/prod/, .devcontainer/, .vscode/
