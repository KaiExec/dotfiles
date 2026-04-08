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
      pkgs.anki-bin
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
      "crossover"
      "cleanshot"
      "obs"
      "obsidian"
      "jordanbaird-ice"
      "android-studio"
      "nikitabobko/tap/aerospace"
      "readest"
      "firefox"
      "font-maple-mono-nf-cn"
    ];

    masApps = {
      "Bitwarden" = 1352778147;
      "Parallels Desktop" = 1085114709;
      "Telegram" = 747648890;
    };
  };
}
