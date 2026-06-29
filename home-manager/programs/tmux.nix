{ pkgs, ... }:
let
  copyCommand = "${pkgs.wl-clipboard}/bin/wl-copy";
in
{
  programs = {
    tmux = {
      enable = true;
      baseIndex = 1;
      clock24 = true;
      prefix = "M-a";
      # Less secure but it persists the session across user login and logout
      secureSocket = false;
      terminal = "tmux-256color";
      shell = "${pkgs.fish}/bin/fish";
      newSession = true;
      focusEvents = true;
      historyLimit = 50000;
      keyMode = "vi";
      mouse = true; # TODO: to be disabled # to allow Ctrl + Click to work in Ghostty
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
      extraConfig = # tmux
        ''
          # Global settings

          # set -g set-clipboard external # should be the default
          set -s copy-command '${copyCommand}'
          set -g status-bg  black
          set -g status-fg  green
          set -ga terminal-overrides ",*:Tc"
          set -s escape-time 10
          set -g allow-passthrough on

          # tmux forwards modified keys in CSI-u format, which is the most reliable configuration
          set -g extended-keys on
          set -g extended-keys-format csi-u

          # setw -g mouse on

          # Vi mode settings
          bind -T copy-mode-vi y send-keys -X copy-selection
        '';
    };

    sesh = {
      enable = true;
    };
  };

}
