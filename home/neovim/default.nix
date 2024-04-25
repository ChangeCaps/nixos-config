{ inputs, config, pkgs, ... }: 

{
  home.file = {
    ".config/nvim".source = inputs.neovim-config;
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
    pkgs.nodejs 
    pkgs.nixd
  ];
}
