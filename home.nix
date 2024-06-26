{ inputs, config, pkgs, lib, ... }: 

 
let
  fix-electron = (package:
    package.overrideAttrs(oldAttrs: {
      nativeBuildInputs = oldAttrs.nativeBuildInputs or [] ++ [ pkgs.makeWrapper ];

      postFixup = (oldAttrs.postFixup or "") + ''
        chmod +x $out/bin/${package.meta.mainProgram}
        wrapProgram $out/bin/${package.meta.mainProgram} --append-flags "--use-angle=opengl"
      '';
    }));
in {
  colorScheme = inputs.nix-colors.colorSchemes.catppuccin-mocha;

  user = {
    name = "anon";
  };

  flake = "~/nixos-config";

  packages = with pkgs; [
    python3
    rustup
    renderdoc
    (fix-electron spotify)
    reaper
    ripgrep
    gdb
    (fix-electron vesktop)
    musescore
    godot_4
    blender
    rustup
    neovide

    /* c development */
    gnumake
    bear

    /* audio */
    vital
    lsp-plugins
    dragonfly-reverb
    geonkick
    tap-plugins
    talentedhack
    sfizz
    helvum
  ];

  home.sessionPath = [
    "$HOME/zls-x86_64-linux"
  ];

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

  monitors = [
    {
      name = "DP-1";
      position = "0x0";
      workspace = 1;
    }
    {
      name = "HDMI-A-2";
      position = "1920x0";
      workspace = 2;
    }
    {
      name = "DVI-D-1";
      position = "3840x0";
      workspace = 3;
    }
  ];

  git = {
    userName = "Hjalte Nannestad";
    userEmail = "hjalte.nannestad@gmail.com";
  };
}
