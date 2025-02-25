# This is needed only for full blown Linux systems
{
  pkgs,
  inputs,
  ...
}:
let
  cursor = {
    name = "Bibata-Modern-Classic";
    size = 16;
  };
in
{
  specialisation = import ./specialisations.nix { inherit pkgs inputs; };
  home.sessionVariables = {
    XCURSOR_SIZE = cursor.size;
    XMODIFIERS = "@im=fcitx";
    XMODIFIER = "@im=fcitx";
    GTK_IM_MODULE = "fcitx";
    QT_IM_MODULE = "fcitx";
    GDK_BACKEND = "wayland,x11";
    SDL_VIDEODRIVER = "wayland";
    CLUTTER_BACKEND = "wayland";
    XDG_CURRENT_DESKTOP = "Hyprland";
    XDG_SESSION_TYPE = "wayland";
    XDG_SESSION_DESKTOP = "Hyprland";
    # QT_AUTO_SCREEN_SCALE_FACTOR = 1;
    QT_QPA_PLATFORM = "wayland;xcb";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
    EDITOR = "nvim";
  };

  home = {
    pointerCursor = {
      gtk.enable = true;
      x11.enable = true;
      package = pkgs.bibata-cursors;
      name = cursor.name;
      size = cursor.size;
    };
  };

  gtk = {
    enable = true;
    theme = {
      package = pkgs.flat-remix-gtk;
      name = "Flat-Remix-GTK-Grey-Darkest";
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
    baobab
    steam
    swaylock
    swayidle
    brave
    scrcpy
    ripgrep-all
    remmina
    # https://discourse.nixos.org/t/virt-manager-cannot-find-virtiofsd/26752
    virtiofsd
    libreoffice-fresh
    mpvpaper
    yt-dlp
    socat
    wineWowPackages.waylandFull
    mpv
    htop
    gitflow
    dunst
    networkmanagerapplet
    libsForQt5.polkit-kde-agent
    grimblast
    nwg-look
    libsForQt5.okular
    hyprpaper
    firefox
    git
    distrobox
    rofi-wayland
    zoxide
    lsd
    bat
    ripgrep
    fzf
    gnumake
    sqlite
    fd
    wl-clipboard
    gcc
    killall
    pavucontrol
    jetbrains.idea-community-bin
    telegram-desktop
    # https://github.com/NixOS/nixpkgs/issues/34603#issuecomment-1025616898
    # this fixes cursor issue on firefox at least
    dnsutils
    unzip
    zbar
    jq
    chromium
    usbutils
    testdisk-qt
    gparted
    exfatprogs
    nmap
    discord
    lsof
    microsoft-edge
    google-chrome
    wget
    btop
    powertop
    lm_sensors
    sbt
    file
    nwg-displays
    # dependency for nwg-displays
    wlr-randr
    vscode
    framework-tool
    devenv
    qbittorrent
    spotify
    wechat-uos
    brightnessctl
    adbfs-rootless
    mgba
    localsend
  ];

  services = {
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
                position = "1128,106";
                scale = 2.0;
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
    waybar = {
      enable = true;
      systemd.enable = true;
    };
  };
}
