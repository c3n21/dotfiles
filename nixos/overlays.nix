final: prev: {
  go-mockery = prev.go-mockery.overrideAttrs (old: {
    patches = (old.patches or [ ]) ++ [
      # workaround to solve this https://github.com/vektra/mockery/pull/1188
      (prev.fetchpatch2 {
        name = "mockery-go-1.27.2-export-data-v5.patch";
        url = "https://github.com/vektra/mockery/commit/3d6befc6338dad94751c7b2657d42d74b2ff5693.patch?full_index=1";
        hash = "sha256-0f61Af2Vl+lVKHcKRjM9C201d+fNLq9V2U27KxpxLxU=";
      })
    ];

    vendorHash = "sha256-ksfAHdPdOd8ELS0CSBg+E7KPd5xX/uGeLPn9HiItjdI=";
  });
  nerd-fonts = prev.nerd-fonts // {
    delugia-code = final.callPackage ./delugia-code/default.nix { pkgs = final; };
  };
  dotfiles = {
    agy-acp-server = final.callPackage ./packages/agy-acp-server.nix { pkgs = final; };
  };
}
