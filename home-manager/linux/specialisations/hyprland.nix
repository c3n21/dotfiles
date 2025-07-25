{
  config,
  inputs,
  pkgs,
  ...
}:
{
  home = {
    pointerCursor = {
      hyprcursor = {
        enable = true;
        size = config.home.pointerCursor.size;
      };
    };
  };

  wayland.windowManager.hyprland = {
    enable = true;
    package = null; # use whatever is system wide
    portalPackage = null; # use whatever is system wide
    systemd = {
      # disabling because of this https://wiki.hyprland.org/Useful-Utilities/Systemd-start/#uwsm
      enable = false;
      variables = [ "--all" ];
    };
    xwayland = {
      enable = true;
    };
    plugins = [
      inputs.split-monitor-workspaces.packages.${pkgs.system}.split-monitor-workspaces
    ];

    settings = {
      # unscale XWayland
      xwayland = {
        force_zero_scaling = true;
      };

      input = {
        kb_layout = "us";
        kb_variant = "altgr-intl";
        follow_mouse = "1";
        touchpad = {
          natural_scroll = true;
          scroll_factor = 0.5; # seems to work well for my framework laptop
        };
      };

      gestures = {
        workspace_swipe = true;
        workspace_swipe_fingers = 3;
      };

      general = {
        gaps_in = 5;
        gaps_out = 5;
        border_size = 7;
        "col.active_border" = "0x66ee1111";
        "col.inactive_border" = "0x66333333";
      };

      decoration = {
        rounding = 10;
        shadow = {
          enabled = false;
          range = 10;
          render_power = 2;
        };
      };

      misc = {
        disable_autoreload = true;
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

        "$mod ,1,split-workspace,1"
        "$mod ,2,split-workspace,2"
        "$mod ,3,split-workspace,3"
        "$mod ,4,split-workspace,4"
        "$mod ,5,split-workspace,5"
        "$mod ,6,split-workspace,6"
        "$mod ,7,split-workspace,7"
        "$mod ,8,split-workspace,8"
        "$mod ,9,split-workspace,9"
        "$mod ,0,split-workspace,10"

        "$mod ,y,split-workspace,r+1"
        "$mod ,e,split-workspace,r-1"

        "$mod SHIFT,1,split-movetoworkspacesilent,1"
        "$mod SHIFT,2,split-movetoworkspacesilent,2"
        "$mod SHIFT,3,split-movetoworkspacesilent,3"
        "$mod SHIFT,4,split-movetoworkspacesilent,4"
        "$mod SHIFT,5,split-movetoworkspacesilent,5"

        "$mod SHIFT,y,split-movetoworkspace,r+1"
        "$mod SHIFT,e,split-movetoworkspace,r-1"

        "$mod ,F11,fullscreen"
        ",Print,exec,grimblast --freeze copy area"

        # Lock screen
        "$mod CTRL,e,exec,swaylock -f -i ~/Pictures/wallpaper.jpg"

        "$mod SHIFT,6,split-movetoworkspacesilent,6"
        "$mod SHIFT,7,split-movetoworkspacesilent,7"
        "$mod SHIFT,8,split-movetoworkspacesilent,8"
        "$mod SHIFT,9,split-movetoworkspacesilent,9"
        "$mod SHIFT,0,split-movetoworkspacesilent,10"
      ];

      bindm = [
        "$mod ,mouse:272,resizewindow"
        "$mod ,mouse:273,movewindow"
      ];

      binde = [
        ",XF86AudioLowerVolume,exec,wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ 5%-"
        ",XF86AudioRaiseVolume,exec,wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ 5%+"
        ",XF86MonBrightnessDown,exec,brightnessctl set 5%-"
        ",XF86MonBrightnessUp,exec,brightnessctl set 5%+"
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
      exec-once = [
        # this makes the cursor size uniform across GTK, QT and Hyprland
        "hyprctl setcursor ${config.home.pointerCursor.name} ${builtins.toString config.home.pointerCursor.size}"

      ];
    };
    extraConfig = # hyprlang
      ''
        plugin {
          split-monitor-workspaces {
            count = 5
            keep_focused = 0
            enable_notifications = 0
            enable_persistent_workspaces = 1
          }
        }

        # windowrulev2=windowdance,class:^(jetbrains-.*)$
        # search dialog
        windowrulev2=dimaround,class:^(jetbrains-.*)$,floating:1,title:^(?!win)
        windowrulev2=center,class:^(jetbrains-.*)$,floating:1,title:^(?!win)
        # autocomplete & menus
        windowrulev2=noanim,class:^(jetbrains-.*)$,title:^(win.*)$
        windowrulev2=noinitialfocus,class:^(jetbrains-.*)$,title:^(win.*)$
        windowrulev2=rounding 0,class:^(jetbrains-.*)$,title:^(win.*)$
        windowrulev2 = workspace special,class:(kitty)
      '';
    # ...
  };
}
