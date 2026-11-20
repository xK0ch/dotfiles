#!/usr/bin/env bash

set -euo pipefail

cd "$(dirname "${BASH_SOURCE[0]}")"

step() { echo; echo "==> $*"; }

step "Installing build prerequisites"
sudo pacman -S --needed --noconfirm base-devel git

step "Installing yay"
if ! command -v yay &>/dev/null; then
  tmpdir=$(mktemp -d)
  git clone https://aur.archlinux.org/yay.git "$tmpdir/yay"
  (cd "$tmpdir/yay" && makepkg -si --noconfirm)
  rm -rf "$tmpdir"
fi

step "Configuring yay"
yay --answerclean All --answerdiff None --save && sed -i 's/"doubleconfirm": true/"doubleconfirm": false/' ~/.config/yay/config.json

PKGS_UI=(
  kate dolphin ark kdegraphics-thumbnailers libheif
  kdesdk-thumbnailers ffmpegthumbs icoutils libappimage resvg
  okular gwenview klassy papirus-icon-theme
)

PKGS_UTILITY=(
  bitwarden fastfetch firefox libreoffice-still filezilla kcalc
  isoimagewriter hunspell-de hunspell-en_us
  rsync partitionmanager dosfstools exfatprogs
)

PKGS_IPHONE=(
  usbmuxd
)

PKGS_GAMING=(
  lib32-vulkan-radeon steam mangohud minecraft-launcher teamspeak gamescope lact
)

PKGS_DEV=(
  jdk25-openjdk jetbrains-toolbox nvm docker docker-compose docker-buildx github-cli claude-desktop
)

PKGS_NETWORK_DISCOVERY=(
  avahi nss-mdns
)

PKGS_PRINTER=(
  cups cnijfilter2 system-config-printer
)

PKGS_SCANNER=(
  sane-airscan skanlite
)

step "Installing UI packages"
yay -S --needed --noconfirm "${PKGS_UI[@]}"

step "Installing utility packages"
yay -S --needed --noconfirm "${PKGS_UTILITY[@]}"

step "Installing iPhone support"
yay -S --needed --noconfirm "${PKGS_IPHONE[@]}"

step "Installing gaming packages"
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

step "Enabling network discovery for printer and scanner (.local hostnames)"
yay -S --needed --noconfirm "${PKGS_NETWORK_DISCOVERY[@]}"
if ! grep -q '^hosts:.*mdns_minimal' /etc/nsswitch.conf; then
  sudo sed -i '/^hosts:/ s/ resolve / mdns_minimal [NOTFOUND=return] resolve /' /etc/nsswitch.conf
fi
grep '^hosts:' /etc/nsswitch.conf
sudo systemctl enable --now avahi-daemon.service
if sudo firewall-cmd --state &>/dev/null; then
  if ! sudo firewall-cmd --permanent --query-service=mdns &>/dev/null; then
    sudo firewall-cmd --permanent --add-service=mdns
    sudo firewall-cmd --reload
  fi
  echo "firewalld services: $(sudo firewall-cmd --list-services)"
else
  echo "firewalld is not running, skipping mDNS firewall rule."
fi

step "Installing printer support"
yay -S --needed --noconfirm "${PKGS_PRINTER[@]}"
sudo systemctl enable --now cups

step "Installing scanner support"
yay -S --needed --noconfirm "${PKGS_SCANNER[@]}"

step "Installing Toshy (macOS-style keyboard shortcuts)"
sh -c "$(curl -L https://raw.githubusercontent.com/RedBearAK/toshy/main/scripts/bootstrap.sh || wget -O - https://raw.githubusercontent.com/RedBearAK/toshy/main/scripts/bootstrap.sh)"

step "Configuring MangoHud"
mkdir -p "$HOME/.config/MangoHud"
cp "config/MangoHud/MangoHud.conf" "$HOME/.config/MangoHud/MangoHud.conf"
echo "Installed MangoHud config."
echo "Toggle the overlay with Right Shift + F12."

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
echo "  Printer: KDE Plasma > Printers > Add, pick the auto-discovered Canon TS5000 (no manual IP needed)"
echo
echo "  Scanner: open Skanlite from KDE Plasma"
echo
