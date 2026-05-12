{ lib, pkgs, config, ... }:
{
  imports = [ ./common.nix ];

  system.defaults = {
    dock = {
      autohide = true;
      autohide-delay = 0.0;
      autohide-time-modifier = 0.3;
      show-recents = false;
      # Only keep study apps in dock
      persistent-apps = lib.mkForce [
        { app = "/Applications/Obsidian.app"; }
        { app = "/Applications/Firefox.app"; }
        { app = "/Applications/Spotify.app"; }
      ];
    };
    # Slower key repeat for typing comfort when not coding
    NSGlobalDomain = {
      KeyRepeat = lib.mkForce 2;
      InitialKeyRepeat = lib.mkForce 15;
    };
  };

  system.activationScripts.postActivation.text = lib.mkForce ''
    echo ""
    echo "========================================"
    echo "  Power Save Mode: ON"
    echo "========================================"
    echo ""

    # === Power Management (pmset) ===
    echo "[pmset] Enabling Low Power Mode..."
    sudo pmset -a lowpowermode 1

    echo "[pmset] Display always on..."
    sudo pmset -a displaysleep 0
    sudo pmset -a sleep 10
    sudo pmset -a disksleep 5
    sudo pmset -a standbydelay 300
    sudo pmset -a hibernatemode 25

    echo "[pmset] Disabling wake-on features..."
    sudo pmset -a powernap 0
    sudo pmset -a proximitywake 0
    sudo pmset -a tcpkeepalive 0
    sudo pmset -a womp 0
    sudo pmset -a networkoversleep 0

    # === Stop Heavy Background Processes ===
    echo ""
    echo "[process] Killing heavy background apps..."

    for app in \
      "Parallels Desktop" \
      "prl_disp_service" \
      "Android Studio" \
      "java" \
      "crossover" \
      "obs" \
      "CleanShot" \
      "Telegram"; do
      if pkill -f "$app" 2>/dev/null; then
        echo "  - killed: $app"
      fi
    done

    # === Disable Bluetooth ===
    echo ""
    if command -v ${pkgs.blueutil}/bin/blueutil &>/dev/null; then
      echo "[bluetooth] Turning off..."
      BLUEUTIL_ALLOW_ROOT=1 ${pkgs.blueutil}/bin/blueutil -p 0
    fi

    # === Stop Spotlight Indexing ===
    echo ""
    echo "[spotlight] Disabling indexing..."
    sudo mdutil -a -i off 2>/dev/null || true

    # === Reduce Display Brightness ===
    echo ""
    echo "[brightness] Setting to 40%..."
    if command -v /usr/local/bin/brightness &>/dev/null; then
      /usr/local/bin/brightness 0.4
    else
      osascript -e 'tell application "System Events" to repeat 20 times; key code 107; end repeat' 2>/dev/null || true
    fi

    # === Wallpaper: solid white ===
    WALLPAPER_FILE="/tmp/wallpaper-powersave.png"
    if [ ! -f "$WALLPAPER_FILE" ]; then
      python3 -c "
import struct, zlib
r, g, b = 255, 255, 255
raw = b'\x00' + bytes([r,g,b])
def c(t,d):
    crc = zlib.crc32(t + d) & 0xffffffff
    return struct.pack('>I',len(d)) + t + d + struct.pack('>I',crc)
ihdr = struct.pack('>IIBBBBB', 1, 1, 8, 2, 0, 0, 0)
open('$WALLPAPER_FILE','wb').write(b'\x89PNG\r\n\x1a\n' + c(b'IHDR',ihdr) + c(b'IDAT',zlib.compress(raw)) + c(b'IEND',bytes()))
"
    fi
    sudo -u ${config.system.primaryUser} osascript -e "
      tell application \"System Events\"
        set desktopCount to count of desktops
        repeat with d from 1 to desktopCount
          tell desktop d
            set picture to \"$WALLPAPER_FILE\"
          end tell
        end repeat
      end tell
    " 2>/dev/null || true

    echo ""
    echo "========================================"
    echo "  Done. Study mode engaged."
    echo "========================================"
  '';

  # Don't touch Mac App Store apps in power-save mode
  homebrew.masApps = lib.mkForce {};
}