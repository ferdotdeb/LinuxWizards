# AGENTS.md

Guidance for agentic coding tools working in this repository.

## Repository Overview
LinuxWizards is a collection of Bash scripts that automate Linux environment setup for developers.
Scripts aim for POSIX compatibility where possible but use Bash features and are run from the repo root.

## Goals for Agents
- Make minimal, targeted changes that follow existing script structure and messaging.
- Preserve interactive flow, prompts, and user-facing output.
- Prefer updates that are safe for repeat runs.

## Layout
- `common.sh`: shared helpers (colors, print_message, print_success/error/warning, dots, command_exists, print_link).
- `*.sh` in repo root: main wizard scripts.
- `scripts/`: helper executables and the `.aliases` file copied by `aliasWizard.sh`.
- `README.md`: user-facing usage and alias reference.
- `CLAUDE.md`: legacy duplicate guidance; treat `AGENTS.md` as source of truth.

## Script Structure Pattern
1. `#!/usr/bin/env bash`
2. `source ./common.sh`
3. `welcome()` banner with colors and a 5-second pause
4. Helper functions for the script's tasks
5. `main()` orchestrates the flow
6. Call `main` at the end

## Common Helpers (common.sh)
- Color constants and `NO_COLOR` handling; disables colors when not a TTY.
- `print_message`, `print_success`, `print_error`, `print_warning` for consistent output.
- `command_exists` for dependency checks.
- `dots` for progress indicators, with optional `DOTS_COUNT` and `DOTS_DELAY`.
- `print_link` for clickable terminal links (OSC 8).

## Script Responsibilities
- `softwareWizard.sh`: apt updates and installs, plus manual install links (requires sudo).
- `gitWizard.sh`: global git config and SSH key creation.
- `aliasWizard.sh`: manages `~/.aliases`, updates shell rc, and installs helper scripts to `~/bin`.
- `repoWizard.sh`: creates repo scaffolding and performs initial commit.
- `debianWizard.sh`: Debian system setup tasks (requires sudo).
- `z.sh`: zsh/oh-my-zsh/powerlevel10k setup.
- `test.sh`: small demo of `print_link` output.

## Running Scripts
- Run from the repo root so `./common.sh` resolves correctly.
- Make executable: `chmod +x scriptName.sh`.
- Execute: `./scriptName.sh`.
- Expect interactive prompts; most scripts are not meant for non-interactive use.
- `softwareWizard.sh` and `debianWizard.sh` require sudo or root.

## Environment and Privileges
- Most scripts assume Debian or Ubuntu tooling (apt, systemctl, timedatectl).
- Network access is required for downloads (curl, git clone).
- `debianWizard.sh` re-execs with sudo when not root.
- Avoid running these scripts in CI without explicit safeguards.

## Script-Specific Notes
- `aliasWizard.sh` copies `scripts/.aliases` to `~/.aliases`; keep README alias docs in sync.
- `aliasWizard.sh` adds source blocks to `.bashrc` or `.zshrc` using `grep -qF` for idempotency.
- `aliasWizard.sh` installs `scripts/run`, `scripts/mkrun`, `scripts/autocommit`, `scripts/autopush` to `~/bin`.
- `gitWizard.sh` writes SSH keys under `~/.ssh`; do not print or log secrets.
- `softwareWizard.sh` installs `uv` and agent tools via curl; keep links in `manual_links()` up to date.
- `z.sh` writes `~/.dircolors` and may append to Ghostty config; ensure parent dirs exist.
- `repoWizard.sh` writes scaffold files and .gitignore entries; keep defaults consistent.

## Build / Lint / Test
Build:
- No build step; scripts are executed directly.

Lint (optional, if tools installed):
- All scripts: `shellcheck *.sh scripts/*`.
- Single file: `shellcheck gitWizard.sh`.
- Syntax-only: `bash -n gitWizard.sh`.

Format:
- No enforced formatter. If you use `shfmt`, keep the existing indentation in the file you touch.

Tests:
- No automated tests in this repo.
- Manual smoke test: run the target script from the repo root (example: `./aliasWizard.sh`).
- Single-test equivalent: `bash -n path/to/script.sh` or `shellcheck path/to/script.sh`.

## Code Style Guidelines (Bash)

Imports and structure:
- Always `source ./common.sh` near the top; do not change the relative path.
- Keep shared logic in `common.sh` rather than duplicating helpers.
- End scripts with a `main` function call.

Formatting:
- Use `printf` instead of `echo` for consistent output.
- Quote variables and expansions: `"$var"`, `"$@"`.
- Prefer `[[ ... ]]` and `case` where already in use.
- Use `local` for function-scoped variables.
- Keep blank lines between top-level functions.
- Preserve existing indentation and wrapping in the file you edit.

Naming and types:
- Functions use lower_snake_case verbs (`install_packages`, `git_test`).
- Globals use lower_snake_case; constants and env vars use UPPER_SNAKE_CASE.
- Keep types simple (strings, integers); avoid arrays unless needed.

User interaction:
- Use `read -erp "Prompt: " var` for prompts.
- Validate required input in loops; default yes with `[Yy]*|""`.
- Use `print_success`, `print_error`, and `print_warning` for status output.
- Use `dots` before long-running commands.
- Keep the 5-second pause after welcome banners for readability.
- `common.sh` handles colors based on TTY and `NO_COLOR`.

Error handling:
- Prefer explicit checks: `if ! command; then ...; return 1; fi`.
- Use `cmd || { print_error "..."; exit 1; }` for fatal failures.
- Avoid `set -e` in wizard scripts unless the whole script is designed for it.
- Use `return 0` for success; return non-zero on failure.

External commands and safety:
- Prefer bash built-ins over external commands when practical.
- Quote paths and use `--` before path arguments where supported.
- Avoid destructive commands without user confirmation.

Files and paths:
- Use absolute paths when writing to user locations (`$HOME`, `~/.ssh`).
- Expand `~` using parameter expansion when needed (`${var/#\~/$HOME}`).
- Use `mkdir -p` and check write permissions before creating files.

Output and logging:
- Keep user-facing messages short and actionable.
- Prefer `print_*` helpers for consistency and color handling.
- When printing links, use `print_link` for clickable output.

Security and secrets:
- Do not print passwords or passphrases to the terminal.
- Never write secrets to tracked files without explicit user request.
- Keep SSH keys under `~/.ssh` and ensure permissions are locked down.

Documentation updates:
- Update `README.md` when changing user-facing behavior or aliases.
- Keep alias lists in `scripts/.aliases` and README in sync.

## Repo Standards
- Default git branch is `main`.
- `repoWizard.sh` performs an initial commit and switches to `dev`.
- Git settings in `gitWizard.sh` use SSH-based signing when available.
- `repoWizard.sh` scaffolding writes `.gitignore` and `.dockerignore` with standard entries.
- Devcontainer layout (when opted in): `docker/dev`, `docker/prod`, `.devcontainer`, `.vscode`.

## Cursor/Copilot Rules
- No `.cursor/rules/`, `.cursorrules`, or `.github/copilot-instructions.md` files exist in this repo.
