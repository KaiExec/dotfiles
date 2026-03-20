{ pkgs, ... }:
{
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages =
    [
      pkgs.nix
      pkgs.neovim
      pkgs.bat
      pkgs.ffmpeg
      pkgs.fzf
      pkgs.lazygit
      pkgs.stow
      pkgs.nodejs_25
      pkgs.pipx
      pkgs.python311
      pkgs.stow
      pkgs.tmux
      pkgs.yazi
      pkgs.zoxide
      pkgs.feishin
      pkgs.ripgrep
    ];
  homebrew = {
    enable = true;

    onActivation = {
      autoUpdate = true;
      upgrade = true;
      cleanup = "zap";
    };
    taps = [
      "nikitabobko/tap"
    ];
    brews = [
      "mole"
      "pnpm"
      "mpv"
      "yt-dlp"
      "mas"
      "golang"
      "starship"
      "ktlint"
      "kotlin"
      "gradle"
    ];
    casks = [
      "keka"
      "raycast"
      "squirrel-app"
      "ghostty"
      "karabiner-elements"
      "crossover"
      "cleanshot"
      "tencent-meeting"
      "obs"
      "obsidian"
      "element"
      "blender"
      "jordanbaird-ice"
      "android-studio"
      "nikitabobko/tap/aerospace"
      "google-chrome"
      "readest"
      "firefox"
      "font-maple-mono-nf-cn"
    ];

    masApps = {
      "Bitwarden" = 1352778147;
      "Parallels Desktop" = 1085114709;
      "xCal" = 6745540489;
      "Wechat" = 836500024;
      "Telegram" = 747648890;
    };
  };
}
