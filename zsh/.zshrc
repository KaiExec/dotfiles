[ -f "${XDG_DATA_HOME:-$HOME/.local/share}/zap/zap.zsh" ] && source "${XDG_DATA_HOME:-$HOME/.local/share}/zap/zap.zsh"

# Initial for start
#------------------------
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

PROMPT='%B%F{cyan}%~%f${vcs_info_msg_0_} %F{green}󱈘%f%b '
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

plug "zsh-users/zsh-syntax-highlighting"
plug "marlonrichert/zsh-autocomplete"
eval "$(zoxide init zsh --cmd j)"
#------------------------

