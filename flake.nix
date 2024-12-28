{
  description = "Home Manager configuration of zhifan";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    # https://github.com/hyprwm/Hyprland/issues/5891
    hyprland = {
      submodules = true;
      url = "https://github.com/hyprwm/Hyprland";
      type = "git";
    };
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    split-monitor-workspaces = {
      url = "github:Duckonaut/split-monitor-workspaces";
      inputs.hyprland.follows = "hyprland";
    };
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.4.1";
      # Optional but recommended to limit the size of your system closure.
      inputs.nixpkgs.follows = "nixpkgs";
    };

    alejandra.url = "github:kamadorueda/alejandra/3.0.0";
    alejandra.inputs.nixpkgs.follows = "nixpkgs";

    ghostty = {
      url = "github:ghostty-org/ghostty";
    };
  };

  outputs = {
    self,
    alejandra,
    nixpkgs,
    home-manager,
    nixos-hardware,
    lanzaboote,
    ghostty,
    ...
  } @ inputs: let
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
    nixosConfigurations = {
      framework-13-7040-amd = mkNixosConfiguration {
        hostName = "zenuko";
        modules = [
          nixos-hardware.nixosModules.framework-13-7040-amd
          ./nixos/framework-13-7040-amd/hardware-configuration.nix
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
          ./home-manager/linux
          {
            home.packages = [
              ghostty.packages.x86_64-linux.default
            ];
          }
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
