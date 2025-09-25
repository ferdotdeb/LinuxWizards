# LinuxWizards

A collection of powerful Bash scripts to automate the setup and configuration of a developer-friendly Linux environment.

## Features

- **Software Wizard:** Installs essential development software, including browsers, editors, and containerization tools.
- **Git Wizard:** Automates Git configuration and SSH key generation for seamless version control.
- **Alias Wizard:** Sets up a comprehensive list of shell aliases to boost productivity in the terminal.

## Prerequisites

- A Debian-based Linux distribution (e.g., Debian, Ubuntu).
- `sudo` or root privileges.
- An active internet connection.

## Getting Started

1. **Clone the repository:**

    ```bash
    git clone https://github.com/ferdotdeb/LinuxWizards.git
    cd LinuxWizards
    ```

2. **Grant execution permissions:**

    ```bash
    chmod +x *.sh
    ```

3. **Run the desired script:**

    For example, to install the software:

    ```bash
    ./softwareWizard.sh
    ```

## Scripts Breakdown

### `softwareWizard.sh`

This script automates the installation of essential software for developers. It handles `apt` packages and third-party applications like Google Chrome, Visual Studio Code, and Docker.

### `gitWizard.sh`

This script streamlines your Git setup. It configures your global Git credentials (username and email) and generates an ED25519 SSH key pair for secure authentication with platforms like GitHub or GitLab.

### `aliasWizard.sh`

This script enhances your terminal productivity by automatically detecting your shell (`bash` or `zsh`) and adding a curated set of useful aliases to your configuration file (`.bashrc` or `.zshrc`).

### `common_functions.sh`

This is a utility script and should not be executed directly. It provides shared functions for displaying colored status messages (success, error, warning), making the output of the main scripts more readable and user-friendly.

## Alias Reference

The `aliasWizard.sh` script will add the following aliases to your shell configuration:

| Category | Alias | Original Command | Description |
| :--- | :--- | :--- | :--- |
| **Navigation** | `sls` | `ls -lavh` | List files with detailed, human-readable sizes. |
| | `ll` | `ls -la` | List all files (including hidden) in long format. |
| | `la` | `ls -A` | List all files, including hidden, except for `.` and `..`. |
| | `l` | `ls -CF` | List files in columns, marking types (e.g., `/` for directories). |
| | `..` | `cd ..` | Go up one directory. |
| | `...` | `cd ../..` | Go up two directories. |
| | `....` | `cd ../../..` | Go up three directories. |
| **APT Shortcuts** | `upg` | `sudo apt update && sudo apt upgrade -y` | Update package lists and upgrade all packages. |
| | `aptin` | `sudo apt install` | Install a package. |
| | `aptrm` | `sudo apt remove` | Remove a package. |
| | `autorm`| `sudo apt autoremove` | Remove automatically installed, unused packages. |
| | `aptacl`| `sudo apt autoclean` | Clean the local repository of retrieved package files. |
| | `aptcl` | `sudo apt clean` | Clear out the local repository of retrieved package files. |
| **System** | `cls` | `clear` | Clear the terminal screen. |
| | `python`| `python3` | Use `python3` as the default Python interpreter. |
| | `ff` | `fastfetch` | Display system information quickly. |
| | `shutdown`| `systemctl poweroff` | Shut down the system. |
| | `reboot`| `systemctl reboot` | Reboot the system. |
| **Docker** | `dc` | `docker` | Shortcut for the `docker` command. |
| | `dcu` | `docker-compose up -d` | Start services in detached mode with Docker Compose. |
| | `dci` | `docker images` | List all Docker images. |
| | `dcps` | `docker ps` | List all running containers. |
| | `dcrm` | `docker rm` | Remove one or more containers. |
| | `dcrmi` | `docker rmi` | Remove one or more images. |
| **Kubernetes** | `kc` | `kubectl` | Shortcut for the `kubectl` command. |
| | `mc` | `minikube` | Shortcut for the `minikube` command. |
| | `kcgp` | `kubectl get pods` | Get all pods in the current namespace. |
| | `kcgpw` | `kubectl get pods -o wide` | Get all pods with more details (IP, node). |
| **Git** | `gs` | `git status` | Show the working tree status. |
| | `ga` | `git add` | Add file contents to the index. |
| | `gc` | `git commit -m` | Record changes to the repository with a message. |
| | `gp` | `git push` | Update remote refs along with associated objects. |
| | `gpl` | `git pull` | Fetch from and integrate with another repository. |
| | `gsw` | `git switch` | Switch branches. |
| | `glg` | `git log` | Show commit logs. |
| | `gb` | `git branch` | List, create, or delete branches. |
| | `gco` | `git checkout` | Switch branches or restore working tree files. |
| | `gcl` | `git clone` | Clone a repository into a new directory. |
| | `gdf` | `git diff` | Show changes between commits, commit and working tree, etc. |
| | `gst` | `git stash` | Stash the changes in a dirty working directory away. |
| | `gitrepair` | `sudo chown -R "$(whoami)":"$(id -gn)" .git` | Fix ownership issues in the `.git` directory. |
| **Miscellaneous**| `h` | `history` | Display command history. |
| | `rootcode` | `--no-sandbox --user-data-dir` | Flags to run VS Code as root (use with caution). |

## License

This project is licensed under the terms of the MIT license. See the [LICENSE](LICENSE) file for details.
