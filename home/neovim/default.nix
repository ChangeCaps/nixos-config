{ inputs, pkgs, ... }: 

{
  xdg.configFile = { 
    "nvim".source = inputs.neovim-config;
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
  ];

  home.sessionVariables = {
    NVIM_LISTEN_ADDRESS = "127.0.0.1:55432";
  };
}
