# Requires niri and home-manager modules to be imported.
# TODO:
# - could be a nice idea to make the user parametric
{
  pkgs,
  lib,
  ...
}:
let
  # selectedShell = "noctalia-shell";
  selectedShell = "custom";

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
    "noctalia-shell" = {
      spawn = noctalia_exec "launcher toggle";
    };
  };

  shellSpecificLockAction = {
    "custom" = {
      spawn = [
        "swaylock"
        "-f"
        "-i"
        "~/Pictures/wallpaper.jpg"
      ];
    };
    "noctalia-shell" = {
      spawn = noctalia_exec "lockScreen lock";
    };
  };

  shellSpecificBrightnessActions = {
    custom = {
      "XF86MonBrightnessDown".action = {
        spawn = [
          "brightnessctl"
          "set"
          "5%-"
        ];
      };
      "XF86MonBrightnessUp".action = {
        spawn = [
          "brightnessctl"
          "set"
          "5%+"
        ];
      };

      # Run `wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.1+`.
      "XF86AudioRaiseVolume".action = {
        spawn = [
          "wpctl"
          "set-volume"
          "-l"
          "1.0"
          "@DEFAULT_AUDIO_SINK@"
          "5%+"
        ];
      };
      "XF86AudioLowerVolume".action = {
        spawn = [
          "wpctl"
          "set-volume"
          "-l"
          "1.0"
          "@DEFAULT_AUDIO_SINK@"
          "5%-"
        ];
      };

      "XF86AudioMute" = {
        allow-when-locked = true;
        action = {
          spawn = [
            "wpctl"
            "set-mute"
            "@DEFAULT_AUDIO_SINK@"
            "toggle"
          ];
        };
      };

    };
    noctalia-shell = {
      "XF86MonBrightnessDown".action = {
        spawn = noctalia_exec "brightness decrease";
      };
      "XF86MonBrightnessUp".action = {
        spawn = noctalia_exec "brightness increase";
      };

      # Run `wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.1+`.
      "XF86AudioRaiseVolume".action = {
        spawn = noctalia_exec "volume increase";
      };
      "XF86AudioLowerVolume".action = {
        spawn = noctalia_exec "volume decrease";
      };

      "XF86AudioMute" = {
        allow-when-locked = true;
        action = {
          spawn = noctalia_exec "volume muteOutput";
        };
      };
    };
  };

  shellSpecificImports = {
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
      ../../home-manager/linux/services/gammastep.nix

      # Commenting because blueman can import will autostart the applet
      # Bluetooth
      # ../../home-manager/linux/services/blueman-applet.nix

      # Network Manager applet
      ../../home-manager/linux/services/network-manager-applet.nix

      # Sway Notification Center
      ../../home-manager/linux/services/swaync.nix

      # Idle manager
      ../../home-manager/linux/services/swayidle.nix

      # Lock manager
      ../../home-manager/linux/programs/swaylock.nix

      # Application launcher
      ../../home-manager/linux/programs/rofi.nix
    ];
    "noctalia-shell" = [
      ../../home-manager/linux/programs/noctalia-shell.nix
    ];
  };

  shellSpecificSpawnAtStartup = {
    "custom" = [ ];
    "noctalia-shell" = [
      {
        argv = [
          "env"
          # QT_QPA_PLATFORMTHEME=gtk3 env var is needed to not break fcitx icon.
          "QT_QPA_PLATFORMTHEME=gtk3"
          noctalia-shell
        ];
      }
    ];
  };

in
{
  services.gnome.gnome-keyring.enable = false;

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
      package = pkgs.niri;
    };
  };

  services.blueman = {
    enable = true;
  };

  home-manager.users.zhifan = {

    imports = [
      ../../home-manager/linux/services/kanshi.nix
    ]
    ++ shellSpecificImports."${selectedShell}";
    programs.niri.package = pkgs.niri;
    home.packages = [ pkgs.xwayland-satellite ] ++ shellSpecificPackages."${selectedShell}";

    programs.niri = {
      settings = {
        prefer-no-csd = true;

        layout = {
          preset-column-widths = [
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
          { argv = [ "xwayland-satellite" ]; }
        ]
        ++ shellSpecificSpawnAtStartup."${selectedShell}";

        switch-events = {
          lid-close.action = {
            # let logind handle suspension
            # this only triggers lockScreen
            spawn = noctalia_exec "lockScreen lock";
          };
          lid-open.action = {
            spawn = [
              "notify-send"
              "The laptop lid is open!"
            ];
          };
          tablet-mode-on.action = {
            spawn = [
              "bash"
              "-c"
              "gsettings set org.gnome.desktop.a11y.applications screen-keyboard-enabled true"
            ];
          };
          tablet-mode-off.action = {
            spawn = [
              "bash"
              "-c"
              "gsettings set org.gnome.desktop.a11y.applications screen-keyboard-enabled false"
            ];
          };
        };

        input = {
          keyboard = {
            xkb = {
              layout = "us";
              variant = "altgr-intl";
            };

            # repeat-delay = 600;
            # repeat-rate = 25;
            # track-layout="global";
          };

          touchpad = {
            # off
            tap = true;
            dwt = true;
            # dwtp
            natural-scroll = true;
            # accel-speed 0.2
            # accel-profile "flat"
            # scroll-factor 1.0
            # scroll-method "two-finger"
            # scroll-button 273
            # tap-button-map "left-middle-right"
            # click-method "clickfinger"
            # left-handed
            # disabled-on-external-mouse
            # middle-emulation
          };

          mouse = {
            # off
            # natural-scroll
            # accel-speed 0.2
            # accel-profile "flat"
            # scroll-factor 1.0
            # scroll-method "no-scroll"
            # scroll-button 273
            # left-handed
            # middle-emulation
          };

          trackpoint = {
            # off
            # natural-scroll
            # accel-speed 0.2
            # accel-profile "flat"
            # scroll-method "on-button-down"
            # scroll-button 273
            # middle-emulation
          };

          trackball = {
            # off
            # natural-scroll
            # accel-speed 0.2
            # accel-profile "flat"
            # scroll-method "on-button-down"
            # scroll-button 273
            # left-handed
            # middle-emulation
          };

          tablet = {
            # off
            map-to-output = "eDP-1";
            # left-handed
          };

          touch = {
            map-to-output = "eDP-1";
          };

          warp-mouse-to-focus = {
            enable = true;
          };
          focus-follows-mouse = {
            enable = true;
            max-scroll-amount = "0%";
          };
          # workspace-auto-back-and-forth
        };

        debug = {
          deactivate-unfocused-windows = true;
        };

        window-rules = [
          {
            open-maximized = true;
          }

          {
            draw-border-with-background = false;
            matches = [
              {
                app-id = "com.mitchellh.ghostty";
              }
            ];
          }
        ];

        # cursor = {
        #   xcursor-size ${builtins.toString config.home.pointerCursor.size}
        # }

        outputs = {
          "eDP-1" = {
            scale = 2.0;
          };
        };

        binds = {

          "Print".action = {
            screenshot = { };
          };

          "Mod+Print".action = {
            screenshot-screen = { };
          };
          "Shift+Print".action = {
            screenshot-window = { };
          };

          # Window bindings (Mod + W prefix)
          "Mod+O".action = {
            maximize-column = { };
          };

          "Mod+V".action = {
            switch-preset-column-width = { };
          };

          "Mod+T".action = {
            spawn = "${pkgs.ghostty}/bin/ghostty";
          };
          "Mod+Shift+X".action = {
            quit = { };
          };

          # Window focus and movement bindings
          "Mod+H".action = {
            focus-column-left = { };
          };
          "Mod+L".action = {
            focus-column-right = { };
          };
          "Mod+J".action = {
            focus-window-or-workspace-down = { };
          };
          "Mod+K".action = {
            focus-window-or-workspace-up = { };
          };

          # Monitor focus
          # I use at most 2 monitors so the behavior is the same as a toggle
          "Mod+W".action = {
            focus-monitor-next = { };
          };

          # Move windows
          "Mod+Shift+H".action = {
            move-column-left-or-to-monitor-left = { };
          };
          "Mod+Shift+L".action = {
            move-column-right-or-to-monitor-right = { };
          };
          "Mod+Shift+J".action = {
            move-window-down-or-to-workspace-down = { };
          };
          "Mod+Shift+K".action = {
            move-window-up-or-to-workspace-up = { };
          };
          "Mod+Shift+W".action = {
            move-window-to-monitor-next = { };
          };

          "Mod+F11".action = {
            fullscreen-window = { };
          };
          "Mod+slash".action = shellSpecificLauncherAction."${selectedShell}";
          "Mod+Shift+Q".action = {
            close-window = { };
          };

          "Mod+Shift+E" = {
            allow-inhibiting = false;
            action = shellSpecificLockAction."${selectedShell}";
          };

        }
        // shellSpecificBrightnessActions."${selectedShell}";
      };
    };
  };
}
