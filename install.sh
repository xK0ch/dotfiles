#!/usr/bin/env bash

set -euo pipefail

cd "$(dirname "${BASH_SOURCE[0]}")"

to_lowercase() {
  printf '%s' "$1" | tr '[:upper:]' '[:lower:]'
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

install_claude() {
  echo "==> Installing Claude config"
  install_file "claude/CLAUDE.md" "$HOME/.claude/CLAUDE.md"
  install_file "claude/settings.json" "$HOME/.claude/settings.json"
  install_file "claude/skills/humanizer/SKILL.md" "$HOME/.claude/skills/humanizer/SKILL.md"
}

install_arch() {
  echo "==> Running Arch setup"
  bash arch/setup.sh
}

echo "Which components do you want to install?"
echo
echo "  1) claude  - Claude Code config (claude/CLAUDE.md, claude/settings.json, claude/skills/)"
echo "  2) arch    - Arch Linux packages & services (arch/setup.sh)"
echo
read -r -p "Select (e.g. '1', '2', '1 2', or 'a' for all): " -a choices

want_claude=false
want_arch=false

if [[ -z "${choices[*]:-}" ]]; then
  echo "Nothing selected. Exiting."
  exit 0
fi

for choice in "${choices[@]}"; do
  case "$(to_lowercase "$choice")" in
    1|claude)  want_claude=true ;;
    2|arch)    want_arch=true ;;
    a|all)     want_claude=true; want_arch=true ;;
    *)         echo "  Ignoring unknown selection: $choice" ;;
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
