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

  home.packages = [
    pkgs.fd
    pkgs.lazygit
    pkgs.lua-language-server
    pkgs.nodejs 
    pkgs.nixd
    pkgs.wl-clipboard
  ];

  home.sessionVariables = {
    NVIM_LISTEN_ADDRESS = "127.0.0.1:55432";
  };
}
