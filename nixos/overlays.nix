final: prev: {
  nerd-fonts = prev.nerd-fonts // {
    delugia-code = final.callPackage ./delugia-code/default.nix { pkgs = final; };
  };
}
