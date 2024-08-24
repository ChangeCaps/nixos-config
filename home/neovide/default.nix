{ pkgs, ... }: 

{
  xdg.configFile = {
    "neovide/neovide.toml".text = "";
  };

  home.packages = [
    pkgs.neovide
  ];
}
