{ config, pkgs, ...}:

let
  flake = builtins.replaceStrings ["~"] [config.home.homeDirectory] "${config.flake}/nixos-config";
  link = config.lib.file.mkOutOfStoreSymlink;
in {
  home.packages = [
    pkgs.logseq
  ];

  home.file = {
    ".logseq/config/".source = link "${flake}/home/logseq/config/";
    ".logseq/settings/".source = link "${flake}/home/logseq/settings/";
    ".config/Logseq/configs.edn".source = link "${flake}/home/logseq/configs.edn";
  };
}
