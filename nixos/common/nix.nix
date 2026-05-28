{
  nix = {
    settings = {
      auto-optimise-store = true;
      download-buffer-size = 524288000;
      trusted-users = [
        "root"
        "zhifan"
      ];
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 14d";
    };
    optimise = {
      automatic = true;
      dates = [ "weekly" ];
    };
    extraOptions = ''
      experimental-features = nix-command flakes
      builders-use-substitutes = true
    '';
  };
}
