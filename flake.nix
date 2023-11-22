{
  description = "Home Manager configuration of zhifan";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    hyprland.url = "github:hyprwm/Hyprland";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    home-manager = {
      url = "github:nix-community/home-manager/release-23.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { self
    , nixpkgs
    , home-manager
    , nixpkgs-unstable
    , nixos-hardware
    , ...
    } @ inputs:
    let
      overlays = [
        inputs.neovim-nightly-overlay.overlay
      ];
      inherit (self) outputs;
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      unstable-pkgs = nixpkgs-unstable.legacyPackages.${system};
    in
    {
      overlays = import ./overlays { inherit inputs; };

      nixosConfigurations = {
        nixos = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs outputs;
            inherit unstable-pkgs;
          };
          modules = [
            nixos-hardware.nixosModules.framework-13-7040-amd
            ./nixos/configuration.nix
          ];
        };
      };

      homeConfigurations = {
        "zhifan@nixos" =
          home-manager.lib.homeManagerConfiguration {
            inherit pkgs;

            # Specify your home configuration modules here, for example,
            # the path to your home.nix.
            modules = [
              ./home-manager/home.nix
              ({ config, ... }: {
                nixpkgs.overlays = overlays;
              })
            ];
            extraSpecialArgs = {
              inherit unstable-pkgs;
              inherit inputs;
              inherit outputs;
            };
            # Optionally use extraSpecialArgs
            # to pass through arguments to home.nix
          };
      };
    };
}
