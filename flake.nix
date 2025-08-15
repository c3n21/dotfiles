{
  description = "Home Manager configuration of zhifan";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    microvm = {
      url = "github:microvm-nix/microvm.nix";
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
      tapInterface = null;

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

        # librewolf-vm = ./nixos/microvm/librewolf.nix;
        librewolf-vm = nixpkgs.lib.nixosSystem {
          inherit system;

          modules = [
            # this runs as a MicroVM
            inputs.microvm.nixosModules.microvm

            (
              { lib, pkgs, ... }:
              {
                microvm = {
                  hypervisor = "cloud-hypervisor";
                  graphics.enable = true;
                  interfaces = lib.optional (tapInterface != null) {
                    type = "tap";
                    id = null;
                    mac = "00:00:00:00:00:02";
                  };
                };

                networking.hostName = "graphical-microvm";
                system.stateVersion = lib.trivial.release;
                nixpkgs.overlays = [ inputs.microvm.overlay ];

                services.getty.autologinUser = "user";
                users.users.user = {
                  password = "";
                  group = "user";
                  isNormalUser = true;
                  extraGroups = [
                    "wheel"
                    "video"
                  ];
                };
                users.groups.user = { };
                security.sudo = {
                  enable = true;
                  wheelNeedsPassword = false;
                };

                environment.sessionVariables = {
                  WAYLAND_DISPLAY = "wayland-1";
                  DISPLAY = ":0";
                  QT_QPA_PLATFORM = "wayland"; # Qt Applications
                  GDK_BACKEND = "wayland"; # GTK Applications
                  XDG_SESSION_TYPE = "wayland"; # Electron Applications
                  SDL_VIDEODRIVER = "wayland";
                  CLUTTER_BACKEND = "wayland";
                };

                systemd.user.services.wayland-proxy = {
                  enable = true;
                  description = "Wayland Proxy";
                  serviceConfig = with pkgs; {
                    # Environment = "WAYLAND_DISPLAY=wayland-1";
                    ExecStart = "${wayland-proxy-virtwl}/bin/wayland-proxy-virtwl --virtio-gpu --x-display=0 --xwayland-binary=${xwayland}/bin/Xwayland";
                    Restart = "on-failure";
                    RestartSec = 5;
                  };
                  wantedBy = [ "default.target" ];
                };

                environment.systemPackages = with pkgs; [
                  xdg-utils # Required
                  librewolf
                ];

                hardware.graphics.enable = true;
              }
            )
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
