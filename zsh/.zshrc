# Initial for start
#------------------------
eval "$(/opt/homebrew/bin/brew shellenv)"

# Variable
#-----------
setopt AUTO_PUSHD
setopt PUSHD_IGNORE_DUPS
setopt PUSHD_SILENT
bindkey -e

export EDITOR="nvim"

export SSH_AUTH_SOCK=$HOME/Library/Containers/com.bitwarden.desktop/Data/.bitwarden-ssh-agent.sock
export https_proxy=http://127.0.0.1:6152
export http_proxy=http://127.0.0.1:6152
export all_proxy=socks5://127.0.0.1:6153

export ANDROID_HOME=$HOME/Library/Android/sdk
export PATH=$PATH:$ANDROID_HOME/platform-tools

export PATH=$PATH:$HOME/go/bin/

export STARSHIP_CONFIG=~/.config/starship/starship.toml
#------------------------

# Prompt
#------------------------
# setopt PROMPT_SUBST
# autoload -Uz vcs_info
#
# zstyle ':vcs_info:*' enable git
#
# zstyle ':vcs_info:git:*' check-for-changes false
# zstyle ':vcs_info:git:*' get-revision false
#
# zstyle ':vcs_info:git:*' formats ' %F{magenta}[%b]%f'
#
# precmd() {
#     vcs_info
# }
#
# PROMPT='%B%F{cyan}%~%f${vcs_info_msg_0_}%F%f%b '
#------------------------

# Function&Widget
#------------------------
function open_lazygit() {
    lazygit
    zle reset-prompt
}
zle -N open_lazygit_widget open_lazygit
bindkey '^g' open_lazygit_widget

function ra() {
local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
yazi "$@" --cwd-file="$tmp"
IFS= read -r -d '' cwd < "$tmp"
[ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && builtin cd -- "$cwd"
rm -f -- "$tmp"
}
#------------------------

# Alias
#------------------------
alias sz="source $HOME/.zshrc"
alias v="nvim"
#------------------------

# Initial for ui
#------------------------
source <(fzf --zsh)
# source ~/dotfiles/zsh/.config/zsh/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh
# source ~/dotfiles/zsh/.config/zsh/plugins/zsh-autocomplete/zsh-autocomplete.plugin.zsh
eval "$(zoxide init zsh --cmd j)"
autoload -Uz compinit
compinit -C

eval "$(starship init zsh)"
#------------------------

# Plugins settings
#------------------------
# bindkey              '^I' menu-select
# bindkey "$terminfo[kcbt]" menu-select
# zstyle ':autocomplete:*' add-semicolon no
#------------------------

# pnpm
export PNPM_HOME="/Users/eleph/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

# uv
. "$HOME/.local/bin/env"
# uv end
