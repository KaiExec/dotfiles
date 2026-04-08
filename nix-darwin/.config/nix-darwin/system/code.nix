{
  system.defaults = {
    dock = {
      persistent-apps = [
        {
          app = "/Applications/Ghostty.app";
        }
        {
          app = "/Applications/Firefox.app";
        }
        {
          app = "/Applications/Keka.app";
        }
        {
          app = "/Applications/Surge.app";
        }
      ];
    };
  };
  system.activationScripts.postActivation.text = ''
    sudo -u 25air /usr/bin/osascript -e 'tell application "System Events" to tell every desktop to set picture to "~/Pictures/wallpapers/01.png"'
  '';
}
