{ pkgs, config, ... }: 

let
  flake = builtins.replaceStrings ["~"] [config.home.homeDirectory] "${config.flake}";
in {
  xdg.configFile = { 
    "nvim".source = config.lib.file.mkOutOfStoreSymlink "${flake}/nixos-config/home/neovim/neovim-config";
  };

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
  };

  home.shellAliases = {
    lg = "lazygit";
  };

  home.packages = [
    pkgs.fd
    pkgs.lazygit
    pkgs.lua-language-server
    pkgs.nodejs 
    pkgs.pyright
    pkgs.nixd
    pkgs.gdb
    pkgs.wl-clipboard
    pkgs.jdt-language-server
    pkgs.typst
    pkgs.tinymist
    pkgs.tree-sitter
    pkgs.python3
    pkgs.python313Packages.pylatexenc
  ];

  home.sessionVariables = {
    NVIM_LISTEN_ADDRESS = "127.0.0.1:55432";
  };
}
