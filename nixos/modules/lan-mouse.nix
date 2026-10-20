{
  services.firewalld = {
    services.lan-mouse = {
      short = "Lan Mouse";
      description = "Keyboard and mouse sharing over LAN";

      ports = [
        {
          port = 4242;
          protocol = "udp";
        }
      ];
    };

    zones = {
      home = {
        services = [
          "lan-mouse"
        ];
      };
    };
  };

  home-manager.users.zhifan =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        lan-mouse
      ];
    };
}
