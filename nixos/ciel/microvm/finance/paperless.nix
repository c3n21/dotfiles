{ pkgs, ... }:
let
  upstreamPaperless = pkgs.paperless-ngx;

  relaxTorch =
    pkg:
    pkg.overridePythonAttrs (old: {
      pythonRelaxDeps = (old.pythonRelaxDeps or [ ]) ++ [ "torch" ];
    });
in
{
  services.paperless = {
    enable = true;
    address = "0.0.0.0"; # Raggiungibile solo via forwarding localhost dell'host
    port = 28981;
    package = (relaxTorch upstreamPaperless) // {
      override = args: relaxTorch (upstreamPaperless.override args);
    };

    settings = {
      PAPERLESS_URL = "http://127.0.0.1:28981";
      PAPERLESS_ALLOWED_HOSTS = "127.0.0.1,localhost";
      PAPERLESS_TIME_ZONE = "Europe/Rome";
      PAPERLESS_OCR_LANGUAGE = "ita+eng";
    };
  };
  # Dopo il primo avvio, da console seriale:
  # sudo paperless-manage createsuperuser
}
