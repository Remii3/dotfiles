# Homebrew path: macOS Apple Silicon or Linuxbrew
if command -v brew >/dev/null 2>&1; then
  eval "$(brew shellenv)"
fi

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

[[ -f ~/dotfiles/zsh/.config/zsh/custom-web-search.zsh ]] \
&& source ~/dotfiles/zsh/.config/zsh/custom-web-search.zsh

plugins=(git zsh-autosuggestions zsh-syntax-highlighting)

DISABLE_AUTO_TITLE="true"

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

export EDITOR='nvim'

alias n=nvim

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -f ${BREW_PREFIX:-}/share/powerlevel10k/powerlevel10k.zsh-theme ]]; then
  source "${BREW_PREFIX}/share/powerlevel10k/powerlevel10k.zsh-theme"
elif [[ -f ~/.oh-my-zsh/custom/themes/powerlevel10k/powerlevel10k.zsh-theme ]]; then
  source ~/.oh-my-zsh/custom/themes/powerlevel10k/powerlevel10k.zsh-theme
fi

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

if command -v mise >/dev/null 2>&1; then
  eval "$(mise activate zsh)"
fi

# fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# zoxide
eval "$(zoxide init zsh)"
cd() {
  if [[ -z "$1" || -d "$1" ]]; then
    builtin cd "$@"
  else
    z "$@"
  fi
}
# eza/bat minimal aliases
if command -v bat >/dev/null 2>&1; then alias cat="bat"; fi
if command -v eza >/dev/null 2>&1; then
  alias ls="eza --icons"
  alias la="eza -la --icons"
  alias l="eza -l --icons"
  alias lsa="eza -la --icons"
fi
