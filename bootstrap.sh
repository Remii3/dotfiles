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

  [[ ! -e "$destination" ]] \
    || fail "$destination exists but is not a Git checkout"

  git clone --depth=1 "$url" "$destination"
}

trap cleanup EXIT
trap 'on_error $LINENO' ERR

[[ ${EUID} -ne 0 ]] \
  || fail 'run this script as your normal user, not as root'

[[ -r /etc/os-release ]] \
  || fail 'cannot identify the operating system'

# shellcheck source=/dev/null
source /etc/os-release

[[ ${ID:-} == ubuntu ]] \
  || fail 'this bootstrap supports Ubuntu only'

command -v git >/dev/null 2>&1 \
  || fail 'git is required to run these dotfiles'

[[ -d "$repo_dir/.git" ]] \
  || fail 'run bootstrap.sh from a Git clone'

export PATH="$HOME/.local/bin:$PATH"
# Run against the global dotfiles config, regardless of the caller's directory.
cd "$HOME"

dotfile_packages=(kitty mise nvim tmux zsh)

check_links() {
  stow --dir="$repo_dir" --target="$HOME" --no-folding --restow \
    --simulate "${dotfile_packages[@]}" \
    || fail 'existing files conflict with dotfiles; back them up and merge their settings first'
}

# Catch conflicts before installing anything when Stow is already available.
if command -v stow >/dev/null 2>&1; then
  check_links
fi

system_packages=(
  bc
  build-essential
  ca-certificates
  curl
  fontconfig
  fonts-noto-color-emoji
  git
  kitty
  neovim
  stow
  tmux
  unzip
  wl-clipboard
  xz-utils
  zsh
)

printf '==> Checking development packages\n'
missing_packages=()
for package in "${system_packages[@]}"; do
  if [[ "$(dpkg-query -W -f='${Status}' "$package" 2>/dev/null || true)" != 'install ok installed' ]]; then
    missing_packages+=("$package")
  fi
done
if (( ${#missing_packages[@]} )); then
  sudo -v
  sudo apt-get update
  sudo apt-get install -y "${missing_packages[@]}"
fi

printf '==> Checking dotfile link conflicts\n'

check_links

printf '==> Checking mise\n'
if ! command -v mise >/dev/null 2>&1; then
  mise_installer="$(mktemp /tmp/mise-installer.XXXXXX.sh)"
  cleanup_paths+=("$mise_installer")
  curl -fsSL https://mise.run -o "$mise_installer"
  sh "$mise_installer"
fi
mise --version

printf '==> Installing Oh My Zsh and plugins\n'

clone_if_missing \
  https://github.com/ohmyzsh/ohmyzsh.git \
  "$HOME/.oh-my-zsh"

clone_if_missing \
  https://github.com/romkatv/powerlevel10k.git \
  "$HOME/.oh-my-zsh/custom/themes/powerlevel10k"

clone_if_missing \
  https://github.com/zsh-users/zsh-autosuggestions \
  "$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions"

clone_if_missing \
  https://github.com/zsh-users/zsh-syntax-highlighting.git \
  "$HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting"

printf '==> Installing JetBrainsMono Nerd Font\n'

font_dir="$HOME/.local/share/fonts/JetBrainsMonoNerdFont"

if ! find "$HOME/.local/share/fonts" -type f \
    -iname 'JetBrainsMono*NerdFont*.ttf' \
    -print -quit 2>/dev/null | grep -q .; then

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

printf '==> Linking dotfiles with Stow\n'

mkdir -p \
  "$HOME/.config/private"

chmod 700 "$HOME/.config/private"

stow --dir="$repo_dir" \
  --target="$HOME" \
  --no-folding \
  --restow \
  "${dotfile_packages[@]}"

printf '==> Installing tools managed by mise\n'
mise install --yes

printf '==> Installing Neovim plugins\n'

mise exec -- nvim --headless '+Lazy! restore' +qa

printf '==> Configuring Zsh\n'

if [[ "$(getent passwd "$USER" | cut -d: -f7)" != "/usr/bin/zsh" ]]; then
  sudo chsh -s /usr/bin/zsh "$USER"
fi

printf '==> Validating installed tools and Zsh integration\n'
missing_tools="$(mise ls --current --missing)"
[[ -z "$missing_tools" ]] \
  || fail 'some configured mise tools are still missing'
# Zsh expands this script, not Bash.
# shellcheck disable=SC2016
mise exec -- zsh -lic '
  failed=0
  for tool in mise bat codex deno eza fd fzf gh lazygit node pnpm rg supabase zoxide kitty nvim stow tmux wl-copy; do
    if ! command -v "$tool" >/dev/null 2>&1; then
      print -u2 -- "Missing command: $tool"
      failed=1
    fi
  done
  (( $+functions[z] && $+functions[cd] && $+functions[fzf-file-widget] )) || failed=1
  [[ ${aliases[cat]} == bat && ${aliases[ls]} == "eza --icons" ]] || failed=1
  exit $failed
' || fail 'Zsh tools or integrations failed validation'

printf '\nBootstrap complete!\n'
printf 'Open a new terminal to load the tools and Zsh integrations.\n'
printf 'Machine-local secrets must be restored separately.\n'
