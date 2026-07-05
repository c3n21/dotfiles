{
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    heroic
    # osu-lazer
    steam
    # TODO: build failure but as it's not vital
    # mgba
  ];
}
