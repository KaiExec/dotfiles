{ pkgs, ... }:
{
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages =
    [
      pkgs.nix
      pkgs.neovim
      pkgs.mas
      pkgs.bat
      pkgs.ffmpeg
      pkgs.fzf
      pkgs.docker
      pkgs.lazygit
      pkgs.stow
      pkgs.nodejs_25
      pkgs.pipx
      pkgs.python311
      pkgs.stow
      pkgs.tmux
      pkgs.yazi
      pkgs.zoxide
      pkgs.aerospace
      pkgs.telegram-desktop
      pkgs.maccy
      pkgs.obsidian
      pkgs.raycast
      pkgs.wechat
      pkgs.feishin
      pkgs.maple-mono.NF
    ];
  homebrew = {
    enable = true;

    onActivation = {
      autoUpdate = true;
      upgrade = true;
      # cleanup = "zap";
    };
    taps = [
      "nikitabobko/tap"
    ];
    brews = [
      "mole"
      "rust"
    ];
    casks = [
      "mumuplayer"
      "squirrel-app"
      "ghostty"
      "karabiner-elements"
      "crossover"
      "cleanshot"
    ];

    masApps = {
      "Bitwarden" = 1352778147;
      "Parallels Desktop" = 1085114709;
      "Reeder" = 1529448980;
      "TickTick" = 966085870;
      "Vimari" = 1480933944;
      "Wipr" = 1662217862;
      "xCal" = 6745540489;
    };
  };
}
