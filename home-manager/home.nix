# Every home should at least contain these configuration.
# This contains the basic CLI tools that I always need
{
  pkgs,
  inputs,
  config,
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
  # TODO: this should be refactored to be home configuration specific
  home = {
    stateVersion = "24.05"; # Please read the comment before changing.
    username = "zhifan";
    homeDirectory = pkgs.lib.mkForce "/home/zhifan";
    shell = {
      enableFishIntegration = true;
    };
  };

  imports = [
    ./programs/tmux.nix
    ./programs/pi.nix
  ];

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    dnsutils
    usbutils
    exfatprogs
    nmap
    lsof
    btop
    powertop
    nix-tree
    zip
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
    # My custom NeoVim package
    neo
    note
  ];

  programs = {
    git = {
      enable = true;
      package = pkgs.gitFull;
      settings = {
        credential.helper = "libsecret";
      };
    };

    lsd = {
      enable = true;
      enableFishIntegration = true;
    };

    starship = {
      enable = true;
      enableInteractive = true;
      enableFishIntegration = true;
      settings = {
        hostname = {
          ssh_only = false;
          disabled = false;
        };
      };
    };

    # Let Home Manager install and manage itself.
    home-manager = {
      enable = true;
    };

    fish = {
      enable = true;

      functions = {
        # fish_user_key_bindings = {
        #   body =
        #     # fish
        #     ''
        #       if not set -q NVIM
        #         fish_vi_key_bindings

        #         # Emulates vim's cursor shape behavior
        #         # Set the normal and visual mode cursors to a block
        #         set fish_cursor_default block

        #         # Set the insert mode cursor to a line
        #         set fish_cursor_insert line

        #         # Set the replace mode cursor to an underscore
        #         set fish_cursor_replace_one underscore
        #       else
        #         fish_default_key_bindings
        #       end
        #     '';
        # };
      };

      interactiveShellInit =
        # fish
        ''
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
      plugins = with pkgs; [
        {
          name = "fzf.fish";
          src = fishPlugins.fzf-fish.src;
        }
        # {
        #   name = "bobthefish";
        #   src = fishPlugins.bobthefish.src;
        # }
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
      # this overrides some default bindings
      enableFishIntegration = false;
      enableNushellIntegration = false;
      tmux.enableShellIntegration = true;
    };
  };
}
