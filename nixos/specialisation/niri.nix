{
  inputs,
  pkgs,
  ...
}:
{
  services.gnome.gnome-keyring.enable = false;

  xdg.portal = {
    xdgOpenUsePortal = true;
    config = {
      # seems like niri-portals.conf doesn't do merging with the default niri-portals.conf,
      # thus I'm providing the full config.
      niri = {
        default = [
          "gnome"
          "gtk"
        ];
        "org.freedesktop.impl.portal.Access" = "gtk";
        "org.freedesktop.impl.portal.Notification" = "gtk";
        "org.freedesktop.impl.portal.FileChooser" = "gtk";
        "org.freedesktop.impl.portal.Secret" = "kwallet"; # needs to be tested
      };
    };
  };

  programs = {
    uwsm = {
      enable = true;
      waylandCompositors = { };
    };

    niri = {
      enable = true;
      package = pkgs.niri;
    };
  };

}
