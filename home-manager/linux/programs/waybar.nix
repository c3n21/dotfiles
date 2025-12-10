{ pkgs, ... }:
let
  catppuccin = pkgs.fetchFromGitHub {
    owner = "catppuccin";
    repo = "waybar";
    rev = "v1.1";
    hash = "sha256-9lY+v1CTbpw2lREG/h65mLLw5KuT8OJdEPOb+NNC6Fo=";
  };
in
{
  programs = {
    waybar = {
      enable = true;
      systemd.enable = true;
      settings = {
        mainBar = {
          "layer" = "top"; # Waybar at top layer
          # "position": "bottom", // Waybar position (top|bottom|left|right)
          # "height": 30, // Waybar height (to be removed for auto height)
          # "width": 1280, // Waybar width
          "spacing" = 4; # Gaps between modules (4px)
          # Choose the order of the modules

          "modules-left" = [ "hyprland/workspaces" ];

          "modules-center" = [ "hyprland/window" ];

          "modules-right" = [
            "battery"
            "idle_inhibitor"
            "tray"
            "disk"
            "pulseaudio"
            "clock"
          ];

          "hyprland/workspaces" = {
            "format" = "{name}: {icon}";
            "format-icons" = {
              # "1": "",
              # "2": "",
              # "3": "",
              # "4": "",
              # "5": "",
              "active" = "";
              "default" = "";
              "urgent" = "";
              # "active"= ""; # focused workspace on current monitor
              "visible" = ""; # focused workspace on other monitors
              # "default"= "";
              "empty" = ""; # persistent (created by this plugin)
            };
            "all-outputs" = false; # recommended
          };

          # Modules configuration
          "keyboard-state" = {
            "numlock" = true;
            "capslock" = true;
            "format" = "{name} {icon}";
            "format-icons" = {
              "locked" = "";
              "unlocked" = "";
            };
          };

          "disk" = {
            "interval" = 30;
            "format" = "{path}: {percentage_used}%";
            "path" = "/";
          };

          "disk#home" = {
            "interval" = 30;
            "format" = "{path}: {percentage_used}%";
            "path" = "/home";
          };

          "sway/mode" = {
            "format" = "<span style=\"italic\">{}</span>";
          };

          "mpd" = {
            "format" =
              "{stateIcon} {consumeIcon}{randomIcon}{repeatIcon}{singleIcon}{artist} - {album} - {title} ({elapsedTime:%M:%S}/{totalTime:%M:%S}) ⸨{songPosition}|{queueLength}⸩ {volume}% ";
            "format-disconnected" = "Disconnected ";
            "format-stopped" = "{consumeIcon}{randomIcon}{repeatIcon}{singleIcon}Stopped ";
            "unknown-tag" = "N/A";
            "interval" = 2;
            "consume-icons" = {
              "on" = " ";
            };
            "random-icons" = {
              "off" = "<span color=\"#f53c3c\"></span> ";
              "on" = " ";
            };
            "repeat-icons" = {
              "on" = " ";
            };
            "single-icons" = {
              "on" = "1 ";
            };
            "state-icons" = {
              "paused" = "";
              "playing" = "";
            };
            "tooltip-format" = "MPD (connected)";
            "tooltip-format-disconnected" = "MPD (disconnected)";
          };

          "idle_inhibitor" = {
            "format" = "{icon}";
            "format-icons" = {
              "activated" = "";
              "deactivated" = "";
            };
          };

          "tray" = {
            "icon-size" = 15;
            "spacing" = 10;
          };

          "clock#calendar" = {
            "tooltip-format" = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
            "format" = "{:%Y-%m-%d}";
          };

          "cpu" = {
            "format" = "{usage}% ";
            "tooltip" = false;
          };

          "memory" = {
            "format" = "{}% ";
          };

          "temperature" = {
            # "thermal-zone": 2,
            # "hwmon-path": "/sys/class/hwmon/hwmon2/temp1_input",
            "critical-threshold" = 80;
            # "format-critical": "{temperatureC}°C {icon}",
            "format" = "{temperatureC}°C {icon}";
            "format-icons" = [
              ""
              ""
              ""
            ];
          };

          "backlight" = {
            # "device": "acpi_video1",
            "format" = "{percent}% {icon}";
            "format-icons" = [
              ""
              ""
              ""
              ""
              ""
              ""
              ""
              ""
              ""
            ];
          };

          "battery" = {
            "states" = {
              # "good": 95,
              "warning" = 30;
              "critical" = 15;
            };
            "format" = "{capacity}% {icon}";
            "format-charging" = "{capacity}% ";
            "format-plugged" = "{capacity}% ";
            "format-alt" = "{time} {icon}";
            # "format-good": "", // An empty format will hide the module
            # "format-full": "",
            "format-icons" = [
              ""
              ""
              ""
              ""
              ""
            ];
          };

          "battery#bat2" = {
            "bat" = "BAT2";
          };

          "network" = {
            # "interface": "wlp2*", // (Optional) To force the use of this interface
            #"format-wifi": "{essid} ({signalStrength}%) ",
            "format-wifi" = "{signalStrength}% ";
            "format-ethernet" = "";
            "tooltip-format" = "{ifname} via {gwaddr} , {ipaddr}/{cidr}";
            "format-linked" = "{ifname} (No IP) ";
            "format-disconnected" = "Disconnected ⚠";
            #"format-alt": "{ifname}: {ipaddr}/{cidr}",
            "on-click" = "wofi-wifi.sh"; # https://raw.githubusercontent.com/cristobaltapia/dotfiles_sway/master/home/.config/wofi/scripts/wofi-wifi.sh
            #"on-click": "nmtui",
          };
          "pulseaudio" = {
            # "scroll-step": 1, // %, can be a float
            "format" = "{volume}% {icon} {format_source}";
            "format-bluetooth" = "{volume}% {icon} {format_source}";
            "format-bluetooth-muted" = " {icon} {format_source}";
            "format-muted" = " {format_source}";
            "format-source" = "{volume}% ";
            "format-source-muted" = "";
            "format-icons" = {
              "headphone" = "";
              "hands-free" = "";
              "headset" = "";
              "phone" = "";
              "portable" = "";
              "car" = "";
              "default" = [
                ""
                ""
                ""
              ];
            };
            "on-click" = "pavucontrol";
          };
        };
      };
      style =
        # css
        ''
          @import "${catppuccin}/themes/macchiato.css";

          * {
            font-family: Delugia;
            font-size: 13px;
            min-height: 0;
            padding: 1px 4px;
            color: @text;
          }

          window#waybar {
            /* you can also GTK3 CSS functions! */
            background-color: shade(@base, 0.9);
            border: 2px solid alpha(@crust, 0.3);
          }
        '';
    };
  };
}
