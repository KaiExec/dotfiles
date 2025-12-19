function wall
    osascript -e "tell application \"System Events\" to tell every desktop to set picture to \"$argv\""
end
