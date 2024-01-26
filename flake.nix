{
  description = "Home Manager configuration of zhifan";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    hyprland.url = "github:hyprwm/Hyprland";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    sddm-sugar-catppuccin.url = "github:TiagoDamascena/sddm-sugar-catppuccin";
    split-monitor-workspaces = {
      url = "github:Duckonaut/split-monitor-workspaces";
      inputs.hyprland.follows = "hyprland";
    };
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.3.0";
      # Optional but recommended to limit the size of your system closure.
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { self
    , sddm-sugar-catppuccin
    , nixpkgs
    , home-manager
    , nixos-hardware
    , lanzaboote
    , ...
    } @ inputs:
    let
      overlays = [
        inputs.neovim-nightly-overlay.overlay
      ];
      inherit (self) outputs;
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      overlays = import ./overlays { inherit inputs; };

      nixosConfigurations = {
        nixos = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs outputs;
            sugar-catppuccin = sddm-sugar-catppuccin.packages.x86_64-linux.default;
          };
          modules = [
            nixos-hardware.nixosModules.framework-13-7040-amd
            ./nixos/configuration.nix
            # This is not a complete NixOS configuration and you need to reference
            # your normal configuration here.

            lanzaboote.nixosModules.lanzaboote
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
              inherit inputs;
              inherit outputs;
            };
            # Optionally use extraSpecialArgs
            # to pass through arguments to home.nix
          };
      };
    };
}
