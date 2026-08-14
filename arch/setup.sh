#!/usr/bin/env bash

set -euo pipefail

cd "$(dirname "${BASH_SOURCE[0]}")"

step() { echo; echo "==> $*"; }

# ---------- prerequisites ----------

step "Installing build prerequisites"
sudo pacman -S --needed --noconfirm base-devel git

# ---------- yay ----------

step "Installing yay"
if ! command -v yay &>/dev/null; then
  tmpdir=$(mktemp -d)
  git clone https://aur.archlinux.org/yay.git "$tmpdir/yay"
  (cd "$tmpdir/yay" && makepkg -si --noconfirm)
  rm -rf "$tmpdir"
fi

step "Configuring yay"
yay --answerclean All --answerdiff None --save && sed -i 's/"doubleconfirm": true/"doubleconfirm": false/' ~/.config/yay/config.json

# ---------- packages ----------

PKGS_UI=(
  kate dolphin ark kdegraphics-thumbnailers kimageformats libheif qt6-imageformats
  kdesdk-thumbnailers ffmpegthumbs taglib icoutils libappimage kio-extras resvg
  okular gwenview klassy papirus-icon-theme
)

PKGS_UTILITY=(
  bitwarden fastfetch firefox libreoffice-still filezilla kcalc
  isoimagewriter hunspell hunspell-de hunspell-en_us
  rsync partitionmanager dosfstools exfatprogs
)

PKGS_IPHONE=(
  libimobiledevice usbmuxd
)

PKGS_GAMING=(
  mangohud minecraft-launcher teamspeak gamescope lact lib32-vulkan-radeon
)

PKGS_DEV=(
  jdk25-openjdk jetbrains-toolbox nvm docker docker-compose github-cli claude-desktop
)

PKGS_PRINTER=(
  cups cups-filters cnijfilter2 system-config-printer
)

PKGS_SCANNER=(
  sane sane-airscan simple-scan skanlite
)

step "Installing UI packages"
yay -S --needed --noconfirm "${PKGS_UI[@]}"

step "Installing utility packages"
yay -S --needed --noconfirm "${PKGS_UTILITY[@]}"

step "Installing iPhone support"
yay -S --needed --noconfirm "${PKGS_IPHONE[@]}"

step "Installing gaming packages"
yay -S --needed steam
yay -S --needed --noconfirm "${PKGS_GAMING[@]}"
sudo systemctl enable --now lactd

step "Installing development tools"
yay -S --needed --noconfirm "${PKGS_DEV[@]}"
if ! grep -q 'init-nvm.sh' "$HOME/.bashrc"; then
  echo 'source /usr/share/nvm/init-nvm.sh' >> "$HOME/.bashrc"
fi
sudo usermod -aG docker "$USER"
sudo systemctl enable --now docker.service

step "Configuring global git identity"
git config --global user.name "Fynn Koch"
git config --global user.email "mail@fynn-koch.de"

step "Installing printer support"
yay -S --needed --noconfirm "${PKGS_PRINTER[@]}"
sudo systemctl enable --now cups

step "Installing scanner support"
yay -S --needed --noconfirm "${PKGS_SCANNER[@]}"

# ---------- Toshy ----------

step "Installing Toshy (macOS-style keyboard shortcuts)"
sh -c "$(curl -L https://raw.githubusercontent.com/RedBearAK/toshy/main/scripts/bootstrap.sh || wget -O - https://raw.githubusercontent.com/RedBearAK/toshy/main/scripts/bootstrap.sh)"

# ---------- MangoHud ----------

step "Configuring MangoHud"
# Toggle overlay: Right Shift + F12
mkdir -p "$HOME/.config/MangoHud"
cp "config/MangoHud/MangoHud.conf" "$HOME/.config/MangoHud/MangoHud.conf"
echo "Installed MangoHud config."

# ---------- manual steps ----------

echo
echo "Done."

step "Manual steps remaining"
echo
echo "  Log out and back in for the docker group membership to take effect."
echo
echo "  Steam:"
echo "    Settings > Interface > Run at startup, launch args: -silent %U"
echo "    Game launch args for Gamescope:"
echo "      gamescope -W 2560 -H 1600 -r 75 --framerate-limit 75 --mangoapp --adaptive-sync --immediate-flips --hdr-enabled --hdr-debug-force-support --force-grab-cursor -- %command%"
echo
echo "  Printer: KDE Plasma > Printers > Add"
echo
echo "  Scanner: open Skanlite from KDE Plasma"
echo
