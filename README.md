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

- Prompts which components to install. Pick one or several:
  - `claude` deploys the Claude Code config (`claude/CLAUDE.md`).
  - `arch` runs `arch/setup.sh`, which installs all packages and enables services (Arch Linux only).
- Enter numbers or names (e.g. `1`, `2`, `1 2`, `claude arch`), or `a` for all.
- Backs up existing files before overwriting (look for `*.backup.YYYYMMDD-HHMMSS` next to the target).
- Idempotent, safe to re-run anytime.

## Updating a config

1. Edit the file in this repo (e.g. `claude/CLAUDE.md`).
2. Run `./install.sh` to copy it to its live location.
3. Commit and push.

## Adding a new dotfile

1. Drop the file into a subfolder (e.g. `vim/.vimrc`).
2. Add an `install_file` line inside the matching component function in `install.sh` (e.g. `install_claude`), or add a new component function plus an entry in the selection menu.
3. Run `./install.sh` to test, then commit.

## Why copy instead of symlink?

Symlinks would let you edit the live file and have changes show up in the repo automatically, but on Windows they require Developer Mode or admin privileges. Copying works the same on all three OSes with zero setup. The downside: after editing in the repo you have to re-run `install.sh`.
