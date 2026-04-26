#!/usr/bin/env bash
#
# install.sh: copies dotfiles into their target locations.
# Safe to re-run, existing files are backed up before being overwritten.
#
# Works on Linux, macOS, and Windows (via Git Bash).

set -euo pipefail

# Always run from the script's own directory, no matter where it was invoked from.
cd "$(dirname "${BASH_SOURCE[0]}")"

# ---------- helpers ----------

detect_os() {
  case "$OSTYPE" in
    linux*)             echo "linux"   ;;
    darwin*)            echo "macos"   ;;
    msys*|cygwin*|win*) echo "windows" ;;
    *)                  echo "unknown" ;;
  esac
}

install_file() {
  local src="$1"
  local dest="$2"

  if [[ ! -f "$src" ]]; then
    echo "  SKIP (source missing): $src"
    return
  fi

  mkdir -p "$(dirname "$dest")"

  if [[ -f "$dest" ]]; then
    local backup
    backup="${dest}.backup.$(date +%Y%m%d-%H%M%S)"
    cp "$dest" "$backup"
    echo "  backed up existing  $dest"
    echo "                  ->  $backup"
  fi

  cp "$src" "$dest"
  echo "  installed           $src"
  echo "                  ->  $dest"
}

# ---------- main ----------

OS=$(detect_os)
echo "Installing dotfiles (detected OS: $OS)"
echo

# Files that live at the same path on every OS:
install_file "claude/CLAUDE.md" "$HOME/.claude/CLAUDE.md"

# When you add OS-specific files later, branch like this:
#
# case "$OS" in
#   linux)
#     install_file "vscode/settings.json" "$HOME/.config/Code/User/settings.json"
#     ;;
#   macos)
#     install_file "vscode/settings.json" "$HOME/Library/Application Support/Code/User/settings.json"
#     ;;
#   windows)
#     install_file "vscode/settings.json" "$APPDATA/Code/User/settings.json"
#     ;;
# esac

echo
echo "Done."
