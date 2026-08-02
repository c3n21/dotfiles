# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
# Common configuration for all machines
{ pkgs, ... }:
{

  imports = [
    # common
    ../common

    ./hardware-configuration.nix

    ../desktop.nix
    # ../firewall.nix

    ../services/tailscale.nix
    ../services/firewalld.nix

    ../modules/niri.nix

    # ../services/llama-cpp.nix
  ];

  environment.systemPackages = with pkgs; [
    bitwarden-desktop # Needs to be installed as system package because of https://github.com/NixOS/nixpkgs/issues/371479#issuecomment-4425603198
  ];

  users.users = {
    zhifan = {
      openssh = {
        authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAWsh71jIIevGaKuRbGfxEWh/5HrRRmzR4CnFkJOhpkJ"
        ];
      };
    };
  };

  security.pam.services.polkit-1.fprintAuth = true;

  networking = {
    hostName = "zenuko"; # Define your hostname.
  };

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
    kernelPackages = pkgs.linuxKernel.packages.linux_zen;

    # Not really using ZFS so can be turned off for the moment
    # supportedFilesystems = {
    #   zfs = true;
    # };
    # zfs = {
    #   forceImportRoot = false;
    # };
  };

  networking = {
    hostId = "505639ad";
  };

  hardware = {
    graphics = {
      enable = true;
      enable32Bit = true;
    };
  };

  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";
  services.timesyncd.enable = true;

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  # home-manager.users.zhifan = {
  #   /* The home.stateVersion option does not have a default and must be set */
  #   home.stateVersion = "23.05";
  #   /* Here goes the rest of your home-manager config, e.g. home.packages = [ pkgs.foo ]; */
  # };

  # services.udev.extraRules = ''
  #   ACTION=="add", SUBSYSTEM=="backlight", KERNEL=="intel_backlight", MODE="0666", RUN+="${pkgs.coreutils}/bin/chmod a+w /sys/class/backlight/%k/brightness"
  # '';

  # xsession.pointerCursor = {
  #   package = pkgs.gnome3.defaultIconTheme;
  #   name = "Adwaita";
  #   size = 130;
  # };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?
}
