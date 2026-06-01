# AGENTS.md

## Repo Shape
- Root `*.sh` files are the entrypoints: `softwareWizard.sh`, `gitWizard.sh`, `aliasWizard.sh`, `repoWizard.sh`, `debianWizard.sh`, and `z.sh`.
- Shared code lives in `src/common.sh` and the `src/<wizard>/` folders; scripts source files with repo-relative paths like `./src/common.sh`, so run them from the repository root.
- `repoWizard.sh` is the repo scaffolder. It copies templates from `src/templates/` and can create `.agents/`, `.cursor/`, `.opencode/`, `.claude/`, `.agent/`, and `.github/` support trees depending on the chosen agent target.

## Commands
- Run a wizard directly from the repo root, for example `./softwareWizard.sh` or `./repoWizard.sh`.
- `repoWizard.sh` makes an initial `git commit -m "🎉 Project created!"` and switches to a new `dev` branch.
- `aliasWizard.sh` writes `~/.aliases`, appends shell source blocks to `~/.bashrc` or `~/.zshrc`, and installs helper scripts into `~/bin`.
- `gitWizard.sh`, `softwareWizard.sh`, `debianWizard.sh`, and `z.sh` make system changes and may require `sudo`.

## Repo Conventions
- `src/common.sh` is shared utility code and should not be executed directly.
- `NO_COLOR` disables colored output in shared helpers.
- The repo is Bash-only; there is no package manager or test runner to discover here.
- `src/templates/README.md` is a scaffold template, not the project README.
