{
  system.defaults = {
    dock = {
      persistent-apps = [
      ];
    };
  };
  system.activationScripts.postActivation.text = ''
    sudo -u 25air /usr/bin/osascript -e 'tell application "System Events" to tell every desktop to set picture to "~/Pictures/wallpapers/01.png"'
  '';
}
