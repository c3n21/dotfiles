{ pkgs, inputs, ... }: {
  imports = [
    ./home.nix
    ./linux/packages-profiles/gaming.nix
    ./linux
    inputs.niri.homeModules.niri
    inputs.noctalia.homeModules.default
  ];

  home.packages = with pkgs; [
    telegram-desktop
    framework-tool
    adbfs-rootless
    localsend
  ];

  xdg = {
    mimeApps = {
      enable = true;
      defaultApplications = {
        "x-scheme-handler/tg" = [ "org.telegram.desktop.desktop" ];
      };
    };
  };

  # TODO: enable this after refactoring home.nix
  # home = {
  #   stateVersion = "24.05"; # Please read the comment before changing.
  #   username = "zhifan";
  #   homeDirectory = pkgs.lib.mkForce "/home/zhifan";
  #   shell = {
  #     enableFishIntegration = true;
  #   };
  # };

  services = {
    kdeconnect = {
      enable = true;
      indicator = true;
    };
  };
}
