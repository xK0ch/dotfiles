# dotfiles

My personal config files, version-controlled. Cloning this repo and running the install script gets a new machine into my preferred state.

## What's in here

| Path in repo | Installed to |
|---|---|
| `claude/CLAUDE.md` | `~/.claude/CLAUDE.md` |

## Install on a new machine

```bash
git clone <repo-url> ~/dotfiles
cd ~/dotfiles
./install.sh
```

The install script:

- Works on Linux, macOS, and Windows (via Git Bash).
- Backs up any existing file before overwriting it (look for `*.backup.YYYYMMDD-HHMMSS` next to the target).
- Is idempotent, safe to re-run anytime.

## Updating a config

1. Edit the file in this repo (e.g. `claude/CLAUDE.md`).
2. Run `./install.sh` to copy it to its live location.
3. Commit and push.

## Adding a new dotfile

1. Drop the file into a new subfolder (e.g. `vim/.vimrc`).
2. Add an `install_file` line at the bottom of `install.sh`.
3. Run `./install.sh` to test, then commit.

For configs whose location differs per OS (like VSCode settings), use the `case "$OS" in ... esac` template that's commented out in `install.sh`.

## Why copy instead of symlink?

Symlinks would let you edit the live file and have changes show up in the repo automatically, but on Windows they require Developer Mode or admin privileges. Copying works the same on all three OSes with zero setup. The downside: after editing in the repo you have to re-run `install.sh`.
