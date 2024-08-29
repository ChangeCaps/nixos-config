{ pkgs, ... }: 

{
  xdg.configFile = {
    "neovide/neovide.toml".text = "";
  };

  home.shellAliases = {
    nv = "neovide &";
  };

  home.packages = [
    pkgs.neovide
  ];
}
