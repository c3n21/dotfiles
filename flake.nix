{
  description = "Home Manager configuration of zhifan";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    mynixpkgs.url = "github:c3n21/nixpkgs/feature/sonarlint-nvim";
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
      url = "github:nix-community/lanzaboote";
      # Optional but recommended to limit the size of your system closure.
      inputs.nixpkgs.follows = "nixpkgs";
    };

    alejandra.url = "github:kamadorueda/alejandra/3.0.0";
    alejandra.inputs.nixpkgs.follows = "nixpkgs";

    niri = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";
  };

  outputs = {
    self,
    alejandra,
    nixpkgs,
    home-manager,
    nixos-hardware,
    lanzaboote,
    niri,
    nixos-wsl,
    ...
  } @ inputs: let
    inherit (self) outputs;
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
  in {
    overlays = [niri.overlays.niri];
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
          ./nixos/framework-13-7040-amd/hardware-configuration.nix
          ./nixos/framework-13-7040-amd/configuration.nix
          ./nixos/desktop.nix
          ./nixos/specialisations.nix
          lanzaboote.nixosModules.lanzaboote
          {
            environment.systemPackages = [alejandra.defaultPackage.${system}];
            environment.sessionVariables.NIXOS_OZONE_WL = "1";
          }
          {
            networking = {
              hostName = "zenuko"; # Define your hostname.
            };
          }
        ];
      };

      wsl = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          nixos-wsl.nixosModules.default
          home-manager.nixosModules.home-manager
          ./nixos/wsl/configuration.nix
          {
            environment.systemPackages = [alejandra.defaultPackage.${system}];
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.zhifan = import ./home-manager/home.nix {inherit pkgs inputs;};
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
          ./home-manager/home.nix
          ./home-manager/linux
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
        buildInputs = [pkgs.nodejs];
      };
    };
  };
}
