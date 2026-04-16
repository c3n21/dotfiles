{ pkgs, ... }:
{
  services = {
    swayidle = {
      enable = true;
      events = {
        "before-sleep" = "${pkgs.swaylock}/bin/swaylock -fF -i ~/Pictures/wallpaper.jpg";
        "lock" = "lock";
      };
    };
  };
}
