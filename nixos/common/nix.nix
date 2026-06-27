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
      trusted-public-keys = [ "default:QqQhH26sX5LlZOMWFGNXf1334y/7lLDTGqN3INIMgjA=" ];
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
