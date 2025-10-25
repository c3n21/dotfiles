# For some reason I need to specify pkgs otherwise it doesn't pick it up
{
  pkgs,
  ...
}@args:
{
  specialisation = {
    hyprland = {
      configuration = {
        system.nixos.tags = [ "hyprland" ];
      }
      // (import ./specialisation/hyprland.nix args);
    };

    niri = {
      configuration = {
        system.nixos.tags = [ "niri" ];
      }
      // (import ./specialisation/niri.nix args);
    };
  };
}
