{
  description = "Eleph's Saber";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs }:
    let
      configuration = { pkgs, ... }: {
        nix.enable = false;
        system.primaryUser = "25air";
        users.users."25air" = {
          name = "25air";
          home = "/Users/25air";
        };
        launchd.daemons."nix-gc" = {
          script = ''
            ${pkgs.nix}/bin/nix-collect-garbage --delete-older-than 7d
          '';
          serviceConfig = {
            StartCalendarInterval = [{ Weekday = 7; Hour = 3; Minute = 0; }];
            StandardOutPath = "/var/log/nix-gc.log";
            StandardErrorPath = "/var/log/nix-gc.error.log";
          };
        };
        # List packages installed in system profile. To search by name, run:
        # $ nix-env -qaP | grep wget

        # Enable alternative shell support in nix-darwin.
        # programs.fish.enable = true;

        # Set Git commit hash for darwin-version.
        system.configurationRevision = self.rev or self.dirtyRev or null;

        # Used for backwards compatibility, please read the changelog before changing.
        # $ darwin-rebuild changelog
        system.stateVersion = 6;

        # The platform the configuration will be used on.
        nixpkgs.hostPlatform = "aarch64-darwin";
      };
    in
    {
      # Build darwin flake using:
      # $ darwin-rebuild build --flake .#Elephs-MacBook-Air
      darwinConfigurations = {
        "25airs-MacBook-Air" = nix-darwin.lib.darwinSystem {
          modules = [
            configuration
            ./apps.nix
            ./system/common.nix
          ];
        };
        "read" = nix-darwin.lib.darwinSystem {
          modules = [
            configuration
            ./apps.nix
            ./system/common.nix
            ./system/read.nix
          ];
        };
        "code" = nix-darwin.lib.darwinSystem {
          modules = [
            configuration
            ./apps.nix
            ./system/common.nix
            ./system/code.nix
          ];
        };
        "private" = nix-darwin.lib.darwinSystem {
          modules = [
            configuration
            ./apps.nix
            ./system/common.nix
            ./system/private.nix
          ];
        };
      };
    };
}
