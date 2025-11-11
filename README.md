# LinuxWizards

A collection of powerful Bash scripts to automate the setup and configuration of a developer-friendly Linux environment.

## Features

- **Software Wizard:** Installs essential development software, including browsers, editors, and containerization tools.
- **Git Wizard:** Automates Git configuration and SSH key generation for seamless version control.
- **Alias Wizard:** Sets up a comprehensive list of shell aliases to boost productivity in the terminal.

## Prerequisites

- Debian or a Debian-based Linux distribution (e.g., Ubuntu, Linux Mint).
- `sudo` or root privileges.
- An active internet connection.

## Getting Started

1. **Clone the repository:**

    ```bash
    git clone https://github.com/ferdotdeb/LinuxWizards.git
    cd LinuxWizards
    ```

    **1.1. Or download the scripts individually:**

    Use `curl` to download the scripts you need. Note that `common_functions.sh` is required by the other scripts.

    ```bash
    curl -O https://raw.githubusercontent.com/ferdotdeb/LinuxWizards/main/common_functions.sh
    ```

    ```bash
    curl -O https://raw.githubusercontent.com/ferdotdeb/LinuxWizards/main/softwareWizard.sh
    ```

    ```bash
    curl -O https://raw.githubusercontent.com/ferdotdeb/LinuxWizards/main/gitWizard.sh
    ```

    ```bash
    curl -O https://raw.githubusercontent.com/ferdotdeb/LinuxWizards/main/aliasWizard.sh
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

### `softwareWizard.sh`

This script automates the installation of essential software for developers. It handles `apt` packages and third-party applications like Google Chrome, Visual Studio Code, and Docker.

### `gitWizard.sh`

This script streamlines your Git setup. It configures your global Git credentials (username and email) and generates an ED25519 SSH key pair for secure authentication with platforms like GitHub or GitLab.

### `aliasWizard.sh`

This script enhances your terminal productivity by automatically setting up a comprehensive list of useful aliases. It creates or uses the existing `.bash_aliases` file in your home directory and populates it with carefully curated aliases to streamline common development tasks. The script checks for duplicate entries before adding new aliases, ensuring a clean configuration.

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
| | `ch` | `cd ~` | Quick shortcut to navigate to home directory. |
| **APT Shortcuts** | `upg` | `sudo apt update && sudo apt upgrade -y` | Update package lists and upgrade all packages. |
| | `install` | `sudo apt install` | Install a package. |
| | `remove` | `sudo apt remove` | Remove a package. |
| | `autoremove`| `sudo apt autoremove` | Remove automatically installed, unused packages. |
| | `autoclean`| `sudo apt autoclean` | Clean the local repository of retrieved package files. |
| | `aptclean` | `sudo apt clean` | Clear out the local repository of retrieved package files. |
| **System** | `cls` | `clear` | Clear the terminal screen. |
| | `python`| `python3` | Use `python3` as the default Python interpreter. |
| | `ff` | `fastfetch` | Display system information quickly. |
| | `shutdown`| `systemctl poweroff` | Shut down the system. |
| | `reboot`| `systemctl reboot` | Reboot the system. |
| | `srm` | `sudo rm -rf` | Force remove files/directories with elevated privileges. |
| | `rm` | `rm -iv --preserve-root` | Remove files interactively with confirmation and root protection. |
| | `cp` | `cp -iv` | Copy files interactively with confirmation and verbose output. |
| | `mv` | `mv -iv` | Move/rename files interactively with confirmation and verbose output. |
| | `ln` | `ln -iv` | Create links interactively with confirmation and verbose output. |
| | `srczsh` | `source ~/.zshrc` | Reload Zsh configuration file. |
| | `srcbash` | `source ~/.bashrc` | Reload Bash configuration file. |
| | `c` | `code .` | Open current directory in VS Code. |
| **Docker** | `dc` | `docker` | Shortcut for the `docker` command. |
| | `dcu` | `docker compose up -d` | Start services in detached mode with Docker Compose. |
| | `dci` | `docker images` | List all Docker images. |
| | `dcps` | `docker ps` | List all running containers. |
| | `dcrm` | `docker rm` | Remove one or more containers. |
| | `dcrmi` | `docker rmi` | Remove one or more images. |
| | `dockerclean` | `docker system prune -a --volumes` | Remove all unused Docker objects, including volumes. |
| **Kubernetes** | `kc` | `kubectl` | Shortcut for the `kubectl` command. |
| | `mc` | `minikube` | Shortcut for the `minikube` command. |
| | `kcgp` | `kubectl get pods` | Get all pods in the current namespace. |
| | `kcgpw` | `kubectl get pods -o wide` | Get all pods with more details (IP, node). |
| **Git** | `ga` | `git add` | Add file contents to the index. |
| | `gc` | `git commit -m` | Record changes to the repository with a message. |
| | `gp` | `git push` | Update remote refs along with associated objects. |
| | `gpl` | `git pull` | Fetch from and integrate with another repository. |
| | `gsw` | `git switch` | Switch branches. |
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
| | `gitclean` | `git fetch --prune` | Remove remote-tracking branches that no longer exist on the remote. |
| **Miscellaneous**| `h` | `history` | Display command history. |
| | `rootrc` | `code .bashrc --no-sandbox --user-data-dir` | Open .bashrc in VS Code as root (use with caution). |
| | `rootaliases` | `code .bash_aliases --no-sandbox --user-data-dir` | Open .bash_aliases in VS Code as root (use with caution). |

## License

This project is licensed under the terms of the GNU General Public License. See the [LICENSE](LICENSE) file for details.