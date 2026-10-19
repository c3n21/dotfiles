{ pkgs, ... }:
{
  services.firefly-iii = {
    enable = true;
    enableNginx = true;
    virtualHost = "127.0.0.1";

    settings = {
      APP_ENV = "production";
      APP_DEBUG = false;
      APP_URL = "http://127.0.0.1:9080";
      APP_KEY_FILE = "/var/lib/firefly-iii/app-key";
      DB_CONNECTION = "sqlite";
      TZ = "Europe/Rome";
      DEFAULT_LANGUAGE = "it_IT";
      SITE_OWNER = "admin@localhost.invalid";
    };
  };

  # Nginx risponde alla porta nel guest; dall'host solo localhost:9080.
  services.nginx.virtualHosts."127.0.0.1".listen = [
    {
      addr = "0.0.0.0";
      port = 9080;
    }
  ];

  # Chiave Laravel persistente, generata solo al primo avvio.
  # Non metterla nel flake/nix store e NON rigenerarla dopo i backup.
  systemd.services.finanza-firefly-key = {
    description = "Crea la chiave persistente Firefly III al primo avvio";
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      RequiresMountsFor = [ "/var/lib" ];
    };
    path = [
      pkgs.coreutils
      pkgs.openssl
    ];
    script = ''
      install -d -m 0700 -o firefly-iii -g firefly-iii /var/lib/firefly-iii
      if [ ! -s /var/lib/firefly-iii/app-key ]; then
        umask 077
        printf 'base64:%s\n' "$(openssl rand -base64 32 | tr -d '\n')" > /var/lib/firefly-iii/app-key
      fi
      chown firefly-iii:firefly-iii /var/lib/firefly-iii/app-key
      chmod 0600 /var/lib/firefly-iii/app-key
    '';
  };

  # Setup non deve partire prima che la chiave esista.
  systemd.services.firefly-iii-setup = {
    requires = [ "finanza-firefly-key.service" ];
    after = [ "finanza-firefly-key.service" ];
  };
}
