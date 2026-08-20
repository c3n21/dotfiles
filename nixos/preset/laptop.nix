# This file is used to setup a laptop
{
  pkgs,
  lib,
  ...
}:
{
  imports = [
    ./desktop.nix
  ];

  # laptop
  powerManagement.enable = true;

  services = {
    logind.settings.Login = {
      HandleLidSwitch = "suspend-then-hibernate";
      HandleLidSwitchExternalPower = "suspend-then-hibernate";
      # When the laptop is plugged to an external monitor
      HandleLidSwitchDocked = "suspend-then-hibernate";
    };
    thermald.enable = true;
    upower.enable = true;
  };

  # TODO: this will be eventually moved to another module
  hardware = {
    bluetooth.enable = true; # enables support for Bluetooth
    bluetooth.powerOnBoot = false; # powers up the default Bluetooth controller on boot  };
  };
}
