{ config, pkgs, ...}:

let
  fix-electron = (package:
    package.overrideAttrs(oldAttrs: {
      nativeBuildInputs = oldAttrs.nativeBuildInputs or [] ++ [ pkgs.makeWrapper ];

      postFixup = (oldAttrs.postFixup or "") + ''
        chmod +x $out/bin/${package.meta.mainProgram}
        wrapProgram $out/bin/${package.meta.mainProgram} --append-flags "--use-angle=opengl"
      '';
    })); 

  flake = builtins.replaceStrings ["~"] [config.home.homeDirectory] "${config.flake}/nixos-config";
  link = config.lib.file.mkOutOfStoreSymlink;
in {
  home.packages = [
    (fix-electron (pkgs.logseq.override {
      electron = pkgs.electron_27;
    }))
  ];

  home.file = {
    ".logseq/config/".source = link "${flake}/home/logseq/config/";
    ".logseq/settings/".source = link "${flake}/home/logseq/settings/";
    ".config/Logseq/configs.edn".source = link "${flake}/home/logseq/configs.edn";
  };
}
