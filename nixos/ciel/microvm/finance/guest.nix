# Configurazione GUEST. Prima della prima build sostituire l'hash password.
{ pkgs, ... }:
{
  networking.hostName = "finance";
  time.timeZone = "Europe/Rome";
  i18n.defaultLocale = "en_US.UTF-8";

  # Valore iniziale: scegliere in base alla release nixpkgs del guest,
  # poi NON cambiarlo per aggiornare la release.
  system.stateVersion = "26.11";

  microvm = {
    hypervisor = "qemu";
    vcpu = 2;
    mem = 4096;

    # SLIRP: nessun bridge/TAP/port forwarding sul router.
    interfaces = [
      {
        type = "user";
        id = "finanza-net";
        mac = "02:00:00:00:02:42";
      }
    ];

    # Solo applicazioni web verso il loopback dell'HOST.
    forwardPorts = [
      {
        from = "host";
        host.address = "127.0.0.1";
        host.port = 28981;
        guest.port = 28981;
      }
      {
        from = "host";
        host.address = "127.0.0.1";
        host.port = 9080;
        guest.port = 9080;
      }
    ];

    # Nome identico alla versione precedente: NON creare un altro
    # file cambiando nome, se esistono gia' dati da preservare.
    volumes = [
      {
        image = "finance-var-lib.img";
        mountPoint = "/home/zhifan/Documents/vms";
        size = 49152; # MiB, 48 GiB; dimensionare PRIMA del primo avvio
        fsType = "ext4";
        autoCreate = true;
      }
    ];

    # Store dell'host condiviso in sola lettura.
    shares = [
      {
        proto = "virtiofs";
        source = "/nix/store";
        mountPoint = "/nix/.ro-store";
        tag = "ro-store";
        readOnly = true;
      }
    ];

    # Niente SSH. Console seriale su socket locale Unix di QEMU.
    # Disabilitiamo la seriale standard per evitare due -serial.
    qemu.serialConsole = false;
    qemu.extraArgs = [
      "-chardev"
      "socket,id=finanza-serial,path=console.sock,server=on,wait=off"
      "-serial"
      "chardev:finanza-serial"
    ];
  };

  # QEMU user networking fornisce DHCP tramite SLIRP.
  networking.useDHCP = true;
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [
      28981
      9080
    ];
  };

  boot.kernelParams = [ "console=ttyS0,115200" ];
  systemd.services."serial-getty@ttyS0".wantedBy = [ "getty.target" ];

  services.openssh.enable = false;
  users.users.root.hashedPassword = "!";

  users.users.zhifan = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];

    # OBBLIGATORIO: sostituire con hash yescrypt, NON password in chiaro.
    # Esempio: nix shell nixpkgs#whois -c mkpasswd -m yescrypt
    hashedPassword = "$y$j9T$6lmtoSP5LqHy2IjUdq5lb0$/IOt96xNJ7DNEB1aXWXYlszYAdxBgA.txUbZSJExHZ9";
  };
  security.sudo.wheelNeedsPassword = true;

  environment.systemPackages = with pkgs; [
    coreutils
    curl
    sqlite
  ];
}
