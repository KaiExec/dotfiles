{ pkgs, ... }:
{
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages =
    [
      pkgs.nix
      pkgs.neovim
      pkgs.pnpm
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
      pkgs.anki-bin
      pkgs.blueutil
    ];
  homebrew = {
    enable = true;

    onActivation = {
      autoUpdate = false;
      upgrade = false;
      cleanup = "zap";
    };
    taps = [
      "nikitabobko/tap"
    ];
    brews = [
      "mole"
      "mpv"
      "yt-dlp"
      "mas"
      "golang"
      "starship"
      "ktlint"
      "kotlin"
      "gradle"
      "rclone"
      "spicetify-cli"
      "jq"
      "just"
      "bookokrat"
      "eza"
    ];
    casks = [
      "keka"
      "raycast"
      "squirrel-app"
      "ghostty"
      "karabiner-elements"
      "macfuse"
      "crossover"
      "cleanshot"
      "obs"
      "spotify"
      "obsidian"
      "jordanbaird-ice"
      "android-studio"
      "nikitabobko/tap/aerospace"
      "tencent-meeting"
      "readest"
      "firefox"
      "font-maple-mono"
    ];

    masApps = { };
  };
}
