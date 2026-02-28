{
  system.defaults = {
    dock = {
      autohide = true;
      autohide-delay = 0.0;
      autohide-time-modifier = 0.0;
    };

    NSGlobalDomain = {
      KeyRepeat = 1;
      InitialKeyRepeat = 10;
      AppleInterfaceStyle = "Dark";
    };
  };
  system.activationScripts.postActivation.text = ''
    sudo -u eleph /usr/bin/osascript -e 'tell application "System Events" to tell every desktop to set picture to "~/Pictures/wallpapers/13.jpg"'
  '';
}
