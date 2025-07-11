{
  description = "Home Manager configuration of zhifan";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    edge.url = "github:nixos/nixpkgs/47dec1cd02e559655a90d3d2748aa56e04459a86";
    nvim-configuration.url = "github:c3n21/nvim-configuration/develop";
    # https://github.com/hyprwm/Hyprland/issues/5891
    # https://github.com/NixOS/nix/issues/6633
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
      ...
    }@inputs:
    let
      inherit (self) outputs;
      system = "x86_64-linux";

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
            ./nixos/common/fish.nix
            ./nixos/common/distributed-builds.nix
            ./nixos/framework-13-7040-amd/hardware-configuration.nix
            ./nixos/framework-13-7040-amd/configuration.nix
            ./nixos/firewall.nix
            ./nixos/desktop.nix
            ./nixos/specialisations.nix
            lanzaboote.nixosModules.lanzaboote
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

        wsl = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./nixos/common/fish.nix
            nixos-wsl.nixosModules.default
            home-manager.nixosModules.home-manager
            ./nixos/wsl/configuration.nix
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.zhifan = import ./home-manager/home.nix { inherit pkgs inputs; };
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
          extraSpecialArgs = {
            inherit inputs;
            inherit outputs;
          };
          # Optionally use extraSpecialArgs
          # to pass through arguments to home.nix
        };

        wsl = {
          inherit pkgs;

          # Specify your home configuration modules here, for example,
          # the path to your home.nix.
          modules = [
            ./home-manager/home.nix
          ];
          extraSpecialArgs = {
            inherit inputs;
            inherit outputs;
          };
          # Optionally use extraSpecialArgs
          # to pass through arguments to home.nix
        };
      };
      devShells = {
        x86_64-linux.nodejs = pkgs.mkShell {
          buildInputs = [ pkgs.nodejs ];
        };
      };
    };
}
