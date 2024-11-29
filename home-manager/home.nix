{
  pkgs,
  inputs,
  ...
}: let
  cursor = {
    name = "Bibata-Modern-Classic";
    size = 16;
  };
  shell = "${pkgs.fish}/bin/fish";
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

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    ripgrep-all
    libreoffice-fresh
    yt-dlp
    socat
    mpv
    htop
    nixd
    tmux
    firefox
    git
    kitty
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
    gcc
    killall
    telegram-desktop
    unzip
    zbar
    jq
    lua-language-server
    selene
    stylua
    chromium
    usbutils
    lua51Packages.luarocks
    gparted
    exfatprogs
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
    vscode
    framework-tool
    devenv
    logisim
    qbittorrent
    spotify
  ];

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
    tmux = {
      enable = true;
      baseIndex = 1;
      clock24 = true;
      prefix = "C-a";
      plugins = with pkgs; [
        tmuxPlugins.sensible
        {
          plugin =
            tmuxPlugins.mkTmuxPlugin
            rec {
              pluginName = "tmux-themepack";
              version = "1.1.0";
              rtpFilePath = "themepack.tmux";
              src = fetchFromGitHub {
                owner = "jimeh";
                repo = "tmux-themepack";
                rev = version;
                hash = "sha256-f6y92kYsKDFanNx5ATx4BkaB/E7UrmyIHU/5Z01otQE=";
              };
            };
          extraConfig = ''
            set -g @themepack 'powerline/double/cyan'
          '';
        }
      ];
      extraConfig = ''
        set-option -g default-shell ${pkgs.fish}/bin/fish

        # Customize the status line
        set -g status-fg  green
        set -g status-bg  black
        setw -g mouse on

        #Set theme
        set-window-option -g mode-keys vi
        bind-key -T copy-mode-vi v send-keys -X begin-selection
        bind -T copy-mode-vi y send-keys -X copy-pipe-and-cancel 'xclip -in -selection clipboard'
      '';
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
      extraPackages = with pkgs; [lua51Packages.luarocks fswatch tree-sitter go python3 luajitPackages.lua-lsp];
      plugins = with pkgs; [
        vimPlugins.SchemaStore-nvim
        vimPlugins.auto-session
        vimPlugins.cmp-buffer
        vimPlugins.cmp-dap
        vimPlugins.cmp-nvim-lsp
        vimPlugins.cmp-nvim-lsp-signature-help
        vimPlugins.cmp_luasnip
        vimPlugins.comment-nvim
        vimPlugins.conform-nvim
        vimPlugins.copilot-cmp
        vimPlugins.copilot-lua
        vimPlugins.diffview-nvim
        vimPlugins.dropbar-nvim
        vimPlugins.flutter-tools-nvim
        vimPlugins.gitsigns-nvim
        vimPlugins.inc-rename-nvim
        vimPlugins.indent-blankline-nvim
        vimPlugins.lazydev-nvim
        vimPlugins.lsp_lines-nvim
        vimPlugins.lualine-nvim
        vimPlugins.neogit
        vimPlugins.neorg
        vimPlugins.nvim-autopairs
        vimPlugins.nvim-cmp
        vimPlugins.nvim-dap
        vimPlugins.nvim-dbee
        vimPlugins.nvim-lspconfig
        vimPlugins.nvim-surround
        vimPlugins.nvim-treesitter
        vimPlugins.nvim-treesitter-textobjects
        vimPlugins.nvim-ts-autotag
        vimPlugins.nvim-ts-context-commentstring
        vimPlugins.nvim-web-devicons
        vimPlugins.oil-nvim
        vimPlugins.otter-nvim
        vimPlugins.sleuth
        vimPlugins.telescope-fzf-native-nvim
        vimPlugins.telescope-nvim
        vimPlugins.telescope-ui-select-nvim
        vimPlugins.typescript-tools-nvim
        vimPlugins.vim-fugitive
        vimPlugins.vim-illuminate
        vimPlugins.vim-matchup
      ];
      defaultEditor = true;
      # extraPackages = with pkgs; [lua51Packages.luarocks fswatch];
    };
  };
}
