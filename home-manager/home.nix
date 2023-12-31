{ config, pkgs, lib, outputs, inputs, ... }:
let
  cursor = {
    name = "Bibata-Modern-Classic";
    size = 16;
  };
  shell = "${pkgs.fish}/bin/fish";
in
{
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
    stateVersion = "22.11"; # Please read the comment before changing.
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

  nixpkgs = {
    overlays = [
      # Add overlays your own flake exports (from overlays and pkgs dir):
      outputs.overlays.modifications
      outputs.overlays.unstable-packages
      # neovim-nightly-overlay.overlays.default

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    ];
  };

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    mpv
    htop
    erlfmt
    erlang
    erlang-ls
    gitflow
    dunst
    networkmanagerapplet
    libsForQt5.polkit-kde-agent
    grimblast
    nwg-look
    pkgs.neovim-nightly
    nixd
    nixpkgs-fmt
    tmux
    libsForQt5.okular
    hyprpaper
    firefox
    git
    kitty
    distrobox
    rofi
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
    ocamlPackages.ocaml-lsp
    ocamlPackages.ocamlformat
    dnsutils
    unzip
    zbar
    way-displays
    jq
    lua-language-server
    selene
    stylua
    chromium
    usbutils
    nodePackages_latest.pnpm
    vscode-langservers-extracted
    discord
    typescript
    lsof
    eslint_d
    tailwindcss-language-server
    microsoft-edge
    google-chrome
    jdk17
    coursier
    scala
    scalafmt
    wget
    btop
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    ".tmux.conf".text = ''
      set-option -g default-shell "${shell}"
      ${builtins.readFile ./dotfiles/tmux.conf}
    '';

    ".config/kitty/kitty.conf".text = ''
      shell ${shell}
      ${builtins.readFile ./dotfiles/kitty/kitty.conf}
    '';

    ".config/hypr/hyprland.conf".text = ''
      exec-once=${pkgs.libsForQt5.polkit-kde-agent}/libexec/polkit-kde-authentication-agent-1
      exec-once=${pkgs.libsForQt5.kwallet}/bin/kwalletd5
      ${builtins.readFile ./dotfiles/hypr/hyprland.conf}
    '';
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

  # TODO: to be solved
  # qt = {
  #   enable = true;
  #   platformTheme = "gtk";
  # };

  programs =
    {
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
    };
}
