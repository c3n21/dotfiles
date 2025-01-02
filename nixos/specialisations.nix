{
  inputs,
  pkgs,
  ...
}: {
  # specialisation = {
  #   hyprland = {
  #     configuration = {
  #       system.nixos.tags = ["hyprland"];
  #
  #       # # Configure keymap in X11
  #       # services.xserver = {
  #       #   # for SDDM
  #       #   enable = true;
  #       #   xkb = {
  #       #     variant = "altgr-intl";
  #       #     layout = "us";
  #       #   };
  #       # };
  #     };
  #   };
  #
  #   niri = {
  #     configuration = {
  #       system.nixos.tags = ["niri"];
  #
  #       programs = {
  #         uwsm = {
  #           enable = true;
  #           waylandCompositors = {
  #             dummy = {
  #               prettyName = "Dummy";
  #               comment = "Dummy";
  #               binPath = "/dev/null";
  #             };
  #           };
  #         };
  #       };
  #     };
  #   };
  # };

  programs = {
    uwsm = {
      enable = true;
    };

    xwayland = {
      enable = false;
    };

    hyprland = {
      withUWSM = true;
      enable = true;
      package = inputs.hyprland.packages.${pkgs.system}.hyprland;
    };

    niri = {
      enable = true;
      package = pkgs.niri;
    };
  };

  services.xserver = {
    # for SDDM
    enable = false;
    xkb = {
      variant = "altgr-intl";
      layout = "us";
    };
  };
}
