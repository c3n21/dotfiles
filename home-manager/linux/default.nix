{
  pkgs,
  inputs,
  ...
}: let
  cursor = {
    name = "Bibata-Modern-Classic";
    size = 16;
  };
in {
  specialisation = import ./specialisations.nix {inherit pkgs inputs;};
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

  # this is needed to declaratively manage connection to qemu in virt-manager
  # https://nixos.wiki/wiki/Virt-manager
  dconf.settings = {
    "org/virt-manager/virt-manager/connections" = {
      autoconnect = ["qemu:///system"];
      uris = ["qemu:///system"];
    };
  };

  home.packages = with pkgs; [
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
    nixd
    libsForQt5.okular
    hyprpaper
    firefox
    git
    distrobox
    rofi-wayland
    fish
    zoxide
    lsd
    bat
    ripgrep
    fzf
    nodejs
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
    lua-language-server
    selene
    stylua
    chromium
    usbutils
    lua51Packages.luarocks
    testdisk-qt
    gparted
    exfatprogs
    nmap
    discord
    typescript
    lsof
    eslint_d
    microsoft-edge
    google-chrome
    jdk17
    wget
    btop
    powertop
    lm_sensors
    sbt
    prettierd
    file
    nwg-displays
    # dependency for nwg-displays
    wlr-randr
    vscode
    framework-tool
    devenv
    wechat-uos
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
