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
    ../common/distributed-builds.nix
    ../common/fish.nix
    ../common/editor.nix
    ../common/nix.nix

    ../services/tailscale.nix
    ../services/firewalld.nix

    ../modules/niri.nix
  ];

  hardware.facter.reportPath = ./facter.json;
  networking = {
    hostName = "ciel";
    networkmanager.enable = true;
  };

  time.timeZone = "Europe/Rome";

  i18n.defaultLocale = "en_US.UTF-8";

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
    isNormalUser = true;
    description = "Your user";

    extraGroups = [
      "networkmanager"
      "wheel"
    ];

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
