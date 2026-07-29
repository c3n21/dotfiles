# This is needed only for full blown Linux systems.
# It contains cursor, services and programs configuration needed to make
# a Linux machine more comfortable.
{
  pkgs,
  config,
  ...
}:
let
  shell = "${pkgs.fish}/bin/fish";
in
rec {
  home.sessionVariables = {
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
    EDITOR = "${pkgs.neo}/bin/neo";
  };

  xdg = {
    mimeApps = {
      enable = true;
      defaultApplications = {
        "inode/directory" = [ "kitty-open.desktop" ];
        "text/*" = [ "nvim.desktop" ];
        "default-web-browser" = [
          "librewolf.desktop"
        ];
        "application/pdf" = [
          "librewolf.desktop"
        ];
        "text/html" = [
          "librewolf.desktop"
        ];
        "text/xml" = [
          "librewolf.desktop"
        ];
        "application/xhtml+xml" = [
          "librewolf.desktop"
        ];
        "application/vnd.mozilla.xul+xml" = [
          "librewolf.desktop"
        ];
        "x-scheme-handler/http" = [
          "librewolf.desktop"
        ];
        "x-scheme-handler/https" = [
          "librewolf.desktop"
        ];
      };
    };
  };

  home = {
    pointerCursor = {
      enable = true;
      gtk.enable = true;
      x11.enable = true;
      name = "phinger-cursors-light";
      package = pkgs.phinger-cursors;
      size = 32;
    };
  };

  qt = {
    enable = true;
    platformTheme.name = "xdgdesktopportal";
  };

  gtk = {
    enable = true;
    cursorTheme = {
      package = home.pointerCursor.package;
      name = home.pointerCursor.name;
      size = home.pointerCursor.size;
    };
    gtk4.theme = config.gtk.theme;
    gtk3.extraCss = ''
      @binding-set no-emoji {
        unbind "<Control>period";
        unbind "<Control>semicolon";
      }

      entry,
      textview {
        -gtk-key-bindings: no-emoji;
      }
    '';
    theme = {
      package = pkgs.flat-remix-gtk;
      name = "Flat-Remix-GTK-Blue-Dark-Solid";
    };
    iconTheme = {
      package = pkgs.kdePackages.breeze-icons;
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
    brave
    scrcpy
    remmina
    # https://discourse.nixos.org/t/virt-manager-cannot-find-virtiofsd/26752
    virtiofsd
    libreoffice-fresh
    # mpvpaper # sometimes I may want to have it again
    mpv
    nwg-look
    kdePackages.okular
    firefox
    wl-clipboard
    killall
    pavucontrol
    zbar
    chromium
    google-chrome
    lm_sensors
    # wechat-uos # 403 error
    microsoft-edge
    obsidian
    dbeaver-bin
    waypipe
  ];

  programs = {
    direnv = {
      enable = true;
      nix-direnv = {
        enable = true;
      };
    };

    ghostty = {
      enable = true;
      enableFishIntegration = true;
      settings = {
        background-blur-radius = 20; # Recommended value https://ghostty.org/docs/config/reference#background-blur-radius
        background-opacity = 0.65;
        font-family = "Delugia";
        font-feature = [
          "ss01"
          "ss02"
          "ss19"
        ];
        shell-integration-features = "ssh-terminfo,ssh-env";
        font-style = "Italic";
        font-style-bold = "Bold Italic";
        font-style-bold-italic = "Bold Italic";
        font-style-italic = "Italic";
        gtk-single-instance = true;
        window-decoration = false;
        keybind = [
          "ctrl+enter=unbind"
        ];
      };
    };

    opencode = {
      enable = true;
      settings = {
        lsp = true;
        formatter = true;
      };
      context = # markdown
        ''
          # Environment

          The user is running NixOS.

          This system is declarative and reproducible.

          Prefer:
          - flakes
          - nix shell
          - nix develop
          - nix run
          - home-manager
          - NixOS modules
          - project-local tooling

          Avoid recommending:
          - curl | sh installers
          - global npm/pip installs
          - manual /usr/local modifications
          - distro-specific instructions for Ubuntu/Debian unless explicitly requested

          Assume:
          - systemd is available
          - modern Linux tooling is available
          - the user is comfortable with terminal workflows
          - the user is a technical user

          # General behavior

          - Prefer inspecting before changing.
          - Always ask for permission before making modifications to the system, configuration, services, repositories, disks, or user files.
          - Explain dangerous commands before suggesting or running them.
          - Preserve existing user changes.
          - Be concise but technically precise.
          - For debugging, prioritize root-cause analysis over quick hacks.
          - When troubleshooting, gather evidence incrementally instead of guessing.
          - Show relevant commands and explain what they verify.
          - Prefer reversible changes.
        '';
    };

    librewolf = {
      enable = true;
      # Enable WebGL, cookies and history
      settings = {
        "webgl.disabled" = false;
        "privacy.resistFingerprinting" = false;
        "privacy.clearOnShutdown.history" = false;
        "privacy.clearOnShutdown.cookies" = false;
        "network.cookie.lifetimePolicy" = 0;
      };
    };

    obs-studio = {
      enable = true;
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

    neovide = {
      enable = true;
      settings = {
        fork = false;
        neovim-bin = "${pkgs.neo}/bin/neo";
        frame = "full";
        idle = true;
        maximized = false;
        no-multigrid = false;
        srgb = false;
        tabs = true;
        theme = "auto";
        vsync = false;
        title-hidden = true;
        font = {
          normal = {
            family = "Delugia";
            style = "Italic";
          };
          size = 14.0;
          features = {
            Delugia = [
              "ss01"
              "ss02"
              "ss19"
            ];
          };
        };
      };
    };
  };
}
