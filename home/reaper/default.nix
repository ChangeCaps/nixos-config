{  config, pkgs, lib, ... }:

let 
  cfg = config.reaper;

  
  yabridge = pkgs.yabridge.override { wine = pkgs.wineWowPackages.waylandFull; };
  yabridgectl = pkgs.yabridgectl.override { wine = pkgs.wineWowPackages.waylandFull; };
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

    home.file = {
      ".local/share/yabridge/yabridge-host.exe".source = "${yabridge}/bin/yabridge-host.exe";
      ".local/share/yabridge/yabridge-host.exe.so".source = "${yabridge}/bin/yabridge-host.exe.so";
      ".local/share/yabridge/yabridge-host-32.exe".source = "${yabridge}/bin/yabridge-host-32.exe";
      ".local/share/yabridge/yabridge-host-32.exe.so".source = "${yabridge}/bin/yabridge-host-32.exe.so";
      ".local/share/yabridge/libyabridge-chainloader-vst2.so".source = "${yabridge}/lib/libyabridge-chainloader-vst2.so";
      ".local/share/yabridge/libyabridge-chainloader-vst3.so".source = "${yabridge}/lib/libyabridge-chainloader-vst3.so";
      ".local/share/yabridge/libyabridge-chainloader-clap.so".source = "${yabridge}/lib/libyabridge-chainloader-clap.so";

      ".local/share/yabridge/libyabridge-vst2.so".source = "${yabridge}/lib/libyabridge-vst2.so";
      ".local/share/yabridge/libyabridge-vst3.so".source = "${yabridge}/lib/libyabridge-vst3.so";
      ".local/share/yabridge/libyabridge-clap.so".source = "${yabridge}/lib/libyabridge-clap.so";
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
      pkgs.airwindows
      pkgs.sfizz
      pkgs.helvum
      pkgs.x42-plugins
      pkgs.x42-avldrums
      pkgs.calf
      
      pkgs.carla
      # (pkgs.carla.override {
      #   python3Packages = pkgs.python312.pkgs;
      # })

      pkgs.guitarix
      pkgs.gxplugins-lv2
      yabridge
      yabridgectl
      pkgs.wineWowPackages.waylandFull
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
