{ inputs, config, pkgs, ... }: 

{
  colorScheme = inputs.nix-colors.colorSchemes.catppuccin-macchiato;

  user = {
    name = "anon";
  };

  packages = with pkgs; [
    python3
    rustup
    zig
    obsidian
    renderdoc
    spotify
    reaper
    vesktop
  ];

  monitors = [
    {
      name = "HDMI-A-2";
      position = "0x0";
      workspace = 1;
    }
    {
      name = "DVI-D-1";
      position = "1920x0";
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
