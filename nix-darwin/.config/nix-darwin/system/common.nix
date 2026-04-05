{ lib, ... }:
{
  system.defaults = {
    dock = {
      autohide = true;
      autohide-delay = 0.0;
      autohide-time-modifier = 0.0;
      show-recents = false;
      persistent-apps = lib.mkDefault [
        {
          app = "/Applications/Ghostty.app";
        }
        {
          app = "/Applications/Firefox.app";
        }
        {

          app = "/Applications/Reeder.app";
        }
        {
          app = "/Applications/Readest.app";
        }
        {
          app = "/Applications/Keka.app";
        }
      ];
    };

    NSGlobalDomain = {
      KeyRepeat = 1;
      InitialKeyRepeat = 10;
    };
  };
  system.activationScripts.postActivation.text = lib.mkDefault ''
    sudo -u 25air /usr/bin/osascript -e 'tell application "System Events" to tell every desktop to set picture to "~/Pictures/wallpapers/02.png"'
    sudo pmset restoredefaults
  '';
}
