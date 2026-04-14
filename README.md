# LinuxWizards

A collection of Bash-based setup wizards to automate the setup and configuration of a developer-friendly Linux environment.

## Features

- **Software Wizard:** Installs essential development software, Python UV, AI agents, and provides manual installation links.
- **Git Wizard:** Automates Git configuration and SSH key generation for version control and SSH-based commit signing.
- **Alias Wizard:** Sets up a comprehensive list of shell aliases and helper scripts to boost productivity in the terminal.
- **Repo Wizard:** Initializes new Git repositories with standard files, optional devcontainer support, and AI agent scaffolding.
- **Debian Wizard:** Performs Debian-specific system configuration and cleanup tasks.
- **Z Shell Wizard:** Installs and configures zsh with Oh My Zsh and the Powerlevel10k theme.

## Prerequisites

- A Linux system with Bash support. Most scripts are designed for Debian or Debian-based distributions.
- `git` to clone the repository and manage generated repositories.
- `sudo` or root privileges for `softwareWizard.sh`, `debianWizard.sh`, and parts of `z.sh`.
- An active internet connection for package installation, downloads, and Git operations.

## Getting Started

1. **Clone the repository:**

    ```bash
    git clone https://github.com/don-linux/LinuxWizards.git
    cd LinuxWizards
    ```

2. **Grant execution permissions if needed:**

    You need to make the scripts executable. You can do this with the following command:

    ```bash
    chmod +x scriptName.sh
    ```

3. **Run the desired script from the repository root:**

    Execute the script you need. In general, the command is:

    ```bash
    ./scriptName.sh
    ```

`LinuxWizards` must be cloned as a complete repository. The entry-point scripts source files from `./src/...`, so downloading individual scripts is not a supported workflow and running them outside the repository root will fail.

## Scripts Breakdown

The entry-point scripts live in the repository root, while shared code and assets live under `src/`.

### `src/common.sh`

This utility file should not be executed directly. It provides shared functions used across the wizards, including:

- Color management with `NO_COLOR` support
- Print helpers (`print_success`, `print_error`, `print_warning`)
- Progress indicators (`dots`)
- Command existence checks (`command_exists`)
- Clickable terminal links (`print_link`)
- Shared Git and update helpers used by multiple scripts

### `softwareWizard.sh`

This entry-point wizard uses `src/common.sh` and `src/software/` helpers to automate essential software installation. It performs the following tasks:

- Updates system packages via APT
- Installs essential packages: `vim`, `vlc`, `git`, `fastfetch`, `openssh-client`, `solaar`, `curl`, `wget`, `libfuse2`
- Installs UV (modern Python package manager)
- Installs AI agents: OpenCode and Claude Code
- Provides clickable links for manual installation of Node.js, Docker, Spotify, VS Code, and Cursor

**Requires:** `sudo` or root privileges.

### `gitWizard.sh`

This script streamlines your Git setup by performing the following:

- Validates Git installation
- Prompts for username and email with email format validation
- Creates an ED25519 SSH key with passphrase protection
- Sets proper permissions for SSH keys and adds the key to `ssh-agent`
- Saves the public key to `public_key.txt`
- Configures global Git settings including:
  - Default branch: `main`
  - Auto setup remote on push
  - Default editor: `nano`
  - SSH-based signing when `~/.ssh/id_ed25519.pub` exists
  - Fast-forward-only pulls and enhanced diff/merge settings

### `repoWizard.sh`

This script automates the creation of new Git repositories with a standardized structure:

- Initializes a Git repository in the selected directory
- Copies base project files from `src/templates/`, including `README.md`, `CONTRIBUTING.md`, `LICENSE`, and `.gitignore`
- Creates `.env`, `.env.example`, `.vscode`, and `.github` scaffolding
- Optionally creates devcontainer and Docker support through `src/repo/devcontainer.sh`
- Optionally creates AI agent support for Cursor, GitHub Copilot, OpenCode, Claude Code, and Google Antigravity through `src/repo/agents.sh`
- Creates `.dockerignore` from `src/templates/.dockerignore` when container support is enabled
- Makes the initial `🎉 Project created!` commit
- Creates and switches to the `dev` branch

### `aliasWizard.sh`

This script enhances terminal productivity by:

- Detecting the current shell (`bash` or `zsh`)
- Copying `src/scripts/.aliases` to `~/.aliases`
- Adding an idempotent source block to `.bashrc` or `.zshrc`
- Installing helper scripts from `src/scripts/` to `~/bin`: `run`, `mkrun`, `autocommit`, `autopush`
- Adding `~/bin` to `PATH`

**Supports:** `bash` and `zsh`.

### `debianWizard.sh`

This script performs Debian-specific system configurations:

- Re-executes itself with `sudo` when needed
- Sets the timezone to `America/Mexico_City`
- Removes outdated LibreOffice APT packages and leftover configuration
- Configures Vim with line numbers
- Installs Realtek firmware and Blueman for Bluetooth support

**Requires:** `sudo` or root privileges. Automatically re-executes with sudo if not running as root.
**Recommended for:** Debian 13.

### `z.sh`

This script sets up a modern zsh environment:

- Adds Ghostty terminal configuration if Ghostty is already installed
- Writes custom `~/.dircolors` values for improved contrast
- Updates the system and installs `zsh`
- Installs Oh My Zsh framework
- Installs the Powerlevel10k theme and configures `.zshrc`

**Note:** Requires MesloLGS NF Regular Nerd Font to be installed and set as terminal font.

## Alias Reference

The `aliasWizard.sh` script copies the alias file from `src/scripts/.aliases` to `~/.aliases` and configures your shell to source it. The following aliases are included:

| Category | Alias | Original Command | Description |
| :--- | :--- | :--- | :--- |
| **Navigation** | | | |
| | `ls` | `ls --color=auto` | List files with colors. |
| | `ll` | `ls -la` | List all files (including hidden) in long format. |
| | `la` | `ls -A` | List all files, including hidden, except for `.` and `..`. |
| | `l` | `ls -CF` | List files in columns, marking types. |
| | `lf` | `ls -alF` | List all files in long format with type indicators. |
| | `lh` | `ls -laFh` | List all files in long format with human-readable sizes. |
| | `sls` | `ls -lavh` | List files with detailed, human-readable sizes. |
| | `..` | `cd ..` | Go up one directory. |
| | `...` | `cd ../..` | Go up two directories. |
| | `....` | `cd ../../..` | Go up three directories. |
| | `dir` | `dir --color=auto` | List directory contents with colors. |
| | `vdir` | `vdir --color=auto` | List directory contents verbosely with colors. |
| | `grep` | `grep --color=auto` | Search text with colored output. |
| | `fgrep` | `fgrep --color=auto` | Search fixed strings with colored output. |
| | `egrep` | `egrep --color=auto` | Search extended regex with colored output. |
| **APT Shortcuts** | | | |
| | `upg` | `sudo apt update && sudo apt upgrade -y` | Update package lists and upgrade all packages. |
| | `install` | `sudo apt install` | Install a package. |
| | `remove` | `sudo apt remove` | Remove a package. |
| | `clean` | `sudo apt autoremove && sudo apt autoclean && sudo apt clean` | Clean up unused packages and cache. |
| **System Shortcuts** | | | |
| | `cls` | `clear` | Clear the terminal screen. |
| | `python` | `python3` | Use `python3` as the default Python interpreter. |
| | `ff` | `fastfetch` | Display system information quickly. |
| | `shutdown` | `systemctl poweroff` | Shut down the system. |
| | `reboot` | `systemctl reboot` | Reboot the system. |
| | `rerun` | `sudo !!` | Rerun the last command with sudo. |
| | `status` | `sudo systemctl status` | Check the status of a service. |
| | `start` | `sudo systemctl start` | Start a service. |
| | `stop` | `sudo systemctl stop` | Stop a service. |
| | `restart` | `sudo systemctl restart` | Restart a service. |
| | `srm` | `sudo rm -rf` | Force remove files/directories with elevated privileges. |
| | `rm` | `rm -iv --preserve-root` | Remove files interactively with confirmation and root protection. |
| | `cp` | `cp -iv` | Copy files interactively with confirmation and verbose output. |
| | `mv` | `mv -iv` | Move/rename files interactively with confirmation and verbose output. |
| | `ln` | `ln -iv` | Create links interactively with confirmation and verbose output. |
| | `srczsh` | `source ~/.zshrc` | Reload Zsh configuration file. |
| | `srcbash` | `source ~/.bashrc` | Reload Bash configuration file. |
| | `c` | `code .` | Open current directory in VS Code. |
| | `code` | `code .` | Open current directory in VS Code. |
| | `cursor` | `cursor .` | Open current directory in Cursor. |
| **Docker Shortcuts** | | | |
| | `dc` | `docker` | Shortcut for the `docker` command. |
| | `dcu` | `docker compose up -d` | Start services in detached mode with Docker Compose. |
| | `dci` | `docker images` | List all Docker images. |
| | `dcps` | `docker ps` | List all running containers. |
| | `dcpsa` | `docker ps -a` | List all containers (including stopped). |
| | `dcrm` | `docker rm` | Remove one or more containers. |
| | `dcrmi` | `docker rmi` | Remove one or more images. |
| | `dockerclean` | `docker system prune -a --volumes` | Remove all unused Docker objects, including volumes. |
| **Kubernetes Shortcuts** | | | |
| | `kc` | `kubectl` | Shortcut for the `kubectl` command. |
| | `mc` | `minikube` | Shortcut for the `minikube` command. |
| | `kcgp` | `kubectl get pods` | Get all pods in the current namespace. |
| | `kcgpw` | `kubectl get pods -o wide` | Get all pods with more details (IP, node). |
| **Git Shortcuts** | | | |
| | `gi` | `git init .` | Initialize a new Git repository in the current directory. |
| | `ga` | `git add` | Add file contents to the index. |
| | `gc` | `git commit -m` | Record changes to the repository with a message. |
| | `gp` | `git push` | Update remote refs along with associated objects. |
| | `gpl` | `git pull` | Fetch from and integrate with another repository. |
| | `gsw` | `git switch` | Switch branches. |
| | `gsc` | `git switch -c` | Create and switch to a new branch. |
| | `glg` | `git log` | Show commit logs. |
| | `gitgraph` | `git log --oneline --graph --decorate --all` | Display a decorated, graphical log of all branches. |
| | `gitlast` | `git log -1 HEAD` | Show the last commit. |
| | `gs` | `git status` | Show the working tree status. |
| | `gss` | `git status -sb` | Show the working tree status in a short format. |
| | `gb` | `git branch` | List, create, or delete branches. |
| | `gbd` | `git branch -d` | Delete a branch safely (only if merged). |
| | `gba` | `git branch -a` | List all branches (local and remote). |
| | `gmg` | `git merge` | Merge branches together. |
| | `gco` | `git checkout` | Switch branches or restore working tree files. |
| | `gcl` | `git clone` | Clone a repository into a new directory. |
| | `gdf` | `git diff` | Show changes between commits, commit and working tree, etc. |
| | `gst` | `git stash` | Stash the changes in a dirty working directory away. |
| | `grs` | `git reset --soft` | Reset HEAD to a previous commit, keeping changes staged. |
| | `grh` | `git reset --hard` | Reset HEAD to a previous commit, discarding all changes. |
| | `gitundo` | `git reset --soft HEAD~1` | Undo the last commit, keeping changes staged. |
| | `gitunstage` | `git reset HEAD --` | Unstage files from the index. |
| | `gitrepair` | `sudo chown -R "$(whoami)":"$(id -gn)" .git` | Fix ownership issues in the `.git` directory. |
| | `gitlocal` | `git config --local commit.gpgsign false` | Disable commit signing for the current repository only. |
| | `cleanremote` | `git fetch origin --prune` | Remove remote-tracking branches that no longer exist on the remote. |
| | `deleteremote` | `git push origin --delete` | Delete a remote branch by name. |
| **AI Agents** | | | |
| | `cld` | `claude` | Shortcut for Claude AI agent CLI. |
| | `ocd` | `opencode` | Shortcut for OpenCode AI agent CLI. |
| **Miscellaneous** | | | |
| | `h` | `history` | Display command history. |
| | `rootrc` | `code .bashrc --no-sandbox --user-data-dir` | Open .bashrc in VS Code as root (use with caution). |
| | `rootzrc` | `code .zshrc --no-sandbox --user-data-dir` | Open .zshrc in VS Code as root (use with caution). |
| | `rootaliases` | `code .aliases --no-sandbox --user-data-dir` | Open .aliases in VS Code as root (use with caution). |

## Helper Scripts

The repository contains additional utilities under `src/scripts/`, but `aliasWizard.sh` currently installs the following helper scripts to `~/bin` and adds this directory to your `PATH`:

### `run`

Executes a script or binary. If the filename doesn't contain a slash, it assumes the file is in the current directory (prepends `./`).

**Usage:**

```bash
run script.sh      # Equivalent to ./script.sh
run folder/script  # Equivalent to folder/script
```

### `mkrun`

Makes files executable (`chmod +x`). Like `run`, it assumes files are in the current directory if no path is provided.

**Usage:**

```bash
mkrun script.sh    # Equivalent to chmod +x ./script.sh
mkrun file1 file2  # Makes multiple files executable
```

### `autocommit`

Interactive script that prompts for a commit message, then stages all changes and commits them. Cancels if the message is empty.

**Usage:**

```bash
autocommit
# Prompts: Commit message:
# Then runs: git add . && git commit -m "your message"
```

### `autopush`

Interactive script that prompts for a commit message, then stages all changes, commits them, and pushes to the remote repository. Cancels if the message is empty.

**Usage:**

```bash
autopush
# Prompts: Commit message:
# Then runs: git add . && git commit -m "your message" && git push
```

## License

This project is licensed under the terms of the GNU General Public License. See the [LICENSE](LICENSE) file for details.
