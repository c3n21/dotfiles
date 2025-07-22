{ pkgs, config, ... }:
{
  programs.niri.package = pkgs.niri-unstable;
  home.packages = [ pkgs.xwayland-satellite ];
  programs.niri.config = # kdl
    ''
      prefer-no-csd
      // dirty fix to use X11 apps because I'm too lazy to dig through
      spawn-at-startup "xwayland-satellite" ":0"

      debug {
        deactivate-unfocused-windows
      }

      // Set open-maximized to true for all windows.
      window-rule {
        open-maximized true
      }

      // this seems to fix cursor issues with niri
      cursor {
        xcursor-size ${builtins.toString config.home.pointerCursor.size}
      }

      environment {
        QT_QPA_PLATFORM "wayland;xcb"
        DISPLAY ":0"
        GTK_IM_MODULE "fcitx"
        QT_IM_MODULE "fcitx"
      }

      switch-events {
        lid-close { spawn "systemctl" "suspend"; }
        lid-open { spawn "notify-send" "The laptop lid is open!"; }
        tablet-mode-on { spawn "bash" "-c" "gsettings set org.gnome.desktop.a11y.applications screen-keyboard-enabled true"; }
        tablet-mode-off { spawn "bash" "-c" "gsettings set org.gnome.desktop.a11y.applications screen-keyboard-enabled false"; }
      }

      input {
        keyboard {
          xkb {
            layout "us"
            variant "altgr-intl"
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
        focus-follows-mouse max-scroll-amount="0%"
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

        // Window focus and movement bindings
        Mod+H { focus-column-or-monitor-left; }
        Mod+L { focus-column-or-monitor-right; }
        Mod+J { focus-window-or-workspace-down; }
        Mod+K { focus-window-or-workspace-up; }


        // Workspace focus
        Mod+W { focus-monitor-next; }
        Mod+Shift+W { focus-monitor-previous; }

        Mod+F11 { fullscreen-window; }
        Mod+slash { spawn "rofi" "-show" "drun"; }
        Mod+Shift+Q {close-window; }

        Mod+Shift+E allow-inhibiting=false { spawn "swaylock" "-f" "-i" "~/Pictures/wallpaper.jpg"; }

        // Run `wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.1+`.
        XF86AudioRaiseVolume { spawn "wpctl" "set-volume" "-l" "1.0" "@DEFAULT_AUDIO_SINK@" "5%+"; }
        XF86AudioLowerVolume { spawn "wpctl" "set-volume" "-l" "1.0" "@DEFAULT_AUDIO_SINK@" "5%-"; }
        XF86MonBrightnessDown { spawn "brightnessctl" "set" "5%-"; }
        XF86MonBrightnessUp { spawn "brightnessctl" "set" "5%+"; }


        XF86AudioMute allow-when-locked=true { spawn "wpctl" "set-mute" "@DEFAULT_AUDIO_SINK@" "toggle"; }
      }
    '';
}
