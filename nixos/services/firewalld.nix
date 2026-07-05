{
  networking = {
    firewall.enable = false;

    # Needed for firewalld backend on NixOS.
    nftables.enable = true;

    networkmanager.enable = true;
  };

  services.firewalld = {
    enable = true;

    zones = {
      public = { };

      home = {
        short = "Home";
        description = "Trusted home Wi-Fi";

        services = [
          "kdeconnect"
        ];
      };
    };
  };
}
