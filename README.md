# dotfiles

My personal config files, version-controlled. Clone this repo and run `install.sh` to get a new machine into my preferred state.

## What's in here

| Path in repo | Purpose |
|---|---|
| `claude/CLAUDE.md` | Claude Code preferences, installed to `~/.claude/CLAUDE.md` |
| `arch/setup.sh` | Arch Linux package installation and system setup |
| `arch/config/MangoHud/MangoHud.conf` | MangoHud overlay config, installed to `~/.config/MangoHud/` |

## Install on a new machine

```bash
git clone https://github.com/xK0ch/dotfiles ~/dotfiles
cd ~/dotfiles
./install.sh
```

`install.sh` is always the entry point:

- Deploys all dotfiles to their target locations (Linux, macOS, Windows via Git Bash).
- On Arch Linux: also prompts whether to run `arch/setup.sh`, which installs all packages and enables services.
- Backs up existing files before overwriting (look for `*.backup.YYYYMMDD-HHMMSS` next to the target).
- Idempotent, safe to re-run anytime.

## Updating a config

1. Edit the file in this repo (e.g. `claude/CLAUDE.md`).
2. Run `./install.sh` to copy it to its live location.
3. Commit and push.

## Adding a new dotfile

1. Drop the file into a subfolder (e.g. `vim/.vimrc`).
2. Add an `install_file` line at the bottom of `install.sh`.
3. Run `./install.sh` to test, then commit.

For configs whose location differs per OS (like VSCode settings), use the `case "$OS" in ... esac` template that's commented out in `install.sh`.

## Why copy instead of symlink?

Symlinks would let you edit the live file and have changes show up in the repo automatically, but on Windows they require Developer Mode or admin privileges. Copying works the same on all three OSes with zero setup. The downside: after editing in the repo you have to re-run `install.sh`.
