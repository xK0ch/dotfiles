#!/usr/bin/env bash
#
# install.sh: interactively install selected dotfile components.
# Safe to re-run, existing files are backed up before being overwritten.

set -euo pipefail

# Always run from the script's own directory, no matter where it was invoked from.
cd "$(dirname "${BASH_SOURCE[0]}")"

# ---------- helpers ----------

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

# ---------- components ----------

install_claude() {
  echo "==> Installing Claude config"
  install_file "claude/CLAUDE.md" "$HOME/.claude/CLAUDE.md"
}

install_arch() {
  echo "==> Running Arch setup"
  bash arch/setup.sh
}

# ---------- selection ----------

echo "Which components do you want to install?"
echo
echo "  1) claude  - Claude Code config (claude/CLAUDE.md)"
echo "  2) arch    - Arch Linux packages & services (arch/setup.sh)"
echo
read -r -p "Select (e.g. '1', '2', '1 2', or 'a' for all): " -a choices

want_claude=false
want_arch=false

if [[ ${#choices[@]} -eq 0 ]]; then
  echo "Nothing selected. Exiting."
  exit 0
fi

for c in "${choices[@]}"; do
  case "${c,,}" in
    1|claude)  want_claude=true ;;
    2|arch)    want_arch=true ;;
    a|all)     want_claude=true; want_arch=true ;;
    *)         echo "  Ignoring unknown selection: $c" ;;
  esac
done

if ! $want_claude && ! $want_arch; then
  echo "Nothing selected. Exiting."
  exit 0
fi

echo
if $want_claude; then install_claude; fi
if $want_arch; then install_arch; fi

echo
echo "Done."
