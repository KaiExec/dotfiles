{ lib, config, ... }:
{
  system.defaults = {
    dock = {
      autohide = true;
      autohide-delay = 0.0;
      autohide-time-modifier = 0.3;
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
      KeyRepeat = lib.mkDefault 1;
      InitialKeyRepeat = lib.mkDefault 10;
    };
  };
  system.activationScripts.postActivation.text = lib.mkDefault ''
    # Restore power settings to factory defaults
    sudo pmset restoredefaults

    # Re-enable Bluetooth (was disabled by power-save mode)
    BLUEUTIL_ALLOW_ROOT=1 blueutil -p 1 2>/dev/null || true

    # === Mac App Store: install if missing (skip if already installed) ===
    MAS_BIN="/opt/homebrew/bin/mas"
    if [ -x "$MAS_BIN" ]; then
      echo "[mas] Checking installed apps..."
      INSTALLED=$($MAS_BIN list 2>/dev/null | awk '{print $1}')

      install_if_missing() {
        local id=$1 name=$2
        if echo "$INSTALLED" | grep -q "^$id$"; then
          echo "  - $name (already installed)"
        else
          echo "  - $name (installing...)"
          sudo -u ${config.system.primaryUser} env MAS_NO_AUTO_INDEX=1 "$MAS_BIN" install "$id" 2>/dev/null || true
        fi
      }

      install_if_missing 1352778147 "Bitwarden"
      install_if_missing 1085114709 "Parallels Desktop"
      install_if_missing 747648890 "Telegram"
    fi
  '';
}
