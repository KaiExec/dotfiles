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
  '';
}
