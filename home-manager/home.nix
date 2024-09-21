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

    ".config/kitty/kitty.conf".text = ''
      shell ${shell}
      ${builtins.readFile ./dotfiles/kitty/kitty.conf}
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

  wayland.windowManager.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
    systemd = {
      enable = true;
    };
    xwayland = {
      enable = true;
    };
    # plugins = [
    #   inputs.split-monitor-workspaces.packages.${pkgs.system}.split-monitor-workspaces
    # ];
    settings = {
      input = {
        kb_layout = "us";
        kb_variant = "altgr-intl";
        kb_options = "caps:swapescape";

        follow_mouse = "1";

        touchpad = {
          natural_scroll = "yes";
        };
      };

      gestures = {
        workspace_swipe = true;
        workspace_swipe_fingers = 3;
      };

      general = {
        sensitivity = 1.0;

        gaps_in = 5;
        gaps_out = 5;
        border_size = 7;
        "col.active_border" = "0x66ee1111";
        "col.inactive_border" = "0x66333333";
        apply_sens_to_raw = 0; # whether to apply the sensitivity to raw input (e.g. used by games where you aim using your mouse)
      };

      decoration = {
        rounding = 10;
        drop_shadow = false;
        shadow_range = 10;
        shadow_render_power = 2;
      };

      misc = {
        vfr = true;
        layers_hog_keyboard_focus = true;
        focus_on_activate = false;
        mouse_move_enables_dpms = true;
        key_press_enables_dpms = true;
        allow_session_lock_restore = true;
      };

      animations = {
        enabled = 1;
        animation = [
          "windows,1,7,default"
          "border,1,10,default"
          "fade,1,10,default"
          "workspaces,1,6,default"
        ];
      };

      dwindle = {
        pseudotile = 1; # enable pseudotiling on dwindle
        force_split = 0; # 0 means the split direction follows mouse position relative to the window
        preserve_split = 1;
      };

      "$mod" = "SUPER";
      bind = [
        "$mod,T,togglespecialworkspace"
        "$mod SHIFT,Q,killactive,"

        "$mod CTRLSHIFT,X,exit, "
        "$mod SHIFT,g,togglefloating,"
        "$mod ,code:61,exec,rofi -show drun"
        "$mod ,P,pseudo,"

        "$mod ,S,togglesplit"

        "$mod ,h,movefocus,l"
        "$mod ,l,movefocus,r"
        "$mod ,k,movefocus,u"
        "$mod ,j,movefocus,d"
        "$mod SHIFT,h,movewindow,l"
        "$mod SHIFT,l,movewindow,r"
        "$mod SHIFT,k,movewindow,u"
        "$mod SHIFT,j,movewindow,d"
        # "$mod ,1,split-workspace,1"
        # "$mod ,2,split-workspace,2"
        # "$mod ,3,split-workspace,3"
        # "$mod ,4,split-workspace,4"
        # "$mod ,5,split-workspace,5"
        "$mod ,1,workspace,1"
        "$mod ,2,workspace,2"
        "$mod ,3,workspace,3"
        "$mod ,4,workspace,4"
        "$mod ,5,workspace,5"
        # "$mod ,6,split-workspace,6"
        # "$mod ,7,split-workspace,7"
        # "$mod ,8,split-workspace,8"
        # "$mod ,9,split-workspace,9"
        # "$mod ,0,split-workspace,10"
        "$mod ,6,workspace,6"
        "$mod ,7,workspace,7"
        "$mod ,8,workspace,8"
        "$mod ,9,workspace,9"
        "$mod ,0,workspace,10"

        # "$mod ,y,split-workspace,e+1"
        # "$mod ,e,split-workspace,e-1"

        "$mod ,y,workspace,e+1"
        "$mod ,e,workspace,e-1"

        # "$mod SHIFT,1,split-movetoworkspacesilent,1"
        # "$mod SHIFT,2,split-movetoworkspacesilent,2"
        # "$mod SHIFT,3,split-movetoworkspacesilent,3"
        # "$mod SHIFT,4,split-movetoworkspacesilent,4"
        # "$mod SHIFT,5,split-movetoworkspacesilent,5"

        "$mod SHIFT,1,movetoworkspacesilent,1"
        "$mod SHIFT,2,movetoworkspacesilent,2"
        "$mod SHIFT,3,movetoworkspacesilent,3"
        "$mod SHIFT,4,movetoworkspacesilent,4"
        "$mod SHIFT,5,movetoworkspacesilent,5"

        # "$mod SHIFT,y,split-movetoworkspace,e+1"
        # "$mod SHIFT,e,split-movetoworkspace,e-1"

        "$mod SHIFT,y,movetoworkspace,e+1"
        "$mod SHIFT,e,movetoworkspace,e-1"

        "$mod ,F11,fullscreen"
        "$mod SHIFT,S,exec,grimblast --freeze copy area"

        # Lock scren
        "$mod CTRL,e,exec,swaylock -f -i ~/Pictures/wallpaper.jpg"

        "$mod SHIFT,6,movetoworkspacesilent,6"
        "$mod SHIFT,7,movetoworkspacesilent,7"
        "$mod SHIFT,8,movetoworkspacesilent,8"
        "$mod SHIFT,9,movetoworkspacesilent,9"
        "$mod SHIFT,0,movetoworkspacesilent,10"
        # "$mod SHIFT,6,split-movetoworkspacesilent,6"
        # "$mod SHIFT,7,split-movetoworkspacesilent,7"
        # "$mod SHIFT,8,split-movetoworkspacesilent,8"
        # "$mod SHIFT,9,split-movetoworkspacesilent,9"
        # "$mod SHIFT,0,split-movetoworkspacesilent,10"
      ];

      bindm = [
        "$mod ,mouse:272,resizewindow"
        "$mod ,mouse:273,movewindow"
      ];

      binde = [
        ",XF86AudioLowerVolume,exec,wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ 5%-"
        ",XF86AudioRaiseVolume,exec,wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ 5%+"
        # ",XF86MonBrightnessDown,exec,awk '{ print $1 - 50}' /sys/class/backlight/intel_backlight/actual_brightness > /sys/class/backlight/intel_backlight/brightness"
        # ",XF86MonBrightnessUp,exec,awk '{ print $1 + 50}' /sys/class/backlight/intel_backlight/actual_brightness > /sys/class/backlight/intel_backlight/brightness"
      ];

      bindt = [
        # bindl=,switch:off:[switch name],exec,hyprctl keyword monitor "eDP-1, disable"
        # bindl=,switch:on:[switch name],exec,hyprctl keyword monitor "eDP-1, 2560x1600, 0x0, 1
        # trigger when the switch is toggled
        # trigger when the switch is turning off
        # trigger when the switch is turning on
        ",switch:on:Lid Switch,exec,systemctl suspend "
        ",XF86AudioMute,exec,wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
      ];
    };
    extraConfig = ''
      source = ~/.config/hypr/monitors.conf
      source = ~/.config/hypr/workspaces.conf

      # windowrulev2=windowdance,class:^(jetbrains-.*)$
      # search dialog
      windowrulev2=dimaround,class:^(jetbrains-.*)$,floating:1,title:^(?!win)
      windowrulev2=center,class:^(jetbrains-.*)$,floating:1,title:^(?!win)
      # autocomplete & menus
      windowrulev2=noanim,class:^(jetbrains-.*)$,title:^(win.*)$
      windowrulev2=noinitialfocus,class:^(jetbrains-.*)$,title:^(win.*)$
      windowrulev2=rounding 0,class:^(jetbrains-.*)$,title:^(win.*)$



      # plugin {
      #     split-monitor-workspaces {
      #         count = 5
      #     }
      # }

      windowrule=pseudo,fcitx

      # windowrulev2 = float,class:(kitty)
      # windowrulev2 = size 80% 80% ,class:(kitty)
      # windowrulev2 = center,class:(kitty)
      windowrulev2 = workspace special,class:(kitty)

      exec-once=nm-applet
      exec-once=blueman-applet
      exec-once=fcitx5 -d --replace
      # exec-once=swayidle -w before-sleep 'swaylock -f -i ~/Pictures/wallpaper.jpg'

      # allow for screen recording via xdg-desktop-portal-wlr
      # exec-once=dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP
      # exec-once=systemctl --user import-environment DISPLAY WAYLAND_DISPLAY SWAYSOCK
      # exec-once=hash dbus-update-activation-environment 2>/dev/null && \
      #     dbus-update-activation-environment --systemd DISPLAY WAYLAND_DISPLAY SWAYSOCK XDG_CURRENT_DESKTOP

      # exec-once = swayidle -w timeout 300 'swaylock -f -i ~/Pictures/wallpaper.jpg' timeout 600 'hyprctl dispatch dpms off' resume 'hyprctl dispatch dpms on'

      # background
      exec=pkill --signal 9 hyprpaper; hyprpaper

      exec-once=hyprctl setcursor Bibata-Modern-Classic 16
    '';
    # ...
  };

  # TODO: to be solved
  # qt = {
  #   enable = true;
  #   platformTheme = "gtk";
  # };

  # Sometimes waybar and swayidle don't work properly because of this bug https://github.com/hyprwm/Hyprland/issues/4849
  # that causes Hyprland to crash and thus the services are not properly stopped.
  programs = {
    waybar = {
      enable = true;
      systemd = {
        enable = true;
        target = hyprland_session_target;
      };
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
      extraPackages = with pkgs; [lua51Packages.luarocks fswatch tree-sitter];
      defaultEditor = true;
      # extraPackages = with pkgs; [lua51Packages.luarocks fswatch];
    };
  };

  services = {
    swayidle = {
      enable = true;
      systemdTarget = hyprland_session_target;
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
    dunst = {
      enable = true;
    };
  };
}
