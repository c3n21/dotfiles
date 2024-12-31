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

    niri = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
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
    niri,
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
    overlays = [niri.overlays.niri];
    nixosModules = [
      niri.nixosModules.niri
    ];

    nixosConfigurations = {
      framework-13-7040-amd = mkNixosConfiguration {
        hostName = "zenuko";
        modules = [
          nixos-hardware.nixosModules.framework-13-7040-amd
          ./nixos/framework-13-7040-amd/hardware-configuration.nix
          {
            programs.niri.package = pkgs.niri;
            programs.niri.enable = true;
          }
          {
            environment.sessionVariables.NIXOS_OZONE_WL = "1";
          }
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
          niri.homeModules.niri

          {
            home.packages = [
              ghostty.packages.x86_64-linux.default
            ];
          }
          {
            programs.niri.package = pkgs.niri;
            programs.niri.config = ''
              input {
                keyboard {
                    xkb {
                        layout "us"
                        variant "altgr-intl"
                        options "caps:swapescape"
                        // model ""
                        // rules ""
                    }

                    // repeat-delay 600
                    // repeat-rate 25
                    // track-layout "global"
                }

                touchpad {
                    // off
                    tap
                    // dwt
                    // dwtp
                    natural-scroll
                    // accel-speed 0.2
                    // accel-profile "flat"
                    // scroll-factor 1.0
                    // scroll-method "two-finger"
                    // scroll-button 273
                    // tap-button-map "left-middle-right"
                    // click-method "clickfinger"
                    // left-handed
                    // disabled-on-external-mouse
                    // middle-emulation
                }

                mouse {
                    // off
                    // natural-scroll
                    // accel-speed 0.2
                    // accel-profile "flat"
                    // scroll-factor 1.0
                    // scroll-method "no-scroll"
                    // scroll-button 273
                    // left-handed
                    // middle-emulation
                }

                trackpoint {
                    // off
                    // natural-scroll
                    // accel-speed 0.2
                    // accel-profile "flat"
                    // scroll-method "on-button-down"
                    // scroll-button 273
                    // middle-emulation
                }

                trackball {
                    // off
                    // natural-scroll
                    // accel-speed 0.2
                    // accel-profile "flat"
                    // scroll-method "on-button-down"
                    // scroll-button 273
                    // left-handed
                    // middle-emulation
                }

                tablet {
                    // off
                    map-to-output "eDP-1"
                    // left-handed
                }

                touch {
                    map-to-output "eDP-1"
                }

                // disable-power-key-handling
                warp-mouse-to-focus
                // focus-follows-mouse max-scroll-amount="0%"
                // workspace-auto-back-and-forth
              }
              output "eDP-1" {
                 scale 2.0
              }
              binds {
                Mod+T { spawn "ghostty"; }
                Mod+Shift+X { quit; }
                Mod+H { focus-column-left; }
                Mod+L { focus-column-right; }
                Mod+F11 { fullscreen-window; }
                Mod+slash { spawn "rofi" "-show" "drun"; }
                Mod+Shift+Q {close-window; }


                // Run `wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.1+`.
                XF86AudioRaiseVolume { spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "0.1+"; }
                XF86AudioLowerVolume { spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "0.1-"; }
              }
            '';
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
