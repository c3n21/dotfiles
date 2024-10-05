{
  config,
  pkgs,
  lib,
  outputs,
  inputs,
  ...
}: let
  cursor = {
    name = "Bibata-Modern-Classic";
    size = 16;
  };
  shell = "${pkgs.fish}/bin/fish";
  hyprland_session_target = "hyprland-session.target";
in {
  nixpkgs.config.allowUnfree = true;
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home = {
    stateVersion = "24.05"; # Please read the comment before changing.
    username = "zhifan";
    homeDirectory = "/home/zhifan";
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
      autoconnect = ["qemu:///system"];
      uris = ["qemu:///system"];
    };
  };

  # The home.packages option allows you to install Nix packages into your
  # environment.
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
    tmux
    libsForQt5.okular
    hyprpaper
    firefox
    git
    kitty
    distrobox
    rofi-wayland
    fish
    waybar
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
    jetbrains.idea-community
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
    psensor
    nwg-displays
    # dependency for nwg-displays
    wlr-randr
    vscode
    framework-tool
    devenv
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    ".tmux.conf".text = ''
      set-option -g default-shell "${shell}"
      ${builtins.readFile ./dotfiles/tmux.conf}
    '';

    # ".config/hypr/hyprland.conf".text = ''
    #   exec-once=${pkgs.libsForQt5.polkit-kde-agent}/libexec/polkit-kde-authentication-agent-1
    #   exec-once=${pkgs.libsForQt5.kwallet}/bin/kwalletd5 ${builtins.readFile ./dotfiles/hypr/hyprland.conf} '';

    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  xdg = {
    mimeApps = {
      associations = {
        added = {
          "inode/directory" = ["kitty-open.desktop"];
          "text/*" = ["nvim.desktop"];
          "default-web-browser" = ["firefox.desktop"];
          "text/html" = ["firefox.desktop"];
          "application/pdf" = ["firefox.desktop"];
          "x-scheme-handler/http" = ["firefox.desktop"];
          "x-scheme-handler/https" = ["firefox.desktop"];
          "x-scheme-handler/tg" = ["org.telegram.desktop.desktop"];
        };
      };
      enable = true;
      defaultApplications = {
        "inode/directory" = ["kitty-open.desktop"];
        "text/*" = ["nvim.desktop"];
        "default-web-browser" = ["firefox.desktop"];
        "text/html" = ["firefox.desktop"];
        "application/pdf" = ["firefox.desktop"];
        "x-scheme-handler/http" = ["firefox.desktop"];
        "x-scheme-handler/https" = ["firefox.desktop"];
        "x-scheme-handler/tg" = ["org.telegram.desktop.desktop"];
      };
    };
  };

  # TODO: to be solved
  # qt = {
  #   enable = true;
  #   platformTheme = "gtk";
  # };

  # Sometimes waybar and swayidle don't work properly because of this bug https://github.com/hyprwm/Hyprland/issues/4849
  # that causes Hyprland to crash and thus the services are not properly stopped.
  programs = {
    kitty = {
      enable = true;
      theme = "Belafonte Night";
      extraConfig = "
      shell ${shell}
      font_family Delugia Italic
      bold_font       Delugia Bold
      italic_font     Delugia Light Italic
      bold_italic_font Delugia Bold Italic

      font_features Delugia-Italic +ss01 +ss02 +ss19
      font_size        18

      enable_audio_bell no
      background_opacity 0.7

      confirm_os_window_close 1
      ";
    };
    # Let Home Manager install and manage itself.
    home-manager = {
      enable = true;
    };
    fish = {
      enable = true;
      interactiveShellInit = ''
        set -x theme_color_scheme nord
        fish_vi_key_bindings
          # Emulates vim's cursor shape behavior
          # Set the normal and visual mode cursors to a block
        set fish_cursor_default block
          # Set the insert mode cursor to a line
        set fish_cursor_insert line
          # Set the replace mode cursor to an underscore
        set fish_cursor_replace_one underscore
        bind -M insert \cf accept-autosuggestion
      '';
      shellAliases = {
        ls = "lsd";
        cat = "bat";
        vim = "nvim";
      };
      plugins = [
        rec {
          name = "fzf.fish";
          src = pkgs.fetchFromGitHub {
            owner = "PatrickF1";
            repo = name;
            rev = "main";
            sha256 = "/31pjXPTBw3VnA0jM6WlRCLVaG57LQNjVQhSc3Bd2o4=";
          };
        }
        rec {
          name = "theme-bobthefish";
          src = pkgs.fetchFromGitHub {
            owner = "oh-my-fish";
            repo = name;
            rev = "master";
            sha256 = "jiXzkW4H9YORR4iRNAfjlPT2jSyXQKmNx3WA+TjleE8=";
          };
        }
      ];
    };
    zoxide = {
      enable = true;
    };
    neovim = {
      enable = true;
      package = inputs.neovim-nightly-overlay.packages.${pkgs.system}.default;
      extraLuaPackages = ps: [ps.magick];
      # go is for nvim-dbee
      extraPackages = with pkgs; [lua51Packages.luarocks fswatch tree-sitter go];
      defaultEditor = true;
      # extraPackages = with pkgs; [lua51Packages.luarocks fswatch];
    };
  };
}
