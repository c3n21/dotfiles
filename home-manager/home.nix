# Every home should at least contain these configuration.
# This contains the basic CLI tools that I always need
{
  pkgs,
  inputs,
  ...
}:
{
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
    shell = {
      enableFishIntegration = true;
    };
  };

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    inputs.nvim-configuration.packages.${pkgs.system}.note
    inputs.nvim-configuration.packages.${pkgs.system}.vi
    # TODO: move somewhere else
    radeontop
    dnsutils
    usbutils
    exfatprogs
    nmap
    lsof
    btop
    powertop
    nix-tree
    unzip
    jq
    btop
    file
    ripgrep
    vscode
    ripgrep-all
    yt-dlp
    htop
    socat
    gitflow
  ];

  programs = {
    git = {
      enable = true;
    };

    lsd = {
      enable = true;
      enableFishIntegration = true;
    };

    tmux = {
      enable = true;
      baseIndex = 1;
      clock24 = true;
      prefix = "M-a";
      # Less secure but it persists the session across user login and logout
      secureSocket = false;
      plugins = with pkgs; [
        tmuxPlugins.sensible
        {
          plugin = tmuxPlugins.mkTmuxPlugin rec {
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

    fd = {
      enable = true;
    };

    bat = {
      enable = true;
    };

    sesh = {
      enable = true;
    };

    fzf = {
      enable = true;
      enableFishIntegration = true;
      tmux.enableShellIntegration = true;
    };

    # TODO: refactor inside nvim-configuration
    neovim = {
      vimdiffAlias = true;
    };
  };
}
