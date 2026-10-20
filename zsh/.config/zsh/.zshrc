# Powerlevel10k instant prompt must stay near the top of this file.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# User-local commands.
export PATH="$HOME/.local/bin:$PATH"

# Activate mise after every other PATH modification so its tools take priority.
if command -v mise >/dev/null 2>&1; then
  if [[ -n "${MISE_SHELL:-}" ]]; then
    eval "$(mise deactivate)"
  fi
  eval "$(mise activate zsh)"
fi

export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"
plugins=(git zsh-autosuggestions zsh-syntax-highlighting)
DISABLE_AUTO_TITLE="true"

[[ -r "$ZDOTDIR/custom-web-search.zsh" ]] && source "$ZDOTDIR/custom-web-search.zsh"
[[ -r "$ZSH/oh-my-zsh.sh" ]] && source "$ZSH/oh-my-zsh.sh"

export EDITOR="nvim"

# Machine-local secrets deliberately stay outside the dotfiles repository.
[[ -r "$HOME/.config/private/zsh-secrets.zsh" ]] && source "$HOME/.config/private/zsh-secrets.zsh"

alias n="nvim"

if command -v fzf >/dev/null 2>&1; then
  source <(fzf --zsh)
fi

if command -v zoxide >/dev/null 2>&1; then
  eval "$(zoxide init zsh)"
  cd() {
    if [[ -z "$1" || -d "$1" ]]; then
      builtin cd "$@"
    else
      z "$@"
    fi
  }
fi

if command -v bat >/dev/null 2>&1; then
  alias cat="bat"
fi

if command -v eza >/dev/null 2>&1; then
  alias ls="eza --icons"
  alias la="eza -la --icons"
  alias l="eza -l --icons"
  alias lsa="eza -la --icons"
fi

# Load the prompt configuration once, from the XDG Zsh directory.
[[ -r "$ZDOTDIR/.p10k.zsh" ]] && source "$ZDOTDIR/.p10k.zsh"
