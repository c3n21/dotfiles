{
  pkgs,
  inputs,
  ...
}: let
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
    homeDirectory = pkgs.lib.mkForce "/home/zhifan";
  };

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    git
    unzip
    jq
    btop
    file
    ripgrep
    fd
    fzf

    # workaround to make NeoVim work
    lua51Packages.luarocks
    gnumake
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

  # Sometimes waybar and swayidle don't work properly because of this bug https://github.com/hyprwm/Hyprland/issues/4849
  # that causes Hyprland to crash and thus the services are not properly stopped.
  programs = {
    ghostty = {
      enable = true;
      enableFishIntegration = true;
      settings = {
        background-blur-radius = 20; # Recommended value https://ghostty.org/docs/config/reference#background-blur-radius
        background-opacity = 0;
        font-family = "Delugia";
        font-feature = ["ss01" "ss02" "ss19"];
        font-style = "Italic";
        font-style-bold = "Bold Italic";
        font-style-bold-italic = "Bold Italic";
        font-style-italic = "Italic";
        gtk-single-instance = true;
        window-decoration = false;
      };
    };
    tmux = {
      enable = true;
      baseIndex = 1;
      clock24 = true;
      prefix = "C-a";
      # Less secure but it persists the session across user login and logout
      secureSocket = false;
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
      shell = "${pkgs.fish}/bin/fish";
      newSession = true;
      extraConfig = ''
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
      font_size        14

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
        fish_default_key_bindings
        if not set -q NVIM
          fish_vi_key_bindings

          # Emulates vim's cursor shape behavior
          # Set the normal and visual mode cursors to a block
          set fish_cursor_default block

          # Set the insert mode cursor to a line
          set fish_cursor_insert line

          # Set the replace mode cursor to an underscore
          set fish_cursor_replace_one underscore
        end

        bind -M insert \cf accept-autosuggestion
      '';
      plugins = with pkgs; [
        {
          name = "fzf.fish";
          src = fishPlugins.fzf-fish.src;
        }
        {
          name = "bobthefish";
          src = fishPlugins.bobthefish.src;
        }
      ];
    };
    zoxide = {
      enable = true;
    };
    neovim = {
      viAlias = true;
      vimAlias = true;
      vimdiffAlias = true;
      enable = true;
      package = inputs.neovim-nightly-overlay.packages.${pkgs.system}.default;
      extraLuaPackages = ps: [ps.magick];
      # go is for nvim-dbee
      extraPackages = with pkgs; [
        prettierd
        terraform-ls
        terraform-lsp
        nodejs
        lua51Packages.luarocks
        fswatch
        tree-sitter
        go
        python3
        luajitPackages.lua-lsp
        vscode-langservers-extracted
        deno
        astro-language-server
        jdt-language-server
        typescript-language-server
      ];
      plugins = with pkgs; [
        # parsers
        vimPlugins.nvim-treesitter-parsers.javascript
        vimPlugins.nvim-treesitter-parsers.java
        vimPlugins.nvim-treesitter-parsers.jsdoc
        vimPlugins.nvim-treesitter-parsers.tsx
        vimPlugins.nvim-treesitter-parsers.typescript
        vimPlugins.nvim-treesitter-parsers.astro
        vimPlugins.nvim-treesitter-parsers.nix
        vimPlugins.nvim-treesitter-parsers.terraform

        vimPlugins.nvim-treesitter-parsers.lua
        vimPlugins.nvim-treesitter-parsers.luadoc
        vimPlugins.nvim-treesitter-parsers.norg

        # nvim-java dep
        vimPlugins.nui-nvim
        vimPlugins.mason-nvim
        vimPlugins.mason-lspconfig-nvim

        vimPlugins.nvim-java

        (
          pkgs.vimUtils.buildVimPlugin rec {
            name = "spring-boot.nvim";
            doCheck = false;
            src = pkgs.fetchFromGitHub {
              owner = "JavaHello";
              repo = name;
              rev = "21483b5cf3dd4bfa16f498f7a28d11e7b34aa2ec";
              hash = "sha256-Fa0htsbWlInuZf7QE7F+CmStyBuZNwDsDHWPhfrsKHI=";
            };
          }
        )

        vimPlugins.luasnip
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
    };
  };
}
