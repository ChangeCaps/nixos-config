{  config, pkgs, lib, ... }:

let 
  cfg = config.reaper;
in {
  options.reaper = {
    enable = lib.mkEnableOption "reaper";
  };

  config = lib.mkIf (cfg.enable) {
    home.sessionVariables = let 
      makePluginPath = format:
        (lib.strings.makeSearchPath format [
          "$HOME"
          "$HOME/.nix-profile/lib"
          "/run/current-system/sw/lib"
          "/etc/profiles/per-user/$USER/lib"
        ])
        + ":$HOME/.${format}";
    in {
      CLAP_PATH = makePluginPath "clap";
      DSSI_PATH = makePluginPath "dssi";
      LADSPA_PATH = makePluginPath "ladspa";
      LV2_PATH = makePluginPath "lv2";
      LXVST_PATH = makePluginPath "lxvst";
      VST_PATH = makePluginPath "vst";
      VST3_PATH = makePluginPath "vst3";
    }; 

    home.packages = [
      pkgs.reaper

      /* plugins */
      pkgs.vital
      pkgs.lsp-plugins
      pkgs.dragonfly-reverb
      pkgs.geonkick
      pkgs.tap-plugins
      pkgs.talentedhack
      pkgs.sfizz
      pkgs.helvum
      pkgs.x42-plugins
      pkgs.decent-sampler
      pkgs.linuxsampler
      pkgs.surge
    ];
  };
}
