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
