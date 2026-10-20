#!/usr/bin/env bash

set -Eeuo pipefail
IFS=$'\n\t'

repo_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
readonly repo_dir

cleanup_paths=()

cleanup() {
  local path
  for path in "${cleanup_paths[@]}"; do
    [[ ! -e "$path" ]] || rm -rf -- "$path"
  done
}

fail() {
  printf 'bootstrap: %s\n' "$*" >&2
  exit 1
}

on_error() {
  local exit_code=$?
  printf 'bootstrap: failed at line %s (exit %s)\n' "$1" "$exit_code" >&2
  exit "$exit_code"
}

clone_if_missing() {
  local url=$1
  local destination=$2

  if [[ -d "$destination/.git" ]]; then
    return
  fi

  [[ ! -e "$destination" ]] || fail "$destination exists but is not a Git checkout"
  git clone --depth=1 "$url" "$destination"
}

trap cleanup EXIT
trap 'on_error $LINENO' ERR

[[ ${EUID} -ne 0 ]] || fail 'run this script as your normal user, not as root'
[[ -r /etc/os-release ]] || fail 'cannot identify the operating system'

# shellcheck source=/etc/os-release
source /etc/os-release
[[ ${ID:-} == ubuntu ]] || fail 'this bootstrap supports Ubuntu only'
dpkg --compare-versions "${VERSION_ID:-0}" ge 26.04 \
  || fail 'Ubuntu 26.04 or newer is required for the stable Niri/DMS packages'

command -v git >/dev/null 2>&1 || fail 'git is required to clone and run these dotfiles'
[[ -d "$repo_dir/.git" ]] || fail 'run bootstrap.sh from a Git clone of the dotfiles repository'

printf '==> Preparing Ubuntu repositories\n'
sudo -v
sudo apt-get update
sudo apt-get install -y ca-certificates software-properties-common
sudo add-apt-repository -y ppa:avengemedia/danklinux
sudo add-apt-repository -y ppa:avengemedia/dms
sudo add-apt-repository -y ppa:jdxcode/mise
sudo apt-get update

printf '==> Installing system packages\n'
system_packages=(
  bc
  build-essential
  ca-certificates
  curl
  dms
  fontconfig
  fonts-noto-color-emoji
  fuzzel
  gdm3
  git
  gnome-keyring
  kitty
  mise
  neovim
  playerctl
  stow
  tmux
  unzip
  wireplumber
  wl-clipboard
  xdg-desktop-portal-gnome
  xdg-desktop-portal-gtk
  xwayland-satellite
  xz-utils
  zsh
)
sudo apt-get install -y "${system_packages[@]}"

# The Niri package recommends Alacritty; Kitty is installed explicitly instead.
sudo apt-get install -y --no-install-recommends niri

printf '==> Installing shell framework and plugins\n'
clone_if_missing https://github.com/ohmyzsh/ohmyzsh.git "$HOME/.oh-my-zsh"
clone_if_missing https://github.com/romkatv/powerlevel10k.git \
  "$HOME/.oh-my-zsh/custom/themes/powerlevel10k"
clone_if_missing https://github.com/zsh-users/zsh-autosuggestions \
  "$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions"
clone_if_missing https://github.com/zsh-users/zsh-syntax-highlighting.git \
  "$HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting"

font_dir="$HOME/.local/share/fonts/JetBrainsMonoNerdFont"
if ! find "$font_dir" -type f -name '*.ttf' -print -quit 2>/dev/null | grep -q .; then
  printf '==> Installing JetBrainsMono Nerd Font\n'
  font_archive="$(mktemp /tmp/JetBrainsMonoNerdFont.XXXXXX.tar.xz)"
  cleanup_paths+=("$font_archive")
  mkdir -p "$font_dir"
  curl -fL \
    https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.tar.xz \
    -o "$font_archive"
  tar -xJf "$font_archive" -C "$font_dir"
  fc-cache -f "$font_dir"
fi

printf '==> Initializing Git submodules\n'
git -C "$repo_dir" submodule update --init --recursive

# Generate DMS-owned Niri fragments in an isolated home. Only the fragments are
# copied; the main Niri config, Kitty config and monitor choices stay separate.
if [[ ! -f "$HOME/.config/niri/dms/input.kdl" ]]; then
  printf '==> Generating local DMS integration for Niri\n'
  dms_temp="$(mktemp -d /tmp/dms-bootstrap.XXXXXX)"
  cleanup_paths+=("$dms_temp")
  env HOME="$dms_temp" XDG_CONFIG_HOME="$dms_temp/.config" \
    dms setup headless --compositor niri --terminal kitty --no-systemd
  mkdir -p "$HOME/.config/niri/dms"
  cp -a "$dms_temp/.config/niri/dms/." "$HOME/.config/niri/dms/"
fi

printf '==> Linking dotfiles with Stow\n'
mkdir -p "$HOME/.config/private" "$HOME/Pictures/Screenshots"
chmod 700 "$HOME/.config/private"
stow --dir="$repo_dir" --target="$HOME" --no-folding --restow \
  dms kitty mise niri nvim tmux zsh

printf '==> Installing tools managed by mise\n'
mise install --yes

printf '==> Installing Neovim plugins\n'
nvim --headless '+Lazy! sync' +qa

printf '==> Configuring the desktop session\n'
sudo locale-gen en_US.UTF-8
sudo update-locale LANG=en_US.UTF-8 LANGUAGE=en_US:en
sudo chsh -s /usr/bin/zsh "$USER"
sudo systemctl enable gdm3

if systemctl --user daemon-reload; then
  systemctl --user add-wants niri.service dms.service \
    || printf 'bootstrap: warning: run systemctl --user add-wants niri.service dms.service after login\n' >&2
else
  printf 'bootstrap: warning: user systemd is unavailable; connect dms.service after login\n' >&2
fi

printf '==> Validating configuration\n'
niri validate -c "$HOME/.config/niri/config.kdl"
mise doctor

printf '\nBootstrap complete. Log out or reboot, select Niri in GDM, then log in.\n'
printf 'Machine-local secrets and account logins must be restored separately.\n'
