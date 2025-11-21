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
    extraOptions = ''
      experimental-features = nix-command flakes
      builders-use-substitutes = true
    '';
  };
}
