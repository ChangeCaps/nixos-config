{ inputs, config, pkgs, lib, ... }: 

{
  colorScheme = inputs.nix-colors.colorSchemes.catppuccin-mocha;

  user = {
    name = "anon";
  };

  packages = with pkgs; [
    python3
    rustup
    renderdoc
    spotify
    reaper
    ripgrep
    gdb
    (logseq.override {
      electron = electron_27;
    })
    vesktop
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
      name = "eDP-1";
      position = "0x0";
    }
    {
      name = "HDMI-A-2";
      position = "1920x0";
      workspace = 1;
      scale = 1.5;
    }
  ];

  nh = {
    flake = "~/dotfiles";
  };

  git = {
    userName = "Hjalte Nannestad";
    userEmail = "hjalte.nannestad@gmail.com";
  };
}
