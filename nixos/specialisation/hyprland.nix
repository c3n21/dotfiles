# TODO:
# - to be tested if it works or not
{ inputs, pkgs, ... }:
{
  xdg.portal = {
    xdgOpenUsePortal = true;
  };

  nix = {
    settings = {
      # additional substituters for Hyprland
      substituters = [ "https://hyprland.cachix.org" ];
      trusted-public-keys = [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" ];
    };
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
