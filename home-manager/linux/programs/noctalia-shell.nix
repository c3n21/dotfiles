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
              displayMode = "icon-always";
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
      general = {
        # radiusRatio = 0.2;
        lockOnSuspend = true;

      };
      location = {
        name = "";
        weatherEnabled = true;
        # weatherShowEffects = true;
        # weatherTaliaMascotAlways = false;
        # useFahrenheit = false;
        use12hourFormat = false;
        # showWeekNumberInCalendar = false;
        # showCalendarEvents = true;
        # showCalendarWeather = true;
        # analogClockInCalendar = false;
        # firstDayOfWeek = -1;
        # hideWeatherTimezone = false;
        # hideWeatherCityName = false;
        autoLocate = true;
      };

      wallpaper = {
        enabled = true;
        overviewEnabled = false;
        directory = "";
        monitorDirectories = [ ];
        enableMultiMonitorDirectories = false;
        showHiddenFiles = false;
        viewMode = "single";
        setWallpaperOnAllMonitors = true;
        linkLightAndDarkWallpapers = true;
        # fillMode = "crop";
        # fillColor = "#000000";
        # useSolidColor = false;
        # solidColor = "#1a1a2e";
        # automationEnabled = false;
        # wallpaperChangeMode = "random";
        # randomIntervalSec = 300;
        # transitionDuration = 1500;
        # transitionType = [
        #   "fade"
        #   "disc"
        #   "stripes"
        #   "wipe"
        #   "pixelate"
        #   "honeycomb"
        # ];
        # skipStartupTransition = false;
        # transitionEdgeSmoothness = 0.05;
        # panelPosition = "follow_bar";
        # hideWallpaperFilenames = false;
        # useOriginalImages = false;
        # overviewBlur = 0.4;
        # overviewTint = 0.6;
        # useWallhaven = false;
        # wallhavenQuery = "";
        # wallhavenSorting = "relevance";
        # wallhavenOrder = "desc";
        # wallhavenCategories = "111";
        # wallhavenPurity = "100";
        # wallhavenRatios = "";
        # wallhavenApiKey = "";
        # wallhavenResolutionMode = "atleast";
        # wallhavenResolutionWidth = "";
        # wallhavenResolutionHeight = "";
        # sortOrder = "name";
        # favorites = [ ];
      };

      # TODO: configure this
      # brightness = {
      #    brightnessStep = 5;
      #    enforceMinimum = true;
      #    enableDdcSupport = false;
      #    backlightDeviceMappings = [ ];
      #  };

      nightLight = {
        enabled = true;
        forced = false;
        autoSchedule = true;
        # nightTemp = "4000";
        # dayTemp = "6500";
        # manualSunrise = "06:30";
        # manualSunset = "18:30";
      };

      idle = {
        enabled = true;
        screenOffTimeout = 600;
        lockTimeout = 660;
        suspendTimeout = 1800;
        fadeDuration = 5;
        # screenOffCommand = "";
        # lockCommand = "";
        # suspendCommand = "";
        # resumeScreenOffCommand = "";
        # resumeLockCommand = "";
        # resumeSuspendCommand = "";
        # customCommands = "[]";
      };
    };
    # this may also be a string or a path to a JSON file.
  };
}
