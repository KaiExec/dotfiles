if status is-interactive
    # Commands to run in interactive sessions can go here
end

# Abbreviation
abbr > ~/.config/fish/conf.d/abbr.fish

zoxide init --cmd cd fish | source

set -x STARSHIP_CONFIG ~/.config/starship/starship.toml
set -gx http_proxy "http://127.0.0.1:8899"
set -gx https_proxy "http://127.0.0.1:8899"

function tweet
    source ~/Workspace/Projects/Tweet/onlyPush/venv/bin/activate.fish
    python ~/Workspace/Projects/Tweet/onlyPush/onlyPush.py
    deactivate
end

function ra
	set tmp (mktemp -t "yazi-cwd.XXXXXX")
	yazi $argv --cwd-file="$tmp"
	if read -z cwd < "$tmp"; and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
		builtin cd -- "$cwd"
	end
	rm -f -- "$tmp"
end

starship init fish | source
