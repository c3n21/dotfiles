{
  boot = {
    loader = {
      systemd-boot.enable = true; # Enable systemd-boot
      efi = {
        canTouchEfiVariables = true; # Allow modifying EFI settings
      };
    };
  };
}
