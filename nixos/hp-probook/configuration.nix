# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
# Common configuration for all machines
{ pkgs, ... }:
{

  imports = [
    ./disko.nix
    ./facter.nix

    # common
    # ../common/distributed-builds.nix
    ../common/fish.nix
    # ../common/secure-boot.nix
    ../common/editor.nix
    ../common/nix.nix

    ../desktop.nix
    ../firewall.nix

    ../modules/niri.nix
  ];

  # loader = {
  #   systemd-boot.enable = true;
  # };

  boot.loader.systemd-boot.enable = true;

  services.thermald.enable = true;
  hardware.cpu.intel.updateMicrocode = true;

  networking = {
    hostName = "kenjy"; # Define your hostname.
    hostId = "5cca6037";
  };

  boot = {
    kernelPackages = pkgs.linuxKernel.packages.linux_zen;
    zfs.package = pkgs.zfs_2_4;
  };

  hardware = {
    graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages32 = with pkgs.driversi686Linux; [
        intel-vaapi-driver
        intel-media-driver
      ];
      extraPackages = with pkgs; [
        vpl-gpu-rt
        intel-vaapi-driver
        intel-media-driver
      ];
    };
  };

  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Set your time zone.
  time.timeZone = "Europe/Rome";

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
  services.openssh.enable = true;

  users.users = {
    root.openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOXsckYz+HIMA2eJtUfyKtjTOQxHt3hW4qrycpLqS/qX hp"
    ];
  };

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
  system.stateVersion = "25.11"; # Did you read the comment?
}
