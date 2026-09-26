{
  nix = {
    settings = {
      auto-optimise-store = true;
      download-buffer-size = 524288000;
      trusted-users = [
        "root"
        "zhifan"
      ];
      substituters = [ "https://attic.services.home.arpa/default" ];
      trusted-public-keys = [ "default:6TQ+I1NsmxSo6gQKMaaX3lo64mLU+NN8T4rPNe4CGlg=" ];
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
