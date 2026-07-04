{ pkgs, ... }: {
  imports = [
    ./home.nix
  ];

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
      # indicator = true;
    };
  };
}
