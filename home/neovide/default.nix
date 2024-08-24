{ pkgs, ... }: 

{
  xdg.configFile = {
    "neovide/neovide.toml".text = "";
  };

  home.shellAliases = {
    nv = "${pkgs.neovide}/bin/neovide";
  };

  home.packages = [
    pkgs.neovide
  ];
}
