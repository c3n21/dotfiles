{
  inputs,
  pkgs,
  ...
}: {
  specialisation = {
    hyprland = {
      configuration = {
        system.nixos.tags = ["hyprland"];

        programs = {
          uwsm = {
            enable = true;
          };

          hyprland = {
            withUWSM = true;
            enable = true;
            package = inputs.hyprland.packages.${pkgs.system}.hyprland;
          };
        };
      };
    };
  };
}
