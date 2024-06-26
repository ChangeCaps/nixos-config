{ inputs, config, pkgs, lib, user, ... }:

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
  imports = [
    # Include all the modules.
    ./alacritty
    ./direnv
    ./dunst
    ./fish
    ./git
    ./hyprland
    ./hyprlock
    ./logseq
    ./monitors
    ./neovim
    ./nh
    ./reaper
    ./theme
    ./waybar
    ./wlogout
    ./wofi 
  ];

  options = {
    theme = lib.mkOption {
      type = lib.types.str;
      default = "catppuccin-mocha";
      description = "The theme to use.";
    };

    packages = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = [];
      description = "Packages to be installed for the user.";
    };

    flake = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      example = "~/nixos-config";
      description = "Path to the NixOS configuration.";
    };
  };

  config = {
    # Let Home Manager install and manage itself.
    programs.home-manager.enable = true;

    colorScheme = inputs.nix-colors.colorSchemes.${config.theme};

    home.stateVersion = "23.11"; 

    # We really want to be sure the user name is set.
    home.username = user;
    home.homeDirectory = "/home/${user}";

    home.packages = [
      pkgs.flatpak
      pkgs.killall
      pkgs.htop
      pkgs.python3
      pkgs.rustup
      pkgs.renderdoc
      (fix-electron pkgs.spotify)
      pkgs.ripgrep
      pkgs.gdb
      (fix-electron pkgs.vesktop)
      pkgs.musescore
      pkgs.godot_4
      pkgs.blender
      pkgs.rustup
      pkgs.neovide

      /* c development */
      pkgs.gnumake
      pkgs.bear 
    ] ++ config.packages; 
  }; 
}
