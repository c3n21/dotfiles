{
  inputs,
  pkgs,
  ...
}:
{
  specialisation = {
    hyprland = {
      configuration = {
        system.nixos.tags = [ "hyprland" ];

        xdg.portal = {
          enable = true;
          xdgOpenUsePortal = true;
        };

        programs = {
          hyprland = {
            withUWSM = true;
            enable = true;
            package = inputs.hyprland.packages.${pkgs.system}.hyprland;
            portalPackage =
              inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
          };
        };
      };
    };

    niri = {
      configuration = {
        system.nixos.tags = [ "niri" ];

        xdg.portal = {
          enable = true;
          xdgOpenUsePortal = true;
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
      };
    };
  };
}
