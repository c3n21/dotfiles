{ ... }:
{
  services.paperless = {
    enable = true;
    address = "0.0.0.0"; # Raggiungibile solo via forwarding localhost dell'host
    port = 28981;

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
