{
  description = "Home Manager configuration of zhifan";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    antigravity-nix = {
      url = "github:jacopone/antigravity-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nvim-configuration.url = "github:c3n21/nvim-configuration/develop";
    # https://github.com/hyprwm/Hyprland/issues/5891
    # https://github.com/NixOS/nix/issues/6633
    hyprland = {
      submodules = true;
      url = "https://github.com/hyprwm/Hyprland";
      type = "git";
    };

    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:nix-community/disko";
    };

    nixos-hardware = {
      url = "github:NixOS/nixos-hardware/master";
    };

    split-monitor-workspaces = {
      url = "github:Duckonaut/split-monitor-workspaces";
      inputs.hyprland.follows = "hyprland";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    lanzaboote = {
      url = "github:nix-community/lanzaboote";
      # Optional but recommended to limit the size of your system closure.
      inputs.nixpkgs.follows = "nixpkgs";
    };

    niri = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      nixos-hardware,
      lanzaboote,
      niri,
      nixos-wsl,
      disko,
      noctalia,
      nvim-configuration,
      antigravity-nix,
      ...
    }@inputs:
    let
      inherit (self) outputs;
      system = "x86_64-linux";

      # home-manager common configuration
      homeManagerExtraSpecialArgs = { inherit inputs; };
      homeManagerModuleConfiguration = {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.extraSpecialArgs = homeManagerExtraSpecialArgs;
      };

      pkgs = import nixpkgs {
        inherit system;
        overlays = [
          niri.overlays.niri
          noctalia.overlays.default
          nvim-configuration.overlays.${system}.neo
          nvim-configuration.overlays.${system}.note
          nvim-configuration.overlays.${system}.neovim-nightly
          antigravity-nix.overlays.default
        ];
        config.allowUnfree = true;
      };
    in
    {
      nixosModules = [
        niri.nixosModules.niri
      ];

      nixosConfigurations = {
        framework-13-7040-amd = nixpkgs.lib.nixosSystem {
          inherit system pkgs;

          specialArgs = {
            inherit inputs outputs;
          };

          modules = [
            nixos-hardware.nixosModules.framework-13-7040-amd

            disko.nixosModules.disko

            lanzaboote.nixosModules.lanzaboote

            home-manager.nixosModules.home-manager

            homeManagerModuleConfiguration

            {

              # home-manager modules must be put there
              home-manager.users.zhifan.imports = [
              ];
            }

            ./nixos/framework-13-7040-amd/configuration.nix
            # TODO: enable when the config is ready
            # ./nixos/framework-13-7040-amd/disko.nix

            {
              home-manager.users.zhifan = ./home-manager/framework-13-7040-amd.nix;
            }
          ];
        };

        ciel = nixpkgs.lib.nixosSystem {
          inherit system pkgs;

          specialArgs = {
            inherit inputs outputs;
          };

          modules = [
            disko.nixosModules.disko

            # lanzaboote.nixosModules.lanzaboote

            home-manager.nixosModules.home-manager

            homeManagerModuleConfiguration

            # {
            #
            #   # home-manager modules must be put there
            #   home-manager.users.zhifan.imports = [
            #   ];
            # }

            ./nixos/ciel/configuration.nix
            # TODO: enable when the config is ready
            # ./nixos/framework-13-7040-amd/disko.nix

            {
              home-manager.users.zhifan = ./home-manager/ciel.nix;
            }
          ];
        };

        wsl = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./nixos/common/fish.nix
            ./nixos/common/nixpkgs-configuration.nix
            nixos-wsl.nixosModules.default
            home-manager.nixosModules.home-manager
            ./nixos/wsl/configuration.nix
            homeManagerModuleConfiguration
            {
              home-manager.users.zhifan = ./home-manager/home.nix;
              system.stateVersion = "24.05";
              wsl.enable = true;
            }
          ];
        };
      };

      homeConfigurations = {
        linux = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;

          # Specify your home configuration modules here, for example,
          # the path to your home.nix.
          modules = [
            ./home-manager/standalone.nix
            ./home-manager/home.nix
            ./home-manager/linux
            ./home-manager/linux/specialisations.nix
            inputs.niri.homeModules.niri
          ];
          extraSpecialArgs = homeManagerExtraSpecialArgs;
        };
      };
    };
}
