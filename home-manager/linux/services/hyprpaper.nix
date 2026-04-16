{
  services = {
    hyprpaper = {
      enable = true;
      settings = {
        ipc = "off";

        preload = [
          "~/Pictures/wallpaper.jpg"
        ];

        wallpaper = [
          {
            # monitor = "eDP-1";
            monitor = ""; # Every monitor
            path = "~/Pictures/wallpaper.jpg";
            # fit_mode = "tile";
          }
        ];
      };
    };
  };
}
