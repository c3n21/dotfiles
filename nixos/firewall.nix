{ ... }:
{
  networking = {
    firewall = {
      trustedInterfaces = [ "virbr0" ];
      enable = true;
      # https://github.com/NixOS/nixpkgs/issues/263359 workaround for not getting DHCP and DNS
      interfaces = {
        # lxdbr0 = {
        #   allowedTCPPorts = [ 53 ];
        #   allowedUDPPorts = [
        #     53
        #     67
        #   ];
        # };
        virbr0 = {
          allowedTCPPorts = [ 53 ];
          allowedUDPPorts = [
            53
            67
          ];
        };

      };

    };
    nftables.enable = true;
  };
}
