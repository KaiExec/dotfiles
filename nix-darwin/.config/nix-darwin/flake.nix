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
system.primaryUser = "eleph";
users.users."eleph" = {
    name = "eleph";
    home = "/Users/eleph";
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
    darwinConfigurations."Elephs-MacBook-Air" = nix-darwin.lib.darwinSystem {
      modules = [ configuration
      ./apps.nix
      ./system.nix
      ];
    };
  };
}
