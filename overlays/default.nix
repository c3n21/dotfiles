# This file defines overlays
{ inputs, ... }: rec {
  # This one brings our custom packages from the 'pkgs' directory
  # additions = final: _prev: import ../pkgs {pkgs = final;};

  # This one contains whatever you want to overlay
  # You can change versions, add patches, set compilation flags, anything really.
  # https://nixos.wiki/wiki/Overlays
  modifications = final: prev: {
    neovim = prev.neovim.overrideAttrs (oldAttrs: rec {
      postFixup = ''
        ${oldAttrs.postFixup}
        LD_LIBRARY_PATH = "${unstable-packages.zlib}/lib:${unstable-packages.sqlite.out}/lib:$LD_LIBRARY_PATH";
      '';
    });
    # example = prev.example.overrideAttrs (oldAttrs: rec {
    # example = prev.example.overrideAttrs (oldAttrs: rec {
    # ...
    # });
  };

  # When applied, the unstable nixpkgs set (declared in the flake inputs) will
  # be accessible through 'pkgs.unstable'
  unstable-packages = final: _prev: {
    unstable = import inputs.nixpkgs-unstable {
      system = final.system;
      config.allowUnfree = true;
    };
  };
}
