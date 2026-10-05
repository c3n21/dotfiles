{
  boot = {
    loader = {
      limine = {
        enable = true;
        secureBoot = {
          enable = true;
        };
      };

      efi.canTouchEfiVariables = true;
    };
  };
}
