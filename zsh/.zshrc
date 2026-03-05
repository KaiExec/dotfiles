# Initial for start
#------------------------
eval "$(/opt/homebrew/bin/brew shellenv)"
# fpath+=("${HOMEBREW_PREFIX}/share/zsh/site-functions")

# Variable
#-----------
export EDITOR="nvim"
export HTTP_PROXY=http://127.0.0.1:8899
export HTTPS_PROXY=http://127.0.0.1:8899
export ANDROID_HOME=$HOME/Library/Android/sdk
export PATH=$PATH:$ANDROID_HOME/platform-tools
bindkey -e
setopt AUTO_PUSHD
setopt PUSHD_IGNORE_DUPS
setopt PUSHD_SILENT
#------------------------

# Prompt
#------------------------
setopt PROMPT_SUBST
autoload -Uz vcs_info

zstyle ':vcs_info:*' enable git

zstyle ':vcs_info:git:*' check-for-changes false
zstyle ':vcs_info:git:*' get-revision false

zstyle ':vcs_info:git:*' formats ' %F{magenta}[%b]%f'

precmd() {
    vcs_info
}

PROMPT='%B%F{cyan}%~%f${vcs_info_msg_0_}%F%f%b '
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
alias lab="ssh dev@lab.local"
#------------------------

# Initial for ui
#------------------------
source <(fzf --zsh)
# source ~/dotfiles/zsh/.config/zsh/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh
# source ~/dotfiles/zsh/.config/zsh/plugins/zsh-autocomplete/zsh-autocomplete.plugin.zsh
eval "$(zoxide init zsh --cmd j)"
autoload -Uz compinit
compinit
#------------------------

# Plugins settings
#------------------------
# bindkey              '^I' menu-select
# bindkey "$terminfo[kcbt]" menu-select
# zstyle ':autocomplete:*' add-semicolon no
#------------------------

# Created by `pipx` on 2026-01-07 11:00:21
export PATH="$PATH:/Users/eleph/.local/bin"

# pnpm
export PNPM_HOME="/Users/eleph/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end
