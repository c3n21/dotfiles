final: prev: {
  nerd-fonts = prev.nerd-fonts // {
    delugia-code = final.callPackage ./delugia-code/default.nix { pkgs = final; };
  };
  dotfiles = {
    agy-acp-server = final.callPackage ./packages/agy-acp-server.nix { pkgs = final; };
  };
}
