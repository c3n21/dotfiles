# TODO:
# - to be tested if it works or not
{ inputs, pkgs, ... }:
{
  xdg.portal = {
    xdgOpenUsePortal = true;
  };

  programs = {
    hyprland = {
      withUWSM = true;
      enable = true;
      package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
      portalPackage =
        inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
    };
  };

  specialisation.hyprland.configuration.home-manager.users.zhifan =
    ../../home-manager/linux/specialisations/hyprland.nix;
}
