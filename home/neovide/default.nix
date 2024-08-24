{ pkgs, ... }: 

{
  xdg.configFile = {
    "neovide/neovide.toml".text = "";
  };

  home.shellAliases = {
    nv = "neovide & disown";
  };

  home.packages = [
    pkgs.neovide
  ];
}
