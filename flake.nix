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

    nix-ld-rs.url = "github:nix-community/nix-ld-rs";
    nix-ld-rs.inputs.nixpkgs.follows = "nixpkgs";
    alejandra.url = "github:kamadorueda/alejandra/3.0.0";
    alejandra.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = {
    self,
    alejandra,
    sddm-sugar-catppuccin,
    nixpkgs,
    home-manager,
    nixos-hardware,
    lanzaboote,
    ...
  } @ inputs: let
    overlays = [
      inputs.neovim-nightly-overlay.overlay
    ];
    inherit (self) outputs;
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
    mkNixosConfiguration = {
      system ? "x86_64-linux",
      hostName,
      # username,
      args ? {},
      modules,
    }: let
      specialArgs =
        {
          inherit inputs outputs;
          sugar-catppuccin = sddm-sugar-catppuccin.packages.x86_64-linux.default;
          nix-ld-rs = inputs.nix-ld-rs.packages.${pkgs.system}.default;
        }
        // {inherit hostName;}
        // args;
    in
      nixpkgs.lib.nixosSystem {
        inherit system specialArgs;
        modules =
          [
            ./nixos/configuration.nix
            lanzaboote.nixosModules.lanzaboote
            {
              environment.systemPackages = [alejandra.defaultPackage.${system}];
            }
          ]
          ++ modules;
      };
  in {
    overlays = import ./overlays {inherit inputs;};

    nixosConfigurations = {
      framework-13-7040-amd = mkNixosConfiguration {
        hostName = "zenuko";
        modules = [
          nixos-hardware.nixosModules.framework-13-7040-amd
          ./nixos/framework-13-7040-amd/hardware-configuration.nix
        ];
      };

      hp-elitebook = mkNixosConfiguration {
        hostName = "elitebook";
        modules = [
        ];
      };
    };

    homeConfigurations = {
      zhifan = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        # Specify your home configuration modules here, for example,
        # the path to your home.nix.
        modules = [
          ./home-manager/home.nix
          ({config, ...}: {
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
