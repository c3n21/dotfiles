{
  description = "Home Manager configuration of zhifan";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nvim-configuration.url = "github:c3n21/nvim-configuration/develop";
    # https://github.com/hyprwm/Hyprland/issues/5891
    # https://github.com/NixOS/nix/issues/6633
    hyprland = {
      submodules = true;
      url = "https://github.com/hyprwm/Hyprland";
      type = "git";
    };
    disko = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:nix-community/disko";
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
        overlays = [ niri.overlays.niri ];
      };
    in
    {
      overlays = [ niri.overlays.niri ];
      nixosModules = [
        niri.nixosModules.niri
      ];

      nixosConfigurations = {
        framework-13-7040-amd = nixpkgs.lib.nixosSystem {
          inherit system;

          specialArgs = {
            inherit inputs outputs;
          };

          modules = [
            nixos-hardware.nixosModules.framework-13-7040-amd
            disko.nixosModules.disko
            ./nixos/common/fish.nix
            ./nixos/common/nixpkgs-configuration.nix
            ./nixos/common/distributed-builds.nix

            ./nixos/framework-13-7040-amd/hardware-configuration.nix
            ./nixos/framework-13-7040-amd/configuration.nix
            # TODO: enable when the config is ready
            # ./nixos/framework-13-7040-amd/disko.nix

            ./nixos/firewall.nix
            ./nixos/desktop.nix
            ./nixos/specialisations.nix
            home-manager.nixosModules.home-manager
            homeManagerModuleConfiguration
            {
              home-manager.users.zhifan = ./home-manager/home.nix;
            }

            {
              home-manager.users.zhifan = ./home-manager/linux/packages-profiles/gaming.nix;
            }

            {

              # home-manager modules must be put there
              home-manager.users.zhifan.imports = [
                inputs.niri.homeModules.niri
              ];
            }

            {
              home-manager.users.zhifan = ./home-manager/linux;
            }

            {
              specialisation.niri.configuration.home-manager.users.zhifan =
                ./home-manager/linux/specialisations/niri.nix;
              specialisation.hyprland.configuration.home-manager.users.zhifan =
                ./home-manager/linux/specialisations/hyprland.nix;
            }

            lanzaboote.nixosModules.lanzaboote
            ./nixos/common/secure-boot.nix
            {
              environment.sessionVariables.NIXOS_OZONE_WL = "1";
            }
            {
              networking = {
                hostName = "zenuko"; # Define your hostname.
              };
            }
            {
              nixpkgs.overlays = [
                niri.overlays.niri
              ];

            }
          ];
        };

        workstation = nixpkgs.lib.nixosSystem {
          inherit system;

          specialArgs = {
            inherit inputs outputs;
          };

          modules = [
            disko.nixosModules.disko
            ./nixos/common/fish.nix
            ./nixos/common/nixpkgs-configuration.nix
            ./nixos/common/distributed-builds.nix

            ./nixos/workstation
            # TODO: enable when the config is ready
            # ./nixos/framework-13-7040-amd/disko.nix

            ./nixos/firewall.nix
            ./nixos/desktop.nix
            ./nixos/specialisations.nix
            home-manager.nixosModules.home-manager
            homeManagerModuleConfiguration
            {
              home-manager.users.zhifan = ./home-manager/home.nix;
            }

            {
              home-manager.users.zhifan = ./home-manager/linux/packages-profiles/gaming.nix;
            }

            {

              # home-manager modules must be put there
              home-manager.users.zhifan.imports = [
                inputs.niri.homeModules.niri
              ];
            }

            {
              home-manager.users.zhifan = ./home-manager/linux;
            }

            {
              specialisation.niri.configuration.home-manager.users.zhifan =
                ./home-manager/linux/specialisations/niri.nix;
              specialisation.hyprland.configuration.home-manager.users.zhifan =
                ./home-manager/linux/specialisations/hyprland.nix;
            }

            {
              environment.sessionVariables.NIXOS_OZONE_WL = "1";
            }

            {
              nixpkgs.overlays = [
                niri.overlays.niri
              ];

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
