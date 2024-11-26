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
      pkgs.calf
      pkgs.carla
      pkgs.eq10q
      (pkgs.stdenv.mkDerivation rec {
        pname = "decent-sampler";
        version = "1.12.5";

        src = ./../../Decent_Sampler-1.12.5-Linux-Static-x86_64;

        nativeBuildInputs = [
          pkgs.autoPatchelfHook
          pkgs.makeWrapper
        ];

        buildInputs = [
          pkgs.alsa-lib
          pkgs.freetype
          pkgs.nghttp2
          pkgs.xorg.libX11
        ];

        dontBuild = true;

        installPhase = ''
          runHook preInstall

          mkdir -p $out/bin
          mkdir -p $out/lib/vst
          mkdir -p $out/lib/vst3

          cp $src/DecentSampler $out/bin
          cp $src/DecentSampler.so $out/lib/vst
          cp -r $src/DecentSampler.vst3 $out/lib/vst3

          wrapProgram $out/bin/DecentSampler \
            --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath buildInputs}"

          runHook postInstall
        '';
      })
      pkgs.surge
    ];
  };
}
