{ inputs, config, pkgs, lib, username, ... }:

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
    ./direnv
    ./dunst
    ./fish
    ./gdb
    ./git
    ./hjaltes-widgets
    ./hyprland
    ./hyprlock
    ./kitty
    ./lute
    ./monitors
    ./neovide
    ./neovim
    ./nh
    ./nushell
    ./reaper
    ./theme
    ./waybar
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
    home.username = assert username != null; username;
    home.homeDirectory = "/home/${config.home.username}";

    home.shellAliases = {
      rdb = "rust-gdb";
      nuke = "rm -rf";
    };

    home.sessionVariables = {
      QT_QPA_PLATFORM = "wayland";
    };

    home.packages = [
      pkgs.flatpak
      pkgs.killall
      pkgs.htop
      pkgs.python3
      pkgs.rustup
      pkgs.renderdoc
      (fix-electron pkgs.spotify)
      pkgs.ripgrep
      (fix-electron pkgs.vesktop)
      pkgs.musescore
      pkgs.muse-sounds-manager
      pkgs.godot_4
      pkgs.blender
      pkgs.rustup
      pkgs.clang 
      pkgs.gleam
      pkgs.erlang
      pkgs.bat
      pkgs.swww

      (pkgs.callPackage ./rtcqs.nix {})

      /* c development */
      pkgs.gnumake
      pkgs.bear 
    ] ++ config.packages; 
  }; 
}
