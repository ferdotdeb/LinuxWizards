# LinuxWizards

A collection of powerful shell scripts to automate the setup and configuration of a developer-friendly Linux environment.

## Features

- **Software Wizard:** Installs essential development software, Python UV, AI agents, and provides manual installation links.
- **Git Wizard:** Automates Git configuration and SSH key generation for seamless version control.
- **Alias Wizard:** Sets up a comprehensive list of shell aliases and helper scripts to boost productivity in the terminal.
- **Repo Wizard:** Initializes new Git repositories with standard configurations and project structures.
- **Debian Wizard:** Performs Debian-specific system configurations and fixes.
- **Z Shell Wizard:** Installs and configures zsh with Oh My Zsh and Powerlevel10k theme.

## Prerequisites

- Linux distribution, MacOS or any system with Bash shell support.
- Debian or a Debian-based Linux distribution (Only for softwareWizard).
- `sudo` or root privileges.
- An active internet connection (For downloading software and updates).

## Getting Started

1. **Clone the repository:**

    ```bash
    git clone https://github.com/ferdotdev/LinuxWizards.git
    cd LinuxWizards
    ```

    **1.1. Or download the scripts individually:**

    Use `curl` to download the scripts you need. Note that `common.sh` is required by all other scripts.

    ```bash
    curl -O https://raw.githubusercontent.com/ferdotdev/LinuxWizards/main/common.sh
    ```

    ```bash
    curl -O https://raw.githubusercontent.com/ferdotdev/LinuxWizards/main/softwareWizard.sh
    ```

    ```bash
    curl -O https://raw.githubusercontent.com/ferdotdev/LinuxWizards/main/gitWizard.sh
    ```

    ```bash
    curl -O https://raw.githubusercontent.com/ferdotdev/LinuxWizards/main/aliasWizard.sh
    ```

    ```bash
    curl -O https://raw.githubusercontent.com/ferdotdev/LinuxWizards/main/repoWizard.sh
    ```

    ```bash
    curl -O https://raw.githubusercontent.com/ferdotdev/LinuxWizards/main/debianWizard.sh
    ```

    ```bash
    curl -O https://raw.githubusercontent.com/ferdotdev/LinuxWizards/main/z.sh
    ```

2. **Grant execution permissions:**

    You need to make the scripts executable. You can do this with the following command:

    ```bash
    chmod +x scriptName.sh
    ```

3. **Run the desired script:**

    Execute the script you need. In general, the command is:

    ```bash
    ./scriptName.sh
    ```

## Scripts Breakdown

### `common.sh`

This is a utility script and should not be executed directly. It provides shared functions used by all other scripts including:
- Color management with `NO_COLOR` support
- Print helpers (`print_success`, `print_error`, `print_warning`)
- Progress indicators (`dots`)
- Command existence checks (`command_exists`)
- Clickable terminal links (`print_link`)

### `softwareWizard.sh`

This script automates the installation of essential software for developers. It performs the following tasks:
- Updates system packages via APT
- Installs essential packages: `vim`, `vlc`, `git`, `fastfetch`, `openssh-client`, `solaar`, `curl`, `wget`
- Installs UV (modern Python package manager)
- Installs AI agents: OpenCode and Claude Code
- Provides clickable links for manual installation of: Node.js, Docker, Spotify, VS Code, and Cursor

**Requires:** sudo or root privileges.

### `gitWizard.sh`

This script streamlines your Git setup by performing the following:
- Validates Git installation
- Prompts for username and email (with email format validation)
- Creates an ED25519 SSH key with passphrase protection
- Sets proper permissions for SSH keys
- Adds the key to SSH agent
- Configures global Git settings including:
  - Default branch: `main`
  - Pull strategy: merge (no rebase)
  - Auto setup remote on push
  - SSH-based GPG signing
  - Enhanced diff and merge settings

### `repoWizard.sh`

This script automates the creation of new Git repositories with a standardized structure:
- Initializes Git repository in specified directory
- Creates basic files: `.gitignore`, `README.md`, `CONTRIBUTING.md`, `LICENSE`, `.env`, `.env.example`
- Optional devcontainer setup with Docker directories and configuration files
- Optional AI agents support (AGENTS.md, .claude, .github, .cursor directories)
- Creates `.dockerignore` for containerized projects
- Makes initial commit with emoji (🎉 Project created!)
- Creates and switches to `dev` branch

### `aliasWizard.sh`

This script enhances terminal productivity by:
- Detecting shell type (bash or zsh)
- Copying `scripts/.aliases` to `~/.aliases`
- Adding source block to `.bashrc` or `.zshrc` (idempotent)
- Installing helper scripts to `~/bin`: `run`, `mkrun`, `autocommit`, `autopush`
- Adding `~/bin` to PATH

**Supports:** bash and zsh shells.

### `debianWizard.sh`

This script performs Debian-specific system configurations:
- Sets timezone to America/Mexico_City (customizable)
- Removes outdated LibreOffice APT packages
- Configures Vim with line numbers
- Installs Realtek firmware and Blueman for Bluetooth support

**Requires:** sudo or root privileges. Automatically re-executes with sudo if not running as root.
**Recommended for:** Debian 13.

### `z.sh`

This script sets up a modern zsh environment:
- Adds Ghostty terminal configurations (if installed)
- Sets custom dircolors for better visual contrast
- Installs zsh shell
- Installs Oh My Zsh framework
- Installs Powerlevel10k theme
- Configures zsh to use Powerlevel10k

**Note:** Requires MesloLGS NF Regular Nerd Font to be installed and set as terminal font.

## Alias Reference

The `aliasWizard.sh` script copies the alias file from `scripts/.aliases` to `~/.aliases` and configures your shell to source it. The following aliases are included:

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
| | `gitclean` | `git fetch origin --prune` | Remove remote-tracking branches that no longer exist on the remote. |
| **AI Agents** | | | |
| | `cld` | `claude` | Shortcut for Claude AI agent CLI. |
| | `ocd` | `opencode` | Shortcut for OpenCode AI agent CLI. |
| **Miscellaneous** | | | |
| | `h` | `history` | Display command history. |
| | `rootrc` | `code .bashrc --no-sandbox --user-data-dir` | Open .bashrc in VS Code as root (use with caution). |
| | `rootzrc` | `code .zshrc --no-sandbox --user-data-dir` | Open .zshrc in VS Code as root (use with caution). |
| | `rootaliases` | `code .aliases --no-sandbox --user-data-dir` | Open .aliases in VS Code as root (use with caution). |

## Helper Scripts

The `aliasWizard.sh` script installs the following helper scripts to `~/bin` and adds this directory to your PATH:

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
