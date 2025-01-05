{
  inputs,
  pkgs,
  ...
}: {
  hyprland = {
    configuration = {
      wayland.windowManager.hyprland = {
        enable = true;
        package = inputs.hyprland.packages.${pkgs.system}.hyprland;
        systemd = {
          # disabling because of this https://wiki.hyprland.org/Useful-Utilities/Systemd-start/#uwsm
          enable = false;
          variables = ["--all"];
        };
        xwayland = {
          enable = true;
        };
        # plugins = [
        #   inputs.split-monitor-workspaces.packages.${pkgs.system}.split-monitor-workspaces
        # ];

        settings = {
          # unscale XWayland
          xwayland = {
            force_zero_scaling = true;
          };

          input = {
            kb_layout = "us";
            kb_variant = "altgr-intl";
            kb_options = "caps:swapescape";
            follow_mouse = "1";
            sensitivity = 0.35;
            touchpad = {
              natural_scroll = "yes";
            };
          };

          gestures = {
            workspace_swipe = true;
            workspace_swipe_fingers = 3;
          };

          general = {
            gaps_in = 5;
            gaps_out = 5;
            border_size = 7;
            "col.active_border" = "0x66ee1111";
            "col.inactive_border" = "0x66333333";
          };

          decoration = {
            rounding = 10;
            shadow = {
              enabled = false;
              range = 10;
              render_power = 2;
            };
          };

          misc = {
            vfr = true;
            layers_hog_keyboard_focus = true;
            focus_on_activate = false;
            mouse_move_enables_dpms = true;
            key_press_enables_dpms = true;
            allow_session_lock_restore = true;
          };

          animations = {
            enabled = 1;
            animation = [
              "windows,1,7,default"
              "border,1,10,default"
              "fade,1,10,default"
              "workspaces,1,6,default"
            ];
          };

          dwindle = {
            pseudotile = 1; # enable pseudotiling on dwindle
            force_split = 0; # 0 means the split direction follows mouse position relative to the window
            preserve_split = 1;
          };

          "$mod" = "SUPER";
          bind = [
            "$mod,T,togglespecialworkspace"
            "$mod SHIFT,Q,killactive,"

            "$mod CTRLSHIFT,X,exit, "
            "$mod SHIFT,g,togglefloating,"
            "$mod ,code:61,exec,rofi -show drun"
            "$mod ,P,pseudo,"

            "$mod ,S,togglesplit"

            "$mod ,h,movefocus,l"
            "$mod ,l,movefocus,r"
            "$mod ,k,movefocus,u"
            "$mod ,j,movefocus,d"

            "$mod SHIFT,h,movewindow,l"
            "$mod SHIFT,l,movewindow,r"
            "$mod SHIFT,k,movewindow,u"
            "$mod SHIFT,j,movewindow,d"

            "$mod ,1,workspace,1"
            "$mod ,2,workspace,2"
            "$mod ,3,workspace,3"
            "$mod ,4,workspace,4"
            "$mod ,5,workspace,5"
            "$mod ,6,workspace,6"
            "$mod ,7,workspace,7"
            "$mod ,8,workspace,8"
            "$mod ,9,workspace,9"
            "$mod ,0,workspace,10"

            "$mod ,y,workspace,r+1"
            "$mod ,e,workspace,r-1"

            "$mod SHIFT,1,movetoworkspacesilent,1"
            "$mod SHIFT,2,movetoworkspacesilent,2"
            "$mod SHIFT,3,movetoworkspacesilent,3"
            "$mod SHIFT,4,movetoworkspacesilent,4"
            "$mod SHIFT,5,movetoworkspacesilent,5"

            "$mod SHIFT,y,movetoworkspace,r+1"
            "$mod SHIFT,e,movetoworkspace,r-1"

            "$mod ,F11,fullscreen"
            "$mod SHIFT,S,exec,grimblast --freeze copy area"

            # Lock scren
            "$mod CTRL,e,exec,swaylock -f -i ~/Pictures/wallpaper.jpg"

            "$mod SHIFT,6,movetoworkspacesilent,6"
            "$mod SHIFT,7,movetoworkspacesilent,7"
            "$mod SHIFT,8,movetoworkspacesilent,8"
            "$mod SHIFT,9,movetoworkspacesilent,9"
            "$mod SHIFT,0,movetoworkspacesilent,10"
          ];

          bindm = [
            "$mod ,mouse:272,resizewindow"
            "$mod ,mouse:273,movewindow"
          ];

          binde = [
            ",XF86AudioLowerVolume,exec,wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ 5%-"
            ",XF86AudioRaiseVolume,exec,wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ 5%+"
            # ",XF86MonBrightnessDown,exec,awk '{ print $1 - 50}' /sys/class/backlight/intel_backlight/actual_brightness > /sys/class/backlight/intel_backlight/brightness"
            # ",XF86MonBrightnessUp,exec,awk '{ print $1 + 50}' /sys/class/backlight/intel_backlight/actual_brightness > /sys/class/backlight/intel_backlight/brightness"
          ];

          bindt = [
            # bindl=,switch:off:[switch name],exec,hyprctl keyword monitor "eDP-1, disable"
            # bindl=,switch:on:[switch name],exec,hyprctl keyword monitor "eDP-1, 2560x1600, 0x0, 1
            # trigger when the switch is toggled
            # trigger when the switch is turning off
            # trigger when the switch is turning on
            ",switch:on:Lid Switch,exec,systemctl suspend "
            ",XF86AudioMute,exec,wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
          ];
        };
        extraConfig = ''
          # windowrulev2=windowdance,class:^(jetbrains-.*)$
          # search dialog
          windowrulev2=dimaround,class:^(jetbrains-.*)$,floating:1,title:^(?!win)
          windowrulev2=center,class:^(jetbrains-.*)$,floating:1,title:^(?!win)
          # autocomplete & menus
          windowrulev2=noanim,class:^(jetbrains-.*)$,title:^(win.*)$
          windowrulev2=noinitialfocus,class:^(jetbrains-.*)$,title:^(win.*)$
          windowrulev2=rounding 0,class:^(jetbrains-.*)$,title:^(win.*)$



          # plugin {
          #     split-monitor-workspaces {
          #         count = 5
          #     }
          # }

          windowrule=pseudo,fcitx

          # windowrulev2 = float,class:(kitty)
          # windowrulev2 = size 80% 80% ,class:(kitty)
          # windowrulev2 = center,class:(kitty)
          windowrulev2 = workspace special,class:(kitty)

          exec-once=nm-applet
          exec-once=blueman-applet
          exec-once=fcitx5 -d --replace
          # exec-once=swayidle -w before-sleep 'swaylock -f -i ~/Pictures/wallpaper.jpg'

          # allow for screen recording via xdg-desktop-portal-wlr
          # exec-once=dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP
          # exec-once=systemctl --user import-environment DISPLAY WAYLAND_DISPLAY SWAYSOCK
          # exec-once=hash dbus-update-activation-environment 2>/dev/null && \
          #     dbus-update-activation-environment --systemd DISPLAY WAYLAND_DISPLAY SWAYSOCK XDG_CURRENT_DESKTOP

          # exec-once = swayidle -w timeout 300 'swaylock -f -i ~/Pictures/wallpaper.jpg' timeout 600 'hyprctl dispatch dpms off' resume 'hyprctl dispatch dpms on'

          # background
          exec=pkill --signal 9 hyprpaper; hyprpaper

          exec-once=hyprctl setcursor Bibata-Modern-Classic 16
        '';
        # ...
      };
    };
  };

  niri = {
    configuration = {
      programs.niri.package = pkgs.niri;
      home.packages = [pkgs.xwayland-satellite];

      programs.niri.config = ''
        // dirty fix to use X11 apps because I'm too lazy to dig through
        spawn-at-startup "xwayland-satellite" ":0"

        // Set open-maximized to true for all windows.
        window-rule {
            open-maximized true
        }

        // this seems to fix cursor issues with niri
        cursor {
            xcursor-size 16
        }

        environment {
          QT_QPA_PLATFORM "wayland;xcb"
          DISPLAY ":0"
        }

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

          Print { screenshot; }

          // Window bindings (Mod + W prefix)
          Mod+O { maximize-column; }

          Mod+T { spawn "ghostty"; }
          Mod+Shift+X { quit; }
          Mod+H { focus-column-left; }
          Mod+L { focus-column-right; }
          Mod+F11 { fullscreen-window; }
          Mod+slash { spawn "rofi" "-show" "drun"; }
          Mod+Shift+Q {close-window; }

          // Run `wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.1+`.
          XF86AudioRaiseVolume { spawn "wpctl" "set-volume" "-l" "1.0" "@DEFAULT_AUDIO_SINK@" "5%+"; }
          XF86AudioLowerVolume { spawn "wpctl" "set-volume" "-l" "1.0" "@DEFAULT_AUDIO_SINK@" "5%-"; }

          XF86AudioMute allow-when-locked=true { spawn "wpctl" "set-mute" "@DEFAULT_AUDIO_SINK@" "toggle"; }
        }
      '';
    };
  };
}
