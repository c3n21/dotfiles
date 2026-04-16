{ pkgs, config, ... }:
let
  supportedShells = [
    "waybar"
    "noctalia-shell"
  ];
  selectedShell = "noctalia-shell";
  shellSpecificImports = {
    "custom" = [
      # Shell bar
      ../programs/waybar.nix

      # Wallpaper engine
      ../services/hyprpaper.nix

      # Night color
      ../services/gammastep.nix

      # Bluetooth
      ../services/blueman-applet.nix

      # Network Manager applet
      ../services/network-manager-applet.nix
    ];
    "noctalia-shell" = [
      ../programs/noctalia-shell.nix
    ];
  };

  shellSpecificSpawnAtStartup = {
    "custom" = [ ];
    "noctalia-shell" = [
      { argv = [ "${pkgs.noctalia-shell}/bin/noctalia-shell" ]; }
    ];
  };
in
{

  imports = shellSpecificImports."${selectedShell}";
  programs.niri.package = pkgs.niri;
  home.packages = [ pkgs.xwayland-satellite ];

  programs.niri = {
    settings = {
      prefer-no-csd = true;

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
        #  let logind handle suspension
        # lid-close { spawn "systemctl" "suspend"; }
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

        # disable-power-key-handling
        warp-mouse-to-focus = true;
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

        "Mod+T".action = {
          spawn = "ghostty";
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
        "Mod+slash".action = {
          spawn = [
            "rofi"
            "-show"
            "drun"
          ];
        };
        "Mod+Shift+Q".action = {
          close-window = { };
        };

        "Mod+Shift+E" = {
          allow-inhibiting = false;
          action = {
            spawn = [
              "swaylock"
              "-f"
              "-i"
              "~/Pictures/wallpaper.jpg"
            ];
          };
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
    };

    # config = # kdl
    #   ''
    #     prefer-no-csd

    #     spawn-at-startup "xwayland-satellite"

    #     debug {
    #       deactivate-unfocused-windows
    #     }

    #     // Set open-maximized to true for all windows.
    #     window-rule {
    #       open-maximized true
    #     }

    #     window-rule {
    #       draw-border-with-background false
    #       match app-id="com.mitchellh.ghostty"
    #     }

    #     // this seems to fix cursor issues with niri
    #     cursor {
    #       xcursor-size ${builtins.toString config.home.pointerCursor.size}
    #     }

    #     environment {
    #       QT_QPA_PLATFORM "wayland;xcb"
    #       DISPLAY ":0"
    #       GTK_IM_MODULE "fcitx"
    #       QT_IM_MODULE "fcitx"
    #     }

    #     switch-events {
    #       // let logind handle suspension
    #       // lid-close { spawn "systemctl" "suspend"; }
    #       lid-open { spawn "notify-send" "The laptop lid is open!"; }
    #       tablet-mode-on { spawn "bash" "-c" "gsettings set org.gnome.desktop.a11y.applications screen-keyboard-enabled true"; }
    #       tablet-mode-off { spawn "bash" "-c" "gsettings set org.gnome.desktop.a11y.applications screen-keyboard-enabled false"; }
    #     }

    #     input {
    #       keyboard {
    #         xkb {
    #           layout "us"
    #           variant "altgr-intl"
    #         }

    #         // repeat-delay 600
    #         // repeat-rate 25
    #         // track-layout "global"
    #       }

    #       touchpad {
    #         // off
    #         tap
    #         dwt
    #         // dwtp
    #         natural-scroll
    #         // accel-speed 0.2
    #         // accel-profile "flat"
    #         // scroll-factor 1.0
    #         // scroll-method "two-finger"
    #         // scroll-button 273
    #         // tap-button-map "left-middle-right"
    #         // click-method "clickfinger"
    #         // left-handed
    #         // disabled-on-external-mouse
    #         // middle-emulation
    #       }

    #       mouse {
    #         // off
    #         // natural-scroll
    #         // accel-speed 0.2
    #         // accel-profile "flat"
    #         // scroll-factor 1.0
    #         // scroll-method "no-scroll"
    #         // scroll-button 273
    #         // left-handed
    #         // middle-emulation
    #       }

    #       trackpoint {
    #         // off
    #         // natural-scroll
    #         // accel-speed 0.2
    #         // accel-profile "flat"
    #         // scroll-method "on-button-down"
    #         // scroll-button 273
    #         // middle-emulation
    #       }

    #       trackball {
    #         // off
    #         // natural-scroll
    #         // accel-speed 0.2
    #         // accel-profile "flat"
    #         // scroll-method "on-button-down"
    #         // scroll-button 273
    #         // left-handed
    #         // middle-emulation
    #       }

    #       tablet {
    #         // off
    #         map-to-output "eDP-1"
    #         // left-handed
    #       }

    #       touch {
    #         map-to-output "eDP-1"
    #       }

    #       // disable-power-key-handling
    #       warp-mouse-to-focus
    #       focus-follows-mouse max-scroll-amount="0%"
    #       // workspace-auto-back-and-forth
    #     }
    #     output "eDP-1" {
    #       scale 2.0
    #     }

    #     binds {

    #       Print { screenshot; }
    #       Mod+Print { screenshot-screen; }
    #       Shift+Print { screenshot-window; }

    #       // Window bindings (Mod + W prefix)
    #       Mod+O { maximize-column; }

    #       Mod+T { spawn "ghostty"; }
    #       Mod+Shift+X { quit; }

    #       // Window focus and movement bindings
    #       Mod+H { focus-column-left; }
    #       Mod+L { focus-column-right; }
    #       Mod+J { focus-window-or-workspace-down; }
    #       Mod+K { focus-window-or-workspace-up; }

    #       // Monitor focus
    #       // I use at most 2 monitors so the behavior is the same as a toggle
    #       Mod+W { focus-monitor-next; }

    #       // Move windows
    #       Mod+Shift+H { move-column-left-or-to-monitor-left; }
    #       Mod+Shift+L { move-column-right-or-to-monitor-right; }
    #       Mod+Shift+J { move-window-down-or-to-workspace-down; }
    #       Mod+Shift+K { move-window-up-or-to-workspace-up; }
    #       Mod+Shift+W { move-window-to-monitor-next; }

    #       Mod+F11 { fullscreen-window; }
    #       Mod+slash { spawn "rofi" "-show" "drun"; }
    #       Mod+Shift+Q {close-window; }

    #       Mod+Shift+E allow-inhibiting=false { spawn "swaylock" "-f" "-i" "~/Pictures/wallpaper.jpg"; }

    #       // Run `wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.1+`.
    #       XF86AudioRaiseVolume { spawn "wpctl" "set-volume" "-l" "1.0" "@DEFAULT_AUDIO_SINK@" "5%+"; }
    #       XF86AudioLowerVolume { spawn "wpctl" "set-volume" "-l" "1.0" "@DEFAULT_AUDIO_SINK@" "5%-"; }
    #       XF86MonBrightnessDown { spawn "brightnessctl" "set" "5%-"; }
    #       XF86MonBrightnessUp { spawn "brightnessctl" "set" "5%+"; }

    #       XF86AudioMute allow-when-locked=true { spawn "wpctl" "set-mute" "@DEFAULT_AUDIO_SINK@" "toggle"; }
    #     }
    #   '';
  };
}
