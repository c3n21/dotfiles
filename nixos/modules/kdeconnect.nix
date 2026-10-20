{
  services.firewalld = {
    zones = {
      home = {
        services = [
          "kdeconnect"
        ];
      };
    };
  };

  home-manager.users.zhifan = {
    services = {
      kdeconnect = {
        enable = true;
        indicator = true;
      };
    };
  };
}
