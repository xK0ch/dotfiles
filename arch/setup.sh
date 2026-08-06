#!/usr/bin/env bash
# Arch Linux post-install setup.
# Run once after a fresh Arch install with KDE Plasma.

set -euo pipefail

cd "$(dirname "${BASH_SOURCE[0]}")"

step() { echo; echo "==> $*"; }

# ---------- prerequisites ----------

step "Installing build prerequisites"
# Needed to clone the AUR repo and compile yay with makepkg.
sudo pacman -S --needed --noconfirm base-devel git

# ---------- yay ----------

step "Installing yay"
if ! command -v yay &>/dev/null; then
  tmpdir=$(mktemp -d)
  git clone https://aur.archlinux.org/yay.git "$tmpdir/yay"
  (cd "$tmpdir/yay" && makepkg -si --noconfirm)
  rm -rf "$tmpdir"
fi

step "Configuring pacman and yay"
sudo sed -i 's/^#Color/Color/' /etc/pacman.conf
yay --save --answerclean All --answerdiff None --nodoubleconfirm

# ---------- packages ----------

PKGS_UI=(
  klassy papirus-icon-theme kdegraphics-thumbnailers kimageformats
  qt6-imageformats kdesdk-thumbnailers ffmpegthumbs taglib
  kde-thumbnailer-apk icoutils libappimage gwenview libheif
)

PKGS_UTILITY=(
  bitwarden fastfetch firefox libreoffice-still filezilla kcalc
  isoimagewriter okular firewalld hunspell hunspell-de hunspell-en_us
  rsync partitionmanager dosfstools
)

PKGS_IPHONE=(
  libimobiledevice usbmuxd
)

PKGS_GAMING=(
  mangohud minecraft-launcher teamspeak gamescope lact lib32-vulkan-radeon
)

PKGS_DEV=(
  jdk21-openjdk jetbrains-toolbox nvm docker docker-compose github-cli
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
sudo systemctl enable --now firewalld.service

step "Installing iPhone support"
yay -S --needed --noconfirm "${PKGS_IPHONE[@]}"

step "Installing gaming packages"
# Steam is installed separately (interactive) to review EULA
yay -S --needed steam
yay -S --needed --noconfirm "${PKGS_GAMING[@]}"
echo
echo "  Steam manual steps:"
echo "    Settings > Interface > Run at startup, launch args: -silent %U"
echo "    Game launch args for Gamescope:"
echo "      gamescope -W 2560 -H 1600 -r 75 --framerate-limit 75 --mangoapp --adaptive-sync --immediate-flips --hdr-enabled --hdr-debug-force-support --force-grab-cursor -- %command%"

step "Installing development tools"
yay -S --needed --noconfirm "${PKGS_DEV[@]}"
if ! grep -q 'init-nvm.sh' "$HOME/.bashrc"; then
  echo 'source /usr/share/nvm/init-nvm.sh' >> "$HOME/.bashrc"
fi
sudo usermod -aG docker "$USER"
sudo systemctl enable --now docker.service

step "Installing printer support"
yay -S --needed --noconfirm "${PKGS_PRINTER[@]}"
sudo systemctl enable --now cups
echo "  Manual: KDE Plasma > Printers > Add"

step "Installing scanner support"
yay -S --needed --noconfirm "${PKGS_SCANNER[@]}"
echo "  Manual: open Skanlite from KDE Plasma"

# ---------- Toshy ----------

step "Installing Toshy (macOS-style keyboard shortcuts)"
# https://github.com/RedBearAK/toshy
tmpdir=$(mktemp -d)
git clone https://github.com/RedBearAK/toshy.git "$tmpdir/toshy"
(cd "$tmpdir/toshy" && python3 ./setup_toshy.py install)
rm -rf "$tmpdir"

# ---------- MangoHud ----------

step "Configuring MangoHud"
# Toggle overlay: Right Shift + F12
mkdir -p "$HOME/.config/MangoHud"
cp "config/MangoHud/MangoHud.conf" "$HOME/.config/MangoHud/MangoHud.conf"
echo "  Installed MangoHud config."

echo
echo "Done."
echo "Log out and back in for the docker group membership to take effect."
