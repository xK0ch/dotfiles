#!/usr/bin/env bash

set -euo pipefail

cd "$(dirname "${BASH_SOURCE[0]}")"

step() { echo; echo "==> $*"; }

step "Installing build prerequisites"
# base-devel (compiler, make, makepkg tools) and git are needed to build yay and every AUR package
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
  # KDE text editor with syntax highlighting, tabs and an integrated terminal
  kate
  # KDE file manager
  dolphin
  # Archive manager for zip, tar, 7z and rar, also adds "Extract here" to Dolphin's context menu
  ark
  # Dolphin previews for PDF, PostScript, camera RAW and Blender files
  kdegraphics-thumbnailers
  # HEIC/HEIF support (iPhone photos) for Dolphin previews and Gwenview
  libheif
  # Dolphin previews for gettext translation files (.po)
  kdesdk-thumbnailers
  # Dolphin previews for video files
  ffmpegthumbs
  # Dolphin previews for .ico and .cur files and icons embedded in Windows .exe files
  icoutils
  # Dolphin shows the embedded icon of .AppImage files
  libappimage
  # Dolphin shows the app icon of Android .apk files (AUR)
  kde-thumbnailer-apk
  # Faster and more accurate SVG previews (turn off "SVG Images" under Dolphin > Configure > Previews)
  resvg
  # Document viewer for PDF, EPUB and more
  okular
  # Image viewer
  gwenview
  # Window decoration and application style theme (AUR)
  klassy
  # Icon theme
  papirus-icon-theme
)

PKGS_UTILITY=(
  # Password manager
  bitwarden
  # Shows system information in the terminal
  fastfetch
  # Web browser
  firefox
  # Office suite, "still" is the stable branch with fewer updates
  libreoffice-still
  # FTP and SFTP client
  filezilla
  # Calculator
  kcalc
  # Writes ISO images to USB sticks, e.g. a bootable Arch installer
  isoimagewriter
  # Spell checking dictionaries (German, US English) for KDE apps and LibreOffice
  hunspell-de hunspell-en_us
  # Fast file copying and syncing, locally and over SSH
  rsync
  # KDE tool to create, resize and format partitions
  partitionmanager
  # FAT32 and exFAT support to format and check USB sticks and SD cards, also used by partitionmanager
  dosfstools exfatprogs
)

PKGS_IPHONE=(
  # Talks to an iPhone over USB so Dolphin can open its photos
  usbmuxd
)

PKGS_GAMING=(
  # 32-bit Vulkan driver for AMD GPUs, needed by Steam and Proton; listed before steam so yay does not ask which driver to use
  lib32-vulkan-radeon
  # Game store and launcher
  steam
  # In-game overlay for FPS, temperatures and load (config in config/MangoHud, toggle with Right Shift + F12)
  mangohud
  # Minecraft (AUR)
  minecraft-launcher
  # Voice chat (AUR)
  teamspeak
  # Valve's game compositor for resolution, frame limit and HDR, used in the Steam launch options below
  gamescope
  # AMD GPU control panel for fan curves, clocks and power limit, runs as the lactd service
  lact
)

PKGS_DEV=(
  # Java 25 for the Spring Boot services
  jdk25-openjdk
  # Installs and updates IntelliJ IDEA and other JetBrains IDEs (AUR)
  jetbrains-toolbox
  # Node Version Manager to install and switch Node.js versions for the UI projects
  nvm
  # Containers: engine, "docker compose" and the BuildKit builder used by "docker compose up --build"
  docker docker-compose docker-buildx
  # GitHub on the command line (gh)
  github-cli
  # Claude desktop app (AUR)
  claude-desktop
)

PKGS_NETWORK_DISCOVERY=(
  # Finds printers and scanners on the WLAN automatically and resolves .local hostnames
  avahi nss-mdns
)

PKGS_PRINTER=(
  # Printing system
  cups
  # Canon printer driver, includes the Canon TS5000 (AUR)
  cnijfilter2
  # Lets KDE detect the right driver when adding a printer
  system-config-printer
)

PKGS_SCANNER=(
  # Scanning over WLAN (eSCL / AirScan), the printer's built-in scanner is supported
  sane-airscan
  # KDE scanning app
  skanlite
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
echo "  Dolphin file previews:"
echo "    Menu > Configure Dolphin... > Interface > Previews"
echo "    Tick every file type you want previews for (videos, PDFs, RAW, AppImage, APK, ...)"
echo "    Untick \"SVG Images\" so the faster resvg previewer is used instead"
echo "    Previews must also be switched on per view: Preview button in the toolbar (or View > Show Previews)"
echo
echo "  Printer: KDE Plasma > Printers > Add, pick the auto-discovered Canon TS5000 (no manual IP needed)"
echo
echo "  Scanner: open Skanlite from KDE Plasma"
echo
