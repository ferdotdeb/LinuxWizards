# LinuxWizards

- Run the `*Wizard.sh` entrypoints from the repo root. They `source ./src/...` with relative paths, so launching them from a subdirectory breaks.
- The top-level scripts are thin wrappers; put shared logic in `src/common.sh` and area-specific logic in `src/<area>/*.sh`.
- These entrypoints are not standalone downloads. They depend on the checked-out `src/` tree.
- `src/templates/` is the source for files `repoWizard.sh` copies into new repos. Edit templates, not generated repos, when changing scaffold content.
- `src/repo/agents.sh` and `src/repo/mdtomdc.sh` generate agent-support folders/symlinks. Keep them in sync with any `.agents/rules` changes.
- `aliasWizard.sh` only supports bash/zsh. It copies `src/scripts/.aliases` to `~/.aliases`, appends source blocks to `~/.bashrc` or `~/.zshrc`, and installs helper scripts from `src/scripts/` into `~/bin`.
- If you add or rename helpers under `src/scripts/`, update `aliasWizard.sh` so the installed set stays in sync.
- `gitWizard.sh` creates an `ed25519` SSH key, starts `ssh-agent`, and writes global Git config, including SSH signing when `~/.ssh/id_ed25519.pub` exists.
- `softwareWizard.sh`, `debianWizard.sh`, and `z.sh` are privileged, networked installers. They modify apt state and user config such as `~/.ssh`, `~/.dircolors`, `~/.config/ghostty/config`, `~/.bashrc`, and `~/.zshrc`.
- `debianWizard.sh` re-execs itself with `sudo` when needed and is intended for Debian 13.
- `z.sh` expects MesloLGS Nerd Font for Powerlevel10k.
- `repoWizard.sh` initializes a new repo from the templates, makes an initial `🎉 Project created!` commit, and switches the new repo to `dev`.
- There is no package manager, formatter, or test runner configured here; for shell edits use `bash -n <file>` and a disposable run of the affected wizard.
