{ pkgs, ... }:
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
      mouse = true;
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
          set -g mouse on
          set -g set-clipboard on
          set -g status-bg  black
          set -g status-fg  green
          set -ga terminal-overrides ",*:Tc"
          set -s escape-time 10
          # setw -g mouse on

          # Vi mode settings
          # set-window-option -g mode-keys vi
          # bind-key -T copy-mode-vi v send-keys -X begin-selection
          # bind -T copy-mode-vi y send-keys -X copy-pipe-and-cancel 'xclip -in -selection clipboard'
        '';
    };

    sesh = {
      enable = true;
    };
  };

}
