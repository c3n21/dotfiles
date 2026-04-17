{
  # configure options
  programs.noctalia-shell = {
    enable = true;
    plugins = {
      sources = [
        {
          enabled = true;
          name = "Official Noctalia Plugins";
          url = "https://github.com/noctalia-dev/noctalia-plugins";
        }
      ];
      states = {
        network-manager-vpn = {
          enabled = true;
          sourceUrl = "https://github.com/noctalia-dev/noctalia-plugins";
        };
      };
      version = 2;
    };
    # this may also be a string or a path to a JSON file.

    pluginSettings = {
      network-manager-vpn = {
        "displayMode" = "alwaysShow";
        "disconnectedColor" = "none";
        "connectedColor" = "primary";
        "disableToastNotifications" = false;
      };
      # this may also be a string or a path to a JSON file.
    };
    settings = {
      # configure noctalia here
      bar = {
        density = "compact";
        position = "top";
        outerCorners = false;
        showCapsule = false;
        widgets = {
          left = [
            {
              id = "ControlCenter";
              useDistroLogo = true;
            }
            {
              id = "Network";
            }
            {
              id = "plugin:network-manager-vpn";
            }
            {
              id = "Bluetooth";
            }
            {
              "id" = "Tray";
              drawerEnabled = false;
            }
          ];
          center = [
            {
              hideUnoccupied = false;
              id = "Workspace";
              labelMode = "none";
            }
          ];
          right = [
            {
              alwaysShowPercentage = false;
              id = "Battery";
              warningThreshold = 30;
            }
            {
              formatHorizontal = "HH:mm";
              formatVertical = "HH mm";
              id = "Clock";
              useMonospacedFont = true;
              usePrimaryColor = true;
            }
          ];
        };
      };
      # colorSchemes.predefinedScheme = "Monochrome";
      # general = {
      #   avatarImage = "/home/drfoobar/.face";
      #   radiusRatio = 0.2;
      # };
      # location = {
      #   monthBeforeDay = true;
      #   name = "Marseille, France";
      # };
    };
    # this may also be a string or a path to a JSON file.
  };
}
