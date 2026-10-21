# Requires niri and home-manager modules to be imported.
# TODO:
# - could be a nice idea to make the user parametric
# - Optionally import inputs.niri.nixosModules.default (which provides programs.niri.withUWSM and programs.niri.withXDG)
{
  pkgs,
  lib,
  # it's for workaround
  # config,
  inputs,
  ...
}:
let
  # selectedShell = "noctalia-shell";
  selectedShell = "custom";
  niri = pkgs.niri-unstable;
  noctalia-shell = "${pkgs.noctalia-shell}/bin/noctalia-shell";

  noctalia_exec =
    cmd:
    [
      noctalia-shell
      "ipc"
      "call"
    ]
    ++ (pkgs.lib.splitString " " cmd);

  shellSpecificPackages = {
    custom = [ pkgs.brightnessctl ];
    noctalia-shell = [ ];
  };

  shellSpecificLauncherAction = {
    "custom" = {
      spawn = [
        "rofi"
        "-show"
        "drun"
      ];
    };
    # "noctalia-shell" = {
    #   spawn = noctalia_exec "launcher toggle";
    # };
  };

  shellSpecificLockAction = {
    "custom" = {
      spawn = [
        "loginctl"
        "lock-session"
      ];
    };
    # "noctalia-shell" = {
    #   spawn = noctalia_exec "lockScreen lock";
    # };
  };

  shellSpecificBrightnessActions = {
    custom = {
      "XF86MonBrightnessDown".spawn = [
        "brightnessctl"
        "set"
        "5%-"
      ];
      "XF86MonBrightnessUp".spawn = [
        "brightnessctl"
        "set"
        "5%+"
      ];

      # Run `wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.1+`.
      "XF86AudioRaiseVolume".spawn = [
        "wpctl"
        "set-volume"
        "-l"
        "1.0"
        "@DEFAULT_AUDIO_SINK@"
        "5%+"
      ];
      "XF86AudioLowerVolume".spawn = [
        "wpctl"
        "set-volume"
        "-l"
        "1.0"
        "@DEFAULT_AUDIO_SINK@"
        "5%-"
      ];

      "XF86AudioMute" = {
        _props.allow-when-locked = true;
        spawn = [
          "wpctl"
          "set-mute"
          "@DEFAULT_AUDIO_SINK@"
          "toggle"
        ];
      };

    };
    # noctalia-shell = {
    #   "XF86MonBrightnessDown".spawn = noctalia_exec "brightness decrease";
    #   "XF86MonBrightnessUp".spawn = noctalia_exec "brightness increase";
    #
    #   # Run `wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.1+`.
    #   "XF86AudioRaiseVolume".spawn = noctalia_exec "volume increase";
    #   "XF86AudioLowerVolume".spawn = noctalia_exec "volume decrease";
    #
    #   "XF86AudioMute" = {
    #     _props.allow-when-locked = true;
    #     spawn = noctalia_exec "volume muteOutput";
    #   };
    # };
  };

  shellSpecificImports =
    let
      lock = "${pkgs.swaylock}/bin/swaylock -fF -i ~/Pictures/wallpaper.jpg";
      displaysOff = "${niri}/bin/niri msg action power-off-monitors";
    in
    {
      "custom" = [
        # Shell bar
        ../../home-manager/linux/programs/waybar.nix
        {
          programs = {
            waybar = {
              settings = {
                mainBar = {
                  "modules-left" = [ "niri/workspaces" ];

                  "niri/workspaces" = {
                    "format" = "{icon}";
                    "format-icons" = {
                      "active" = "";
                      "default" = "";
                    };
                  };
                };
              };
            };
          };
        }

        # Wallpaper engine
        ../../home-manager/linux/services/hyprpaper.nix

        # Night color
        # ../../home-manager/linux/services/gammastep.nix
        ../../home-manager/linux/services/wlsunset.nix

        # Commenting because blueman can import will autostart the applet
        # Bluetooth
        # ../../home-manager/linux/services/blueman-applet.nix

        # Network Manager applet
        ../../home-manager/linux/services/network-manager-applet.nix

        # Sway Notification Center
        ../../home-manager/linux/services/swaync.nix

        # Idle manager
        ../../home-manager/linux/services/swayidle.nix
        {
          services = {
            swayidle = {
              events = {
                lock = "${lock}; ${displaysOff} ";

                before-sleep = lock;
              };
            };
          };
        }

        # Lock manager
        ../../home-manager/linux/programs/swaylock.nix

        # Application launcher
        ../../home-manager/linux/programs/rofi.nix
      ];
      # "noctalia-shell" = [
      #   ../../home-manager/linux/programs/noctalia-shell.nix
      # ];
    };

  shellSpecificSpawnAtStartup = {
    "custom" = [ ];
    # "noctalia-shell" = [
    #   [
    #     "env"
    #     # QT_QPA_PLATFORMTHEME=gtk3 env var is needed to not break fcitx icon.
    #     "QT_QPA_PLATFORMTHEME=gtk3"
    #     noctalia-shell
    #   ]
    # ];
  };

in
{

  imports = [
  ];

  services = {
    gnome.gnome-keyring.enable = false;
  };

  xdg.portal = {
    xdgOpenUsePortal = true;
    config = {
      # seems like niri-portals.conf doesn't do merging with the default niri-portals.conf,
      # thus I'm providing the full config.
      niri = {
        default = [
          "gnome"
          "gtk"
        ];
        "org.freedesktop.impl.portal.Access" = "gtk";
        "org.freedesktop.impl.portal.Notification" = "gtk";
        "org.freedesktop.impl.portal.FileChooser" = "gtk";
        "org.freedesktop.impl.portal.Secret" = lib.mkForce "kwallet"; # needs to be tested
      };
    };
  };

  programs = {
    uwsm = {
      enable = true;
      waylandCompositors = { };
    };

    niri = {
      enable = true;
      package = niri;
    };
  };

  services.blueman = {
    enable = true;
  };

  home-manager.users.zhifan =
    { lib, ... }:
    {

      imports = [

        ../../home-manager/linux/services/kanshi.nix
      ]
      ++ shellSpecificImports."${selectedShell}";

      home.activation.ensureNiriWorkspaces =
        lib.hm.dag.entryAfter [ "writeBoundary" ]
          # bash
          ''
            WORKSPACES_FILE="$HOME/.config/niri/workspaces.kdl"
            if [ ! -e "$WORKSPACES_FILE" ]; then
              $DRY_RUN_CMD mkdir -p "$(dirname "$WORKSPACES_FILE")"
              $DRY_RUN_CMD touch "$WORKSPACES_FILE"
            fi
          '';

      home.packages = [
        pkgs.xwayland-satellite
        pkgs.dotfiles.niri-autostart
      ]
      ++ shellSpecificPackages."${selectedShell}";

      # Temporapry workaround
      # xdg.configFile.niri-config.source =
      #   let
      #     inherit (inputs.niri.lib.internal) validated-config-for;
      #     inherit (config.home-manager.users.zhifan.programs.niri) finalConfig package;
      #   in
      #   lib.mkForce (
      #     validated-config-for pkgs package # kdl
      #       ''
      #         ${finalConfig}
      #
      #         window-rule {
      #           background-effect {
      #             // blur true
      #             xray true
      #           }
      #         }
      #
      #         // layer-rule {
      #         //   match namespace="^noctalia-(background|launcher-overlay|dock)-.*$"
      #         //   background-effect {
      #         //     xray false
      #         //   }
      #         // }
      #       ''
      #   );

      wayland.windowManager.niri = {
        enable = true;
        package = niri;

        settings = {

          include = [
            "workspaces.kdl"
          ];

          prefer-no-csd = { };

          layout = {
            preset-column-widths._children = [
              {
                proportion = 0.5;
              }
              {
                proportion = 1.0;
              }
            ];
          };

          environment = {
            QT_QPA_PLATFORM = "wayland;xcb";
            # do I really need to hard-code the DISPLAY number?
            DISPLAY = ":0";
            GTK_IM_MODULE = "fcitx";
            QT_IM_MODULE = "fcitx";
          };

          spawn-at-startup = [
            [ "xwayland-satellite" ]
            [ "niri-autostart" ]
          ]
          ++ shellSpecificSpawnAtStartup."${selectedShell}";

          switch-events = {
            # lid-close = {
            #   # let logind handle suspension
            #   # this only triggers lockScreen
            #   spawn = noctalia_exec "lockScreen lock";
            # };
            # lid-open = {
            #   spawn = [
            #     "notify-send"
            #     "The laptop lid is open!"
            #   ];
            # };
            # tablet-mode-on = {
            #   spawn = [
            #     "bash"
            #     "-c"
            #     "gsettings set org.gnome.desktop.a11y.applications screen-keyboard-enabled true"
            #   ];
            # };
            # tablet-mode-off = {
            #   spawn = [
            #     "bash"
            #     "-c"
            #     "gsettings set org.gnome.desktop.a11y.applications screen-keyboard-enabled false"
            #   ];
            # };
          };

          input = {
            keyboard = {
              xkb = {
                layout = "us";
                variant = "altgr-intl";
              };

              # repeat-delay = 600;
              # repeat-rate = 25;
              # track-layout = "global";
            };

            touchpad = {
              # off = { };
              tap = { };
              dwt = { };
              # dwtp = { };
              natural-scroll = { };
              # accel-speed = 0.2;
              # accel-profile = "flat";
              # scroll-factor = 1.0;
              # scroll-method = "two-finger";
              # scroll-button = 273;
              # tap-button-map = "left-middle-right";
              # click-method = "clickfinger";
              # left-handed = { };
              # disabled-on-external-mouse = { };
              # middle-emulation = { };
            };

            mouse = {
              # off = { };
              # natural-scroll = { };
              # accel-speed = 0.2;
              # accel-profile = "flat";
              # scroll-factor = 1.0;
              # scroll-method = "no-scroll";
              # scroll-button = 273;
              # left-handed = { };
              # middle-emulation = { };
            };

            trackpoint = {
              # off = { };
              # natural-scroll = { };
              # accel-speed = 0.2;
              # accel-profile = "flat";
              # scroll-factor = 1.0;
              # scroll-method = "on-button-down";
              # scroll-button = 273;
              # middle-emulation = { };
            };

            trackball = {
              # off = { };
              # natural-scroll = { };
              # accel-speed = 0.2;
              # accel-profile = "flat";
              # scroll-factor = 1.0;
              # scroll-method = "on-button-down";
              # scroll-button = 273;
              # left-handed = { };
              # middle-emulation = { };
            };

            tablet = {
              # off = { };
              map-to-output = "eDP-1";
              # left-handed = { };
            };

            touch = {
              map-to-output = "eDP-1";
            };

            warp-mouse-to-focus = { };
            focus-follows-mouse._props.max-scroll-amount = "0%";
            # workspace-auto-back-and-forth = { };
          };

          debug = {
            deactivate-unfocused-windows = true;
          };

          window-rule = [
            # {
            #   open-maximized = true;
            # }

            {
              draw-border-with-background = false;
              match._props.app-id = "com.mitchellh.ghostty";
            }
          ];

          output = [
            {
              _args = [ "eDP-1" ];
              scale = 2.0;
            }
          ];

          binds = {
            "Print".screenshot = { };

            "Mod+Print".screenshot-screen = { };
            "Shift+Print".screenshot-window = { };

            # Window bindings (Mod + W prefix)
            "Mod+O".maximize-window-to-edges = { };

            "Mod+c".toggle-column-tabbed-display = { };

            "Mod+Alt+H".consume-or-expel-window-left = { };

            "Mod+Alt+L".consume-or-expel-window-right = { };

            "Mod+V".switch-preset-column-width = { };

            "Mod+T".spawn = "${pkgs.ghostty}/bin/ghostty";
            "Mod+Shift+X".quit = { };

            # Window focus and movement bindings
            "Mod+H".focus-column-left = { };
            "Mod+L".focus-column-right = { };
            "Mod+J".focus-window-or-workspace-down = { };
            "Mod+K".focus-window-or-workspace-up = { };

            # Monitor focus
            # I use at most 2 monitors so the behavior is the same as a toggle
            "Mod+W".focus-monitor-next = { };

            # Move windows
            "Mod+Shift+H".move-column-left-or-to-monitor-left = { };
            "Mod+Shift+L".move-column-right-or-to-monitor-right = { };
            "Mod+Shift+J".move-window-down-or-to-workspace-down = { };
            "Mod+Shift+K".move-window-up-or-to-workspace-up = { };
            "Mod+Shift+W".move-window-to-monitor-next = { };

            "Mod+F11".fullscreen-window = { };
            "Mod+slash" = shellSpecificLauncherAction."${selectedShell}";
            "Mod+Shift+Q".close-window = { };

            "Mod+Shift+E" = {
              _props.allow-inhibiting = false;
            }
            // shellSpecificLockAction."${selectedShell}";

          }
          // shellSpecificBrightnessActions."${selectedShell}";
        };
      };
    };
}
