if status is-interactive
    # Commands to run in interactive sessions can go here
    set -gx all_proxy http://127.0.0.1:8899
    for file in $__fish_config_dir/custom/**/*.fish
        source $file
    end

    set -x STARSHIP_CONFIG ~/.config/starship/starship.toml
    starship init fish | source
    zoxide init fish --cmd cd | source
end


function fish_greeting
    echo "Today is $(set_color --bold yellow)$(date +"%y-%m/%d")"
    echo "$(set_color --bold magenta)EXIST FOR YOU💜"
end

