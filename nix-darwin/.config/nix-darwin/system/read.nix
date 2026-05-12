{
  system.defaults = {
    dock = {
      persistent-apps = [
        {
          app = "/Applications/Readest.app";
        }
        {
          app = "/Applications/Obsidian.app";
        }
        {
          app = "/Applications/Firefox.app";
        }
        {
          app = "/Applications/Reeder.app";
        }
      ];
    };
  };
  system.activationScripts.postActivation.text = ''
  '';
}
