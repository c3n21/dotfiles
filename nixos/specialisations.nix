# Convenience file to import all specialisations at once in a system.
# In case it's not needed I can just import the specific specialisation which
# reduces my system size.
#
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
