{
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    heroic
    osu-lazer
    # TODO: build failure but as it's not vital
    # mgba
  ];

  programs.lutris = {
    enable = true;
  };
}
