{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    ./disko.nix

    # TODO: use this in place of
    # ../common

    # these when secure boot will be enabled
    # TODO: refactor this
    ../common/distributed-builds.nix
    ../common/fish.nix
    ../common/editor.nix
    ../common/nix.nix

    ../desktop.nix

    ../services/tailscale.nix
    ../services/firewalld.nix

    ../modules/niri.nix
  ];

  # Configure the remote builder
  programs.ssh.extraConfig =
    # sshconfig
    ''
      Host thinkcentre.private.headscale.com
        HostName thinkcentre.private.headscale.com
        User remotebuilder
        IdentityFile /root/.ssh/remotebuilder.thinkcentre.private.headscale.com
        IdentitiesOnly yes

      Host kenjy.home.arpa
        HostName kenjy.home.arpa
        User zhifan
        IdentityFile /root/.ssh/kenjy
        IdentitiesOnly yes
    '';

  hardware.facter.reportPath = ./facter.json;
  networking = {
    hostName = "ciel";
    networkmanager.enable = true;
  };

  time.timeZone = "Europe/Rome";

  i18n.defaultLocale = "en_US.UTF-8";

  # TODO: refactor this
  security.pki = {
    installCACerts = true;
    certificates = [
      ''
        -----BEGIN CERTIFICATE-----
        MIIBcjCCARigAwIBAgIRAKrMwfIuq4rrPBBWvzfSSj8wCgYIKoZIzj0EAwIwFzEV
        MBMGA1UEAxMMQ2xhbiBSb290IENBMB4XDTI2MDQwNjA1MTkwMloXDTI3MDQwNjE3
        MTkwMlowFzEVMBMGA1UEAxMMQ2xhbiBSb290IENBMFkwEwYHKoZIzj0CAQYIKoZI
        zj0DAQcDQgAEbtr+thTdJilW38QpSpiaWv9X4+w/jeaOmgNfAG7s5LrdAFUq2+jm
        Niq22nmXb+NbDZPQp/EGyp4jy/fT2t4chKNFMEMwDgYDVR0PAQH/BAQDAgEGMBIG
        A1UdEwEB/wQIMAYBAf8CAQEwHQYDVR0OBBYEFMABVv9Q4mFCbpBXUqqAu39p5eSm
        MAoGCCqGSM49BAMCA0gAMEUCIQDIPqw83BZbLhPu0ETd3BY844/kEw7v/5PVqZ92
        LDnJyQIgdXKxeIgHTWk2KiDcqkPef8LOJGBdXAWfYAfW0LXAlaE=
        -----END CERTIFICATE-----
      ''
    ];
  };

  boot = {
    loader = {
      systemd-boot = {
        enable = true;
        configurationLimit = 20;
      };

      efi.canTouchEfiVariables = true;
    };

    # Btrfs support is normally available automatically, but declaring it
    # makes the installation requirement explicit.
    supportedFilesystems = [ "btrfs" ];

    # Generic modules useful for SATA/AHCI systems.
    initrd.availableKernelModules = [
      "ahci"
      "xhci_pci"
      "usbhid"
      "sd_mod"
    ];

    kernelModules = [ "kvm-intel" ];

    kernelPackages = pkgs.linuxKernel.packages.linux_zen;
  };

  hardware = {
    cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

    enableRedistributableFirmware = true;
  };

  # Issue TRIM periodically for the SATA SSD.
  services.fstrim = {
    enable = true;
    interval = "weekly";
  };

  services.openssh = {
    enable = true;

    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      PermitRootLogin = "prohibit-password";
    };
  };

  users.users.zhifan = {
    openssh.authorizedKeys.keys = [
      # Replace this.
      "ssh-ed25519 AAAA_REPLACE_WITH_YOUR_PUBLIC_KEY"
    ];
  };

  # Also permits initial SSH access as root after installation.
  users.users.root.openssh.authorizedKeys.keys = [
    # Replace this with the same public key.
    "ssh-ed25519 AAAA_REPLACE_WITH_YOUR_PUBLIC_KEY"
  ];

  security.sudo.wheelNeedsPassword = true;

  nix = {
    settings = {
      builders-use-substitutes = true;
      # Prefer remote builders
      max-jobs = 1;
      experimental-features = [
        "nix-command"
        "flakes"
      ];

      auto-optimise-store = true;
    };

    gc = {
      automatic = true;
      dates = "weekly";
    };
  };

  environment.systemPackages = with pkgs; [
    btrfs-progs
    git
    smartmontools
    vim
  ];

  system.stateVersion = "26.05";
}
