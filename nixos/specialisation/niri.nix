# Requires niri and home-manager modules to be imported.
# TODO:
# - could be a nice idea to make the user parametric
{
  pkgs,
  lib,
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
        "org.freedesktop.impl.portal.Secret" = lib.mkForce "kwallet"; # needs to be tested
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

  home-manager.users.zhifan = ../../home-manager/linux/specialisations/niri.nix;
}
