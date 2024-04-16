{ inputs, config, pkgs, ... }:

{
  imports = [
    ./alacritty       
    ./dunst
    ./hyprland
    ./wofi
    ./waybar
    ./wlogout
  ];

  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "anon";
  home.homeDirectory = "/home/anon";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
    # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.11"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    nodejs
    rustup
    zig
    lazygit
    python3
    flatpak
    killall
    obsidian
    renderdoc
    spotify
    pulseaudio
    pavucontrol
    playerctl
    reaper
    vesktop
    htop
    nixd
    wofi
    swww
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';

    ".config/nvim".source = inputs.neovim-config;
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. If you don't want to manage your shell through Home
  # Manager then you have to manually source 'hm-session-vars.sh' located at
  # either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/anon/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    EDITOR = "nvim";
    SUDO_EDITOR = "nvim";

    XDG_DATA_DIRS = "$XDG_DATA_DIRS:/usr/share:/var/lib/flatpak/exports/share:$HOME/.local/share/flatpak/exports/share"; 
  }; 

  gtk = {
    enable = true;

    iconTheme = {
      name = "Yaru-magenta-dark";
      package = pkgs.yaru-theme;
    };

    theme = {
      name = "Catppuccin-Macchiato-Standard-Teal-Dark";
      package = pkgs.catppuccin-gtk.override {
        accents = [ "teal" ];
        size = "standard";
        variant = "macchiato";
      };
    };

    cursorTheme = {
      name = "Bibata-Modern-Classic";
      package = pkgs.bibata-cursors;
    };
  };

  programs.fish = {
    enable = true; 
    shellInit = ''
      direnv hook fish | source
    '';
  };

  programs.git = {
    enable = true;
    package = pkgs.gitFull;
    userName = "Hjalte Nannestad";
    userEmail = "hjalte.nannestad@gmail.com";
    extraConfig = {
      credential.helper = "libsecret";
      init.defaultBranch = "main";
    };
  };

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
  }; 

  programs.direnv = {
    enable = true;
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
