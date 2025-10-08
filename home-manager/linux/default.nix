# This is needed only for full blown Linux systems.
# It contains cursor, services and programs configuration needed to make
# a Linux machine more comfortable.
{
  pkgs,
  inputs,
  ...
}:
let
  shell = "${pkgs.fish}/bin/fish";
in
rec {
  home.sessionVariables = {
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
    EDITOR = "${inputs.nvim-configuration.packages.${pkgs.system}.vi.outPath}/bin/vi";
  };

  xdg = {
    mimeApps = {
      enable = true;
      defaultApplications = {
        "inode/directory" = [ "kitty-open.desktop" ];
        "text/*" = [ "nvim.desktop" ];
        "default-web-browser" = [
          "librewolf.desktop"
        ];
        "application/pdf" = [
          "librewolf.desktop"
        ];
        "text/html" = [
          "librewolf.desktop"
        ];
        "text/xml" = [
          "librewolf.desktop"
        ];
        "application/xhtml+xml" = [
          "librewolf.desktop"
        ];
        "application/vnd.mozilla.xul+xml" = [
          "librewolf.desktop"
        ];
        "x-scheme-handler/http" = [
          "librewolf.desktop"
        ];
        "x-scheme-handler/https" = [
          "librewolf.desktop"
        ];
        "x-scheme-handler/tg" = [ "org.telegram.desktop.desktop" ];
      };
    };
  };

  home = {
    pointerCursor = {
      gtk.enable = true;
      x11.enable = true;
      name = "phinger-cursors-light";
      package = pkgs.phinger-cursors;
      size = 32;
    };
  };

  qt = {
    enable = true;
    platformTheme.name = "xdgdesktopportal";
  };

  gtk = {
    enable = true;
    cursorTheme = {
      package = home.pointerCursor.package;
      name = home.pointerCursor.name;
      size = home.pointerCursor.size;
    };
    theme = {
      package = pkgs.flat-remix-gtk;
      name = "Flat-Remix-GTK-Blue-Dark-Solid";
    };
    iconTheme = {
      package = pkgs.libsForQt5.breeze-icons;
      name = "breeze-dark";
    };
    font = {
      name = "Sans";
      size = 11;
    };
  };

  # this is needed to declaratively manage connection to qemu in virt-manager
  # https://nixos.wiki/wiki/Virt-manager
  dconf.settings = {
    "org/virt-manager/virt-manager/connections" = {
      autoconnect = [ "qemu:///system" ];
      uris = [ "qemu:///system" ];
    };
    # for brave's dark mode https://github.com/brave/brave-browser/issues/30766
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
    };
  };

  home.packages = with pkgs; [
    bitwarden-desktop
    baobab
    steam
    brave
    scrcpy
    remmina
    # https://discourse.nixos.org/t/virt-manager-cannot-find-virtiofsd/26752
    virtiofsd
    libreoffice-fresh
    # mpvpaper # sometimes I may want to have it again
    mpv
    networkmanagerapplet
    kdePackages.polkit-kde-agent-1
    nwg-look
    kdePackages.okular
    firefox
    rofi
    wl-clipboard
    killall
    pavucontrol
    # TODO: currently broken
    # jetbrains.idea-community-bin
    telegram-desktop
    zbar
    chromium
    google-chrome
    lm_sensors
    framework-tool
    # wechat-uos # 403 error
    brightnessctl
    adbfs-rootless
    localsend
    microsoft-edge
  ];

  services = {
    gammastep = {
      enable = true;
      latitude = 45.45862600;
      longitude = 9.18187300;
      tray = true;
    };

    hyprpaper = {
      enable = true;
      settings = {
        ipc = "off";

        preload = [
          "~/Pictures/wallpaper.jpg"
        ];

        wallpaper = [
          "eDP-1,~/Pictures/wallpaper.jpg"
          ",~/Pictures/wallpaper.jpg"
        ];
      };
    };

    blueman-applet = {
      enable = true;
    };

    network-manager-applet = {
      enable = true;
    };

    swaync = {
      enable = true;
    };

    kanshi = {
      enable = true;
      systemdTarget = "graphical-session.target";
      settings = [
        {
          profile = {
            name = "laptop";
            outputs = [
              {
                criteria = "eDP-1";
              }
            ];
          };
        }
        {
          profile = {
            name = "home";
            outputs = [
              {
                criteria = "eDP-1";
                position = "296,720";
              }
              {
                criteria = "LG Electronics LG ULTRAGEAR 208NTVS0P575";
                position = "0,0";
                scale = 2.0;
                mode = "3440x1440@85.00Hz";
              }
            ];
          };
        }
        {
          profile = {
            name = "home2";
            outputs = [
              {
                criteria = "eDP-1";
                position = "0,0";
              }
              {
                criteria = "Samsung Electric Company S24F350 H4ZH808827";
                position = "1128,164";
                scale = 1.0;
                mode = "1920x1080@71.91Hz";
              }
            ];
          };
        }

      ];
    };

    swayidle = {
      enable = true;
      events = [
        {
          event = "before-sleep";
          command = "${pkgs.swaylock}/bin/swaylock -fF -i ~/Pictures/wallpaper.jpg";
        }
        {
          event = "lock";
          command = "lock";
        }
      ];
    };
  };

  programs = {

    swaylock = {
      enable = true;
    };

    waybar = {
      enable = true;
      systemd.enable = true;
    };

    ghostty = {
      enable = true;
      enableFishIntegration = true;
      settings = {
        background-blur-radius = 20; # Recommended value https://ghostty.org/docs/config/reference#background-blur-radius
        background-opacity = 0.65;
        font-family = "Delugia";
        font-feature = [
          "ss01"
          "ss02"
          "ss19"
        ];
        font-style = "Italic";
        font-style-bold = "Bold Italic";
        font-style-bold-italic = "Bold Italic";
        font-style-italic = "Italic";
        gtk-single-instance = true;
        window-decoration = false;
        keybind = [
          "ctrl+enter=unbind"
        ];
      };
    };

    librewolf = {
      enable = true;
      # Enable WebGL, cookies and history
      settings = {
        "webgl.disabled" = false;
        "privacy.resistFingerprinting" = false;
        "privacy.clearOnShutdown.history" = false;
        "privacy.clearOnShutdown.cookies" = false;
        "network.cookie.lifetimePolicy" = 0;
      };
    };

    obs-studio = {
      enable = true;
    };

    kitty = {
      enable = true;
      themeFile = "Belafonte_Night";
      extraConfig = "
      shell ${shell}
      font_family Delugia Italic
      bold_font       Delugia Bold
      italic_font     Delugia Light Italic
      bold_italic_font Delugia Bold Italic

      font_features Delugia-Italic +ss01 +ss02 +ss19
      font_size        14

      enable_audio_bell no
      background_opacity 0.7

      confirm_os_window_close 1
      ";
    };

    neovide = {
      enable = true;
      settings = {
        fork = false;
        neovim-bin = "${inputs.nvim-configuration.packages.${pkgs.system}.neo}/bin/neo";
        frame = "full";
        idle = true;
        maximized = false;
        no-multigrid = false;
        srgb = false;
        tabs = true;
        theme = "auto";
        vsync = false;
        title-hidden = true;
        font = {
          normal = {
            family = "Delugia";
            style = "Italic";
          };
          size = 14.0;
          features = {
            Delugia = [
              "ss01"
              "ss02"
              "ss19"
            ];
          };
        };
      };
    };
  };
}
