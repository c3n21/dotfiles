# This is needed only for full blown Linux systems
{
  pkgs,
  inputs,
  ...
}:
let
  edge_flake = import inputs.edge {
    system = pkgs.system;
    config.allowUnfree = true;
  };
in
rec {
  home.sessionVariables = {
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
    EDITOR = "${inputs.nvim-configuration.packages.${pkgs.system}.vi.outPath}/bin/vi";
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

  home.packages =
    (with pkgs; [
      bitwarden-desktop
      baobab
      steam
      brave
      scrcpy
      ripgrep-all
      remmina
      # https://discourse.nixos.org/t/virt-manager-cannot-find-virtiofsd/26752
      virtiofsd
      libreoffice-fresh
      # mpvpaper # sometimes I may want to have it again
      yt-dlp
      socat
      mpv
      htop
      gitflow
      dunst
      networkmanagerapplet
      kdePackages.polkit-kde-agent-1
      nwg-look
      libsForQt5.okular
      firefox
      git
      rofi-wayland
      zoxide
      lsd
      bat
      ripgrep
      fzf
      fd
      wl-clipboard
      killall
      pavucontrol
      # TODO: currently broken
      # jetbrains.idea-community-bin
      telegram-desktop
      dnsutils
      unzip
      zbar
      jq
      chromium
      usbutils
      exfatprogs
      nmap
      lsof
      google-chrome
      btop
      powertop
      lm_sensors
      sbt
      file
      framework-tool
      wechat-uos
      brightnessctl
      adbfs-rootless
      mgba
      localsend
    ]

    )
    ++ [
      # edge_flake.legacyPackages.${pkgs.system}.microsoft-edge
      edge_flake.microsoft-edge
    ];

  services = {
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
    sesh = {
      enable = true;
    };

    fzf = {
      enable = true;
      enableFishIntegration = true;
      tmux.enableShellIntegration = true;
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

  };
}
